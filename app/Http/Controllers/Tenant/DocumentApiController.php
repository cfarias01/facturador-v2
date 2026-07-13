<?php

namespace App\Http\Controllers\Tenant;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\System\ClientesFacturador;
use App\Models\Tenant\CabeceraDocumentoElectronica;
use App\Models\Tenant\Company;
use App\Models\Tenant\Destinatarios;
use App\Models\Tenant\Destinatarios_detalle;
use App\Models\Tenant\DetalleFacturaElectronica;
use App\Models\Tenant\DetalleRetencionElectronica;
use App\Models\Tenant\StateType;
use Doctrine\DBAL\Driver\PDO\Exception as PDOException;
use Exception;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\Log;

class DocumentApiController extends Controller
{
    protected $company;

    public function __construct()
    {
        $this->company = Company::active();
    }

    private function validateToken()
    {
        if (isset($this->company->tokenApi) && trim($this->company->tokenApi) != '') {
            return true;
        } else {
            return false;
        }
    }

    public function createClient(string $nombre, string $cedula, string $apellido, string $email = null, string $telefono = null, string $direccion = null)
    {
        try {
            $validar = ClientesFacturador::where('cedula', $cedula)->first();

            if ($validar) {

                return response()->json([
                    'status' => 'success',
                    'message' => 'Cliente creado exitosamente',
                ]);
            } else {

            ClientesFacturador::updateOrCreate(
                ['cedula' => $cedula],
                [
                    'nombre' => $nombre,
                    'apellido' => $apellido,
                    'email' => $email,
                    'telefono' => $telefono,
                    'direccion' => $direccion
                ]
            );

                return response()->json([
                    'status' => 'success',
                    'message' => 'Cliente creado exitosamente',
                ]);
            }
        } catch (PDOException $e) {

            return response()->json([
                'status' => 'error',
                'message' => 'Error al crear el cliente: ' . $e->getMessage()
            ], 500);
        }
    }

    public function createInvoice(Request $request)
    {

        $jsonError = null;
        $result = null;
        $whileResult = true;
        $structureError = null;
        $detalleError = null;
        $docID = null;
        $result = null;
        $secuencialDoc = null;
        $rucEmpresa = null;

        try {

            //Log::info($request->all());

            if (!isset($request->token) || !isset($request->data)) {
                $result = ['Response' => 'Requerimiento malformado, el parametro token y data son obligatorios'];
                return $result;
            }
            $validar = $this->validateToken();

            if ($validar == false) {
                $result = ['Response' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
                return $result;
            }

            $token = base64_decode($request->token, true);
            //Log::info($token);

            if ($token != $this->company->tokenApi) {
                $result = ['Response' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
                return $result;
            }

            $datos = json_decode(base64_decode($request->data, true), true);
            $datos = $datos[0];

            //Log::info(json_last_error_msg());
            Log::info("Datos a procesar : " . $datos['establecimiento']);

            switch (json_last_error()) {

                case JSON_ERROR_NONE:
                    $jsonError = "Sin errores";
                    $result = true;
                    break;
                case JSON_ERROR_DEPTH:
                    $jsonError = "Profundidad maxima superada en nodos";
                    $result = false;
                    break;
                case JSON_ERROR_STATE_MISMATCH:
                    $jsonError = "JSON inválido o malformado";
                    $result = false;
                    break;
                case JSON_ERROR_CTRL_CHAR:
                    $jsonError = "Error en el control de caracteres";
                    $result = false;
                    break;
                case JSON_ERROR_SYNTAX:
                    $jsonError = "Error de Syntaxis";
                    $result = false;
                    break;
                case JSON_ERROR_UTF8:
                    $jsonError = "Caracter UTF-8 malformado";
                    $result = false;
                    break;
                default:
                    $jsonError = "Error desconocido";
                    $result = false;
                    break;
            }

            $facturaValidador = CabeceraDocumentoElectronica::where('idComporbante', 'F' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'])->get();
            if (count($facturaValidador) > 0) {
                $result = ['Response' => 'El Documento : F' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'] . ' ya se encuentra registrado en el sistema'];
                return $result;
            }

            if ($result) {

                try {

                    $fcatura = new CabeceraDocumentoElectronica();
                    while ($whileResult == true) {

                        if (isset($datos['idInterno'])) {
                            $fcatura->idInterno = $datos['idInterno'];
                        }
                        if (isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) > 0) {
                            $fcatura->fecha = $datos['fecha'];
                        }
                        if (!isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'fecha' es obligatorio y debe cumplir el formato de  YYYY-MM-DD";
                            break;
                        }
                        if (isset($datos['cliente']) && $datos['cliente'] != '') {
                            $fcatura->cliente = $datos['cliente'];
                        }
                        if (!isset($datos['cliente']) && $datos['cliente'] == '') {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'cliente' es obligatorio";
                            break;
                        }
                        if (isset($datos['direccion']) && $datos['direccion'] != '') {
                            $fcatura->direccion = $datos['direccion'];
                        }
                        if (!isset($datos['direccion']) && $datos['direccion'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'direccion' es obligatorio";
                            break;
                        }
                        if (isset($datos['telefono']) && $datos['telefono'] != '') {
                            $fcatura->telefono = $datos['telefono'];
                        }

                        if (!isset($datos['telefono']) && $datos['telefono'] == '') {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'telefono' es obligatorio";
                            break;
                        }
                        if (isset($datos['ruc']) && $datos['ruc'] != '') {
                            $fcatura->ruc = $datos['ruc'];
                        }

                        if (!isset($datos['ruc']) && $datos['ruc'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ruc/ci' del cliente es obligatorio";
                            break;
                        }
                        if (isset($datos['tipoComprobante']) && $datos['tipoComprobante'] != '' && in_array($datos['tipoComprobante'], [1])) {
                            $fcatura->tipoComprobante = $datos['tipoComprobante'];
                        }

                        if (!isset($datos['tipoComprobante']) && $datos['tipoComprobante'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'tipoComprobante' es obligatorio";
                            break;
                        }
                        if (in_array($datos['tipoComprobante'], [1]) == false) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "EL tipo de archivo " . $datos['tipoComprobante'] . " no puede ser procesado en este servicio, por favor utiliza el servicio correspondiente";
                            break;
                        }

                        if (isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] != '') {
                            $fcatura->tipoIdentificador = $datos['tipoIdentificador'];
                        }

                        if (!isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'tipoIdentificador' es obligatorio";
                            break;
                        }

                        if (isset($datos['correo']) && $datos['correo'] != '') {
                            $fcatura->correo = $datos['correo'];
                        }
                        if (!isset($datos['correo']) && $datos['correo'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'correo' es obligatorio";
                            break;
                        }

                        if (isset($datos['establecimiento']) && $datos['establecimiento'] != '' && strlen($datos['establecimiento']) == 3) {
                            $fcatura->establecimiento = $datos['establecimiento'];
                        }

                        if (!isset($datos['establecimiento']) || $datos['establecimiento'] == '' || strlen($datos['establecimiento']) != 3) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'establecimiento' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['ptoEmision']) && $datos['ptoEmision'] != '' && strlen($datos['ptoEmision']) == 3) {
                            $fcatura->ptoEmision = $datos['ptoEmision'];
                        }

                        if (!isset($datos['ptoEmision']) || $datos['ptoEmision'] == '' || strlen($datos['ptoEmision']) != 3) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ptoEmision' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['rucEmpresa']) && $datos['rucEmpresa'] != '' && strlen($datos['rucEmpresa']) == 13) {
                            $fcatura->rucEmpresa = $datos['rucEmpresa'];
                        }

                        if (!isset($datos['rucEmpresa']) || $datos['rucEmpresa'] == '' || strlen($datos['rucEmpresa']) != 13) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'rucEmpresa' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['secuencial']) && $datos['secuencial'] != '' && strlen($datos['secuencial']) == 9) {
                            $fcatura->secuencial = $datos['secuencial'];
                        }
                        if (!isset($datos['secuencial']) || $datos['secuencial'] == '' || strlen($datos['secuencial']) != 9) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'secuencial' es obligatorio y debe ser de 9 dígitos";
                            break;
                        }

                        if (isset($datos['ambiente']) && $datos['ambiente'] != '' && strlen($datos['ambiente']) == 1) {
                            $fcatura->ambiente = $datos['ambiente'];
                        }

                        if (!isset($datos['ambiente']) || $datos['ambiente'] == '' || strlen($datos['ambiente']) != 1) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ambiente' es obligatorio y solo es un dígito";
                            break;
                        }

                        if (isset($datos['razonSocial']) && $datos['razonSocial'] != '') {
                            $fcatura->razonSocial = $datos['razonSocial'];
                        }

                        if (!isset($datos['razonSocial']) || $datos['razonSocial'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'razonSocial' es obligatorio";
                            break;
                        }

                        if (isset($datos['nombreComercial']) && $datos['nombreComercial'] != '') {
                            $fcatura->nombreComercial = $datos['nombreComercial'];
                        }

                        if (!isset($datos['nombreComercial']) || $datos['nombreComercial'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'nombreComercial' es obligatorio";
                            break;
                        }

                        if (isset($datos['direccionMatriz']) && $datos['direccionMatriz'] != '') {
                            $fcatura->direccionMatriz = $datos['direccionMatriz'];
                        }
                        if (!isset($datos['direccionMatriz']) || $datos['direccionMatriz'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'direccionMatriz' es obligatorio";
                            break;
                        }

                        if (isset($datos['direccionEstablecimiento']) && $datos['direccionEstablecimiento'] != '') {
                            $fcatura->direccionEstablecimiento = $datos['direccionEstablecimiento'];
                        }

                        if (!isset($datos['direccionEstablecimiento']) || $datos['direccionEstablecimiento'] == '') {
                            $fcatura->direccionEstablecimiento = $datos['direccionMatriz'];
                        }

                        if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '') {
                            $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                        }

                        if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'obligadoContabilidad' es obligatorio";
                            break;
                        }

                        if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '' && strlen($datos['obligadoContabilidad']) == 2 && in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no'])) {
                            $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                        }
                        if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '' || strlen($datos['obligadoContabilidad']) != 2 || in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no']) == false) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'obligadoContabilidad' es obligatorio, y solo se aceptan los terminos 'SI' o 'NO'";
                            break;
                        }

                        if (isset($datos['numeroCE']) && $datos['numeroCE'] != '') {
                            $fcatura->numeroCE = $datos['numeroCE'];
                        }

                        if (isset($datos['claveAcceso']) && $datos['claveAcceso'] != '') {
                            $fcatura->claveAcceso = $datos['claveAcceso'];
                        }

                        if (isset($datos['importeSinImpuestos']) && $datos['importeSinImpuestos'] != '' && is_numeric($datos['importeSinImpuestos']) > 0) {
                            $fcatura->importeSinImpuestos = $datos['importeSinImpuestos'];
                        }
                        if (!isset($datos['importeSinImpuestos']) || $datos['importeSinImpuestos'] == '' || is_numeric($datos['importeSinImpuestos']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'importeSinImpuestos' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            break;
                        }

                        if (isset($datos['descuento']) && is_numeric($datos['descuento']) > 0) {
                            $fcatura->descuento = $datos['descuento'];
                        }

                        if (!isset($datos['descuento']) || is_numeric($datos['descuento']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'descuento' es obligatorio, solo se aceptan valores de tipo DOUBLE, valor recibido : " . $datos['descuento'];
                            break;
                        }

                        if (isset($datos['importeTotal']) && $datos['importeTotal'] != '' && is_numeric($datos['importeTotal']) > 0) {
                            $fcatura->importeTotal = $datos['importeTotal'];
                        }
                        if (!isset($datos['importeTotal']) || $datos['importeTotal'] == '' || is_numeric($datos['importeTotal']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'importeTotal' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            break;
                        }

                        if (isset($datos['baseIva12']) && is_numeric($datos['baseIva12']) > 0) {
                            $fcatura->baseIva12 = $datos['baseIva12'];
                        }
                        if (isset($datos['baseIva12']) == false || is_numeric($datos['baseIva12']) < 1) {
                            //$result = false;
                            //$whileResult = false;
                            //$detalleError = "El campo 'baseIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE " . isset($datos['baseIva12']) . ' - ' . $datos['baseIva12'] . ' - ' . is_numeric($datos['baseIva12']);
                            //break;
                        }

                        if (isset($datos['valorIva12']) && is_numeric($datos['valorIva12']) > 0) {
                            $fcatura->valorIva12 = $datos['valorIva12'];
                        }

                        if (!isset($datos['valorIva12']) || is_numeric($datos['valorIva12']) < 1) {
                            //$result = false;
                            //$whileResult = false;
                            //$detalleError = "El campo 'valorIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            //break;
                        }

                        if (isset($datos['baseIva0'])  && is_numeric($datos['baseIva0']) > 0) {
                            $fcatura->baseIva0 = $datos['baseIva0'];
                        }

                        if (!isset($datos['baseIva0']) || is_numeric($datos['baseIva0']) < 1) {
                            //$result = false;
                            //$whileResult = false;
                            //$detalleError = "El campo 'baseIva0' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            //break;
                        }

                        if (isset($datos['adicionales']) && $datos['adicionales'] != '') {
                            $fcatura->adicionales = $datos['adicionales'];
                        }

                        if (isset($datos['fPagos']) && $datos['fPagos'] != '') {
                            $fcatura->fPagos = json_encode($datos['fPagos']);
                        }

                        if (isset($datos['propina']) && $datos['propina'] != '') {
                            $fcatura->propina = $datos['propina'];
                        }else{
                            $fcatura->propina = 0.00;
                        }

                        $fcatura->idComporbante = 'F' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'];
                        $fcatura->idEstado = '01';
                        $fcatura->orderNo =  $fcatura->secuencial;

                        $fcatura->save();
                        $docID = $fcatura->idComporbante;
                        $rucEmpresa = $fcatura->rucEmpresa;

                        if (isset($datos['Detalle']) == false || $datos['Detalle'] == '') {
                            $result = false;
                            $fcatura->delete();
                            $whileResult = false;
                            break;
                        }
                        

                        $detalles = $datos['Detalle'];
                        if(is_array($detalles)){
                            error_log("El campo Detalle es un array con " . count($detalles) . " elementos");
                        }else{
                            error_log("El campo Detalle no es un array o está vacío");
                            $detalles = json_decode($datos['Detalle'], true);
                        }
                        foreach ($detalles as $value) {
                            try {
                                $detalle = new DetalleFacturaElectronica();
                                $detalle->cantidad = ($value['cantidad'] && $value['cantidad'] > 0) ? $value['cantidad'] : null;
                                $detalle->item = ($value['item'] && trim($value['item']) != '') ? trim($value['item']) : '-';
                                $detalle->precioUnitario = (isset($value['precioUnitario'])) ? $value['precioUnitario'] : null;
                                $detalle->descuento = (isset($value['descuentoLinea'])) ? $value['descuentoLinea'] : null;
                                $detalle->total = (isset($value['total'])) ? $value['total'] : null;
                                $detalle->iva = $value['iva'];
                                $iva_code = 0;
                                switch (intVal($value['iva'])) {
                                    case 0:
                                        $iva_code = 0;
                                        break;
                                    case 5:
                                        $iva_code = 5;
                                        break;
                                    case 12:
                                        $iva_code = 2;
                                        break;
                                    case 14:
                                        $iva_code = 3;
                                        break;
                                    case 15:
                                        $iva_code = 4;
                                        break;
                                    case 8:
                                        $iva_code = 8;
                                        break;
                                }
                                $detalle->iva_code = $iva_code;
                                $detalle->ice = $value['ice'];
                                $detalle->irbpnr = $value['irbpnr'];
                                $detalle->codigoIce = $value['codigoIce'];
                                $detalle->codigoPorcentajeIce = $value['codigoPorcentajeIce'];
                                $detalle->baseImponibleIce = $value['baseImponibleIce'];
                                $detalle->tarifaIce = $value['tarifaIce'];
                                $detalle->ValorIce = $value['ValorIce'];
                                $detalle->codigoIrbpnr = $value['codigoIrbpnr'];
                                $detalle->codigoPorcentajeIrbpnr = $value['codigoPorcentajeIrbpnr'];
                                $detalle->baseImponibleIrbpnr = $value['baseImponibleIrbpnr'];
                                $detalle->tarifaIrbpnr = $value['tarifaIrbpnr'];
                                $detalle->valorIrbpnr = $value['valorIrbpnr'];
                                $detalle->idComporbante =  $fcatura->idComporbante;
                                $detalle->idLinea = $fcatura->idComporbante . '-' . $value['idlinea'];
                                $detalle->codItem = ($value['codItem'] && trim($value['codItem']) != '') ? trim($value['codItem']) : null;
                                $detalle->lote = (isset($value['lote']) && trim($value['lote']) != '') ? trim($value['lote']) : null;
                                $detalle->fecha_creado = (isset($value['fecha_elaborado']) && trim($value['fecha_elaborado']) != '') ? trim($value['fecha_elaborado']) : null;
                                $detalle->fecha_vencimiento = (isset($value['fecha_vencimiento']) && trim($value['fecha_vencimiento']) != '') ? trim($value['fecha_vencimiento']) : null;
                                $detalle->save();
                                $result = true;
                                
                            } catch (QueryException $exPdo) {

                                $fcatura->delete();
                                $result = false;
                                $docID = "N/A";
                                $detalleError = $exPdo;
                                Log::error('Error al tratar de generar detalle de la factura : ' . json_encode($exPdo));
                                break;
                            }
                        }

                        $secuencialDoc = $fcatura->secuencial;
                        $this->createClient($fcatura->cliente, $fcatura->ruc, $fcatura->razonSocial, $fcatura->correo, $fcatura->telefono, $fcatura->direccion);
                        $whileResult = false;
                    }
                } catch (Exception $ex) {

                    $result = false;
                    $structureError = $ex->getMessage();
                    $docID = "N/A";
                    Log::error('Error al tratar de generar la factura : ' . $ex->getMessage());
                }

                $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID, 'secuencial' => $secuencialDoc, 'rucEmpresa' => $rucEmpresa];
            } else {

                $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
            }
            return $result;
        } catch (Exception $ex) {
            $result = ['Result' => 'No se pudo procesar su requerimiento, ERROR: ' . $ex->getMessage()];
            return $result;
        }
    }

    public function createNote(Request $request)
    {

        if (!isset($request->token) || !isset($request->data)) {
            $result = ['Result' => 'Requerimiento malformado, el parametro token y data son obligatorios'];
            return $result;
        }
        $validar = $this->validateToken();
        if ($validar == false) {
            $result = ['Result' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
            return $result;
        }

        $token = base64_decode($request->token, true);

        if ($token != $this->company->tokenApi) {
            $result = ['Result' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
            return $result;
        }

        $datos = json_decode(base64_decode($request->data, true), true);
        $datos = $datos[0];

        $jsonError = null;
        $result = null;
        $whileResult = true;
        $structureError = null;
        $detalleError = null;
        $docID = null;
        $result = null;
        $secuencialDoc = null;
        $rucEmpresa = null;

        switch (json_last_error()) {
            case JSON_ERROR_NONE:
                $jsonError = "Sin errores";
                $result = true;
                break;
            case JSON_ERROR_DEPTH:
                $jsonError = "Profundidad maxima superada en nodos";
                $result = false;
                break;
            case JSON_ERROR_STATE_MISMATCH:
                $jsonError = "JSON inválido o malformado";
                $result = false;
                break;
            case JSON_ERROR_CTRL_CHAR:
                $jsonError = "Error en el control de caracteres";
                $result = false;
                break;
            case JSON_ERROR_SYNTAX:
                $jsonError = "Error de Syntaxis";
                $result = false;
                break;
            case JSON_ERROR_UTF8:
                $jsonError = "Caracter UTF-8 malformado";
                $result = false;
                break;
            default:
                $jsonError = "Error desconocido";
                $result = false;
                break;
        }

        $docuemntoValidador = CabeceraDocumentoElectronica::where('idComporbante', 'N' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'])->get();
        if (count($docuemntoValidador) > 0) {
            $result = ['Result' => 'El Documento : N' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'] . ' ya se encuentra registrado en el sistema'];
            return $result;
        }

        if ($result) {

            try {

                $fcatura = new CabeceraDocumentoElectronica();
                while ($whileResult == true) {

                    if (isset($datos['idInterno'])) {
                        $fcatura->idInterno = $datos['idInterno'];
                    }

                    if (isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) > 0) {
                        $fcatura->fecha = $datos['fecha'];
                    }
                    if (!isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fecha' es obligatorio y debe cumplir el formato de  YYYY-MM-DD";
                        break;
                    }
                    if (isset($datos['cliente']) && $datos['cliente'] != '') {
                        $fcatura->cliente = $datos['cliente'];
                    }
                    if (!isset($datos['cliente']) && $datos['cliente'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'cliente' es obligatorio";
                        break;
                    }
                    if (isset($datos['direccion']) && $datos['direccion'] != '') {
                        $fcatura->direccion = $datos['direccion'];
                    }
                    if (!isset($datos['direccion']) && $datos['direccion'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccion' es obligatorio";
                        break;
                    }
                    if (isset($datos['telefono']) && $datos['telefono'] != '') {
                        $fcatura->telefono = $datos['telefono'];
                    }

                    if (!isset($datos['telefono']) && $datos['telefono'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'telefono' es obligatorio";
                        break;
                    }
                    if (isset($datos['ruc']) && $datos['ruc'] != '') {
                        $fcatura->ruc = $datos['ruc'];
                    }

                    if (!isset($datos['ruc']) && $datos['ruc'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ruc/ci' del cliente es obligatorio";
                        break;
                    }
                    if (isset($datos['tipoComprobante']) && $datos['tipoComprobante'] != '') {
                        $fcatura->tipoComprobante = $datos['tipoComprobante'];
                    }

                    if (!isset($datos['tipoComprobante']) && $datos['tipoComprobante'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoComprobante' es obligatorio";
                        break;
                    }

                    if (in_array($datos['tipoComprobante'], [4]) == false) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "EL tipo de archivo " . $datos['tipoComprobante'] . " no puede ser procesado en este servicio, por favor utiliza el servicio correspondiente";
                        break;
                    }

                    if (isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] != '') {
                        $fcatura->tipoIdentificador = $datos['tipoIdentificador'];
                    }

                    if (!isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoIdentificador' es obligatorio";
                        break;
                    }

                    if (isset($datos['correo']) && $datos['correo'] != '') {
                        $fcatura->correo = $datos['correo'];
                    }

                    if (!isset($datos['correo']) && $datos['correo'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'correo' es obligatorio";
                        break;
                    }

                    if (isset($datos['establecimiento']) && $datos['establecimiento'] != '' && strlen($datos['establecimiento']) == 3) {
                        $fcatura->establecimiento = $datos['establecimiento'];
                    }

                    if (!isset($datos['establecimiento']) || $datos['establecimiento'] == '' || strlen($datos['establecimiento']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'establecimiento' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['ptoEmision']) && $datos['ptoEmision'] != '' && strlen($datos['ptoEmision']) == 3) {
                        $fcatura->ptoEmision = $datos['ptoEmision'];
                    }

                    if (!isset($datos['ptoEmision']) || $datos['ptoEmision'] == '' || strlen($datos['ptoEmision']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ptoEmision' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['rucEmpresa']) && $datos['rucEmpresa'] != '' && strlen($datos['rucEmpresa']) == 13) {
                        $fcatura->rucEmpresa = $datos['rucEmpresa'];
                    }

                    if (!isset($datos['rucEmpresa']) || $datos['rucEmpresa'] == '' || strlen($datos['rucEmpresa']) != 13) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'rucEmpresa' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['secuencial']) && $datos['secuencial'] != '' && strlen($datos['secuencial']) == 9) {
                        $fcatura->secuencial = $datos['secuencial'];
                    }
                    if (!isset($datos['secuencial']) || $datos['secuencial'] == '' || strlen($datos['secuencial']) != 9) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'secuencial' es obligatorio y debe ser de 9 dígitos";
                        break;
                    }

                    if (isset($datos['ambiente']) && $datos['ambiente'] != '' && strlen($datos['ambiente']) == 1) {
                        $fcatura->ambiente = $datos['ambiente'];
                    }

                    if (!isset($datos['ambiente']) || $datos['ambiente'] == '' || strlen($datos['ambiente']) != 1) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ambiente' es obligatorio y solo es un dígito";
                        break;
                    }

                    if (isset($datos['razonSocial']) && $datos['razonSocial'] != '') {
                        $fcatura->razonSocial = $datos['razonSocial'];
                    }

                    if (!isset($datos['razonSocial']) || $datos['razonSocial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'razonSocial' es obligatorio";
                        break;
                    }

                    if (isset($datos['nombreComercial']) && $datos['nombreComercial'] != '') {
                        $fcatura->nombreComercial = $datos['nombreComercial'];
                    }

                    if (!isset($datos['nombreComercial']) || $datos['nombreComercial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'nombreComercial' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionMatriz']) && $datos['direccionMatriz'] != '') {
                        $fcatura->direccionMatriz = $datos['direccionMatriz'];
                    }
                    if (!isset($datos['direccionMatriz']) || $datos['direccionMatriz'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccionMatriz' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionEstablecimiento']) && $datos['direccionEstablecimiento'] != '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionEstablecimiento'];
                    }

                    if (!isset($datos['direccionEstablecimiento']) || $datos['direccionEstablecimiento'] == '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionMatriz'];
                    }

                    if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '' && strlen($datos['obligadoContabilidad']) == 2 && in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no'])) {
                        $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                    }
                    if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '' || strlen($datos['obligadoContabilidad']) != 2 || in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no']) == false) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'obligadoContabilidad' es obligatorio, y solo se aceptan los terminos 'SI' o 'NO'";
                        break;
                    }

                    //CAMBIOS NOTA DE CREDITO

                    if (isset($datos['tipoDocAfectado']) && $datos['tipoDocAfectado'] != '') {
                        $fcatura->tipoDocAfectado = $datos['tipoDocAfectado'];
                    }
                    if (!isset($datos['tipoDocAfectado']) && $datos['tipoDocAfectado'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'DocAfectado' es obligatorio";
                        break;
                    }

                    if (isset($datos['secuencialDocAfectado']) && $datos['secuencialDocAfectado'] != '') {
                        $fcatura->secuencialDocAfectado = $datos['secuencialDocAfectado'];
                    }
                    if (!isset($datos['secuencialDocAfectado']) && $datos['secuencialDocAfectado'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'secuencialDocAfectado' es obligatorio";
                        break;
                    }

                    if (isset($datos['motivoDev']) && $datos['motivoDev'] != '') {
                        $fcatura->motivoDev = $datos['motivoDev'];
                    }
                    if (!isset($datos['motivoDev']) && $datos['motivoDev'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'motivoDev' es obligatorio";
                        break;
                    }

                    if (isset($datos['fechaDocSustento']) && $datos['fechaDocSustento'] != '') {
                        $fcatura->fechaDocSustento = $datos['fechaDocSustento'];
                    }
                    if (!isset($datos['fechaDocSustento']) && $datos['fechaDocSustento'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fechaDocSustento' es obligatorio";
                        break;
                    }

                    if (isset($datos['claveAcceso']) && $datos['claveAcceso'] != '') {
                        $fcatura->claveAcceso = $datos['claveAcceso'];
                    }

                    if (isset($datos['importeSinImpuestos']) && is_numeric($datos['importeSinImpuestos']) > 0) {
                        $fcatura->importeSinImpuestos = $datos['importeSinImpuestos'];
                    }
                    if (!isset($datos['importeSinImpuestos']) || is_numeric($datos['importeSinImpuestos']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeSinImpuestos' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['descuento']) && is_numeric($datos['descuento']) > 0) {
                        $fcatura->descuento = $datos['descuento'];
                    }

                    if (!isset($datos['descuento']) || is_numeric($datos['descuento']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'descuento' es obligatorio, solo se aceptan valores de tipo DOUBLE, valor recibido : " . $datos['descuento'];
                        break;
                    }

                    if (isset($datos['importeTotal']) && is_numeric($datos['importeTotal']) > 0) {
                        $fcatura->importeTotal = $datos['importeTotal'];
                    }
                    if (!isset($datos['importeTotal']) || is_numeric($datos['importeTotal']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeTotal' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['baseIva12']) && is_numeric($datos['baseIva12']) > 0) {
                        $fcatura->baseIva12 = $datos['baseIva12'];
                    }

                    // if (!isset($datos['baseIva12']) || is_numeric($datos['baseIva12']) < 1) {
                    //     $result = false;
                    //     $whileResult = false;
                    //     $detalleError = "El campo 'baseIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                    //     break;
                    // }

                    if (isset($datos['valorIva12']) && is_numeric($datos['valorIva12']) > 0) {
                        $fcatura->valorIva12 = $datos['valorIva12'];
                    }

                    // if (!isset($datos['valorIva12']) || is_numeric($datos['valorIva12']) < 1) {
                    //     $result = false;
                    //     $whileResult = false;
                    //     $detalleError = "El campo 'valorIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                    //     break;
                    // }

                    if (isset($datos['baseIva0']) && is_numeric($datos['baseIva0']) > 0) {
                        $fcatura->baseIva0 = $datos['baseIva0'];
                    }

                    // if (!isset($datos['baseIva0']) || is_numeric($datos['baseIva0']) < 1) {
                    //     $result = false;
                    //     $whileResult = false;
                    //     $detalleError = "El campo 'baseIva0' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                    //     break;
                    // }

                    if (isset($datos['adicionales']) && $datos['adicionales'] != '') {
                        $fcatura->adicionales = $datos['adicionales'];
                    }

                    if (isset($datos['fPagos']) && $datos['fPagos'] != '') {
                        $fcatura->fPagos = json_encode($datos['fPagos']);
                    }


                    $fcatura->idComporbante = 'N' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'];
                    $fcatura->idEstado = '01';
                    $fcatura->orderNo =  $fcatura->secuencial;
                    $fcatura->save();
                    $docID = $fcatura->idComporbante;
                    $rucEmpresa = $fcatura->rucEmpresa;
                    $detalles = $datos['Detalle'];
                    foreach ($detalles as $value) {
                        try {

                            $detalle = new DetalleFacturaElectronica();
                            $detalle->cantidad = ($value['cantidad'] && $value['cantidad'] > 0) ? $value['cantidad'] : null;
                            $detalle->item = ($value['item'] && trim($value['item']) != '') ? trim($value['item']) : '-';
                            $detalle->precioUnitario = (isset($value['precioUnitario'])) ? $value['precioUnitario'] : null;
                            $detalle->descuento = (isset($value['descuentoLinea'])) ? $value['descuentoLinea'] : null;
                            $detalle->total = (isset($value['total'])) ? $value['total'] : null;
                            $detalle->iva = $value['iva'];
                            $iva_code = 0;
                            switch (intVal($value['iva'])) {
                                case 0:
                                    $iva_code = 0;
                                    break;
                                case 5:
                                    $iva_code = 5;
                                    break;
                                case 12:
                                    $iva_code = 2;
                                    break;
                                case 14:
                                    $iva_code = 3;
                                    break;
                                case 15:
                                    $iva_code = 4;
                                    break;
                                case 8:
                                    $iva_code = 8;
                                    break;
                            }
                            $detalle->iva_code = $iva_code;
                            $detalle->ice = $value['ice'];
                            $detalle->irbpnr = $value['irbpnr'];
                            $detalle->codigoIce = $value['codigoIce'];
                            $detalle->codigoPorcentajeIce = $value['codigoPorcentajeIce'];
                            $detalle->baseImponibleIce = $value['baseImponibleIce'];
                            $detalle->tarifaIce = $value['tarifaIce'];
                            $detalle->ValorIce = $value['ValorIce'];
                            $detalle->codigoIrbpnr = $value['codigoIrbpnr'];
                            $detalle->codigoPorcentajeIrbpnr = $value['codigoPorcentajeIrbpnr'];
                            $detalle->baseImponibleIrbpnr = $value['baseImponibleIrbpnr'];
                            $detalle->tarifaIrbpnr = $value['tarifaIrbpnr'];
                            $detalle->valorIrbpnr = $value['valorIrbpnr'];
                            $detalle->idComporbante =  $fcatura->idComporbante;
                            $detalle->idLinea = $fcatura->idComporbante . '-' . $value['idlinea'];
                            $detalle->codItem = ($value['codItem'] && trim($value['codItem']) != '') ? trim($value['codItem']) : null;
                            $detalle->lote = (isset($value['lote']) && trim($value['lote']) != '') ? trim($value['lote']) : null;
                            $detalle->fecha_creado = (isset($value['fecha_elaborado']) && trim($value['fecha_elaborado']) != '') ? trim($value['fecha_elaborado']) : null;
                            $detalle->fecha_vencimiento = (isset($value['fecha_vencimiento']) && trim($value['fecha_vencimiento']) != '') ? trim($value['fecha_vencimiento']) : null;
                            $detalle->save();
                            $result = true;
                        } catch (QueryException $exPdo) {

                            $fcatura->delete();
                            $result = false;
                            $docID = "N/A";
                            $detalleError = $exPdo;
                            Log::error('Error al tratar de generar detalle de la Nota : ' . json_encode($exPdo));
                            break;
                        }
                    }
                    //$result = true;
                    $secuencialDoc = $fcatura->secuencial;
                    $this->createClient($fcatura->cliente, $fcatura->ruc, $fcatura->razonSocial, $fcatura->correo, $fcatura->telefono, $fcatura->direccion);
                    $whileResult = false;
                }
            } catch (Exception $ex) {
                $result = false;
                $structureError = $ex->getMessage();
                Log::error('Error al intentar crear nota de crédito por el API: ' . $ex->getMessage());
            }

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID, 'secuencial' => $secuencialDoc, 'rucEmpresa' => $rucEmpresa];
        } else {

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
        }

        return $result;
    }

    public function createNoteDebit(Request $request)
    {

        if (!isset($request->token) || !isset($request->data)) {
            $result = ['Result' => 'Requerimiento malformado, el parametro token y data son obligatorios'];
            return $result;
        }
        $validar = $this->validateToken();
        if ($validar == false) {
            $result = ['Result' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
            return $result;
        }

        $token = base64_decode($request->token, true);

        if ($token != $this->company->tokenApi) {
            $result = ['Result' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
            return $result;
        }

        $datos = json_decode(base64_decode($request->data, true), true);
        $datos = $datos[0];

        $jsonError = null;
        $result = null;
        $whileResult = true;
        $structureError = null;
        $detalleError = null;
        $docID = null;
        $result = null;
        $secuencialDoc = null;
        $rucEmpresa = null;

        switch (json_last_error()) {
            case JSON_ERROR_NONE:
                $jsonError = "Sin errores";
                $result = true;
                $whileResult = true;
                break;
            case JSON_ERROR_DEPTH:
                $jsonError = "Profundidad maxima superada en nodos";
                $result = false;
                $whileResult = false;
                break;
            case JSON_ERROR_STATE_MISMATCH:
                $jsonError = "JSON inválido o malformado";
                $result = false;
                $whileResult = false;
                break;
            case JSON_ERROR_CTRL_CHAR:
                $jsonError = "Error en el control de caracteres";
                $result = false;
                $whileResult = false;
                break;
            case JSON_ERROR_SYNTAX:
                $jsonError = "Error de Syntaxis";
                $result = false;
                $whileResult = false;
                break;
            case JSON_ERROR_UTF8:
                $jsonError = "Caracter UTF-8 malformado";
                $result = false;
                $whileResult = false;
                break;
            default:
                $jsonError = "Error desconocido";
                $result = false;
                $whileResult = false;
                break;
        }

        if ($result) {

            $docuemntoValidador = CabeceraDocumentoElectronica::where('idComporbante', 'ND' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'])->get();

            if (count($docuemntoValidador) > 0) {
                $result = ['Result' => 'El Documento : ND' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'] . ' ya se encuentra registrado en el sistema'];
                return $result;
            }

            try {

                $fcatura = new CabeceraDocumentoElectronica();
                while ($whileResult == true) {

                    if (isset($datos['idInterno'])) {
                        $fcatura->idInterno = $datos['idInterno'];
                    }

                    if (isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) > 0) {
                        $fcatura->fecha = $datos['fecha'];
                    }
                    if (!isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fecha' es obligatorio y debe cumplir el formato de  YYYY-MM-DD";
                        break;
                    }
                    if (isset($datos['cliente']) && $datos['cliente'] != '') {
                        $fcatura->cliente = $datos['cliente'];
                    }
                    if (!isset($datos['cliente']) && $datos['cliente'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'cliente' es obligatorio";
                        break;
                    }
                    if (isset($datos['direccion']) && $datos['direccion'] != '') {
                        $fcatura->direccion = $datos['direccion'];
                    }
                    if (!isset($datos['direccion']) && $datos['direccion'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccion' es obligatorio";
                        break;
                    }
                    if (isset($datos['telefono']) && $datos['telefono'] != '') {
                        $fcatura->telefono = $datos['telefono'];
                    }

                    if (!isset($datos['telefono']) && $datos['telefono'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'telefono' es obligatorio";
                        break;
                    }
                    if (isset($datos['ruc']) && $datos['ruc'] != '') {
                        $fcatura->ruc = $datos['ruc'];
                    }

                    if (!isset($datos['ruc']) && $datos['ruc'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ruc/ci' del cliente es obligatorio";
                        break;
                    }
                    if (isset($datos['tipoComprobante']) && $datos['tipoComprobante'] != '') {
                        $fcatura->tipoComprobante = $datos['tipoComprobante'];
                    }

                    if (!isset($datos['tipoComprobante']) && $datos['tipoComprobante'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoComprobante' es obligatorio";
                        break;
                    }

                    if (in_array($datos['tipoComprobante'], [5]) == false) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "EL tipo de archivo " . $datos['tipoComprobante'] . " no puede ser procesado en este servicio, por favor utiliza el servicio correspondiente";
                        break;
                    }

                    if (isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] != '') {
                        $fcatura->tipoIdentificador = $datos['tipoIdentificador'];
                    }

                    if (!isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoIdentificador' es obligatorio";
                        break;
                    }

                    if (isset($datos['correo']) && $datos['correo'] != '') {
                        $fcatura->correo = $datos['correo'];
                    }

                    if (!isset($datos['correo']) && $datos['correo'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'correo' es obligatorio";
                        break;
                    }

                    if (isset($datos['establecimiento']) && $datos['establecimiento'] != '' && strlen($datos['establecimiento']) == 3) {
                        $fcatura->establecimiento = $datos['establecimiento'];
                    }

                    if (!isset($datos['establecimiento']) || $datos['establecimiento'] == '' || strlen($datos['establecimiento']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'establecimiento' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['ptoEmision']) && $datos['ptoEmision'] != '' && strlen($datos['ptoEmision']) == 3) {
                        $fcatura->ptoEmision = $datos['ptoEmision'];
                    }

                    if (!isset($datos['ptoEmision']) || $datos['ptoEmision'] == '' || strlen($datos['ptoEmision']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ptoEmision' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['rucEmpresa']) && $datos['rucEmpresa'] != '' && strlen($datos['rucEmpresa']) == 13) {
                        $fcatura->rucEmpresa = $datos['rucEmpresa'];
                    }

                    if (!isset($datos['rucEmpresa']) || $datos['rucEmpresa'] == '' || strlen($datos['rucEmpresa']) != 13) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'rucEmpresa' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['secuencial']) && $datos['secuencial'] != '' && strlen($datos['secuencial']) == 9) {
                        $fcatura->secuencial = $datos['secuencial'];
                    }
                    if (!isset($datos['secuencial']) || $datos['secuencial'] == '' || strlen($datos['secuencial']) != 9) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'secuencial' es obligatorio y debe ser de 9 dígitos";
                        break;
                    }

                    if (isset($datos['ambiente']) && $datos['ambiente'] != '' && strlen($datos['ambiente']) == 1) {
                        $fcatura->ambiente = $datos['ambiente'];
                    }

                    if (!isset($datos['ambiente']) || $datos['ambiente'] == '' || strlen($datos['ambiente']) != 1) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ambiente' es obligatorio y solo es un dígito";
                        break;
                    }

                    if (isset($datos['razonSocial']) && $datos['razonSocial'] != '') {
                        $fcatura->razonSocial = $datos['razonSocial'];
                    }

                    if (!isset($datos['razonSocial']) || $datos['razonSocial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'razonSocial' es obligatorio";
                        break;
                    }

                    if (isset($datos['nombreComercial']) && $datos['nombreComercial'] != '') {
                        $fcatura->nombreComercial = $datos['nombreComercial'];
                    }

                    if (!isset($datos['nombreComercial']) || $datos['nombreComercial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'nombreComercial' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionMatriz']) && $datos['direccionMatriz'] != '') {
                        $fcatura->direccionMatriz = $datos['direccionMatriz'];
                    }
                    if (!isset($datos['direccionMatriz']) || $datos['direccionMatriz'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccionMatriz' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionEstablecimiento']) && $datos['direccionEstablecimiento'] != '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionEstablecimiento'];
                    }

                    if (!isset($datos['direccionEstablecimiento']) || $datos['direccionEstablecimiento'] == '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionMatriz'];
                    }

                    if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '' && strlen($datos['obligadoContabilidad']) == 2 && in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no'])) {
                        $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                    }
                    if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '' || strlen($datos['obligadoContabilidad']) != 2 || in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no']) == false) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'obligadoContabilidad' es obligatorio, y solo se aceptan los terminos 'SI' o 'NO'";
                        break;
                    }

                    //CAMBIOS NOTA DE CREDITO

                    if (isset($datos['tipoDocAfectado']) && $datos['tipoDocAfectado'] != '') {
                        $fcatura->tipoDocAfectado = $datos['tipoDocAfectado'];
                    }
                    if (!isset($datos['tipoDocAfectado']) && $datos['tipoDocAfectado'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'DocAfectado' es obligatorio";
                        break;
                    }

                    if (isset($datos['secuencialDocAfectado']) && $datos['secuencialDocAfectado'] != '') {
                        $fcatura->secuencialDocAfectado = $datos['secuencialDocAfectado'];
                    }
                    if (!isset($datos['secuencialDocAfectado']) && $datos['secuencialDocAfectado'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'secuencialDocAfectado' es obligatorio";
                        break;
                    }

                    if (isset($datos['fechaDocSustento']) && $datos['fechaDocSustento'] != '') {
                        $fcatura->fechaDocSustento = $datos['fechaDocSustento'];
                    }
                    if (!isset($datos['fechaDocSustento']) && $datos['fechaDocSustento'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fechaDocSustento' es obligatorio";
                        break;
                    }

                    if (isset($datos['claveAcceso']) && $datos['claveAcceso'] != '') {
                        $fcatura->claveAcceso = $datos['claveAcceso'];
                    }

                    if (isset($datos['importeSinImpuestos']) && is_numeric($datos['importeSinImpuestos']) > 0) {
                        $fcatura->importeSinImpuestos = $datos['importeSinImpuestos'];
                    }
                    if (!isset($datos['importeSinImpuestos']) || is_numeric($datos['importeSinImpuestos']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeSinImpuestos' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['descuento']) && is_numeric($datos['descuento']) > 0) {
                        $fcatura->descuento = $datos['descuento'];
                    }

                    if (!isset($datos['descuento']) || is_numeric($datos['descuento']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'descuento' es obligatorio, solo se aceptan valores de tipo DOUBLE, valor recibido : " . $datos['descuento'];
                        break;
                    }

                    if (isset($datos['importeTotal']) && is_numeric($datos['importeTotal']) > 0) {
                        $fcatura->importeTotal = $datos['importeTotal'];
                    }
                    if (!isset($datos['importeTotal']) || is_numeric($datos['importeTotal']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeTotal' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['baseIva12']) && is_numeric($datos['baseIva12']) > 0) {
                        $fcatura->baseIva12 = $datos['baseIva12'];
                    }
                    // if (!isset($datos['baseIva12']) || is_numeric($datos['baseIva12']) < 1) {
                    //     $result = false;
                    //     $whileResult = false;
                    //     $detalleError = "El campo 'baseIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                    //     break;
                    // }

                    if (isset($datos['valorIva12']) && is_numeric($datos['valorIva12']) > 0) {
                        $fcatura->valorIva12 = $datos['valorIva12'];
                    }

                    // if (!isset($datos['valorIva12']) || is_numeric($datos['valorIva12']) < 1) {
                    //     $result = false;
                    //     $whileResult = false;
                    //     $detalleError = "El campo 'valorIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                    //     break;
                    // }

                    if (isset($datos['baseIva0']) && is_numeric($datos['baseIva0']) > 0) {
                        $fcatura->baseIva0 = $datos['baseIva0'];
                    }

                    // if (!isset($datos['baseIva0']) || is_numeric($datos['baseIva0']) < 1) {
                    //     $result = false;
                    //     $whileResult = false;
                    //     $detalleError = "El campo 'baseIva0' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                    //     break;
                    // }

                    if (isset($datos['adicionales']) && $datos['adicionales'] != '') {
                        $fcatura->adicionales = $datos['adicionales'];
                    }

                    if (isset($datos['fPagos']) && $datos['fPagos'] != '') {
                        $fcatura->fPagos = json_encode($datos['fPagos']);
                    }
                    if (!isset($datos['fPagos']) || $datos['fPagos'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo formas de pago 'fPagos' es obligatorio en notas de débito";
                        break;
                    }
                    if (isset($datos['impuestos']) && $datos['impuestos'] != '') {
                        $fcatura->impuestos = json_encode($datos['impuestos']);
                    }


                    $fcatura->idComporbante = 'ND' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'];
                    $fcatura->idEstado = '01';
                    $fcatura->orderNo =  $fcatura->secuencial;
                    $fcatura->save();
                    $docID = $fcatura->idComporbante;
                    $rucEmpresa = $fcatura->rucEmpresa;
                    $detalles = $datos['motivos'];
                    foreach ($detalles as $value) {
                        try {
                            $detalle = new DetalleFacturaElectronica();
                            $detalle->cantidad = 0;
                            $detalle->item = ($value['motivo'] && trim($value['motivo']) != '') ? trim($value['motivo']) : null;
                            $detalle->precioUnitario = 0;
                            $detalle->descuento = 0;
                            $detalle->total = ($value['total']) ? $value['total'] : null;
                            $detalle->iva = 0;
                            $detalle->ice = 0;
                            $detalle->irbpnr = 0;
                            $detalle->codigoIce = 'N/A';
                            $detalle->codigoPorcentajeIce = 'N/A';
                            $detalle->baseImponibleIce = 0;
                            $detalle->tarifaIce = 0;
                            $detalle->ValorIce = 0;
                            $detalle->codigoIrbpnr = 'N/A';
                            $detalle->codigoPorcentajeIrbpnr = 'N/A';
                            $detalle->baseImponibleIrbpnr = 0;
                            $detalle->tarifaIrbpnr = 0;
                            $detalle->valorIrbpnr = 0;
                            $detalle->idComporbante =  $fcatura->idComporbante;
                            $detalle->idLinea = null;
                            $detalle->codItem = null;
                            $detalle->save();
                            $result = true;
                        } catch (QueryException $exPdo) {

                            $fcatura->delete();
                            $result = false;
                            $docID = "N/A";
                            $detalleError = $exPdo;
                            Log::error('Error al tratar de generar detalle de la Nota : ' . json_encode($exPdo));
                            break;
                        }
                    }
                    //$result = true;
                    $secuencialDoc = $fcatura->secuencial;
                    $whileResult = false;
                }
            } catch (Exception $ex) {
                $result = false;
                $structureError = $ex->getMessage();
                Log::error('Error al intentar crear nota de debito por el API: ' . $ex->getMessage());
            }

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID, 'secuencial' => $secuencialDoc, 'rucEmpresa' => $rucEmpresa];
        } else {

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
        }

        return $result;
    }

    public function createLiquidation(Request $request)
    {

        $jsonError = null;
        $result = null;
        $whileResult = true;
        $structureError = null;
        $detalleError = null;
        $docID = null;
        $result = null;
        $secuencialDoc = null;
        $rucEmpresa = null;

        try {

            //Log::info($request);
            if (!isset($request->token) || !isset($request->data)) {
                $result = ['Response' => 'Requerimiento malformado, el parametro token y data son obligatorios'];
                return $result;
            }
            $validar = $this->validateToken();
            if ($validar == false) {
                $result = ['Response' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
                return $result;
            }

            $token = base64_decode($request->token, true);
            //Log::info($token);

            if ($token != $this->company->tokenApi) {
                $result = ['Response' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
                return $result;
            }

            $datos = json_decode(base64_decode($request->data, true), true);
            $datos = $datos[0];

            //Log::info(json_last_error_msg());
            //Log::info(base64_decode($request->data,true));

            switch (json_last_error()) {

                case JSON_ERROR_NONE:
                    $jsonError = "Sin errores";
                    $result = true;
                    break;
                case JSON_ERROR_DEPTH:
                    $jsonError = "Profundidad maxima superada en nodos";
                    $result = false;
                    break;
                case JSON_ERROR_STATE_MISMATCH:
                    $jsonError = "JSON inválido o malformado";
                    $result = false;
                    break;
                case JSON_ERROR_CTRL_CHAR:
                    $jsonError = "Error en el control de caracteres";
                    $result = false;
                    break;
                case JSON_ERROR_SYNTAX:
                    $jsonError = "Error de Syntaxis";
                    $result = false;
                    break;
                case JSON_ERROR_UTF8:
                    $jsonError = "Caracter UTF-8 malformado";
                    $result = false;
                    break;
                default:
                    $jsonError = "Error desconocido";
                    $result = false;
                    break;
            }

            if ($result) {

                $facturaValidador = CabeceraDocumentoElectronica::where('idComporbante', 'L' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'])->get();
                if (count($facturaValidador) > 0) {
                    $result = ['Response' => 'La liquidación : L' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'] . ' ya se encuentra registrada en el sistema'];

                    return $result;
                }

                try {

                    $fcatura = new CabeceraDocumentoElectronica();
                    while ($whileResult == true) {

                        if (isset($datos['idInterno'])) {
                            $fcatura->idInterno = $datos['idInterno'];
                        }
                        if (isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) > 0) {
                            $fcatura->fecha = $datos['fecha'];
                        }
                        if (!isset($datos['fecha']) || preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'fecha' es obligatorio y debe cumplir el formato de  YYYY-MM-DD";
                            break;
                        }
                        if (isset($datos['cliente']) && $datos['cliente'] != '') {
                            $fcatura->cliente = $datos['cliente'];
                        }
                        if (!isset($datos['cliente']) || $datos['cliente'] == '') {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'cliente' es obligatorio";
                            break;
                        }
                        if (isset($datos['direccion']) && $datos['direccion'] != '') {
                            $fcatura->direccion = $datos['direccion'];
                        }
                        if (!isset($datos['direccion']) || $datos['direccion'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'direccion' es obligatorio";
                            break;
                        }
                        if (isset($datos['telefono']) && $datos['telefono'] != '') {
                            $fcatura->telefono = $datos['telefono'];
                        }

                        if (!isset($datos['telefono']) || $datos['telefono'] == '') {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'telefono' es obligatorio";
                            break;
                        }
                        if (isset($datos['ruc']) && $datos['ruc'] != '') {
                            $fcatura->ruc = $datos['ruc'];
                        }

                        if (!isset($datos['ruc']) || $datos['ruc'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ruc/ci' del cliente es obligatorio";
                            break;
                        }
                        if (isset($datos['tipoComprobante']) && in_array($datos['tipoComprobante'], [3])) {
                            $fcatura->tipoComprobante = $datos['tipoComprobante'];
                        }

                        if (!isset($datos['tipoComprobante']) || $datos['tipoComprobante'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'tipoComprobante' es obligatorio";
                            break;
                        }
                        if (in_array($datos['tipoComprobante'], [3]) == false) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "EL tipo de archivo " . $datos['tipoComprobante'] . " no puede ser procesado en este servicio, por favor utiliza el servicio correspondiente";
                            break;
                        }

                        if (isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] != '') {
                            $fcatura->tipoIdentificador = $datos['tipoIdentificador'];
                        }

                        if (!isset($datos['tipoIdentificador']) || $datos['tipoIdentificador'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'tipoIdentificador' es obligatorio";
                            break;
                        }

                        if (isset($datos['correo']) && $datos['correo'] != '') {
                            $fcatura->correo = $datos['correo'];
                        }
                        if (!isset($datos['correo']) || $datos['correo'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'correo' es obligatorio";
                            break;
                        }

                        if (isset($datos['establecimiento']) && $datos['establecimiento'] != '' && strlen($datos['establecimiento']) == 3) {
                            $fcatura->establecimiento = $datos['establecimiento'];
                        }

                        if (!isset($datos['establecimiento']) || $datos['establecimiento'] == '' || strlen($datos['establecimiento']) != 3) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'establecimiento' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['ptoEmision']) && $datos['ptoEmision'] != '' && strlen($datos['ptoEmision']) == 3) {
                            $fcatura->ptoEmision = $datos['ptoEmision'];
                        }

                        if (!isset($datos['ptoEmision']) || $datos['ptoEmision'] == '' || strlen($datos['ptoEmision']) != 3) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ptoEmision' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['rucEmpresa']) && $datos['rucEmpresa'] != '' && strlen($datos['rucEmpresa']) == 13) {
                            $fcatura->rucEmpresa = $datos['rucEmpresa'];
                        }

                        if (!isset($datos['rucEmpresa']) || $datos['rucEmpresa'] == '' || strlen($datos['rucEmpresa']) != 13) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'rucEmpresa' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['secuencial']) && $datos['secuencial'] != '' && strlen($datos['secuencial']) == 9) {
                            $fcatura->secuencial = $datos['secuencial'];
                        }
                        if (!isset($datos['secuencial']) || $datos['secuencial'] == '' || strlen($datos['secuencial']) != 9) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'secuencial' es obligatorio y debe ser de 9 dígitos";
                            break;
                        }

                        if (isset($datos['ambiente']) && $datos['ambiente'] != '' && strlen($datos['ambiente']) == 1) {
                            $fcatura->ambiente = $datos['ambiente'];
                        }

                        if (!isset($datos['ambiente']) || $datos['ambiente'] == '' || strlen($datos['ambiente']) != 1) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ambiente' es obligatorio y solo es un dígito";
                            break;
                        }

                        if (isset($datos['razonSocial']) && $datos['razonSocial'] != '') {
                            $fcatura->razonSocial = $datos['razonSocial'];
                        }

                        if (!isset($datos['razonSocial']) || $datos['razonSocial'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'razonSocial' es obligatorio";
                            break;
                        }

                        if (isset($datos['nombreComercial']) && $datos['nombreComercial'] != '') {
                            $fcatura->nombreComercial = $datos['nombreComercial'];
                        }

                        if (!isset($datos['nombreComercial']) || $datos['nombreComercial'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'nombreComercial' es obligatorio";
                            break;
                        }

                        if (isset($datos['direccionMatriz']) && $datos['direccionMatriz'] != '') {
                            $fcatura->direccionMatriz = $datos['direccionMatriz'];
                        }
                        if (!isset($datos['direccionMatriz']) || $datos['direccionMatriz'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'direccionMatriz' es obligatorio";
                            break;
                        }

                        if (isset($datos['direccionEstablecimiento']) && $datos['direccionEstablecimiento'] != '') {
                            $fcatura->direccionEstablecimiento = $datos['direccionEstablecimiento'];
                        }

                        if (!isset($datos['direccionEstablecimiento']) || $datos['direccionEstablecimiento'] == '') {
                            $fcatura->direccionEstablecimiento = $datos['direccionMatriz'];
                        }

                        if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '') {
                            $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                        }

                        if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'obligadoContabilidad' es obligatorio";
                            break;
                        }

                        if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '' && strlen($datos['obligadoContabilidad']) == 2 && in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no'])) {
                            $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                        }
                        if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '' || strlen($datos['obligadoContabilidad']) != 2 || in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no']) == false) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'obligadoContabilidad' es obligatorio, y solo se aceptan los terminos 'SI' o 'NO'";
                            break;
                        }

                        if (isset($datos['numeroCE']) && $datos['numeroCE'] != '') {
                            $fcatura->numeroCE = $datos['numeroCE'];
                        }

                        if (isset($datos['claveAcceso']) && $datos['claveAcceso'] != '') {
                            $fcatura->claveAcceso = $datos['claveAcceso'];
                        }

                        if (isset($datos['importeSinImpuestos']) && $datos['importeSinImpuestos'] != '' && is_numeric($datos['importeSinImpuestos']) > 0) {
                            $fcatura->importeSinImpuestos = $datos['importeSinImpuestos'];
                        }
                        if (!isset($datos['importeSinImpuestos']) || $datos['importeSinImpuestos'] == '' || is_numeric($datos['importeSinImpuestos']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'importeSinImpuestos' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            break;
                        }

                        if (isset($datos['descuento']) && is_numeric($datos['descuento']) > 0) {
                            $fcatura->descuento = $datos['descuento'];
                        }

                        if (!isset($datos['descuento']) || is_numeric($datos['descuento']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'descuento' es obligatorio, solo se aceptan valores de tipo DOUBLE, valor recibido : " . $datos['descuento'];
                            break;
                        }

                        if (isset($datos['importeTotal']) && $datos['importeTotal'] != '' && is_numeric($datos['importeTotal']) > 0) {
                            $fcatura->importeTotal = $datos['importeTotal'];
                        }
                        if (!isset($datos['importeTotal']) || $datos['importeTotal'] == '' || is_numeric($datos['importeTotal']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'importeTotal' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            break;
                        }

                        if (isset($datos['baseIva12']) && is_numeric($datos['baseIva12']) > 0) {
                            $fcatura->baseIva12 = $datos['baseIva12'];
                        }
                        // if (isset($datos['baseIva12']) == false || is_numeric($datos['baseIva12']) < 1) {
                        //     $result = false;
                        //     $whileResult = false;
                        //     $detalleError = "El campo 'baseIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE " . isset($datos['baseIva12']) . ' - ' . $datos['baseIva12'] . ' - ' . is_numeric($datos['baseIva12']);
                        //     break;
                        // }

                        if (isset($datos['valorIva12']) && is_numeric($datos['valorIva12']) > 0) {
                            $fcatura->valorIva12 = $datos['valorIva12'];
                        }

                        // if (!isset($datos['valorIva12']) || is_numeric($datos['valorIva12']) < 1) {
                        //     $result = false;
                        //     $whileResult = false;
                        //     $detalleError = "El campo 'valorIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        //     break;
                        // }

                        if (isset($datos['baseIva0'])  && is_numeric($datos['baseIva0']) > 0) {
                            $fcatura->baseIva0 = $datos['baseIva0'];
                        }

                        // if (!isset($datos['baseIva0']) || is_numeric($datos['baseIva0']) < 1) {
                        //     $result = false;
                        //     $whileResult = false;
                        //     $detalleError = "El campo 'baseIva0' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        //     break;
                        // }

                        if (isset($datos['adicionales']) && $datos['adicionales'] != '') {
                            $fcatura->adicionales = $datos['adicionales'];
                        }

                        if (isset($datos['fPagos']) && $datos['fPagos'] != '') {
                            $fcatura->fPagos = json_encode($datos['fPagos']);
                        }

                        $fcatura->idComporbante = 'L' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'];
                        $fcatura->idEstado = '01';
                        $fcatura->orderNo =  $fcatura->secuencial;

                        $fcatura->save();
                        $docID = $fcatura->idComporbante;
                        $rucEmpresa = $fcatura->rucEmpresa;

                        if (isset($datos['Detalle']) == false || $datos['Detalle'] == '') {
                            $result = false;
                            $docID = "N/A";
                            $detalleError = "Debes ingresar los detalles del documento de forma obligatoria";
                            $fcatura->delete();
                            $whileResult = false;
                            break;
                        }

                        $detalles = $datos['Detalle'];

                        foreach ($detalles as $value) {
                            try {
                                $detalle = new DetalleFacturaElectronica();
                                $detalle->cantidad = ($value['cantidad'] && $value['cantidad'] > 0) ? $value['cantidad'] : null;
                                $detalle->item = ($value['item'] && trim($value['item']) != '') ? trim($value['item']) : null;
                                $detalle->precioUnitario = (isset($value['precioUnitario'])) ? $value['precioUnitario'] : null;
                                $detalle->descuento = (isset($value['descuentoLinea'])) ? $value['descuentoLinea'] : null;
                                $detalle->total = (isset($value['total'])) ? $value['total'] : null;
                                $detalle->iva = $value['iva'];
                                $iva_code = 0;
                                switch (intVal($value['iva'])) {
                                    case 0:
                                        $iva_code = 0;
                                        break;
                                    case 5:
                                        $iva_code = 5;
                                        break;
                                    case 12:
                                        $iva_code = 2;
                                        break;
                                    case 14:
                                        $iva_code = 3;
                                        break;
                                    case 15:
                                        $iva_code = 4;
                                        break;
                                    case 8:
                                        $iva_code = 8;
                                        break;
                                }
                                $detalle->iva_code = $iva_code;
                                $detalle->ice = $value['ice'];
                                $detalle->irbpnr = $value['irbpnr'];
                                $detalle->codigoIce = $value['codigoIce'];
                                $detalle->codigoPorcentajeIce = $value['codigoPorcentajeIce'];
                                $detalle->baseImponibleIce = $value['baseImponibleIce'];
                                $detalle->tarifaIce = $value['tarifaIce'];
                                $detalle->ValorIce = $value['ValorIce'];
                                $detalle->codigoIrbpnr = $value['codigoIrbpnr'];
                                $detalle->codigoPorcentajeIrbpnr = $value['codigoPorcentajeIrbpnr'];
                                $detalle->baseImponibleIrbpnr = $value['baseImponibleIrbpnr'];
                                $detalle->tarifaIrbpnr = $value['tarifaIrbpnr'];
                                $detalle->valorIrbpnr = $value['valorIrbpnr'];
                                $detalle->idComporbante =  $fcatura->idComporbante;
                                $detalle->idLinea = $fcatura->idComporbante . '-' . $value['idlinea'];
                                $detalle->codItem = ($value['codItem'] && trim($value['codItem']) != '') ? trim($value['codItem']) : null;
                                $detalle->save();
                                $result = true;
                            } catch (QueryException $exPdo) {

                                $fcatura->delete();
                                $result = false;
                                $docID = "N/A";
                                $detalleError = $exPdo;
                                Log::error('Error al tratar de generar detalle de la factura : ' . json_encode($exPdo));
                                break;
                            }
                        }

                        $secuencialDoc = $fcatura->secuencial;
                        $this->createClient($fcatura->cliente, $fcatura->ruc, $fcatura->razonSocial, $fcatura->correo, $fcatura->telefono, $fcatura->direccion);
                        $whileResult = false;
                    }
                } catch (Exception $ex) {

                    $result = false;
                    $structureError = $ex->getMessage();
                    $docID = "N/A";
                    Log::error('Error al tratar de generar la liquidacion : ' . $ex->getMessage());
                }

                $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID, 'secuencial' => $secuencialDoc, 'rucEmpresa' => $rucEmpresa];
            } else {

                $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
            }
            return $result;
        } catch (Exception $ex) {
            $result = ['Result' => 'No se pudo procesar su requerimiento, ERROR: ' . $ex->getMessage()];
            return $result;
        }
    }

    public function createGuide(Request $request)
    {

        $jsonError = null;
        $result = null;
        $whileResult = true;
        $structureError = null;
        $detalleError = null;
        $docID = null;
        $result = null;
        $secuencialDoc = null;
        $rucEmpresa = null;

        try {

            //Log::info($request);
            if (!isset($request->token) || !isset($request->data)) {
                $result = ['Response' => 'Requerimiento malformado, el parametro token y data son obligatorios'];
                return $result;
            }
            $validar = $this->validateToken();
            if ($validar == false) {
                $result = ['Response' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
                return $result;
            }

            $token = base64_decode($request->token, true);
            //Log::info($token);

            if ($token != $this->company->tokenApi) {
                $result = ['Response' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
                return $result;
            }

            $datos = json_decode(base64_decode($request->data, true), true);
            $datos = $datos[0];

            switch (json_last_error()) {

                case JSON_ERROR_NONE:
                    $jsonError = "Sin errores";
                    $result = true;
                    break;
                case JSON_ERROR_DEPTH:
                    $jsonError = "Profundidad maxima superada en nodos";
                    $result = false;
                    break;
                case JSON_ERROR_STATE_MISMATCH:
                    $jsonError = "JSON inválido o malformado";
                    $result = false;
                    break;
                case JSON_ERROR_CTRL_CHAR:
                    $jsonError = "Error en el control de caracteres";
                    $result = false;
                    break;
                case JSON_ERROR_SYNTAX:
                    $jsonError = "Error de Syntaxis";
                    $result = false;
                    break;
                case JSON_ERROR_UTF8:
                    $jsonError = "Caracter UTF-8 malformado";
                    $result = false;
                    break;
                default:
                    $jsonError = "Error desconocido";
                    $result = false;
                    break;
            }

            $facturaValidador = CabeceraDocumentoElectronica::where('idComporbante', 'G' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'])->get();
            if (count($facturaValidador) > 0) {
                $result = ['Response' => 'El Guía de remisión : G' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'] . ' ya se encuentra registrado en el sistema'];
                return $result;
            }

            if ($result) {

                try {

                    $fcatura = new CabeceraDocumentoElectronica();
                    while ($whileResult == true) {

                        if (isset($datos['idInterno'])) {
                            $fcatura->idInterno = $datos['idInterno'];
                        }

                        if (isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) > 0) {
                            $fcatura->fecha = $datos['fecha'];
                        }

                        if (!isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'fecha' es obligatorio y debe cumplir el formato de  YYYY-MM-DD";
                            break;
                        }

                        if (isset($datos['fechaIniTransporte'])) {
                            $fcatura->fechaIniTranporte = $datos['fechaIniTransporte'];
                        }

                        if (!isset($datos['fechaIniTransporte'])) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'fechaIniTransporte' es obligatorio y debe cumplir el formato de  DD/MM/YYYY";
                            break;
                        }

                        if (isset($datos['fechaFinTransporte'])) {
                            $fcatura->fechaFinTransporte = $datos['fechaFinTransporte'];
                        }

                        if (!isset($datos['fechaFinTransporte'])) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'fechaFinTransporte' es obligatorio y debe cumplir el formato de  DD/MM/YYYY";
                            break;
                        }

                        if (isset($datos['transportista']) && $datos['transportista'] != '') {
                            $fcatura->cliente = $datos['transportista'];
                        }

                        if (!isset($datos['transportista']) && $datos['transportista'] == '') {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'transportista' es obligatorio";
                            break;
                        }

                        if (isset($datos['placa']) && $datos['placa'] != '') {
                            $fcatura->placa = $datos['placa'];
                        }

                        if (!isset($datos['placa']) && $datos['placa'] == '') {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'placa' es obligatorio";
                            break;
                        }

                        if (isset($datos['ruc']) && $datos['ruc'] != '') {
                            $fcatura->ruc = $datos['ruc'];
                        }

                        if (!isset($datos['ruc']) && $datos['ruc'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ruc/ci' del transportista es obligatorio";
                            break;
                        }

                        if (isset($datos['tipoComprobante']) && $datos['tipoComprobante'] != '' && in_array($datos['tipoComprobante'], [6, '06'])) {
                            $fcatura->tipoComprobante = $datos['tipoComprobante'];
                        }

                        if (!isset($datos['tipoComprobante']) && $datos['tipoComprobante'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'tipoComprobante' es obligatorio";
                            break;
                        }
                        if (in_array($datos['tipoComprobante'], [6]) == false) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "EL tipo de archivo " . $datos['tipoComprobante'] . " no puede ser procesado en este servicio, por favor utiliza el servicio correspondiente";
                            break;
                        }

                        if (isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] != '') {
                            $fcatura->tipoIdentificador = $datos['tipoIdentificador'];
                        }

                        if (!isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'tipoIdentificador' es obligatorio";
                            break;
                        }

                        if (isset($datos['correo']) && $datos['correo'] != '') {
                            $fcatura->correo = $datos['correo'];
                        }

                        if (!isset($datos['correo']) && $datos['correo'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'correo' es obligatorio";
                            break;
                        }

                        if (isset($datos['establecimiento']) && $datos['establecimiento'] != '' && strlen($datos['establecimiento']) == 3) {
                            $fcatura->establecimiento = $datos['establecimiento'];
                        }

                        if (!isset($datos['establecimiento']) || $datos['establecimiento'] == '' || strlen($datos['establecimiento']) != 3) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'establecimiento' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['ptoEmision']) && $datos['ptoEmision'] != '' && strlen($datos['ptoEmision']) == 3) {
                            $fcatura->ptoEmision = $datos['ptoEmision'];
                        }

                        if (!isset($datos['ptoEmision']) || $datos['ptoEmision'] == '' || strlen($datos['ptoEmision']) != 3) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ptoEmision' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['rucEmpresa']) && $datos['rucEmpresa'] != '' && strlen($datos['rucEmpresa']) == 13) {
                            $fcatura->rucEmpresa = $datos['rucEmpresa'];
                        }

                        if (!isset($datos['rucEmpresa']) || $datos['rucEmpresa'] == '' || strlen($datos['rucEmpresa']) != 13) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'rucEmpresa' es obligatorio y debe ser de 13 dígitos";
                            break;
                        }

                        if (isset($datos['secuencial']) && $datos['secuencial'] != '' && strlen($datos['secuencial']) == 9) {
                            $fcatura->secuencial = $datos['secuencial'];
                        }
                        if (!isset($datos['secuencial']) || $datos['secuencial'] == '' || strlen($datos['secuencial']) != 9) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'secuencial' es obligatorio y debe ser de 9 dígitos";
                            break;
                        }

                        if (isset($datos['ambiente']) && $datos['ambiente'] != '' && strlen($datos['ambiente']) == 1) {
                            $fcatura->ambiente = $datos['ambiente'];
                        }

                        if (!isset($datos['ambiente']) || $datos['ambiente'] == '' || strlen($datos['ambiente']) != 1) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ambiente' es obligatorio y solo es un dígito";
                            break;
                        }

                        if (isset($datos['razonSocial']) && $datos['razonSocial'] != '') {
                            $fcatura->razonSocial = $datos['razonSocial'];
                        }

                        if (!isset($datos['razonSocial']) || $datos['razonSocial'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'razonSocial' es obligatorio";
                            break;
                        }

                        if (isset($datos['nombreComercial']) && $datos['nombreComercial'] != '') {
                            $fcatura->nombreComercial = $datos['nombreComercial'];
                        }

                        if (!isset($datos['nombreComercial']) || $datos['nombreComercial'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'nombreComercial' es obligatorio";
                            break;
                        }

                        if (isset($datos['direccionMatriz']) && $datos['direccionMatriz'] != '') {
                            $fcatura->direccionMatriz = $datos['direccionMatriz'];
                        }
                        if (!isset($datos['direccionMatriz']) || $datos['direccionMatriz'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'direccionMatriz' es obligatorio";
                            break;
                        }

                        if (isset($datos['direccionEstablecimiento']) && $datos['direccionEstablecimiento'] != '') {
                            $fcatura->direccionEstablecimiento = $datos['direccionEstablecimiento'];
                        }

                        if (!isset($datos['direccionEstablecimiento']) || $datos['direccionEstablecimiento'] == '') {
                            $fcatura->direccionEstablecimiento = $datos['direccionMatriz'];
                        }

                        if (isset($datos['direccionPartida']) && $datos['direccionPartida'] != '') {
                            $fcatura->direccionDePartida = $datos['direccionPartida'];
                            $fcatura->direccion = 'N/A';
                            $fcatura->telefono = 'N/A';
                        }

                        if (!isset($datos['direccionPartida']) || $datos['direccionPartida'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'direccionPartida' es obligatorio";
                            break;
                        }

                        if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '') {
                            $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                        }

                        if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'obligadoContabilidad' es obligatorio";
                            break;
                        }

                        if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '' && strlen($datos['obligadoContabilidad']) == 2 && in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no'])) {
                            $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                        }
                        if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '' || strlen($datos['obligadoContabilidad']) != 2 || in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no']) == false) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'obligadoContabilidad' es obligatorio, y solo se aceptan los terminos 'SI' ó 'NO'";
                            break;
                        }

                        if (isset($datos['numeroCE']) && $datos['numeroCE'] != '') {
                            $fcatura->numeroCE = $datos['numeroCE'];
                        }

                        if (isset($datos['claveAcceso']) && $datos['claveAcceso'] != '') {
                            $fcatura->claveAcceso = $datos['claveAcceso'];
                        }

                        if (isset($datos['adicionales']) && $datos['adicionales'] != '') {
                            $fcatura->adicionales = $datos['adicionales'];
                        }

                        $fcatura->idComporbante = 'G' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'];
                        $fcatura->idEstado = '01';
                        $fcatura->orderNo =  $fcatura->secuencial;

                        $fcatura->importeSinImpuestos = null;
                        $fcatura->descuento = null;
                        $fcatura->importeTotal = null;
                        $fcatura->baseIva12 = null;
                        $fcatura->valorIva12 = null;
                        $fcatura->baseIva0 = null;

                        $fcatura->save();
                        $docID = $fcatura->idComporbante;
                        $rucEmpresa = $fcatura->rucEmpresa;

                        if (isset($datos['destinatarios']) == false || $datos['destinatarios'] == '') {
                            $result = false;
                            $fcatura->delete();
                            $whileResult = false;
                            $docID = "N/A";
                            break;
                        }

                        $detalles = $datos['destinatarios'];

                        foreach ($detalles as $value) {
                            try {
                                $destinatario = new Destinatarios();
                                $destinatario->identificacion = $value["identificacion"];
                                $destinatario->razon_social = $value["razonSocial"];
                                $destinatario->motivo = $value["motivoTraslado"];
                                $destinatario->direccion = $value["dirDestinatario"];
                                $destinatario->docAduaneroUnico = (isset($value["docAduaneroUnico"])) ? $value["docAduaneroUnico"] : null;
                                $destinatario->codEstablecimiento = $value["codEstablecimientoDestino"];
                                $destinatario->ruta = (isset($value["ruta"])) ? $value["ruta"] : null;
                                $destinatario->codDocSustento = (isset($value["codDocSustento"])) ? $value["codDocSustento"] : null;
                                $destinatario->numDocSustento = (isset($value["numDocSustento"])) ? $value["numDocSustento"] : null;
                                $destinatario->numAutDocSustento = (isset($value["numAutDocSustento"])) ? $value["numAutDocSustento"] : null;
                                $destinatario->fechaEmisionDocSustento = (isset($value["fechaEmisionDocSustento"])) ? $value["fechaEmisionDocSustento"] : null;
                                $destinatario->id_documento = $fcatura->idComporbante;

                                if ($destinatario->save()) {

                                    try {
                                        $detallesDes = $value['detalles'];
                                        foreach ($detallesDes as $items) {
                                            $detalleD = new Destinatarios_detalle();
                                            $detalleD->codItem = $items["codItem"];
                                            $detalleD->codAdicional = (isset($items["codAdicional"])) ? $items["codAdicional"] : null;
                                            $detalleD->item = $items["item"];
                                            $detalleD->cantidad = $items["cantidad"];
                                            $detalleD->adicionales = (isset($items["detallesAdicionales"])) ? $items["detallesAdicionales"] : null;
                                            $detalleD->id_destinatario = $destinatario->id;
                                            $detalleD->save();
                                        }
                                        $result = true;
                                    } catch (QueryException $detEx) {
                                        $fcatura->delete();
                                        $destinatario->delete();
                                        $result = false;
                                        $docID = "N/A";
                                        $detalleError = $detEx;
                                        Log::error('Error al tratar de generar detalle de la factura : ' . json_encode($detEx));
                                        break;
                                    }
                                }
                            } catch (QueryException $exPdo) {

                                $fcatura->delete();
                                $result = false;
                                $docID = "N/A";
                                $detalleError = $exPdo;
                                Log::error('Error al tratar de generar detalle de la factura : ' . json_encode($exPdo));
                                break;
                            }
                        }

                        $secuencialDoc = $fcatura->secuencial;
                        $whileResult = false;
                    }
                } catch (Exception $ex) {

                    $result = false;
                    $structureError = $ex->getMessage();
                    $docID = "N/A";
                    Log::error('Error al tratar de generar la Guia de remision : ' . $ex->getMessage());
                }

                $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID, 'secuencial' => $secuencialDoc, 'rucEmpresa' => $rucEmpresa];
            } else {

                $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
            }

            return $result;
        } catch (Exception $ex) {

            $result = ['Result' => 'No se pudo procesar su requerimiento, ERROR: ' . $ex->getMessage()];
            return $result;
        }
    }

    public function createRetention(Request $request)
    {

        if (!isset($request->token) || !isset($request->data)) {
            $result = ['Result' => 'Requerimiento malformado, el parametro token y data son obligatorios'];
            return $result;
        }
        $validar = $this->validateToken();
        if ($validar == false) {
            $result = ['Result' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
            return $result;
        }

        $token = base64_decode($request->token, true);

        if ($token != $this->company->tokenApi) {
            $result = ['Result' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
            return $result;
        }

        $datos = json_decode(base64_decode($request->data, true), true);
        $datos = $datos[0];

        $docuemntoValidador = CabeceraDocumentoElectronica::where('idComporbante', 'R' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'])->get();
        if (count($docuemntoValidador) > 0) {
            $result = ['Result' => 'El Documento : R' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'] . ' ya se encuentra registrado en el sistema'];
            return $result;
        }
        if (in_array($datos['tipoComprobante'], [7]) == false) {

            $result = ['Result' => 'El tipo de documento : ' . $datos['tipoComprobante'] . ' no se puede procesar en este servicio'];
            return $result;
        }

        $jsonError = null;
        $result = null;
        $whileResult = true;
        $structureError = null;
        $detalleError = null;
        $docID = null;
        $result = null;

        switch (json_last_error()) {
            case JSON_ERROR_NONE:
                $jsonError = "Sin errores";
                $result = true;
                break;
            case JSON_ERROR_DEPTH:
                $jsonError = "Profundidad maxima superada en nodos";
                $result = false;
                break;
            case JSON_ERROR_STATE_MISMATCH:
                $jsonError = "JSON inválido o malformado";
                $result = false;
                break;
            case JSON_ERROR_CTRL_CHAR:
                $jsonError = "Error en el control de caracteres";
                $result = false;
                break;
            case JSON_ERROR_SYNTAX:
                $jsonError = "Error de Syntaxis";
                $result = false;
                break;
            case JSON_ERROR_UTF8:
                $jsonError = "Caracter UTF-8 malformado";
                $result = false;
                break;
            default:
                $jsonError = "Error desconocido";
                $result = false;
                break;
        }

        if ($result) {

            try {

                $fcatura = new CabeceraDocumentoElectronica();
                while ($whileResult == true) {

                    if (isset($datos['idInterno'])) {
                        $fcatura->idInterno = $datos['idInterno'];
                    }

                    if (isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) > 0) {
                        $fcatura->fecha = $datos['fecha'];
                    }
                    if (!isset($datos['fecha']) || preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fecha' es obligatorio y debe cumplir el formato de  YYYY-MM-DD";
                        break;
                    }

                    if (isset($datos['fechaFizcal']) && $datos['fechaFizcal'] != '') {
                        $fcatura->fechaFizcal = $datos['fechaFizcal'];
                    }
                    if (!isset($datos['fechaFizcal']) || $datos['fechaFizcal'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fechaFizcal' es obligatorio";
                        break;
                    }

                    if (isset($datos['cliente']) && $datos['cliente'] != '') {
                        $fcatura->cliente = $datos['cliente'];
                    }

                    if (!isset($datos['cliente']) || $datos['cliente'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'cliente' es obligatorio";
                        break;
                    }
                    if (isset($datos['direccion']) && $datos['direccion'] != '') {
                        $fcatura->direccion = $datos['direccion'];
                    }
                    if (!isset($datos['direccion']) || $datos['direccion'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccion' es obligatorio";
                        break;
                    }
                    if (isset($datos['telefono']) && $datos['telefono'] != '') {
                        $fcatura->telefono = $datos['telefono'];
                    }

                    if (!isset($datos['telefono']) || $datos['telefono'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'telefono' es obligatorio";
                        break;
                    }
                    if (isset($datos['ruc']) && $datos['ruc'] != '') {
                        $fcatura->ruc = $datos['ruc'];
                    }

                    if (!isset($datos['ruc']) || $datos['ruc'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ruc/ci' del cliente es obligatorio";
                        break;
                    }
                    if (isset($datos['tipoComprobante']) && $datos['tipoComprobante'] != '') {
                        $fcatura->tipoComprobante = $datos['tipoComprobante'];
                    }

                    if (!isset($datos['tipoComprobante']) || $datos['tipoComprobante'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoComprobante' es obligatorio";
                        break;
                    }



                    if (isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] != '') {
                        $fcatura->tipoIdentificador = $datos['tipoIdentificador'];
                    }

                    if (!isset($datos['tipoIdentificador']) || $datos['tipoIdentificador'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoIdentificador' es obligatorio";
                        break;
                    }

                    if (isset($datos['tipoSujetoRetenido']) && $datos['tipoSujetoRetenido'] != '') {
                        $fcatura->tipoSujetoRetenido = $datos['tipoSujetoRetenido'];
                    }

                    if (isset($datos['correo']) && $datos['correo'] != '') {
                        $fcatura->correo = $datos['correo'];
                    }

                    if (!isset($datos['correo']) || $datos['correo'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'correo' es obligatorio";
                        break;
                    }

                    if (isset($datos['establecimiento']) && $datos['establecimiento'] != '' && strlen($datos['establecimiento']) == 3) {
                        $fcatura->establecimiento = $datos['establecimiento'];
                    }

                    if (!isset($datos['establecimiento']) || $datos['establecimiento'] == '' || strlen($datos['establecimiento']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'establecimiento' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['ptoEmision']) && $datos['ptoEmision'] != '' && strlen($datos['ptoEmision']) == 3) {
                        $fcatura->ptoEmision = $datos['ptoEmision'];
                    }

                    if (!isset($datos['ptoEmision']) || $datos['ptoEmision'] == '' || strlen($datos['ptoEmision']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ptoEmision' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['rucEmpresa']) && $datos['rucEmpresa'] != '' && strlen($datos['rucEmpresa']) == 13) {
                        $fcatura->rucEmpresa = $datos['rucEmpresa'];
                    }

                    if (!isset($datos['rucEmpresa']) || $datos['rucEmpresa'] == '' || strlen($datos['rucEmpresa']) != 13) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'rucEmpresa' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['secuencial']) && $datos['secuencial'] != '' && strlen($datos['secuencial']) == 9) {
                        $fcatura->secuencial = $datos['secuencial'];
                    }

                    if (!isset($datos['secuencial']) || $datos['secuencial'] == '' || strlen($datos['secuencial']) != 9) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'secuencial' es obligatorio y debe ser de 9 dígitos";
                        break;
                    }

                    if (isset($datos['ambiente']) && $datos['ambiente'] != '' && strlen($datos['ambiente']) == 1) {
                        $fcatura->ambiente = $datos['ambiente'];
                    }

                    if (!isset($datos['ambiente']) || $datos['ambiente'] == '' || strlen($datos['ambiente']) != 1) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ambiente' es obligatorio y solo es un dígito";
                        break;
                    }

                    if (isset($datos['razonSocial']) && $datos['razonSocial'] != '') {
                        $fcatura->razonSocial = $datos['razonSocial'];
                    }

                    if (!isset($datos['razonSocial']) || $datos['razonSocial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'razonSocial' es obligatorio";
                        break;
                    }

                    if (isset($datos['nombreComercial']) && $datos['nombreComercial'] != '') {
                        $fcatura->nombreComercial = $datos['nombreComercial'];
                    }

                    if (!isset($datos['nombreComercial']) || $datos['nombreComercial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'nombreComercial' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionMatriz']) && $datos['direccionMatriz'] != '') {
                        $fcatura->direccionMatriz = $datos['direccionMatriz'];
                    }
                    if (!isset($datos['direccionMatriz']) || $datos['direccionMatriz'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccionMatriz' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionEstablecimiento']) && $datos['direccionEstablecimiento'] != '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionEstablecimiento'];
                    }

                    if (!isset($datos['direccionEstablecimiento']) || $datos['direccionEstablecimiento'] == '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionMatriz'];
                    }

                    if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '' && strlen($datos['obligadoContabilidad']) == 2 && in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no'])) {
                        $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                    }
                    if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '' || strlen($datos['obligadoContabilidad']) != 2 || in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no']) == false) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'obligadoContabilidad' es obligatorio, y solo se aceptan los terminos 'SI' o 'NO'";
                        break;
                    }

                    //CAMBIOS RETENCIONES

                    if (isset($datos['numeroCE']) && $datos['numeroCE'] != '') {
                        $fcatura->numeroCE = $datos['numeroCE'];
                    }

                    if (isset($datos['codSustento']) && $datos['codSustento'] != '') {
                        $fcatura->codSustento = $datos['codSustento'];
                    }
                    if (!isset($datos['codSustento']) || $datos['codSustento'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'codSustento' es obligatorio";
                        break;
                    }

                    if (isset($datos['codDocSustento']) && $datos['codDocSustento'] != '') {
                        $fcatura->codDocSustento = $datos['codDocSustento'];
                    }
                    if (!isset($datos['codDocSustento']) || $datos['codDocSustento'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'codDocSustento' es obligatorio";
                        break;
                    }

                    if (isset($datos['parteRel']) && $datos['parteRel'] != '') {
                        $fcatura->parteRel = $datos['parteRel'];
                    }
                    if (!isset($datos['parteRel']) || $datos['parteRel'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'parteRel' es obligatorio";
                        break;
                    }

                    if (isset($datos['numAuthSustento']) && $datos['numAuthSustento'] != '') {
                        $fcatura->numAuthSustento = $datos['numAuthSustento'];
                    }
                    if (!isset($datos['numAuthSustento']) || $datos['numAuthSustento'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'numAuthSustento' es obligatorio";
                        break;
                    }

                    if (isset($datos['pagoLocExt']) && $datos['pagoLocExt'] != '') {
                        $fcatura->pagoLocExt = $datos['pagoLocExt'];
                    }
                    if (!isset($datos['pagoLocExt']) || $datos['pagoLocExt'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'pagoLocExt' es obligatorio";
                        break;
                    }

                    if (isset($datos['tipoRegi']) && $datos['tipoRegi'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->tipoRegi = $datos['tipoRegi'];
                    }
                    if (!isset($datos['tipoRegi']) && $datos['pagoLocExt'] != '01' || $datos['tipoRegi'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoRegi' es obligatorio";
                        break;
                    }

                    if (isset($datos['paisEfecPago']) && $datos['paisEfecPago'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->paisEfecPago = $datos['paisEfecPago'];
                    }
                    if (!isset($datos['paisEfecPago']) && $datos['pagoLocExt'] != '01' || $datos['paisEfecPago'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'paisEfecPago' es obligatorio";
                        break;
                    }

                    if (isset($datos['aplicConvDobTrib']) && $datos['aplicConvDobTrib'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->aplicConvDobTrib = $datos['aplicConvDobTrib'];
                    }
                    if (!isset($datos['aplicConvDobTrib']) && $datos['pagoLocExt'] != '01' || $datos['aplicConvDobTrib'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'aplicConvDobTrib' es obligatorio";
                        break;
                    }

                    if (isset($datos['pagExtSujRetNorLeg']) && $datos['pagExtSujRetNorLeg'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->pagExtSujRetNorLeg = $datos['pagExtSujRetNorLeg'];
                    }
                    if (!isset($datos['pagExtSujRetNorLeg']) && $datos['pagoLocExt'] != '01' || $datos['pagExtSujRetNorLeg'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'pagExtSujRetNorLeg' es obligatorio";
                        break;
                    }

                    if (isset($datos['pagoRegFis']) && $datos['pagoRegFis'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->pagoRegFis = $datos['pagoRegFis'];
                    }

                    if (!isset($datos['pagoRegFis']) && $datos['pagoLocExt'] != '01' || $datos['pagoRegFis'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'pagoRegFis' es obligatorio";
                        break;
                    }

                    if (isset($datos['claveAcceso']) && $datos['claveAcceso'] != '') {
                        $fcatura->claveAcceso = $datos['claveAcceso'];
                    }

                    if (isset($datos['importeSinImpuestos']) && is_numeric($datos['importeSinImpuestos']) > 0) {
                        $fcatura->importeSinImpuestos = $datos['importeSinImpuestos'];
                    }
                    if (!isset($datos['importeSinImpuestos']) || is_numeric($datos['importeSinImpuestos']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeSinImpuestos' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['importeTotal']) && is_numeric($datos['importeTotal']) > 0) {
                        $fcatura->importeTotal = $datos['importeTotal'];
                    }
                    if (!isset($datos['importeTotal']) || is_numeric($datos['importeTotal']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeTotal' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['baseIva12']) && is_numeric($datos['baseIva12']) > 0) {
                        $fcatura->baseIva12 = $datos['baseIva12'];
                    }
                    // if (!isset($datos['baseIva12']) || is_numeric($datos['baseIva12']) < 1) {
                    //     $result = false;
                    //     $whileResult = false;
                    //     $detalleError = "El campo 'baseIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                    //     break;
                    // }

                    if (isset($datos['valorIva12']) && is_numeric($datos['valorIva12']) > 0) {
                        $fcatura->valorIva12 = $datos['valorIva12'];
                    }

                    // if (!isset($datos['valorIva12']) || is_numeric($datos['valorIva12']) < 1) {
                    //     $result = false;
                    //     $whileResult = false;
                    //     $detalleError = "El campo 'valorIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                    //     break;
                    // }

                    if (isset($datos['baseIva0']) && is_numeric($datos['baseIva0']) > 0) {
                        $fcatura->baseIva0 = $datos['baseIva0'];
                    }

                    // if (!isset($datos['baseIva0']) || is_numeric($datos['baseIva0']) < 1) {
                    //     $result = false;
                    //     $whileResult = false;
                    //     $detalleError = "El campo 'baseIva0' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                    //     break;
                    // }

                    if (isset($datos['fPagos']) && $datos['fPagos'] != '') {
                        $fcatura->fPagos = json_encode($datos['fPagos']);
                    }
                    if (!isset($datos['fPagos']) || $datos['fPagos'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fPagos' es obligatorio";
                        break;
                    }
                    if (isset($datos['impuestos']) && $datos['impuestos'] != '') {
                        $fcatura->impuestos = json_encode($datos['impuestos']);
                    }
                    if (isset($datos['adicionales']) && $datos['adicionales'] != '') {
                        $fcatura->adicionales = $datos['adicionales'];
                    }

                    $fcatura->idComporbante = 'R' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'];
                    $fcatura->idEstado = '01';
                    $fcatura->orderNo =  $fcatura->secuencial;
                    $save = $fcatura->save();
                    $docID = $fcatura->idComporbante;

                    if ($save) {
                        if (!isset($datos['Detalle']) || $datos['Detalle'] == '') {
                            $result = false;
                            $fcatura->delete();
                            $whileResult = false;
                            break;
                        }
                        $detalles = $datos['Detalle'] ?? $datos['detalle'];
                        foreach ($detalles as $value) {
                            try {

                                $detalle = new DetalleRetencionElectronica();
                                $detalle->idComporbante = $fcatura->idComporbante;
                                $detalle->codigoRet = $value['codigoRet'];
                                $detalle->baseRet = $value['baseRet'];
                                $detalle->porcentajeRet = $value['porcentajeRet'];
                                $detalle->valorRet = $value['valorRet'];
                                $detalle->tipoDocAfectado = $value['tipoDocAfectado'];
                                $detalle->serieDocAfectado = $value['serieDocAfectado'];
                                $detalle->fechaDocAfectado = $value['fechaDocAfectado'];
                                $detalle->idLinea = $fcatura->idComporbante . '-' . $value['idlinea'];

                                if ($fcatura->codSustento == '10') {

                                    if (!isset($value['fechaPagoDiv']) || $value['fechaPagoDiv'] == '') {
                                        $fcatura->delete();
                                        $result = false;
                                        $docID = "N/A";
                                        throw new Exception("El campo fechaPagoDiv es obligatorio cuando codSustento es 10 ");
                                    }

                                    if (!isset($value['imRentaSoc']) || $value['imRentaSoc'] == '') {
                                        $fcatura->delete();
                                        $result = false;
                                        $docID = "N/A";
                                        throw new Exception("El campo imRentaSoc es obligatorio cuando codSustento es 10 ");
                                    }

                                    if (!isset($value['ejerFisUtDiv']) || $value['ejerFisUtDiv'] == '') {
                                        $fcatura->delete();
                                        $result = false;
                                        $docID = "N/A";
                                        throw new Exception("El campo ejerFisUtDiv es obligatorio cuando codSustento es 10 ");
                                    }
                                }

                                $detalle->fechaPagoDiv = ($fcatura->codSustento == '10') ? $value['fechaPagoDiv'] : null;
                                $detalle->imRentaSoc = ($fcatura->codSustento == '10') ? $value['imRentaSoc'] : null;
                                $detalle->ejerFisUtDiv = ($fcatura->codSustento == '10') ? $value['ejerFisUtDiv'] : null;

                                $detalle->save();
                                $result = true;
                            } catch (QueryException $exPdo) {

                                $fcatura->delete();
                                $result = false;
                                $docID = "N/A";
                                $detalleError = $exPdo;
                                throw new Exception('Error al tratar de generar detalle de la retencion : ' . json_encode($exPdo));
                                //break;
                            }
                        }
                    }
                    //$result = true;
                    $this->createClient($fcatura->cliente, $fcatura->ruc, $fcatura->razonSocial, $fcatura->correo, $fcatura->telefono, $fcatura->direccion);
                    $whileResult = false;
                }
            } catch (Exception $ex) {
                $result = false;
                $detalleError = $ex->getMessage();
            }

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
        } else {

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
        }

        return $result;
    }

    public function getStatusDocument(Request $request)
    {

        if (!isset($request->token) || !isset($request->document)) {
            $result = ['Response' => 'Requerimiento malformado, el parametro token y document son obligatorios'];
            return $result;
        }
        $validar = $this->validateToken();
        if ($validar == false) {
            $result = ['Response' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
            return $result;
        }

        $token = base64_decode($request->token, true);

        if ($token != $this->company->tokenApi) {
            $result = ['Response' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
            return $result;
        }

        $idDocumento = base64_decode($request->document);

        $doc = CabeceraDocumentoElectronica::where('idComporbante', $idDocumento)->get();

        if ($doc && $doc->count() > 0) {

            $estado = StateType::find($doc[0]->idEstado);
            $result = ['Response' => 'Se encontro el documento: ' . $idDocumento . ' en el sistema', 'ClaveAcceso' => $doc[0]->claveAcceso, 'Status' => $estado->description, 'ResponseText' => json_decode($doc[0]->responseRegularizeShipping)];
            return $result;
        } else {
            $result = ['Response' => 'No se encontro el documento: ' . $idDocumento . ' en el sistema', 'Status' => 'N/A', 'ResponseText' => 'N/A'];
            return $result;
        }
    }

    public function deleteDocument(Request $request)
    {

        if (!isset($request->token) || !isset($request->document)) {
            $result = ['Response' => 'Requerimiento malformado, el parametro token y document son obligatorios'];
            return $result;
        }
        $validar = $this->validateToken();
        if ($validar == false) {
            $result = ['Response' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
            return $result;
        }

        $token = base64_decode($request->token, true);

        if ($token != $this->company->tokenApi) {
            $result = ['Response' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
            return $result;
        }

        $idDocumento = base64_decode($request->document);

        $doc = CabeceraDocumentoElectronica::where('idComporbante', $idDocumento)->get();

        if ($doc && $doc->count() > 0) {
            $doc[0]->delete();
            $result = ['Response' => 'Se elimino el documento: ' . $idDocumento . ' en el sistema'];
            return $result;
        } else {
            $result = ['Response' => 'No se encontro el documento: ' . $idDocumento . ' en el sistema'];
            return $result;
        }
    }

    public function reCreateInvoice(Request $request)
    {

        $jsonError = null;
        $result = null;
        $whileResult = true;
        $structureError = null;
        $detalleError = null;
        $docID = null;
        $result = null;
        $secuencialDoc = null;
        $rucEmpresa = null;

        try {

            if (!isset($request->token) || !isset($request->data)) {
                $result = ['Response' => 'Requerimiento malformado, el parametro token y data son obligatorios'];
                return $result;
            }
            $validar = $this->validateToken();
            if ($validar == false) {
                $result = ['Response' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
                return $result;
            }

            $token = base64_decode($request->token, true);
            //Log::info($token);

            if ($token != $this->company->tokenApi) {
                $result = ['Response' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
                return $result;
            }

            $datos = json_decode(base64_decode($request->data, true), true);
            $datos = $datos[0];

            //Log::info(json_last_error_msg());
            //Log::info(base64_decode($request->data,true));

            switch (json_last_error()) {

                case JSON_ERROR_NONE:
                    $jsonError = "Sin errores";
                    $result = true;
                    break;
                case JSON_ERROR_DEPTH:
                    $jsonError = "Profundidad maxima superada en nodos";
                    $result = false;
                    break;
                case JSON_ERROR_STATE_MISMATCH:
                    $jsonError = "JSON inválido o malformado";
                    $result = false;
                    break;
                case JSON_ERROR_CTRL_CHAR:
                    $jsonError = "Error en el control de caracteres";
                    $result = false;
                    break;
                case JSON_ERROR_SYNTAX:
                    $jsonError = "Error de Syntaxis";
                    $result = false;
                    break;
                case JSON_ERROR_UTF8:
                    $jsonError = "Caracter UTF-8 malformado";
                    $result = false;
                    break;
                default:
                    $jsonError = "Error desconocido";
                    $result = false;
                    break;
            }

            $facturaValidador = CabeceraDocumentoElectronica::where('idComporbante', 'F' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'])->get();

            if (count($facturaValidador) < 1) {
                $result = ['Response' => 'El Documento : F' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'] . ' no se encuentra registrado en el sistema'];
                return $result;
            } else {

                $facturaValidador->delete();
            }

            if ($result) {

                try {

                    $fcatura = new CabeceraDocumentoElectronica();
                    while ($whileResult == true) {
                        if (isset($datos['idInterno'])) {
                            $fcatura->idInterno = $datos['idInterno'];
                        }

                        if (isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) > 0) {
                            $fcatura->fecha = $datos['fecha'];
                        }
                        if (!isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'fecha' es obligatorio y debe cumplir el formato de  YYYY-MM-DD";
                            break;
                        }
                        if (isset($datos['cliente']) && $datos['cliente'] != '') {
                            $fcatura->cliente = $datos['cliente'];
                        }
                        if (!isset($datos['cliente']) && $datos['cliente'] == '') {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'cliente' es obligatorio";
                            break;
                        }
                        if (isset($datos['direccion']) && $datos['direccion'] != '') {
                            $fcatura->direccion = $datos['direccion'];
                        }
                        if (!isset($datos['direccion']) && $datos['direccion'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'direccion' es obligatorio";
                            break;
                        }
                        if (isset($datos['telefono']) && $datos['telefono'] != '') {
                            $fcatura->telefono = $datos['telefono'];
                        }

                        if (!isset($datos['telefono']) && $datos['telefono'] == '') {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'telefono' es obligatorio";
                            break;
                        }
                        if (isset($datos['ruc']) && $datos['ruc'] != '') {
                            $fcatura->ruc = $datos['ruc'];
                        }

                        if (!isset($datos['ruc']) && $datos['ruc'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ruc/ci' del cliente es obligatorio";
                            break;
                        }
                        if (isset($datos['tipoComprobante']) && $datos['tipoComprobante'] != '' && in_array($datos['tipoComprobante'], [1])) {
                            $fcatura->tipoComprobante = $datos['tipoComprobante'];
                        }

                        if (!isset($datos['tipoComprobante']) && $datos['tipoComprobante'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'tipoComprobante' es obligatorio";
                            break;
                        }
                        if (in_array($datos['tipoComprobante'], [1]) == false) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "EL tipo de archivo " . $datos['tipoComprobante'] . " no puede ser procesado en este servicio, por favor utiliza el servicio correspondiente";
                            break;
                        }

                        if (isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] != '') {
                            $fcatura->tipoIdentificador = $datos['tipoIdentificador'];
                        }

                        if (!isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'tipoIdentificador' es obligatorio";
                            break;
                        }

                        if (isset($datos['correo']) && $datos['correo'] != '') {
                            $fcatura->correo = $datos['correo'];
                        }
                        if (!isset($datos['correo']) && $datos['correo'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'correo' es obligatorio";
                            break;
                        }

                        if (isset($datos['establecimiento']) && $datos['establecimiento'] != '' && strlen($datos['establecimiento']) == 3) {
                            $fcatura->establecimiento = $datos['establecimiento'];
                        }

                        if (!isset($datos['establecimiento']) || $datos['establecimiento'] == '' || strlen($datos['establecimiento']) != 3) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'establecimiento' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['ptoEmision']) && $datos['ptoEmision'] != '' && strlen($datos['ptoEmision']) == 3) {
                            $fcatura->ptoEmision = $datos['ptoEmision'];
                        }

                        if (!isset($datos['ptoEmision']) || $datos['ptoEmision'] == '' || strlen($datos['ptoEmision']) != 3) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ptoEmision' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['rucEmpresa']) && $datos['rucEmpresa'] != '' && strlen($datos['rucEmpresa']) == 13) {
                            $fcatura->rucEmpresa = $datos['rucEmpresa'];
                        }

                        if (!isset($datos['rucEmpresa']) || $datos['rucEmpresa'] == '' || strlen($datos['rucEmpresa']) != 13) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'rucEmpresa' es obligatorio y debe ser de tres dígitos";
                            break;
                        }

                        if (isset($datos['secuencial']) && $datos['secuencial'] != '' && strlen($datos['secuencial']) == 9) {
                            $fcatura->secuencial = $datos['secuencial'];
                        }
                        if (!isset($datos['secuencial']) || $datos['secuencial'] == '' || strlen($datos['secuencial']) != 9) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'secuencial' es obligatorio y debe ser de 9 dígitos";
                            break;
                        }

                        if (isset($datos['ambiente']) && $datos['ambiente'] != '' && strlen($datos['ambiente']) == 1) {
                            $fcatura->ambiente = $datos['ambiente'];
                        }

                        if (!isset($datos['ambiente']) || $datos['ambiente'] == '' || strlen($datos['ambiente']) != 1) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'ambiente' es obligatorio y solo es un dígito";
                            break;
                        }

                        if (isset($datos['razonSocial']) && $datos['razonSocial'] != '') {
                            $fcatura->razonSocial = $datos['razonSocial'];
                        }

                        if (!isset($datos['razonSocial']) || $datos['razonSocial'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'razonSocial' es obligatorio";
                            break;
                        }

                        if (isset($datos['nombreComercial']) && $datos['nombreComercial'] != '') {
                            $fcatura->nombreComercial = $datos['nombreComercial'];
                        }

                        if (!isset($datos['nombreComercial']) || $datos['nombreComercial'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'nombreComercial' es obligatorio";
                            break;
                        }

                        if (isset($datos['direccionMatriz']) && $datos['direccionMatriz'] != '') {
                            $fcatura->direccionMatriz = $datos['direccionMatriz'];
                        }
                        if (!isset($datos['direccionMatriz']) || $datos['direccionMatriz'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'direccionMatriz' es obligatorio";
                            break;
                        }

                        if (isset($datos['direccionEstablecimiento']) && $datos['direccionEstablecimiento'] != '') {
                            $fcatura->direccionEstablecimiento = $datos['direccionEstablecimiento'];
                        }

                        if (!isset($datos['direccionEstablecimiento']) || $datos['direccionEstablecimiento'] == '') {
                            $fcatura->direccionEstablecimiento = $datos['direccionMatriz'];
                        }

                        if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '') {
                            $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                        }

                        if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '') {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'obligadoContabilidad' es obligatorio";
                            break;
                        }

                        if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '' && strlen($datos['obligadoContabilidad']) == 2 && in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no'])) {
                            $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                        }
                        if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '' || strlen($datos['obligadoContabilidad']) != 2 || in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no']) == false) {

                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'obligadoContabilidad' es obligatorio, y solo se aceptan los terminos 'SI' o 'NO'";
                            break;
                        }

                        if (isset($datos['numeroCE']) && $datos['numeroCE'] != '') {
                            $fcatura->numeroCE = $datos['numeroCE'];
                        }

                        if (isset($datos['claveAcceso']) && $datos['claveAcceso'] != '') {
                            $fcatura->claveAcceso = $datos['claveAcceso'];
                        }

                        if (isset($datos['importeSinImpuestos']) && $datos['importeSinImpuestos'] != '' && is_numeric($datos['importeSinImpuestos']) > 0) {
                            $fcatura->importeSinImpuestos = $datos['importeSinImpuestos'];
                        }
                        if (!isset($datos['importeSinImpuestos']) || $datos['importeSinImpuestos'] == '' || is_numeric($datos['importeSinImpuestos']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'importeSinImpuestos' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            break;
                        }

                        if (isset($datos['descuento']) && is_numeric($datos['descuento']) > 0) {
                            $fcatura->descuento = $datos['descuento'];
                        }

                        if (!isset($datos['descuento']) || is_numeric($datos['descuento']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'descuento' es obligatorio, solo se aceptan valores de tipo DOUBLE, valor recibido : " . $datos['descuento'];
                            break;
                        }

                        if (isset($datos['importeTotal']) && $datos['importeTotal'] != '' && is_numeric($datos['importeTotal']) > 0) {
                            $fcatura->importeTotal = $datos['importeTotal'];
                        }
                        if (!isset($datos['importeTotal']) || $datos['importeTotal'] == '' || is_numeric($datos['importeTotal']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'importeTotal' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            break;
                        }

                        if (isset($datos['baseIva12']) && is_numeric($datos['baseIva12']) > 0) {
                            $fcatura->baseIva12 = $datos['baseIva12'];
                        }
                        if (isset($datos['baseIva12']) == false || is_numeric($datos['baseIva12']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'baseIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE " . isset($datos['baseIva12']) . ' - ' . $datos['baseIva12'] . ' - ' . is_numeric($datos['baseIva12']);
                            break;
                        }

                        if (isset($datos['valorIva12']) && is_numeric($datos['valorIva12']) > 0) {
                            $fcatura->valorIva12 = $datos['valorIva12'];
                        }

                        if (!isset($datos['valorIva12']) || is_numeric($datos['valorIva12']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'valorIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            break;
                        }

                        if (isset($datos['baseIva0'])  && is_numeric($datos['baseIva0']) > 0) {
                            $fcatura->baseIva0 = $datos['baseIva0'];
                        }

                        if (!isset($datos['baseIva0']) || is_numeric($datos['baseIva0']) < 1) {
                            $result = false;
                            $whileResult = false;
                            $detalleError = "El campo 'baseIva0' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                            break;
                        }

                        if (isset($datos['adicionales']) && $datos['adicionales'] != '') {
                            $fcatura->adicionales = $datos['adicionales'];
                        }

                        if (isset($datos['fPagos']) && $datos['fPagos'] != '') {
                            $fcatura->fPagos = json_encode($datos['fPagos']);
                        }

                        $fcatura->idComporbante = 'F' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'];
                        $fcatura->idEstado = '01';
                        $fcatura->orderNo =  $fcatura->secuencial;
                        $fcatura->save();
                        $docID = $fcatura->idComporbante;
                        $rucEmpresa = $fcatura->rucEmpresa;

                        if (isset($datos['Detalle']) == false || $datos['Detalle'] == '') {
                            $result = false;
                            $fcatura->delete();
                            $whileResult = false;
                            break;
                        }

                        $detalles = $datos['Detalle'];
                        foreach ($detalles as $value) {
                            try {
                                $detalle = new DetalleFacturaElectronica();
                                $detalle->cantidad = ($value['cantidad'] && $value['cantidad'] > 0) ? $value['cantidad'] : null;
                                $detalle->item = ($value['item'] && trim($value['item']) != '') ? trim($value['item']) : null;
                                $detalle->precioUnitario = (isset($value['precioUnitario'])) ? $value['precioUnitario'] : null;
                                $detalle->descuento = (isset($value['descuentoLinea'])) ? $value['descuentoLinea'] : null;
                                $detalle->total = (isset($value['total'])) ? $value['total'] : null;
                                $detalle->iva = $value['iva'];
                                $iva_code = 0;
                                switch (intVal($value['iva'])) {
                                    case 0:
                                        $iva_code = 0;
                                        break;
                                    case 5:
                                        $iva_code = 5;
                                        break;
                                    case 12:
                                        $iva_code = 2;
                                        break;
                                    case 14:
                                        $iva_code = 3;
                                        break;
                                    case 15:
                                        $iva_code = 4;
                                        break;
                                    case 8:
                                        $iva_code = 8;
                                        break;
                                }
                                $detalle->iva_code = $iva_code;
                                $detalle->ice = $value['ice'];
                                $detalle->irbpnr = $value['irbpnr'];
                                $detalle->codigoIce = $value['codigoIce'];
                                $detalle->codigoPorcentajeIce = $value['codigoPorcentajeIce'];
                                $detalle->baseImponibleIce = $value['baseImponibleIce'];
                                $detalle->tarifaIce = $value['tarifaIce'];
                                $detalle->ValorIce = $value['ValorIce'];
                                $detalle->codigoIrbpnr = $value['codigoIrbpnr'];
                                $detalle->codigoPorcentajeIrbpnr = $value['codigoPorcentajeIrbpnr'];
                                $detalle->baseImponibleIrbpnr = $value['baseImponibleIrbpnr'];
                                $detalle->tarifaIrbpnr = $value['tarifaIrbpnr'];
                                $detalle->valorIrbpnr = $value['valorIrbpnr'];
                                $detalle->idComporbante =  $fcatura->idComporbante;
                                $detalle->idLinea = $fcatura->idComporbante . '-' . $value['idlinea'];
                                $detalle->codItem = ($value['codItem'] && trim($value['codItem']) != '') ? trim($value['codItem']) : null;
                                $detalle->save();
                                $result = true;
                            } catch (QueryException $exPdo) {

                                $fcatura->delete();
                                $result = false;
                                $docID = "N/A";
                                $detalleError = $exPdo;
                                Log::error('Error al tratar de generar detalle de la factura : ' . json_encode($exPdo));
                                break;
                            }
                        }
                        $secuencialDoc = $fcatura->secuencial;
                        $whileResult = false;
                    }
                } catch (Exception $ex) {
                    $result = false;
                    $structureError = $ex->getMessage();
                }

                $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID, 'secuencial' => $secuencialDoc, 'rucEmpresa' => $rucEmpresa];
            } else {

                $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
            }
            return $result;
        } catch (Exception $ex) {
            $result = ['Result' => 'No se pudo procesar su requerimiento, ERROR: ' . $ex->getMessage()];
            return $result;
        }
    }

    public function reCreateNote(Request $request)
    {

        if (!isset($request->token) || !isset($request->data)) {
            $result = ['Result' => 'Requerimiento malformado, el parametro token y data son obligatorios'];
            return $result;
        }
        $validar = $this->validateToken();
        if ($validar == false) {
            $result = ['Result' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
            return $result;
        }

        $token = base64_decode($request->token, true);

        if ($token != $this->company->tokenApi) {
            $result = ['Result' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
            return $result;
        }

        $datos = json_decode(base64_decode($request->data, true), true);
        $datos = $datos[0];

        $jsonError = null;

        $whileResult = true;
        $structureError = null;
        $detalleError = null;
        $docID = null;
        $result = null;

        switch (json_last_error()) {
            case JSON_ERROR_NONE:
                $jsonError = "Sin errores";
                $result = true;
                break;
            case JSON_ERROR_DEPTH:
                $jsonError = "Profundidad maxima superada en nodos";
                $result = false;
                break;
            case JSON_ERROR_STATE_MISMATCH:
                $jsonError = "JSON inválido o malformado";
                $result = false;
                break;
            case JSON_ERROR_CTRL_CHAR:
                $jsonError = "Error en el control de caracteres";
                $result = false;
                break;
            case JSON_ERROR_SYNTAX:
                $jsonError = "Error de Syntaxis";
                $result = false;
                break;
            case JSON_ERROR_UTF8:
                $jsonError = "Caracter UTF-8 malformado";
                $result = false;
                break;
            default:
                $jsonError = "Error desconocido";
                $result = false;
                break;
        }

        $docuemntoValidador = CabeceraDocumentoElectronica::where('idComporbante', 'N' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'])->get();
        if (count($docuemntoValidador) < 1) {
            $result = ['Result' => 'El Documento : N' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'] . ' no se encuentra registrado en el sistema'];
            return $result;
        } else {

            $docuemntoValidador->delete();
        }

        if ($result) {

            try {

                $fcatura = new CabeceraDocumentoElectronica();
                while ($whileResult == true) {
                    if (isset($datos['idInterno'])) {
                        $fcatura->idInterno = $datos['idInterno'];
                    }
                    if (isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) > 0) {
                        $fcatura->fecha = $datos['fecha'];
                    }
                    if (!isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fecha' es obligatorio y debe cumplir el formato de  YYYY-MM-DD";
                        break;
                    }
                    if (isset($datos['cliente']) && $datos['cliente'] != '') {
                        $fcatura->cliente = $datos['cliente'];
                    }
                    if (!isset($datos['cliente']) && $datos['cliente'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'cliente' es obligatorio";
                        break;
                    }
                    if (isset($datos['direccion']) && $datos['direccion'] != '') {
                        $fcatura->direccion = $datos['direccion'];
                    }
                    if (!isset($datos['direccion']) && $datos['direccion'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccion' es obligatorio";
                        break;
                    }
                    if (isset($datos['telefono']) && $datos['telefono'] != '') {
                        $fcatura->telefono = $datos['telefono'];
                    }

                    if (!isset($datos['telefono']) && $datos['telefono'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'telefono' es obligatorio";
                        break;
                    }
                    if (isset($datos['ruc']) && $datos['ruc'] != '') {
                        $fcatura->ruc = $datos['ruc'];
                    }

                    if (!isset($datos['ruc']) && $datos['ruc'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ruc/ci' del cliente es obligatorio";
                        break;
                    }
                    if (isset($datos['tipoComprobante']) && $datos['tipoComprobante'] != '') {
                        $fcatura->tipoComprobante = $datos['tipoComprobante'];
                    }

                    if (!isset($datos['tipoComprobante']) && $datos['tipoComprobante'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoComprobante' es obligatorio";
                        break;
                    }

                    if (in_array($datos['tipoComprobante'], [4]) == false) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "EL tipo de archivo " . $datos['tipoComprobante'] . " no puede ser procesado en este servicio, por favor utiliza el servicio correspondiente";
                        break;
                    }

                    if (isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] != '') {
                        $fcatura->tipoIdentificador = $datos['tipoIdentificador'];
                    }

                    if (!isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoIdentificador' es obligatorio";
                        break;
                    }

                    if (isset($datos['correo']) && $datos['correo'] != '') {
                        $fcatura->correo = $datos['correo'];
                    }

                    if (!isset($datos['correo']) && $datos['correo'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'correo' es obligatorio";
                        break;
                    }

                    if (isset($datos['establecimiento']) && $datos['establecimiento'] != '' && strlen($datos['establecimiento']) == 3) {
                        $fcatura->establecimiento = $datos['establecimiento'];
                    }

                    if (!isset($datos['establecimiento']) || $datos['establecimiento'] == '' || strlen($datos['establecimiento']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'establecimiento' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['ptoEmision']) && $datos['ptoEmision'] != '' && strlen($datos['ptoEmision']) == 3) {
                        $fcatura->ptoEmision = $datos['ptoEmision'];
                    }

                    if (!isset($datos['ptoEmision']) || $datos['ptoEmision'] == '' || strlen($datos['ptoEmision']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ptoEmision' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['rucEmpresa']) && $datos['rucEmpresa'] != '' && strlen($datos['rucEmpresa']) == 13) {
                        $fcatura->rucEmpresa = $datos['rucEmpresa'];
                    }

                    if (!isset($datos['rucEmpresa']) || $datos['rucEmpresa'] == '' || strlen($datos['rucEmpresa']) != 13) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'rucEmpresa' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['secuencial']) && $datos['secuencial'] != '' && strlen($datos['secuencial']) == 9) {
                        $fcatura->secuencial = $datos['secuencial'];
                    }
                    if (!isset($datos['secuencial']) || $datos['secuencial'] == '' || strlen($datos['secuencial']) != 9) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'secuencial' es obligatorio y debe ser de 9 dígitos";
                        break;
                    }

                    if (isset($datos['ambiente']) && $datos['ambiente'] != '' && strlen($datos['ambiente']) == 1) {
                        $fcatura->ambiente = $datos['ambiente'];
                    }

                    if (!isset($datos['ambiente']) || $datos['ambiente'] == '' || strlen($datos['ambiente']) != 1) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ambiente' es obligatorio y solo es un dígito";
                        break;
                    }

                    if (isset($datos['razonSocial']) && $datos['razonSocial'] != '') {
                        $fcatura->razonSocial = $datos['razonSocial'];
                    }

                    if (!isset($datos['razonSocial']) || $datos['razonSocial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'razonSocial' es obligatorio";
                        break;
                    }

                    if (isset($datos['nombreComercial']) && $datos['nombreComercial'] != '') {
                        $fcatura->nombreComercial = $datos['nombreComercial'];
                    }

                    if (!isset($datos['nombreComercial']) || $datos['nombreComercial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'nombreComercial' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionMatriz']) && $datos['direccionMatriz'] != '') {
                        $fcatura->direccionMatriz = $datos['direccionMatriz'];
                    }
                    if (!isset($datos['direccionMatriz']) || $datos['direccionMatriz'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccionMatriz' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionEstablecimiento']) && $datos['direccionEstablecimiento'] != '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionEstablecimiento'];
                    }

                    if (!isset($datos['direccionEstablecimiento']) || $datos['direccionEstablecimiento'] == '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionMatriz'];
                    }

                    if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '' && strlen($datos['obligadoContabilidad']) == 2 && in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no'])) {
                        $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                    }
                    if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '' || strlen($datos['obligadoContabilidad']) != 2 || in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no']) == false) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'obligadoContabilidad' es obligatorio, y solo se aceptan los terminos 'SI' o 'NO'";
                        break;
                    }

                    //CAMBIOS NOTA DE CREDITO

                    if (isset($datos['tipoDocAfectado']) && $datos['tipoDocAfectado'] != '') {
                        $fcatura->tipoDocAfectado = $datos['tipoDocAfectado'];
                    }
                    if (!isset($datos['tipoDocAfectado']) && $datos['tipoDocAfectado'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'obligadoContabilidad' es obligatorio";
                        break;
                    }

                    if (isset($datos['secuencialDocAfectado']) && $datos['secuencialDocAfectado'] != '') {
                        $fcatura->secuencialDocAfectado = $datos['secuencialDocAfectado'];
                    }
                    if (!isset($datos['secuencialDocAfectado']) && $datos['secuencialDocAfectado'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'secuencialDocAfectado' es obligatorio";
                        break;
                    }

                    if (isset($datos['motivoDev']) && $datos['motivoDev'] != '') {
                        $fcatura->motivoDev = $datos['motivoDev'];
                    }
                    if (!isset($datos['motivoDev']) && $datos['motivoDev'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'motivoDev' es obligatorio";
                        break;
                    }

                    if (isset($datos['fechaDocSustento']) && $datos['fechaDocSustento'] != '') {
                        $fcatura->fechaDocSustento = $datos['fechaDocSustento'];
                    }
                    if (!isset($datos['fechaDocSustento']) && $datos['fechaDocSustento'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fechaDocSustento' es obligatorio";
                        break;
                    }

                    if (isset($datos['claveAcceso']) && $datos['claveAcceso'] != '') {
                        $fcatura->claveAcceso = $datos['claveAcceso'];
                    }

                    if (isset($datos['importeSinImpuestos']) && is_numeric($datos['importeSinImpuestos']) > 0) {
                        $fcatura->importeSinImpuestos = $datos['importeSinImpuestos'];
                    }
                    if (!isset($datos['importeSinImpuestos']) || is_numeric($datos['importeSinImpuestos']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeSinImpuestos' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['descuento']) && is_numeric($datos['descuento']) > 0) {
                        $fcatura->descuento = $datos['descuento'];
                    }

                    if (!isset($datos['descuento']) || is_numeric($datos['descuento']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'descuento' es obligatorio, solo se aceptan valores de tipo DOUBLE, valor recibido : " . $datos['descuento'];
                        break;
                    }

                    if (isset($datos['importeTotal']) && is_numeric($datos['importeTotal']) > 0) {
                        $fcatura->importeTotal = $datos['importeTotal'];
                    }
                    if (!isset($datos['importeTotal']) || is_numeric($datos['importeTotal']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeTotal' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['baseIva12']) && is_numeric($datos['baseIva12']) > 0) {
                        $fcatura->baseIva12 = $datos['baseIva12'];
                    }
                    if (!isset($datos['baseIva12']) || is_numeric($datos['baseIva12']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'baseIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['valorIva12']) && is_numeric($datos['valorIva12']) > 0) {
                        $fcatura->valorIva12 = $datos['valorIva12'];
                    }

                    if (!isset($datos['valorIva12']) || is_numeric($datos['valorIva12']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'valorIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['baseIva0']) && is_numeric($datos['baseIva0']) > 0) {
                        $fcatura->baseIva0 = $datos['baseIva0'];
                    }

                    if (!isset($datos['baseIva0']) || is_numeric($datos['baseIva0']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'baseIva0' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['adicionales']) && $datos['adicionales'] != '') {
                        $fcatura->adicionales = $datos['adicionales'];
                    }

                    if (isset($datos['fPagos']) && $datos['fPagos'] != '') {
                        $fcatura->fPagos = json_encode($datos['fPagos']);
                    }


                    $fcatura->idComporbante = 'N' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'];
                    $fcatura->idEstado = '01';
                    $fcatura->orderNo =  $fcatura->secuencial;
                    $save = $fcatura->save();
                    $docID = $fcatura->idComporbante;
                    if (isset($datos['Detalle']) == false || $datos['Detalle'] == '') {
                        $result = false;
                        $fcatura->delete();
                        $whileResult = false;
                        break;
                    }
                    $detalles = $datos['Detalle'];
                    foreach ($detalles as $value) {
                        try {
                            $detalle = new DetalleFacturaElectronica();
                            $detalle->cantidad = ($value['cantidad'] && $value['cantidad'] > 0) ? $value['cantidad'] : null;
                            $detalle->item = ($value['item'] && trim($value['item']) != '') ? trim($value['item']) : null;
                            $detalle->precioUnitario = (isset($value['precioUnitario'])) ? $value['precioUnitario'] : null;
                            $detalle->descuento = (isset($value['descuentoLinea'])) ? $value['descuentoLinea'] : null;
                            $detalle->total = (isset($value['total'])) ? $value['total'] : null;
                            $detalle->iva = $value['iva'];
                            $iva_code = 0;
                            switch (intVal($value['iva'])) {
                                case 0:
                                    $iva_code = 0;
                                    break;
                                case 5:
                                    $iva_code = 5;
                                    break;
                                case 12:
                                    $iva_code = 2;
                                    break;
                                case 14:
                                    $iva_code = 3;
                                    break;
                                case 15:
                                    $iva_code = 4;
                                    break;
                                case 8:
                                    $iva_code = 8;
                                    break;
                            }
                            $detalle->iva_code = $iva_code;
                            $detalle->ice = $value['ice'];
                            $detalle->irbpnr = $value['irbpnr'];
                            $detalle->codigoIce = $value['codigoIce'];
                            $detalle->codigoPorcentajeIce = $value['codigoPorcentajeIce'];
                            $detalle->baseImponibleIce = $value['baseImponibleIce'];
                            $detalle->tarifaIce = $value['tarifaIce'];
                            $detalle->ValorIce = $value['ValorIce'];
                            $detalle->codigoIrbpnr = $value['codigoIrbpnr'];
                            $detalle->codigoPorcentajeIrbpnr = $value['codigoPorcentajeIrbpnr'];
                            $detalle->baseImponibleIrbpnr = $value['baseImponibleIrbpnr'];
                            $detalle->tarifaIrbpnr = $value['tarifaIrbpnr'];
                            $detalle->valorIrbpnr = $value['valorIrbpnr'];
                            $detalle->idComporbante =  $fcatura->idComporbante;
                            $detalle->idLinea = $fcatura->idComporbante . '-' . $value['idlinea'];
                            $detalle->codItem = ($value['codItem'] && trim($value['codItem']) != '') ? trim($value['codItem']) : null;
                            $detalle->save();
                            $result = true;
                        } catch (QueryException $exPdo) {

                            $fcatura->delete();
                            $result = false;
                            $docID = "N/A";
                            $detalleError = $exPdo;
                            Log::error('Error al tratar de generar detalle de la factura : ' . json_encode($exPdo));
                            break;
                        }
                    }
                    //$result = true;
                    $whileResult = false;
                }
            } catch (Exception $ex) {
                $result = false;
                $structureError = $ex->getMessage();
            }

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
        } else {

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
        }

        return $result;
    }

    public function reCreateRetention(Request $request)
    {

        if (!isset($request->token) || !isset($request->data)) {
            $result = ['Result' => 'Requerimiento malformado, el parametro token y data son obligatorios'];
            return $result;
        }
        $validar = $this->validateToken();
        if ($validar == false) {
            $result = ['Result' => 'La empresa ' . $this->company->name . ' no cuenta con el API activada, contacta con el administrador para generar el token de acceso'];
            return $result;
        }

        $token = base64_decode($request->token, true);

        if ($token != $this->company->tokenApi) {
            $result = ['Result' => 'Token inválido, asegurate que el token enviado este corrrecto o contacta con el administrador'];
            return $result;
        }

        $datos = json_decode(base64_decode($request->data, true), true);
        $datos = $datos[0];

        $docuemntoValidador = CabeceraDocumentoElectronica::where('idComporbante', 'R' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'])->get();
        if (count($docuemntoValidador) < 1) {
            $result = ['Result' => 'El Documento : R' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'] . ' no se encuentra registrado en el sistema'];
            return $result;
        } else {
            $docuemntoValidador->delete();
        }

        if (in_array($datos['tipoComprobante'], [7]) == false) {

            $result = ['Result' => 'El tipo de documento : ' . $datos['tipoComprobante'] . ' no se puede procesar en este servicio'];
            return $result;
        }

        $jsonError = null;
        $result = null;
        $whileResult = true;
        $structureError = null;
        $detalleError = null;
        $docID = null;
        $result = null;

        switch (json_last_error()) {
            case JSON_ERROR_NONE:
                $jsonError = "Sin errores";
                $result = true;
                break;
            case JSON_ERROR_DEPTH:
                $jsonError = "Profundidad maxima superada en nodos";
                $result = false;
                break;
            case JSON_ERROR_STATE_MISMATCH:
                $jsonError = "JSON inválido o malformado";
                $result = false;
                break;
            case JSON_ERROR_CTRL_CHAR:
                $jsonError = "Error en el control de caracteres";
                $result = false;
                break;
            case JSON_ERROR_SYNTAX:
                $jsonError = "Error de Syntaxis";
                $result = false;
                break;
            case JSON_ERROR_UTF8:
                $jsonError = "Caracter UTF-8 malformado";
                $result = false;
                break;
            default:
                $jsonError = "Error desconocido";
                $result = false;
                break;
        }

        if ($result) {

            try {

                $fcatura = new CabeceraDocumentoElectronica();
                while ($whileResult == true) {
                    if (isset($datos['idInterno'])) {
                        $fcatura->idInterno = $datos['idInterno'];
                    }
                    if (isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) > 0) {
                        $fcatura->fecha = $datos['fecha'];
                    }
                    if (!isset($datos['fecha']) && preg_match("/[0-9]{4}+-[0-9]{2}+-[0-9]{2}/", $datos['fecha']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fecha' es obligatorio y debe cumplir el formato de  YYYY-MM-DD";
                        break;
                    }

                    if (isset($datos['fechaFizcal']) && $datos['fechaFizcal'] != '') {
                        $fcatura->fechaFizcal = $datos['fechaFizcal'];
                    }
                    if (!isset($datos['fechaFizcal']) && $datos['fechaFizcal'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fechaFizcal' es obligatorio";
                        break;
                    }

                    if (isset($datos['cliente']) && $datos['cliente'] != '') {
                        $fcatura->cliente = $datos['cliente'];
                    }
                    if (!isset($datos['cliente']) && $datos['cliente'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'cliente' es obligatorio";
                        break;
                    }
                    if (isset($datos['direccion']) && $datos['direccion'] != '') {
                        $fcatura->direccion = $datos['direccion'];
                    }
                    if (!isset($datos['direccion']) && $datos['direccion'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccion' es obligatorio";
                        break;
                    }
                    if (isset($datos['telefono']) && $datos['telefono'] != '') {
                        $fcatura->telefono = $datos['telefono'];
                    }

                    if (!isset($datos['telefono']) && $datos['telefono'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'telefono' es obligatorio";
                        break;
                    }
                    if (isset($datos['ruc']) && $datos['ruc'] != '') {
                        $fcatura->ruc = $datos['ruc'];
                    }

                    if (!isset($datos['ruc']) && $datos['ruc'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ruc/ci' del cliente es obligatorio";
                        break;
                    }
                    if (isset($datos['tipoComprobante']) && $datos['tipoComprobante'] != '') {
                        $fcatura->tipoComprobante = $datos['tipoComprobante'];
                    }

                    if (!isset($datos['tipoComprobante']) && $datos['tipoComprobante'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoComprobante' es obligatorio";
                        break;
                    }



                    if (isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] != '') {
                        $fcatura->tipoIdentificador = $datos['tipoIdentificador'];
                    }

                    if (!isset($datos['tipoIdentificador']) && $datos['tipoIdentificador'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoIdentificador' es obligatorio";
                        break;
                    }

                    if (isset($datos['correo']) && $datos['correo'] != '') {
                        $fcatura->correo = $datos['correo'];
                    }

                    if (!isset($datos['correo']) && $datos['correo'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'correo' es obligatorio";
                        break;
                    }

                    if (isset($datos['establecimiento']) && $datos['establecimiento'] != '' && strlen($datos['establecimiento']) == 3) {
                        $fcatura->establecimiento = $datos['establecimiento'];
                    }

                    if (!isset($datos['establecimiento']) || $datos['establecimiento'] == '' || strlen($datos['establecimiento']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'establecimiento' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['ptoEmision']) && $datos['ptoEmision'] != '' && strlen($datos['ptoEmision']) == 3) {
                        $fcatura->ptoEmision = $datos['ptoEmision'];
                    }

                    if (!isset($datos['ptoEmision']) || $datos['ptoEmision'] == '' || strlen($datos['ptoEmision']) != 3) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ptoEmision' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['rucEmpresa']) && $datos['rucEmpresa'] != '' && strlen($datos['rucEmpresa']) == 13) {
                        $fcatura->rucEmpresa = $datos['rucEmpresa'];
                    }

                    if (!isset($datos['rucEmpresa']) || $datos['rucEmpresa'] == '' || strlen($datos['rucEmpresa']) != 13) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'rucEmpresa' es obligatorio y debe ser de tres dígitos";
                        break;
                    }

                    if (isset($datos['secuencial']) && $datos['secuencial'] != '' && strlen($datos['secuencial']) == 9) {
                        $fcatura->secuencial = $datos['secuencial'];
                    }
                    if (!isset($datos['secuencial']) || $datos['secuencial'] == '' || strlen($datos['secuencial']) != 9) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'secuencial' es obligatorio y debe ser de 9 dígitos";
                        break;
                    }

                    if (isset($datos['ambiente']) && $datos['ambiente'] != '' && strlen($datos['ambiente']) == 1) {
                        $fcatura->ambiente = $datos['ambiente'];
                    }

                    if (!isset($datos['ambiente']) || $datos['ambiente'] == '' || strlen($datos['ambiente']) != 1) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'ambiente' es obligatorio y solo es un dígito";
                        break;
                    }

                    if (isset($datos['razonSocial']) && $datos['razonSocial'] != '') {
                        $fcatura->razonSocial = $datos['razonSocial'];
                    }

                    if (!isset($datos['razonSocial']) || $datos['razonSocial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'razonSocial' es obligatorio";
                        break;
                    }

                    if (isset($datos['nombreComercial']) && $datos['nombreComercial'] != '') {
                        $fcatura->nombreComercial = $datos['nombreComercial'];
                    }

                    if (!isset($datos['nombreComercial']) || $datos['nombreComercial'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'nombreComercial' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionMatriz']) && $datos['direccionMatriz'] != '') {
                        $fcatura->direccionMatriz = $datos['direccionMatriz'];
                    }
                    if (!isset($datos['direccionMatriz']) || $datos['direccionMatriz'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'direccionMatriz' es obligatorio";
                        break;
                    }

                    if (isset($datos['direccionEstablecimiento']) && $datos['direccionEstablecimiento'] != '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionEstablecimiento'];
                    }

                    if (!isset($datos['direccionEstablecimiento']) || $datos['direccionEstablecimiento'] == '') {
                        $fcatura->direccionEstablecimiento = $datos['direccionMatriz'];
                    }

                    if (isset($datos['obligadoContabilidad']) && $datos['obligadoContabilidad'] != '' && strlen($datos['obligadoContabilidad']) == 2 && in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no'])) {
                        $fcatura->obligadoContabilidad = $datos['obligadoContabilidad'];
                    }
                    if (!isset($datos['obligadoContabilidad']) || $datos['obligadoContabilidad'] == '' || strlen($datos['obligadoContabilidad']) != 2 || in_array($datos['obligadoContabilidad'], ['SI', 'NO', 'si', 'no']) == false) {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'obligadoContabilidad' es obligatorio, y solo se aceptan los terminos 'SI' o 'NO'";
                        break;
                    }

                    //CAMBIOS NOTA DE RETENCIONES

                    if (isset($datos['numeroCE']) && $datos['numeroCE'] != '') {
                        $fcatura->numeroCE = $datos['numeroCE'];
                    }

                    if (isset($datos['codSustento']) && $datos['codSustento'] != '') {
                        $fcatura->codSustento = $datos['codSustento'];
                    }
                    if (!isset($datos['codSustento']) && $datos['codSustento'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'codSustento' es obligatorio";
                        break;
                    }

                    if (isset($datos['codDocSustento']) && $datos['codDocSustento'] != '') {
                        $fcatura->codDocSustento = $datos['codDocSustento'];
                    }
                    if (!isset($datos['codDocSustento']) && $datos['codDocSustento'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'codDocSustento' es obligatorio";
                        break;
                    }

                    if (isset($datos['parteRel']) && $datos['parteRel'] != '') {
                        $fcatura->parteRel = $datos['parteRel'];
                    }
                    if (!isset($datos['parteRel']) && $datos['parteRel'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'parteRel' es obligatorio";
                        break;
                    }

                    if (isset($datos['numAuthSustento']) && $datos['numAuthSustento'] != '') {
                        $fcatura->numAuthSustento = $datos['numAuthSustento'];
                    }
                    if (!isset($datos['numAuthSustento']) && $datos['numAuthSustento'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'numAuthSustento' es obligatorio";
                        break;
                    }

                    if (isset($datos['pagoLocExt']) && $datos['pagoLocExt'] != '') {
                        $fcatura->pagoLocExt = $datos['pagoLocExt'];
                    }
                    if (!isset($datos['pagoLocExt']) && $datos['pagoLocExt'] == '') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'pagoLocExt' es obligatorio";
                        break;
                    }

                    if (isset($datos['tipoRegi']) && $datos['tipoRegi'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->tipoRegi = $datos['tipoRegi'];
                    }
                    if (!isset($datos['tipoRegi']) && $datos['pagoLocExt'] != '01' || $datos['tipoRegi'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'tipoRegi' es obligatorio";
                        break;
                    }

                    if (isset($datos['paisEfecPago']) && $datos['paisEfecPago'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->paisEfecPago = $datos['paisEfecPago'];
                    }
                    if (!isset($datos['paisEfecPago']) && $datos['pagoLocExt'] != '01' || $datos['paisEfecPago'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'paisEfecPago' es obligatorio";
                        break;
                    }

                    if (isset($datos['aplicConvDobTrib']) && $datos['aplicConvDobTrib'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->aplicConvDobTrib = $datos['aplicConvDobTrib'];
                    }
                    if (!isset($datos['aplicConvDobTrib']) && $datos['pagoLocExt'] != '01' || $datos['aplicConvDobTrib'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'aplicConvDobTrib' es obligatorio";
                        break;
                    }

                    if (isset($datos['pagExtSujRetNorLeg']) && $datos['pagExtSujRetNorLeg'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->pagExtSujRetNorLeg = $datos['pagExtSujRetNorLeg'];
                    }
                    if (!isset($datos['pagExtSujRetNorLeg']) && $datos['pagoLocExt'] != '01' || $datos['pagExtSujRetNorLeg'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'pagExtSujRetNorLeg' es obligatorio";
                        break;
                    }

                    if (isset($datos['pagoRegFis']) && $datos['pagoRegFis'] != '' && $datos['pagoLocExt'] != '01') {
                        $fcatura->pagoRegFis = $datos['pagoRegFis'];
                    }
                    if (!isset($datos['pagoRegFis']) && $datos['pagoLocExt'] != '01' || $datos['pagoRegFis'] == '' && $datos['pagoLocExt'] != '01') {

                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'pagoRegFis' es obligatorio";
                        break;
                    }

                    if (isset($datos['claveAcceso']) && $datos['claveAcceso'] != '') {
                        $fcatura->claveAcceso = $datos['claveAcceso'];
                    }

                    if (isset($datos['importeSinImpuestos']) && is_numeric($datos['importeSinImpuestos']) > 0) {
                        $fcatura->importeSinImpuestos = $datos['importeSinImpuestos'];
                    }
                    if (!isset($datos['importeSinImpuestos']) || is_numeric($datos['importeSinImpuestos']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeSinImpuestos' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['importeTotal']) && is_numeric($datos['importeTotal']) > 0) {
                        $fcatura->importeTotal = $datos['importeTotal'];
                    }
                    if (!isset($datos['importeTotal']) || is_numeric($datos['importeTotal']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'importeTotal' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['baseIva12']) && is_numeric($datos['baseIva12']) > 0) {
                        $fcatura->baseIva12 = $datos['baseIva12'];
                    }
                    if (!isset($datos['baseIva12']) || is_numeric($datos['baseIva12']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'baseIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['valorIva12']) && is_numeric($datos['valorIva12']) > 0) {
                        $fcatura->valorIva12 = $datos['valorIva12'];
                    }

                    if (!isset($datos['valorIva12']) || is_numeric($datos['valorIva12']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'valorIva12' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['baseIva0']) && is_numeric($datos['baseIva0']) > 0) {
                        $fcatura->baseIva0 = $datos['baseIva0'];
                    }

                    if (!isset($datos['baseIva0']) || is_numeric($datos['baseIva0']) < 1) {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'baseIva0' es obligatorio, solo se aceptan valores de tipo DOUBLE";
                        break;
                    }

                    if (isset($datos['fPagos']) && $datos['fPagos'] != '') {
                        $fcatura->fPagos = json_encode($datos['fPagos']);
                    }
                    if (!isset($datos['fPagos']) || $datos['fPagos'] == '') {
                        $result = false;
                        $whileResult = false;
                        $detalleError = "El campo 'fPagos' es obligatorio";
                        break;
                    }

                    $fcatura->idComporbante = 'R' . $datos['establecimiento'] . $datos['ptoEmision'] . $datos['secuencial'];
                    $fcatura->idEstado = '01';
                    $fcatura->orderNo =  $fcatura->secuencial;
                    $save = $fcatura->save();
                    $docID = $fcatura->idComporbante;
                    if ($save) {
                        if (!isset($datos['Detalle']) || $datos['Detalle'] == '') {
                            $result = false;
                            $fcatura->delete();
                            $whileResult = false;
                            break;
                        }
                        $detalles = $datos['Detalle'];
                        foreach ($detalles as $value) {

                            try {

                                $detalle = new DetalleRetencionElectronica();
                                $detalle->idComporbante = $fcatura->idComporbante;
                                $detalle->codigoRet = $value['codigoRet'];
                                $detalle->baseRet = $value['baseRet'];
                                $detalle->porcentajeRet = $value['porcentajeRet'];
                                $detalle->valorRet = $value['valorRet'];
                                $detalle->tipoDocAfectado = $value['tipoDocAfectado'];
                                $detalle->serieDocAfectado = $value['serieDocAfectado'];
                                $detalle->fechaDocAfectado = $value['fechaDocAfectado'];
                                $detalle->idLinea = $fcatura->idComporbante . '-' . $value['idlinea'];

                                $detalle->save();
                                $result = true;
                            } catch (QueryException $exPdo) {

                                $fcatura->delete();
                                $result = false;
                                $docID = "N/A";
                                $detalleError = $exPdo;
                                Log::error('Error al tratar de generar detalle de la retencion : ' . json_encode($exPdo));
                                break;
                            }
                        }
                    }
                    //$result = true;
                    $whileResult = false;
                }
            } catch (Exception $ex) {
                $result = false;
                $detalleError = $ex->getMessage();
            }

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
        } else {

            $result = ['Company' => $this->company->name, 'Result' => $result, 'JsonError' => $jsonError, 'EstructuraError' => $structureError, 'DetalleError' => $detalleError, 'DocGenerado' => $docID];
        }

        return $result;
    }
}
