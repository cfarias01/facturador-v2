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

class DocumentEmailNotification extends Mailable
{
    use Queueable;
    use SerializesModels;
    use StorageDocument;

    public $company;
    public $document;
    public $type;

    public function __construct($company, $document, $type)
    {
        $this->company = $company;
        $this->document = $document;
        $this->type = $type;

    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        $template_document_mail = config('tenant.template_document_mail');
        if($this->type == 2 ){
            $template_document_mail_view = 'tenant.templates.email.notification';
        }else{
            $template_document_mail_view = 'tenant.templates.email.notificationReturned';
        }
        

        $subject = 'Notificaicones Automaticas';
        $email = $this->subject($subject)
                    ->from(config('mail.username'), 'Sistema de Facturación')
                    ->view($template_document_mail_view);
        return $email;
    }
}
