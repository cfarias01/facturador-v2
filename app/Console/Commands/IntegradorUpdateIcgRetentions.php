<?php

namespace App\Console\Commands;

use App\Http\Controllers\Tenant\DocumentApiController;
use App\Models\Tenant\CabeceraDocumentoElectronica;
use Error;
use Illuminate\Console\Command;

class IntegradorUpdateIcgRetentions extends Command
{
    /**
     * The name and signature of the console command.     *
     * @var string
     */
    protected $signature = 'icg:retentions';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Comando que actualiza las retenciones autorizadas del facturador en ICG';

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
        $this->info('Ejecutando comando');
        $service = new \App\Services\IntegradorService();
        $company = \App\Models\Tenant\Company::find(1); // Cambia el ID según sea necesario
        $service->conectar($company);
        $retenciones = CabeceraDocumentoElectronica::where('tipoComprobante', '7')
            ->where('idEstado', '05')
            ->where('icg', 0)
            ->get();

        if ($retenciones->isEmpty()) {
            $this->info('No se encontraron retenciones pendientes de actualizar.');
            return;
        }

        foreach ($retenciones as $row) {

            if($row->claveAcceso){

                $procesado =  $service->updateRetention($company,$row->claveAcceso);
                $this->info('Retencion a actualizar en ICG.'. $row->claveAcceso);
                if($procesado){
                    $this->info('Retención actualizada correctamente en ICG: ' . $row->claveAcceso);
                    $row->icg = 1; // Marcar como procesada
                    $row->save();
                } else {
                    $this->error('Error al actualizar la retención en ICG: ' . $row->claveAcceso);
                }
            }
        }
        
        $this->info('Comando ICG ejecutado correctamente.');

    }
}
