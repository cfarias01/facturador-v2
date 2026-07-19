<?php

namespace App\Traits;

/**
 * Reemplaza Hyn\Tenancy\Traits\UsesSystemConnection.
 *
 * Usa el nombre de conexion configurado como central en config/tenancy.php
 * (database.central_connection), que es 'system' -- el mismo nombre que ya
 * usaba hyn/multi-tenant.
 */
trait UsesSystemConnection
{
    public function getConnectionName()
    {
        return config('tenancy.database.central_connection', 'system');
    }
}
