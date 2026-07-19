<?php

declare(strict_types=1);

use App\Models\System\Domain;
use App\Models\System\Tenant;

return [
    'tenant_model' => Tenant::class,
    'id_generator' => Stancl\Tenancy\UUIDGenerator::class,

    'domain_model' => Domain::class,

    /**
     * The list of domains hosting the central (System) app.
     *
     * Reemplaza al branching manual con Hyn\Tenancy\Contracts\CurrentHostname que
     * existia antes en routes/web.php y routes/api.php.
     */
    'central_domains' => array_values(array_filter([
        rtrim((string) env('APP_URL_BASE', ''), '/'),
        'localhost',
        '127.0.0.1',
    ])),

    /**
     * Solo se tenant-scopea la base de datos, igual que hacia hyn/multi-tenant
     * (que no usaba cache/filesystem/queue tenancy). No se agregan bootstrappers
     * nuevos para no introducir comportamiento que no existia antes.
     */
    'bootstrappers' => [
        Stancl\Tenancy\Bootstrappers\DatabaseTenancyBootstrapper::class,
    ],

    'database' => [
        // Conexion central existente en config/database.php (antes 'system' con hyn).
        'central_connection' => env('DB_CONNECTION', 'system'),

        'template_tenant_connection' => null,

        /**
         * Los nombres de BD de tenant se arman igual que antes con hyn:
         * prefix (config/tenant.php: prefix_database, default 'tenancy') + '_' + id.
         * Ej: id 'carlos' -> 'tenancy_carlos'.
         */
        'prefix' => env('PREFIX_DATABASE', 'tenancy') . '_',
        'suffix' => '',

        'managers' => [
            'mysql' => Stancl\Tenancy\TenantDatabaseManagers\MySQLDatabaseManager::class,
            'mariadb' => Stancl\Tenancy\TenantDatabaseManagers\MySQLDatabaseManager::class,
        ],
    ],

    /**
     * Features es intencionalmente vacio: no se habilita nada que hyn/multi-tenant
     * no tuviera (impersonation, telescope, universal routes, etc.).
     */
    'features' => [],

    /**
     * Rutas propias del paquete (tenant asset routes). No se usaban con hyn.
     */
    'routes' => false,

    'migration_parameters' => [
        '--force' => true,
        '--path' => [database_path('migrations/tenant')],
        '--realpath' => true,
    ],

    'seeder_parameters' => [
        '--class' => 'TenancyDatabaseSeeder',
    ],
];
