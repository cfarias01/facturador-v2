<?php
namespace App\Http\Controllers\Tenant;

use App\CoreFacturalo\Facturalo;
use App\CoreFacturalo\Helpers\Storage\StorageDocument;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Tenant\QuotationController;
use App\Http\Controllers\Tenant\SriDocumentController as TenantSriDocumentController;
use Exception;
use Facades\App\Http\Controllers\Tenant\SriDocumentController;

class DownloadController extends Controller
{
    use StorageDocument;

    public function downloadExternal($model, $type, $external_id, $format = null) {
        $document_type = $model;
        $model = "App\\Models\\Tenant\\".ucfirst($model);
        $document = $model::where('claveAcceso', $external_id)->first();

        if (!$document) throw new Exception("El código {$external_id} es inválido, no se encontro documento relacionado");

        $typeDoc = 'invoice';

        if ($document_type == 'dispatch') {
            $type = 'dispatch';
        }
        if($document->tipoComprobante === 4) {
            $typeDoc = 'credit';
        }
        if($document->tipoComprobante === 5) {
            $typeDoc = 'debit';
        }
        if($document->tipoComprobante === 7) {
            $typeDoc = 'retention';
        }

        if ($format != null) $this->reloadPDF($document, $typeDoc, $format);

        return $this->download($type, $document);
    }

    public function download($type, $document) {
        switch ($type) {
            case 'pdf':
                $folder = 'pdf';
                break;
            case 'xml':
                $folder = 'autorizados';
                break;
            case 'cdr':
                $folder = 'cdr';
                break;
            case 'quotation':
                $folder = 'quotation';
                break;
            case 'sale_note':
                $folder = 'sale_note';
                break;
            default:
                throw new Exception('Tipo de archivo a descargar es inválido');
        }

        return $this->downloadStorage($document->claveAcceso, $folder);
    }

    /**
     * @param      $model
     * @param      $external_id
     * @param null $format
     *
     * @return \Symfony\Component\HttpFoundation\BinaryFileResponse
     * @throws \Exception
     */
    public function toPrint($model, $external_id, $format = 'a4') {
        $document_type = $model;

        $model = "App\\Models\\Tenant\\".ucfirst($model);

        $document = $model::where('claveAcceso', $external_id)->first();

        if (!$document) {
            throw new Exception("El código {$external_id} es inválido, no se encontro documento relacionado");
        }

        if ($document_type == 'quotation'){
            // Las cotizaciones tienen su propio controlador, si se generan por este medio, dará error
            $quotation = new QuotationController();
            return $quotation->toPrint($external_id,$format);
        }elseif($document_type =='salenote'){
            $saleNote = new SaleNoteController();
            return $saleNote->toPrint($external_id,$format);
        }

        $type = 'invoice';
        if ($document_type == 'dispatch') {
            $type = 'dispatch';
        }
        if($document->tipoComprobante === 4) {
            $type = 'credit';
        }
        if($document->tipoComprobante === 5) {
            $type = 'debit';
        }
        if($document->tipoComprobante === 7) {
            $type = 'retention';
        }
        if($document->tipoComprobante === 6) {
            $type = 'guide';
        }

        $this->reloadPDF($document, $type, $format);

        $temp = tempnam(sys_get_temp_dir(), 'pdf');

        file_put_contents($temp, $this->getStorage($document->claveAcceso, 'pdf'));

        /*
        $headers = [
            'Content-Type' => 'application/pdf',
            'Content-Disposition' => 'inline; filename="'.$document->filename.'.pdf'.'"'
        ];
        */

        return response()->file($temp, $this->generalPdfResponseFileHeaders($document->claveAcceso));
    }

    public function toTicket($model, $external_id, $format = null) {
        $model = "App\\Models\\Tenant\\".ucfirst($model);
        $document = $model::where('id', $external_id)->first();

        if (!$document) throw new Exception("El código {$external_id} es inválido, no se encontro documento relacionado");

        if ($format != null) return $this->reloadTicket($document, 'invoice', $format);

    }

    /**
     * Reload Ticket
     * @param  ModelTenant $document
     * @param  string $format
     * @return void
     */
    private function reloadTicket($document, $type, $format) {
        return (new Facturalo)->createPdf($document, $type, $format, 'html');
    }

    /**
     * Reload PDF
     * @param  ModelTenant $document
     * @param  string $format
     * @return void
     */
    private function reloadPDF($document, $type, $format) {
        (new TenantSriDocumentController)->createPdf($document, $type, $format);
    }
}
