<?php

namespace App\Console\Commands;

use App\Models\System\Client;
use App\Models\System\Tenant;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class MigrarTenantsDesdeHyn extends Command
{
    protected $signature = 'tenancy:migrar-hyn';

    protected $description = 'Migra los websites/hostnames de hyn/multi-tenant a las tablas tenants/domains de stancl/tenancy, sin tocar las bases de datos fisicas de cada tenant.';

    public function handle()
    {
        $prefix = config('tenant.prefix_database') . '_';

        $websites = DB::connection('system')->table('websites')->whereNull('deleted_at')->get();
        $hostnames = DB::connection('system')->table('hostnames')->whereNull('deleted_at')->get();

        foreach ($websites as $website) {
            $hostname = $hostnames->firstWhere('website_id', $website->id);

            if (!$hostname) {
                $this->warn("No se encontro hostname para el website #{$website->id} (uuid: {$website->uuid}). Omitiendo.");
                continue;
            }

            // El uuid de hyn se armo como "{prefix}_{id}" (ver ClientController::store).
            // El id de tenant en stancl debe ser solo la parte final, porque
            // config/tenancy.php ya arma el nombre de BD como prefix+id.
            $tenantId = str_starts_with($website->uuid, $prefix)
                ? substr($website->uuid, strlen($prefix))
                : $website->uuid;

            $domain = rtrim($hostname->fqdn, '/');

            if (Tenant::find($tenantId)) {
                $this->info("El tenant '{$tenantId}' ya existe. Omitiendo creacion, solo verifico el dominio y el cliente.");
            } else {
                Tenant::create([
                    'id' => $tenantId,
                    'data' => [
                        'migrated_from_hyn_website_id' => $website->id,
                    ],
                ]);
                $this->info("Tenant creado: '{$tenantId}' (BD esperada: {$prefix}{$tenantId})");
            }

            $tenant = Tenant::find($tenantId);

            if (!$tenant->domains()->where('domain', $domain)->exists()) {
                $tenant->domains()->create(['domain' => $domain]);
                $this->info("Dominio '{$domain}' vinculado al tenant '{$tenantId}'.");
            }

            $updated = Client::where('hostname_id', $hostname->id)
                ->whereNull('tenant_id')
                ->update(['tenant_id' => $tenantId]);

            if ($updated) {
                $this->info("Cliente(s) actualizado(s) con tenant_id '{$tenantId}': {$updated}.");
            }
        }

        $this->info('Migracion de hyn/multi-tenant a stancl/tenancy completa.');
    }
}
