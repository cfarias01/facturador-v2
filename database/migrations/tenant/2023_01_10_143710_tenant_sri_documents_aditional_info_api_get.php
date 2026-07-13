<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantSriDocumentsAditionalInfoApiGet extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('documentos_recibidos_aditional_sri', function (Blueprint $table) {

            $table->increments('id');
            $table->unsignedInteger('document_id');
            $table->longText('nombre');
            $table->longText('valor');

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
        Schema::dropIfExists('documentos_recibidos_aditional_sri');
    }
}
