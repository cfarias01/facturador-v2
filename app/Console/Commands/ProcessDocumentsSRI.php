<?php

namespace App\Console\Commands;

use App\Http\Controllers\Tenant\DocumentosRecibidosController;
use Illuminate\Console\Command;

class ProcessDocumentsSRI extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'sri:process-documents';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Procesa los documentos recibidos desde el SRI';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        try {
            $this->info('Iniciando el procesamiento de documentos recibidos desde el SRI...');

            $documentos = \App\Models\Tenant\DocumentosRecibidosPendientes::where('estado', 0)->whereIn('clave_acceso',['0105202507179009835400120010050076375900000000111','0105202501179127767800120030020000072748243517615'])->get();
            if ($documentos->isEmpty()) {
                $this->info('No hay documentos pendientes para procesar.');
                return;
            }
            $DocumentsRecibidos = new DocumentosRecibidosController();
            foreach ($documentos as $documento) {
                // Aquí puedes agregar la lógica para procesar cada documento
                $claveAcceso = $documento->clave_acceso;
                $result = $DocumentsRecibidos->processXmlSRI($claveAcceso);

                if($result){

                    $documento->estado = 1; // Cambia el estado a procesado
                    $documento->save();
                    $this->info('Documento procesado: ' . $documento->clave_acceso);

                }else{
                    
                    $this->info('Documento No procesado: ' . $documento->clave_acceso);
                }
               
            }
        } catch (\Exception $e) {
            $this->error('Error al procesar los documentos: ' . $e->getMessage());
        }

        $this->info('Proceso de documentos SRI finalizado.');
    }
}
