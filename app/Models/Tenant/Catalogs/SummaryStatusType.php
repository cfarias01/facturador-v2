<?php

namespace App\Models\Tenant\Catalogs;

use App\Traits\UsesTenantConnection;

class SummaryStatusType extends ModelCatalog
{
    use UsesTenantConnection;

    protected $table = "cat_summary_status_types";
    public $incrementing = false;
}