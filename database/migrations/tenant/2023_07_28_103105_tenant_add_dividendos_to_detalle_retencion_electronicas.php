<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantAddDividendosToDetalleRetencionElectronicas extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('detalle_retencion_electronicas', function (Blueprint $table) {
            $table->string('fechaPagoDiv', 10)->nullable();
            $table->decimal('imRentaSoc',12,8)->nullable();
            $table->integer('ejerFisUtDiv')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('detalle_retencion_electronicas', function (Blueprint $table) {
            //
            $table->dropColumn('fechaPagoDiv');
            $table->dropColumn('imRentaSoc');
            $table->dropColumn('ejerFisUtDiv');
        });
    }
}
