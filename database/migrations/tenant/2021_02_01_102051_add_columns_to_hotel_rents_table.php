<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddColumnsToHotelRentsTable extends Migration
{
	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::table('hotel_rents', function (Blueprint $table) {
			$table->dropColumn('payment_type');
			$table->dropColumn('payment_number_operation');
		});

		// Se agregan en un Schema::table() separado porque el original
		// intentaba posicionar ambas columnas "after('payment_number_operation')",
		// una columna que se dropea en el mismo bloque -- bug preexistente que
		// nunca fallo hasta ahora porque el schema builder de versiones previas
		// de Laravel no validaba esa referencia contra el estado post-drop.
		Schema::table('hotel_rents', function (Blueprint $table) {
			$table->date('input_date')->nullable();
			$table->string('input_time', 8)->nullable()->after('input_date');
		});
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::table('hotel_rents', function (Blueprint $table) {
			$table->string('payment_type', 10)->nullable();
			$table->string('payment_number_operation', 20)->nullable();
			$table->dropColumn('input_date');
			$table->dropColumn('input_time');
		});
	}
}
