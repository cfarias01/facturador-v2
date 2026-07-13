<?php

namespace App\Models\System;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ClientesFacturador extends Model
{
    use HasFactory;

    protected $fillable = [
        'cedula',
        'nombre',
        'apellido',
        'email',
        'telefono',
        'direccion',
    ];

    
}
