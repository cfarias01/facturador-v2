<?php

namespace App\Traits;

/**
 * Reemplaza Hyn\Tenancy\Traits\UsesTenantConnection.
 *
 * stancl/tenancy crea la conexion dinamica del tenant activo siempre bajo el
 * nombre 'tenant' (ver config/tenancy.php y DatabaseTenancyBootstrapper), asi
 * que el reemplazo es un mapeo directo.
 */
trait UsesTenantConnection
{
    public function getConnectionName()
    {
        return 'tenant';
    }
}
