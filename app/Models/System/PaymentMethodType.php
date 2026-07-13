<?php

namespace App\Models\System;
use Hyn\Tenancy\Traits\UsesSystemConnection;
use Illuminate\Database\Eloquent\Model;

class PaymentMethodType extends Model
{

    public $timestamps = false;

    protected $fillable = [
        'description',
    ];
}