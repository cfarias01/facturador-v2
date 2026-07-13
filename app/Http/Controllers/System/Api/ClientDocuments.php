<?php

namespace App\Http\Controllers\System\Api;

use App\Http\Controllers\Controller;
use App\Models\System\Client;
use Hyn\Tenancy\Environment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ClientDocuments extends Controller
{
    //

    public function validarCliente(Request $request)
    {
        $cedula = $request->input('cedula');
        $cliente = \App\Models\System\ClientesFacturador::where('cedula', $cedula)->first();
        if ($cliente) {
            return response()->json([
                'status' => 'success',
                'message' => 'Cliente encontrado',
                'data' => $cliente
            ]);
        } else {
            return response()->json([
                'status' => 'error',
                'message' => 'Cliente no encontrado'
            ]);
        }
    }

    public function consultarDocumentos(Request $request)
    {
        $records = Client::all();
        $count_documents = [];
        $cedula = $request->input('cedula');

        foreach ($records as $row) {
            $tenancy = app(Environment::class);
            $tenancy->tenant($row->hostname->website);

            // Obtener todos los documentos del tenant donde ruc = $cedula
            $documentos = DB::connection('tenant')
                ->table('cabecera_documento_electronicas')
                ->where('ruc', $cedula)
                ->get();

            // Obtener la URL base del tenant
            $tenantBaseUrl = $row->hostname->fqdn ? 'http://' . $row->hostname->fqdn : url('/');

            foreach ($documentos as $documento) {
                $count_documents[] = [
                    'cliente' => $cedula,
                    //'document' => $documento,
                    'comprobante' => $documento->idComporbante,
                    'valor' => $documento->importeTotal,
                    'fecha' => $documento->fecha,
                    'clave_acceso' => $documento->claveAcceso,
                    'pdf_url' => "{$tenantBaseUrl}/index.php/downloads/cabeceraDocumentoElectronica/pdf/{$documento->claveAcceso}",
                    'xml_url' => "{$tenantBaseUrl}/index.php/downloads/cabeceraDocumentoElectronica/xml/{$documento->claveAcceso}",
                ];
            }
        }

        return response()->json([
            'status' => 'success',
            'data' => $count_documents
        ]);
    }

    public function getToken(){
        $token = \Illuminate\Support\Facades\Cache::get('token');
        if (!$token) {
            $token = \App\Models\System\Token::first();
            if ($token) {
                \Illuminate\Support\Facades\Cache::put('token', $token->access_token, 3600);
            } else {
                return response()->json(['error' => 'Token not found'], 404);
            }
        }

        return response()->json(['token' => $token]);
    }
}
