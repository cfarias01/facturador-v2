<?php

namespace App\CoreFacturalo\Helpers\Storage;

use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

trait StorageDocument
{
    protected $_folder;
    protected $_filename;

    /**
     * $date organiza el archivo en subcarpetas year/month/day (fecha de
     * emision del documento, no la clave de acceso). Si no se pasa, el
     * archivo queda en la carpeta plana de siempre (compatibilidad con
     * llamadas que no manejan fecha, p.ej. cotizaciones, contratos, etc).
     */
    public function uploadStorage($filename, $file_content, $file_type, $root = null, $date = null)
    {
        $this->setData($filename, $file_type, $root, $date);
        //Log::error("Ruta 1: ".$this->_folder.DIRECTORY_SEPARATOR.$this->_filename);
        Storage::disk('tenant')->put($this->_folder.DIRECTORY_SEPARATOR.$this->_filename, $file_content);
    }

    public function downloadStorage($filename, $file_type, $root = null, $date = null)
    {
        $path = $this->resolveStoragePath($filename, $file_type, $root, $date);
        return Storage::disk('tenant')->download($path);
    }

    public function getStorage($filename, $file_type, $root = null, $date = null)
    {
        $path = $this->resolveStoragePath($filename, $file_type, $root, $date);
        return Storage::disk('tenant')->get($path);
    }

    /**
     * Resuelve la ruta a leer: primero la carpeta por fecha (si se paso
     * $date), y si el archivo no esta ahi cae a la carpeta plana antigua
     * (documentos generados antes de organizar por fecha).
     */
    private function resolveStoragePath($filename, $file_type, $root, $date)
    {
        $this->setData($filename, $file_type, $root, $date);
        $datedPath = $this->_folder.DIRECTORY_SEPARATOR.$this->_filename;

        if (! $date || Storage::disk('tenant')->exists($datedPath)) {
            return $datedPath;
        }

        $this->setData($filename, $file_type, $root, null);
        return $this->_folder.DIRECTORY_SEPARATOR.$this->_filename;
    }

    private function setData($filename, $file_type, $root, $date = null)
    {
        $extension = 'xml';
        switch ($file_type) {
            case 'unsigned':
                break;
            case 'firmados':
                break;
            case 'pdf':
                $extension = 'pdf';
                break;
            case 'quotation':
                $extension = 'pdf';
                break;
            case 'sale_note':
                $extension = 'pdf';
                break;
            case 'cdr':
                $filename = 'R-'.$filename;
                $extension = 'zip';
                break;
            case 'purchase_quotation':
                $extension = 'pdf';
                break;
            case 'purchase_order_attached':
                $extension = '';
                break;
            case 'purchase_order':
                $extension = 'pdf';
                break;
            case 'order_note':
                $extension = 'pdf';
                break;
            case 'sale_opportunity':
                $extension = 'pdf';
                break;
            case 'contract':
                $extension = 'pdf';
                break;
            case 'order_form':
                $extension = 'pdf';
                break;
            case 'purchase':
                $extension = 'pdf';
                break;
            case 'devolution':
                $extension = 'pdf';
                break;
            case 'report_inventory_pdf':
                $extension = 'pdf';
                break;
            case 'download_tray_pdf':
                $extension = 'pdf';
                break;
            case 'download_tray_xlsx':
                $extension = 'xlsx';
                break;
            case 'income':
                $extension = 'pdf';
            case 'expense':
                $extension = 'pdf';
                break;
            case 'image':
                $extension = 'png';
                break;
        }

        $this->_filename = $filename.'.'.$extension;

        $folder = $file_type;
        if ($date) {
            $folder .= DIRECTORY_SEPARATOR.$this->dateStorageFolder($date);
        }

        $this->_folder = ($root)?$root.DIRECTORY_SEPARATOR.$folder:$folder;
    }

    /**
     * year/month/day a partir de la fecha de emision del documento.
     */
    private function dateStorageFolder($date)
    {
        $carbon = $date instanceof \DateTimeInterface
            ? \Illuminate\Support\Carbon::instance($date)
            : \Illuminate\Support\Carbon::parse((string) $date);

        return $carbon->format('Y').DIRECTORY_SEPARATOR.$carbon->format('m').DIRECTORY_SEPARATOR.$carbon->format('d');
    }

    /**
     * Los primeros 8 caracteres de la clave de acceso SRI (Ecuador) son la
     * fecha de emision en formato ddmmyyyy. Se usa donde se guarda/lee por
     * claveAcceso en vez de por $document->date_of_issue (SriDocumentController,
     * DownloadController).
     */
    public function claveAccesoIssueDate(?string $claveAcceso)
    {
        if (! $claveAcceso) {
            return null;
        }

        $fecha = \DateTime::createFromFormat('dmY', substr($claveAcceso, 0, 8));
        return $fecha ?: null;
    }

    /**
     * "Y/m/d/" (con separador final) para armar rutas de storage a mano,
     * p.ej. "autorizados/" . $this->claveAccesoDateFolder($clave) . $clave . ".xml".
     */
    public function claveAccesoDateFolder(?string $claveAcceso): string
    {
        $fecha = $this->claveAccesoIssueDate($claveAcceso);
        return $fecha ? $fecha->format('Y').DIRECTORY_SEPARATOR.$fecha->format('m').DIRECTORY_SEPARATOR.$fecha->format('d').DIRECTORY_SEPARATOR : '';
    }

    /**
     *
     * Validar si existe archivo
     *
     * @param  string $filename
     * @param  string $file_type
     * @param  string $root
     * @param  \DateTimeInterface|string|null $date
     * @return bool
     */
    public function existFileInStorage($filename, $file_type, $root = null, $date = null)
    {
        $this->setData($filename, $file_type, $root, $date);
        if (Storage::disk('tenant')->exists($this->_folder.DIRECTORY_SEPARATOR.$this->_filename)) {
            return true;
        }

        if (! $date) {
            return false;
        }

        $this->setData($filename, $file_type, $root, null);
        return Storage::disk('tenant')->exists($this->_folder.DIRECTORY_SEPARATOR.$this->_filename);
    }

}