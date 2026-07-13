<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantModifyCatIdentityDocumentTypesCe extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::connection('tenant')->table('cat_identity_document_types')->where('description', 'CE')->update(['description' => 'IDENTIFICACIÓN DEL EXTERIOR']);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
