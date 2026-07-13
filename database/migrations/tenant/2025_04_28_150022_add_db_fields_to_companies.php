<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddDbFieldsToCompanies extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('companies', function (Blueprint $table) {
            $table->string('sql_host',255)->nullable();
            $table->string('sql_pot',255)->nullable();
            $table->string('sql_username',255)->nullable();
            $table->string('sql_password',255)->nullable();
            $table->string('sql_db',255)->nullable();
            $table->string('sql_db2', 255)->nullable();
            $table->boolean('active_icg')->default(0);
            $table->string('extra_emails',255)->nullable();
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
            //
        });
    }
}
