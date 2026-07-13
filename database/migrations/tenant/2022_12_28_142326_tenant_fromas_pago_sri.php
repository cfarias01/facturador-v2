<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantFromasPagoSri extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('sri_formas_pago', function (Blueprint $table) {
            $table->increments('id');
            $table->char('code', 2);
            $table->string('description');
        });
        
        DB::table('sri_formas_pago')->insert([
            ['code' => '01', 'description' => 'SIN UTILIZACION DEL SISTEMA FINANCIERO'],
            ['code' => '15', 'description' => 'COMPENSACIÓN DE DEUDAS'],
            ['code' => '16', 'description' => 'TARJETA DE DÉBITO'],
            ['code' => '17', 'description' => 'DINERO ELECTRÓNICO'],
            ['code' => '18', 'description' => 'TARJETA PREPAGO'],
            ['code' => '19', 'description' => 'TARJETA DE CRÉDITO'],
            ['code' => '20', 'description' => 'OTROS CON UTILIZACIÓN DEL SISTEMA FINANCIERO'],
            ['code' => '21', 'description' => 'ENDOSO DE TÍTULOS'],
        ]);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
        Schema::dropIfExists('sri_formas_pago');
    }
}
