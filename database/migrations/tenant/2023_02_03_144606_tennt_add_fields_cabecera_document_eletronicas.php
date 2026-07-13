<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenntAddFieldsCabeceraDocumentEletronicas extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('cabecera_documento_electronicas', function (Blueprint $table) {
            $table->char('tipoRegi', 2)->nullable();
            $table->integer('paisEfecPago')->nullable();
            $table->char('aplicConvDobTrib', 2)->nullable();
            $table->char('pagExtSujRetNorLeg', 2)->nullable();
            $table->char('pagoRegFis',2)->nullable();
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
            $table->dropIfExists('tipoRegi');
            $table->dropIfExists('paisEfecPago');
            $table->dropIfExists('aplicConvDobTrib');
            $table->dropIfExists('pagExtSujRetNorLeg');
            $table->dropIfExists('pagoRegFis');
        });
    }
}
