<?php

namespace App\Models\Tenant;

use Illuminate\Database\Eloquent\Model;

class ArchivosProcesar extends ModelTenant
{
    protected $table = 'archivos_procesar';

    public $timestamps = true;

    protected $fillable = [
        'nombre_archivo',
        'mes',
        'anio',
        'created_at',
        'updated_at',
    ];

    public function documentosRecibidosPendientes()
    {
        return $this->hasMany(DocumentosRecibidosPendientes::class, 'archivo_id');
    }
}
