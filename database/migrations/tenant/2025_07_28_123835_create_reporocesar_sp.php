<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {

        // Crear el Stored Procedure SP_REPROCESAR_DOCUMENTOS
        DB::unprepared("
            CREATE PROCEDURE SP_REPROCESAR_DOCUMENTOS()
            BEGIN
            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '01', fpagos = REPLACE(fPagos,'unidadtiempo\": \"\"','unidadtiempo\": \"DIAS\"')  
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%unidadTiempo%' 
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '07' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%CLAVE ACCESO REGISTRADA%'  
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '07' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%CLAVE DE ACCESO EN PROCESAMIENTO%'  
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '07' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%DOCUMENTO AUTORIZADO POR EL SRI%'  
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '07' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%DOCUMENTO RECIBIDO POR EL SRI%'  
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '01' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%NO SE PUDO VALIDAR EL DOCUMENTO EN EL SRI%'  
                AND IdEstado = '30';
            END
        ");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('SP_REPROCESAR_DOCUMENTOS');
    }
};
