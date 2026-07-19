# Migración: Laravel 9 → 13, PHP 8.4, reemplazo de tenancy

Este documento vive en el repo (a diferencia del plan efímero de la sesión de Claude) para que
cualquier persona o sesión futura retome el trabajo sin perder contexto. Rama de trabajo:
`upgrade/laravel-13-php84`.

## Por qué

- Laravel 9.52 está fuera de soporte de seguridad.
- El objetivo es Laravel 13 (última versión estable) + PHP 8.4.
- PHP 8.4 solo es soportado sólidamente desde Laravel 11 en adelante, así que el salto de PHP y
  el salto de framework van de la mano.
- El obstáculo central es `hyn/multi-tenant` (abandonado, no soporta más allá de Laravel 8/9).
  Se reemplaza por `stancl/tenancy` (soporta Laravel 10–13).
- **No hay suite de tests automatizados real** (solo scaffolding). La verificación de cada fase
  es manual, contra el [checklist de QA](./qa-checklist.md), en base de datos de prueba —
  nunca contra producción.

## Fases

- [x] **Fase 0 — Red de seguridad y limpieza previa** (Laravel 9, PHP 8.1, bajo riesgo)
  - [x] Rama `upgrade/laravel-13-php84` creada desde `main`.
  - [x] `composer install` baseline funcional con PHP 8.1.10.
  - [x] Checklist de QA manual escrito (`qa-checklist.md`).
  - [x] Limpieza de dependencias muertas: se quitaron `fabpot/goutte` y
        `picqer/php-barcode-generator` (sin ningún uso en `app/`/`modules/`).
        **Importante**: `mpdf/mpdf`, `orchestra/parser` y `econea/nusoap` se investigaron y
        están en uso activo (motor PDF de `Facturalo.php`, parseo del CDR de SUNAT en
        `SriDocumentController.php`, y clientes SOAP en `BillSender.php`/`AuthSri.php`
        respectivamente) — **no se tocan**.
  - [x] Ruta `logs` (`rap2hpoutre/laravel-log-viewer`) verificada: ya está protegida por
        `auth:admin` en `routes/web.php:728`. No requirió corrección.
- [x] **Fase 1 — Salto Laravel 9 → 10**
  - [x] `laravel/framework` ^10.0, `laravel/ui` ^4.0, `barryvdh/laravel-dompdf` ^2.0.
  - [x] `hyn/multi-tenant` **sigue funcionando sin cambios** en Laravel 10 (declara soporte
        `^9.0|^10.0` — no fue necesario combinar esta fase con la Fase 2).
  - [x] Se adelantaron 2 items de la Fase 4 porque bloqueaban el salto: se quitó
        `binarytorch/larecipe`+`graham-campbell/markdown` (no soportan L10; el único uso real
        era el link "Wiki" del módulo Digemid, que queda roto hasta reemplazar esa fuente de
        docs, y el changelog de `UpdateController` que ahora usa `league/commonmark` directo)
        y `fruitcake/laravel-cors` (redundante desde Laravel 9; `Kernel.php` usa ahora
        `Illuminate\Http\Middleware\HandleCors` nativo con el mismo `config/cors.php`).
  - [x] `database/seeds` → `database/seeders` (convención Laravel 8+).
  - [x] Verificado: boot OK (Laravel 10.50.2), `route:list` resuelve 99 rutas sin errores.
  - [ ] **Pendiente, no bloqueante**: `Swift_SmtpTransport`/`Swift_Mailer`/
        `Swift_RfcComplianceException` siguen usados directamente (sin pasar por el Mail
        facade de Laravel) en `Tenant\DocumentController.php` y `Tenant\EmailController.php`/
        `SriDocumentController.php`. Sigue funcionando porque `swiftmailer/swiftmailer` sigue
        instalado, pero es codigo legacy a migrar a Symfony Mailer en la Fase 4.
- [x] **Fase 2 — Reemplazo de `hyn/multi-tenant` por `stancl/tenancy`** (mayor riesgo — completa)
  - Confirmado empíricamente (`composer require laravel/framework:^11.0 --dry-run`):
    `hyn/multi-tenant` 5.9.1 declara `require laravel/framework ^9.0|^10.0` y bloquea duro en
    Laravel 11. Por eso esta fase pasó a ser obligatoria antes de seguir subiendo versión.
  - Confirmado empíricamente (Fase 0): no existía ninguna carpeta `tenancy/<uuid>/` en
    `storage/` ni en el repo, y `config/tenancy.php` tenía `'disk' => null` — nadie usaba la
    personalización de vistas/rutas/traducciones por tenant de Hyn. Se descartó esa función
    sin reemplazo.
  - `config/tenancy.php` reescrito para stancl (central_connection='system', prefix de BD
    tomado de `PREFIX_DATABASE`, solo `DatabaseTenancyBootstrapper`). `App\Models\System\Tenant`
    y `App\Models\System\Domain` (con accessors de compat `uuid`/`fqdn`/`hostnames` para no
    tocar cada lectura antigua). `App\Providers\TenancyServiceProvider` (wiring de eventos:
    `TenantCreated` → crea+migra la BD sincrono, igual que el auto-create+auto-migrate de hyn).
  - `App\Traits\UsesTenantConnection`/`UsesSystemConnection` reemplazan a los traits de Hyn en
    ~64 modelos. `App\Support\Tenancy\Environment` es un shim de compatibilidad con la API de
    `Hyn\Tenancy\Environment::tenant()` para minimizar el diff en ~16 controllers/comandos/jobs
    que cambiaban de tenant activo.
  - `routes/web.php`/`routes/api.php` (y los 8 módulos) separados en versión central y
    `routes/tenant.php`/`routes/tenant_api.php` (tenant, vía `InitializeTenancyByDomain` +
    `PreventAccessFromCentralDomains`, sin `Route::domain()` manual).
  - `System\ClientController` (provisión/baja de tenants) reescrito: `Tenant::create()` +
    `$tenant->domains()->create()` reemplazan a `WebsiteRepository`/`HostnameRepository`;
    `destroy()` respeta `TENANCY_DATABASE_AUTO_DELETE` igual que antes.
  - **Bug crítico encontrado y corregido durante la validación**: a diferencia de hyn (que
    nunca tocaba `database.default`), el `DatabaseTenancyBootstrapper` de stancl sí lo cambia
    mientras el tenant está activo. Esto expuso que 11 modelos `System` (`Client`, `Plan`,
    `Configuration`, `Module`, etc.) importaban el trait de conexión pero nunca lo aplicaban
    (`use X;` faltante dentro de la clase) — dependían en silencio de que el default nunca
    cambiara. Corregido en todos; `TrackApiPeruServices` además tenía el trait equivocado.
  - **Se encontraron y limpiaron ~38 referencias a controllers `Tenant\*` inexistentes en todo
    el historial del repo** (Item, Person, SaleNote, Purchase, Quotation, Dispatch, Pos, etc.)
    — confirmado con el usuario que son funcionalidad no usada/removida, no una regresión de
    esta migración.
  - Validado end-to-end (sin datos preexistentes): creación completa de un tenant nuevo
    (BD + migración + seed de company/configuration/establishment/warehouse/series/user),
    login HTTP real 200, baja de tenant con borrado de BD. También validado contra el tenant
    real preexistente `carlos` (BD `tenancy_carlos`).
  - `hyn/multi-tenant` removido de `composer.json`/`composer.lock`.
- [ ] **Fase 3 — Saltos Laravel 10 → 11 → 12 → 13**
- [ ] **Fase 4 — Limpieza final de dependencias y hardening**

Detalle completo de cada fase: ver el plan original en el historial de conversación, o pedirle
a Claude que lo regenere a partir de este documento — el resumen de cada fase está más abajo.

## Resumen de fases pendientes

### Fase 3 — Laravel 10 → 11 → 12 → 13
10→11: colapsar `app/Http/Kernel.php` y `app/Exceptions/Handler.php` en `bootstrap/app.php`;
mover `schedule()` de `Console/Kernel.php` a `routes/console.php`. Aquí se cambia el PHP local de
8.1 a 8.4. 11→12: salto pequeño. 12→13: seguir release notes oficiales al momento de ejecutar.

### Fase 4 — Limpieza final
Quitar `fruitcake/laravel-cors` (usar el CORS nativo de Laravel), `laravelcollective/html`,
evaluar retirar `binarytorch/larecipe`/`graham-campbell/markdown` si `/docs` no se usa en
producción, subir `maatwebsite/excel` y el resto de paquetes a versiones compatibles con
Laravel 13/PHP 8.4. Recomendación no bloqueante: agregar una suite mínima de tests (Pest/PHPUnit)
sobre los flujos del checklist, y CI.
