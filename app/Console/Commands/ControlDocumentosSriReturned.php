<?php

namespace App\Console\Commands;

use App\Http\Controllers\Tenant\SriDocumentController;
use App\Models\Tenant\CabeceraDocumentoElectronica;
use App\Models\Tenant\Company;
use App\Models\Tenant\Configuration;
use Illuminate\Console\Command;

class ControlDocumentosSriReturned extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'icg:returned';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Este comando se encarga de notificar el estado de los documentos devueltos por el SRI';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
         if (Configuration::firstOrFail()->cron) {
            $company = Company::active();
            

            if($company->active_icg){

                $this->info('EMPRESA : '.$company->name);
                $documents = CabeceraDocumentoElectronica::whereIn('idEstado',['30','09'])->get();

                if ($documents && $documents->count() > 0) {
                    $this->info(count($documents));
                    try {
                        $response = new SriDocumentController();
                        $response->sendEmailNotificationReturned($documents);
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
