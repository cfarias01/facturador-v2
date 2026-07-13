<?php

namespace App\Models\Tenant;

use Illuminate\Database\Eloquent\Model;

class DetalleFacturaElectronica extends ModelTenant
{
    //
    protected $table = 'detalle_factura_electronicas';
    protected $fillable = [
        'id',
        'idComporbante',
        'cantidad',
        'item',
        'precioUnitario',
        'total',
        'iva',
        'ice',
        'irbpnr',
        'codigoIce',
        'codigoPorcentajeIce',
        'baseImponibleIce',
        'tarifaIce',
        'valorIce',
        'codigoIrbpnr',
        'codigoPorcentajeIrbpnr',
        'baseImponibleIrbpnr',
        'tarifaIrbpnr',
        'valorIrbpnr',
        'idLinea',
        'codItem',
        'descuento',
        'iva_code',
        'lote',
        'fecha_creado',
        'fecha_vencimiento',
    ];
}
