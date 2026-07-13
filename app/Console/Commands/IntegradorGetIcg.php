<?php

namespace App\Console\Commands;

use App\Http\Controllers\Tenant\DocumentApiController;
use Error;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;

class IntegradorGetIcg extends Command
{
    /**
     * The name and signature of the console command.     *
     * @var string
     */
    protected $signature = 'icg:get';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Comando para recuperar documentos de ICG';

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
        $this->info('Ejecutando comando para recuperar documentos de ICG...');
        $service = new \App\Services\IntegradorService();
        $company = \App\Models\Tenant\Company::find(1); // Cambia el ID según sea necesario

        if (!$company) {
            $this->error('No se encontró la empresa con ID 1.');
            return;
        }

        if ($company->active_icg == 0) {

            $this->error('La empresa ' . $company->name . ' no tiene activo el integrador ICG.');
            Log::error('La empresa ' . $company->name . ' no tiene activo el integrador ICG.');
            return;

        } else {

            $process = new DocumentApiController();
            $service->conectar($company);
            $service->ejecutarSPNuevosDoc($company);
            $this->info('Conexión establecida correctamente A LA EMPRESA '.$company->name);
            //$this->info('Ejecutando procedimiento almacenado JOIN_NUEVOSDOC...');
            $result = $service->selectDocumentosAProcesar($company) ?? [];
            $this->info("Registros encontrados: " . count($result));
            foreach ($result as $row) {

                //FACTURAS
                if ($row['TIPODOC'] == '01') {

                    $request = new \Illuminate\Http\Request();
                    $request->merge([
                        'data' => base64_encode($row['JSON']),
                        'token' => base64_encode($company->tokenApi),
                    ]);

                    $result = $process->createInvoice($request);
                    $this->info('Factura procesada correctamente.' . $row['NUMDOC'] . "-" . $row['NUMSERIE']);
                    $service->updateDocumentoNuevos($company, json_encode($result), $row['NUMDOC'], $row['NUMSERIE']);
                }
                //NOTAS DE CREDITO
                if ($row['TIPODOC'] == '04') {

                    $request = new \Illuminate\Http\Request();
                    $request->merge([
                        'data' => base64_encode($row['JSON']),
                        'token' => base64_encode($company->tokenApi),
                    ]);

                    $result = $process->createNote($request);
                    $this->info('Nota de crédito procesada correctamente.' . $row['NUMDOC'] . "-" . $row['NUMSERIE']);
                    $service->updateDocumentoNuevos($company, json_encode($result), $row['NUMDOC'], $row['NUMSERIE']);
                }
                //RETENCIONES
                if ($row['TIPODOC'] == '07') {

                    $request = new \Illuminate\Http\Request();
                    $request->merge([
                        'data' => base64_encode($row['JSON']),
                        'token' => base64_encode($company->tokenApi),
                    ]);

                    $result = $process->createRetention($request);
                    $this->info('Retencion procesada correctamente.' . $row['NUMDOC'] . "-" . $row['NUMSERIE']);
                    $service->updateDocumentoNuevos($company, json_encode($result), $row['NUMDOC'], $row['NUMSERIE']);
                }

                //LIQUIDACIONES
                if ($row['TIPODOC'] == '03') {

                    $request = new \Illuminate\Http\Request();
                    $request->merge([
                        'data' => base64_encode($row['JSON']),
                        'token' => base64_encode($company->tokenApi),
                    ]);

                    $result = $process->createLiquidation($request);
                    $this->info(' Liquidacion procesada correctamente.' . $row['NUMDOC'] . "-" . $row['NUMSERIE']);
                    $service->updateDocumentoNuevos($company, json_encode($result), $row['NUMDOC'], $row['NUMSERIE']);
                }
            }

            $this->info('Comando ICG ejecutado correctamente.');
        }
    }
}
