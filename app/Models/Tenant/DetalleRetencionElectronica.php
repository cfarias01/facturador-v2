<?php

namespace App\Models\Tenant;

use Illuminate\Database\Eloquent\Model;

class DetalleRetencionElectronica extends ModelTenant
{
    //
    protected $table = 'detalle_retencion_electronicas';
    protected $fillable = [
        'id',
        'idComporbante',
        'codigoRet',
        'baseRet',
        'porcentajeRet',
        'valorRet',
        'tipoDocAfectado',
        'serieDocAfectado',
        'fechaDocAfectado',
        'fechaPagoDiv',
        'imRentaSoc',
        'ejerFisUtDiv',

    ];

}
