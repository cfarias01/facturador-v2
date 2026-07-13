<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class DocumentosRecibidosPendientes extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('archivos_procesar', function (Blueprint $table) {

            $table->bigIncrements('id');
            $table->string('nombre_archivo', 255);
            $table->string('mes', 2);
            $table->string('anio', 4);
            $table->timestamps();

        });

        Schema::create('documentos_recibidos_pendientes', function (Blueprint $table) {

            $table->bigIncrements('id');
            $table->bigInteger('archivo_id')->unsigned();
            $table->string('ruc_emisor',13);
            $table->string('razon_social_emisor', 255);
            $table->string('tipo_documento', 255);
            $table->string('serie_comprobante', 255);
            $table->string('clave_acceso', 255);
            $table->dateTime('fecha_autorizacion');
            $table->date('fecha_emision');
            $table->string('identificador_receptor', 255);
            $table->float('valor_sin_impuestos', 15,2)->nullable();
            $table->float('iva', 15,2)->nullable();
            $table->float('importe_total', 15,2)->nullable();
            $table->string('numero_documento_modificado', 255);
            $table->boolean('estado')->default(0);
            $table->foreign('archivo_id')->references('id')->on('archivos_procesar')->onDelete('cascade');
            $table->timestamps();

        });
    }
    
    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('archivos_procesar');
        Schema::dropIfExists('documentos_recibidos_pendientes');
    }
}
