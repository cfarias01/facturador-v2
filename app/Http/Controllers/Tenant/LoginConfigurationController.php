<?php

namespace App\Http\Controllers\Tenant;

use App\Http\Controllers\Controller;
use App\Models\Tenant\Configuration;
use Exception;
use Illuminate\Support\Facades\Log;
use Modules\Finance\Helpers\UploadFileHelper;


class LoginConfigurationController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        $config = Configuration::first();

        return view('tenant.login_page.index', compact('user', 'config'));
    }

    public function uploadBgImage()
    {
        request()->validate([
            'image' => 'required|mimes:jpeg,png,jpg,gif,svg|max:2048'
        ]);

        $config = Configuration::first();
        if (request()->hasFile('image') && request()->file('image')->isValid()) {
            $file = request()->file('image');
            $ext = $file->getClientOriginalExtension();
            $name = time() . '.' . $ext;

            $path = 'public/uploads/login';

            Log::info($name . ' - '.$file->getPathName());
            Log::info(mime_content_type($file->getPathName()));

            UploadFileHelper::checkIfValidFile($name, $file->getPathName(), true);

            Log::info($path .' - '.$name );
            try{

                $file->storeAs($path, $name);

            }catch(Exception $ex){

                Log::info("error en uploadBgImage: ".$ex->getMessage());
            }
            
            $loginConfig = $config->login;
            $loginConfig->type = 'image';
            $loginConfig->image = asset('storage/uploads/login/' . $name);
            $config->login = $loginConfig;
            $config->save();
        }

        return response()->json([
            'success' => true,
            'message' => 'Información actualizada.',
        ], 200);
    }

    public function update()
    {
        request()->validate([
            'position_form' => 'required|in:left,right',
            'show_logo_in_form' => 'boolean',
            'position_logo' => 'required|in:top-left,top-right,bottom-left,bottom-right',
            'show_socials' => 'boolean',
            'facebook' => 'max:200',
            'twitter' => 'max:200',
            'instagram' => 'max:200',
            'linkedin' => 'max:200',
        ]);

        $config = Configuration::first();
        $loginConfig = $config->login;
        foreach(request()->all() as $key => $option) {
            $loginConfig->$key = $option;
        }
        $config->login = $loginConfig;
        $config->save();

        return response()->json([
            'success' => true,
            'message' => 'Información actualizada.',
        ], 200);
    }
}
