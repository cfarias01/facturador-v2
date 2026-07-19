<?php

namespace App\Models\System;

use Stancl\Tenancy\Database\Models\Domain as BaseDomain;

class Domain extends BaseDomain
{
    /**
     * Alias de compatibilidad: hyn/multi-tenant exponia el hostname como "fqdn".
     */
    public function getFqdnAttribute()
    {
        return $this->domain;
    }
}
