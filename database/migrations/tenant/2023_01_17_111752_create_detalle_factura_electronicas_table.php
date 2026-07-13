<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDetalleFacturaElectronicasTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('detalle_factura_electronicas', function (Blueprint $table) {
            $table->string('idComporbante',30);
            $table->double('cantidad', 15, 2);
            $table->string('item', 255);
            $table->double('precioUnitario', 20, 12);
            $table->double('total', 15, 3);
            $table->integer('iva')->default(12);
            $table->integer('ice')->default(0);
            $table->integer('irbpnr')->default(0);
            $table->string('codigoIce', 50)->nullable()->default('3');
            $table->string('codigoPorcentajeIce', 50)->nullable()->default('0');
            $table->double('baseImponibleIce', 15, 2)->default(0.00);
            $table->double('tarifaIce', 15, 2)->default(0.00);
            $table->double('valorIce', 15, 2)->default(0.00);
            $table->string('codigoIrbpnr', 50)->nullable()->default('5');
            $table->string('codigoPorcentajeIrbpnr', 50)->nullable()->default('0');
            $table->double('baseImponibleIrbpnr', 15, 2)->default(0.00);
            $table->double('tarifaIrbpnr', 15, 2)->default(0.00);
            $table->double('valorIrbpnr', 15, 2)->default(0.00);
            $table->timestamps();
            $table->foreign('idComporbante')->references('idComporbante')->on('cabecera_documento_electronicas')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('detalle_factura_electronicas');
    }
}
