<?php

namespace App\Models\System;

use Illuminate\Database\Eloquent\Model;
use Hyn\Tenancy\Traits\UsesSystemConnection;

class HistoryResource extends Model
{


    protected $fillable = [
        'cpu_percent',
        'memory_total',
        'memory_free',
        'memory_used',
    ];
}
