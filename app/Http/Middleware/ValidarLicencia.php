<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;

class ValidarLicencia
{
    public function handle(Request $request, Closure $next)
    {
        $licenseKey = config('app.license');

        try {
            $client = new Client(['timeout' => 10]);
            $response = $client->request('GET', 'https://raw.githubusercontent.com/CFarias95/licencias/refs/heads/main/licencias.json');

            $data = json_decode($response->getBody(), true);

            if (!isset($data[$licenseKey]) || $data[$licenseKey] !== 'activo') {
                Log::warning("Licencia inválida o inactiva: {$licenseKey}");
                return response()->view('errors.403');
            }

        } catch (RequestException $e) {
            Log::error('Error al verificar la licencia: ' . $e->getMessage());
            return response()->view('errors.403');
        }

        return $next($request);
    }
}