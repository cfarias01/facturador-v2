<?php

namespace App\Support\Tenancy;

use App\Models\System\Tenant;

/**
 * Shim de compatibilidad con Hyn\Tenancy\Environment.
 *
 * Reemplaza la clase de hyn/multi-tenant manteniendo la misma firma
 * (tenant() como getter/setter) para minimizar los cambios en los ~16
 * controladores/comandos/jobs que la usaban para cambiar de tenant activo,
 * mientras que por debajo usa tenancy()->initialize() de stancl/tenancy.
 *
 * Acepta como argumento tanto un App\Models\System\Tenant como un objeto
 * "shape" antiguo de hyn (con propiedad ->uuid, ej. Hyn\Tenancy\Models\Website)
 * o directamente el id (string) del tenant.
 */
class Environment
{
    /**
     * Get or set the current tenant.
     *
     * @param  Tenant|object|string|null  $tenant
     * @return Tenant|null
     */
    public function tenant($tenant = null): ?Tenant
    {
        if ($tenant === null) {
            return tenancy()->tenant;
        }

        if (is_string($tenant)) {
            $tenant = Tenant::findOrFail($tenant);
        } elseif (!($tenant instanceof Tenant)) {
            // Compat: objeto con forma de Hyn\Tenancy\Models\Website (propiedad uuid).
            $tenant = Tenant::findOrFail($tenant->uuid);
        }

        tenancy()->initialize($tenant);

        return $tenant;
    }
}
