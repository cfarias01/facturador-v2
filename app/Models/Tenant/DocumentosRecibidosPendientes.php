<?php

namespace App\Models\Tenant;

use Illuminate\Database\Eloquent\Model;

class DocumentosRecibidosPendientes extends ModelTenant
{
    protected $table = 'documentos_recibidos_pendientes';
    public $timestamps = true;

    protected $fillable = [
        'archivo_id',
        'ruc_emisor',
        'razon_social_emisor',
        'tipo_documento',
        'serie_comprobante',
        'clave_acceso',
        'fecha_autorizacion',
        'fecha_emision',
        'identificador_receptor',
        'valor_sin_impuestos',
        'iva',
        'importe_total',
        'numero_documento_modificado',
        'estado'
    ];

    protected $casts = [
        'fecha_autorizacion' => 'datetime',
        'fecha_emision' => 'date',
        'valor_sin_impuestos' => 'float',
        'iva' => 'float',
        'importe_total' => 'float',
        'estado' => 'boolean',
    ];

    public function archivo()
    {
        return $this->belongsTo(ArchivosProcesar::class, 'archivo_id');
    }
    
    public function scopeFilter($query, array $filters)
    {
        $query->when($filters['search'] ?? false, function ($query, $search) {
            $query->where(function ($query) use ($search) {
                $query->where('ruc_emisor', 'like', '%' . $search . '%')
                    ->orWhere('razon_social_emisor', 'like', '%' . $search . '%')
                    ->orWhere('tipo_documento', 'like', '%' . $search . '%')
                    ->orWhere('serie_comprobante', 'like', '%' . $search . '%')
                    ->orWhere('clave_acceso', 'like', '%' . $search . '%');
            });
        });
    }
}
