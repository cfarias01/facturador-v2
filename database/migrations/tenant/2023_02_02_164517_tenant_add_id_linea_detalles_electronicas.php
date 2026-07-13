<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantAddIdLineaDetallesElectronicas extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('detalle_factura_electronicas', function (Blueprint $table) {
            $table->string('idLinea', 30)->unique()->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {

        Schema::table('detalle_factura_electronicas', function (Blueprint $table) {
            $table->dropIfExists('idLinea');
        });
    }
}
