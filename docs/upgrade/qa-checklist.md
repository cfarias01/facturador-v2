# Checklist de QA manual — migración Laravel 9 → 13

No existe suite de tests automatizados real en este proyecto, así que esta es la única red de
seguridad durante la migración. **Correr este checklist completo después de cada fase** (ver
[README.md](./README.md)), en la rama `upgrade/laravel-13-php84`, contra una base de datos de
prueba — nunca contra producción ni contra datos reales de clientes.

Marca ✅/❌ y la fecha/fase en la que se corrió, en una copia de trabajo de este archivo o en el
PR correspondiente.

## 1. Autenticación
- [ ] Login al panel System (`admin@gmail.com` / contraseña de README) funciona y redirige al
      dashboard de System.
- [ ] Login de un usuario tenant (dominio de un cliente existente) funciona y redirige al
      dashboard del tenant.
- [ ] Logout funciona en ambos paneles.

## 2. Provisión de tenant (el flujo más frágil de toda la migración)
- [ ] Alta de un cliente nuevo (`System\ClientController@store`): se crea la base de datos del
      tenant, corren las migraciones de `database/migrations/tenant`, se siembran datos base
      (company, configuration, establishment, warehouse, series, usuario admin).
- [ ] El nuevo tenant puede loguearse inmediatamente después del alta.
- [ ] **Aislamiento entre tenants**: los datos de un cliente no son visibles ni accesibles desde
      la sesión de otro cliente (probar con dos tenants distintos en paralelo).
- [ ] Baja de un cliente (`System\ClientController@destroy`) elimina su base de datos sin afectar
      a otros tenants.

## 3. Facturación electrónica (núcleo del negocio — SUNAT)
- [ ] Crear un comprobante (factura/boleta) desde el panel tenant.
- [ ] Firma XML del comprobante (`app/CoreFacturalo/WS/Signed/XmlSigned.php`) se genera
      correctamente.
- [ ] Envío SOAP a SUNAT (o su entorno de pruebas/beta) via `BillSender.php`/`AuthSri.php` recibe
      respuesta y el CDR se parsea correctamente (`SriDocumentController.php`, usa
      `orchestra/parser`).
- [ ] Consulta de estado de un comprobante (`ConsultCdrService.php`) funciona.

## 4. Documentos y PDFs
- [ ] Generación del PDF (RIDE) de un comprobante usando el motor `mpdf` (`Facturalo.php`).
- [ ] Generación de PDF con `dompdf`/`fpdf`/`fpdi` donde corresponda (`PdfUnionController.php`).
- [ ] Impresión en formato ticket (80mm/70mm) si está habilitado.

## 5. Códigos de barras
- [ ] Generación de código de barras de un ítem (`barcode-bakery`, `app/Models/Tenant/Item.php`)
      en las vistas de exportación (`items-barcode*.blade.php`, `persons-barcode-id.blade.php`).

## 6. Exportaciones / importaciones
- [ ] Al menos una exportación Excel (`maatwebsite/excel`) desde un listado (ej. reportes,
      productos, o el módulo Finance).
- [ ] Al menos una importación Excel si el flujo está en uso.

## 7. Módulos (nwidart/laravel-modules)
- [ ] Un flujo de cada módulo activo: Account, Dashboard, Document (los marcados `active: 1` en
      su `module.json`).
- [ ] Confirmar si BusinessTurn, Digemid, Finance, LevelAccess, Offline (marcados `active: 0`)
      siguen usándose en producción a pesar del flag — si es así, incluirlos también aquí.

## 8. Correo
- [ ] Envío de un correo (ej. notificación de comprobante) — validar tras Fase 1, donde se tocan
      las referencias a Swiftmailer/Symfony Mailer.

## 9. Otras integraciones livianas (validar solo si el flujo se usa activamente)
- [ ] Geolocalización (`stevebauman/location`).
- [ ] Detección de user agent (`jenssegers/agent`).
- [ ] OCR de validación (`thiagoalessio/tesseract_ocr`), requiere el binario `tesseract` en el
      SO — confirmar que sigue instalado en el entorno de destino.
- [ ] Backup con `zanysoft/laravel-zip` (`app/Console/Commands/BackupFiles.php`).
