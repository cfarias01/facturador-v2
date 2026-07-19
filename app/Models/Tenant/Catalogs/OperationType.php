<?php

namespace App\Models\Tenant\Catalogs;

use App\Traits\UsesTenantConnection;

class OperationType extends ModelCatalog
{
    use UsesTenantConnection;

    protected $table = "cat_operation_types";
    public $incrementing = false;
}