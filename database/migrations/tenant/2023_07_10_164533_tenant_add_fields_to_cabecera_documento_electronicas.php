<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantAddFieldsToCabeceraDocumentoElectronicas extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('cabecera_documento_electronicas', function (Blueprint $table) {
            $table->string('direccionDePartida', 255)->nullable();
            $table->string('fechaIniTranporte', 10)->nullable();
            $table->string('fechaFinTransporte', 10)->nullable();
            $table->string('placa', 20)->nullable();

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('cabecera_documento_electronicas', function (Blueprint $table) {
            $table->dropColumn('direccionDePartida');
            $table->dropColumn('fechaIniTranporte');
            $table->dropColumn('fechaFinTransporte');
            $table->dropColumn('placa');
        });
    }
}
