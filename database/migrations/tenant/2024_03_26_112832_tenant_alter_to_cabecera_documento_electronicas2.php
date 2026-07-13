<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantAlterToCabeceraDocumentoElectronicas2 extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('cabecera_documento_electronicas', function (Blueprint $table) {
            $table->longText('impuestos')->nullable();
            $table->boolean('icg')->default(false);
        });
        Schema::table('detalle_factura_electronicas', function (Blueprint $table) {
            $table->integer('iva_code')->unsigned()->nullable();
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
            $table->dropColumn('impuestos');
        });
        Schema::table('detalle_factura_electronicas', function (Blueprint $table) {
            $table->dropColumn('iva_code');
        });
    }
}
