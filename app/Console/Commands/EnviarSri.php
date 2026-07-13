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

class EnviarSri extends Command
{
    use CommandTrait;
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'sri:send';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'ENVIA LOS DOCUMENTOS AL SRI ECUADOR';

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
            if ($this->isOffline()) {
                $this->info('Offline service is enabled');
                return;
            }

            $company = Company::active();
            $documents = CabeceraDocumentoElectronica::query()
                ->whereIn('idEstado',['01'])
                ->orderBy('fecha','desc')
                //->limit(300)
                ->get();
            $this->info('EMPRESA : '.$company->name);
            foreach ($documents as $document) {
                try {
                    $proceso = new SriDocumentController();
                    $proceso->setDocumento($document->id);
                    $caveAcceso = $proceso->createXML($document->id);
                    if($caveAcceso){
                        $document->update([
                            'claveAcceso'=> $caveAcceso
                        ]);
                        $this->info('XML GENERADO PARA : '.$caveAcceso);
                        $firmarDoc = $proceso->firmarXML();
                        if($firmarDoc){
                            $this->info('XML FIRMADO PARA : '.$caveAcceso);
                            $proceso->sendToSriDocuments();
                        }else{
                            $this->info('XML NO FIRMADO PARA : '.$caveAcceso);
                        }
                    }else{
                        $this->info('NO SE PUDO GENERAR XML PARA DOCUMENTO ID: '.$document->id);
                    }
                    //$this->info('DOCUMENTO ENVIADO AL SRI: '.$document->claveAcceso);
                }
                catch (\Exception $e) {
                    $this->info('NO SE PUDO PROCESAR EL DOCUMENTO '.$document->id);
                    $this->info('NO SE PUDO PROCESAR EL DOCUMENTO '.$e->getMessage());

                }
            }
        }
        else {
            $this->info('The crontab is disabled');
        }

        $this->info('The command is finished');
    }
}
