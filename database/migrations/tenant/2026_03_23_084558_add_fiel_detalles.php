<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('detalle_factura_electronicas', function (Blueprint $table) {
            $table->string('lote',50)->nullable();
            $table->string('fecha_creado',10)->nullable();
            $table->string('fecha_vencimiento',10)->nullable();
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
            $table->dropColumn('lote');
            $table->dropColumn('fecha_creado');
            $table->dropColumn('fecha_vencimiento');
        });
    }
};
