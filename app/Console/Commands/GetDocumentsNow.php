<?php

namespace App\Console\Commands;

use App\Http\Controllers\Tenant\SriDocumentController;
use App\Models\Tenant\Company;
use App\Models\Tenant\SriDocumentsDetails;
use Illuminate\Console\Command;

class GetDocumentsNow extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'documents:now {companiId?}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'PROCESAR UN DOCUMENTO DEL FTP AL MOMENTO DE EJECUTAR EL COMANDO';

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
        $rucEmpresa = $this->argument('companiId');

        $SriDocumentController = new SriDocumentController();
        $company = Company::active();

        if (isset($rucEmpresa)){
            if($rucEmpresa == $company->number){
                if(isset($company->ftpEmitidosServer)){

                    $server = $company->ftpEmitidosServer;
                    $usuario = $company->ftpEmitidosUser;
                    $contrasena = $company->ftpEmitidosPass;
                    $puerto = $company->ftpEmitidosPort;

                    //$fechaActual = date("Y-m-d");
                    $fechaActual = "carga_eventual";
                    $rutoFact = $company->ftpEmitidosRutaFac.'/'.$fechaActual;
                    $rutaNota =  $company->ftpEmitidosRutaNota.'/'.$fechaActual;
                    $rutaRet =  $company->ftpEmitidosRutaRetencion.'/'.$fechaActual;

                    $this->info('CONECTANDO A FTP: '.$company->name );
                    $listaComporbantes = $SriDocumentController->getDocumentFromFTP('emitidos',$server,$usuario,$contrasena,$puerto,$rutoFact);
                    if($listaComporbantes){
                        $rsult = $SriDocumentController->cargarDatosBD('emitidos',$rutoFact);
                        if($rsult){

                            $this->info('DOCUMENTOS PROCESADOS');

                        }else{
                            $this->info('NO SE PUDIERON PROCESAR LOS DOCUMENTOS, PARA MAS DETALLES REVISAR EL LOG');
                        }
                    }else{
                        $this->info('NO SE CONECTO AL FTP');
                    }

                    $listaComporbantes=$SriDocumentController->getDocumentFromFTP('emitidos',$server,$usuario,$contrasena,$puerto,$rutaNota);
                    if($listaComporbantes){
                        //$this->info('DOCUMENTOS DESCARGADOS');
                        $rsult = $SriDocumentController->cargarDatosBD('emitidos',$rutaNota);
                        if($rsult){

                            $this->info('DOCUMENTOS PROCESADOS');

                        }else{
                            $this->info('NO SE PUDIERON PROCESAR LOS DOCUMENTOS, PARA MAS DETALLES REVISAR EL LOG');
                        }
                    }else{
                        $this->info('NO SE CONECTO AL FTP');
                    }

                    $listaComporbantes=$SriDocumentController->getDocumentFromFTP('emitidos',$server,$usuario,$contrasena,$puerto,$rutaRet);
                    if($listaComporbantes){
                        //$this->info('DOCUMENTOS DESCARGADOS');
                        $rsult = $SriDocumentController->cargarDatosBD('emitidos',$rutaRet);
                        if($rsult){

                            $this->info('DOCUMENTOS PROCESADOS');

                        }else{
                            $this->info('NO SE PUDIERON PROCESAR LOS DOCUMENTOS, PARA MAS DETALLES REVISAR EL LOG');
                        }
                    }else{
                        $this->info('NO SE CONECTO AL FTP');
                    }
                }
            }
        }else{

            if(isset($company->ftpEmitidosServer)){

                $server = $company->ftpEmitidosServer;
                $usuario = $company->ftpEmitidosUser;
                $contrasena = $company->ftpEmitidosPass;
                $puerto = $company->ftpEmitidosPort;

                //$fechaActual = date("Y-m-d");
                $fechaActual = "carga_eventual";
                $rutoFact = $company->ftpEmitidosRutaFac.'/'.$fechaActual;
                $rutaNota =  $company->ftpEmitidosRutaNota.'/'.$fechaActual;
                $rutaRet =  $company->ftpEmitidosRutaRetencion.'/'.$fechaActual;

                $this->info('CONECTANDO A FTP: '.$company->name );
                $listaComporbantes = $SriDocumentController->getDocumentFromFTP('emitidos',$server,$usuario,$contrasena,$puerto,$rutoFact);
                if($listaComporbantes){
                    $rsult = $SriDocumentController->cargarDatosBD('emitidos',$rutoFact);
                    if($rsult){

                        $this->info('DOCUMENTOS PROCESADOS');

                    }else{
                        $this->info('NO SE PUDIERON PROCESAR LOS DOCUMENTOS, PARA MAS DETALLES REVISAR EL LOG');
                    }
                }else{
                    $this->info('NO SE CONECTO AL FTP');
                }

                $listaComporbantes=$SriDocumentController->getDocumentFromFTP('emitidos',$server,$usuario,$contrasena,$puerto,$rutaNota);
                if($listaComporbantes){
                    //$this->info('DOCUMENTOS DESCARGADOS');
                    $rsult = $SriDocumentController->cargarDatosBD('emitidos',$rutaNota);
                    if($rsult){

                        $this->info('DOCUMENTOS PROCESADOS');

                    }else{
                        $this->info('NO SE PUDIERON PROCESAR LOS DOCUMENTOS, PARA MAS DETALLES REVISAR EL LOG');
                    }
                }else{
                    $this->info('NO SE CONECTO AL FTP');
                }

                $listaComporbantes=$SriDocumentController->getDocumentFromFTP('emitidos',$server,$usuario,$contrasena,$puerto,$rutaRet);
                if($listaComporbantes){
                    //$this->info('DOCUMENTOS DESCARGADOS');
                    $rsult = $SriDocumentController->cargarDatosBD('emitidos',$rutaRet);
                    if($rsult){

                        $this->info('DOCUMENTOS PROCESADOS');

                    }else{
                        $this->info('NO SE PUDIERON PROCESAR LOS DOCUMENTOS, PARA MAS DETALLES REVISAR EL LOG');
                    }
                }else{
                    $this->info('NO SE CONECTO AL FTP');
                }
            }
        }

    }
}
