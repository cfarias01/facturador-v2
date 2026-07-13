<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantSendMeailToCabeceraDocumentoElectronicas extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('cabecera_documento_electronicas', function (Blueprint $table) {
            $table->boolean('send_email')->nullable()->default(false);
            $table->boolean('emailed')->nullable()->default(false);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */

    public function down()
    {
        Schema::table('cabecera_documento_electronicas', function (Blueprint $table) {
            $table->dropColumn('send_email');
            $table->dropColumn('emailed');
        });
    }
}
