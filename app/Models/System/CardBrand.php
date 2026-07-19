<?php

namespace App\Models\System;
use App\Traits\UsesSystemConnection;
use Illuminate\Database\Eloquent\Model;

class CardBrand extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'description',
    ];
}