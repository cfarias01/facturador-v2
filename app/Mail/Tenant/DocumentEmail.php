<?php

namespace App\Mail\Tenant;

use App\CoreFacturalo\Helpers\Storage\StorageDocument;
use App\Models\Tenant\Document;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Svg\Gradient\Stop;

class DocumentEmail extends Mailable
{
    use Queueable;
    use SerializesModels;
    use StorageDocument;

    public $company;
    public $document;

    public function __construct($company, $document)
    {
        $this->company = $company;
        $this->document = $document;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        // $this->document puede venir como App\Models\Tenant\Document (columna
        // clave_SRI, flujo Facturalo::sendEmail/sendEmail2) o como
        // CabeceraDocumentoElectronica (columna claveAcceso, flujo
        // SriDocumentController::sendEmail2). Se soportan ambos.
        $claveAcceso = $this->document->claveAcceso ?? $this->document->clave_SRI;
        $fechaEmision = $this->claveAccesoIssueDate($claveAcceso);

        $pdf = $this->getStorage($claveAcceso, 'pdf', null, $fechaEmision);
        $xml = $this->getStorage($claveAcceso, 'autorizados', null, $fechaEmision);
        $path = base_path().'/public';
        //$imgUs = File::get($path."/logo/logo2.png");
        //$imgCompany = Storage::get("public/uploads/logos/".$this->company->logo);
        $cdr = null;

        /*if($this->document->tipoComprobante !== 3) {

            if($this->existFileInStorage($claveAcceso, 'cdr', null, $fechaEmision))
            {
                $cdr = $this->getStorage($claveAcceso, 'cdr', null, $fechaEmision);
            }

        }*/

        //$image_detraction = ($this->document->detraction) ? (($this->document->detraction->image_pay_constancy) ? storage_path('app'.DIRECTORY_SEPARATOR.'public'.DIRECTORY_SEPARATOR.'uploads'.DIRECTORY_SEPARATOR.'image_detractions'.DIRECTORY_SEPARATOR.$this->document->detraction->image_pay_constancy):false):false;

        $template_document_mail = config('tenant.template_document_mail');
        if($template_document_mail === 'default') {
            $template_document_mail_view = 'tenant.templates.email.document';
            $subject = $this->document->cliente . " Comprobante Electrónico";
        } else {
            $template_document_mail_view = 'tenant.templates.email.'.$template_document_mail;
            $subject = 'Folio '.$this->document->folio;
        }

        $email = $this->subject($subject)
                    ->from(config('mail.username'), 'Comprobante electrónico')
                    ->view($template_document_mail_view)
                    ->attachData($pdf, $claveAcceso.'.pdf')
                    ->attachData($xml, $claveAcceso.'.xml');


        // $file = $this->getCdr($this->document);
        /*
        if(!empty($cdr) ){
            $email->attachData($cdr, $claveAcceso.'.zip');
        }
        */
        /*
        if($image_detraction){
            return $email->attachData(File::get($image_detraction), $this->document->detraction->image_pay_constancy);
        }
        */

        return $email;
    }

    public function getCdr($document){
        $file = null;
        $claveAcceso = $document->claveAcceso ?? $document->clave_SRI ?? null;
        if( !empty($claveAcceso)) {
            $file = $this->getStorage($claveAcceso, 'cdr', null, $this->claveAccesoIssueDate($claveAcceso));
        }
        return $file;

    }
}
