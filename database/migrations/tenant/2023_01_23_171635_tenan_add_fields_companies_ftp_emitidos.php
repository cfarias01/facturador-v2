<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenanAddFieldsCompaniesFtpEmitidos extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::table('companies', function (Blueprint $table) {
            $table->string('ftpEmitidosServer',20)->nullable();
            $table->char('ftpEmitidosPort', 10)->nullable();
            $table->string('ftpEmitidosUser', 255)->nullable();
            $table->string('ftpEmitidosPass', 100)->nullable();
            $table->string('ftpEmitidosRutaFac', 255)->nullable();
            $table->string('ftpEmitidosRutaNota', 255)->nullable();
            $table->string('ftpEmitidosRutaRetencion', 255)->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {

        Schema::table('companies', function (Blueprint $table) {

            $table->dropColumn('ftpEmitidosServer');
            $table->dropColumn('ftpEmitidosPort');
            $table->dropColumn('ftpEmitidosUser');
            $table->dropColumn('ftpEmitidosPass');
            $table->dropColumn('ftpEmitidosRutaFac');
            $table->dropColumn('ftpEmitidosRutaNota');
            $table->dropColumn('ftpEmitidosRutaRetencion');

        });

    }
}
