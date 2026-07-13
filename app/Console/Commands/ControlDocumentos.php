<?php

namespace App\Console\Commands;

use App\Http\Controllers\Tenant\SriDocumentController;
use App\Models\Tenant\Company;
use App\Models\Tenant\Configuration;
use App\Services\IntegradorService;
use Illuminate\Console\Command;

class ControlDocumentos extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'icg:failed';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Busca todos los documentos que no fueron cargados al facturador para notificar al administrador del sistema';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {

        if (Configuration::firstOrFail()->cron) {
            $company = Company::active();
            $service = new IntegradorService();
            if($company->active_icg){
                 $this->info('EMPRESA : '.$company->name);
                $documents = $service->getResumenNoCargadosDiario($company);

                if ($documents && count($documents) > 0) {
                    $this->info(count($documents));
                    try {
                        $response = new SriDocumentController();
                        $response->sendEmailNotification($documents);
                    }
                    catch (\Exception $e) {
                        $this->info('ERROR: '.$e->getMessage());
                    }
                }
            }         
        }
        else {
            $this->info('The crontab is disabled');
        }

        $this->info('Notificación de sistema enviada');
    }
}
