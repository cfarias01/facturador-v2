<?php

namespace App\Models\System;

use Stancl\Tenancy\Contracts\TenantWithDatabase;
use Stancl\Tenancy\Database\Concerns\HasDatabase;
use Stancl\Tenancy\Database\Concerns\HasDomains;
use Stancl\Tenancy\Database\Models\Tenant as BaseTenant;

class Tenant extends BaseTenant implements TenantWithDatabase
{
    use HasDatabase, HasDomains;

    public function client()
    {
        return $this->hasOne(Client::class);
    }

    /**
     * Alias de compatibilidad: hyn/multi-tenant exponia "uuid" en Website (que
     * en la practica ya era el identificador logico del tenant). Aca "uuid" y
     * la clave primaria "id" son el mismo valor.
     */
    public function getUuidAttribute()
    {
        return $this->id;
    }

    /**
     * Alias de compatibilidad con hyn: Website::hostnames era una coleccion,
     * aca Tenant::domains ya cumple el mismo rol (relacion hasMany).
     */
    public function getHostnamesAttribute()
    {
        return $this->domains;
    }
}
