# Facturador SRI

Sistema multi-tenant de facturación electrónica para el **SRI (Ecuador)**.
Laravel 13 · PHP 8.4 · MySQL 8 · Vue 2 + Vite · `stancl/tenancy` (una base de datos por cliente).

## Requisitos

| Componente | Versión | Notas |
|---|---|---|
| PHP | **8.4** | Extensiones: `pdo_mysql`, `mbstring`, `openssl`, `curl`, `zip`, `gd`, `intl`, `bcmath`, `soap`, `xml`, `fileinfo` |
| Composer | 2.x | |
| Node.js | **18+** (recomendado 20) | Solo para compilar el frontend (Vite) |
| MySQL | 8.x (o MariaDB 10.6+) | El usuario de BD debe poder **crear bases de datos** (una por tenant) |
| OpenSSL | 3.x | Firma de XML (certificado `.p12`) |
| `mysql` / `mysqldump` en el PATH | | Laravel los usa para cargar `database/schema/tenant-schema.sql` al crear un tenant |
| `pdo_sqlsrv` + ODBC Driver 18 | opcional | **Solo** si usas la integración con ICG (SQL Server). Sin esto verás `could not find driver` en `documents/get_failed_documents` |

> Ya no se usa Laravel Mix ni `npm run watch/production`. El frontend es Vite: `npm run dev` / `npm run build`.

## Instalación limpia (local)

```bash
git clone <url-del-repo> facturador
cd facturador

composer install
npm ci

cp .env.example .env
php artisan key:generate
```

Edita `.env` y revisa como mínimo:

| Variable | Qué poner |
|---|---|
| `APP_URL_BASE` | Dominio base sin `http://`, ej. `facturador.test`. Los tenants serán `<tenant>.facturador.test` |
| `APP_URL` | Déjalo como `http://${APP_URL_BASE}` |
| `DB_DATABASE` / `DB_USERNAME` / `DB_PASSWORD` | BD **central** (se crea sola abajo) |
| `PREFIX_DATABASE` | Prefijo de las BD de tenants (`tenancy` → `tenancy_<tenant>`). **No lo cambies después** de crear tenants |
| `QUEUE_CONNECTION` | `database` (los correos y varios procesos van por cola) |
| `MAIL_*` | SMTP para envío de comprobantes |

Crea la base central y migra:

```bash
mysql -u root -e "CREATE DATABASE facturadorsri CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
php artisan migrate --seed
php artisan storage:link
```

Compila el frontend:

```bash
npm run build      # producción / uso normal
npm run dev        # desarrollo con recarga en vivo (deja la consola abierta)
```

### Panel de administración (central)

Entra a `http://<APP_URL_BASE>/login`

- Usuario: `admin@gmail.com`
- Contraseña: `123456` — **cámbiala** en cuanto ingreses.

Desde ahí se crean los clientes (tenants). Cada alta crea su base `tenancy_<subdominio>`, corre todas las migraciones del tenant y deja su usuario inicial. El cliente entra por `http://<subdominio>.<APP_URL_BASE>/login`.

### Subdominios en Windows + Laragon

Cada tenant necesita resolver a tu máquina y llegar al mismo `public/`:

1. **hosts** (`C:\Windows\System32\drivers\etc\hosts`, como administrador), una línea por tenant:
   ```
   127.0.0.1   facturador.test
   127.0.0.1   carlos.facturador.test
   ```
2. **Virtual host con wildcard.** Laragon genera `auto.<sitio>.conf` con `ServerAlias *.${SITE}, <sitio>.<ip>.nip.io`, y esa **coma** hace que Apache ignore el wildcard: los subdominios caen en la página por defecto de Laragon. Soluciones (cualquiera de las dos):
   - Laragon → *Menu → Preferences → General* → vacía **Wildcard DNS** (nip.io), o
   - crea un archivo propio `C:\laragon\etc\apache2\sites-enabled\01-<sitio>-wildcard.conf` con `ServerName <sitio>` y `ServerAlias *.<sitio>` (sin coma), apuntando a la carpeta `public`. Laragon no lo regenera.
   
   Luego **Apache → Reload**.
3. Verifica con `httpd -S`: debe aparecer `wild alias *.facturador.test` **sin coma final**.

### Colas y tareas programadas

La app necesita dos procesos en segundo plano, además del servidor web:

```bash
# Cola (correos, procesos en segundo plano)
php artisan queue:work --tries=3 --sleep=3

# Scheduler (envío/consulta al SRI, correos, ICG, Telegram: ver app/Console/Kernel.php)
php artisan schedule:work          # en desarrollo
# En un servidor sin Docker, cron cada minuto:
# * * * * * cd /ruta/facturador && php artisan schedule:run >> /dev/null 2>&1
```

Si no corren, los comprobantes quedan sin enviar/autorizar y no salen los correos.

### Archivos generados (XML / PDF)

Se guardan por tenant en las carpetas `generados`, `firmados`, `autorizados` y `pdf`, organizados en subcarpetas **año/mes/día** (`2026/10/11/`), tomando la fecha de los primeros 8 dígitos (ddmmyyyy) de la clave de acceso. Los archivos antiguos en la carpeta plana siguen encontrándose (hay fallback).

## Despliegue con Docker

Incluye `Dockerfile` (multi-stage: compila Vite con Node 20 y sirve con `php:8.4-apache`), `compose.yaml` y `docker/entrypoint.sh`. Servicios: `mysql`, `app` (web), `queue` y `scheduler`, compartiendo el volumen `storage_data`.

```bash
cp .env.example .env
# Edita .env (APP_URL_BASE, MAIL_*, etc.). Genera la clave dentro del contenedor:
docker compose build
docker compose run --rm --no-deps app php artisan key:generate --show   # copia el valor a APP_KEY en .env
docker compose up -d
```

- El servicio `app` ejecuta `php artisan migrate --force` y cachea config/rutas/vistas al arrancar. **Después de cambiar `.env` hay que reiniciar** (`docker compose up -d --force-recreate`) porque la config queda cacheada.
- Crear el usuario administrador la primera vez (el seeder no corre solo):
  ```bash
  docker compose exec app php artisan db:seed --force
  ```
- `compose.yaml` fuerza `DB_HOST=mysql`. `docker/mysql-init/` otorga al usuario de la app permisos sobre las bases `tenancy_*` (solo corre cuando el volumen de MySQL está vacío; si cambias `PREFIX_DATABASE` en una instalación existente, otorga el permiso a mano).
- La imagen incluye el **driver de SQL Server** (`msodbcsql18` + `pdo_sqlsrv`) para la integración con ICG.
- Detrás de un proxy con TLS (Nginx/Traefik/Cloudflare) usa `APP_URL=https://...`. **Pendiente conocido:** la app no tiene configurados proxies de confianza (`TrustProxies`), así que tras un proxy Laravel puede generar enlaces `http://` y fallar el login; hay que agregarlo antes de publicar con HTTPS. `FORCE_HTTPS` solo afecta a comandos de consola, no fuerza HTTPS en la web.
- Haz respaldo de los volúmenes `mysql_data` y `storage_data` (contienen BD, certificados `.p12` y comprobantes).

## Verificar que todo está bien

```bash
composer validate                      # composer.json y composer.lock deben coincidir
composer install --no-dev --dry-run    # lo que ejecuta el Dockerfile en producción
php artisan about                      # versión y entorno
php artisan route:list >/dev/null      # sin errores de rutas
```

## Problemas frecuentes

| Síntoma | Causa / solución |
|---|---|
| `carlos.facturador.test` muestra la página de Laragon | Wildcard con coma en el vhost, ver *Subdominios en Windows + Laragon* |
| Login redirige a otro dominio / 419 | `APP_URL_BASE` no coincide con el dominio real, o falta limpiar config: `php artisan config:clear` |
| Panel solo muestra la barra superior | Falta el build del frontend: `npm run build` (o `npm run dev` corriendo) |
| `could not find driver` en `get_failed_documents` | Falta `pdo_sqlsrv` (solo integración ICG), ver Requisitos |
| Error al crear un tenant: `Access denied ... CREATE DATABASE` | El usuario de MySQL no tiene permisos globales (o sobre `tenancy_%`) |
| Comprobantes sin enviar / correos sin salir | `queue:work` o `schedule:run` no están corriendo |

## Notas de la migración

El detalle de la migración Laravel 9 → 13 / PHP 8.1 → 8.4 / `hyn` → `stancl/tenancy` está en [`docs/upgrade/README.md`](docs/upgrade/README.md), con el [checklist de QA](docs/upgrade/qa-checklist.md).
