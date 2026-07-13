<?php

namespace App\Models\Tenant;

use App\Models\Tenant\Catalogs\DocumentType;
use Illuminate\Database\Eloquent\Model;

class Destinatarios extends ModelTenant
{
    protected $table = 'destinatarios';
    protected $fillable = [
        'id',
        'identificacion',
        'razon_social',
        'direccion',
        'motivo',
        'docAduaneroUnico',
        'codEstablecimiento',
        'ruta',
        'codDocSustento',
        'numDocSustento',
        'numAutDocSustento',
        'fechaEmisionDocSustento',
        'id_documento',
    ];
    protected $with = ['destinatarios_detalle','cat_document_types'];

    public function destinatarios_detalle()
    {
        return $this->hasMany(Destinatarios_detalle::class,'id_destinatario','id');
    }
    public function cat_document_types()
    {
        return $this->hasOne(DocumentType::class,'id','codDocSustento');
    }
}
