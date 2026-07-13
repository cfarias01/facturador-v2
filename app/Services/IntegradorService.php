<?php

namespace App\Services;

use App\Models\Tenant\Company;
use Exception;
use Illuminate\Database\Connectors\SqlServerConnector;
use PDO;
use Illuminate\Support\Facades\Log;

class IntegradorService
{

    protected $con;

    public function conectar(Company $company)
    {

        try {
            $config = [
                'driver' => 'sqlsrv',
                'host' => $company->sql_host,
                'database' => $company->sql_db,
                'username' => $company->sql_username,
                'password' => $company->sql_password,
                'options' => [
                    'TrustServerCertificate' => true,
                ],
            ];

            $connector = new SqlServerConnector();
            $this->con = $connector->connect($config);

            if ($this->con) {
                Log::error("Conexión establecida correctamente.");
            } else {
                Log::error("Error al conectar con la base de datos.");
            }
        } catch (Exception $ex) {
            Log::error("Error al intentar conectar con la base de datos.");
            Log::error($ex->getMessage());
        }
    }

    public function ejecutarSPNuevosDoc(Company $company)
    {

        try {

            $this->conectar($company);
            $query = "EXEC [{$company->sql_db2}].[dbo].[JOIN_NUEVOSDOC]";
            $stmt = $this->con->prepare($query);
            // Ejecutar de forma asíncrona
            $stmt->execute();

            return true;
        } catch (Exception $ex) {

            Log::error("Error al tratar de ejcutar nuevos doc");
            Log::error($ex->getMessage());
        }
    }

    public function selectDocumentosAProcesar(Company $company)
    {
        try {
            Log::error("Conectando a la base de datos de ICG para seleccionar documentos a procesar.");
            $this->conectar($company);
            $query = "SELECT * FROM LOG_DOCUMENTOS_ICG WHERE JSON IS NOT NULL AND RESPUESTAENVIO IS NULL AND RESPUESTACOMPROBACION IS NULL AND FECHAENVIO IS NULL AND EMPRESA = '{$company->client_id_pse}'";
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            // Obtener los resultados
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return $resultados;
        } catch (Exception $ex) {
            Log::error("Error al selecionar la listo de documento spor cargar");
            Log::error($ex->getMessage());
        }
    }

    public function updateDocumentoNuevos(Company $company, $respuestaEnvio, $numdoc, $numserie)
    {

        try {
			
            $this->conectar($company);
            // Usar parámetros para evitar problemas de sintaxis y SQL Injection
            $query = "UPDATE LOG_DOCUMENTOS_ICG SET FECHAENVIO = GETDATE(), RESPUESTAENVIO = :respuestaEnvio WHERE NUMSERIE = :numserie AND NUMDOC = :numdoc AND EMPRESA = :empresa";
            Log::error($query);
            $stmt = $this->con->prepare($query);
            $respuestaEnvioJson = json_encode($respuestaEnvio);
            $company_id = $company->client_id_pse;
            $stmt->bindParam(':respuestaEnvio', $respuestaEnvioJson);
            $stmt->bindParam(':numserie', $numserie);
            $stmt->bindParam(':numdoc', $numdoc);
            $stmt->bindParam(':empresa', $company_id);
            $stmt->execute();

            return true;
        } catch (Exception $ex) {
            Log::error("Error al selecionar la listo de documento spor cargar");
            Log::error($ex->getMessage());
        }
    }

    public function getDocumentosEnviados(Company $company)
    {

        try {
            $this->conectar($company);
            $query = "SELECT * FROM LOG_DOCUMENTOS_ICG WHERE JSON IS NOT NULL AND RESPUESTAENVIO LIKE '%true%' AND RESPUESTACOMPROBACION IS NULL AND EMPRESA = '{$company->client_id_pse}'";
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            // Obtener los resultados
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return $resultados;
        } catch (Exception $ex) {
            Log::error("Error getDocumentosEnviados");
            Log::error($ex->getMessage());
        }
    }
    
    public function updateDocumentosProcesados(Company $company, $comporbacion, $numdoc, $numserie)
    {

        try {
            $this->conectar($company);
            $query = "UPDATE LOG_DOCUMENTOS_ICG SET FECHACOMPROBACION = GETDATE(), RESPUESTACOMPROBACION = :comprobacion WHERE NUMSERIE = :numserie AND NUMDOC = :numdoc AND EMPRESA = :empresa";
            $company_id = $company->client_id_pse;
            $stmt = $this->con->prepare($query);
            $stmt->bindParam(':comprobacion', $comporbacion);
            $stmt->bindParam(':numserie', $numserie);
            $stmt->bindParam(':numdoc', $numdoc);
            $stmt->bindParam(':empresa', $company_id);
            $stmt->execute();

            return true;
        } catch (Exception $ex) {
            Log::error("Error updateDocumentosProcesados");
            Log::error($ex->getMessage());
        }
    }

    public function getDocumentsFailed(Company $company, $numserie = null, $numdoc = null, $fechaini = null, $fechafin = null)
    {

        try {
            $this->conectar($company);
            $query = "SELECT * FROM LOG_DOCUMENTOS_ICG WHERE JSON IS NOT NULL AND (RESPUESTAENVIO LIKE '%false%' OR RESPUESTAENVIO LIKE '%fwrite()%' OR RESPUESTAENVIO IS NULL OR RESPUESTAENVIO = '' OR RESPUESTAENVIO LIKE '%, ERROR:%') AND RESPUESTACOMPROBACION IS NULL AND EMPRESA = '{$company->client_id_pse}' ";
            if ($numserie) {
                $query .= " AND NUMSERIE = '{$numserie}'";
            }
            if ($numdoc) {
                $query .= " AND NUMDOC = {$numdoc}";
            }
            if ($fechaini) {
                $query .= " AND FECHAENVIO >= '{$fechaini}'";
            }
            if ($fechafin) {
                $query .= " AND FECHAENVIO <= '{$fechafin}'";
            }
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return $resultados;
        } catch (Exception $ex) {
            Log::error("Error getDocumentsFailed");
            Log::error($ex->getMessage());
        }
    }

    public function reprocesarDocumentosFailed(Company $company, $numserie = null, $numdoc = null, $fechaini = null, $fechafin = null)
    {
        try {
            $this->conectar($company);
            $query = "DELETE FROM LOG_DOCUMENTOS_ICG WHERE (RESPUESTAENVIO LIKE '%false%' OR RESPUESTAENVIO LIKE '%fwrite()%' OR RESPUESTAENVIO IS NULL OR RESPUESTAENVIO = '' OR RESPUESTAENVIO LIKE '%, ERROR:%') AND RESPUESTACOMPROBACION IS NULL AND EMPRESA = '{$company->client_id_pse}'";
            if ($numserie) {
                $query .= " AND NUMSERIE = '{$numserie}'";
            }
            if ($numdoc) {
                $query .= " AND NUMDOC = {$numdoc}";
            }
            if ($fechaini) {
                $query .= " AND FECHAENVIO >= '{$fechaini}'";
            }
            if ($fechafin) {
                $query .= " AND FECHAENVIO <= '{$fechafin}'";
            }
            $stmt = $this->con->prepare($query);
            $stmt->execute();

            return [
                'success' => true,
                'message' => 'Documentos reprocesados correctamente.'
            ];
            
        } catch (Exception $ex) {
            Log::error("Error reprocesarDocumentosFailed");
            Log::error($ex->getMessage());
        }
    }

    public function deletedocument(Company $company, $numserie, $numdoc)
    {

        try {
            $this->conectar($company);
            $query = "DELETE FROM LOG_DOCUMENTOS_ICG WHERE NUMSERIE = '{$numserie}' AND NUMDOC = {$numdoc} AND EMPRESA = '{$company->client_id_pse}'";
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            // Obtener los resultados

            return true;
        } catch (Exception $ex) {
            Log::error("Error updateDocumentosProcesados");
            Log::error($ex->getMessage());
        }
    }

    public function updateRetention(Company $company, $claveAcceso)
    {
        try {

            $this->conectar($company);
            $query = "UPDATE "."[{$company->sql_db2}].[dbo].[FACTURASCOMPRACOMPROBANTERET] SET FIRMA = CLAVEACCESO WHERE CLAVEACCESO = '{$claveAcceso}'";
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            return true;
        }
        catch (Exception $ex) {
            Log::error("Error al actualizar la frima de la retencion.");
            Log::error($ex->getMessage());
            return false;
        }
    }
	
	public function updateFacturaVenta(Company $company, $claveAcceso){
		
		try {

            $this->conectar($company);
            $query = "UPDATE "."[{$company->sql_db2}].[dbo].[FACTURASVENTAFIRMA] SET FIRMA = CLAVEACCESO WHERE CLAVEACCESO = '{$claveAcceso}'";
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            return true;
        }
        catch (Exception $ex) {
            Log::error("Error al actualizar la frima de la Factura de Venta.");
            Log::error($ex->getMessage());
            return false;
        }
		
	}

    public function updateLiquidacionCompra(Company $company, $claveAcceso){
		
		try {

            $this->conectar($company);
            $query = "UPDATE "."[{$company->sql_db2}].[dbo].[FACTURASCOMPRAFIRMA] SET FIRMA = CLAVEACCESO WHERE CLAVEACCESO = '{$claveAcceso}'";
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            return true;
        }
        catch (Exception $ex) {
            Log::error("Error al actualizar la frima de la Factura de Venta.");
            Log::error($ex->getMessage());
            return false;
        }
		
	}
	
	public function updateNotasCredito(Company $company, $claveAcceso){
		
		try {

            $this->conectar($company);
            $query = "UPDATE "."[{$company->sql_db2}].[dbo].[FACTURASVENTAFIRMA] SET FIRMA = CLAVEACCESO WHERE CLAVEACCESO = '{$claveAcceso}'";
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            return true;
        }
        catch (Exception $ex) {
            Log::error("Error al actualizar la frima de la nota de crédito ");
            Log::error($ex->getMessage());
            return false;
        }
		
	}
	
    public function deleteDocumentClaveAcceso(Company $company, $claveAcceso)
    {
        try {
            $this->conectar($company);
            $query = "DELETE FROM LOG_DOCUMENTOS_ICG WHERE CLAVEACCESO = '{$claveAcceso}' AND EMPRESA = '{$company->client_id_pse}'";
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            return true;
        } catch (Exception $ex) {
            Log::error("Error al eliminar el documento por clave de acceso.");
            Log::error($ex->getMessage());
        }

    }

    public function getResumenNoCargadosDiario(Company $company){
        try {

            $this->conectar($company);
            $query = "SELECT CLAVEACCESO, NUMSERIE, NUMDOC, ERRORSQL, RESPUESTAENVIO FROM LOG_DOCUMENTOS_ICG WHERE  RESPUESTAENVIO NOT LIKE '%Sin errores%' AND RESPUESTAENVIO NOT LIKE '%ya se encuentra registrado en el sistema%' AND EMPRESA = '{$company->client_id_pse}' 
            UNION ALL 
            SELECT CLAVEACCESO, NUMSERIE, NUMDOC, ERRORSQL, RESPUESTAENVIO FROM LOG_DOCUMENTOS_ICG WHERE ( ERRORSQL IS NOT NULL AND RESPUESTAENVIO NOT LIKE '%Sin errores%' AND RESPUESTAENVIO NOT LIKE '%ya se encuentra registrado en el sistema%' ) AND EMPRESA = '{$company->client_id_pse}'
            UNION ALL
            SELECT CLAVEACCESO, NUMSERIE, NUMDOC, ERRORSQL, RESPUESTAENVIO FROM LOG_DOCUMENTOS_ICG WHERE RESPUESTAENVIO LIKE '%:false%' AND EMPRESA = '{$company->client_id_pse}' ";
            $stmt = $this->con->prepare($query);
            $stmt->execute();
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return $resultados;
            
        } catch (Exception $ex) {

            Log::error("Error al recuperar documentos de resumen diario");
            Log::error($ex->getMessage());
        }
    }
 
}
