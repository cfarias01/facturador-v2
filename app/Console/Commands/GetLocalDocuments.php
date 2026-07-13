<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Facades\App\Http\Controllers\Tenant\SriDocumentController;

use App\Models\Tenant\{
    Configuration,
    Company
};
use Illuminate\Support\Facades\Log;

class GetLocalDocuments extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'documents:local {date?}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Buscar documentos en una ruta local y procesarlos';

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


                $rutoFact = $company->ftpEmitidosRutaFac.'/'.$fechaActual;
                $rutaNota =  $company->ftpEmitidosRutaNota.'/'.$fechaActual;

                $this->info('CONECTANDO A FTP: '.$company->name );
                //$this->info('CONECTANDO A FTP: '.$server.' '.$usuario.' '.$contrasena.' '.$puerto.' '.$rutoFact);
                $listaComporbantes=$SriDocumentController::getDocumentFromFTP('emitidos',$server,$usuario,$contrasena,$puerto,$rutoFact);
                if($listaComporbantes){
                    //$this->info('DOCUMENTOS DESCARGADOS');
                    $rsult = $SriDocumentController::cargarDatosBD('emitidos',$rutoFact);
                    if($rsult){

                        $this->info('DOCUMENTOS PROCESADOS');

                    }else{
                        $this->info('NO SE PUDIERON PROCESAR LOS DOCUMENTOS, PARA MAS DETALLES REVISAR EL LOG');
                    }
                }else{
                    $this->info('NO SE CONECTO AL FTP');
                }

                $listaComporbantes=$SriDocumentController::getDocumentFromFTP('emitidos',$server,$usuario,$contrasena,$puerto,$rutaNota);
                if($listaComporbantes){
                    //$this->info('DOCUMENTOS DESCARGADOS');
                    $rsult = $SriDocumentController::cargarDatosBD('emitidos',$rutaNota);
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
