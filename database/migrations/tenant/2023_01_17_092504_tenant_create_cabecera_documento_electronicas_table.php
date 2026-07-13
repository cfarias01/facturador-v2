<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantCreateCabeceraDocumentoElectronicasTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {

        Schema::create('cabecera_documento_electronicas', function (Blueprint $table) {

            $table->increments('id');
            $table->string('idComporbante',30);
            $table->string('idEstado')->default('01');
            $table->date('fecha');
            $table->string('fechaFizcal', 100)->nullable();
            $table->integer('orderNo');
            $table->string('cliente', 100);
            $table->text('direccion');
            $table->string('telefono', 20);
            $table->string('ruc', 13);
            $table->integer('tipoComprobante');
            $table->integer('tipoIdentificador');
            $table->string('correo', 255)->nullable()->default('email@email.com');
            $table->char('establecimiento', 3);
            $table->char('ptoEmision', 3);
            $table->char('rucEmpresa', 13);
            $table->char('secuencial', 9);
            $table->char('ambiente', 1)->default('1');
            $table->text('razonSocial')->nullable();
            $table->text('nombreComercial')->nullable();
            $table->text('direccionMatriz')->nullable();
            $table->char('obligadoContabilidad', 2)->default('NO');
            $table->integer('notaNo')->nullable();
            $table->integer('numeroCE')->nullable();
            $table->char('codSustento', 5)->nullable();
            $table->char('codDocSustento', 5)->nullable();
            $table->char('parteRel', 2)->nullable()->default('NO');
            $table->char('numAuthSustento', 50)->nullable();
            $table->char('fPago', 5)->nullable();
            $table->char('pagoLocExt', 2)->nullable();
            $table->char('tipoDocAfectado', 2)->nullable();
            $table->string('secuencialDocAfectado', 20)->nullable();
            $table->string('motivoDev', 50)->nullable();
            $table->string('fechaDocSustento', 20)->nullable();
            $table->string('nombreDoc', 255)->nullable();
            $table->double('importeTotal', 15,2)->nullable();
            $table->double('importeSinImpuestos', 15,2)->nullable();
            $table->double('descuento', 15,2)->nullable();
            $table->double('baseIva12', 15,2)->nullable();
            $table->double('valorIva12', 15,2)->nullable();
            $table->double('baseIva0', 15,2)->nullable();
            $table->char('claveAcceso',49)->nullable();
            $table->tinyInteger('regularizeShipping')->nullable();
            $table->json('responseRegularizeShipping')->nullable();
            $table->date('dateAuthorization')->nullable();
            $table->time('timeAuthorization')->nullable();
            $table->jsonb('fPagos')->nullable();
            $table->timestamps();

            $table->unique('idComporbante');
            $table->foreign('idEstado')->references('id')->on('state_types');

        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('cabecera_documento_electronicas');
    }
}
