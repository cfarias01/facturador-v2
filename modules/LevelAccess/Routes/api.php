<?php
use Illuminate\Support\Facades\Route;
use Stancl\Tenancy\Middleware\InitializeTenancyByDomain;
use Stancl\Tenancy\Middleware\PreventAccessFromCentralDomains;

Route::middleware([InitializeTenancyByDomain::class, PreventAccessFromCentralDomains::class])->group(function () {

        Route::middleware(['auth:api', 'locked.tenant'])->group(function () {
            
            Route::get('user-permissions/{id}', 'Api\UserPermissionController@getWebUserPermissions');

        });

    });

