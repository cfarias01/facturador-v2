<?php

use Illuminate\Support\Facades\Route;
use Stancl\Tenancy\Middleware\InitializeTenancyByDomain;
use Stancl\Tenancy\Middleware\PreventAccessFromCentralDomains;

Route::middleware([InitializeTenancyByDomain::class, PreventAccessFromCentralDomains::class])->group(function () {
        Route::middleware(['auth', 'redirect.module', 'locked.tenant'])->group(function () {

            Route::prefix('offline-configurations')->group(function () {

                Route::get('', 'OfflineConfigurationController@index')->name('tenant.offline_configurations.index')->middleware('redirect.level');
                Route::post('', 'OfflineConfigurationController@store');
                Route::get('record', 'OfflineConfigurationController@record');
            });

        });
    });
