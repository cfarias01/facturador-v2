<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes (dominio central / System)
|--------------------------------------------------------------------------
|
| Las rutas del tenant viven ahora en routes/tenant.php, cargadas
| dinamicamente por App\Providers\TenancyServiceProvider cuando el dominio de
| la request resuelve a un tenant (ver InitializeTenancyByDomain).
|
*/

$prefix = config('tenant.prefix_url');
$prefix = !empty($prefix) ? $prefix . "." : '';
$app_url = $prefix . config('tenant.app_url_base');

Route::domain($app_url)->group(function () {

    Route::get('login', 'System\LoginController@showLoginForm')->name('system.login');
    Route::post('login', 'System\LoginController@login');
    Route::post('logout', 'System\LoginController@logout')->name('system.logout');

    Route::get('phone', 'System\UserController@getPhone');

    Route::middleware('auth:admin')->group(function () {
        Route::get('logs', '\Rap2hpoutre\LaravelLogViewer\LogViewerController@index');
        Route::get('/', function () {
            return redirect()->route('system.dashboard');
        });
        Route::get('dashboard', 'System\HomeController@index')->name('system.dashboard');

        // En routes/web.php
        Route::get('/test-session', function () {
            return response()->json([
                'session_id' => session()->getId(),
                'user' => auth()->user(),
                'all_session' => session()->all()
            ]);
        });

        //Clients
        Route::get('clients', 'System\ClientController@index')->name('system.clients.index');
        Route::get('clients/records', 'System\ClientController@records');
        Route::get('clients/record/{client}', 'System\ClientController@record');

        Route::get('clients/create', 'System\ClientController@create');
        Route::get('clients/tables', 'System\ClientController@tables');
        Route::get('clients/charts', 'System\ClientController@charts');
        Route::post('clients', 'System\ClientController@store');
        Route::post('clients/update', 'System\ClientController@update');

        Route::delete('clients/{client}/{input_validate}', 'System\ClientController@destroy');
        // Route::delete('clients/{client}', 'System\ClientController@destroy');

        Route::post('clients/password/{client}', 'System\ClientController@password');
        Route::post('clients/locked_emission', 'System\ClientController@lockedEmission');
        Route::post('clients/locked_tenant', 'System\ClientController@lockedTenant');
        // Route::post('clients/locked_tenant', 'System\ClientController@lockedTenant'); //Linea repetida

        Route::post('clients/locked_user', 'System\ClientController@lockedUser');
        Route::post('clients/renew_plan', 'System\ClientController@renewPlan');

        Route::post('clients/set_billing_cycle', 'System\ClientController@startBillingCycle');


        Route::post('clients/upload', 'System\ClientController@upload');

        Route::get('client_payments/records/{client_id}', 'System\ClientPaymentController@records');
        Route::get('client_payments/client/{client_id}', 'System\ClientPaymentController@client');
        Route::get('client_payments/tables', 'System\ClientPaymentController@tables');
        Route::post('client_payments', 'System\ClientPaymentController@store');
        Route::delete('client_payments/{client_payment}', 'System\ClientPaymentController@destroy');
        Route::get('client_payments/cancel_payment/{client_payment_id}', 'System\ClientPaymentController@cancel_payment');

        Route::get('client_account_status/records/{client_id}', 'System\AccountStatusController@records');
        Route::get('client_account_status/client/{client_id}', 'System\AccountStatusController@client');
        Route::get('client_account_status/tables', 'System\AccountStatusController@tables');

        //Planes
        Route::get('plans', 'System\PlanController@index')->name('system.plans.index');
        Route::get('plans/records', 'System\PlanController@records');
        Route::get('plans/tables', 'System\PlanController@tables');
        Route::get('plans/record/{plan}', 'System\PlanController@record');
        Route::post('plans', 'System\PlanController@store');
        Route::delete('plans/{plan}', 'System\PlanController@destroy');

        //Users
        Route::get('users/create', 'System\UserController@create')->name('system.users.create');
        Route::get('users/record', 'System\UserController@record');
        Route::post('users', 'System\UserController@store');

        Route::get('services/ruc/{number}', 'System\ServiceController@ruc');

        Route::get('certificates/record', 'System\CertificateController@record');
        Route::post('certificates/uploads', 'System\CertificateController@uploadFile');
        Route::post('certificates/saveSoapUser', 'System\CertificateController@saveSoapUser');
        Route::delete('certificates', 'System\CertificateController@destroy');
        Route::get('configurations', 'System\ConfigurationController@index')->name('system.configuration.index');
        Route::post('configurations/login', 'System\ConfigurationController@storeLoginSettings');
        Route::post('configurations/bg', 'System\ConfigurationController@storeBgLogin');
        Route::post('configurations/other-configuration', 'System\ConfigurationController@storeOtherConfiguration');

        Route::get('companies/record', 'System\CompanyController@record');
        Route::post('companies', 'System\CompanyController@store');

        // auto-update
        Route::get('auto-update', 'System\UpdateController@index')->name('system.update');
        Route::get('auto-update/branch', 'System\UpdateController@branch')->name('system.update.branch');
        Route::get('auto-update/pull/{branch}', 'System\UpdateController@pull')->name('system.update.pull');
        Route::get('auto-update/artisan/migrate', 'System\UpdateController@artisanMigrate')->name('system.update.artisan.migrate');
        Route::get('auto-update/artisan/migrate/tenant', 'System\UpdateController@artisanTenancyMigrate')->name('system.update.artisan.tenancy.migrate');
        Route::get('auto-update/artisan/clear', 'System\UpdateController@artisanClear')->name('system.update.artisan.clear');
        Route::get('auto-update/composer/install', 'System\UpdateController@composerInstall')->name('system.update.composer.install');
        Route::get('auto-update/keygen', 'System\UpdateController@keygen')->name('system.update.keygen');
        Route::get('auto-update/version', 'System\UpdateController@version')->name('system.update.version');
        Route::get('auto-update/changelog', 'System\UpdateController@changelog')->name('system.changelog');

        //Configuration

        Route::post('configurations', 'System\ConfigurationController@store');
        Route::get('configurations/record', 'System\ConfigurationController@record');
        Route::get('information', 'System\ConfigurationController@InfoIndex')->name('system.information');
        Route::get('status/history', 'System\StatusController@history')->name('system.status');
        Route::get('status/memory', 'System\StatusController@memory')->name('system.status.memory');
        Route::get('status/cpu', 'System\StatusController@cpu')->name('system.status.cpu');
        Route::get('configurations/apiruc', 'System\ConfigurationController@apiruc');
        Route::get('configurations/apkurl', 'System\ConfigurationController@apkurl');

        Route::get('configurations/update-tenant-discount-type-base', 'System\ConfigurationController@updateTenantDiscountTypeBase');

        // backup
        Route::get('backup', 'System\BackupController@index')->name('system.backup');
        Route::post('backup/db', 'System\BackupController@db')->name('system.backup.db');
        Route::post('backup/files', 'System\BackupController@files')->name('system.backup.files');
        Route::post('backup/upload', 'System\BackupController@upload')->name('system.backup.upload');

        Route::get('backup/last-backup', 'System\BackupController@mostRecent');
        Route::get('backup/download/{filename}', 'System\BackupController@download');

    });
});
