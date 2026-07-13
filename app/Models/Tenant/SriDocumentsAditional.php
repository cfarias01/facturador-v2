<?php

namespace App\Models\Tenant;

use Carbon\Carbon;
use Eloquent;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class SriDocumentsAditional extends ModelTenant
{

    public $timestamps = false;
    protected $table = 'documentos_recibidos_aditional_sri';
    protected $fillable = [
        'document_id',
        'nombre',
        'valor'
    ];

}
