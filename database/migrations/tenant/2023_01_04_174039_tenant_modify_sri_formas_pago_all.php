<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantModifySriFormasPagoAll extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Tarjeta crédito visa')->update(['description' => 'Pago Inmediato']);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Contado contraentrega')->update(['pago_sri' => '01']);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Crédito')->update(['description' => 'Crédito a 15 días']);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Contado')->update(['description' => 'Canje']);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'Crédito 60 días')->update(['description' => 'Crédito 90 días']);
        DB::connection('tenant')->table('payment_method_types')->where('description', 'A 30 días')->update(['description' => 'Crédito a 60 días']);
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
