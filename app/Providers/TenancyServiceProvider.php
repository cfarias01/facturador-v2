<?php

namespace App\Providers;

use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\ServiceProvider;
use Stancl\JobPipeline\JobPipeline;
use Stancl\Tenancy\Events;
use Stancl\Tenancy\Jobs;
use Stancl\Tenancy\Listeners;
use Stancl\Tenancy\Middleware;

class TenancyServiceProvider extends ServiceProvider
{
    public static string $controllerNamespace = '';

    public function events()
    {
        return [
            // Tenant events
            Events\CreatingTenant::class => [],
            Events\TenantCreated::class => [
                // Reemplaza el auto-create-tenant-database + auto-migrate de hyn/multi-tenant.
                // El seed de datos base (company, configuration, series, etc.) sigue
                // haciendose a mano en System\ClientController::store(), igual que antes,
                // no como un Seeder de esta pipeline.
                JobPipeline::make([
                    Jobs\CreateDatabase::class,
                    Jobs\MigrateDatabase::class,
                ])->send(function (Events\TenantCreated $event) {
                    return $event->tenant;
                })->shouldBeQueued(false),
            ],
            Events\SavingTenant::class => [],
            Events\TenantSaved::class => [],
            Events\UpdatingTenant::class => [],
            Events\TenantUpdated::class => [],
            Events\DeletingTenant::class => [],
            // TenantDeleted NO dispara el borrado fisico de la BD automaticamente aqui:
            // eso queda condicionado a TENANCY_DATABASE_AUTO_DELETE, igual que con hyn,
            // y se maneja explicitamente en System\ClientController::destroy().
            Events\TenantDeleted::class => [],

            // Domain events
            Events\CreatingDomain::class => [],
            Events\DomainCreated::class => [],
            Events\SavingDomain::class => [],
            Events\DomainSaved::class => [],
            Events\UpdatingDomain::class => [],
            Events\DomainUpdated::class => [],
            Events\DeletingDomain::class => [],
            Events\DomainDeleted::class => [],

            // Database events
            Events\DatabaseCreated::class => [],
            Events\DatabaseMigrated::class => [],
            Events\DatabaseSeeded::class => [],
            Events\DatabaseRolledBack::class => [],
            Events\DatabaseDeleted::class => [],

            // Tenancy events
            Events\InitializingTenancy::class => [],
            Events\TenancyInitialized::class => [
                Listeners\BootstrapTenancy::class,
                [$this, 'bootstrapTenantFilesystem'],
            ],

            Events\EndingTenancy::class => [],
            Events\TenancyEnded::class => [
                Listeners\RevertToCentralContext::class,
                [$this, 'revertTenantFilesystem'],
            ],

            Events\BootstrappingTenancy::class => [],
            Events\TenancyBootstrapped::class => [],
            Events\RevertingToCentralContext::class => [],
            Events\RevertedToCentralContext::class => [],
        ];
    }

    public function register()
    {
        //
    }

    public function boot()
    {
        $this->bootEvents();
        $this->mapRoutes();

        $this->makeTenancyMiddlewareHighestPriority();
    }

    protected function bootEvents()
    {
        foreach ($this->events() as $event => $listeners) {
            foreach ($listeners as $listener) {
                if ($listener instanceof JobPipeline) {
                    $listener = $listener->toListener();
                }

                Event::listen($event, $listener);
            }
        }
    }

    /**
     * Antes hyn/multi-tenant registraba automaticamente un disco 'tenant' por
     * cliente; stancl/tenancy no lo hace (solo se activo el bootstrapper de
     * base de datos). Sin esto, Storage::disk('tenant') (usado por
     * StorageDocument y todo el guardado de XML/PDF) no tiene driver
     * configurado. La raiz sigue la misma convencion que ya usa
     * BackupFiles.php: storage/app/tenancy/tenants/{tenant_id}.
     */
    public function bootstrapTenantFilesystem(Events\TenancyInitialized $event)
    {
        $this->app['config']->set('filesystems.disks.tenant', [
            'driver' => 'local',
            'root' => storage_path('app/tenancy/tenants/' . $event->tenancy->tenant->getTenantKey()),
        ]);

        $this->app['filesystem']->forgetDisk('tenant');
    }

    public function revertTenantFilesystem()
    {
        $this->app['config']->set('filesystems.disks.tenant', null);
        $this->app['filesystem']->forgetDisk('tenant');
    }

    protected function mapRoutes()
    {
        $this->app->booted(function () {
            if (file_exists(base_path('routes/tenant.php'))) {
                Route::namespace(static::$controllerNamespace)
                    ->group(base_path('routes/tenant.php'));
            }
            if (file_exists(base_path('routes/tenant_api.php'))) {
                Route::namespace(static::$controllerNamespace)
                    ->group(base_path('routes/tenant_api.php'));
            }

            // Estas rutas se cargan despues del arranque normal del router (via
            // app()->booted()), momento en el que Laravel ya construyo su tabla
            // de busqueda por nombre para web.php/api.php. Sin este refresh, los
            // nombres de ruta definidos aqui (incluido los de Auth::routes())
            // quedan invisibles para route()/has(), aunque el matching por URL
            // entrante funcione con normalidad.
            Route::getRoutes()->refreshNameLookups();
        });
    }

    protected function makeTenancyMiddlewareHighestPriority()
    {
        $tenancyMiddleware = [
            Middleware\PreventAccessFromCentralDomains::class,
            Middleware\InitializeTenancyByDomain::class,
        ];

        foreach (array_reverse($tenancyMiddleware) as $middleware) {
            $this->app[\Illuminate\Contracts\Http\Kernel::class]->prependToMiddlewarePriority($middleware);
        }
    }
}
