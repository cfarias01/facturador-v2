<?php

namespace App\Console\Commands;

use App\Http\Controllers\Tenant\SriDocumentController;
use App\Models\Tenant\CabeceraDocumentoElectronica;
use App\Models\Tenant\Company;
use App\Models\Tenant\Configuration;
use Illuminate\Console\Command;

class SendEmailAuth extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'sri:email';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'This command send emails to customers when a document is accepted by SRI';

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
            $documents = CabeceraDocumentoElectronica::whereIn('idEstado', ['05'])
                ->where('send_email',1)
                ->where('emailed',0)
                ->limit(40)
                ->get();

            $this->info('EMPRESA : '.$company->name);
            foreach ($documents as $document) {
                try {
                    //$this->info('CONSULTANDO: '.$document->clave_SRI);
                    $response = new SriDocumentController();
                    $response->setDocumento($document->id);
                    $result = $response->sendEmail3($document->id);
                    $this->info('Email del documento: '.$document->id. ' '. $result['success']);
                }
                catch (\Exception $e) {

                    $this->info('NO SE PUDO ENVIAR EL CORREO DEL DOCUMENTO: '.$document->claveAcceso);
                    $this->info('ERROR: '.$e->getMessage());
                }
            }
        }
        else {
            $this->info('The crontab is disabled');
        }
    }
}
