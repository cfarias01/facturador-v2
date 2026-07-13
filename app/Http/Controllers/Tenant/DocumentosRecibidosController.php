<?php

namespace App\Http\Controllers\Tenant;

use App\CoreFacturalo\Facturalo;
use App\Http\Controllers\Controller;
use App\Models\Tenant\ArchivosProcesar;
use App\Models\Tenant\DocumentosRecibidosPendientes;
use Dom\XMLDocument;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use RecursiveArrayIterator;
use RecursiveIteratorIterator;
use Symfony\Component\VarDumper\Cloner\Data;

class DocumentosRecibidosController extends Controller
{


    public function index_received(Request $request)
    {
        return view('tenant.documents_received.index');
    }


    public function index_received2()
    {
        return view('tenant.documents_uploaded.index');
    }

    public function records_received2(Request $request)
    {
        $data = \App\Models\Tenant\DocumentosRecibidosPendientes::query();
        $data->orderBy('created_at', 'desc');

        if (isset($request->ruc_emisor)) {
            $data->where('ruc_emisor', 'like', '%' . $request->ruc_emisor . '%');
        }
        if (isset($request->razon_social_emisor9)) {
            $data->where('razon_social_emisor', 'like', '%' . $request->razon_social_emisor . '%');
        }
        if (isset($request->serie_comprobante)) {
            $data->where('serie_comprobante', 'like', '%' . $request->serie_comprobante . '%');
        }
        if (isset($request->tipo_comprobante)) {
            $data->where('tipo_documento', 'like', '%' . $request->tipo_comprobante . '%');
        }
        if (isset($request->numero_documento_modificado)) {
            $data->where('numero_documento_modificado', 'like', '%' . $request->numero_documento_modificado . '%');
        }

        if (isset($request->autorizacion_start) && isset($request->autorizacion_end)) {

            $data->where('fecha_autorizacion', '>=', \Carbon\Carbon::parse($request->autorizacion_start)->format('Y-m-d'));
            $data->where('fecha_autorizacion', '<=', \Carbon\Carbon::parse($request->autorizacion_end)->format('Y-m-d H:i:s'));

        }else if (isset($request->autorizacion_start)) {

            $data->where('fecha_autorizacion', 'like', '%' .$request->autorizacion_start . '%');
        }else if (isset($request->autorizacion_end)) {
            $data->where('fecha_autorizacion', 'like', '%' .$request->autorizacion_end. '%');
        }

        if (isset($request->emision_start) && isset($request->emision_end)) {

            $data->where('fecha_emision', '>=', \Carbon\Carbon::parse($request->emision_start)->format('Y-m-d'));
            $data->where('fecha_emision', '<=', \Carbon\Carbon::parse($request->emision_end)->format('Y-m-d H:i:s'));

        }else if (isset($request->emision_start)) {
            $data->where('fecha_emision', 'like', '%' .$request->emision_start. '%');
        }else if (isset($request->emision_end)) {
            $data->where('fecha_emision', 'like', '%' .$request->emision_end. '%');
        }

        $documentos = $data->get();
        return compact('documentos');
    }

    public function records_received(Request $request)
    {
        $data = \App\Models\Tenant\ArchivosProcesar::query();
        $data->orderBy('created_at', 'desc');

        if ($request->has('name')) {
            $data->where('nombre_archivo', 'like', '%' . $request->name . '%');
        }

        $documentos = $data->get();

        return compact('documentos');
    }

    public function destroy($id)
    {
        try {

            $documento = \App\Models\Tenant\DocumentosRecibidosPendientes::findOrFail($id);
            $documento->delete();

            return response()->json([
                'message' => 'Documento eliminado correctamente, Se eliminaros los registros relacionados',
                'success' => true,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error al eliminar el documento: ' . $e->getMessage(),
                'success' => false,
            ]);
        }
    }

    public function import(Request $request)
    {
        Log::info("entro a la carga de documentos");

        if ($request->hasFile('file')) {
            $file = $request->file('file');

            if ($file->isValid() && $file->getRealPath()) {

                $content = file($file->getRealPath(), FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
            } else {
                return response()->json([
                    'message' => 'Invalid file or empty file',
                    'success' => false,
                ]);
            }

            Log::info("MES " . $request->mes);
            Log::info("ANIO " . $request->anio);

            $validar = \App\Models\Tenant\ArchivosProcesar::where('nombre_archivo', $file->getClientOriginalName())
                ->where('mes', $request->mes)
                ->where('anio', $request->anio)
                ->first();

            if ($validar) {
                return response()->json([
                    'message' => 'El archivo ya fue procesado, eliminalo para volver a cargarlo',
                    'success' => false,
                ]);
            }

            $archivo = new ArchivosProcesar();
            $archivo->nombre_archivo = $file->getClientOriginalName();
            $archivo->mes = $request->mes;
            $archivo->anio = $request->anio;
            $archivo->save();

            if (!$archivo->id) {

                return response()->json([
                    'message' => 'Error al guardar el archivo',
                    'success' => false,
                ]);
            }

            Log::info("Nombre del archivo: " . $archivo->nombre_archivo);
            Log::info("ID del archivo: " . $archivo->id);

            foreach ($content as $line) {
                Log::info("Contenido de la línea: " . $line);
                $dataArray = explode("\t", $line);

                if ($dataArray[0] == 'RUC_EMISOR') {
                    continue; // Skip the header line
                }

                $documento = new DocumentosRecibidosPendientes();
                $documento->archivo_id = $archivo->id;
                $documento->ruc_emisor = $dataArray[0] ?? null;
                $documento->razon_social_emisor = isset($dataArray[1]) ? mb_convert_encoding($dataArray[1], 'UTF-8', 'auto') : null;
                $documento->tipo_documento = isset($dataArray[2]) ? trim(str_replace(['á', 'é', 'í', 'ó', 'ú'], ['a', 'e', 'i', 'o', 'u'], $dataArray[2])) : null;
                $documento->serie_comprobante = isset($dataArray[3]) ? trim($dataArray[3]) : null;
                $documento->clave_acceso = $dataArray[4] ?? null;
                $documento->fecha_autorizacion = isset($dataArray[5]) ? \Carbon\Carbon::createFromFormat('d/m/Y H:i:s', $dataArray[5])->format('Y-m-d H:i:s') : null;
                $documento->fecha_emision = isset($dataArray[6]) ? \Carbon\Carbon::createFromFormat('d/m/Y', $dataArray[6])->format('Y-m-d') : null;
                $documento->identificador_receptor = $dataArray[7] ?? null;
                $documento->valor_sin_impuestos = isset($dataArray[8]) ? (is_numeric($dataArray[8]) ? (float)$dataArray[8] : null) : null;
                $documento->iva =  isset($dataArray[9]) ? (is_numeric($dataArray[9]) ? (float)$dataArray[9] : null) : null;
                $documento->importe_total = isset($dataArray[10]) ? (is_numeric($dataArray[10]) ? (float)$dataArray[10] : null) : null;
                $documento->numero_documento_modificado = $dataArray[11] ?? null;

                $documento->save();
                Log::info("Contenido del array: " . count($dataArray));
            }
        }
    }

    public function processXmlSRI(string $calve_Acceso){

        try{

            Log::error("procesando XML");
            $facturadorSRi = new Facturalo();
            $xml = $facturadorSRi->getXmlSoapSRI($calve_Acceso);
            
            $numeroComprobantes = intval($xml['RespuestaAutorizacionComprobante']['numeroComprobantes']);
            Log::error("comporbante recuperado: ".$numeroComprobantes);

            if($numeroComprobantes = 1){

                $estado = $xml['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['estado'];
                $comprobante = $xml['RespuestaAutorizacionComprobante']['autorizaciones']['autorizacion']['comprobante'];

                $xmlString = $comprobante;
                $xmlObject = simplexml_load_string($xmlString, "SimpleXMLElement", LIBXML_NOCDATA);
                $xmlDom = json_decode(json_encode($xmlObject), true);

                foreach ($xmlObject->xpath('//campoAdicional') as $campoAdicional) {
                    $nombre = (string) $campoAdicional['nombre'];
                    $valor = (string) $campoAdicional;
                    Log::info("Campo Adicional - Nombre: " . $nombre . " - Valor: " . $valor);
                }

                Log::error("Comprobante: " . count($xmlDom));

                foreach($xmlDom as $nodo){
                    if($nodo)
                    Log::info($nodo);
                }
            }

        }catch(Exception $ex){
            Log::error("Error al descargar el documento del SRI");
            Log::error($ex->getMessage());
        }
    }
}
