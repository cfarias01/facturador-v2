<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateRetencionesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('retenciones', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('ambiente');
            $table->string('tipo_emision');
            $table->string('razon_social');
            $table->string('nombre_comercial');
            $table->string('ruc');
            $table->string('clave_acceso');
            $table->string('cod_doc');
            $table->string('estab');
            $table->string('pto_emi');
            $table->string('secuencial');
            $table->string('dir_matriz');
            $table->date('fecha_emision');
            $table->string('contribuyente_especial')->nullable();
            $table->string('obligado_contabilidad');
            $table->string('tipo_identificacion_sujeto_retenido');
            $table->string('razon_social_sujeto_retenido');
            $table->string('identificacion_sujeto_retenido');
            $table->string('periodo_fiscal');
            $table->timestamps();
        });

        Schema::create('impuestos', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('retencion_id');
            $table->string('codigo');
            $table->string('codigo_retencion');
            $table->decimal('base_imponible', 10, 2);
            $table->decimal('porcentaje_retener', 5, 2);
            $table->decimal('valor_retenido', 10, 2);
            $table->string('cod_doc_sustento');
            $table->string('num_doc_sustento');
            $table->date('fecha_emision_doc_sustento');
            $table->foreign('retencion_id')->references('id')->on('retenciones')->onDelete('cascade');
            $table->timestamps();
        });

        Schema::create('adicionales_retenciones',function(Blueprint $table){
            $table->bigIncrements('id');
            $table->string('nombre',255);
            $table->string('valor',255);
            $table->unsignedBigInteger('retencion_id');
            $table->foreign('retencion_id')->references('id')->on('retenciones')->onDelete('cascade');

        });

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('retenciones');
        Schema::dropIfExists('impuestos');
        Schema::dropIfExists('adicionales_retenciones');
    }
}
