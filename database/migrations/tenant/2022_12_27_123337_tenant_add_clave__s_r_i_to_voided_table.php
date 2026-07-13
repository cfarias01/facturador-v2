<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantAddClaveSRIToVoidedTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('voided', function (Blueprint $table) {
            //
            $table->json('clave_SRI')->nullable()->after('external_id');
           
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('voided', function (Blueprint $table) {
            //
            $table->dropColumn('clave_SRI');
        });
    }
}
