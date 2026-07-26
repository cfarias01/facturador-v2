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
  - [x] `Swift_SmtpTransport`/`Swift_Mailer`/`Swift_RfcComplianceException` usados directamente
        en `Tenant\DocumentController.php`/`Tenant\EmailController.php`/`SriDocumentController.php`
        (documentado aqui como pendiente para la Fase 4): terminó resuelto antes, en la Fase 3,
        porque bloqueaba duro el salto a Laravel 13 (ver detalle en Fase 3). Ya no queda código
        que dependa de `swiftmailer/swiftmailer`.
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
- [x] **Fase 3 — Saltos Laravel 10 → 11 → 12 → 13**
  - [x] **Laravel 10 → 11**: `laravel/framework` ^11.0, PHP local pasado de 8.1 a **8.4**
        (`composer.json` ahora pide `^8.2`). `symfony/*` pineados subidos a `^7.0`,
        `nunomaduro/collision` a `^8.0`, `phpunit/phpunit` a `^11.0`, `stevebauman/location`
        subido de 6.x a **7.x** (API de `Location::get()`/`Position` sin cambios, verificado
        contra el codigo instalado — no requirio tocar `DataClientHelper.php`).
        `laravelcollective/html` removido (bloqueaba L11 duro): las 3 vistas que usaban el
        facade `Form::` (`tenant/reports/kardex/index`, `tenant/reports/index_backup`,
        `system/reports/index`) se reescribieron con HTML nativo + Blade.
    - **La estructura clasica `app/Http/Kernel.php` / `app/Exceptions/Handler.php` /
      `bootstrap/app.php` se dejo tal cual** — Laravel 11 sigue soportandola, no es obligatorio
      migrar a la nueva forma basada en `Application::configure()`. No se toco.
    - **3 bugs preexistentes encontrados y corregidos durante la validacion** (ninguno
      introducido por esta migracion, todos ya estaban rotos, solo que nadie los habia
      disparado):
      1. `database/migrations/tenant/2021_02_01_102051_add_columns_to_hotel_rents_table.php`
         intentaba agregar una columna `->after('payment_number_operation')` en el mismo
         `Schema::table()` donde esa columna se dropea — referencia invalida. El schema
         builder de Laravel 11 la valida mas estricto que el de L10 y hace fallar el
         provisioning de cualquier tenant nuevo. Separado en dos `Schema::table()` y sacado
         el `->after()` (el orden de columnas no afecta nada a nivel de Eloquent).
      2. Dos migraciones de tenant (`2021_07_05_091229_change_data_to.php`,
         `2021_07_05_125811_add_field_to_documentary_file.php`) llamaban directo a
         `Schema::getConnection()->getDoctrineSchemaManager()` (workaround viejo para mapear
         `enum`→`string` en Doctrine). Ese metodo ya no existe en Laravel 11 (`Schema::change()`
         dejo de depender de Doctrine DBAL) — se quito el workaround completo, ya no hace falta.
      3. `System\ClientController::store()`: si `Tenant::create()` fallaba **dentro** del
         evento `TenantCreated` (ej. por los bugs de arriba), la fila ya se habia insertado en
         `tenants` pero la asignacion a la variable local `$tenant` nunca se completaba (la
         excepcion corta el flujo antes de que el `=` termine), asi que el `if ($tenant)` del
         rollback nunca corria y quedaba un tenant + BD huerfanos. Se agrego un fallback
         `Tenant::find($subDom)` en el catch.
    - Validado end-to-end en Laravel 11.55.0 + PHP 8.4: boot OK, login central 200, login
      tenant 200, y **ciclo completo de alta de un tenant nuevo** (creacion de BD + todas las
      migraciones de tenant, incluidas las que dependen de `doctrine/dbal` para
      `renameColumn`/`change()`) sin errores.
    - **Riesgo para QA manual, no auditado exhaustivamente**: `nesbot/carbon` subio de 2.x a
      **3.x** (dependencia transitiva de `laravel/framework`). Carbon 3 cambio el
      comportamiento de signo de varios metodos `diffIn*()`. Hay 13 usos de `->diffIn*(` en
      `app/` y `modules/`, concentrados en el modulo Finance (calculos de morosidad/vencimiento
      en `UnpaidTrait`, `ToPay`, etc.) y en `Document`/`AccountsReceivable`. No se tocaron
      porque no hay forma de validar el resultado correcto sin datos reales — revisar estos
      calculos especificamente al probar la Fase 3 manualmente.
  - [x] **Laravel 11 → 12**: salto pequeño y limpio, como anticipaba el release de Laravel
        (mayor de mantenimiento). Solo hizo falta subir `barryvdh/laravel-dompdf` de ^2.0 a
        ^3.0 (bloqueaba duro, `illuminate/support` max ^9 en la v2). Verificado que los metodos
        usados (`loadView`, `setPaper`, `download`, `stream`) siguen disponibles en dompdf v3
        (`setPaper` via `__call()` forwarding al `Dompdf` subyacente). Sin bugs nuevos esta vez.
        Validado en Laravel 12.64.0 + PHP 8.4: boot OK, login central y tenant 200, ciclo
        completo de alta de tenant sin errores.
  - [x] **Laravel 12 → 13**: release de bajo impacto según el propio upgrade guide de Laravel
        ("~10 minutos", casi sin breaking changes obligatorios). `laravel/framework` ^13.0,
        `laravel/tinker` ^3.0, `phpunit/phpunit` ^12.0.
    - **Dos bloqueadores duros de composer, no anticipados por el upgrade guide** (dependencias
      de terceros que aún no publicaban soporte para Laravel 13 al momento de este salto):
      1. `swiftmailer/swiftmailer` 6.3.0 fija `egulias/email-validator: ^2.0|^3.1`, pero
         `laravel/framework` 13 exige `^4.0` — conflicto irresoluble. Se adelantó el ítem que
         ya estaba pendiente desde la Fase 1 (Swift_\* usado directo, sin pasar por el Mail
         facade, en `Tenant\DocumentController.php`/`Tenant\EmailController.php`/
         `SriDocumentController.php`): reemplazado por el patrón Symfony Mailer que
         `SriDocumentController.php` ya usaba en otro método (`Transport::fromDsn()` +
         `Mail::setSymfonyTransport()`), y `Swift_RfcComplianceException` por
         `Symfony\Component\Mime\Exception\RfcComplianceException`. `swiftmailer/swiftmailer`
         removido de `composer.json`. Nota: el catch de `Swift_RfcComplianceException` en
         `EmailController.php` y el bloque completo de `DocumentController.php` (que llamaba
         `Mail::getSwiftMailer()`/`Config::get()` sin importar esas facades) eran código muerto
         — ya fallaban con "Class not found" antes de esta migración, independientemente de
         Swift; quedaron corregidos de paso.
      2. `orchestra/parser` (usado solo como `XmlParser::extract()->parse()` en
         `SriDocumentController.php`, para parsear el XML de autorización del SRI) no tiene
         versión compatible con `illuminate/container` ^13 aún (su última release, v10, tope en
         ^12), y su propia dependencia real `laravie/parser` tampoco (tope `illuminate/collections`
         ^12). Bloqueador externo, igual que `hyn/multi-tenant` lo fue para Laravel 11. Con un
         único call site y un schema fijo (sin colecciones/namespaces/atributos), se reemplazó
         por `App\Support\Xml\SimpleXmlExtractor` (nuevo, ~40 líneas, sin dependencias), que
         replica exactamente el subconjunto de comportamiento usado. `orchestra/parser` removido
         de `composer.json`; el service provider y el alias `XmlParser` removidos de
         `config/app.php`.
    - `symfony/http-client`, `symfony/mailgun-mailer`, `symfony/postmark-mailer` subidos de ^7.0
      a ^8.0, `symfony/process` de ^7.2 a ^8.1 (`laravel/framework` 13 exige `symfony/process`
      ^8.1 exacto).
    - **Riesgo para QA manual, no auditado exhaustivamente** (breaking changes de bajo impacto
      según el upgrade guide oficial, no verificados contra el código real de este proyecto):
      middleware CSRF renombrado `VerifyCsrfToken` → `PreventRequestForgery` (alias deprecado
      sigue funcionando, pero cualquier `->withoutMiddleware([VerifyCsrfToken::class])` o
      exclusión custom debería revisarse); `cache.serializable_classes` ahora default `false`
      (si algún flujo cachea objetos PHP en vez de arrays, hay que listarlos explícitamente);
      DELETE con JOIN+ORDER BY+LIMIT en MySQL ahora se compila completo (antes se ignoraba
      silenciosamente) — revisar si existe algún `DB::table(...)->join(...)->orderBy(...)->limit(...)->delete()`
      en el código.
    - Validado en Laravel 13.22.0 + PHP 8.4 (Docker, `mysql:8` limpio): boot OK, login central
      200, y ciclo completo de alta de un tenant nuevo (creación de BD + las ~140 migraciones de
      tenant) sin errores.
    - **Nota aparte, no de esta fase pero descubierta en el camino**: la primera vez que se
      probó la creación de un tenant contra un MySQL realmente vacío (Docker, en vez de la BD de
      desarrollo ya poblada de siempre) aparecieron bugs preexistentes de larga data en
      migraciones de tenant (columnas `id` de tablas catálogo declaradas `->index()` en vez de
      `->primary()`, rompiendo `foreign()` hacia ellas — `cat_currency_types`, `departments`,
      `provinces`, `districts`, `countries`, y varias tablas más). Se corrigieron todas (ver
      commits de esta rama). No están relacionados con Laravel 13; simplemente nunca se habían
      disparado porque ninguna validación previa de este proyecto había recreado un tenant desde
      cero contra una base de datos física realmente vacía.
- [ ] **Fase 4 — Limpieza final de dependencias y hardening**

Detalle completo de cada fase: ver el plan original en el historial de conversación, o pedirle
a Claude que lo regenere a partir de este documento — el resumen de cada fase está más abajo.

## Resumen de fases pendientes

Nota general para Fases 1–3 (ya completas): en cualquier salto de versión quedó pendiente,
opcional y no bloqueante, migrar `app/Http/Kernel.php`/`app/Exceptions/Handler.php` a la nueva
forma de `bootstrap/app.php` — Laravel sigue soportando la estructura clásica, se dejó así a
propósito para minimizar riesgo.

### Fase 4 — Limpieza final
Quitar `fruitcake/laravel-cors` (usar el CORS nativo de Laravel), `laravelcollective/html`,
evaluar retirar `binarytorch/larecipe`/`graham-campbell/markdown` si `/docs` no se usa en
producción, subir `maatwebsite/excel` y el resto de paquetes a versiones compatibles con
Laravel 13/PHP 8.4. Recomendación no bloqueante: agregar una suite mínima de tests (Pest/PHPUnit)
sobre los flujos del checklist, y CI.
