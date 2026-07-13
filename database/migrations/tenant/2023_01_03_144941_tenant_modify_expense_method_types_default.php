<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantModifyExpenseMethodTypesDefault extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::connection('tenant')->table('expense_method_types')->where('description', 'Tarjeta de crédito')->delete();
        DB::connection('tenant')->table('expense_method_types')->where('description', 'Tarjeta de débito')->delete();
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
