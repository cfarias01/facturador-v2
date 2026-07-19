<?php

namespace App\Models\Tenant\Catalogs;

use App\Traits\UsesTenantConnection;

class NoteCreditType extends ModelCatalog
{
    use UsesTenantConnection;
    
    protected $table = "cat_note_credit_types";
    public $incrementing = false;
}