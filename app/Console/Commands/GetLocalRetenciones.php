<?php

namespace App\Console\Commands;

use App\Models\Tenant\Company;
use App\Models\Tenant\Configuration;
use Facades\App\Http\Controllers\Tenant\SriDocumentController;
use Illuminate\Console\Command;

class GetLocalRetenciones extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'local:retentions {date?}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Descarga las retenciones del FTP';

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
        $SriDocumentController = new SriDocumentController();
        $company = Company::active();


        if (Configuration::firstOrFail()->cron) {
            $config = Configuration::get();

            if(isset($company->ftpEmitidosServer)){

                $server = $company->ftpEmitidosServer;
                $usuario = $company->ftpEmitidosUser;
                $contrasena = $company->ftpEmitidosPass;
                $puerto = $company->ftpEmitidosPort;

                $dateInput = $this->argument('date');
                $fechaActual = date("Y-m-d");

                if(isset($dateInput) && $dateInput != ''){
                    $fechaActual = $dateInput;
                }

                $rutaRet =  $company->ftpEmitidosRutaRetencion.'/'.$fechaActual;

                $this->info('CONECTANDO A FTP DE RETENCIONES: '.$company->name);

                $listaComporbantes=$SriDocumentController::getDocumentFromFTP('emitidos',$server,$usuario,$contrasena,$puerto,$rutaRet);
                if($listaComporbantes){
                    //$this->info('DOCUMENTOS DESCARGADOS');
                    $rsult = $SriDocumentController::cargarDatosBD('emitidos',$rutaRet);
                    if($rsult){

                        $this->info('DOCUMENTOS PROCESADOS');

                    }else{
                        $this->info('NO SE PUDIERON PROCESAR LOS DOCUMENTOS, PARA MAS DETALLES REVISAR EL LOG');
                    }
                }else{
                    $this->info('NO SE CONECTO AL FTP');
                }



            }

        }else{
            $this->info('FAIL GET CONFIG');
        }


    }
}
