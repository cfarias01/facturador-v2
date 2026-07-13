<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class TenantAlterCabeceraDocs extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('detalle_factura_electronicas', function (Blueprint $table) {
            $table->double('descuento', 15, 12)->nullable()->default(0.00);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('detalle_factura_electronicas', function (Blueprint $table) {
           $table->dropColumn('descuento');
        });
    }
}
