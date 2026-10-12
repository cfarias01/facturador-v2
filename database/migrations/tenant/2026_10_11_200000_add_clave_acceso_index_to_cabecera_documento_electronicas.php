<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * DownloadController busca el documento por claveAcceso en cada descarga de
 * XML/PDF (enlaces publicos y de correo). Sin indice, cada una recorre toda la
 * tabla cabecera_documento_electronicas, que es la que mas crece.
 */
return new class extends Migration
{
    private string $table = 'cabecera_documento_electronicas';
    private string $index = 'idx_cde_claveAcceso';

    public function up(): void
    {
        if (! Schema::hasTable($this->table) || Schema::hasIndex($this->table, $this->index)) {
            return;
        }

        Schema::table($this->table, function (Blueprint $table) {
            $table->index('claveAcceso', $this->index);
        });
    }

    public function down(): void
    {
        if (Schema::hasTable($this->table) && Schema::hasIndex($this->table, $this->index)) {
            Schema::table($this->table, function (Blueprint $table) {
                $table->dropIndex($this->index);
            });
        }
    }
};
