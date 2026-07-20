<?php

namespace App\Http\Controllers\Tenant;

use App\Http\Controllers\Tenant\EmailController;
use Mpdf\Mpdf;
use Mpdf\HTMLParserMode;

use Mpdf\Config\FontVariables;

use Mpdf\Config\ConfigVariables;

use App\Mail\Tenant\DocumentEmail;

use Illuminate\Support\Facades\Mail;

use App\CoreFacturalo\Helpers\Storage\StorageDocument;

use App\Http\Controllers\Controller;

use App\Http\Requests\Tenant\DocumentEmailRequest;


use App\Models\Tenant\Company;
use App\Models\Tenant\Configuration;

use App\Models\Tenant\DocumentosRecibidosSRI;
use App\Models\Tenant\SriDocumentsAditional;
use App\Models\Tenant\SriDocumentsDetails;


use Exception;

use Illuminate\Support\Facades\Storage;

use Modules\Finance\Traits\FinanceTrait;

use Illuminate\Support\Facades\Log;

use Illuminate\Filesystem\FilesystemManager;
use App\CoreFacturalo\Helpers\Xml\XmlFormat;
use Orchestra\Parser\Xml\Facade as XmlParser;
use DOMDocument;

use App\Models\Tenant\CabeceraDocumentoElectronica;
use App\Models\Tenant\DetalleFacturaElectronica;
use App\Models\Tenant\DetalleRetencionElectronica;
use App\CoreFacturalo\SRI\FirmarSri;

use App\CoreFacturalo\WS\Services\AuthSri;
use App\CoreFacturalo\WS\Services\BillSender;
use App\Mail\Tenant\DocumentEmailNotification;
use App\Models\Tenant\Destinatarios;
use App\Models\Tenant\Destinatarios_detalle;
use App\Models\Tenant\LogSRI;
use Illuminate\Support\Facades\Config;
use Swift_Mailer;
use Swift_SmtpTransport;
use App\Services\IntegradorService;
use App\Services\TenantMailerService;
use Error;
use Monolog\Handler\SymfonyMailerHandler;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mailer\Transport;

class SriDocumentController extends Controller
{
    const REGISTERED = '01';
    const SENT = '03';
    const ACCEPTED = '05';
    const NOACCEPTED = '09';
    const OBSERVED = '07';
    const REJECTED = '31';
    const CANCELING = '13';
    const VOIDED = '11';
    const RETURNED = '30';

    use StorageDocument;
    protected $XmlData;
    protected $tipoDoc;
    protected $documento;
    protected $XmlGenerado;
    protected $pathCertificate;
    protected $company;
    protected $isDemo;
    protected $isOse;
    protected $isSRI;
    protected $xmlSigned;
    protected $clave_acceso;
    protected $configuration;
    protected $ambienteLocal;
    protected $doc_type;
    protected $actions;
    protected $type;

    public function __construct()
    {
        $this->configuration = Configuration::first();
        $this->company = Company::active();
        $this->isDemo = ($this->company->soap_type_id === '01') ? true : false;
        $this->ambienteLocal = ($this->company->soap_type_id === '01') ? 1 : 2;
        $this->isOse = ($this->company->soap_send_id === '02') ? true : false;
        $this->isSRI = ($this->company->soap_send_id === '03') ? true : false;
    }

    public function getDocumentFromFTP(String $tipo, String $server, String $usuario, String $contrasena, int $puerto, String $ruta)
    {
        try {
            $fsMgr = new FilesystemManager(app());
            $disk = [
                'driver' => 'ftp',
                'host' => $server,
                'username' => $usuario,
                'password' => $contrasena,
                'root' => '',
                'port' => $puerto,
            ];

            try {
                $ftpDisk = $fsMgr->createFtpDriver($disk);
                //Log::info(json_encode($ftpDisk->directories()));
                $file_path = "/$ruta/";
                $FileList = $ftpDisk->allFiles($file_path);
                //Log::info(json_encode($FileList));
                //Log::info(json_encode($FileList));
                foreach ($FileList as $key => $value) {
                    //Log::info($value);
                    Storage::disk('tenant')->put($tipo . '/' . $value, $ftpDisk->get($value));
                }
            } catch (Exception $ex) {
                Log::critical("Error" . $ex->getMessage());
                return false;
            }
            return true;
        } catch (Exception $e) {

            Log::error('Error al conectar FTP: ' . $e->getMessage());
            return false;
        }
    }

    public function getDocumetsFromLocal(String $tipoTran, String $tipoDoc, String $ruta)
    {

        if ($tipoDoc == 'factura' && $tipoTran == 'emitidos') {

            try {

                $fsMgr = new FilesystemManager(app());
                $disk = [
                    'driver' => 'local',
                    'root' => $ruta,
                ];

                $ftpDisk = $fsMgr->createLocalDriver($disk);
                $FileList = $ftpDisk->files();

                foreach ($FileList as $key => $value) {

                    Storage::disk('tenant')->put('emitidos/' . $tipoDoc . '/' . $value, $ftpDisk->get($value));
                    $contenido = $ftpDisk->get($value);
                    $cabeceraMax = strpos($contenido, '];');
                    $detallesMax = strpos($contenido, 'emailCliente');

                    $cabecera = substr($contenido, 0, $cabeceraMax + 2);
                    $detalles = substr($contenido, $cabeceraMax + 2, $detallesMax - $cabeceraMax - 2) . ';';
                    $final = substr($contenido, $detallesMax);
                    $final = explode(';', $final);

                    $inicioSubCabecera = strpos($cabecera, ';[');
                    $finSubCabecera = strpos($cabecera, 'DOLAR');
                    $subCabecera = substr($cabecera, $inicioSubCabecera + 1, ($finSubCabecera - $inicioSubCabecera + 4));
                    $inicioPagoF = strpos($subCabecera, ';[');
                    $SformasPago = substr($cabecera, $finSubCabecera + 6, -1);
                    $importeTotal = 0;
                    $baseIva12 = 0;
                    $valorIva12 = 0;
                    $baseIva0 = 0;

                    $fPgosArray = explode('][', $SformasPago);
                    $arrayFp = null;

                    foreach ($fPgosArray as $fpagoArray) {
                        $fpagoArray = str_replace('[PAG', '', $fpagoArray);
                        $fpagoArray = str_replace(']', '', $fpagoArray);
                        $arrayFp[] = explode(';', $fpagoArray);
                    }

                    $subCabeceraArray = explode('][', $subCabecera);
                    foreach ($subCabeceraArray as $it) {
                        $it = explode(';', $it);
                        if (isset($it[5]) && isset($it[6])) {
                            $importeTotal = $it[5];
                            $moneda = $it[6];
                        } else {
                            $porcentajeIva = $it[3];
                            if ($porcentajeIva == 12) {
                                $baseIva12 = $it[2];
                                $valorIva12 = $it[4];
                            }
                            if ($porcentajeIva == 0) {
                                $baseIva0 = $it[2];
                            }
                        }
                    }

                    $cabecera = explode(';', $cabecera);
                    $id_comprobante = '';
                    $fecha = explode('/', $cabecera[8]);
                    $fecha2 = $fecha[2] . '-' . $fecha[1] . '-' . $fecha[0];

                    $orden_no = $cabecera[6];
                    $cliente = $cabecera[14];
                    $direccion = str_replace('/\s+/', '', trim($cabecera[9]));
                    $telefono = substr($final[3], strpos($final[3], '=') + 1);
                    $ruc = $cabecera[15];
                    $tipo_comporbante = $cabecera[3];
                    $tipo_identificacion = $cabecera[12];
                    $correo = substr($final[0], strpos($final[0], '=') + 1);
                    $establecimiento = $cabecera[4];
                    $punto_emi = $cabecera[5];
                    $ruc_empresa = $cabecera[2];
                    $ambiente = '2';
                    $razon_social = $cabecera[0];
                    $nombre_comercial = $cabecera[0];
                    $secuencial = $cabecera[6];
                    $direccion_matriz = substr($cabecera[7], 0, 45);
                    $obligado = $cabecera[11];
                    $nota_no = '1';
                    $importeSinImpuestos = $cabecera[16];
                    $descuento = $cabecera[17];

                    $documento = new CabeceraDocumentoElectronica();
                    $documento->idComporbante = 'F' . $orden_no;
                    $documento->fecha = $fecha2;
                    $documento->orderNo = $orden_no;
                    $documento->cliente = $cliente;
                    $documento->direccion = $direccion;
                    $documento->telefono = $telefono;
                    $documento->ruc = $ruc;
                    $documento->tipoComprobante = $tipo_comporbante;
                    $documento->tipoIdentificador = $tipo_identificacion;
                    $documento->correo = $correo;
                    $documento->establecimiento = $establecimiento;
                    $documento->ptoEmision = $punto_emi;
                    $documento->rucEmpresa = $ruc_empresa;
                    $documento->secuencial = $secuencial;
                    $documento->ambiente = $ambiente;
                    $documento->razonSocial = $razon_social;
                    $documento->nombreComercial = $nombre_comercial;
                    $documento->direccionMatriz = $direccion_matriz;
                    $documento->obligadoContabilidad = $obligado;
                    $documento->notaNo = $nota_no;
                    $documento->nombreDoc = $value;
                    $documento->importeSinImpuestos = $importeSinImpuestos;
                    $documento->descuento = $descuento;
                    $documento->importeTotal = $importeTotal;
                    $documento->baseIva12 = $baseIva12;
                    $documento->valorIva12 = $valorIva12;
                    $documento->baseIva0 = $baseIva0;
                    $documento->fPagos = json_encode($arrayFp);
                    $documento->save();

                    if ($documento->id) {
                        $detallesArray = explode('];', $detalles);
                        foreach ($detallesArray as $det) {
                            $det = str_replace('][', ';', $det);
                            $det = str_replace('[', '', $det);
                            $linea = explode(';', $det);
                            if (isset($linea[3])) {
                                $cantidad = $linea[3];
                                $item = $linea[2];
                                $precio_u = $linea[4];
                                $total = $linea[6];
                                $iva =  intval($linea[12]);
                                $ice = 0;
                                $irbpnr = 0;
                                $codigo_ice = 3;
                                $codigoPorcentaje_ice = 0.00;
                                $baseImponible_ice = 0.00;
                                $tarifa_ice = 0.00;
                                $valor_ice = 0;
                                $codigo_irbpnr = 5;
                                $codigoPorcentaje_irbpnr = 0;
                                $tarifa_irbpnr = 0;
                                $baseImponible_irbpnr = 0;
                                $valor_irbpnr = 0;

                                $detalle = new DetalleFacturaElectronica();

                                $detalle->idComporbante = 'F' . $orden_no;
                                $detalle->cantidad = $cantidad;
                                $detalle->item = $item;
                                $detalle->precioUnitario = $precio_u;
                                $detalle->total = $total;
                                $detalle->iva = $iva;
                                $detalle->ice = $ice;
                                $detalle->irbpnr = $irbpnr;
                                $detalle->codigoIce = $codigo_ice;
                                $detalle->codigoPorcentajeIce = $codigoPorcentaje_ice;
                                $detalle->baseImponibleIce = $baseImponible_ice;
                                $detalle->tarifaIce = $tarifa_ice;
                                $detalle->valorIce = $valor_ice;
                                $detalle->codigoIrbpnr = $codigo_irbpnr;
                                $detalle->codigoPorcentajeIrbpnr = $codigoPorcentaje_irbpnr;
                                $detalle->baseImponibleIrbpnr = $baseImponible_irbpnr;
                                $detalle->tarifaIrbpnr = $tarifa_irbpnr;
                                $detalle->valorIrbpnr = $valor_irbpnr;
                                $detalle->save();
                            }
                        }
                    }
                }

                return true;
            } catch (Exception $e) {

                Log::error("Se produjo un error al tratar de recuperar archivo ruta local:" . $e->getMessage());
                return false;
            }
        }
    }

    public function cargarDatosBD(String $tipo, String $ruta)
    {

        try {

            if ($tipo == 'recibidos') {
                $listaDocumentos = Storage::disk('tenant')->files($tipo . DIRECTORY_SEPARATOR . $ruta);
                if (count($listaDocumentos) > 0) {
                    foreach ($listaDocumentos as $rutaDoc) {
                        //Log::notice("Archivo: $rutaDoc");

                        $this->XmlData = '';
                        $this->readXML($rutaDoc);

                        //$XmlDataConvert = XmlFormat::format($this->XmlData);
                        $xml = XmlParser::extract($this->XmlData);
                        $documento = $xml->parse([
                            'estado' => ['uses' => 'estado'],
                            'numeroAutorizacion' => ['uses' => 'numeroAutorizacion'],
                            'ambiente' => ['uses' => 'ambiente'],
                            'fechaAutorizacion' => ['uses' => 'fechaAutorizacion'],
                            'comprobante' => ['uses' => 'comprobante'],
                        ]);
                        $documentoJSON = simplexml_load_string($documento['comprobante']);

                        $validarDoc = DocumentosRecibidosSRI::where('codDoc', $documentoJSON->infoTributaria->codDoc)
                            ->where('secuencial', $documentoJSON->infoTributaria->secuencial)
                            ->first();
                        if ($validarDoc) {
                            //Log::info("Documento ya se encuentra en la base de datos:" . $documentoJSON->infoTributaria->secuencial . "de tipo:" . $documentoJSON->infoTributaria->codDoc);
                        } else {
                            if ($documentoJSON->infoTributaria->codDoc == '01') {
                                //$infoTrubutariaXML = XmlParser::extract($documento['comprobante']);
                                $xml = new DOMDocument();
                                $xml->loadXML($documento['comprobante']);
                                $xml->formatOutput = false;
                                $xml->preserveWhiteSpace = false;
                                $x = $xml->documentElement;

                                //RECUPERAMOS NOMBRE DEL ATRIBUTO Y VALOR DE LOS CAMPOS ADICIONALES//
                                foreach ($x->childNodes as $item) {
                                    if ($item->nodeName == 'infoAdicional') {
                                        foreach ($item->childNodes as $attr) {
                                            if ($attr->hasAttributes()) {
                                                foreach ($attr->attributes as $nodeAtt) {
                                                    ////Log::info($nodeAtt->nodeValue." = ".$attr->nodeValue);
                                                    $infoAdicional[$nodeAtt->nodeValue] = $attr->nodeValue;
                                                }
                                            }
                                        }
                                    }
                                }

                                $documentoCabecera = new DocumentosRecibidosSRI();

                                $documentoCabecera->ambiente = $documentoJSON->infoTributaria->ambiente;
                                $documentoCabecera->tipoEmision = $documentoJSON->infoTributaria->tipoEmision;
                                $documentoCabecera->razonSocial = $documentoJSON->infoTributaria->razonSocial;
                                $documentoCabecera->nombreComercial = $documentoJSON->infoTributaria->nombreComercial;
                                $documentoCabecera->ruc = $documentoJSON->infoTributaria->ruc;
                                $documentoCabecera->claveAcceso = $documentoJSON->infoTributaria->claveAcceso;
                                $documentoCabecera->codDoc = $documentoJSON->infoTributaria->codDoc;
                                $documentoCabecera->estab = $documentoJSON->infoTributaria->estab;
                                $documentoCabecera->ptoEmi = $documentoJSON->infoTributaria->ptoEmi;
                                $documentoCabecera->secuencial = $documentoJSON->infoTributaria->secuencial;
                                $documentoCabecera->dirMatriz = $documentoJSON->infoTributaria->dirMatriz;
                                if (isset($documentoJSON->infoTributaria->contribuyenteRimpe)) {
                                    $documentoCabecera->contribuyenteRimpe = $documentoJSON->infoTributaria->contribuyenteRimpe;
                                }

                                if (isset($documentoJSON->infoTributaria->agenteRetencion)) {
                                    $documentoCabecera->agenteRetencion = $documentoJSON->infoTributaria->agenteRetencion;
                                }

                                $documentoCabecera->fechaEmision = $documentoJSON->infoFactura->fechaEmision;
                                $documentoCabecera->dirEstablecimiento = $documentoJSON->infoFactura->dirEstablecimiento;
                                $documentoCabecera->obligadoContabilidad = $documentoJSON->infoFactura->obligadoContabilidad;
                                $documentoCabecera->tipoIdentificacionComprador = $documentoJSON->infoFactura->tipoIdentificacionComprador;
                                $documentoCabecera->razonSocialComprador = $documentoJSON->infoFactura->razonSocialComprador;
                                $documentoCabecera->identificacionComprador = $documentoJSON->infoFactura->identificacionComprador;
                                $documentoCabecera->totalSinImpuestos = $documentoJSON->infoFactura->totalSinImpuestos;
                                $documentoCabecera->totalDescuento = $documentoJSON->infoFactura->totalDescuento;
                                $documentoCabecera->totalConImpuestos = json_encode($documentoJSON->infoFactura->totalConImpuestos);
                                if (isset($documentoJSON->infoFactura->propina)) {
                                    $documentoCabecera->propina = $documentoJSON->infoFactura->propina;
                                } else {
                                    $documentoCabecera->propina = 0.00;
                                }

                                $documentoCabecera->importeTotal = $documentoJSON->infoFactura->importeTotal;
                                $documentoCabecera->moneda = $documentoJSON->infoFactura->moneda;
                                $documentoCabecera->pagos = json_encode($documentoJSON->infoFactura->pagos);
                                $documentoCabecera->direccionComprador = $documentoJSON->infoFactura->direccionComprador;

                                $documentoCabecera->save();
                                $intCount = count($documentoJSON->detalles->detalle);
                                ////Log::info($intCount);
                                ////Log::info(json_encode($documentoJSON->detalles->detalle));
                                foreach ($documentoJSON->detalles->detalle as $detalle) {
                                    ////Log::info($detalle->codigoPrincipal);

                                    $detallesDoc = new SriDocumentsDetails();
                                    $detallesDoc->document_id = $documentoCabecera->id;
                                    $detallesDoc->codigoPrincipal = $detalle->codigoPrincipal;
                                    $detallesDoc->descripcion = $detalle->descripcion;
                                    $detallesDoc->cantidad = $detalle->cantidad;
                                    $detallesDoc->precioUnitario = $detalle->precioUnitario;
                                    $detallesDoc->descuento = $detalle->descuento;
                                    $detallesDoc->precioTotalSinImpuesto = $detalle->precioTotalSinImpuesto;
                                    $detallesDoc->impuestos = json_encode($detalle->impuestos);
                                    $detallesDoc->save();
                                }
                                if (isset($documentoJSON->infoAdicional)) {
                                    foreach ($infoAdicional as $key => $value) {
                                        $adicionales = new SriDocumentsAditional();
                                        $adicionales->document_id = $documentoCabecera->id;
                                        $adicionales->nombre = $key;
                                        $adicionales->valor = $value;
                                        $adicionales->save();
                                    }
                                }
                            }
                        }
                    }

                    return true;
                } else {
                    return false;
                    //Log::error("No se encontearon docuemntos en la ruta: " . $tipo . DIRECTORY_SEPARATOR . $ruta);
                }
            } elseif ($tipo == 'emitidos') {
                //Log::info("Inicio Proceso de " . $ruta);
                $FileList = Storage::disk('tenant')->files($tipo . DIRECTORY_SEPARATOR . $ruta);

                if (str_contains($ruta, 'Facturas') || str_contains($ruta, 'Factura') || str_contains($ruta, 'factura') || str_contains($ruta, 'facturas')) {

                    foreach ($FileList as $key => $value) {
                        ////Log::info("Inicio Proceso factura ". $value);
                        $contenido = Storage::disk('tenant')->get($value);
                        $cabeceraMax = strpos($contenido, '];');
                        $detallesMax = strpos($contenido, 'emailCliente');

                        $cabecera = substr($contenido, 0, $cabeceraMax + 2);
                        $detalles = substr($contenido, $cabeceraMax + 2, $detallesMax - $cabeceraMax - 2) . ';';
                        $final = substr($contenido, $detallesMax);
                        $finalcompleto = $final;
                        $final = explode(';', $final);

                        $inicioSubCabecera = strpos($cabecera, ';[');
                        $finSubCabecera = strpos($cabecera, 'DOLAR');
                        $subCabecera = substr($cabecera, $inicioSubCabecera + 1, ($finSubCabecera - $inicioSubCabecera + 4));
                        $inicioPagoF = strpos($subCabecera, ';[');
                        $SformasPago = substr($cabecera, $finSubCabecera + 6, -1);
                        $importeTotal = 0;
                        $baseIva12 = 0;
                        $valorIva12 = 0;
                        $baseIva0 = 0;

                        $fPgosArray = explode('][', $SformasPago);
                        $arrayFp = null;

                        foreach ($fPgosArray as $fpagoArray) {
                            $fpagoArray = str_replace('[PAG', '', $fpagoArray);
                            $fpagoArray = str_replace(']', '', $fpagoArray);
                            $arrayFp[] = explode(';', $fpagoArray);
                        }

                        $subCabeceraArray = explode('][', $subCabecera);
                        foreach ($subCabeceraArray as $it) {
                            $it = explode(';', $it);
                            if (isset($it[5]) && isset($it[6])) {
                                $importeTotal = $it[5];
                                $moneda = $it[6];
                            } else {
                                $porcentajeIva = $it[3];
                                if ($porcentajeIva == 12) {
                                    $baseIva12 = $it[2];
                                    $valorIva12 = $it[4];
                                }
                                if ($porcentajeIva == 0) {
                                    $baseIva0 = $it[2];
                                }
                            }
                        }

                        $cabecera = explode(';', $cabecera);
                        $id_comprobante = '';
                        $fecha = explode('/', $cabecera[8]);
                        $fecha2 = $fecha[2] . '-' . $fecha[1] . '-' . $fecha[0];
                        $telefono = '';
                        $correo = '';

                        foreach ($final as $datosFinal) {
                            if (str_contains($datosFinal, 'emailCliente')) {
                                $correo = substr($datosFinal, strpos($datosFinal, '=') + 1);
                            }
                            if (str_contains($datosFinal, 'telefono')) {
                                $telefono = substr($datosFinal, strpos($datosFinal, '=') + 1);
                            }
                        }

                        $orden_no = $cabecera[6];
                        $cliente = $cabecera[14];

                        $direccion = str_replace('/\s+/', '', trim($cabecera[9]));
                        $ruc = $cabecera[15];
                        $tipo_comporbante = $cabecera[3];
                        $tipo_identificacion = $cabecera[12];
                        $establecimiento = $cabecera[4];
                        $punto_emi = $cabecera[5];
                        $ruc_empresa = $cabecera[2];
                        $ambiente = $this->ambienteLocal;
                        $razon_social = $cabecera[0];
                        $nombre_comercial = $cabecera[0];
                        $secuencial = $cabecera[6];
                        $direccion_matriz = substr($cabecera[7], 0, 45);
                        $obligado = $cabecera[11];
                        $nota_no = '1';
                        $importeSinImpuestos = $cabecera[16];
                        $descuento = $cabecera[17];
                        $validar = CabeceraDocumentoElectronica::where('idComporbante', 'F' . $establecimiento . $punto_emi . $orden_no)->get();
                        if (count($validar) > 0) {
                            ////Log::info("DCUMENTO YA PROCESADO: ".'N'.$establecimiento.$punto_emi.$orden_no);
                            ////Log::info("DATA: ".json_encode($validar));

                        } else {

                            $documento = new CabeceraDocumentoElectronica();
                            $documento->idComporbante = 'F' . $establecimiento . $punto_emi . $orden_no;
                            $documento->fecha = $fecha2;
                            $documento->orderNo = $orden_no;
                            $documento->cliente = $cliente;
                            $documento->direccion = $direccion;
                            $documento->telefono = $telefono;
                            $documento->ruc = $ruc;
                            $documento->tipoComprobante = $tipo_comporbante;
                            $documento->tipoIdentificador = $tipo_identificacion;
                            $documento->correo = $correo;
                            $documento->establecimiento = $establecimiento;
                            $documento->ptoEmision = $punto_emi;
                            $documento->rucEmpresa = $ruc_empresa;
                            $documento->secuencial = $secuencial;
                            $documento->ambiente = $ambiente;
                            $documento->razonSocial = $razon_social;
                            $documento->nombreComercial = $nombre_comercial;
                            $documento->direccionMatriz = $direccion_matriz;
                            $documento->obligadoContabilidad = $obligado;
                            $documento->notaNo = $nota_no;
                            $documento->nombreDoc = $value;
                            $documento->importeSinImpuestos = $importeSinImpuestos;
                            $documento->descuento = $descuento;
                            $documento->importeTotal = $importeTotal;
                            $documento->baseIva12 = $baseIva12;
                            $documento->valorIva12 = $valorIva12;
                            $documento->baseIva0 = $baseIva0;
                            $documento->fPagos = json_encode($arrayFp);
                            $documento->adicionales = $finalcompleto;
                            $documento->save();

                            if ($documento->id) {
                                $detallesArray = explode('];', $detalles);
                                foreach ($detallesArray as $det) {
                                    $det = str_replace('][', ';', $det);
                                    $det = str_replace('[', '', $det);
                                    $linea = explode(';', $det);
                                    if (isset($linea[3])) {
                                        $cantidad = $linea[3];
                                        $item = $linea[2];
                                        $precio_u = $linea[4];
                                        $total = $linea[6];
                                        $iva =  intval($linea[12]);
                                        $ice = 0;
                                        $irbpnr = 0;
                                        $codigo_ice = 3;
                                        $codigoPorcentaje_ice = 0.00;
                                        $baseImponible_ice = 0.00;
                                        $tarifa_ice = 0.00;
                                        $valor_ice = 0;
                                        $codigo_irbpnr = 5;
                                        $codigoPorcentaje_irbpnr = 0;
                                        $tarifa_irbpnr = 0;
                                        $baseImponible_irbpnr = 0;
                                        $valor_irbpnr = 0;

                                        $detalle = new DetalleFacturaElectronica();

                                        $detalle->idComporbante = 'F' . $establecimiento . $punto_emi . $orden_no;
                                        $detalle->cantidad = $cantidad;
                                        $detalle->item = $item;
                                        $detalle->precioUnitario = $precio_u;
                                        $detalle->total = $total;
                                        $detalle->iva = $iva;
                                        $detalle->ice = $ice;
                                        $detalle->irbpnr = $irbpnr;
                                        $detalle->codigoIce = $codigo_ice;
                                        $detalle->codigoPorcentajeIce = $codigoPorcentaje_ice;
                                        $detalle->baseImponibleIce = $baseImponible_ice;
                                        $detalle->tarifaIce = $tarifa_ice;
                                        $detalle->valorIce = $valor_ice;
                                        $detalle->codigoIrbpnr = $codigo_irbpnr;
                                        $detalle->codigoPorcentajeIrbpnr = $codigoPorcentaje_irbpnr;
                                        $detalle->baseImponibleIrbpnr = $baseImponible_irbpnr;
                                        $detalle->tarifaIrbpnr = $tarifa_irbpnr;
                                        $detalle->valorIrbpnr = $valor_irbpnr;
                                        $detalle->save();
                                    }
                                }
                            }
                        }
                    }
                }
                if (str_contains($ruta, 'Retencion') || str_contains($ruta, 'retencion') || str_contains($ruta, 'retenciones') || str_contains($ruta, 'Retenciones')) {
                    foreach ($FileList as $key => $value) {
                        Log::info("Creando retencion en base de datos");
                        $retencion = Storage::disk('tenant')->get($value);
                        $cabeceraMax = strpos($retencion, 'DTR');
                        $detallesMax = strpos($retencion, 'emailCliente');
                        $cabecera = substr($retencion, 0, $cabeceraMax + 6);
                        $detalles = substr($retencion, $cabeceraMax + 8, $detallesMax - $cabeceraMax - 9);
                        $final = substr($retencion, $detallesMax);
                        $base12 = 0;
                        $valor12 = 0;
                        $base0 = 0;

                        $inicioImpuestos = strpos($cabecera, '][DS');
                        $FinImpuestos = strpos($cabecera, '][TR');

                        $Impuestos = substr($cabecera, $inicioImpuestos + 1, ($FinImpuestos - $inicioImpuestos));
                        $FinImpuestosArray = explode('][', $Impuestos);

                        foreach ($FinImpuestosArray as $finArray) {
                            $finArray = str_replace('[', '', $finArray);
                            $finArray = str_replace(']', '', $finArray);
                            $finArrayExplode = explode(';', $finArray);
                            if ($finArrayExplode[3] == 12) {
                                $base12 = $finArrayExplode[2];
                                $valor12 = $finArrayExplode[4];
                            } else {
                                $base0 = $finArrayExplode[2];
                            }
                        }

                        $cabecera = str_replace('][', ';', $cabecera);
                        $cabecera = str_replace(';[', ';', $cabecera);
                        $cabecera = str_replace('[', ';', $cabecera);
                        $cabecera = explode(';', $cabecera);

                        $CamposAdicionales = $final;
                        $final = explode(';', $final);

                        $telefono = '';
                        $correo = '';
                        $direccion = '';

                        foreach ($final as $datosFinal) {

                            if (str_contains($datosFinal, 'emailCliente')) {
                                $correo = substr($datosFinal, strpos($datosFinal, '=') + 1);
                            }
                            if (str_contains($datosFinal, 'telefono')) {
                                $telefono = substr($datosFinal, strpos($datosFinal, '=') + 1);
                            }
                            if (str_contains($datosFinal, 'direccion')) {
                                $direccion = substr($datosFinal, strpos($datosFinal, '=') + 1);
                                $direccion = str_replace('/\s+/', '', trim($direccion));
                            }
                        }


                        $tipo_comprobante = $cabecera[3];
                        $fecha = explode('/', $cabecera[8]);
                        $fecha2 = $fecha[2] . '-' . $fecha[1] . '-' . $fecha[0];
                        $fecha_fizcal = $cabecera[15];
                        $retencion_no = $cabecera[6];
                        $cliente = $cabecera[13];
                        $ruc = $cabecera[14];
                        $tipo_identificacion = $cabecera[12];
                        $establecimiento = $cabecera[4];
                        $punto_emi = $cabecera[5];
                        $secuencial = $cabecera[6];
                        $ruc_empresa = $cabecera[2];
                        $ambiente = $this->ambienteLocal;
                        $razon_social =  $cabecera[0];
                        $nombre_comercial  =  $cabecera[0];
                        $direccion_matriz =  substr($cabecera[7], 0, 45);
                        $obligado = $cabecera[11];
                        $nota_no = 1;
                        $numero_ce = $cabecera[10];
                        if ($numero_ce == '') {
                            $numero_ce = 0;
                        }

                        $codSustento = $cabecera[16];
                        $parteRel = strtoupper($cabecera[17]);
                        $codDocSustento = $cabecera[18];
                        $numAutorizaSustento = $cabecera[20];
                        $pagoLocExt = $cabecera[21];
                        $fPago = substr($cabecera[29], 2);
                        $fPagoValor = $cabecera[30];
                        if ($codSustento == '') {
                            $codSustento = '01';
                        }

                        $validar = CabeceraDocumentoElectronica::where('idComporbante', 'R' . $establecimiento . $punto_emi . $retencion_no)->get();
                        if (count($validar) > 0) {
                            Log::info("DOCUMENTO YA PROCESADO: " . 'R' . $establecimiento . $punto_emi . $retencion_no);
                            Log::info("DATA: " . json_encode($validar));
                        } else {

                            $documento = new CabeceraDocumentoElectronica();
                            $documento->idComporbante = 'R' . $establecimiento . $punto_emi . $retencion_no;
                            $documento->fecha = $fecha2;
                            $documento->fechaFizcal = $fecha_fizcal;
                            $documento->orderNo = $retencion_no;
                            $documento->cliente = $cliente;
                            $documento->direccion = $direccion;
                            $documento->telefono = $telefono;
                            $documento->ruc = $ruc;
                            $documento->tipoComprobante = $tipo_comprobante;
                            $documento->tipoIdentificador = $tipo_identificacion;
                            $documento->correo = $correo;
                            $documento->establecimiento = $establecimiento;
                            $documento->ptoEmision = $punto_emi;
                            $documento->rucEmpresa = $ruc_empresa;
                            $documento->secuencial = $secuencial;
                            $documento->ambiente = $ambiente;
                            $documento->razonSocial = $razon_social;
                            $documento->nombreComercial = $nombre_comercial;
                            $documento->direccionMatriz = $direccion_matriz;
                            $documento->obligadoContabilidad = $obligado;
                            $documento->notaNo = $nota_no;
                            $documento->numeroCE = $numero_ce;
                            $documento->codSustento = $codSustento;
                            $documento->codDocSustento = $codDocSustento;
                            $documento->parteRel = $parteRel;
                            $documento->numAuthSustento = $numAutorizaSustento;
                            $documento->fPago = $fPago;
                            $documento->pagoLocExt = $pagoLocExt;
                            $documento->nombreDoc = $value;
                            $documento->adicionales = $CamposAdicionales;
                            $documento->importeSinImpuestos = $base12 + $base0;
                            //$documento->descuento = $descuento;
                            $documento->importeTotal = $base12 + $base0 + $valor12;
                            $documento->baseIva12 = $base12;
                            $documento->valorIva12 = $valor12;
                            $documento->baseIva0 = $base0;
                            //$documento->fPagos = json_encode($arrayFp);
                            $documento->save();
                            Log::info("Creando retencion, CABECERA CREADA: " . json_encode($documento));
                            if ($documento->id) {
                                $detallesArray = explode(']', $detalles);
                                $tipo_doc_afectado = '';
                                $valorRetenidoT = 0;
                                foreach ($detallesArray as $lin) {
                                    $lin = str_replace(']', '', $lin);
                                    $lin = str_replace('[', '', $lin);
                                    $linea = explode(';', $lin);
                                    if (isset($linea[1])) {
                                        $valorRetenidoT += $linea[4];
                                        $codigo_ret = $linea[1];
                                        $base_ret = $linea[2];
                                        $porcentaje_ret = $linea[3];
                                        $valor_ret = $linea[4];
                                        $tipo_doc_afectado = $linea[5];
                                        $serie_doc_afectado = $linea[6];
                                        $fecha_doc_afectado = $linea[7];

                                        $retencionDoc = new DetalleRetencionElectronica();
                                        $retencionDoc->idComporbante = 'R' . $establecimiento . $punto_emi . $retencion_no;
                                        $retencionDoc->codigoRet = $codigo_ret;
                                        $retencionDoc->baseRet = $base_ret;
                                        $retencionDoc->porcentajeRet = $porcentaje_ret;
                                        $retencionDoc->valorRet = $valor_ret;
                                        $retencionDoc->tipoDocAfectado = $tipo_doc_afectado;
                                        $retencionDoc->serieDocAfectado = $serie_doc_afectado;
                                        $retencionDoc->fechaDocAfectado = $fecha_doc_afectado;
                                        $retencionDoc->save();
                                        Log::info("Creando detalle de retención, DETALLE CREADO: " . json_encode($retencionDoc));
                                    }
                                }
                                $documento->update([
                                    'codDocSustento' => $tipo_doc_afectado,
                                    'importeTotal' => $valorRetenidoT,
                                ]);
                            }
                        }
                    }
                }
                if (str_contains($ruta, 'Notas') || str_contains($ruta, 'Nota') || str_contains($ruta, 'nota') || str_contains($ruta, 'notas')) {
                    foreach ($FileList as $key => $value) {
                        try {
                            $conenido = Storage::disk('tenant')->get($value);
                            $cabeceraMax = strpos($conenido, '][DET');
                            $detallesMax = strpos($conenido, 'emailCliente');

                            $cabecera = substr($conenido, 0, $cabeceraMax);
                            $detalles = substr($conenido, $cabeceraMax + 1, $detallesMax - $cabeceraMax - 1) . ';';
                            $final = substr($conenido, $detallesMax);

                            $cabecera = str_replace('][', ';', $cabecera);

                            $cabecera = explode(';', $cabecera);
                            $camposAdicionales = $final;
                            $final = explode(';', $final);

                            $telefono = '';
                            $correo = '';

                            foreach ($final as $datosFinal) {
                                if (str_contains($datosFinal, 'emailCliente')) {
                                    $correo = substr($datosFinal, strpos($datosFinal, '=') + 1);
                                }
                                if (str_contains($datosFinal, 'telefono')) {
                                    $telefono = substr($datosFinal, strpos($datosFinal, '=') + 1);
                                }
                            }
                            $id_comprobante = '';
                            $fecha = explode('/', $cabecera[8]);
                            $fecha2 = $fecha[2] . '-' . $fecha[1] . '-' . $fecha[0];

                            $orden_no = $cabecera[6];
                            $cliente = $cabecera[11];
                            $direccion = str_replace('/\s+/', '', trim($cabecera[7]));
                            $ruc = $cabecera[12];
                            $tipo_comporbante = $cabecera[3];
                            $tipo_identificacion = $cabecera[10];
                            $establecimiento = $cabecera[4];
                            $punto_emi = $cabecera[5];
                            $ruc_empresa = $cabecera[2];
                            $ambiente = $this->ambienteLocal;
                            $razon_social = $cabecera[0];
                            $nombre_comercial = $cabecera[0];
                            $secuencial = $cabecera[6];
                            $numCE = $cabecera[13];
                            $obligado = $cabecera[14];
                            $nota_no = $cabecera[6];
                            $tipoDocAfectado = $cabecera[16];
                            $secuencialDocAfectado = $cabecera[17];
                            $motivoDev = $cabecera[30];
                            $fechaDocSustento = $cabecera[18];
                            $direccion_matriz = trim(substr($final[4], strpos($final[0], '=') + 1));

                            $validar = CabeceraDocumentoElectronica::where('idComporbante', 'N' . $establecimiento . $punto_emi . $orden_no)->get();
                            if (count($validar) > 0) {
                                ////Log::info("DCUMENTO YA PROCESADO: ".'N'.$establecimiento.$punto_emi.$orden_no);
                                ////Log::info("DATA: ".json_encode($validar));

                            } else {

                                $documento = new CabeceraDocumentoElectronica();
                                $documento->idComporbante = 'N' . $establecimiento . $punto_emi . $orden_no;
                                $documento->fecha = $fecha2;
                                $documento->orderNo = $orden_no;
                                $documento->cliente = $cliente;
                                $documento->direccion = $direccion;
                                $documento->telefono = $telefono;
                                $documento->ruc = $ruc;
                                $documento->tipoComprobante = $tipo_comporbante;
                                $documento->tipoIdentificador = $tipo_identificacion;
                                $documento->correo = $correo;
                                $documento->establecimiento = $establecimiento;
                                $documento->ptoEmision = $punto_emi;
                                $documento->rucEmpresa = $ruc_empresa;
                                $documento->secuencial = $secuencial;
                                $documento->ambiente = $ambiente;
                                $documento->razonSocial = $razon_social;
                                $documento->nombreComercial = $nombre_comercial;
                                $documento->direccionMatriz = $direccion_matriz;
                                $documento->obligadoContabilidad = $obligado;
                                $documento->notaNo = $nota_no;
                                $documento->numeroCE = $numCE;
                                $documento->tipoDocAfectado = $tipoDocAfectado;
                                $documento->secuencialDocAfectado = $secuencialDocAfectado;
                                $documento->motivoDev = $motivoDev;
                                $documento->fechaDocSustento = $fechaDocSustento;
                                $documento->nombreDoc = $value;
                                $documento->adicionales = $camposAdicionales;

                                $base12 = 0;
                                $base0 = 0;
                                $valor12 = 0;
                                if ($documento->save()) {
                                    $detallesArray = explode('];', $detalles);
                                    $totalImporte = 0;
                                    foreach ($detallesArray as $det) {
                                        $det = str_replace('][', ';', $det);
                                        $det = str_replace('[', '', $det);
                                        $linea = explode(';', $det);
                                        if (isset($linea[3])) {

                                            if (intval($linea[17]) == 12) {
                                                $base12 += $linea[6];
                                                $valor12 += ($linea[6] * 0.12);
                                            } else {
                                                $base0 += $linea[6];
                                            }

                                            $totalImporte += $linea[6];
                                            $cantidad = $linea[3];
                                            $item = $linea[2];
                                            $precio_u = $linea[4];
                                            $total = $linea[6];
                                            $iva =  intval($linea[17]);
                                            $ice = 0;
                                            $irbpnr = 0;
                                            $codigo_ice = 3;
                                            $codigoPorcentaje_ice = 0.00;
                                            $baseImponible_ice = 0.00;
                                            $tarifa_ice = 0.00;
                                            $valor_ice = 0;
                                            $codigo_irbpnr = 5;
                                            $codigoPorcentaje_irbpnr = 0;
                                            $tarifa_irbpnr = 0;
                                            $baseImponible_irbpnr = 0;
                                            $valor_irbpnr = 0;

                                            $detalle = new DetalleFacturaElectronica();

                                            $detalle->idComporbante = 'N' . $establecimiento . $punto_emi . $orden_no;
                                            $detalle->cantidad = $cantidad;
                                            $detalle->item = $item;
                                            $detalle->precioUnitario = $precio_u;
                                            $detalle->total = $total;
                                            $detalle->iva = $iva;
                                            $detalle->ice = $ice;
                                            $detalle->irbpnr = $irbpnr;
                                            $detalle->codigoIce = $codigo_ice;
                                            $detalle->codigoPorcentajeIce = $codigoPorcentaje_ice;
                                            $detalle->baseImponibleIce = $baseImponible_ice;
                                            $detalle->tarifaIce = $tarifa_ice;
                                            $detalle->valorIce = $valor_ice;
                                            $detalle->codigoIrbpnr = $codigo_irbpnr;
                                            $detalle->codigoPorcentajeIrbpnr = $codigoPorcentaje_irbpnr;
                                            $detalle->baseImponibleIrbpnr = $baseImponible_irbpnr;
                                            $detalle->tarifaIrbpnr = $tarifa_irbpnr;
                                            $detalle->valorIrbpnr = $valor_irbpnr;
                                            $detalle->save();
                                        }
                                    }
                                }

                                $documento->update([
                                    'importeTotal' => $totalImporte,
                                    'baseIva12' => $base12,
                                    'valorIva12' => round($valor12 * 0.12, 2),
                                    'baseIva0' => $base0,
                                ]);
                            }
                        } catch (\Illuminate\Database\QueryException $ex) {
                            Log::critical("Error Al guardar DATA" . $ex->getMessage());
                        }
                    }
                }
            }

            return true;
        } catch (Exception $ex) {

            Log::error("Error al procesar documentos " . $ex->getMessage());
            return false;
        } catch (\PDOException $ex) {

            Log::error("Error al procesar documentos " . $ex->getMessage());
            return false;
        }
    }

    private function readXML(String $ruta)
    {

        try {
            $xml = Storage::disk('tenant')->get($ruta);
            $this->XmlData = $xml;
            return true;
        } catch (Exception $e) {
            //Log::error("Error a leer XML: $ruta , Error: $e->getMessage()");
            return false;
        }
    }

    public function setDocumento(int $id)
    {
        $this->documento = CabeceraDocumentoElectronica::find($id);
    }

    public function createXML(int $id)
    {

        try {
            $documento = CabeceraDocumentoElectronica::find($id);

            if ($documento) {

                //FACTURAS
                if ($documento->tipoComprobante == 1) {

                    $xml_detalles = '';
                    $impuestos = array(
                        ['base' => 0, 'IVA' => 0, 'valor' => 0, 'code' => 0],
                        ['base' => 0, 'IVA' => 5, 'valor' => 0, 'code' => 5],
                        ['base' => 0, 'IVA' => 12, 'valor' => 0, 'code' => 2],
                        ['base' => 0, 'IVA' => 14, 'valor' => 0, 'code' => 3],
                        ['base' => 0, 'IVA' => 15, 'valor' => 0, 'code' => 4],
                        ['base' => 0, 'IVA' => 8, 'valor' => 0, 'code' => 8]
                    );

                    $total_iva_12 = $documento->valorIva12;
                    $base_imponible_12 = $documento->baseIva12;
                    $base_imponible_0 = $documento->baseIva0;

                    $base_imponible_ice = 0;
                    $base_imponible_irbpnr = 0;
                    $valor_ice = 0;
                    $valor_irbpnr = 0;
                    $sub_total = 0;
                    $impuesto_ice = false;
                    $impuesto_irbpnr = false;
                    $impuesto_cabecera_ice = '';
                    $impuesto_cabecera_irbpnr = '';
                    $array_cod_ice = array();
                    $array_ice = array();
                    $camposAdicionales = $documento->adicionales;
                    
                    if($this->company->detraction_account){
                        $camposAdicionales = "Adicional="+$this->company->detraction_account+";"+ $camposAdicionales;                   
                    }
                    
                    $items = DetalleFacturaElectronica::where('idComporbante', $documento->idComporbante)->get();
                    
                    //ESTRUCTURA DETALLES DE FACTURA
                    foreach ($items as $item) {
                        $decuentoL = ($item->descuento) ? round($item->descuento,2) : 0;

                        if (strrpos($item->item, "COD:")) {

                            $codPos = strrpos($item->item, "COD:");
                            $cod = substr($item->item, $codPos);
                            $cod = trim(str_replace("COD:", "", $cod));
                            if ($cod == '' || $cod == null) {
                                $cod = $item->codItem;
                            }
                            $descipcion = trim(str_replace(["COD:", $cod], "", $item->item));
                        } else {

                            $descipcion = trim($item->item);
                            $cod = $item->codItem;
                        }

                        $precioUnitario = ROUND($item->precioUnitario,6);
                        if($precioUnitario < 1 ){
                            $precioUnitario = number_format($precioUnitario, 6, '.', '');
                        }

                        if($item->lote && $item->lote != ''){  
                            $descipcion .= ' Lote: '.$item->lote;
                        }

                        if($item->fecha_vencimiento && $item->fecha_vencimiento != ''){

                            $descipcion .= ' F.Venc: '.$item->fecha_vencimiento;
                        }

                        if($item->fecha_creado && $item->fecha_creado != ''){
                            $descipcion .= ' F.Creado: '.$item->fecha_creado;
                        }

                        $xml_detalles .= '<detalle>
                        <codigoPrincipal>' . $item->codItem . '</codigoPrincipal>
                        <codigoAuxiliar>' . $cod . '</codigoAuxiliar>
                        <descripcion>' . $descipcion . '</descripcion>
                        <cantidad>' . $item->cantidad . '</cantidad>
                        <precioUnitario>' . $precioUnitario . '</precioUnitario>
                        <descuento>' . $decuentoL . '</descuento>
                        <precioTotalSinImpuesto>' . ROUND($item->total, 2) . '</precioTotalSinImpuesto>';

                        $xml_detalles .= '<impuestos>';

                        if ($item->iva == 0) {

                            $BASE = ($item->precioUnitario * $item->cantidad) - $item->descuento;

                            $xml_detalles .= '
                                <impuesto>
                                    <codigo>2</codigo>
                                    <codigoPorcentaje>0</codigoPorcentaje>
                                    <tarifa>0</tarifa>
                                    <baseImponible>' . ROUND($BASE, 2) . '</baseImponible>
                                    <valor>0</valor>
                                </impuesto>
                            ';
                            $impuestos[0]['base'] += $BASE;
                            $impuestos[0]['valor'] = 0;

                        } elseif ($item->iva == 12) {

                            $BASE12 = ($item->precioUnitario * $item->cantidad) - $item->descuento;
                            $valor12 = ($BASE12 * $item->iva) /100;

                            // $totalProductoConImpuesto = $item->total * $item->iva;
                            // $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);
                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>2</codigoPorcentaje>
                                <tarifa>12</tarifa>
                                <baseImponible>' . ROUND($BASE12, 2)  . '</baseImponible>
                                <valor>' . round($valor12, 2) . '</valor>
                            </impuesto>
                            ';
                            $impuestos[2]['base'] += $BASE12;
                            $impuestos[2]['valor'] += $valor12;

                        } elseif ($item->iva == 8) {
                            $BASE8 = ($item->precioUnitario * $item->cantidad) - $item->descuento;
                            $valor8 = ($BASE8 * $item->iva) /100;

                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>8</codigoPorcentaje>
                                <tarifa>8</tarifa>
                                <baseImponible>' . ROUND($BASE8, 2) . '</baseImponible>
                                <valor>' . round($valor8, 2) . '</valor>
                            </impuesto>
                            ';
                            $impuestos[5]['valor'] += $valor8;
                            $impuestos[5]['base'] += $BASE8;
                        } elseif ($item->iva == 15) {

                            $BASE15 = ($item->precioUnitario * $item->cantidad) - $item->descuento;
                            $valor15 = ($BASE15 * $item->iva) /100;

                            // $totalProductoConImpuesto = ($item->total * $item->iva) / 100;
                            // $totalProductoConImpuesto = round($totalProductoConImpuesto, 3, PHP_ROUND_HALF_UP);

                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>4</codigoPorcentaje>
                                <tarifa>15</tarifa>
                                <baseImponible>' . ROUND($BASE15, 2) . '</baseImponible>
                                <valor>' . round($valor15, 2) . '</valor>
                            </impuesto>
                            ';

                            $impuestos[4]['valor'] += $valor15;
                            $impuestos[4]['base'] += $BASE15;

                        } elseif ($item->iva == 5) {

                            // $totalProductoConImpuesto = $item->total * $item->iva;
                            // $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);

                            $BASE5 = ($item->precioUnitario * $item->cantidad) - $item->descuento;
                            $valor5 = ($BASE5 * $item->iva) /100;

                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>5</codigoPorcentaje>
                                <tarifa>5</tarifa>
                                <baseImponible>' . ROUND($BASE5, 2) . '</baseImponible>
                                <valor>' . round($valor5, 2) . '</valor>
                            </impuesto>
                            ';
                            $impuestos[1]['valor'] += $valor5;
                            $impuestos[1]['base'] += $BASE5;

                        } elseif ($item->iva == 14) {

                            $totalProductoConImpuesto = $item->total * $item->iva;
                            $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);
                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>3</codigoPorcentaje>
                                <tarifa>14</tarifa>
                                <baseImponible>' . $item->total . '</baseImponible>
                                <valor>' . $totalProductoConImpuesto . '</valor>
                            </impuesto>
                            ';
                            $impuestos[3]['valor'] += $totalProductoConImpuesto;
                            $impuestos[3]['base'] += $item->total;
                        }

                        if ($item->ice == '1') {

                            $impuesto_ice = true;
                            $xml_detalles .= '
                                <impuesto>
                                    <codigo>' . $item->codigoIce . '</codigo>
                                    <codigoPorcentaje>' . $item->codigoPorcentajeIce . '</codigoPorcentaje>
                                    <tarifa>' . $item->tarifaIce . '</tarifa>
                                    <baseImponible>' . $item->baseImponibleIce . '</baseImponible>
                                    <valor>' . $item->valorIce . '</valor>
                                </impuesto>
                            ';

                            array_push($array_cod_ice, $item->codigoPorcentajeIce);
                            $codigoPorcentaje_ice = $item->codigoPorcentajeIce;
                            $cod_porce = array_search($item->codigoPorcentajeIce, $array_cod_ice);

                            $array_ice[$codigoPorcentaje_ice]['base_imponible'] += $item->baseImponibleIce;
                            $array_ice[$codigoPorcentaje_ice]['valor'] += $item->valorIce;
                            $array_ice[$codigoPorcentaje_ice]['tarifa'] = $item->tarifaIce;
                        }
                        if ($item->irbpnr == '1') {

                            $impuesto_irbpnr = true;
                            $base_imponible_irbpnr += $item->baseImponibleIrbpnr;
                            $valor_irbpnr += $item->valorIrbpnr;
                            $xml_detalles .= '
                                <impuesto>
                                    <codigo>' . $item->codigoIrbpnr . '</codigo>
                                    <codigoPorcentaje>' . $item->codigoPorcentajeIrbpnr . '</codigoPorcentaje>
                                    <tarifa>' . $item->tarifaIrbpnr . '</tarifa>
                                    <baseImponible>' . $item->baseImponibleIrbpnr . '</baseImponible>
                                    <valor>' . $item->valorIrbpnr . '</valor>
                                </impuesto>
                            ';


                            $impuesto_cabecera_irbpnr .= '<codigo>' . $item->codigoIrbpnr . '</codigo>
                                <codigoPorcentaje>' . $item->codigoPorcentajeIrbpnr . '</codigoPorcentaje>
                                <baseImponible>' . $item->baseImponibleIrbpnr . '</baseImponible>
                                <tarifa>' . $item->tarifaIrbpnr  . '</tarifa>
                                <valor>' . $item->valorIrbpnr . '</valor>
                                ';
                        }

                        $xml_detalles .= '</impuestos></detalle>';
                    }

                    $nombre_comercial_empresa = $documento->nombreComercial;
                    $razon_social_empresa = $documento->razonSocial;
                    $direccion_empresa = $documento->direccionMatriz;
                    $direccion_sucursal = (isset($documento->direccionEstablecimiento) && $documento->direccionEstablecimiento != '') ? $documento->direccionEstablecimiento : $documento->direccionMatriz;
                    $telefono_empresa = $documento->telefono;
                    $email_empresa = $documento->correo;
                    $nro_documento_empresa = $documento->rucEmpresa;
                    $obligado_llevar_contabilidad = $documento->obligadoContabilidad;

                    $nro_comprovante = $documento->secuencial;
                    $codigo_establecimiento = $documento->establecimiento;
                    $codigo_punto_emision = $documento->ptoEmision;
                    $fecha_emision = $documento->fecha;
                    $id_tipo_ambiente = $documento->ambiente;
                    $id_tipo_emision = 1;
                    $id_tipo_documento = str_pad($documento->tipoIdentificador, '2', '0', STR_PAD_LEFT);
                    $razon_social = $documento->razonSocial;
                    $razon_social_comprador = $documento->cliente;
                    $nro_documento = trim($documento->ruc);
                    $direccion = str_replace('/\s+/', '', trim($documento->direccion));
                    $subtotal_sin_impuesto = $documento->importeSinImpuestos;
                    $totaliva = 0;
                    $descuento =  $documento->descuento;
                    $subtotal_con_impuesto = $documento->total;
                    $impuesto = 0;
                    $total = $documento->importeTotal;

                    $direccion = str_replace('/\s+/', '', trim($documento->direccion));
                    $telefono = $documento->telefono;
                    $email = $documento->correo;

                    //Datos para la clave de acceso

                    if ($documento->claveAcceso) {
                        $clave_acceso = $documento->claveAcceso;
                    } else {
                        $clave = "" . date('dmY', strtotime($documento->fecha)) . "" . str_pad($documento->tipoComprobante, '2', '0', STR_PAD_LEFT) . "" . $documento->rucEmpresa . "" . $documento->ambiente . "" . $documento->establecimiento . "" . $documento->ptoEmision . "" . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . "12345678" . $id_tipo_emision . "";
                        $digito_verificador_clave = $this->validar_clave($clave);
                        $clave_acceso = $clave . $digito_verificador_clave . "";
                    }

                    $xml = '<?xml version="1.0" encoding="UTF-8"?>
                    <factura id="comprobante" version="1.1.0">
                        <infoTributaria>
                            <ambiente>' . $id_tipo_ambiente . '</ambiente>
                            <tipoEmision>' . $id_tipo_emision . '</tipoEmision>
                            <razonSocial>' . $razon_social_empresa . '</razonSocial>
                            <nombreComercial>' . $nombre_comercial_empresa . '</nombreComercial>
                            <ruc>' . $nro_documento_empresa . '</ruc>
                            <claveAcceso>' . $clave_acceso . '</claveAcceso>
                            <codDoc>01</codDoc>
                            <estab>' . $codigo_establecimiento . '</estab>
                            <ptoEmi>' . $codigo_punto_emision . '</ptoEmi>
                            <secuencial>' . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . '</secuencial>
                            <dirMatriz>' . $direccion_empresa . '</dirMatriz>';

                    if ($this->company->rimpe_emp) {
                        $xml .= '
                            <contribuyenteRimpe>CONTRIBUYENTE RÉGIMEN RIMPE</contribuyenteRimpe>
                            ';
                    }
                    if ($this->company->agente_retencion) {
                        $xml .= '
                        <agenteRetencion>' . $this->company->agente_retencion_num . '</agenteRetencion>
                        ';
                    }

                    $xml .= '</infoTributaria>
                        <infoFactura>
                            <fechaEmision>' . date("d/m/Y", strtotime($fecha_emision)) . '</fechaEmision>
                            <dirEstablecimiento>' . $direccion_sucursal . '</dirEstablecimiento>';

                    if ($this->company->contribuyente_especial) {
                        $xml .= '
                        <contribuyenteEspecial>' . $this->company->contribuyente_especial_num . '</contribuyenteEspecial>
                        ';
                    }


                    $xml .= '<obligadoContabilidad>' . $obligado_llevar_contabilidad . '</obligadoContabilidad>
                            <tipoIdentificacionComprador>' . str_pad($id_tipo_documento, '2', '0', STR_PAD_LEFT) . '</tipoIdentificacionComprador>
                            <razonSocialComprador>' . $razon_social_comprador . '</razonSocialComprador>
                            <identificacionComprador>' . $nro_documento . '</identificacionComprador>
                            <direccionComprador>' . $direccion . '</direccionComprador>';


                    $xml .= '
                        <totalSinImpuestos>' . $documento->importeSinImpuestos . '</totalSinImpuestos>';
                    $xml .= '
                        <totalDescuento>' . $descuento . '</totalDescuento>';

                    $xml .= '<totalConImpuestos>';

                    foreach ($impuestos as $value) {
                        if ($value['base'] > 0) {
                            //$valorA = $documento->importeTotal - $value['base'];
                            $valorA = $value['valor'];
                            $xml .= '
                                <totalImpuesto>
                                    <codigo>2</codigo>
                                    <codigoPorcentaje>' . $value['code'] . '</codigoPorcentaje>
                                    <baseImponible>' . round($value['base'], 2) . '</baseImponible>
                                    <tarifa>' . $value['IVA'] . '</tarifa>
                                    <valor>' . round($valorA, 2) . '</valor>
                                </totalImpuesto>';
                        }
                    }

                    /*
                    if ($documento->valorIva12 > 0) {

                        $xml .= '<totalImpuesto>
                                    <codigo>2</codigo>
                                    <codigoPorcentaje>2</codigoPorcentaje>
                                    <baseImponible>' . $documento->baseIva12 . '</baseImponible>
                                    <tarifa>12</tarifa>
                                    <valor>' . $documento->valorIva12 . '</valor>
                                </totalImpuesto>';
                    }
                    */

                    if ($impuesto_ice == true) {
                        foreach ($array_ice as $k => $v) {

                            $impuesto_cabecera_ice = '<codigo>3</codigo>
                                        <codigoPorcentaje>' . $k . '</codigoPorcentaje>
                                        <baseImponible>' . $v['base_imponible'] . '</baseImponible>
                                        <tarifa>' . $v['tarifa'] . '</tarifa>
                                        <valor>' . $v['valor'] . '</valor>';
                            $xml .= '<totalImpuesto>' . $impuesto_cabecera_ice . '</totalImpuesto>';
                        }
                    }

                    if ($impuesto_irbpnr == true) {
                        $xml .= '<totalImpuesto>' . $impuesto_cabecera_irbpnr . '</totalImpuesto>';
                    }

                    $fpagosArray = $documento->fPagos;
                    $fpagosArray = json_decode($fpagosArray, true);
                    $xmlfPagos = '';
                    foreach ($fpagosArray as $fpagosData) {
                        $xmlfPagos .= '<pago>
                                        <formaPago>' . $fpagosData['fp'] . '</formaPago>
                                        <total>' . $fpagosData['total'] . '</total>
                                        <plazo>' . $fpagosData['plazo'] . '</plazo>
                                        <unidadTiempo>' . $fpagosData['unidadtiempo'] . '</unidadTiempo>
                                    </pago>';
                    }

                    $importeTotal = $base_imponible_0 + $base_imponible_12 + $total_iva_12;
                    $popina = $documento->propina ? $documento->propina : 0.00;
                    $xml .= '
                            </totalConImpuestos>
                            <propina>'. $popina.'</propina>
                            <importeTotal>' . $total . '</importeTotal>
                            <moneda>DOLAR</moneda>
                            <pagos>
                                ' . $xmlfPagos . '
                            </pagos>
                            <valorRetIva>0.00</valorRetIva>
                            <valorRetRenta>0.00</valorRetRenta>
                        </infoFactura>
                    <detalles>';
                    $xml .= $xml_detalles;

                    $camposAdicionalesArray = explode(';', $camposAdicionales);
                    $xmlAdicionales = null;
                    
                    foreach ($camposAdicionalesArray as $adicional) {
                        $name = substr($adicional, 0, strpos($adicional, '='));
                        $value = substr($adicional, strpos($adicional, '=') + 1);
                        if ($name != '' && $value != '') {
                            $xmlAdicionales .= '<campoAdicional nombre="' . trim($name) . '">' . trim($value) . '</campoAdicional>';
                        }
                    }

                    if ($xmlAdicionales) {
                        $xml .= '</detalles>
                            <infoAdicional>
                                ' . $xmlAdicionales . '
                            </infoAdicional>
                        </factura>';
                    } else {
                        $xml .= '</detalles>
                        </factura>';
                    }

                    $nombre = "generados/" . $this->claveAccesoDateFolder($clave_acceso) . $clave_acceso . ".xml";
                    Storage::disk('tenant')->put($nombre, $xml);
                    $this->XmlGenerado = $xml;
                    $this->clave_acceso = $clave_acceso;
                    return $clave_acceso;
                }

                //RETENCIONES
                if ($documento->tipoComprobante == 7) {

                    $xml_docsustento = '';
                    $xml_retenciones = '';
                    $docSustentoP = '';

                    $totalSinImpuestos = $documento->importeSinImpuestos;

                    $totalBaseRetencion1 = 0;
                    $totalBaseRetencion2 = 0;

                    $totalRetenido1 = 0;
                    $totalRetenido2 = 0;
                    $os = array('1', '2', '3', '9', '10', '11');

                    $retenciones = DetalleRetencionElectronica::where('idComporbante', $documento->idComporbante)->get();

                    foreach ($retenciones as $retencion) {
                        $codigo = 1;
                        if (in_array($retencion->codigoRet, $os)) {
                            $codigo = 2;
                            $totalBaseRetencion2 = $totalBaseRetencion2 + $retencion->baseRet;
                            $totalRetenido2 = $totalRetenido2 + $retencion->valoRet;
                        } else {
                            $totalBaseRetencion1 = $totalBaseRetencion1 + $retencion->baseRet;
                            $totalRetenido1 = $totalRetenido1 + $retencion->valorRet;
                        }
                        $xmlDividentos = null;

                        if (isset($retencion->fechaPagoDiv)) {
                            $xmlDividentos = '<dividendos>
                                <fechaPagoDiv>' . $retencion->fechaPagoDiv . '</fechaPagoDiv>
                                <imRentaSoc>' . $retencion->imRentaSoc . '</imRentaSoc>
                                <ejerFisUtDiv>' . $retencion->ejerFisUtDiv . '</ejerFisUtDiv>
                            </dividendos>
                        </retencion>';
                        }
                        $xml_retenciones .= '<retencion>
                            <codigo>' . $codigo . '</codigo>
                            <codigoRetencion>' . $retencion->codigoRet . '</codigoRetencion>
                            <baseImponible>' . $retencion->baseRet . '</baseImponible>
                            <porcentajeRetener>' . $retencion->porcentajeRet . '</porcentajeRetener>
                            <valorRetenido>' . $retencion->valorRet . '</valorRetenido>';

                        if (isset($xmlDividentos) && $xmlDividentos != '') {
                            $xml_retenciones .= $xmlDividentos;
                        } else {
                            $xml_retenciones .= '
                        </retencion>';
                        }
                    }

                    $xmlImpuestos = '';

                    if ($documento->impuestos != null && isset($documento->impuestos) ==  true) {

                        foreach (json_decode($documento->impuestos, true) as $value) {
                            $xmlImpuestos = '<impuestoDocSustento>
                                <codImpuestoDocSustento>2</codImpuestoDocSustento>
                                <codigoPorcentaje>' . $value['code'] . '</codigoPorcentaje>
                                <baseImponible>' . $value['base'] . '</baseImponible>
                                <tarifa>' . $value['tarifa'] . '</tarifa>
                                <valorImpuesto>' . $value['valor'] . '</valorImpuesto>
                            </impuestoDocSustento>';
                        }
                    }

                    if (isset($documento->impuestos) ==  false && $documento->baseIva12 > 0) {
                        $xmlImpuestos .= '
                                    <impuestoDocSustento>
                                        <codImpuestoDocSustento>2</codImpuestoDocSustento>
                                        <codigoPorcentaje>2</codigoPorcentaje>
                                        <baseImponible>' . $documento->baseIva12 . '</baseImponible>
                                        <tarifa>12</tarifa>
                                        <valorImpuesto>' . $documento->valorIva12 . '</valorImpuesto>
                                    </impuestoDocSustento>';
                    }
                    if (isset($documento->impuestos) ==  false && $documento->baseIva0 > 0) {
                        $xmlImpuestos .= '
                                    <impuestoDocSustento>
                                        <codImpuestoDocSustento>2</codImpuestoDocSustento>
                                        <codigoPorcentaje>0</codigoPorcentaje>
                                        <baseImponible>' . $documento->baseIva0 . '</baseImponible>
                                        <tarifa>0</tarifa>
                                        <valorImpuesto>0</valorImpuesto>
                                    </impuestoDocSustento>';
                    }


                    $fpagosArray = $documento->fPagos;
                    $fpagosArray = json_decode($fpagosArray, true);

                    $xmlfPagos = '';
                    foreach ($fpagosArray as $fpagosData) {
                        $xmlfPagos .= ' <pago>
                                        <formaPago>' . $fpagosData['fp'] . '</formaPago>
                                        <total>' . $fpagosData['total'] . '</total>
                                    </pago>
                                    ';
                    }

                    $xml_docsustento = '<docSustento>
                        <codSustento>' . $documento->codSustento . '</codSustento>
                        <codDocSustento>' . $documento->codDocSustento . '</codDocSustento>
                        <numDocSustento>' . $retenciones[0]->serieDocAfectado . '</numDocSustento>
                        <fechaEmisionDocSustento>' . date("d/m/Y", strtotime($retenciones[0]->fechaDocAfectado)) . '</fechaEmisionDocSustento>
                        <numAutDocSustento>' . $documento->numAuthSustento . '</numAutDocSustento>
                        <pagoLocExt>' . $documento->pagoLocExt . '</pagoLocExt>
                        <totalSinImpuestos>' . $totalBaseRetencion1 . '</totalSinImpuestos>
                        <importeTotal>' . $documento->importeTotal . '</importeTotal>
                        <impuestosDocSustento>
                            ' . $xmlImpuestos . '
                        </impuestosDocSustento>
                        <retenciones>
                            ' . $xml_retenciones . '
                        </retenciones>
                        <pagos>
                                ' . $xmlfPagos . '
                        </pagos>
                    </docSustento>';

                    $nombre_comercial_empresa = $documento->nombreComercial;
                    $razon_social_empresa = $documento->razonSocial;
                    $direccion_empresa = $documento->direccionMatriz;
                    $direccion_sucursal = (isset($documento->direccionEstablecimiento) && $documento->direccionEstablecimiento != '') ? $documento->direccionEstablecimiento : $documento->direccionMatriz;
                    $telefono_empresa = $documento->telefono;
                    $email_empresa = $documento->correo;
                    $nro_documento_empresa = $documento->rucEmpresa;
                    $obligado_llevar_contabilidad = $documento->obligadoContabilidad;

                    $nro_comprovante = $documento->secuencial;
                    $codigo_establecimiento = $documento->establecimiento;
                    $codigo_punto_emision = $documento->ptoEmision;
                    $fecha_emision = $documento->fecha;
                    $periodo_fiscal = $documento->fechaFizcal;


                    $id_tipo_ambiente = $documento->ambiente;
                    $id_tipo_emision = 1;

                    $id_tipo_documento = str_pad($documento->tipoIdentificador, '2', '0', STR_PAD_LEFT);

                    $razon_social = $documento->razonSocial;
                    $razon_social_comprador = $documento->cliente;
                    $nro_documento = trim($documento->ruc);
                    $direccion = str_replace('/\s+/', '', trim($documento->direccion));
                    $telefono = $documento->telefono;
                    $email = $documento->correo;

                    $codSustento = $documento->codSustento;
                    $parteRel = $documento->parteRel;
                    $codDocSustento = $documento->codDocSustento;
                    $Authsustento = $documento->numAuthSustento;
                    $fpago = $documento->fPago;
                    $pagoLocExt = $documento->pagoLocExt;

                    //Datos para la clave de acceso


                    if ($documento->claveAcceso) {
                        $clave_acceso = $documento->claveAcceso;
                    } else {
                        $clave = "" . date('dmY', strtotime($documento->fecha)) . "" . str_pad($documento->tipoComprobante, '2', '0', STR_PAD_LEFT) . "" . $documento->rucEmpresa . "" . $documento->ambiente . "" . $documento->establecimiento . "" . $documento->ptoEmision . "" . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . "12345678" . $id_tipo_emision . "";
                        $digito_verificador_clave = $this->validar_clave($clave);
                        $clave_acceso = $clave . $digito_verificador_clave . "";
                    }
                    $xml = '<?xml version="1.0" encoding="utf-8"?>
                    <comprobanteRetencion id="comprobante" version="2.0.0">
                        <infoTributaria>
                            <ambiente>' . $id_tipo_ambiente . '</ambiente>
                            <tipoEmision>' . $id_tipo_emision . '</tipoEmision>
                            <razonSocial>' . $razon_social_empresa . '</razonSocial>
                            <nombreComercial>' . $nombre_comercial_empresa . '</nombreComercial>
                            <ruc>' . $nro_documento_empresa . '</ruc>
                            <claveAcceso>' . $clave_acceso . '</claveAcceso>
                            <codDoc>07</codDoc>
                            <estab>' . $codigo_establecimiento . '</estab>
                            <ptoEmi>' . $codigo_punto_emision . '</ptoEmi>
                            <secuencial>' . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . '</secuencial>
                            <dirMatriz>' . $direccion_empresa . '</dirMatriz>';

                    if ($this->company->rimpe_emp) {
                        $xml .= '
                            <contribuyenteRimpe>CONTRIBUYENTE RÉGIMEN RIMPE</contribuyenteRimpe>
                            ';
                    }
                    if ($this->company->agente_retencion) {
                        $xml .= '
                        <agenteRetencion>' . $this->company->agente_retencion_num . '</agenteRetencion>
                        ';
                    }

                    $xml .= '</infoTributaria>
                        <infoCompRetencion>
                            <fechaEmision>' . date("d/m/Y", strtotime($fecha_emision)) . '</fechaEmision>
                            <dirEstablecimiento>' . $direccion_sucursal . '</dirEstablecimiento>';

                    if ($this->company->contribuyente_especial) {
                        $xml .= '
                        <contribuyenteEspecial>' . $this->company->contribuyente_especial_num . '</contribuyenteEspecial>
                        ';
                    }

                    $xml .= ' <obligadoContabilidad>' . $obligado_llevar_contabilidad . '</obligadoContabilidad>
                            <tipoIdentificacionSujetoRetenido>' . $id_tipo_documento . '</tipoIdentificacionSujetoRetenido>';

                    if ($id_tipo_documento == '08') {
                        $xml .= '<tipoSujetoRetenido>' . $documento->tipoSujetoRetenido . '</tipoSujetoRetenido>
                            ';
                    }
                    $xml .= '<parteRel>' . $parteRel . '</parteRel>
                            <razonSocialSujetoRetenido>' . $razon_social_comprador . '</razonSocialSujetoRetenido>
                            <identificacionSujetoRetenido>' . $nro_documento . '</identificacionSujetoRetenido>
                            <periodoFiscal>' . $periodo_fiscal . '</periodoFiscal>
                        </infoCompRetencion>
                        <docsSustento>';

                    $xml .= $xml_docsustento;

                    $camposAdicionalesArray = explode(';', $documento->adicionales);

                    $xmlAdicionales = null;
                    foreach ($camposAdicionalesArray as $adicional) {
                        $name = substr($adicional, 0, strpos($adicional, '='));
                        $value = substr($adicional, strpos($adicional, '=') + 1);
                        if ($name != '' && $value != '') {
                            $xmlAdicionales .= '<campoAdicional nombre="' . trim($name) . '">' . trim($value) . '</campoAdicional>';
                        }
                    }

                     if($this->company->detraction_account){
                         $xmlAdicionales .= '<campoAdicional nombre="Adicional">' . trim($this->company->detraction_account) . '</campoAdicional>';                  
                    }



                    if ($xmlAdicionales) {
                        $xml .= '</docsSustento>
                            <infoAdicional>
                                ' . $xmlAdicionales . '
                            </infoAdicional>
                        </comprobanteRetencion>';
                    } else {
                        $xml .= '</docsSustento>
                        </comprobanteRetencion>';
                    }
                    $nombre = "generados/" . $this->claveAccesoDateFolder($clave_acceso) . $clave_acceso . ".xml";
                    Storage::disk('tenant')->put($nombre, $xml);
                    $this->XmlGenerado = $xml;
                    $this->clave_acceso = $clave_acceso;
                    return $clave_acceso;
                }

                // NOTA DE CREDITO
                if ($documento->tipoComprobante == 4) {

                    $xml_detalles = '';
                    $total_iva_12 = 0;
                    $base_imponible_12 = 0;
                    $base_imponible_ice = 0;
                    $base_imponible_irbpnr = 0;
                    $valor_ice = 0;
                    $valor_irbpnr = 0;
                    $base_imponible_0 = 0;
                    $total_iva_0 = 0;
                    $sub_total = 0;
                    $impuesto_ice = false;
                    $impuesto_irbpnr = false;
                    $impuesto_cabecera_ice = '';
                    $impuesto_cabecera_irbpnr = '';
                    $array_cod_ice = array();
                    $array_ice = array();
                    $impuestos = array(
                        ['base' => 0, 'IVA' => 0, 'valor' => 0, 'code' => 0],
                        ['base' => 0, 'IVA' => 5, 'valor' => 0, 'code' => 5],
                        ['base' => 0, 'IVA' => 12, 'valor' => 0, 'code' => 2],
                        ['base' => 0, 'IVA' => 14, 'valor' => 0, 'code' => 3],
                        ['base' => 0, 'IVA' => 15, 'valor' => 0, 'code' => 4],
                        ['base' => 0, 'IVA' => 8, 'valor' => 0, 'code' => 8]
                    );

                    $items = DetalleFacturaElectronica::where('idComporbante', $documento->idComporbante)->get();
                    foreach ($items as $item) {

                        $sub_total += $item->total;
                        $denominacion_comercial = $item->item;
                        $decuentoL = ($item->descuento) ? $item->descuento : 0;
                        $xml_detalles .= '<detalle>
                        <codigoInterno>' . $item->codItem . '</codigoInterno>
                        <descripcion>' . $denominacion_comercial . '</descripcion>
                        <cantidad>' . $item->cantidad . '</cantidad>
                        <precioUnitario>' . $item->precioUnitario . '</precioUnitario>
                        <descuento>' . $decuentoL . '</descuento>
                        <precioTotalSinImpuesto>' . $item->total . '</precioTotalSinImpuesto>';
                        $adiconalDet = false;
                        if($item->lote && $item->lote != ''){  
                            $xml_detalles .= '<detallesAdicionales>';
                            $xml_detalles .= '<detAdicional nombre="Lote" valor="'.$item->lote.'"/>';
                            $adiconalDet = true;
                        }

                        if($item->fecha_vencimiento && $item->fecha_vencimiento != ''){

                            $xml_detalles .=  $adiconalDet == false ? '<detallesAdicionales>' : '';
                            $xml_detalles .= '<detAdicional nombre="F.Vencimiento" valor="'.$item->fecha_vencimiento.'"/>';
                            $adiconalDet = true;
                        }

                        if($item->fecha_creado && $item->fecha_creado != ''){
                            $xml_detalles .=  $adiconalDet == false ? '<detallesAdicionales>' : '';
                            $xml_detalles .= '<detAdicional nombre="F.Elaborado" valor="'.$item->fecha_creado.'"/>';
                            $adiconalDet = true;
                        }
                        
                        $xml_detalles .=  $adiconalDet == true ? '</detallesAdicionales>' : '';
                        $xml_detalles .= '<impuestos>';
                        if ($item->iva == 0) {
                            $base_imponible_0 += $item->total;
                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>0</codigoPorcentaje>
                                <tarifa>0</tarifa>
                                <baseImponible>' . $item->total . '</baseImponible>
                                <valor>0</valor>
                            </impuesto>
                            ';
                            $impuestos[0]['base'] += $item->total;
                        } elseif ($item->iva == 12) {
                            $totalProductoConImpuesto = $item->total * $item->iva;
                            $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);

                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>2</codigoPorcentaje>
                                <tarifa>12</tarifa>
                                <baseImponible>' . $item->total . '</baseImponible>
                                <valor>' . $totalProductoConImpuesto . '</valor>
                            </impuesto>
                            ';
                            $impuestos[2]['base'] += $item->total;
                            $impuestos[2]['valor'] += $totalProductoConImpuesto;
                        } elseif ($item->iva == 15) {
                            $totalProductoConImpuesto = $item->total * $item->iva;
                            $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);

                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>4</codigoPorcentaje>
                                <tarifa>15</tarifa>
                                <baseImponible>' . $item->total . '</baseImponible>
                                <valor>' . $totalProductoConImpuesto . '</valor>
                            </impuesto>
                            ';
                            $impuestos[4]['base'] += $item->total;
                            $impuestos[4]['valor'] += $totalProductoConImpuesto;
                        }elseif ($item->iva == 8) {
                            $BASE8 = ($item->precioUnitario * $item->cantidad) - $item->descuento;
                            $valor8 = ($BASE8 * $item->iva) /100;

                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>8</codigoPorcentaje>
                                <tarifa>8</tarifa>
                                <baseImponible>' . ROUND($BASE8, 2) . '</baseImponible>
                                <valor>' . round($valor8, 2) . '</valor>
                            </impuesto>
                            ';
                            $impuestos[5]['valor'] += $valor8;
                            $impuestos[5]['base'] += $BASE8;
                        }elseif ($item->iva == 5) {
                            $totalProductoConImpuesto = $item->total * $item->iva;
                            $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);

                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>5</codigoPorcentaje>
                                <tarifa>5</tarifa>
                                <baseImponible>' . $item->total . '</baseImponible>
                                <valor>' . $totalProductoConImpuesto . '</valor>
                            </impuesto>
                            ';
                            $impuestos[1]['base'] += $item->total;
                            $impuestos[1]['valor'] += $totalProductoConImpuesto;
                        } elseif ($item->iva == 14) {
                            $totalProductoConImpuesto = $item->total * $item->iva;
                            $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);

                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>3</codigoPorcentaje>
                                <tarifa>14</tarifa>
                                <baseImponible>' . $item->total . '</baseImponible>
                                <valor>' . $totalProductoConImpuesto . '</valor>
                            </impuesto>
                            ';
                            $impuestos[3]['base'] += $item->total;
                            $impuestos[3]['valor'] += $totalProductoConImpuesto;
                        }

                        if ($item->ice == 1) {

                            $impuesto_ice = true;

                            $xml_detalles .= '
                                <impuesto>
                                    <codigo>' . $item->codigoIce . '</codigo>
                                    <codigoPorcentaje>' . $item->codigoPorcentajeIce . '</codigoPorcentaje>
                                    <tarifa>' . $item->tarifaIce . '</tarifa>
                                    <baseImponible>' . $item->baseImponibleIce . '</baseImponible>
                                    <valor>' . $item->valorIce . '</valor>
                                </impuesto>
                            ';

                            array_push($array_cod_ice, $item->codigoPorcentajeIce);
                            $codigoPorcentaje_ice = $item->codigoPorcentajeIce;
                            $cod_porce = array_search($item->codigoPorcentajeIce, $array_cod_ice);

                            $array_ice[$codigoPorcentaje_ice]['base_imponible'] += $item->baseImponibleIce;
                            $array_ice[$codigoPorcentaje_ice]['valor'] += $item->valorIce;
                            $array_ice[$codigoPorcentaje_ice]['tarifa'] = $item->tarifaIce;
                        }
                        if ($item->irbpnr == 1) {

                            $impuesto_irbpnr = true;
                            $base_imponible_irbpnr += $item->baseImponibleIrbpnr;
                            $valor_irbpnr += $item->valorIrbpnr;
                            $xml_detalles .= '
                                <impuesto>
                                    <codigo>' . $item->codigoIrbpnr . '</codigo>
                                    <codigoPorcentaje>' . $item->codigoPorcentajeIrbpnr . '</codigoPorcentaje>
                                    <tarifa>' . $item->tarifaIrbpnr . '</tarifa>
                                    <baseImponible>' . $item->baseImponibleIrbpnr . '</baseImponible>
                                    <valor>' . $item->valorIrbpnr . '</valor>
                                </impuesto>
                            ';


                            $impuesto_cabecera_irbpnr .= '<codigo>' . $item->codigoIrbpnr . '</codigo>
                                <codigoPorcentaje>' . $item->codigoPorcentajeIrbpnr . '</codigoPorcentaje>
                                <baseImponible>' . $item->baseImponibleIrbpnr . '</baseImponible>
                                <tarifa>' . $item->tarifaIrbpnr . '</tarifa>
                                <valor>' . $item->valorIrbpnr . '</valor>
                                ';
                        }
                        $xml_detalles .= '</impuestos></detalle>';
                    }

                    $nombre_comercial_empresa = $documento->nombreComercial;
                    $razon_social_empresa = $documento->razonSocial;
                    $direccion_empresa = $documento->direccionMatriz;
                    $direccion_sucursal = (isset($documento->direccionEstablecimiento) && $documento->direccionEstablecimiento != '') ? $documento->direccionEstablecimiento : $documento->direccionMatriz;
                    $telefono_empresa = '';
                    $email_empresa = '';
                    $nro_documento_empresa = $documento->rucEmpresa;
                    $obligado_llevar_contabilidad = $documento->obligadoContabilidad;

                    $nro_comprovante = $documento->secuencial;
                    $codigo_establecimiento = $documento->establecimiento;
                    $codigo_punto_emision = $documento->ptoEmision;
                    $fecha_emision = $documento->fecha;


                    $id_tipo_ambiente = $documento->ambiente;
                    $id_tipo_emision = 1;

                    $id_tipo_documento = str_pad($documento->tipoIdentificador, '1', '0', STR_PAD_LEFT);
                    $razon_social = $documento->razonSocial;
                    $razon_social_comprador = $documento->cliente;
                    $nro_documento = trim($documento->ruc);
                    $direccion = str_replace('/\s+/', '', trim($documento->direccion));
                    $subtotal_sin_impuesto = $sub_total;
                    $totaliva = 0;
                    $descuento = 0;
                    $subtotal_con_impuesto = $sub_total;
                    $impuesto = 0;
                    $total = $sub_total;


                    $telefono = $documento->telefono;
                    $email = $documento->correo;

                    $codDocModificado = $documento->tipoDocAfectado;
                    $numDocModificado = $documento->secuencialDocAfectado;
                    $fechaEmisionDocSustento = $documento->fechaDocSustento;
                    $motivoDev = $documento->motivoDev;

                    if ($documento->claveAcceso) {
                        $clave_acceso = $documento->claveAcceso;
                    } else {
                        $clave = "" . date('dmY', strtotime($documento->fecha)) . "" . str_pad($documento->tipoComprobante, '2', '0', STR_PAD_LEFT) . "" . $documento->rucEmpresa . "" . $documento->ambiente . "" . $documento->establecimiento . "" . $documento->ptoEmision . "" . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . "12345678" . $id_tipo_emision . "";
                        $digito_verificador_clave = $this->validar_clave($clave);
                        $clave_acceso = $clave . $digito_verificador_clave . "";
                    }

                    /*
                    if($total_iva_12 != floatVal($documento->valorIva12)){
                        $xml = 'El total del valor de IVA de la cabecera no cuadra con el total de la sumatoria de IVA en los detalles, verifique que esten asignados correctamente';
                        $nombre = "generados/" . $this->claveAccesoDateFolder($clave_acceso) . $clave_acceso . ".xml";
                        Storage::disk('tenant')->put($nombre, $xml);
                        $this->XmlGenerado = $xml;
                        $this->clave_acceso = $clave_acceso;
                        return $clave_acceso;
                    }
                    */
                    $xml = '<?xml version="1.0" encoding="UTF-8"?>
                    <notaCredito id="comprobante" version="1.1.0">
                        <infoTributaria>
                            <ambiente>' . $id_tipo_ambiente . '</ambiente>
                            <tipoEmision>' . $id_tipo_emision . '</tipoEmision>
                            <razonSocial>' . $razon_social_empresa . '</razonSocial>
                            <nombreComercial>' . $nombre_comercial_empresa . '</nombreComercial>
                            <ruc>' . $nro_documento_empresa . '</ruc>
                            <claveAcceso>' . $clave_acceso . '</claveAcceso>
                            <codDoc>04</codDoc>
                            <estab>' . $codigo_establecimiento . '</estab>
                            <ptoEmi>' . $codigo_punto_emision . '</ptoEmi>
                            <secuencial>' . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . '</secuencial>
                            <dirMatriz>' . $direccion_empresa . '</dirMatriz>';
                    if ($this->company->rimpe_emp) {
                        $xml .= '
                            <contribuyenteRimpe>CONTRIBUYENTE RÉGIMEN RIMPE</contribuyenteRimpe>
                            ';
                    }
                    if ($this->company->agente_retencion) {
                        $xml .= '
                        <agenteRetencion>' . $this->company->agente_retencion_num . '</agenteRetencion>
                        ';
                    }
                    $xml .= '</infoTributaria>
                        <infoNotaCredito>
                            <fechaEmision>' . date("d/m/Y", strtotime($fecha_emision)) . '</fechaEmision>
                            <dirEstablecimiento>' . $direccion_sucursal . '</dirEstablecimiento>
                            <tipoIdentificacionComprador>' . str_pad($id_tipo_documento, '2', '0', STR_PAD_LEFT) . '</tipoIdentificacionComprador>
                            <razonSocialComprador>' . $razon_social_comprador . '</razonSocialComprador>
                            <identificacionComprador>' . $nro_documento . '</identificacionComprador>';
                    if ($this->company->contribuyente_especial) {
                        $xml .= '
                                <contribuyenteEspecial>' . $this->company->contribuyente_especial_num . '</contribuyenteEspecial>
                                ';
                    }
                    $xml .= ' <obligadoContabilidad>' . $obligado_llevar_contabilidad . '</obligadoContabilidad>
                            <codDocModificado>' . $codDocModificado . '</codDocModificado>
                            <numDocModificado>' . $numDocModificado . '</numDocModificado>
                            <fechaEmisionDocSustento>' . date("d/m/Y", strtotime($fechaEmisionDocSustento)) . '</fechaEmisionDocSustento>
                            <totalSinImpuestos>' . $total . '</totalSinImpuestos>
                            <valorModificacion>' . round($documento->importeTotal * -1, 2) . '</valorModificacion>
                            <moneda>DOLAR</moneda>
                            <totalConImpuestos>';

                    /*
                    $xml .= '<totalConImpuestos>
                            <totalImpuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>0</codigoPorcentaje>
                                <baseImponible>' . $base_imponible_0 . '</baseImponible>
                                <valor>0.00</valor>
                            </totalImpuesto>';
                            */
                    foreach ($impuestos as $value) {
                        if ($value['valor'] > 0) {
                            $xml .= '
                                    <totalImpuesto>
                                        <codigo>2</codigo>
                                        <codigoPorcentaje>' . $value['code'] . '</codigoPorcentaje>
                                        <baseImponible>' . $value['base'] . '</baseImponible>
                                        <valor>' . $value['valor'] . '</valor>
                                    </totalImpuesto>';
                        }
                    }
                    /*
                    if ($total_iva_12 > 0) {

                        $xml .= '<totalImpuesto>
                                                <codigo>2</codigo>
                                                <codigoPorcentaje>2</codigoPorcentaje>
                                                <baseImponible>' . $base_imponible_12 . '</baseImponible>
                                                <valor>' . $total_iva_12 . '</valor>
                                            </totalImpuesto>';
                    }
                    */
                    if ($impuesto_ice == true) {
                        foreach ($array_ice as $k => $v) {

                            $impuesto_cabecera_ice = '<codigo>3</codigo>
                                                    <codigoPorcentaje>' . $k . '</codigoPorcentaje>
                                                    <baseImponible>' . $v['base_imponible'] . '</baseImponible>
                                                    <valor>' . $v['valor'] . '</valor>';
                            $xml .= '<totalImpuesto>' . $impuesto_cabecera_ice . '</totalImpuesto>';
                        }
                    }
                    if ($impuesto_irbpnr == true) {
                        $xml .= '<totalImpuesto>' . $impuesto_cabecera_irbpnr . '</totalImpuesto>';
                    }



                    $importeTotal = $base_imponible_0 + $base_imponible_12 + $total_iva_12;

                    $xml .= '
                            </totalConImpuestos>
                            <motivo>' . $motivoDev . '</motivo>
                        </infoNotaCredito>
                        <detalles>';
                    //echo $xml;
                    $xml .= $xml_detalles;
                    $camposAdicionalesArray = explode(';', $documento->adicionales);
                    $xmlAdicionales = null;
                    foreach ($camposAdicionalesArray as $adicional) {
                        $name = substr($adicional, 0, strpos($adicional, '='));
                        $value = substr($adicional, strpos($adicional, '=') + 1);
                        if ($name != '' && $value != '') {
                            $xmlAdicionales .= '<campoAdicional nombre="' . trim($name) . '">' . trim($value) . '</campoAdicional>';
                        }
                    }

                    if($this->company->detraction_account){
                        $xmlAdicionales .= '<campoAdicional nombre="Adicional">' . trim($this->company->detraction_account) . '</campoAdicional>';                  
                    }

                    if ($xmlAdicionales) {
                        $xml .= '
                            </detalles>
                            <infoAdicional>
                                ' . $xmlAdicionales . '
                            </infoAdicional>
                        </notaCredito>';
                    } else {
                        $xml .= '
                            </detalles>
                        </notaCredito>';
                    }

                    $nombre = "generados/" . $this->claveAccesoDateFolder($clave_acceso) . $clave_acceso . ".xml";
                    Storage::disk('tenant')->put($nombre, $xml);
                    $this->XmlGenerado = $xml;
                    $this->clave_acceso = $clave_acceso;
                    return $clave_acceso;
                }

                //nota de debito
                if ($documento->tipoComprobante == 5) {

                    $xml_motivos = '';
                    $total_iva_12 = 0;
                    $base_imponible_12 = 0;
                    $base_imponible_ice = 0;
                    $base_imponible_irbpnr = 0;
                    $valor_ice = 0;
                    $valor_irbpnr = 0;
                    $base_imponible_0 = 0;
                    $total_iva_0 = 0;
                    $sub_total = 0;
                    $impuesto_ice = false;
                    $impuesto_irbpnr = false;
                    $impuesto_cabecera_ice = '';
                    $impuesto_cabecera_irbpnr = '';
                    $array_cod_ice = array();
                    $array_ice = array();

                    $items = DetalleFacturaElectronica::where('idComporbante', $documento->idComporbante)->get();
                    foreach ($items as $item) {

                        $xml_motivos .= '<motivo>
                                <razon>' . $item->item . '</razon>
                                <valor>' . $item->total . '</valor>
                            </motivo>';
                    }

                    $nombre_comercial_empresa = $documento->nombreComercial;
                    $razon_social_empresa = $documento->razonSocial;
                    $direccion_empresa = $documento->direccionMatriz;
                    $direccion_sucursal = (isset($documento->direccionEstablecimiento) && $documento->direccionEstablecimiento != '') ? $documento->direccionEstablecimiento : $documento->direccionMatriz;
                    $telefono_empresa = '';
                    $email_empresa = '';
                    $nro_documento_empresa = $documento->rucEmpresa;
                    $obligado_llevar_contabilidad = $documento->obligadoContabilidad;

                    $nro_comprovante = $documento->secuencial;
                    $codigo_establecimiento = $documento->establecimiento;
                    $codigo_punto_emision = $documento->ptoEmision;
                    $fecha_emision = $documento->fecha;


                    $id_tipo_ambiente = $documento->ambiente;
                    $id_tipo_emision = 1;

                    $id_tipo_documento = str_pad($documento->tipoIdentificador, '1', '0', STR_PAD_LEFT);
                    $razon_social = $documento->razonSocial;
                    $razon_social_comprador = $documento->cliente;
                    $nro_documento = trim($documento->ruc);
                    $direccion = str_replace('/\s+/', '', trim($documento->direccion));
                    $subtotal_sin_impuesto = $sub_total;
                    $totaliva = 0;
                    $descuento = 0;
                    $subtotal_con_impuesto = $sub_total;
                    $impuesto = 0;
                    $total = $sub_total;


                    $telefono = $documento->telefono;
                    $email = $documento->correo;

                    $codDocModificado = $documento->tipoDocAfectado;
                    $numDocModificado = $documento->secuencialDocAfectado;
                    $fechaEmisionDocSustento = $documento->fechaDocSustento;
                    $motivoDev = $documento->motivoDev;

                    if ($documento->claveAcceso) {
                        $clave_acceso = $documento->claveAcceso;
                    } else {
                        $clave = "" . date('dmY', strtotime($documento->fecha)) . "" . str_pad($documento->tipoComprobante, '2', '0', STR_PAD_LEFT) . "" . $documento->rucEmpresa . "" . $documento->ambiente . "" . $documento->establecimiento . "" . $documento->ptoEmision . "" . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . "12345678" . $id_tipo_emision . "";
                        $digito_verificador_clave = $this->validar_clave($clave);
                        $clave_acceso = $clave . $digito_verificador_clave . "";
                    }
                    $xml = '<?xml version="1.0" encoding="UTF-8"?>
                    <notaDebito id="comprobante" version="1.0.0">
                        <infoTributaria>
                            <ambiente>' . $id_tipo_ambiente . '</ambiente>
                            <tipoEmision>' . $id_tipo_emision . '</tipoEmision>
                            <razonSocial>' . $razon_social_empresa . '</razonSocial>
                            <nombreComercial>' . $nombre_comercial_empresa . '</nombreComercial>
                            <ruc>' . $nro_documento_empresa . '</ruc>
                            <claveAcceso>' . $clave_acceso . '</claveAcceso>
                            <codDoc>05</codDoc>
                            <estab>' . $codigo_establecimiento . '</estab>
                            <ptoEmi>' . $codigo_punto_emision . '</ptoEmi>
                            <secuencial>' . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . '</secuencial>
                            <dirMatriz>' . $direccion_empresa . '</dirMatriz>';
                    if ($this->company->rimpe_emp) {
                        $xml .= '
                            <contribuyenteRimpe>CONTRIBUYENTE RÉGIMEN RIMPE</contribuyenteRimpe>
                            ';
                    }
                    if ($this->company->agente_retencion) {
                        $xml .= '
                        <agenteRetencion>' . $this->company->agente_retencion_num . '</agenteRetencion>
                        ';
                    }
                    $xml .= '</infoTributaria>
                        <infoNotaDebito>
                            <fechaEmision>' . date("d/m/Y", strtotime($fecha_emision)) . '</fechaEmision>
                            <dirEstablecimiento>' . $direccion_sucursal . '</dirEstablecimiento>
                            <tipoIdentificacionComprador>' . str_pad($id_tipo_documento, '2', '0', STR_PAD_LEFT) . '</tipoIdentificacionComprador>
                            <razonSocialComprador>' . $razon_social_comprador . '</razonSocialComprador>
                            <identificacionComprador>' . $nro_documento . '</identificacionComprador>';
                    if ($this->company->contribuyente_especial) {
                        $xml .= '
                            <contribuyenteEspecial>' . $this->company->contribuyente_especial_num . '</contribuyenteEspecial>
                            ';
                    }
                    $xml .= '<obligadoContabilidad>' . $obligado_llevar_contabilidad . '</obligadoContabilidad>
                            <codDocModificado>' . $codDocModificado . '</codDocModificado>
                            <numDocModificado>' . $numDocModificado . '</numDocModificado>
                            <fechaEmisionDocSustento>' . date("d/m/Y", strtotime($fechaEmisionDocSustento)) . '</fechaEmisionDocSustento>
                            <totalSinImpuestos>' . $documento->importeSinImpuestos . '</totalSinImpuestos>
                            <impuestos>';
                    //<valorModificacion>' . round($base_imponible_0 + $base_imponible_12 + $total_iva_12, 2) . '</valorModificacion>';

                    if ($documento->impuestos != null && isset($documento->impuestos) ==  true) {

                        foreach (json_decode($documento->impuestos, true) as $value) {
                            $xml .= '
                                <impuesto>
                                    <codigo>2</codigo>
                                    <codigoPorcentaje>' . $value['code'] . '</codigoPorcentaje>
                                    <tarifa>' . $value['tarifa'] . '</tarifa>
                                    <baseImponible>' . $value['base'] . '</baseImponible>
                                    <valor>' . $value['valor'] . '</valor>
                                </impuesto>';
                        }
                    }

                    if ($documento->impuestos == null && $documento->baseIva0 > 0) {

                        $xml .= '<impuesto>
                                    <codigo>2</codigo>
                                    <codigoPorcentaje>0</codigoPorcentaje>
                                    <tarifa>0.00</tarifa>
                                    <baseImponible>' . $documento->baseIva0 . '</baseImponible>
                                    <valor>0</valor>
                                </impuesto>';
                    }

                    if ($documento->impuestos == null && $documento->baseIva12 > 0) {

                        $xml .= '<impuesto>
                                    <codigo>2</codigo>
                                    <codigoPorcentaje>2</codigoPorcentaje>
                                    <tarifa>12.00</tarifa>
                                    <baseImponible>' . $documento->baseIva12 . '</baseImponible>
                                    <valor>' . $documento->valorIva12 . '</valor>
                                </impuesto>';
                    }

                    if ($impuesto_ice == true) {
                        foreach ($array_ice as $k => $v) {

                            $impuesto_cabecera_ice = '<codigo>3</codigo>
                                                    <codigoPorcentaje>' . $k . '</codigoPorcentaje>
                                                    <baseImponible>' . $v['base_imponible'] . '</baseImponible>
                                                    <valor>' . $v['valor'] . '</valor>';
                            $xml .= '<totalImpuesto>' . $impuesto_cabecera_ice . '</totalImpuesto>';
                        }
                    }
                    if ($impuesto_irbpnr == true) {
                        $xml .= '<totalImpuesto>' . $impuesto_cabecera_irbpnr . '</totalImpuesto>';
                    }



                    $importeTotal = $documento->importeTotal;
                    $fpagosArray = $documento->fPagos;
                    $fpagosArray = json_decode($fpagosArray, true);
                    $xmlfPagos = '';
                    foreach ($fpagosArray as $fpagosData) {
                        $xmlfPagos .= '<pago>
                                    <formaPago>' . $fpagosData['fp'] . '</formaPago>
                                    <total>' . $fpagosData['total'] . '</total>
                                    <plazo>' . $fpagosData['plazo'] . '</plazo>
                                    <unidadTiempo>' . $fpagosData['unidadtiempo'] . '</unidadTiempo>
                                </pago>';
                    }
                    $xml .= '
                            </impuestos>
                            <valorTotal>' . $importeTotal . '</valorTotal>
                            <pagos>
                                ' . $xmlfPagos . '
                            </pagos>
                        </infoNotaDebito>
                        ';
                    $camposAdicionalesArray = explode(';', $documento->adicionales);
                    $xmlAdicionales = null;
                    foreach ($camposAdicionalesArray as $adicional) {
                        $name = substr($adicional, 0, strpos($adicional, '='));
                        $value = substr($adicional, strpos($adicional, '=') + 1);
                        if ($name != '' && $value != '') {
                            $xmlAdicionales .= '<campoAdicional nombre="' . trim($name) . '">' . trim($value) . '</campoAdicional>';
                        }
                    }

                    if($this->company->detraction_account){
                        $xmlAdicionales .= '<campoAdicional nombre="Adicional">' . trim($this->company->detraction_account) . '</campoAdicional>';                  
                    }

                    if ($xmlAdicionales) {
                        $xml .= '<motivos>
                            ' . $xml_motivos . '
                        </motivos>
                        <infoAdicional>
                            ' . $xmlAdicionales . '
                        </infoAdicional>
                    </notaDebito>';
                    } else {
                        $xml .= '<motivos>
                            ' . $xml_motivos . '
                        </motivos>
                    </notaDebito>';
                    }

                    $nombre = "generados/" . $this->claveAccesoDateFolder($clave_acceso) . $clave_acceso . ".xml";
                    Storage::disk('tenant')->put($nombre, $xml);
                    $this->XmlGenerado = $xml;
                    $this->clave_acceso = $clave_acceso;
                    return $clave_acceso;
                }

                //liquidacion de compra
                if ($documento->tipoComprobante == 3) {

                    $xml_detalles = '';
                    $total_iva_12 = $documento->valorIva12;
                    $base_imponible_12 = $documento->baseIva12;
                    $base_imponible_ice = 0;
                    $base_imponible_irbpnr = 0;
                    $valor_ice = 0;
                    $valor_irbpnr = 0;
                    $base_imponible_0 = $documento->baseIva0;
                    $total_iva_0 = 0;
                    $sub_total = 0;
                    $impuesto_ice = false;
                    $impuesto_irbpnr = false;
                    $impuesto_cabecera_ice = '';
                    $impuesto_cabecera_irbpnr = '';
                    $array_cod_ice = array();
                    $array_ice = array();
                    $camposAdicionales = $documento->adicionales;
                    $impuestos = array(
                        ['base' => 0, 'IVA' => 0, 'valor' => 0, 'code' => 0],
                        ['base' => 0, 'IVA' => 5, 'valor' => 0, 'code' => 5],
                        ['base' => 0, 'IVA' => 12, 'valor' => 0, 'code' => 2],
                        ['base' => 0, 'IVA' => 14, 'valor' => 0, 'code' => 3],
                        ['base' => 0, 'IVA' => 15, 'valor' => 0, 'code' => 4],
                        ['base' => 0, 'IVA' => 8, 'valor' => 0, 'code' => 8]
                    );
                    $items = DetalleFacturaElectronica::where('idComporbante', $documento->idComporbante)->get();
                    //ESTRUCTURA DETALLES DE LIQUIDACION

                    foreach ($items as $item) {
                        $xml_detalles .= '
                            <detalle>
                                <codigoPrincipal>' . $item->codItem  . '</codigoPrincipal>
                                <codigoAuxiliar>' . $item->codItem  . '</codigoAuxiliar>
                                <descripcion>' . $item->item . '</descripcion>
                                <cantidad>' . $item->cantidad . '</cantidad>
                                <precioUnitario>' . $item->precioUnitario . '</precioUnitario>
                                <descuento>' . $item->descuento . '</descuento>
                                <precioTotalSinImpuesto>' . $item->total . '</precioTotalSinImpuesto>
                                <impuestos>';
                        //$xml_detalles .= '<impuestos>';
                        if ($item->iva == 0) {
                            $xml_detalles .= '
                                    <impuesto>
                                        <codigo>2</codigo>
                                        <codigoPorcentaje>0</codigoPorcentaje>
                                        <tarifa>0</tarifa>
                                        <baseImponible>' . $item->total . '</baseImponible>
                                        <valor>0</valor>
                                    </impuesto>
                            ';
                            $impuestos[0]['base'] += $item->total;
                        } elseif ($item->iva == 12) {
                            $totalProductoConImpuesto = $item->total * $item->iva;
                            $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);
                            $xml_detalles .= '
                                    <impuesto>
                                        <codigo>2</codigo>
                                        <codigoPorcentaje>2</codigoPorcentaje>
                                        <tarifa>12</tarifa>
                                        <baseImponible>' . $item->total . '</baseImponible>
                                        <valor>' . $totalProductoConImpuesto . '</valor>
                                    </impuesto>
                            ';
                            $impuestos[2]['base'] += $item->total;
                            $impuestos[2]['valor'] += $totalProductoConImpuesto;
                        } elseif ($item->iva == 15) {
                            $totalProductoConImpuesto = $item->total * $item->iva;
                            $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);
                            $xml_detalles .= '
                                    <impuesto>
                                        <codigo>2</codigo>
                                        <codigoPorcentaje>4</codigoPorcentaje>
                                        <tarifa>15</tarifa>
                                        <baseImponible>' . $item->total . '</baseImponible>
                                        <valor>' . $totalProductoConImpuesto . '</valor>
                                    </impuesto>
                            ';
                            $impuestos[4]['base'] += $item->total;
                            $impuestos[4]['valor'] += $totalProductoConImpuesto;
                        } elseif ($item->iva == 5) {
                            $totalProductoConImpuesto = $item->total * $item->iva;
                            $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);
                            $xml_detalles .= '
                                    <impuesto>
                                        <codigo>2</codigo>
                                        <codigoPorcentaje>5</codigoPorcentaje>
                                        <tarifa>5</tarifa>
                                        <baseImponible>' . $item->total . '</baseImponible>
                                        <valor>' . $totalProductoConImpuesto . '</valor>
                                    </impuesto>
                            ';
                            $impuestos[1]['base'] += $item->total;
                            $impuestos[1]['valor'] += $totalProductoConImpuesto;
                        } elseif ($item->iva == 14) {
                            $totalProductoConImpuesto = $item->total * $item->iva;
                            $totalProductoConImpuesto = round($totalProductoConImpuesto / 100, 2);
                            $xml_detalles .= '
                                    <impuesto>
                                        <codigo>2</codigo>
                                        <codigoPorcentaje>3</codigoPorcentaje>
                                        <tarifa>14</tarifa>
                                        <baseImponible>' . $item->total . '</baseImponible>
                                        <valor>' . $totalProductoConImpuesto . '</valor>
                                    </impuesto>
                            ';
                            $impuestos[3]['base'] += $item->total;
                            $impuestos[3]['valor'] += $totalProductoConImpuesto;
                        }elseif ($item->iva == 8) {
                            $BASE8 = ($item->precioUnitario * $item->cantidad) - $item->descuento;
                            $valor8 = ($BASE8 * $item->iva) /100;

                            $xml_detalles .= '
                            <impuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>8</codigoPorcentaje>
                                <tarifa>8</tarifa>
                                <baseImponible>' . ROUND($BASE8, 2) . '</baseImponible>
                                <valor>' . round($valor8, 2) . '</valor>
                            </impuesto>
                            ';
                            $impuestos[5]['valor'] += $valor8;
                            $impuestos[5]['base'] += $BASE8;
                        }

                        if ($item->ice == '1') {

                            $impuesto_ice = true;
                            $xml_detalles .= '
                                    <impuesto>
                                        <codigo>' . $item->codigoIce . '</codigo>
                                        <codigoPorcentaje>' . $item->codigoPorcentajeIce . '</codigoPorcentaje>
                                        <tarifa>' . $item->tarifaIce . '</tarifa>
                                        <baseImponible>' . $item->baseImponibleIce . '</baseImponible>
                                        <valor>' . $item->valorIce . '</valor>
                                    </impuesto>
                            ';

                            array_push($array_cod_ice, $item->codigoPorcentajeIce);
                            $codigoPorcentaje_ice = $item->codigoPorcentajeIce;
                            $cod_porce = array_search($item->codigoPorcentajeIce, $array_cod_ice);

                            $array_ice[$codigoPorcentaje_ice]['base_imponible'] += $item->baseImponibleIce;
                            $array_ice[$codigoPorcentaje_ice]['valor'] += $item->valorIce;
                            $array_ice[$codigoPorcentaje_ice]['tarifa'] = $item->tarifaIce;
                        }
                        if ($item->irbpnr == '1') {

                            $impuesto_irbpnr = true;
                            $base_imponible_irbpnr += $item->baseImponibleIrbpnr;
                            $valor_irbpnr += $item->valorIrbpnr;
                            $xml_detalles .= '
                                    <impuesto>
                                        <codigo>' . $item->codigoIrbpnr . '</codigo>
                                        <codigoPorcentaje>' . $item->codigoPorcentajeIrbpnr . '</codigoPorcentaje>
                                        <tarifa>' . $item->tarifaIrbpnr . '</tarifa>
                                        <baseImponible>' . $item->baseImponibleIrbpnr . '</baseImponible>
                                        <valor>' . $item->valorIrbpnr . '</valor>
                                    </impuesto>
                            ';

                            $impuesto_cabecera_irbpnr .= '<codigo>' . $item->codigoIrbpnr . '</codigo>
                                <codigoPorcentaje>' . $item->codigoPorcentajeIrbpnr . '</codigoPorcentaje>
                                <baseImponible>' . $item->baseImponibleIrbpnr . '</baseImponible>
                                <tarifa>' . $item->tarifaIrbpnr  . '</tarifa>
                                <valor>' . $item->valorIrbpnr . '</valor>
                                ';
                        }

                        $xml_detalles .= '  </impuestos>
                            </detalle>';
                    }

                    $nombre_comercial_empresa = $documento->nombreComercial;
                    $razon_social_empresa = $documento->razonSocial;
                    $direccion_empresa = $documento->direccionMatriz;
                    $direccion_sucursal = (isset($documento->direccionEstablecimiento) && $documento->direccionEstablecimiento != '') ? $documento->direccionEstablecimiento : $documento->direccionMatriz;
                    $telefono_empresa = $documento->telefono;
                    $email_empresa = $documento->correo;
                    $nro_documento_empresa = $documento->rucEmpresa;
                    $obligado_llevar_contabilidad = $documento->obligadoContabilidad;

                    $nro_comprovante = $documento->secuencial;
                    $codigo_establecimiento = $documento->establecimiento;
                    $codigo_punto_emision = $documento->ptoEmision;
                    $fecha_emision = $documento->fecha;


                    $id_tipo_ambiente = $documento->ambiente;
                    $id_tipo_emision = 1;

                    $id_tipo_documento = str_pad($documento->tipoIdentificador, '1', '0', STR_PAD_LEFT);
                    $razon_social = $documento->razonSocial;
                    $razon_social_comprador = $documento->cliente;
                    $nro_documento = trim($documento->ruc);
                    $direccion = str_replace('/\s+/', '', trim($documento->direccion));
                    $subtotal_sin_impuesto = $documento->importeSinImpuestos;
                    $totaliva = 0;
                    $descuento = 0;
                    $subtotal_con_impuesto = $documento->total;
                    $impuesto = 0;
                    $total = $documento->importeTotal;

                    $direccion = str_replace('/\s+/', '', trim($documento->direccion));
                    $telefono = $documento->telefono;
                    $email = $documento->correo;

                    //Datos para la clave de acceso

                    if ($documento->claveAcceso) {
                        $clave_acceso = $documento->claveAcceso;
                    } else {
                        $clave = "" . date('dmY', strtotime($documento->fecha)) . "" . str_pad($documento->tipoComprobante, '2', '0', STR_PAD_LEFT) . "" . $documento->rucEmpresa . "" . $documento->ambiente . "" . $documento->establecimiento . "" . $documento->ptoEmision . "" . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . "12345678" . $id_tipo_emision . "";
                        $digito_verificador_clave = $this->validar_clave($clave);
                        $clave_acceso = $clave . $digito_verificador_clave . "";
                    }

                    $xml = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
                    <liquidacionCompra  id="comprobante" version="1.1.0">
                        <infoTributaria>
                            <ambiente>' . $id_tipo_ambiente . '</ambiente>
                            <tipoEmision>' . $id_tipo_emision . '</tipoEmision>
                            <razonSocial>' . $razon_social_empresa . '</razonSocial>
                            <nombreComercial>' . $nombre_comercial_empresa . '</nombreComercial>
                            <ruc>' . $nro_documento_empresa . '</ruc>
                            <claveAcceso>' . $clave_acceso . '</claveAcceso>
                            <codDoc>03</codDoc>
                            <estab>' . $codigo_establecimiento . '</estab>
                            <ptoEmi>' . $codigo_punto_emision . '</ptoEmi>
                            <secuencial>' . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . '</secuencial>
                            <dirMatriz>' . $direccion_empresa . '</dirMatriz>';

                    $xml .= '
                        </infoTributaria>
                        <infoLiquidacionCompra>
                            <fechaEmision>' . date("d/m/Y", strtotime($fecha_emision)) . '</fechaEmision>
                            <dirEstablecimiento>' . $direccion_sucursal . '</dirEstablecimiento>';

                    if ($this->company->contribuyente_especial) {
                        $xml .= '
                            <contribuyenteEspecial>' . $this->company->contribuyente_especial_num . '</contribuyenteEspecial>
                        ';
                    }

                    $xml .= '<obligadoContabilidad>' . $obligado_llevar_contabilidad . '</obligadoContabilidad>
                            <tipoIdentificacionProveedor>' . str_pad($id_tipo_documento, '2', '0', STR_PAD_LEFT) . '</tipoIdentificacionProveedor>
                            <razonSocialProveedor>' . $razon_social_comprador . '</razonSocialProveedor>
                            <identificacionProveedor>' . $nro_documento . '</identificacionProveedor>
                            <totalSinImpuestos>' . $documento->importeSinImpuestos . '</totalSinImpuestos>
                            <totalDescuento>' . $descuento . '</totalDescuento>
                            <totalConImpuestos>';

                    foreach ($impuestos as $value) {
                        if ($value['base'] > 0) {
                        $xml .= '
                            <totalImpuesto>
                                <codigo>2</codigo>
                                <codigoPorcentaje>' . $value['code'] . '</codigoPorcentaje>
                                <baseImponible>' . $value['base'] . '</baseImponible>
                                <tarifa>' . $value['IVA'] . '</tarifa>
                                <valor>' . round($value['valor'], 2) . '</valor>
                            </totalImpuesto>';
                        }
                    }
                    /*
                    if ($documento->valorIva12 > 0) {

                        $xml .= '<totalImpuesto>
                                    <codigo>2</codigo>
                                    <codigoPorcentaje>2</codigoPorcentaje>
                                    <baseImponible>' . $documento->baseIva12 . '</baseImponible>
                                    <tarifa>12</tarifa>
                                    <valor>' . $documento->valorIva12 . '</valor>
                                </totalImpuesto>';
                    }
                    */
                    if ($impuesto_ice == true) {
                        foreach ($array_ice as $k => $v) {

                            $impuesto_cabecera_ice = '<codigo>3</codigo>
                                        <codigoPorcentaje>' . $k . '</codigoPorcentaje>
                                        <baseImponible>' . $v['base_imponible'] . '</baseImponible>
                                        <tarifa>' . $v['tarifa'] . '</tarifa>
                                        <valor>' . $v['valor'] . '</valor>';
                            $xml .= '<totalImpuesto>' . $impuesto_cabecera_ice . '</totalImpuesto>';
                        }
                    }

                    if ($impuesto_irbpnr == true) {
                        $xml .= '<totalImpuesto>' . $impuesto_cabecera_irbpnr . '</totalImpuesto>';
                    }

                    $fpagosArray = $documento->fPagos;
                    $fpagosArray = json_decode($fpagosArray, true);
                    $xmlfPagos = '';
                    foreach ($fpagosArray as $fpagosData) {
                        $xmlfPagos .= '<pago>
                                        <formaPago>' . $fpagosData['fp'] . '</formaPago>
                                        <total>' . $fpagosData['total'] . '</total>
                                        <plazo>' . $fpagosData['plazo'] . '</plazo>
                                        <unidadTiempo>' . $fpagosData['unidadtiempo'] . '</unidadTiempo>
                                    </pago>';
                    }

                    //$importeTotal = $base_imponible_0 + $base_imponible_12 + $total_iva_12;
                    $xml .= '
                            </totalConImpuestos>
                            <importeTotal>' . $documento->importeTotal . '</importeTotal>
                            <moneda>DOLAR</moneda>
                            <pagos>
                                ' . $xmlfPagos . '
                            </pagos>
                        </infoLiquidacionCompra>
                        <detalles>';
                    $xml .= $xml_detalles;

                    $camposAdicionalesArray = explode(';', $camposAdicionales);
                    $xmlAdicionales = null;
                    foreach ($camposAdicionalesArray as $adicional) {
                        $name = substr($adicional, 0, strpos($adicional, '='));
                        $value = substr($adicional, strpos($adicional, '=') + 1);
                        if (isset($name) && isset($value) && $value != '' && $name != '') {
                            $xmlAdicionales .= '<campoAdicional nombre="' . trim($name) . '">' . trim($value) . '</campoAdicional>';
                        }
                    }
                    if($this->company->detraction_account){
                        $xmlAdicionales .= '<campoAdicional nombre="Adicional">' . trim($this->company->detraction_account) . '</campoAdicional>';                  
                    }
                    if (isset($xmlAdicionales)) {
                        $xml .= '
                        </detalles>
                        <infoAdicional>
                            ' . $xmlAdicionales . '
                        </infoAdicional>
                    </liquidacionCompra >';
                    } else {
                        $xml .= '</detalles>
                    </liquidacionCompra >';
                    }


                    $nombre = "generados/" . $this->claveAccesoDateFolder($clave_acceso) . $clave_acceso . ".xml";
                    Storage::disk('tenant')->put($nombre, $xml);
                    $this->XmlGenerado = $xml;
                    $this->clave_acceso = $clave_acceso;
                    return $clave_acceso;
                }
                
                //guia de remision
                if ($documento->tipoComprobante == 6) {

                    $xml_destinatarios = '';
                    $total_iva_12 = $documento->valorIva12;
                    $base_imponible_12 = $documento->baseIva12;
                    $base_imponible_ice = 0;
                    $base_imponible_irbpnr = 0;
                    $valor_ice = 0;
                    $valor_irbpnr = 0;
                    $base_imponible_0 = $documento->baseIva0;
                    $total_iva_0 = 0;
                    $sub_total = 0;
                    $impuesto_ice = false;
                    $impuesto_irbpnr = false;
                    $impuesto_cabecera_ice = '';
                    $impuesto_cabecera_irbpnr = '';
                    $array_cod_ice = array();
                    $array_ice = array();
                    $camposAdicionales = $documento->adicionales;
                    $items = Destinatarios::where('id_documento', $documento->idComporbante)->get();
                    //ESTRUCTURA DESTINATARIOS
                    foreach ($items as $item) {

                        $xml_destinatarios .= '
                        <destinatario>
                            <identificacionDestinatario>' . $item->identificacion . '</identificacionDestinatario>
                            <razonSocialDestinatario>' . $item->razon_social . '</razonSocialDestinatario>
                            <dirDestinatario>' . $item->direccion . '</dirDestinatario>
                            <motivoTraslado>' . $item->motivo . '</motivoTraslado>';

                        if (isset($item->docAduaneroUnico)) {
                            $xml_destinatarios .= '
                            <docAduaneroUnico>' . $item->docAduaneroUnico . '</docAduaneroUnico>';
                        }

                        if (isset($item->codEstablecimiento)) {
                            $xml_destinatarios .= '
                            <codEstabDestino>' . $item->codEstablecimiento . '</codEstabDestino>';
                        }

                        if (isset($item->ruta)) {
                            $xml_destinatarios .= '
                            <ruta>' . $item->ruta . '</ruta>';
                        }

                        if (isset($item->codDocSustento) && $item->codDocSustento != '') {

                            $xml_destinatarios .= '
                            <codDocSustento>' . $item->codDocSustento . '</codDocSustento>
                            <numDocSustento>' . $item->numDocSustento . '</numDocSustento>
                            <numAutDocSustento>' . $item->numAutDocSustento . '</numAutDocSustento>
                            <fechaEmisionDocSustento>' . $item->fechaEmisionDocSustento . '</fechaEmisionDocSustento>
                            <detalles>';
                        } else {

                            $xml_destinatarios .= '
                            <detalles>';
                        }


                        $xmlDetalles = '';
                        $detallesDestino = Destinatarios_detalle::where('id_destinatario', $item->id)->get();

                        //Log::info($xml_destinatarios);

                        foreach ($detallesDestino as $detalle) {

                            $xmlDetalles .= '
                                <detalle>
                                    <codigoInterno>' . $detalle->codItem . '</codigoInterno>';

                            if (isset($detalle->codAdicional)) {
                                $xmlDetalles .= '
                                    <codigoAdicional>' . $detalle->codAdicional . '</codigoAdicional>';
                            }

                            $xmlDetalles .= '
                                    <descripcion>' . $detalle->item . '</descripcion>
                                    <cantidad>' . $detalle->cantidad . '</cantidad>';

                            //Log::info($xmlDetalles);

                            $detallesAdItem = '';

                            if (isset($detalle->adicionales)) {

                                $adArray = explode(';', $detalle->adicionales);
                                //Log::info("detalles: ",$adArray);

                                foreach ($adArray as $detAd) {

                                    if ($detAd != '') {
                                        $value = explode(':', $detAd);
                                        //Log::info("detalles 2: ",$value);
                                        $detallesAdItem .= '
                                        <detAdicional nombre="' . $value[0] . '" valor="' . $value[1] . '"/>';
                                    }
                                }
                            }

                            if ($detallesAdItem != '') {

                                $xmlDetalles .= '
                                    <detallesAdicionales>' . $detallesAdItem . '
                                    </detallesAdicionales>';
                            }
                            $xmlDetalles .= '
                                </detalle>';
                        }
                        $xml_destinatarios .= $xmlDetalles . '
                            </detalles>
                        </destinatario>';
                    }

                    $nombre_comercial_empresa = $documento->nombreComercial;
                    $razon_social_empresa = $documento->razonSocial;
                    $direccion_empresa = $documento->direccionMatriz;
                    $direccion_sucursal = (isset($documento->direccionEstablecimiento) && $documento->direccionEstablecimiento != '') ? $documento->direccionEstablecimiento : $documento->direccionMatriz;
                    $telefono_empresa = $documento->telefono;
                    $email_empresa = $documento->correo;
                    $nro_documento_empresa = $documento->rucEmpresa;
                    $obligado_llevar_contabilidad = $documento->obligadoContabilidad;

                    $nro_comprovante = $documento->secuencial;
                    $codigo_establecimiento = $documento->establecimiento;
                    $codigo_punto_emision = $documento->ptoEmision;
                    $fecha_emision = $documento->fecha;


                    $id_tipo_ambiente = $documento->ambiente;
                    $id_tipo_emision = 1;

                    $id_tipo_documento = str_pad($documento->tipoIdentificador, '2', '0', STR_PAD_LEFT);
                    $razon_social = $documento->razonSocial;
                    $razon_social_comprador = $documento->cliente;
                    $nro_documento = trim($documento->ruc);
                    $direccion = str_replace('/\s+/', '', trim($documento->direccion));
                    $subtotal_sin_impuesto = $documento->importeSinImpuestos;
                    $totaliva = 0;
                    $descuento =  $documento->descuento;
                    $subtotal_con_impuesto = $documento->total;
                    $impuesto = 0;
                    $total = $documento->importeTotal;

                    $direccion = str_replace('/\s+/', '', trim($documento->direccion));
                    $telefono = $documento->telefono;
                    $email = $documento->correo;

                    //Datos para la clave de acceso

                    if ($documento->claveAcceso) {
                        $clave_acceso = $documento->claveAcceso;
                    } else {
                        $clave = "" . date('dmY', strtotime($documento->fecha)) . "" . str_pad($documento->tipoComprobante, '2', '0', STR_PAD_LEFT) . "" . $documento->rucEmpresa . "" . $documento->ambiente . "" . $documento->establecimiento . "" . $documento->ptoEmision . "" . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . "12345678" . $id_tipo_emision . "";
                        $digito_verificador_clave = $this->validar_clave($clave);
                        $clave_acceso = $clave . $digito_verificador_clave . "";
                    }

                    $xml = '<?xml version="1.0" encoding="UTF-8"?>
                    <guiaRemision id="comprobante" version="1.1.0">
                        <infoTributaria>
                            <ambiente>' . $id_tipo_ambiente . '</ambiente>
                            <tipoEmision>' . $id_tipo_emision . '</tipoEmision>
                            <razonSocial>' . $razon_social_empresa . '</razonSocial>
                            <nombreComercial>' . $nombre_comercial_empresa . '</nombreComercial>
                            <ruc>' . $nro_documento_empresa . '</ruc>
                            <claveAcceso>' . $clave_acceso . '</claveAcceso>
                            <codDoc>06</codDoc>
                            <estab>' . $codigo_establecimiento . '</estab>
                            <ptoEmi>' . $codigo_punto_emision . '</ptoEmi>
                            <secuencial>' . str_pad($documento->secuencial, '9', '0', STR_PAD_LEFT) . '</secuencial>
                            <dirMatriz>' . $direccion_empresa . '</dirMatriz>
                        </infoTributaria>';

                    $xml .= '
                    <infoGuiaRemision>
                            <dirEstablecimiento>' . $direccion_sucursal . '</dirEstablecimiento>
                            <dirPartida>' . $documento->direccionDePartida . '</dirPartida>
                            <razonSocialTransportista>' . $documento->cliente . '</razonSocialTransportista>
                            <tipoIdentificacionTransportista>' .  str_pad($id_tipo_documento, '2', '0', STR_PAD_LEFT) . '</tipoIdentificacionTransportista>
                            <rucTransportista>' . $nro_documento . '</rucTransportista>';

                    if ($this->company->rise) {
                        $xml .= '
                            <rise>Contribuyente Regimen Simplificado RISE</rise>';
                    }

                    $xml .= '
                            <obligadoContabilidad>' . $obligado_llevar_contabilidad . '</obligadoContabilidad>';

                    if ($this->company->contribuyente_especial) {
                        $xml .= '
                            <contribuyenteEspecial>' . $this->company->contribuyente_especial_num . '</contribuyenteEspecial>';
                    }

                    $xml .= '
                            <fechaIniTransporte>' . $documento->fechaIniTranporte . '</fechaIniTransporte>
                            <fechaFinTransporte>' . $documento->fechaFinTransporte . '</fechaFinTransporte>
                            <placa>' . $documento->placa . '</placa>
                        </infoGuiaRemision>';

                    $xml .= '
                        <destinatarios>' . $xml_destinatarios . '
                        </destinatarios>';

                    $camposAdicionalesArray = explode(';', $camposAdicionales);
                    $xmlAdicionales = null;
                    foreach ($camposAdicionalesArray as $adicional) {
                        $name = substr($adicional, 0, strpos($adicional, '='));
                        $value = substr($adicional, strpos($adicional, '=') + 1);
                        if ($name != '' && $value != '') {
                            $xmlAdicionales .= '
                            <campoAdicional nombre="' . trim($name) . '">' . trim($value) . '</campoAdicional>';
                        }
                    }
                    if($this->company->detraction_account){
                        $xmlAdicionales .= '<campoAdicional nombre="Adicional">' . trim($this->company->detraction_account) . '</campoAdicional>';                  
                    }
                    if ($xmlAdicionales) {
                        $xml .= '
                        <infoAdicional>
                            ' . $xmlAdicionales . '
                        </infoAdicional>
                    </guiaRemision>';
                    } else {
                        $xml .= '
                    </guiaRemision>';
                    }

                    $nombre = "generados/" . $this->claveAccesoDateFolder($clave_acceso) . $clave_acceso . ".xml";
                    Storage::disk('tenant')->put($nombre, $xml);
                    $this->XmlGenerado = $xml;
                    $this->clave_acceso = $clave_acceso;
                    return $clave_acceso;
                }
            }
        } catch (Exception $ex) {
            Log::info("Error en createXML : " . $documento->idComporbante . " - " . $ex->getMessage());
            return false;
        }
    }

    public function firmarXML()
    {

        try {

            $this->setPathCertificate();
            $firma = new FirmarSri();
            //Log::info("Ruta del CErtificado: ".$this->pathCertificate);
            $this->XmlGenerado = str_replace('&', '&amp;', $this->XmlGenerado);
            $this->xmlSigned = $firma->Firma_SRI($this->clave_acceso, $this->pathCertificate, $this->company->certificate_pass, $this->XmlGenerado);
            $nombre = "firmados/" . $this->claveAccesoDateFolder($this->clave_acceso) . $this->clave_acceso . ".xml";
            Storage::disk('tenant')->put($nombre, $this->xmlSigned);
            return true;
        } catch (Exception $ex) {

            Log::critical("NO SE PUDO FIRMAR EL XML DE : " . $this->clave_acceso);
            Log::critical("ERROR: " . $ex->getMessage());
            return false;
        }
    }

    public function sendToSriDocuments()
    {
        $res = $this->sendXmlSigned();

        if ($res) {

            $responseSRI = $res;
            $estado = NULL;
            $code = NULL;
            $mensaje = NULL;
            $detalle = null;

            try {

                $estado = $responseSRI['RespuestaRecepcionComprobante']['estado'];

                LogSRI::create([
                    'document_id' => $this->documento->idComporbante,
                    'type' => 'ENVIO',
                    'status' => $estado,
                    'message' => json_encode($responseSRI)
                ])->save();


                if ($estado == 'DEVUELTA') {

                    $this->documento->update([
                        'idEstado' => self::RETURNED
                    ]);
                    $code = $responseSRI['RespuestaRecepcionComprobante']['comprobantes']['comprobante']['mensajes']['mensaje']['identificador'];
                    $mensaje = $responseSRI['RespuestaRecepcionComprobante']['comprobantes']['comprobante']['mensajes']['mensaje']['mensaje'];
                    $detalle = $responseSRI['RespuestaRecepcionComprobante']['comprobantes']['comprobante']['mensajes'];
                    $this->documento->update([
                        'regularizeShipping' => true,
                        'responseRegularizeShipping' => json_encode([
                            'code' => $code,
                            'description' => $mensaje,
                            'response' =>  $detalle,
                        ])
                    ]);
                } elseif ($estado == 'RECIBIDA') {

                    $this->documento->update([
                        'idEstado' => self::OBSERVED
                    ]);
                    $code = 200;
                    $mensaje = "DOCUMENTO RECIBIDO POR EL SRI";
                    $this->documento->update([
                        'regularizeShipping' => true,
                        'responseRegularizeShipping' => json_encode([
                            'code' => $code,
                            'description' => $mensaje,
                            'detalle' => null,
                        ])
                    ]);
                } else {

                    $code = 502;
                    $mensaje = 'NO SE RECUPERO UNA RESPUESTA DEL SRI';
                    $this->documento->update([
                        'regularizeShipping' => true,
                        'responseRegularizeShipping' => json_encode([
                            'code' => $code,
                            'description' => $mensaje,
                            'detalle' => $res,
                        ])
                    ]);
                }
            } catch (Exception $ex) {

                try {

                    $code = $responseSRI['RespuestaRecepcionComprobante']['comprobantes']['comprobante']['mensajes']['mensaje']['identificador'];
                    $mensaje = $responseSRI['RespuestaRecepcionComprobante']['comprobantes']['comprobante']['mensajes']['mensaje']['mensaje'];
                    $detalle = $responseSRI['RespuestaRecepcionComprobante']['comprobantes']['comprobante']['mensajes']['mensaje']['informacionAdicional'];
                } catch (Exception $ex) {

                    $estado = 'PENDIENTE';
                    $code = 501;
                    $mensaje = 'NO SE PUDO PROCESAR LA RESPUESTA DEL SRI';
                    $detalle = '';
                }

                LogSRI::create([
                    'document_id' => $this->documento->idComporbante,
                    'type' => 'ENVIO',
                    'status' => $estado,
                    'message' => json_encode($responseSRI)
                ])->save();

                $this->documento->update([
                    'regularizeShipping' => true,
                    'responseRegularizeShipping' => json_encode([
                        'code' => $code,
                        'description' => $mensaje,
                        'detalle' => $detalle
                    ])
                ]);
            }
        } else {

            $code = 110;
            $mensaje = 'ERROR AL PROCESAR RESPUESTA';

            LogSRI::create([

                'document_id' => $this->documento->idComporbante,
                'type' => 'ENVIO',
                'status' => 'ERROR',
                'message' => 'ERROR AL PROCESAR RESPUESTA'

            ])->save();

            $this->documento->update([
                'regularizeShipping' => false,
                'responseRegularizeShipping' => json_encode([
                    'code' => $code,
                    'description' => $mensaje,
                    'response' => $res
                ])
            ]);
        }
    }

    private function sendXmlSigned()
    {
        if (is_array($this->xmlSigned)) {
            Log::critical('no se puede leer contenido del archivo p12');
            return false;
        }
        $urlSri = '';
        if ($this->isDemo) {

            $urlSri = 'https://celcer.sri.gob.ec/comprobantes-electronicos-ws/RecepcionComprobantesOffline?wsdl';
        } else {

            $urlSri = 'https://cel.sri.gob.ec/comprobantes-electronicos-ws/RecepcionComprobantesOffline?wsdl';
        }

        $sender = new BillSender();
        return $sender->send($urlSri, $this->xmlSigned);
    }
    //VALIDAR DOCUEMENTOS EN EL SRI
    public function validateDocumentSRI()
    {
        $url = null;
        $integradorICG = new IntegradorService();


        if ($this->isDemo) {

            $url = "https://celcer.sri.gob.ec/comprobantes-electronicos-ws/AutorizacionComprobantesOffline?wsdl";
        } else {

            $url = "https://cel.sri.gob.ec/comprobantes-electronicos-ws/AutorizacionComprobantesOffline?wsdl";
        }

        $request = new AuthSri();
        $authSRI = $request->send($url, $this->documento->claveAcceso);



        if ($authSRI != '') {

            $mensaje = null;
            $code = null;
            $detalles = null;

            if ($authSRI['RespuestaAutorizacionComprobante']['numeroComprobantes'] == 0 || $authSRI['RespuestaAutorizacionComprobante']['numeroComprobantes'] == '0') {
                $this->documento->update([
                    'idEstado' => '01'
                ]);
                return false;
            }
            $estado = $authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['estado'];

            LogSRI::create([
                'document_id' => $this->documento->idComporbante,
                'type' => 'CONSULTA',
                'status' => $estado,
                'message' => json_encode($authSRI)
            ])->save();

            if ($estado == 'RECHAZADA') {

                //$this->updateStateDocuments(self::REJECTED);
                $this->documento->update([
                    'idEstado' => self::REJECTED
                ]);

                $code = $authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['mensajes']['mensaje']['identificador'];
                $mensaje = $authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['mensajes']['mensaje']['mensaje'];
                $detalles = $authSRI;
            } elseif ($estado == 'AUTORIZADO') {

                $fechaAutorizado = $authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['fechaAutorizacion'];
                $fechaArray = explode('T', $fechaAutorizado);

                $this->documento->idEstado = self::ACCEPTED;
                $this->documento->send_email = true;
                $this->documento->dateAuthorization = $fechaArray[0];
                $this->documento->timeAuthorization = substr($fechaArray[1], 0, 8);
                $this->documento->update();
                $code = 200;
                $mensaje = 'DOCUMENTO AUTORIZADO POR EL SRI';
                $documento = new \SimpleXMLElement('<autorizacion/>');

                // Función para convertir el array a XML recursivamente
                $this->arrayToXmlHelper($authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion'], $documento);

                $nombre = "autorizados/" . $this->claveAccesoDateFolder($this->documento->claveAcceso) . $this->documento->claveAcceso . ".xml";
                Storage::disk('tenant')->put($nombre, $documento->asXML());
                $tipodoc = '';

                if ($this->documento->tipoComprobante == 1) {
                    $tipodoc = 'invoice';
                    $this->doc_type = '01';
                    $integradorICG->updateFacturaVenta($this->company, $this->documento->claveAcceso);
                }

                if ($this->documento->tipoComprobante == 3) {
                    $tipodoc = 'invoice';
                    $this->doc_type = '03';

                    $integradorICG->updateLiquidacionCompra($this->company, $this->documento->claveAcceso);
                }

                if ($this->documento->tipoComprobante == 4) {

                    $tipodoc = 'note';
                    $this->doc_type = '04';
                    $integradorICG->updateFacturaVenta($this->company, $this->documento->claveAcceso);
                }
                if ($this->documento->tipoComprobante == 5) {

                    $tipodoc = 'debit';
                    $this->doc_type = '05';
                }
                if ($this->documento->tipoComprobante == 7) {

                    $tipodoc = 'retention';
                    $this->doc_type = '07';
                    $integradorICG->updateRetention($this->company, $this->documento->claveAcceso);
                }
                if ($this->documento->tipoComprobante == 6) {

                    $tipodoc = 'guide';
                    $this->doc_type = '06';
                }

                $this->actions['format_pdf'] = 'blank';
                $this->createPdf($this->documento, $tipodoc, 'a4');
            } elseif ($estado == 'NO AUTORIZADO') {

                $this->documento->update([
                    'idEstado' => self::NOACCEPTED
                ]);

                $code = $authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['mensajes']['mensaje']['identificador'];
                $mensaje = $authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['mensajes']['mensaje']['mensaje'];
                $detalles = trim($authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['mensajes']['mensaje']['informacionAdicional']);
            } else {

                if ($authSRI['RespuestaAutorizacionComprobante']['numeroComprobantes'] > 0) {

                    $code = $authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['mensajes']['mensaje']['identificador'];
                    $mensaje = $authSRI['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['mensajes']['mensaje']['mensaje'];
                    $detalles = $authSRI;
                } else {

                    $this->documento->update([
                        'idEstado' => self::REGISTERED
                    ]);
                    $code = 500;
                    $mensaje = 'NO SE ENCONTRO EL DOCUMENTO EN EL SISTEMA DEL SRI';
                }
            }

            $this->documento->update([
                'regularizeShipping' => true,
                'responseRegularizeShipping' => json_encode([
                    'code' => $code,
                    'description' => $mensaje,
                    'detalles' => $detalles,
                ])
            ]);
        } else {

            LogSRI::create([
                'document_id' => $this->documento->idComporbante,
                'type' => 'CONSULTA',
                'status' => null,
                'message' => json_encode($authSRI)
            ])->save();

            $this->documento->update([
                'regularizeShipping' => false,
                'responseRegularizeShipping' => json_encode([
                    'code' => 500,
                    'description' => 'NO SE PUDO VALIDAR EL DOCUMENTO EN EL SRI'
                ])
            ]);
        }
    }

    private function arrayToXmlHelper($data, &$xml)
    {
        foreach ($data as $key => $value) {
            if (is_array($value)) {
                // Si es un array, llamar recursivamente la función
                $subnode = $xml->addChild($key);
                $this->arrayToXmlHelper($value, $subnode);
            } else {
                // Si es un valor simple, agregar como nodo de texto
                if ($key === 'comprobante') {
                    // Crear un nodo para el elemento 'comprobante'
                    $child = $xml->addChild($key);

                    // Convertir el valor a CDATA y agregarlo como texto del elemento
                    $dom = dom_import_simplexml($child);
                    $dom->appendChild($dom->ownerDocument->createCDATASection($value));
                } else {
                    $xml->addChild($key, htmlspecialchars($value, ENT_XML1));
                }
            }
        }
    }

    private function setPathCertificate()
    {

        if ($this->isOse) {
            $this->pathCertificate = storage_path('app' . DIRECTORY_SEPARATOR .
                'certificates' . DIRECTORY_SEPARATOR . $this->company->certificate);
        }

        if ($this->isSRI) {

            $this->pathCertificate = storage_path('app' . DIRECTORY_SEPARATOR . 'certificates' . DIRECTORY_SEPARATOR . $this->company->certificate);
        } else {
            if ($this->isDemo) {
                $this->pathCertificate = app_path('CoreFacturalo' . DIRECTORY_SEPARATOR .
                    'WS' . DIRECTORY_SEPARATOR .
                    'Signed' . DIRECTORY_SEPARATOR .
                    'Resources' . DIRECTORY_SEPARATOR .
                    'certificate.pem');
            } else {
                $this->pathCertificate = storage_path('app' . DIRECTORY_SEPARATOR .
                    'certificates' . DIRECTORY_SEPARATOR . $this->company->certificate);
            }
        }
    }

    public function validar_clave($clave)
    {
        if ($clave == "") {
            $verificado = false;
            return $verificado;
        }

        $x = 2;
        $sumatoria = 0;
        for ($i = strlen($clave) - 1; $i >= 0; $i--) {
            if ($x > 7) {
                $x = 2;
            }
            $sumatoria = $sumatoria + ($clave[$i] * $x);
            $x++;
        }
        $digito = $sumatoria % 11;
        $digito = 11 - $digito;

        switch ($digito) {
            case 10:
                $digito = "1";
                break;
            case 11:
                $digito = "0";
                break;
        }

        return $digito;
    }

    public function createPdf($documento = null, $type = null, $format = null, $output = 'pdf')
    {

        ini_set("pcre.backtrack_limit", "5000000");
        $template = new Template();
        $pdf = new Mpdf();

        $format_pdf = $this->actions['format_pdf'] ?? null;
        $this->type = ($type != null) ? $type : $this->type;
        $this->documento = ($documento != null) ? $documento : $this->documento;

        $details = DetalleFacturaElectronica::where('idComporbante', $documento->idComporbante)->get();
        if ($this->type == '06' || $this->documento->tipoComprobante == 6) {
            $details = Destinatarios::where('id_documento', $documento->idComporbante)
                ->get();
        }

        $returnSales = (object) $this->documento->getCollectionData();
        $format_pdf = ($format != null) ? $format : $format_pdf;
        $base_pdf_template = 'default';
        $pdf_margin_top = 15;
        $pdf_margin_right = 15;
        $pdf_margin_bottom = 15;
        $pdf_margin_left = 15;

        if (in_array($base_pdf_template, ['full_height', 'default3_new', 'rounded'])) {
            $pdf_margin_top = 5;
            $pdf_margin_right = 5;
            $pdf_margin_bottom = 5;
            $pdf_margin_left = 5;
        }
        if ($base_pdf_template === 'blank' && in_array($this->documento->tipoComprobante, ['09'])) {
            $pdf_margin_top = 15;
            $pdf_margin_right = 5;
            $pdf_margin_bottom = 15;
            $pdf_margin_left = 14;
        }

        $this->company->terms = $this->configuration->terms_condition_sale;

        $html = $template->pdf($base_pdf_template, $this->type, $this->company, $this->documento, $details, $returnSales, $format_pdf);

        if ($format_pdf === 'a5') {

            $company_name      = (strlen($this->company->name) / 20) * 10;
            $company_address   = (strlen($this->documento->establishment->address) / 30) * 10;
            $company_number    = $this->documento->establishment->telephone != '' ? '10' : '0';
            $customer_name     = strlen($this->documento->customer->name) > '25' ? '10' : '0';
            $customer_address  = (strlen($this->documento->customer->address) / 200) * 10;
            $p_order           = $this->documento->purchase_order != '' ? '10' : '0';

            $total_exportation = $this->documento->total_exportation != '' ? '10' : '0';
            $total_free        = $this->documento->total_free != '' ? '10' : '0';
            $total_unaffected  = $this->documento->total_unaffected != '' ? '10' : '0';
            $total_exonerated  = $this->documento->total_exonerated != '' ? '10' : '0';
            $total_taxed       = $this->documento->total_taxed != '' ? '10' : '0';
            $total_plastic_bag_taxes       = $this->documento->total_plastic_bag_taxes != '' ? '10' : '0';
            $quantity_rows     = count($this->documento->items);

            $extra_by_item_description = 0;
            $discount_global = 0;
            foreach ($this->documento->items as $it) {
                if (strlen($it->item->description) > 100) {
                    $extra_by_item_description += 24;
                }
                if ($it->discounts) {
                    $discount_global = $discount_global + 1;
                }
            }
            $legends = $this->documento->legends != '' ? '10' : '0';


            $height = ($quantity_rows * 8) +
                ($discount_global * 3) +
                $company_name +
                $company_address +
                $company_number +
                $customer_name +
                $customer_address +
                $p_order +
                $legends +
                $total_exportation +
                $total_free +
                $total_unaffected +
                $total_exonerated +
                $total_taxed;
            $diferencia = 148 - (float)$height;

            $pdf = new Mpdf([
                'mode' => 'utf-8',
                'format' => [
                    210,
                    $diferencia + $height
                ],
                'margin_top' => 2,
                'margin_right' => 5,
                'margin_bottom' => 0,
                'margin_left' => 5
            ]);
        } else {

            if ($base_pdf_template === 'brand') {
                $pdf_margin_top = 93.7;
                $pdf_margin_bottom = 74;
            }
            if ($base_pdf_template === 'blank' && in_array($this->documento->tipoComprobante, ['09'])) {
                $pdf_margin_top = 110;
                $pdf_margin_bottom = 125;
            }

            $pdf_font_regular = config('tenant.pdf_name_regular');
            $pdf_font_bold = config('tenant.pdf_name_bold');

            if ($pdf_font_regular != false) {
                $defaultConfig = (new ConfigVariables())->getDefaults();
                $fontDirs = $defaultConfig['fontDir'];

                $defaultFontConfig = (new FontVariables())->getDefaults();
                $fontData = $defaultFontConfig['fontdata'];

                $pdf = new Mpdf([
                    'fontDir' => array_merge($fontDirs, [
                        app_path('CoreFacturalo' . DIRECTORY_SEPARATOR . 'Templates' .
                            DIRECTORY_SEPARATOR . 'pdf' .
                            DIRECTORY_SEPARATOR . $base_pdf_template .
                            DIRECTORY_SEPARATOR . 'font')
                    ]),
                    'fontdata' => $fontData + [
                        'custom_bold' => [
                            'R' => $pdf_font_bold . '.ttf',
                        ],
                        'custom_regular' => [
                            'R' => $pdf_font_regular . '.ttf',
                        ],
                    ],
                    'margin_top' => $pdf_margin_top,
                    'margin_right' => $pdf_margin_right,
                    'margin_bottom' => $pdf_margin_bottom,
                    'margin_left' => $pdf_margin_left,
                ]);
            } else {
                $pdf = new Mpdf([
                    'margin_top' => $pdf_margin_top,
                    'margin_right' => $pdf_margin_right,
                    'margin_bottom' => $pdf_margin_bottom,
                    'margin_left' => $pdf_margin_left
                ]);
            }
        }

        $path_css = app_path('CoreFacturalo' . DIRECTORY_SEPARATOR . 'Templates' .
            DIRECTORY_SEPARATOR . 'pdf' .
            DIRECTORY_SEPARATOR . $base_pdf_template .
            DIRECTORY_SEPARATOR . 'style.css');

        $stylesheet = file_get_contents($path_css);


        // if (($format_pdf != 'ticket') AND ($format_pdf != 'ticket_58') AND ($format_pdf != 'ticket_50')) {
        // dd($base_pdf_template);// = config(['tenant.pdf_template'=> $configuration]);
        if (config('tenant.pdf_template_footer')) {
            $html_footer = '';
            if (($format_pdf != 'ticket') and ($format_pdf != 'ticket_58') and ($format_pdf != 'ticket_50')) {
                $html_footer = $template->pdfFooter($base_pdf_template, in_array($this->documento->document_type_id, ['09']) ? null : $this->documento);
                $html_footer_legend = "";
            }
            // dd($this->configuration->legend_footer && in_array($this->documento->document_type_id, ['01', '03']));
            // se quiere visuzalizar ahora la legenda amazona en todos los formatos
            $html_footer_legend = '';
            if ($this->configuration->legend_footer && in_array($this->documento->document_type_id, ['01', '03'])) {
                $html_footer_legend = $template->pdfFooterLegend($base_pdf_template, $documento);
            }

            $pdf->SetHTMLFooter($html_footer . $html_footer_legend);
        }
        //            $html_footer = $template->pdfFooter();
        //            $pdf->SetHTMLFooter($html_footer);
        // }


        if ($base_pdf_template === 'blank' && in_array($this->documento->tipoComprobante, [9])) {

            $html_header = $template->pdfHeader($base_pdf_template, $this->company, $this->documento);
            $pdf->SetHTMLHeader($html_header);

            $html_footer_blank = $template->pdfFooterBlank($base_pdf_template, $this->documento);
            $pdf->SetHTMLFooter($html_footer_blank);
        }

        if ($base_pdf_template === 'default3_929' && in_array($this->documento->tipoComprobante, [3, 1])) {
            // Solo boleta o factura #929
            $html_header = $template->pdfHeader($base_pdf_template, $this->company, $this->documento);
            $pdf->SetHTMLHeader($html_header);
            $html_footer = $template->pdfFooter($base_pdf_template, $this->documento);
            $pdf->SetHTMLFooter($html_footer);
        }

        // para impresion automatica se requiere el resultado en html ya que es lo que se envia a las funciones de impresión
        if ($output == 'html') {
            $path_html = app_path('CoreFacturalo' . DIRECTORY_SEPARATOR . 'Templates' .
                DIRECTORY_SEPARATOR . 'pdf' .
                DIRECTORY_SEPARATOR . 'ticket_html.css');
            $ticket_html = file_get_contents($path_html);
            $pdf->WriteHTML($ticket_html, HTMLParserMode::HEADER_CSS);
            $pdf->WriteHTML($html, HTMLParserMode::HTML_BODY);
            return "<style>" . $ticket_html . $stylesheet . "</style>" . $html;
        } else {
            $pdf->WriteHTML($stylesheet, HTMLParserMode::HEADER_CSS);
            $pdf->WriteHTML($html, HTMLParserMode::HTML_BODY);
        }

        $nombre = "pdf/" . $this->claveAccesoDateFolder($this->documento->claveAcceso) . $this->documento->claveAcceso . ".pdf";
        Storage::disk('tenant')->put($nombre, $pdf->output('', 'S'));
        return $this;
    }

    public function sendEmail2()
    {
        $company = $this->company;
        $documento = $this->documento;
        $email = '';
        if (strpos($this->documento->correo, '|')) {
            $email = explode('|', $this->documento->correo);
            $email = trim($email[0]);
        } else {
            $email = trim($this->documento->correo);
        }
        $mailable = new DocumentEmail($company, $documento);
        $id =  $documento->id;
        $model = __FILE__ . ";;" . __LINE__;
        EmailController::SendMail($email, $mailable, $id, $model);
    }

    public function sendEmail3($id)
    {
        $company = $this->company;
        $documento = CabeceraDocumentoElectronica::find($id);

        // Validar correo
        $email = trim($documento->correo);
        if (!filter_var($email, FILTER_VALIDATE_EMAIL) && !str_contains($email, ';')) {
            $documento->update(['emailed' => true]);
            return ["success" => false, "message" => "Correo $email no válido"];
        }

        // Procesar lista de correos
        $emails = array_filter(array_map('trim', preg_split('/[;, ]+/', $email)), function ($mail) {
            return filter_var($mail, FILTER_VALIDATE_EMAIL) && !str_contains($mail, 'sincorreo');
        });

        if (empty($emails)) {
            $documento->update(['emailed' => true]);
            return ["success" => false, "message" => "No hay correos válidos"];
        }

        $mailable = new DocumentEmail($company, $documento);
        Configuration::setConfigSmtpMail();

        // Validar que el mailable tenga contenido
        if (empty($documento) || empty($documento->correo) || !$mailable) {
            $documento->update(['emailed' => true]);
            return ["success" => false, "message" => "No se pudo generar el correo electrónico"];
        }

        // Usar el mailer configurado por Laravel, no crear uno nuevo si no es necesario

        try {

            Mail::to($emails)->send($mailable);
            $documento->update(['emailed' => true]);
            return ["success" => true];
        } catch (\Throwable $e) {

            Log::error("Error al enviar correo: " . $e->getMessage());
            $documento->update(['emailed' => true]);
            return ["success" => false, "message" => $e->getMessage()];
        }
    }

    public function sendEmail(DocumentEmailRequest $request)
    {

        $company = Company::active();
        $documento = CabeceraDocumentoElectronica::find($request->input('id'));
        $email = trim($request->input('customer_email'));

        $mail = explode(';', str_replace([',', ' '], [';', ''], $email));
        $mails = [];
        if (!empty($mail) && count($mail) > 0) {
            foreach ($mail as $email) {
                $email = trim($email);
                if (!empty($email)) {
                    $mails[] = $email;
                }
            }
            $email = implode(';', $mails);
        }
        $email = explode(';', $email);

        $mailable = new DocumentEmail($company, $documento);
        Configuration::setConfigSmtpMail();

        $dsn = 'smtp://'.Config::get('mail.username').':'.Config::get('mail.password').'@'.Config::get('mail.host').':'.Config::get('mail.port').'?verify_peer=0';

        $transport = Transport::fromDsn($dsn);
        $mailer = new \Illuminate\Mail\Mailer('ManualMail',
            app('view'),
            $transport,
            app('events')
        );
        
        $mailer->setSymfonyTransport($transport);

        //Mail::setMailer($mailer);
        $mailer->to($email)->send($mailable);

        return ["success" => true];
    }

    public function sendEmailNotification($documents)
    {
        $company = $this->company;
        $documento = $documents;
        $email = $company->user_pse;
        $mailable = new DocumentEmailNotification($company, $documento,2);
        // Validar correo
        if (!filter_var($email, FILTER_VALIDATE_EMAIL) && !str_contains($email, ';')) {
            return ["success" => false, "message" => "Correo $email no válido"];
        }

        // Procesar lista de correos
        $emails = array_filter(array_map('trim', preg_split('/[;, ]+/', $email)), function ($mail) {
            return filter_var($mail, FILTER_VALIDATE_EMAIL) && !str_contains($mail, 'sincorreo');
        });

        if (empty($emails)) {

            return ["success" => false, "message" => "No hay correos válidos"];
        }

        $mailable = new DocumentEmailNotification($company, $documento,2);
        Configuration::setConfigSmtpMail();

        // Validar que el mailable tenga contenido
        if (empty($documento) || !$mailable) {

            return ["success" => false, "message" => "No se pudo generar el correo electrónico"];
        }

        // Usar el mailer configurado por Laravel, no crear uno nuevo si no es necesario
        try {

            $primaryEmail = array_shift($emails);
            $mailer = Mail::to($primaryEmail);
            if (!empty($emails)) {
                $mailer->cc(array_values($emails));
            }

            $mailer->send($mailable);
            return ["success" => true];

        } catch (\Throwable $e) {

            Log::error("Error al enviar correo: " . $e->getMessage());
            return ["success" => false, "message" => $e->getMessage()];
        }
    }

    public function sendEmailNotificationReturned($documents)
    {
        $company = $this->company;
        $documento = $documents;
        $email = $company->user_pse;

        // Procesar lista de correos multivalor
        $emails = array_filter(array_map('trim', preg_split('/[;,\s]+/', $email)), function ($mail) {
            return filter_var($mail, FILTER_VALIDATE_EMAIL) && !str_contains($mail, 'sincorreo');
        });

        if (empty($emails)) {
            return ["success" => false, "message" => "No hay correos válidos"];
        }

        $mailable = new DocumentEmailNotification($company, $documento,3);
        Configuration::setConfigSmtpMail();

        // Validar que el mailable tenga contenido
        if (empty($documento) || !$mailable) {

            return ["success" => false, "message" => "No se pudo generar el correo electrónico"];
        }

        // Usar el mailer configurado por Laravel, no crear uno nuevo si no es necesario
        try {

            $primaryEmail = array_shift($emails);
            $mailer = Mail::to($primaryEmail);
            if (!empty($emails)) {
                $mailer->cc(array_values($emails));
            }

            $mailer->send($mailable);
            return ["success" => true];
            
        } catch (\Throwable $e) {

            Log::error("Error al enviar correo: " . $e->getMessage());
            return ["success" => false, "message" => $e->getMessage()];
        }
    }

}
