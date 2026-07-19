<?php

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Stancl\Tenancy\Middleware\InitializeTenancyByDomain;
use Stancl\Tenancy\Middleware\PreventAccessFromCentralDomains;

/*
|--------------------------------------------------------------------------
| Tenant Routes
|--------------------------------------------------------------------------
|
| Antes vivian en routes/web.php, dentro de la rama
| `if (app(Hyn\Tenancy\Contracts\CurrentHostname::class)) { Route::domain($hostname->fqdn)->group(...) }`.
| Con stancl/tenancy la identificacion del tenant por dominio es dinamica via
| middleware (InitializeTenancyByDomain), no hace falta Route::domain() ni la
| resolucion eager de Hyn. Este archivo lo carga
| App\Providers\TenancyServiceProvider::mapRoutes().
|
*/

Route::middleware(['web', InitializeTenancyByDomain::class, PreventAccessFromCentralDomains::class])
    ->namespace('App\Http\Controllers')
    ->group(function () {

        Auth::routes([
            'register' => false,
            'verify'   => false
        ]);

        Route::get('search', 'Tenant\SearchController@index')->name('search.index');
        Route::get('buscar', 'Tenant\SearchController@index')->name('search.index');
        Route::get('search/tables', 'Tenant\SearchController@tables');
        Route::post('search', 'Tenant\SearchController@store');

        Route::get('downloads/{model}/{type}/{external_id}/{format?}', 'Tenant\DownloadController@downloadExternal')->name('tenant.download.external_id');
        Route::get('print/{model}/{external_id}/{format?}', 'Tenant\DownloadController@toPrint');
        Route::get('printticket/{model}/{external_id}/{format?}', 'Tenant\DownloadController@toTicket');
        Route::get('/exchange_rate/ecommence/{date}', 'Tenant\Api\ServiceController@exchangeRateTest');



        Route::middleware(['auth', 'redirect.module', 'locked.tenant'])->group(function () {
            // Route::get('catalogs', 'Tenant\CatalogController@index')->name('tenant.catalogs.index');
            Route::get('list-reports', 'Tenant\SettingController@listReports');
            Route::get('list-extras', 'Tenant\SettingController@listExtras');
            Route::get('list-settings', 'Tenant\SettingController@indexSettings')->name('tenant.general_configuration.index');
            Route::get('list-banks', 'Tenant\SettingController@listBanks');
            Route::get('list-bank-accounts', 'Tenant\SettingController@listAccountBanks');
            Route::get('list-currencies', 'Tenant\SettingController@listCurrencies');
            Route::get('list-cards', 'Tenant\SettingController@listCards');
            Route::get('list-platforms', 'Tenant\SettingController@listPlatforms');
            Route::get('list-attributes', 'Tenant\SettingController@listAttributes');
            Route::get('list-detractions', 'Tenant\SettingController@listDetractions');
            Route::get('list-units', 'Tenant\SettingController@listUnits');
            Route::get('list-payment-methods', 'Tenant\SettingController@listPaymentMethods');
            Route::get('list-incomes', 'Tenant\SettingController@listIncomes');
            Route::get('list-payments', 'Tenant\SettingController@listPayments');
            Route::get('list-vouchers-type', 'Tenant\SettingController@listVouchersType');
            Route::get('list-transfer-reason-types', 'Tenant\SettingController@listTransferReasonTypes');


            Route::get('tasks', 'Tenant\TaskController@index')->name('tenant.tasks.index')->middleware('redirect.level');
            Route::post('tasks/commands', 'Tenant\TaskController@listsCommand');
            Route::post('tasks/tables', 'Tenant\TaskController@tables');
            Route::post('tasks', 'Tenant\TaskController@store');
            Route::delete('tasks/{task}', 'Tenant\TaskController@destroy');

            //Orders

            //warehouse


            //Status Orders

            //Company
            Route::get('companies/create', 'Tenant\CompanyController@create')->name('tenant.companies.create')->middleware('redirect.level');
            Route::get('companies/tables', 'Tenant\CompanyController@tables');
            Route::get('companies/record', 'Tenant\CompanyController@record');
            Route::post('companies', 'Tenant\CompanyController@store');
            Route::post('companies/uploads', 'Tenant\CompanyController@uploadFile');

            //configuracion envio documento a pse
            Route::post('companies/store-send-pse', 'Tenant\CompanyController@storeSendPse');
            Route::get('companies/record-send-pse', 'Tenant\CompanyController@recordSendPse');

            //configuracion WhatsApp Api
            Route::post('companies/store-whatsapp-api', 'Tenant\CompanyController@storeWhatsAppApi');
            Route::get('companies/record-whatsapp-api', 'Tenant\CompanyController@recordWhatsAppApi');


            //Card Brands

            //Configurations
            Route::get('configurations/addSeeder', 'Tenant\ConfigurationController@addSeeder');
            Route::get('configurations/preprinted/addSeeder', 'Tenant\ConfigurationController@addPreprintedSeeder');
            Route::get('configurations/getFormats', 'Tenant\ConfigurationController@getFormats');
            Route::get('configurations/preprinted/getFormats', 'Tenant\ConfigurationController@getPreprintedFormats');
            Route::get('configurations/create', 'Tenant\ConfigurationController@create')->name('tenant.configurations.create');
            Route::get('configurations/record', 'Tenant\ConfigurationController@record');
            Route::post('configurations', 'Tenant\ConfigurationController@store');
            Route::post('configurations/apiruc', 'Tenant\ConfigurationController@storeApiRuc');
            Route::post('configurations/icbper', 'Tenant\ConfigurationController@icbper');
            Route::post('configurations/changeFormat', 'Tenant\ConfigurationController@changeFormat');
            Route::get('configurations/tables', 'Tenant\ConfigurationController@tables');
            Route::get('configurations/visual_defaults', 'Tenant\ConfigurationController@visualDefaults')->name('visual_defaults');
            Route::get('configurations/visual/get_menu', 'Tenant\ConfigurationController@visualGetMenu')->name('visual_get_menu');
            Route::post('configurations/visual/set_menu', 'Tenant\ConfigurationController@visualSetMenu')->name('visual_set_menu');
            Route::post('configurations/visual_settings', 'Tenant\ConfigurationController@visualSettings')->name('visual-settings');
            Route::post('configurations/visual/upload_skin', 'Tenant\ConfigurationController@visualUploadSkin')->name('visual_upload_skin');
            Route::post('configurations/visual/delete_skin', 'Tenant\ConfigurationController@visualDeleteSkin')->name('visual_delete_skin');
            Route::get('configurations/pdf_templates', 'Tenant\ConfigurationController@pdfTemplates')->name('tenant.advanced.pdf_templates');
            Route::get('configurations/pdf_guide_templates', 'Tenant\ConfigurationController@pdfGuideTemplates')->name('tenant.advanced.pdf_guide_templates');
            Route::get('configurations/pdf_preprinted_templates', 'Tenant\ConfigurationController@pdfPreprintedTemplates')->name('tenant.advanced.pdf_preprinted_templates');
            Route::post('configurations/uploads', 'Tenant\ConfigurationController@uploadFile');
            Route::post('configurations/preprinted/generateDispatch', 'Tenant\ConfigurationController@generateDispatch');
            Route::get('configurations/preprinted/{template}', 'Tenant\ConfigurationController@show');
            Route::get('configurations/change-mode', 'Tenant\ConfigurationController@changeMode')->name('settings.change_mode');

            Route::get('configurations/templates/ticket/refresh', 'Tenant\ConfigurationController@refreshTickets');
            Route::get('configurations/pdf_templates/ticket', 'Tenant\ConfigurationController@pdfTicketTemplates')->name('tenant.advanced.pdf_ticket_templates');
            Route::get('configurations/templates/ticket/records', 'Tenant\ConfigurationController@getTicketFormats');
            Route::post('configurations/templates/ticket/update', 'Tenant\ConfigurationController@changeTicketFormat');
            Route::get('configurations/apiruc', 'Tenant\ConfigurationController@apiruc');

            //Certificates
            Route::get('certificates/record', 'Tenant\CertificateController@record');
            Route::post('certificates/uploads', 'Tenant\CertificateController@uploadFile');
            Route::delete('certificates', 'Tenant\CertificateController@destroy');

            //Establishments

            //Bank Accounts

            //Series
            Route::get('series/records/{establishment}/{document_type?}', 'Tenant\SeriesController@records');
            Route::get('series/create', 'Tenant\SeriesController@create');
            Route::get('series/tables', 'Tenant\SeriesController@tables');
            Route::post('series', 'Tenant\SeriesController@store');
            Route::delete('series/{series}', 'Tenant\SeriesController@destroy');

            //Users
            Route::get('users', 'Tenant\UserController@index')->name('tenant.users.index');
            Route::get('users/create', 'Tenant\UserController@create')->name('tenant.users.create');
            Route::get('users/tables', 'Tenant\UserController@tables');
            Route::get('users/record/{user}', 'Tenant\UserController@record');
            Route::post('users', 'Tenant\UserController@store');
            Route::post('users/token/{user}', 'Tenant\UserController@regenerateToken');
            Route::get('users/records', 'Tenant\UserController@records');
            Route::delete('users/{user}', 'Tenant\UserController@destroy');

            //ChargeDiscounts

            //Items Ecommerce

            //Items

            //Persons
            Route::prefix('persons')->group(function () {
                /**
                 *persons/columns
                 *persons/tables
                 *persons/{type}
                 *persons/{type}/records
                 *persons/
                 *persons/{person}
                 *persons/import
                 *persons/enabled/{type}/{person}
                 *persons/{type}/exportation
                 */



            });
            //Documents
            Route::post('documents/categories', 'Tenant\DocumentController@storeCategories');
            Route::post('documents/brands', 'Tenant\DocumentController@storeBrands');
            Route::get('documents/search/customers', 'Tenant\DocumentController@searchCustomers');
            Route::get('documents/search/customer/{id}', 'Tenant\DocumentController@searchCustomerById');
            Route::get('documents/search/externalId/{external_id}', 'Tenant\DocumentController@searchExternalId');

            Route::get('documents', 'Tenant\DocumentController@index')->name('tenant.documents.index')->middleware(['redirect.level', 'tenant.internal.mode']);

            Route::get('documents/columns', 'Tenant\DocumentController@columns');
            Route::get('documents/records', 'Tenant\DocumentController@records');
            Route::get('documents/recordsTotal', 'Tenant\DocumentController@recordsTotal');
            Route::get('documents/create', 'Tenant\DocumentController@create')->name('tenant.documents.create')->middleware(['redirect.level', 'tenant.internal.mode']);
            Route::get('documents/create_tensu', 'Tenant\DocumentController@create_tensu')->name('tenant.documents.create_tensu');
            Route::get('documents/{id}/edit', 'Tenant\DocumentController@edit')->middleware(['redirect.level', 'tenant.internal.mode']);
            Route::get('documents/{id}/show', 'Tenant\DocumentController@show');

            Route::get('documents/tables', 'Tenant\DocumentController@tables');
            Route::get('documents/record/{document}', 'Tenant\DocumentController@record');
            Route::post('documents', 'Tenant\DocumentController@store');
            Route::post('documents/{id}/update', 'Tenant\DocumentController@update');
            Route::get('documents/send/{document}', 'Tenant\DocumentController@send');
            // Route::get('documents/remove/{document}', 'Tenant\DocumentController@remove');
            // Route::get('documents/consult_cdr/{document}', 'Tenant\DocumentController@consultCdr');
            Route::post('documents/email', 'Tenant\SriDocumentController@sendEmail');
            Route::get('documents/item/tables', 'Tenant\DocumentController@item_tables');
            Route::get('documents/table/{table}', 'Tenant\DocumentController@table');
            Route::get('documents/re_store/{document}', 'Tenant\DocumentController@reStore');
            Route::get('documents/locked_emission', 'Tenant\DocumentController@messageLockedEmission');

            Route::get('document_payments/records/{document_id}', 'Tenant\DocumentPaymentController@records');
            Route::get('document_payments/document/{document_id}', 'Tenant\DocumentPaymentController@document');
            Route::get('document_payments/tables', 'Tenant\DocumentPaymentController@tables');
            Route::post('document_payments', 'Tenant\DocumentPaymentController@store');
            Route::delete('document_payments/{document_payment}', 'Tenant\DocumentPaymentController@destroy');
            Route::get('document_payments/initialize_balance', 'Tenant\DocumentPaymentController@initialize_balance');
            Route::get('document_payments/report/{start}/{end}/{report}', 'Tenant\DocumentPaymentController@report');

            Route::get('documents/send_server/{document}/{query?}', 'Tenant\DocumentController@sendServer');
            Route::get('documents/check_server/{document}', 'Tenant\DocumentController@checkServer');
            Route::get('documents/change_to_registered_status/{document}', 'Tenant\DocumentController@changeToRegisteredStatus');

            Route::post('documents/import', 'Tenant\DocumentController@import');
            Route::post('documents/import_second_format', 'Tenant\DocumentController@importTwoFormat');
            Route::get('documents/data_table', 'Tenant\DocumentController@data_table');
            Route::get('documents/payments/excel/{month}/{anulled}', 'Tenant\DocumentController@report_payments')->name('tenant.document.payments.excel');
            Route::get('documents/payments-complete', 'Tenant\DocumentController@report_payments');

            Route::get('documents/excel', 'Tenant\DocumentController@excel');

            Route::post('documents/import_excel_format', 'Tenant\DocumentController@importExcelFormat');
            Route::get('documents/import_excel_tables', 'Tenant\DocumentController@importExcelTables');


            Route::delete('documents/delete_document/{document_id}', 'Tenant\DocumentController@destroyDocument');



            //agregado por Carlos Farias
            Route::get('documents/failed', 'Tenant\DocumentController@index_failed')->name('tenant.documents.failed.index');
            Route::get('documents/returned','Tenant\DocumentController@index_returned')->name('tenant.documents.returned.index');

            Route::post('purchases/received/import', 'Tenant\DocumentosRecibidosController@import');

            Route::post('purchases/received/records', 'Tenant\DocumentosRecibidosController@records_received');

            Route::get('purchases/received', 'Tenant\DocumentosRecibidosController@index_received')->name('tenant.documents_received.index');
            Route::get('purchases/received2', 'Tenant\DocumentosRecibidosController@index_received2')->name('tenant.documents_received.index2');
            Route::post('purchases/received2/records', 'Tenant\DocumentosRecibidosController@records_received2');

            Route::post(('documents/get_failed_documents'), 'Tenant\DocumentController@getDocumentsFailed');
            Route::post('documents/process_failed_documents', 'Tenant\DocumentController@processdoccumentsFailed');
            Route::post('documents/returned/records', 'Tenant\DocumentController@getdocumentsReturned');

            Route::get('documents/returned/resend/{idInterno}','Tenant\DocumentController@reSendDocument');
            Route::get('documents/returned/recreate/{idInterno}','Tenant\DocumentController@reCrateDocument');
            Route::get('documents/returned/recreate_all','Tenant\DocumentController@reCreateDocumentAll');

            Route::get('documents/data-table/items', 'Tenant\DocumentController@getDataTableItem');
            Route::get('documents/retention/{document}', 'Tenant\DocumentController@retention');
            Route::post('documents/retention', 'Tenant\DocumentController@retentionStore');
            Route::post('documents/retention/upload', 'Tenant\DocumentController@retentionUpload');

            //Contingencies

            //Summaries

            //Voided


            //Retentions
            Route::get('retentions', 'Tenant\RetentionController@index')->name('tenant.retentions.index');
            Route::get('retentions/columns', 'Tenant\RetentionController@columns');
            Route::get('retentions/records', 'Tenant\RetentionController@records');
            Route::get('retentions/create', 'Tenant\RetentionController@create')->name('tenant.retentions.create');
            Route::get('retentions/tables', 'Tenant\RetentionController@tables');
            Route::get('retentions/record/{retention}', 'Tenant\RetentionController@record');
            Route::post('retentions', 'Tenant\RetentionController@store');
            Route::delete('retentions/{retention}', 'Tenant\RetentionController@destroy');
            Route::get('retentions/document/tables', 'Tenant\RetentionController@document_tables');
            Route::get('retentions/table/{table}', 'Tenant\RetentionController@table');

            /** Dispatches
             * dispatches
             * dispatches/columns
             * dispatches/records
             * dispatches/create/{document?}/{type?}/{dispatch?}
             * dispatches/tables
             * dispatches
             * dispatches/record/{id}
             * dispatches/sendSunat/{document}
             * dispatches/email
             * dispatches/generate/{sale_note}
             * dispatches/record/{id}/tables
             * dispatches/record/{id}/set-document-id
             * dispatches/search/customers
             * dispatches/search/customer/{id}
             * dispatches/client/{id}
             * dispatches/items
             * dispatches/data_table
             * dispatches/search/customer/{id}
             */
            Route::prefix('dispatches')->group(function () {
            });



            // apiperu no usa estas rutas - revisar
            Route::get('services/ruc/{number}', 'Tenant\Api\ServiceController@ruc');
            Route::get('services/dni/{number}', 'Tenant\Api\ServiceController@dni');
            Route::post('services/exchange_rate', 'Tenant\Api\ServiceController@exchange_rate');
            Route::post('services/search_exchange_rate', 'Tenant\Api\ServiceController@searchExchangeRateByDate');
            Route::get('services/exchange_rate/{date}', 'Tenant\Api\ServiceController@exchangeRateTest');

            //Codes

            //Units

            //Transfer Reason Types

            //Detractions

            //Banks

            //Exchange Rates

            //Currency Types

            //Perceptions

            //Tribute Concept Type

            //purchases



            //quotations



            //sale-notes









            //POS


            //POS VENTA RAPIDA


            //Tags

            //Promotion



            //Cuenta
            Route::get('cuenta/payment_index', 'Tenant\AccountController@paymentIndex')->name('tenant.payment.index');
            Route::get('cuenta/configuration', 'Tenant\AccountController@index')->name('tenant.configuration.index');
            Route::get('cuenta/payment_records', 'Tenant\AccountController@paymentRecords');
            Route::get('cuenta/tables', 'Tenant\AccountController@tables');
            Route::post('cuenta/update_plan', 'Tenant\AccountController@updatePlan');
            Route::post('cuenta/payment_culqui', 'Tenant\AccountController@paymentCulqui')->name('tenant.account.payment_culqui');

            //Payment Methods

            //formats PDF
            Route::get('templates', 'Tenant\FormatTemplateController@records');
            // Configuración del Login
            Route::get('login-page', 'Tenant\LoginConfigurationController@index')->name('tenant.login_page')->middleware('redirect.level');
            Route::post('login-page/upload-bg-image', 'Tenant\LoginConfigurationController@uploadBgImage');
            Route::post('login-page/update', 'Tenant\LoginConfigurationController@update');



            //liquidacion de compra



            //Almacen de columnas por usuario
            Route::post('validate_columns','Tenant\SettingController@getColumnsToDatatable');

            Route::post('general-upload-temp-image', 'Controller@generalUploadTempImage');

            Route::get('general-get-current-warehouse', 'Controller@generalGetCurrentWarehouse');

            // test theme
            // Route::get('testtheme', function () {
            //     return view('tenant.layouts.partials.testtheme');
            // });

        });
    });
