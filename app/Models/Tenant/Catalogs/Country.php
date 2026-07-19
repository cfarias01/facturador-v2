<?php

namespace App\Models\Tenant\Catalogs;

use App\Traits\UsesTenantConnection;

class Country extends ModelCatalog
{
    use UsesTenantConnection;

    public $incrementing = false;
    public $timestamps = false;
}