<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddIndexesToCabeceraDocumentoTable extends Migration
{
    /**
     * Lista de nombres de tabla probados (ajusta si tu tabla tiene otro nombre).
     *
     * @var array
     */
    protected $tableCandidates = [
        'cabecera_documento_electronicas',
    ];

    /**
     * Columnas a indexar => nombre de índice.
     *
     * @var array
     */
    protected $columns = [
        'fecha' => 'idx_cde_fecha',
        'tipoComprobante' => 'idx_cde_tipoComprobante',
        'idEstado' => 'idx_cde_idEstado',
        'orderNo' => 'idx_cde_orderNo',
        'ruc' => 'idx_cde_ruc',
        'idInterno' => 'idx_cde_idInterno',
    ];

    /**
     * Ejecutar migración.
     *
     * @return void
     */
    public function up()
    {
        $tableName = null;
        foreach ($this->tableCandidates as $candidate) {
            if (Schema::hasTable($candidate)) {
                $tableName = $candidate;
                break;
            }
        }

        if (!$tableName) {
            // Si no existe ninguna tabla candidata, no hacer nada.
            return;
        }

        foreach ($this->columns as $column => $indexName) {
            if (Schema::hasColumn($tableName, $column)) {
                // Crear índice solo si no existe (try/catch evita errores si ya existe)
                try {
                    Schema::table($tableName, function (Blueprint $table) use ($column, $indexName) {
                        $table->index($column, $indexName);
                    });
                } catch (\Throwable $e) {
                    // index could already exist or other DB-specific error; ignore to keep migration idempotente
                }
            }
        }
    }

    /**
     * Revertir migración.
     *
     * @return void
     */
    public function down()
    {
        $tableName = null;
        foreach ($this->tableCandidates as $candidate) {
            if (Schema::hasTable($candidate)) {
                $tableName = $candidate;
                break;
            }
        }

        if (!$tableName) {
            return;
        }

        foreach ($this->columns as $column => $indexName) {
            if (Schema::hasColumn($tableName, $column)) {
                try {
                    Schema::table($tableName, function (Blueprint $table) use ($indexName) {
                        $table->dropIndex($indexName);
                    });
                } catch (\Throwable $e) {
                    // ignore if index doesn't exist
                }
            }
        }
    }
}