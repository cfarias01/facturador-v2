<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantSriDocumentsDetailApiGet extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('documentos_recibidos_detail_sri', function (Blueprint $table) {

            $table->increments('id');
            $table->unsignedInteger('document_id');
            $table->string('codigoPrincipal', 100);
            $table->string('descripcion', 100);
            $table->double('cantidad', 15, 2);
            $table->double('precioUnitario', 20,2);
            $table->double('descuento', 15, 2);
            $table->double('precioTotalSinImpuesto', 15,2);
            $table->json('impuestos');

            $table->foreign('document_id')->references('id')->on('documentos_recibidos_sri')->onDelete('cascade');
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
        Schema::dropIfExists('documentos_recibidos_detail_sri');
    }
}
