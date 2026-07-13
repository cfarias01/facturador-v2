<?php

namespace App\Models\Tenant;

use Illuminate\Database\Eloquent\Model;
use App\CoreFacturalo\Helpers\QrCode\QrCodeGenerate;
use App\Models\Tenant\Catalogs\DocumentType;
use Illuminate\Support\Facades\Log;

class CabeceraDocumentoElectronica extends ModelTenant
{
    //
    protected $table = 'cabecera_documento_electronicas';
    protected $fillable = [
        'id',
        'idComporbante',
        'idEstado',
        'fecha',
        'fechaFizcal',
        'orderNo',
        'cliente',
        'direccion',
        'telefono',
        'ruc',
        'qr',
        'tipoComprobante',
        'tipoIdentificador',
        'correo',
        'establecimiento',
        'ptoEmision',
        'rucEmpresa',
        'secuencial',
        'ambiente',
        'razonSocial',
        'nombreComercial',
        'direccionMatriz',
        'direccionEstablecimiento',
        'obligadoContabilidad',
        'notaNo',
        'numeroCE',
        'codSustento',
        'codDocSustento',
        'parteRel',
        'numAuthSustento',
        'fPago',
        'pagoLocExt',
        'tipoDocAfectado',
        'secuencialDocAfectado',
        'motivoDev',
        'fechaDocSustento',
        'nombreDoc',
        'importeTotal',
        'importeSinImpuestos',
        'descuento',
        'baseIva12',
        'valorIva12',
        'baseIva0',
        'claveAcceso',
        'fPagos',
        'regularizeShipping',
        'responseRegularizeShipping',
        'dateAuthorization',
        'timeAuthorization',
        'adicionales',
        'tipoRegi',
        'paisEfecPago',
        'aplicConvDobTrib',
        'pagExtSujRetNorLeg',
        'pagoRegFis',
        'idInterno',
        'direccionDePartida',
        'fechaIniTranporte',
        'fechaFinTransporte',
        'placa',
        'tipoSujetoRetenido',
        'send_email',
        'emailed',
        'impuestos',
        'icg',
        'extra_emails',
        'propina',
    ];
    protected $casts = [

        'secuencial'=>'string',
    ];

    /**
     * @param     $number
     * @param int $decimal
     *
     * @return string
     */
    protected static function NumberFormat($number,$decimal = 2){
        return number_format($number,$decimal,'.','');
    }

    public function getQrAttribute($value)
    {
        if(!is_null($value)) {
            return $value;
        }
        /*
        $company = Company::query()->first();
        $text = join('|', [
            $company->number,
            $this->tipoComprobante,
            $this->ptoEmision,
            $this->secuencial,
            $this->valorIva12,
            $this->importeTotal,
            $this->fecha,
            $this->tipoIdentificador,
            $this->ruc
            $this->hash
        ]);
        */
        $qrCode = new QrCodeGenerate();
        return $qrCode->generarCodigoBarras($this->claveAcceso);
    }

    public function  getCollectionData() {
        $total = $this->total;
        if ($this->total_perception) {
            $total += round($this->total_perception, 2);
        }
        $document_type_description = '';
        if($this->tipoComprobante == '1'){
            $document_type_description = 'FACTURA';

        }
        if($this->tipoComprobante == '7'){
            $document_type_description = 'COMPROBANTE DE RETENCIÓN';
        }

        if($this->tipoComprobante == '4'){
            $document_type_description = 'NOTA DE CRÉDITO';
        }

        if($this->tipoComprobante == '3'){
            $document_type_description = 'LIQUIDACIÓN DE COMPRA DE BIENES Y PRESTACIÓN DE SERVICIOS';
        }

        if($this->tipoComprobante == '5'){
            $document_type_description = 'NOTA DE DÉBITO';
        }

        $pagoA = null;
        $pagosArray = (array) json_decode($this->fPagos,false);
        $pagos = null;
        foreach($pagosArray as $pagosL){
            if(is_array($pagosL)){
                $descripFpago = SriFormasPagos::where('code',str_pad($pagosL['fp'],2,'0',STR_PAD_LEFT))->get();
                $pagos['description'] = $descripFpago[0]->description;
                //Log::info("Array: ".$pagos);
                $pagos['totalP'] = $pagosL['total'];
                if(isset($pagosL['plazo']) && isset($pagosL['unidadtiempo'])){
                    $pagos['plazoP'] = $pagosL['plazos'];
                    $pagos['unidadTiempoP'] = $pagosL['unidadtiempo'];
                } else {
                    $pagos['plazoP'] = 0;
                    $pagos['unidadTiempoP'] = 'días';
                }
            }elseif(is_object($pagosL)){

                $descripFpago = SriFormasPagos::where('code',$pagosL->fp)->get();
                $pagos['description'] = $descripFpago[0]->description;
                //Log::info("Array: ".$pagos);
                $pagos['totalP'] = $pagosL->total;
                if(isset($pagosL->plazo) && isset($pagosL->unidadtiempo)){
                    $pagos['plazoP'] = $pagosL->plazo;
                    $pagos['unidadTiempoP'] = $pagosL->unidadtiempo;
                } else {
                    $pagos['plazoP'] = 0;
                    $pagos['unidadTiempoP'] = 'días';
                }
            }

            $pagoA[]= $pagos;
        }

        //Log::info('FORMAS DE PAGP'. json_encode($pagoA));

        $items = null;
        $itemsRet = null;
        $itemsArray=DetalleFacturaElectronica::where('idComporbante',$this->idComporbante)->get();
        $itemsRetArray=DetalleRetencionElectronica::where('idComporbante',$this->idComporbante)->get();
        if(isset($itemsArray)){
            foreach($itemsArray as $key=>$item){
                $items[]=[
                    'key'         => $key + 1,
                    'id'          => $item->id,
                    'description' => $item->item,
                    'quantity'    => round($item->cantidad, 2),
                    'unit_price'    => round($item->precioUnitario, 2),
                    'descuento'    => ($item->descuento)?$item->descuento:0,
                    'total'    => round($item->total, 2),
                    'codItem'    => $item->codItem ?? '',
                    'lote'       =>$item->lote ?? '',
                    'fecha_elaborado' => $item->fecha_creado ?? '',
                    'fecha_vencimiento' => $item->fecha_vencimiento ?? ''
                    //'model' => $item->codigoPrincipal
                ];
            }
        }
        if(isset($itemsRetArray)){
            foreach($itemsRetArray as $key=>$item){
                $os = array('1', '2', '3', '9', '10', '11');
                $code = '';

                $document_type_afect = DocumentType::find($item->tipoDocAfectado)->description;

                $exercise = explode("/",date("d/m/Y", strtotime($item->fechaDocAfectado)));

                if (in_array($item->codigoRet, $os)) {
                    $code = 'IVA';
                } else {
                    $code = 'Impuesto a la Renta';
                };

                $itemsRet[]=[
                    'key'         => $key + 1,
                    'id'          => $item->id,
                    'serieDocAfectado' => $item->serieDocAfectado,
                    'fechaDocAfectado'    => $item->fechaDocAfectado,
                    'exercise' => $exercise[1].'/'.$exercise[2],
                    'baseRet'    => round($item->baseRet, 2),
                    'document_type_afect'    => $document_type_afect,
                    'code'        => $code,
                    'porcentajeRet'    => round($item->porcentajeRet, 2),
                    'valorRet'    => round($item->valorRet, 2),
                    //'model' => $item->codigoPrincipal
                ];
            }
        }

        $supplier_identity_document_type_description = '';
        if($this->tipoIdentificador == '05'){
            $supplier_identity_document_type_description = 'CÉDULA';
        }elseif($this->tipoIdentificador == '08'){
            $supplier_identity_document_type_description = 'IDENTIFICACIÓN DEL EXTERIOR';
        }elseif($this->tipoIdentificador == '04'){
            $supplier_identity_document_type_description = 'RUC';
        }elseif($this->tipoIdentificador == '06'){
            $supplier_identity_document_type_description = 'Pasaporte';
        }

        return [

            'id'                             => $this->id,
            //'customer_number'                => $this->ruc,
            //'customer_name'                  => $this->razonSocial,
            'series'                         => $this->ptoEmision,
            'tipoComprobante'                => $this->tipoComprobante,
            'document_type_description'      => $document_type_description,
            'supplier_identity_document_type_description' => $supplier_identity_document_type_description,
            'group_id'                       => 01,
            'guides'                         => null,
            'soap_type_id'                   => $this->ambiente,
            'date_of_issue'                  => $this->fecha,
            //'date_of_due'                    => $this->fechaEmision,
            'purchase_order'                 => 01,
            'number'                         => $this->secuencial,
            //'supplier_name'                  => $this->razonSocial,
            'supplier_number'                => $this->ruc,
            'supplier_telephone'             => null,
            'supplier_email'                 => null,
            'currency_type_id'               => 'USD',
            'total_exportation'              => 0,
            'total_free'                     => 0,
            'total_unaffected'               => 0,
            'total_exonerated'               => 0,
            'total_taxed'                    => self::NumberFormat($this->importeTotal-$this->importeSinImpuestos),
            'total_discount'                 => 0,
            'total_igv'                      => 0,
            'total_isc'                      => 0,
            'total_perception'               => 0,
            'total'                          => self::NumberFormat($this->importeTotal),
            'state_type_id'                  => '09',
            'state_type_description'         => 'RECIBIDO',
            'state_type_payment_description' => 'Pagado',
            // 'payment_method_type_description' => isset($this->purchase_payments['payment_method_type']['description'])?$this->purchase_payments['payment_method_type']['description']:'-',
            'created_at'                     => $this->created_at->format('Y-m-d H:i:s'),
            'updated_at'                     => $this->updated_at->format('Y-m-d H:i:s'),
            'payments'                       => (array) $pagoA,
            'items'                          => (array) $items,
            'itemsRet'                       => (array) $itemsRet,
            'print_a4'                       => url('')."/print/cabeceraDocumentoElectronica/{$this->claveAcceso}/a4",
            'filename'                         => $this->claveAcceso,
        ];
    }
}
