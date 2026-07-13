<?php

namespace App\Services;

use App\Models\Tenant\CabeceraDocumentoElectronica;
use App\Models\Tenant\Company;
use Exception;
use Illuminate\Support\Facades\Log;

class TelegramService
{
    protected $service;

    public function __construct()
    {
        $this->service = new IntegradorService();
    }

    /**
     * Envía un mensaje al bot de Telegram.
     *
     * @param string $chatId
     * @param string $texto
     * @param array $opciones - ej: ['parse_mode' => 'HTML']
     * @return array|null
     * @throws Exception
     */
    
    public function sendMessage(string $chatId, string $texto, array $opciones = []): ?array
    {
        $token = "7779181971:AAEEbeOceALbHiATDh2t4akKg7EuhhI3gJU" ;//config('services.telegram.bot_token') ?: env('TELEGRAM_BOT_TOKEN');
        if (empty($token)) {
            Log::error('TelegramService: token de bot no configurado en services.telegram.bot_token.');
            throw new Exception('Token de Telegram no configurado.');
        }

        $url = "https://api.telegram.org/bot{$token}/sendMessage";

        $payload = array_merge([
            'chat_id' => $chatId,
            'text' => $texto,
            'parse_mode' => 'HTML',
        ], $opciones);

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($payload));
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/x-www-form-urlencoded']);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        // Soporta entornos locales con certificado autofirmado
        $verifySsl = env('TELEGRAM_CURL_VERIFY_SSL', false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, $verifySsl ? 1 : 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, $verifySsl ? 2 : 0);

        $response = curl_exec($ch);
        $error = curl_error($ch);
        $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($response === false || $status !== 200) {
            $msg = "TelegramService: error al llamar API Telegram, status={$status}, error={$error}, response={$response}";
            Log::error($msg);
            throw new Exception($msg);
        }

        $decoded = json_decode($response, true);
        if (!is_array($decoded) || !($decoded['ok'] ?? false)) {
            $msg = "TelegramService: respuesta inválida de Telegram: {$response}";
            Log::error($msg);
            throw new Exception($msg);
        }

        return $decoded;
    }

    /**
     * Ejemplo: generar notificación basada en un Company y enviar a un chat.
     */

    private function formatAlertMessage(Company $company, array $documentos, string $tipo): string
    {
        $count = count($documentos);
        $header = "<b>🚨 ALERTA FACTURADOR 🚨 </b>\n";
        $header .= "<i>Canal: Notificaciones Facturador</i>\n";
        $header .= "<b>Empresa:</b> {$company->name}\n";
        $header .= "<b>Tipo:</b> {$tipo}\n";
        $header .= "<b>Documentos pendientes:</b> {$count}\n";
        $header .= "\n";

        $body = "";
        $maxRows = 15;
        $i = 0;
        foreach ($documentos as $doc) {
            if ($i++ >= $maxRows) {
                $body .= "... y " . ($count - $maxRows) . " más.\n";
                break;
            }
            $num = $doc['NUMSERIE'] ?? $doc['fecha'] ?? 'N/A';
            $id = $doc['NUMDOC'] ?? $doc['idInterno'] ?? 'N/A';
            $body .= "<b>#{$i} </b> <code>{$num}/{$id}</code>\n";
        }

        $footer = "\n";
        $footer .= "<b>🟠 Prioridad:</b> Alta\n";
        $footer .= "<b>📅 Fecha:</b> " . now()->format('Y-m-d H:i:s') . "\n";
        $footer .= "\n";

        return $header . $body . $footer;
    }

    public function sendNotificationToBot(Company $company, string $chatId): ?array
    {
        $documentos = $this->service->getResumenNoCargadosDiario($company);

        if (empty($documentos)) {
            Log::warning("TelegramService: No se pudo obtener resumen de documentos para company_id={$company->id}");
            return null;
        }

        $texto = $this->formatAlertMessage($company, $documentos, 'Documentos no cargados');

        try {
            return $this->sendMessage($chatId, $texto, ['parse_mode' => 'HTML', 'disable_web_page_preview' => true]);
        } catch (Exception $e) {
            Log::error("TelegramService: error al enviar mensaje a Telegram: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Enviar alerta directamente al canal configurado.
     */
    public function sendAlertToChannel(Company $company, array $documentos, string $tipo = 'Alerta'): ?array
    {
        $channel = env('TELEGRAM_CHANNEL_USERNAME', '@gsnotificaciones_bot');
        $texto = $this->formatAlertMessage($company, $documentos, $tipo);

        try {
            return $this->sendMessage($channel, $texto, ['parse_mode' => 'HTML', 'disable_web_page_preview' => true]);
        } catch (Exception $e) {
            Log::error("TelegramService: error al enviar alerta al canal: " . $e->getMessage());
            return null;
        }
    }


    public function sendNotificationToBot2(Company $company, string $chatId): ?array
    {
        $documentos = CabeceraDocumentoElectronica::whereIn('idEstado', ['30', '09'])->get()->toArray();

        if (empty($documentos)) {
            Log::warning("TelegramService: No se pudo obtener resumen de documentos para company_id={$company->id}");
            return null;
        }

        $texto = $this->formatAlertMessage($company, $documentos, 'Documentos DEVUELTOS');

        try {
            return $this->sendMessage($chatId, $texto, ['parse_mode' => 'HTML', 'disable_web_page_preview' => true]);
        } catch (Exception $e) {
            Log::error("TelegramService: error al enviar mensaje a Telegram: " . $e->getMessage());
            return null;
        }
    }

}
