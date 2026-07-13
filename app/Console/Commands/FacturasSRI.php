<?php

namespace App\Console\Commands;

use Facades\App\Http\Controllers\Tenant\DocumentController;
use Illuminate\Console\Command;
use App\Traits\CommandTrait;
use App\Models\Tenant\{
    Configuration,
    Document,
    CabeceraDocumentoElectronica,
    Company,
};
use App\Http\Controllers\Tenant\SriDocumentController;


class FacturasSRI extends Command
{
    //use CommandTrait;
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'sri:see';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'CONSULTA LAS FACTURAS YA ENVIADAS AL SRI ECUADOR';

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
        if (Configuration::firstOrFail()->cron) {
            $company = Company::active();
            $documents = CabeceraDocumentoElectronica::query()
                ->whereIn('idEstado', ['07','30'])
                ->orderBy('fecha','asc')
                ->limit(100)
                ->get();
            $this->info('EMPRESA : '.$company->name);
            foreach ($documents as $document) {
                try {
                    //$this->info('CONSULTANDO: '.$document->clave_SRI);
                    $response = new SriDocumentController();
                    $response->setDocumento($document->id);
                    $this->info('VALIDANDO DOCUMENTO: '.$document->claveAcceso);
                    $response->validateDocumentSRI();
                    $this->info('DOCUMENTO VALIDADO: '.$document->claveAcceso);
                }
                catch (\Exception $e) {

                    $this->info('NO SE PUDO VALIDAR EL DOCUMENTO: '.$document->claveAcceso);
                    $this->info('ERROR: '.$e->getMessage());
                }
            }
        }
        else {
            $this->info('The crontab is disabled');
        }

        $this->info('SRI:SEE A TERMINADO');

    }
}
