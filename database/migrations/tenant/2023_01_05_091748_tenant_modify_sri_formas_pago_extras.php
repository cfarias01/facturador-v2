<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantModifySriFormasPagoExtras extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Pago Inmediato')->update(['pago_sri' => '01']);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Crédito a 15 días')->update(['number_days' => 15]);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Crédito a 15 días')->update(['pago_sri' => '01']);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Canje')->update(['pago_sri' => '01']);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Crédito 90 días')->update(['number_days' => 90]);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Crédito a 60 días')->update(['number_days' => 60]);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Crédito a 60 días')->update(['pago_sri' => '01']);
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
