<?php
namespace App\CoreFacturalo\SRI;

use Exception;
use Illuminate\Support\Facades\Log;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of firmar
 *
 * @author UESR
 */
class FirmarSri {
    //put your code here

    public function Firma_SRI($clave, $ruta_firma, $contrasena, $content){

        $config = array(
            'file' => $ruta_firma,
            'pass' => $contrasena
        );

        $firma = new Firma($config, $clave);

        $resp = $firma->verificarCertPKey();

        if ($resp["error"] === true)
            return $resp;


        $resp = $firma->firmar($content);

        return $resp;

    }

    private function getDocXml($content)
    {
        try{
            $doc = new \DOMDocument();
            $doc->loadXML($content);

            return $doc;
        }catch(Exception $ex){

            Log::error($ex->getMessage());
            return false;
        }

    }

}
