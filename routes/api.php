<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes (dominio central / System)
|--------------------------------------------------------------------------
|
| Las rutas de API del tenant viven ahora en routes/tenant_api.php, cargadas
| dinamicamente por App\Providers\TenancyServiceProvider cuando el dominio de
| la request resuelve a un tenant (ver InitializeTenancyByDomain).
|
*/

Route::domain(rtrim((string) env('APP_URL_BASE'), '/'))->group(function () {

    Route::middleware(['auth:system_api'])->group(function () {
        //reseller
        Route::post('reseller/detail', 'System\Api\ResellerController@resellerDetail');
        // Route::post('reseller/lockedAdmin', 'System\Api\ResellerController@lockedAdmin');
        // Route::post('reseller/lockedTenant', 'System\Api\ResellerController@lockedTenant');

        Route::get('restaurant/partner/list', 'System\Api\RestaurantPartnerController@list');
        Route::post('restaurant/partner/store', 'System\Api\RestaurantPartnerController@store');
        Route::post('restaurant/partner/search', 'System\Api\RestaurantPartnerController@search');
    });

    // Limit to 10 requests per minute to prevent abuse of client validation and document endpoints.

    Route::middleware(['throttle:100,1'])->group(function () {
        Route::post('client/validate', 'System\Api\ClientDocuments@validarCliente');
        Route::post('client/documents', 'System\Api\ClientDocuments@consultarDocumentos');
    });

});
