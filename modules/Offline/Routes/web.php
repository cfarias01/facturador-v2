<?php

use Illuminate\Support\Facades\Route;

$hostname = app(Hyn\Tenancy\Contracts\CurrentHostname::class);

if ($hostname) {
    Route::domain($hostname->fqdn)->group(function () {
        Route::middleware(['auth', 'redirect.module', 'locked.tenant'])->group(function () {

            Route::prefix('offline-configurations')->group(function () {

                Route::get('', 'OfflineConfigurationController@index')->name('tenant.offline_configurations.index')->middleware('redirect.level');
                Route::post('', 'OfflineConfigurationController@store');
                Route::get('record', 'OfflineConfigurationController@record');
            });

        });
    });
}
