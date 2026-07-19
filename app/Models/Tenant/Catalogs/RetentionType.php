<?php

namespace App\Models\Tenant\Catalogs;

use App\Traits\UsesTenantConnection;

class RetentionType extends ModelCatalog
{
    use UsesTenantConnection;

    protected $table = "cat_retention_types";
    public $incrementing = false;
}