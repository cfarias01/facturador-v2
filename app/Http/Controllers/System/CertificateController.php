<?php
namespace App\Http\Controllers\System;

use App\Http\Controllers\Controller;
use Exception;
use Illuminate\Http\Request;
use App\Models\System\Configuration;
use Illuminate\Support\Facades\Log;

class CertificateController extends Controller
{
    public function record()
    {

        $configuration = Configuration::first();

        return [
            'certificate' => $configuration->certificate,
            'soap_username' => $configuration->soap_username,
            'soap_password' => $configuration->soap_password,
        ];
    }

    public function uploadFile(Request $request)
    {
        if ($request->hasFile('file')) {
            try {
                //$company = Company::active();
                $configuration = Configuration::first();
                $password = $request->input('password');
                $file = $request->file('file');
                $pfx = file_get_contents($file);
                //Log::error('pfx', $pfx);
                //$pem = GenerateCertificate::typePEM($pfx, $password);
                //$name = 'certificate_'.'admin_master'.'.pem';
                $name = 'certificate_'.'admin_master'.'.p12';
                if(!file_exists(storage_path('app'.DIRECTORY_SEPARATOR.'certificates'))) {
                    mkdir(storage_path('app'.DIRECTORY_SEPARATOR.'certificates'));
                }
                file_put_contents(storage_path('app'.DIRECTORY_SEPARATOR.'certificates'.DIRECTORY_SEPARATOR.$name), $pfx);
                $configuration->certificate = $name;
                $configuration->certificate_pass = $password;
                $configuration->save();

                return [
                    'success' => true,
                    'message' =>  __('app.actions.upload.success'),
                ];
            } catch (Exception $e) {
                return [
                    'success' => false,
                    'message' =>  $e->getMessage()
                ];
            }
        }
        return [
            'success' => false,
            'message' =>  __('app.actions.upload.error'),
        ];
    }

    public function destroy()
    {
        $company = Configuration::first();
        $company->certificate = null;
        $company->save();

        return [
            'success' => true,
            'message' => 'Certificado eliminado con éxito'
        ];
    }

    public function saveSoapUser(Request $request)
    {
        $configuration = Configuration::first();
        $configuration->soap_username = $request->soap_username;
        $configuration->soap_password = $request->soap_password;
        $configuration->save();

        return [
            'success' => true,
            'message' => 'Cambios guardados.'
        ];


    }
}
