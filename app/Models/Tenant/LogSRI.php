<?php

namespace App\Models\Tenant;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LogSRI extends ModelTenant
{
    use HasFactory;

    protected $table = 'log_sri';
    protected $fillable = [
        'document_id',
        'type',
        'message',
        'status',
        'created_at',
        'updated_at'
    ];
}
