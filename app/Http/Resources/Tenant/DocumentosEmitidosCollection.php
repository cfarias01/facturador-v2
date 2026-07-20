<?php

namespace App\Http\Resources\Tenant;

use App\Models\Tenant\EmailSendLog;
use Illuminate\Http\Resources\Json\ResourceCollection;
use App\Models\Tenant\StateType;
use App\Models\Tenant\Catalogs\DocumentType;
use Illuminate\Support\Facades\Storage;
use App\CoreFacturalo\Helpers\Storage\StorageDocument;

class DocumentosEmitidosCollection extends ResourceCollection
{
    use StorageDocument;

    /**
     * Transform the resource collection into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return mixed
     */
    public function toArray($request) {

        return $this->collection->transform(function(\App\Models\Tenant\CabeceraDocumentoElectronica $row, $key) {
            $has_xml = false;
            $has_pdf = false;
            $has_cdr = false;
            $btn_note = false;
            $btn_guide = false; // Boton para generar guia
            $btn_resend = false;
            $btn_voided = false;
            $btn_consult_cdr = false;
            $btn_delete_doc_type_03 = false;
            $btn_constancy_detraction = false;

            $affected_document = null;

            $btn_guide = $btn_note;


            // $btn_recreate_document = config('tenant.recreate_document');
            $btn_recreate_document = auth()->user()->recreate_documents;

            $btn_change_to_registered_status = false;

            if($row->idEstado === '01') {
                $btn_change_to_registered_status = config('tenant.change_to_registered_status');
            }
            if(isset($row->dateAuthorization)){

                $has_pdf = true;
            }
            if($this->existFileInStorage($row->claveAcceso, 'firmados', null, $this->claveAccesoIssueDate($row->claveAcceso))){
                $has_xml = true;
            }
            $total_payment = $row->total;
            $balance = 0;
            $message_regularize_shipping = null;

            if($row->regularizeShipping) {
                $jsondata = json_decode($row->responseRegularizeShipping,true);
                $message_regularize_shipping = $jsondata['code']."-".$jsondata['description'];
            }

            // Regresa si se hn enviado correos
            $email_send_it = false;
            $email_send_it_array = [];
            $send_it = EmailSendLog::Document()->FindRelationId($row->id)->get();
            if(count($send_it)> 0){
                /** @var EmailSendLog $log*/
                foreach($send_it as $log){
                    $email_send_it_array[] = [
                        'email'=>$log->email,
                        'send_it'=>$log->sendit,
                        'send_date'=>$log->created_at->format('Y-m-d H:i'),
                    ];
                    if($email_send_it == false){
                        $email_send_it = $log->sendit;
                    }
                }
            }
            $date_pay=$row->payments;
            $payment='';

            $btn_retention = !is_null($row->retention);

            $DocumentoTipo = $row->tipoComprobante;
            $DocumentoDescripcion = DocumentType::find('0'.$row->tipoComprobante)->description;

            $descripcionEstado =StateType::find($row->idEstado)->description;
            return [
                'id' => $row->id,
                'group_id' => $row->tipoComprobante,
                'soap_type_id' => $row->ambiente,
                'soap_type_description' => (in_array($row->ambiente, [1])) ? 'PRUEBAS' : 'PRODUCCION',
                'date_of_issue' => $row->fecha,
                'date_of_due' => $row->fecha,
                'number' => $row->establecimiento.$row->ptoEmision.str_pad($row->orderNo, '9', '0', STR_PAD_LEFT),
                'customer_name' => $row->cliente,
                'customer_number' => $row->ruc,
                'customer_telephone' => $row->telefono,
                'customer_email' => optional($row->correo),
                'currency_type_id' => 'USD',
                'exchange_rate_sale' => null,
                'total_exportation' => 0,
                'total_free' => 0,
                'total_unaffected' => 0,
                'total_exonerated' =>  0,
                'total_taxed' => round($row->importeSinImpuestos,2),
                'total_igv' => round($row->valorIva12,2),
                'total' => $row->importeTotal,
                'state_type_id' => $row->idEstado,
                'state_type_description' => $descripcionEstado,
                'document_type_description' => $DocumentoDescripcion,
                'document_type_id' => $row->tipoComprobante,
                'has_xml' => $has_xml,
                'has_pdf' => $has_pdf,
                'has_cdr' => false,
                'download_xml' => null,
                'download_pdf' => null,
                'download_cdr' => null,
                'btn_voided' => $btn_voided,
                'btn_note' => $btn_note,
                'btn_guide' => $btn_guide,
                'btn_resend' => $btn_resend,
                'btn_consult_cdr' => $btn_consult_cdr,
                'btn_constancy_detraction' => $btn_constancy_detraction,
                'btn_recreate_document' => $btn_recreate_document,
                'btn_change_to_registered_status' => $btn_change_to_registered_status,
                'btn_delete_doc_type_03' => $btn_delete_doc_type_03,
                'send_server' => true,
                'affected_document' => $affected_document,
                'shipping_status' => null ,
                'sunat_shipping_status' => null ,
                'query_status' => null ,
                'created_at' => $row->created_at->format('Y-m-d H:i:s'),
                'updated_at' => $row->updated_at->format('Y-m-d H:i:s'),

                'user_name' => $row->razonSocial,
                'user_email' => '',
                'user_id' => null,

                'email_send_it' => $email_send_it,
                'email_send_it_array' => $email_send_it_array,
                'external_id' => $row->claveAcceso,

                'notes' => null,
                'sales_note' => null,
                'order_note' =>null,
                'balance' => $balance,
                'guides' => !empty($row->guides)?(array)$row->guides:null,
                'message_regularize_shipping' => $message_regularize_shipping,
                'regularize_shipping' => (bool) $row->regularizeShipping,
                'purchase_order' => $row->purchase_order,
                'is_editable' => true,
                'dispatches' => $this->getDispatches($row),
                'soap_type' => $row->soap_type,
                'plate_numbers' => null,
                'total_charge' => $row->total_charge,
                'filename' => $row->claveAcceso,
                'date_of_payment' => $payment,
                'btn_force_send_by_summary' => false,
                'btn_retention' => $btn_retention,
                'idInterno' => $row->idInterno,

            ];
        });
    }


    private function getDispatches($row){

        $dispatches = [];

        if(in_array($row->document_type_id, ['01', '03'])) {

            $dispatches = $row->reference_guides->transform(function($row) {
                return [
                    'description' => $row->number_full,
                ];
            });

            if($row->dispatch){
                $dispatches = $dispatches->push([
                    'description' => $row->dispatch->number_full,
                ]);
            }

        }

        return $dispatches;

    }

}
