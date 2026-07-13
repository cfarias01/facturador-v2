<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantChangeTextAndCodeToCatDocumentTypes extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::disableForeignKeyConstraints();
        DB::table('cat_document_types')->where('description', 'LIQUIDACIÓN DE COMPRA')->delete();
        DB::table('cat_document_types')->where('id', '07')->update(['id' => '04']);
        DB::table('cat_document_types')->insert([ 
            ['id'=> '07', 'active' => true, 'short' => 'CO', 'description' => 'RETENCIÓN']
        ]);
        DB::table('cat_document_types')->where('id', '80')->update(['active' => false]);
        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::disableForeignKeyConstraints();
        DB::table('cat_document_types')->where('description', 'LIQUIDACIÓN DE COMPRA')->delete();
        DB::table('cat_document_types')->where('id', '07')->update(['id' => '04']);
        DB::table('cat_document_types')->where('id', '07')->delete();
        DB::table('cat_document_types')->where('id', '80')->update(['active' => false]);
        Schema::enableForeignKeyConstraints();
    }
}
