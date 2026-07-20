<?php

namespace App\Http\Resources\Tenant;

use App\Models\Tenant\EmailSendLog;
use Illuminate\Http\Resources\Json\ResourceCollection;
use App\Models\Tenant\StateType;
use App\Models\Tenant\Catalogs\DocumentType;
use Illuminate\Support\Facades\Storage;
use App\CoreFacturalo\Helpers\Storage\StorageDocument;

class DocumentosDevueltosCollection extends ResourceCollection
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
                'idInterno' => $row->idInterno,
                'fecha' =>$row->fecha,
                'claveAcceso' => $row->claveAcceso,
                'cliente' => $row->cliente,
                'ruc' => $row->ruc,
                'responseRegularizeShipping' => $row->responseRegularizeShipping,
                'TIPODOC' => $row->tipoComprobante,
                'state_type_id' => $row->idEstado,
                'idComporbante' => $row->idComporbante
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
