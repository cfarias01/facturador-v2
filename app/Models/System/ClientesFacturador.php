<?php

namespace App\Models\System;

use App\Traits\UsesSystemConnection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ClientesFacturador extends Model
{
    use HasFactory, UsesSystemConnection;

    protected $fillable = [
        'cedula',
        'nombre',
        'apellido',
        'email',
        'telefono',
        'direccion',
    ];

    
}
