<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantSriDocumentsApiGet extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('documentos_recibidos_sri', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('ambiente');
            $table->integer('tipoEmision');
            $table->string('razonSocial');
            $table->string('nombreComercial');
            $table->string('ruc',13);
            $table->string('claveAcceso');
            $table->char('codDoc',2);
            $table->char('estab',3);
            $table->char('ptoEmi',3);
            $table->char('secuencial',9);
            $table->string('dirMatriz', 255);
            $table->string('agenteRetencion',5)->nullable();
            $table->string('contribuyenteRimpe',50)->nullable();
            $table->string('fechaEmision');
            $table->string('dirEstablecimiento',255)->nullable();
            $table->char('obligadoContabilidad', 2);
            $table->char('tipoIdentificacionComprador',2);
            $table->string('razonSocialComprador',255);
            $table->string('identificacionComprador',20);
            $table->longText('direccionComprador')->nullable();
            $table->double('totalSinImpuestos', 15, 2);
            $table->double('totalDescuento', 15, 2);
            $table->json('totalConImpuestos');
            $table->double('propina', 15, 2);
            $table->double('importeTotal', 15, 2);
            $table->string('moneda', 100)->nullable()->default('DOLAR');
            $table->json('pagos');
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
        //
        Schema::dropIfExists('documentos_recibidos_sri');
    }
}
