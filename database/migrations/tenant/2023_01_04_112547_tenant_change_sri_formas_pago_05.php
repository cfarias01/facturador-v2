<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantChangeSriFormasPago05 extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Crédito 30 días')->delete();
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Factura a 30 días')->update(['description' => 'Crédito 30 días']);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
