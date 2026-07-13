<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantAdddirectionSucToCabeceraDocumentoElectronicas extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('cabecera_documento_electronicas', function (Blueprint $table) {
            $table->string('direccionEstablecimiento', 255)->nullable()->after('direccionMatriz');
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
            $table->dropColumn('direccionEstablecimiento');
        });
    }
}
