<?php

namespace App\Services;

use App\Models\Tenant\sriQuery;
use GuzzleHttp\Client;
use Illuminate\Support\Facades\Log;


class ContaboService
{
    public function SendRequest(sriQuery $query, string $url)
    {
        try{
            $client = new Client();
            $res = $client->request('POST', $url.'/', ["form_params" => json_decode(json_encode($query), true)]);
            Log::info("ESTADO CONSULTA".$res->getStatusCode());
            return  $res;

        }catch(Exception $e){

            Log::error("ERROR AL CONSUMIR API $e->getMessage()");
            return false;
        }

    }

}
