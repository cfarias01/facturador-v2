<?php

namespace App\Console\Commands;

use App\Http\Controllers\Tenant\SriDocumentController;
use App\Models\Tenant\CabeceraDocumentoElectronica;
use App\Models\Tenant\Company;
use App\Models\Tenant\Configuration;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class SriSendReturnedDocuments extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'sri:returned';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Este comando reprocesa de forma automatica los documentos que estan en estado 30 (DEVUELTOS) llamam al SP SP_REPROCESAR_DOCUMENTOS';

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
            $this->info('Reprocesando docuemnto de la EMPRESA : '.$company->name);
            DB::connection('tenant')->statement('CALL SP_REPROCESAR_DOCUMENTOS();');
            DB::connection('tenant')->statement('CALL OPTIMIZAR_TABLAS();');
 
            $this->info('Se ejecuto el SP de reporcesar documentos');

        }
        else {
            $this->info('The crontab is disabled');
        }

        $this->info('Comando de reporcesar documentos devuelto Finalizado');
        
    }
}
