<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantcreateDetalleDestinatario extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('destinatarios' ,function (Blueprint $table){
            $table->bigIncrements('id');
            $table->string("identificacion",20);
            $table->string("razon_social",255);
            $table->string("motivo",255);
            $table->string("docAduaneroUnico",20)->nullable();
            $table->string("codEstablecimiento",10);
            $table->string("ruta",100)->nullable();
            $table->string("direccion",255)->nullable();
            $table->string("codDocSustento",2)->nullable();
            $table->string("numDocSustento",20)->nullable();
            $table->string("numAutDocSustento",50)->nullable();
            $table->string("fechaEmisionDocSustento",10)->nullable();
            $table->string('id_documento',255);
            $table->timestamps();

            $table->foreign('id_documento')->references('idComporbante')->on('cabecera_documento_electronicas')->onDelete('cascade');

        });

        Schema::create('destinatarios_detalle' ,function (Blueprint $table){
            $table->bigIncrements('id');
            $table->string("codItem",20);
            $table->string("codAdicional",50)->nullable();
            $table->string("item",255);
            $table->double("cantidad",15,8);
            $table->string("adicionales",255)->nullable();
            $table->bigInteger('id_destinatario')->unsigned();
            $table->timestamps();

            $table->foreign('id_destinatario')->references('id')->on('destinatarios')->onDelete('cascade');

        });

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('destinatarios');
        Schema::dropIfExists('destinatarios_detalle');
    }
}
