<?php

namespace App\Models\System;

use App\Traits\UsesSystemConnection;
use Illuminate\Database\Eloquent\Model;

class PlanDocument extends Model
{
    use UsesSystemConnection;

    protected $table = "plan_documents";
    
    protected $fillable = [
        'description', 
    ];

    public $timestamps = false;
}
