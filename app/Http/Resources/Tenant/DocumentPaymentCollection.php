<?php

namespace App\Http\Resources\Tenant;

use Illuminate\Http\Resources\Json\ResourceCollection;
use App\Models\Tenant\SriFormasPagos;

class DocumentPaymentCollection extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return mixed
     */
    public function toArray($request)
    {
        return $this->collection->transform(function($row, $key) {

            $descripcionEstado =SriFormasPagos::where('code',$row[0])->description;

            return [
                'id' => $key,
                'date_of_payment' => null,
                'payment_method_type_description' => $descripcionEstado,
                'destination_description' => null,
                'reference' => null,
                'filename' => null,
                'payment' => $row[1],
                'payment_received' => null,
                'payment_received_description' => null,
            ];
        });
    }
}
