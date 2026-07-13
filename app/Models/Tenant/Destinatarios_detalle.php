<?php

namespace App\Models\Tenant;

use Illuminate\Database\Eloquent\Model;

class Destinatarios_detalle extends ModelTenant
{
    protected $table = 'destinatarios_detalle';
    protected $fillable = [
        'id',
        'codItem',
        'codAdicional',
        'item',
        'cantidad',
        'adicionales',
        'id_destinatario',
    ];
    protected $cast =[
        'cantidad'=>'decimal',
    ];
}
