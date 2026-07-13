<?php

namespace App\Models\Tenant;

use Illuminate\Database\Eloquent\Model;

class sriQuery extends Model
{
    //
    protected $fillable = [
        'ruc',
        'password',
        'anio',
        'mes',
        'dia',
        'archivos'
    ];
}
