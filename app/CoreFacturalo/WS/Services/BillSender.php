<?php

namespace App\CoreFacturalo\WS\Services;
use Illuminate\Support\Facades\Log;
use nusoap_client;

/**
 * Class BillSender.
 */
class BillSender extends BaseSunat
{
    /**
     * @param string $filename
     * @param string $content agregar o quitar programas
     *
     * @return mixed
     */
    public function send($filename, $content)
    {
        //Log::info("url a enviar $filename");
        $response = null;
        //$servicio = "https://cel.sri.gob.ec/comprobantes-electronicos-ws/RecepcionComprobantesOffline?wsdl"; //url del servicio
        $client = new nusoap_client("$filename", 'wsdl');

        $client->soap_defencoding = 'utf-8';
        $client->decode_utf8 = false;
        $params = array();

        try {

            $params['xml'] = base64_encode($content);
            $response = $client->call("validarComprobante", $params, "http://ec.gob.sri.ws.recepcion");
            //Log::info('__getFunctions: '.json_encode($client->__getFunctions()));
            //Log::info('__getLastResponseHeaders: '.json_encode($client->getHeaders()));
            //Log::info('gettype: '.gettype($response));
            //Log::info($filename.($response));
            //Log::info("$filename: ".json_encode($response));
            //Log::info('response: '.$response['RespuestaRecepcionComprobante']['estado']);

            $cdrZip = $response;
            /*$result
                //->setCdrResponse($response)
                ->setSRIResponse($response)
                ->setCdrZip($cdrZip)
                ->setSuccess(true);*/

        } catch (\SoapFault $e) {

            Log::info('exception try to consult SRI: '.json_encode($e));
            return false;
        }
        //$fileObjeto = json_decode(json_encode($response, JSON_FORCE_OBJECT));
        return $response;
    }
}
