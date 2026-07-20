<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ChangeDataTo extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // El workaround de Doctrine para mapear 'enum' -> 'string' ya no hace
        // falta ni existe en Laravel 11+ (Schema::change() dejo de depender
        // de doctrine/dbal para esto).
        Schema::table('documentary_files', function (Blueprint $table) {
            //
            $table->mediumText('number')->nullable()->change();
            $table->longText('sender')->nullable()->change();
            $table->longText('subject')->nullable()->change();
            $table->longText('attached_file')->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('documentary_files', function (Blueprint $table) {
            //
        });
    }
}
