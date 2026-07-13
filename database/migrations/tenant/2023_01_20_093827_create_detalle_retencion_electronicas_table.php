<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDetalleRetencionElectronicasTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('detalle_retencion_electronicas', function (Blueprint $table) {
            $table->increments('id');
            $table->string('idComporbante',30);
            $table->char('codigoRet', 10);
            $table->double('baseRet', 15, 2);
            $table->double('porcentajeRet', 15, 2);
            $table->double('valorRet', 15, 2);
            $table->char('tipoDocAfectado', 2);
            $table->string('serieDocAfectado', 100);
            $table->string('fechaDocAfectado', 20);
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
        Schema::dropIfExists('detalle_retencion_electronicas');
    }
}
