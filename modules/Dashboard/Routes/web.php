<?php
use Illuminate\Support\Facades\Route;
use Stancl\Tenancy\Middleware\InitializeTenancyByDomain;
use Stancl\Tenancy\Middleware\PreventAccessFromCentralDomains;

Route::middleware([InitializeTenancyByDomain::class, PreventAccessFromCentralDomains::class])->group(function () {
        Route::middleware(['auth', 'locked.tenant'])->group(function () {

            Route::redirect('/', '/dashboard');

            Route::prefix('dashboard')->group(function () {
                Route::get('/', 'DashboardController@index')->name('tenant.dashboard.index');
                Route::get('filter', 'DashboardController@filter');
                Route::post('data', 'DashboardController@data');
                Route::post('data_aditional', 'DashboardController@data_aditional');
                // Route::post('unpaid', 'DashboardController@unpaid');
                // Route::get('unpaidall', 'DashboardController@unpaidall')->name('unpaidall');
                Route::get('stock-by-product/records', 'DashboardController@stockByProduct');
                Route::get('product-of-due/records', 'DashboardController@productOfDue');
                Route::post('utilities', 'DashboardController@utilities');
                Route::get('global-data', 'DashboardController@globalData');
                Route::get('sales-by-product', 'DashboardController@salesByProduct');
            });

            //Commands
            Route::get('command/df', 'DashboardController@df')->name('command.df');

        });
    });
