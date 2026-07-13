<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantAddPagosriPaymentMethods extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::table('payment_method_types', function (Blueprint $table) {
            //
            $table->char('pago_sri',2);
            //$table->foreign('pago_sri')->references('code')->on('sri_formas_pago');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
        Schema::table('payment_method_types', function (Blueprint $table) {
            //
            $table->dropColumn('pago_sri');
        });
    }
}
