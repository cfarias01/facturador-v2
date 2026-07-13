<?php

namespace App\Models\Tenant;

use Illuminate\Database\Eloquent\Model;
use \App\Models\Tenant\SriFormasPagos;
use \App\Models\Tenant\SriDocumentsDetails;

class DocumentosRecibidosSRI extends ModelTenant
{

    protected $table = 'documentos_recibidos_sri';
    protected $fillable = [

        'id',
        'ambiente',
        'tipoEmision',
        'razonSocial',
        'nombreComercial',
        'ruc',
        'claveAcceso',
        'codDoc',
        'estab',
        'ptoEmi',
        'secuencial',
        'dirMatriz',
        'agenteRetencion',
        'fechaEmision',
        'dirEstablecimiento',
        'obligadoContabilidad',
        'tipoIdentificacionComprador',
        'razonSocialComprador',
        'identificacionComprador',
        'direccionComprador',
        'totalSinImpuestos',
        'totalDescuento',
        'totalConImpuestos',
        'propina',
        'importeTotal',
        'moneda',
        'pagos',
        'contribuyenteRimpe',

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

     /**
     * @return array
     */
    public function  getCollectionData() {
        $total = $this->total;
        if ($this->total_perception) {
            $total += round($this->total_perception, 2);
        }
        $document_type_description = '';
        if($this->codDoc == '01'){
            $document_type_description = 'FACTURA';

        }elseif($this->codDoc == '07'){
            $document_type_description = 'RETENCIONES';
        }elseif($this->codDoc == '04'){
            $document_type_description = 'NOTA DE CRÉDITO';
        }
        $pagoA = null;
        $pagosArray = (array) json_decode(stripslashes($this->pagos),false);
        //$pagoA=get_object_vars($pagosArray['pago'] );;
        foreach($pagosArray as $pagos){
            $descripFpago = SriFormasPagos::where('code',$pagos->formaPago)->get();
            $pagos->descripcion = $descripFpago[0]->description;
            $pagos->totalP = $pagos->total;
            if(isset($pagos->plazo) && isset($pagos->unidadTiempo)){
                $pagos->plazoP = $pagos->plazo;
                $pagos->unidadTiempoP = $pagos->unidadTiempo;
            } else {
                $pagos->plazoP = 0;
                $pagos->unidadTiempoP = 'días';
            }
            $pagoA[]= $pagos;
        }



        $items = null;
        $itemsArray=SriDocumentsDetails::where('document_id',$this->id)->get();
        if(isset($itemsArray)){
            foreach($itemsArray as $key=>$item){
                $items[]=[
                    'key'         => $key + 1,
                    'id'          => $item->id,
                    'description' => $item->descripcion,
                    'quantity'    => round($item->cantidad, 2),
                    'unit_price'    => round($item->precioUnitario, 2),
                    'discounts'    => $item->descuento,
                    'total'    => round($item->precioTotalSinImpuesto, 2),
                    'model' => $item->codigoPrincipal
                ];
            }
        }


        $supplier_identity_document_type_description = '';
        if($this->tipoIdentificacionComprador == '05'){
            $supplier_identity_document_type_description = 'CÉDULA';
        }elseif($this->tipoIdentificacionComprador == '08'){
            $supplier_identity_document_type_description = 'IDENTIFICACIÓN DEL EXTERIOR';
        }elseif($this->tipoIdentificacionComprador == '04'){
            $supplier_identity_document_type_description = 'RUC';
        }elseif($this->tipoIdentificacionComprador == '06'){
            $supplier_identity_document_type_description = 'Pasaporte';
        }

        return [

            'id'                             => $this->id,
            'customer_number'                => $this->ruc,
            'customer_name'                  => $this->razonSocial,
            'series'                         => $this->ptoEmi,
            'document_type_description'      => $document_type_description,
            'supplier_identity_document_type_description' => $supplier_identity_document_type_description,
            'group_id'                       => 01,
            'guides'                         => null,
            'soap_type_id'                   => $this->tipoEmision,
            'date_of_issue'                  => $this->fechaEmision,
            'date_of_due'                    => $this->fechaEmision,
            'purchase_order'                 => 01,
            'number'                         => $this->secuencial,
            'supplier_name'                  => $this->razonSocial,
            'supplier_number'                => $this->ruc,
            'supplier_telephone'             => null,
            'supplier_email'                 => null,
            'currency_type_id'               => 'USD',
            'total_exportation'              => 0,
            'total_free'                     => 0,
            'total_unaffected'               => 0,
            'total_exonerated'               => 0,
            'total_taxed'                    => self::NumberFormat($this->importeTotal-$this->totalSinImpuestos),
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
            'print_a4'                       => url('')."/purchases/print/{$this->claveAcceso}/a4",
            'filename'                         => $this->claveAcceso,
        ];
    }

}
