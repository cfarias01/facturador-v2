<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

use Stancl\Tenancy\Database\Models\Tenant;
use Illuminate\Support\Facades\DB;
//use Stancl\Tenancy\Tenant;
use Illuminate\Support\Facades\Artisan;

class MigrarTenantsDesdeHyn extends Command
{
    protected $signature = 'tenancy:migrar-hyn';

    protected $description = 'Migrar tenants desde Hyn a Stancl tenancy';

    public function handle()
    {
        $websites = DB::table('websites')->get();
        $hostnames = DB::table('hostnames')->get();

        foreach ($websites as $website) {
            $hostname = $hostnames->firstWhere('website_id', $website->id);

            if (!$hostname) {
                $this->warn("No se encontró hostname para el website ID: {$website->id}");
                continue;
            }

            $tenantId = $hostname->fqdn;

            if (Tenant::find($tenantId)) {
                $this->info("El tenant {$tenantId} ya existe. Omitiendo...");
                continue;
            }

            $tenant = Tenant::create([
                'id' => $tenantId,
                'data' => [
                    'fqdn' => $hostname->fqdn,
                    'plan' => $website->plan ?? 'default',
                ],
            ]);

            $this->info("Tenant creado: {$tenantId}");

            // Activar tenant y ejecutar migraciones
            $tenant->run(function () use ($tenantId) {
                $this->info("Ejecutando migraciones para: {$tenantId}");
                Artisan::call('tenants:migrate', [
                    '--tenants' => [$tenantId],
                    '--force' => true,
                ]);
            });
        }

        $this->info('Migración completa ✅');
    }
}
