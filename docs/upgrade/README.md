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
        **Pendiente**: correr el checklist completo de `qa-checklist.md` contra una BD de
        prueba con tenants reales — no se hizo por no tener ese entorno disponible en esta
        sesión.
- [ ] **Fase 2 — Reemplazo de `hyn/multi-tenant` por `stancl/tenancy`** (mayor riesgo, **ahora
      obligatoria antes de seguir**)
  - Confirmado empíricamente (`composer require laravel/framework:^11.0 --dry-run`):
    `hyn/multi-tenant` 5.9.1 declara `require laravel/framework ^9.0|^10.0` y bloquea duro en
    Laravel 11. Ya no se puede posponer esta fase — es el próximo paso obligatorio.
  - Confirmado empíricamente (Fase 0): no existe ninguna carpeta `tenancy/<uuid>/` en
    `storage/` ni en el repo, y `config/tenancy.php` tiene `'disk' => null` — nadie usa hoy la
    personalización de vistas/rutas/traducciones por tenant de Hyn. Se puede descartar esa
    función sin reemplazo.
- [ ] **Fase 3 — Saltos Laravel 10 → 11 → 12 → 13**
- [ ] **Fase 4 — Limpieza final de dependencias y hardening**

Detalle completo de cada fase: ver el plan original en el historial de conversación, o pedirle
a Claude que lo regenere a partir de este documento — el resumen de cada fase está más abajo.

## Resumen de fases pendientes

### Fase 1 — Laravel 9 → 10
`composer require laravel/framework:^10.0`, seguir la guía oficial de upgrade 9→10, arreglar
referencias a `Swift_RfcComplianceException` en `EmailController.php` (Symfony Mailer),
renombrar `database/seeds` → `database/seeders` (y su classmap en `composer.json`). Probar si
`hyn/multi-tenant` sigue arrancando; si no, combinar con la Fase 2.

### Fase 2 — Tenancy: `hyn/multi-tenant` → `stancl/tenancy`
Puntos de reescritura: conexión dinámica por tenant (`config/tenancy.php` →
`Hyn\Tenancy\Database\Connection`), ~69 modelos que heredan `ModelTenant`/`UsesTenantConnection`,
provisión de tenant en `ClientController::store()/destroy()` (hoy sin transacción — corregir de
paso), routing por dominio en `routes/web.php`/`routes/api.php` (hoy bifurcan todo el archivo
según `Hyn\Tenancy\Contracts\CurrentHostname`). Antes de escribir código: confirmar si algún
cliente usa hoy personalización de vistas/rutas por tenant (carpetas `tenancy/<uuid>/`), porque
stancl no tiene un equivalente directo de esa función de Hyn.

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
