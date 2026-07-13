<?php

namespace App\Http\Resources\Tenant;

use Illuminate\Http\Resources\Json\ResourceCollection;
use Illuminate\Support\Collection;
use App\Models\Tenant\DocumentosRecibidosSRI;
use App\Models\Tenant\SriDocumentsAditional;
use App\Models\Tenant\SriDocumentsDetails;


/**
 * Class PurchaseCollection
 *
 * @package App\Http\Resources\Tenant
 */
class PurchaseCollection extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return Collection
     */
    public function toArray($request)
    {
        return $this->collection->transform(function($row, $key) {

            /** @var \App\Models\Tenant\Purchase  $row */
            return $row->getCollectionData();
            /** Pasado al modelo */
            $total = 0;
            /*if($row->total_perception)
            {
                $total += round($row->total_perception, 2);
            }*/

            foreach($row->pagos->pago as $pago){
                $total += round($pago->total, 2);
            }

            $items = SriDocumentsDetails::where('document_id',$row->id)->get();

            return [
                'id'                             => $row->id,
                'customer_number'                => $row->ruc,
                'customer_name'                  => $row->razonSocial,
                'series'                         => $row->ptoEmi,
                'document_type_description'      => $document_type_description,
                'group_id'                       => 01,
                'guides'                         => null,
                'soap_type_id'                   => $row->tipoEmision,
                'date_of_issue'                  => $row->fechaEmision,
                'date_of_due'                    => $row->fechaEmision,
                'purchase_order'                 => 01,
                'number'                         => $row->secuencial,
                'supplier_name'                  => $row->razonSocial,
                'supplier_number'                => $row->ruc,
                'supplier_telephone'             => null,
                'supplier_email'                 => null,
                'currency_type_id'               => 'USD',
                'total_exportation'              => 0,
                'total_free'                     => 0,
                'total_unaffected'               => 0,
                'total_exonerated'               => 0,
                'total_taxed'                    => self::NumberFormat($row->importeTotal-$row->totalSinImpuestos),
                'total_igv'                      => 0,
                'total_isc'                      => 0,
                'total_perception'               => 0,
                'total'                          => self::NumberFormat($row->importeTotal),
                'state_type_id'                  => '09',
                'state_type_description'         => 'AUTORIZADO',
                'state_type_payment_description' => 'Pagado',
                // 'payment_method_type_description' => isset($row->purchase_payments['payment_method_type']['description'])?$row->purchase_payments['payment_method_type']['description']:'-',
                'created_at'                     => $row->created_at->format('Y-m-d H:i:s'),
                'updated_at'                     => $row->updated_at->format('Y-m-d H:i:s'),
                'payments'                       => [],
                'items'                          => [],
                'print_a4'                       => url('')."/purchases/print/{$row->claveAcceso}/a4",
            ];
        });
    }

}
