/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `account_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `date_of_payment` date NOT NULL,
  `date_of_payment_real` date DEFAULT NULL,
  `reference_id` int unsigned DEFAULT NULL,
  `payment_method_type_id` int unsigned DEFAULT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `card_brand_id` int unsigned DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment` decimal(12,2) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT '0',
  `reference_payment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `account_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `accounting_ledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounting_ledger` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `month` smallint unsigned DEFAULT '0' COMMENT 'Numero de mes',
  `year` mediumint unsigned DEFAULT '0' COMMENT 'Numero de mes',
  `date_of_report` date DEFAULT NULL,
  `code_account` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Codigo de plan de cuenta',
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de cuenta',
  `last_month_total` float NOT NULL DEFAULT '0' COMMENT 'Debe ser el valor del total del mes pasado',
  `credits` float NOT NULL DEFAULT '0' COMMENT 'Créditos en el mes',
  `debs` float NOT NULL DEFAULT '0' COMMENT 'Debitos en el mes',
  `final_total` float NOT NULL DEFAULT '0' COMMENT 'Saldo Final de mes',
  `serialize_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'datos serialziados en bruto.',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `accounting_ledger` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounting_ledger` ENABLE KEYS */;
DROP TABLE IF EXISTS `accounting_ledger_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounting_ledger_task` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `month` smallint unsigned DEFAULT '0' COMMENT 'Numero de mes',
  `year` mediumint unsigned DEFAULT '0' COMMENT 'Numero de mes',
  `last_rum` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `accounting_ledger_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounting_ledger_task` ENABLE KEYS */;
DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
DROP TABLE IF EXISTS `adicionales_retenciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adicionales_retenciones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `retencion_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `adicionales_retenciones_retencion_id_foreign` (`retencion_id`),
  CONSTRAINT `adicionales_retenciones_retencion_id_foreign` FOREIGN KEY (`retencion_id`) REFERENCES `retenciones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `adicionales_retenciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `adicionales_retenciones` ENABLE KEYS */;
DROP TABLE IF EXISTS `agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `internal_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `agents_internal_id_unique` (`internal_id`),
  KEY `agents_name_index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `agents` DISABLE KEYS */;
/*!40000 ALTER TABLE `agents` ENABLE KEYS */;
DROP TABLE IF EXISTS `app_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_configurations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `show_image_item` tinyint(1) NOT NULL DEFAULT '1',
  `print_format_pdf` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ticket',
  `card_color` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'multicolored',
  `theme_color` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'blue',
  `header_waves` tinyint(1) NOT NULL DEFAULT '0',
  `direct_send_documents_whatsapp` tinyint(1) NOT NULL DEFAULT '0',
  `direct_print` tinyint(1) NOT NULL DEFAULT '0',
  `app_mode` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `app_configurations` DISABLE KEYS */;
INSERT INTO `app_configurations` VALUES (1,1,'ticket','multicolored','blue',0,0,0,'default','2026-07-26 19:40:24','2026-07-26 19:40:24');
/*!40000 ALTER TABLE `app_configurations` ENABLE KEYS */;
DROP TABLE IF EXISTS `app_module_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_module_user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `app_module_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `app_module_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_module_user` ENABLE KEYS */;
DROP TABLE IF EXISTS `app_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_modules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_menu` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_modules_value_unique` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `app_modules` DISABLE KEYS */;
INSERT INTO `app_modules` VALUES (1,'invoice','Factura electrónica',1,NULL,NULL),(2,'invoice-ticket','Boleta electrónica',2,NULL,NULL),(3,'sale-note','Nota de venta',3,NULL,NULL),(4,'order-note','Pedido',4,NULL,NULL),(5,'purchase','Compra',5,NULL,NULL),(6,'documents','Lista de comprobantes',6,NULL,NULL),(7,'report-sales','Reportes',7,NULL,NULL),(8,'validate-document','Validar cpe',8,NULL,NULL),(9,'customers','Clientes',9,NULL,NULL),(10,'items','Productos',10,NULL,NULL),(11,'cash','Caja',11,NULL,NULL),(12,'configuration','Configuración',12,NULL,NULL),(13,'quotation','Cotización',13,NULL,NULL);
/*!40000 ALTER TABLE `app_modules` ENABLE KEYS */;
DROP TABLE IF EXISTS `archivos_procesar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archivos_procesar` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre_archivo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mes` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `anio` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `archivos_procesar` DISABLE KEYS */;
/*!40000 ALTER TABLE `archivos_procesar` ENABLE KEYS */;
DROP TABLE IF EXISTS `authorized_discount_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authorized_discount_users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `seller_id` int unsigned DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `authorized_discount_users_token_unique` (`token`),
  KEY `authorized_discount_users_user_id_foreign` (`user_id`),
  KEY `authorized_discount_users_seller_id_foreign` (`seller_id`),
  KEY `authorized_discount_users_date_index` (`date`),
  KEY `authorized_discount_users_active_index` (`active`),
  CONSTRAINT `authorized_discount_users_seller_id_foreign` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`),
  CONSTRAINT `authorized_discount_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `authorized_discount_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `authorized_discount_users` ENABLE KEYS */;
DROP TABLE IF EXISTS `bank_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_accounts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bank_id` int unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cci` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `initial_balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `show_in_documents` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `bank_accounts_bank_id_foreign` (`bank_id`),
  KEY `bank_accounts_currency_type_id_foreign` (`currency_type_id`),
  CONSTRAINT `bank_accounts_bank_id_foreign` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`),
  CONSTRAINT `bank_accounts_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `bank_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_accounts` ENABLE KEYS */;
DROP TABLE IF EXISTS `bank_loan_fee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_loan_fee` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bank_loan_id` int unsigned NOT NULL,
  `date` date NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Relacion con el metodo de pago, Nulo es pago a cuotas',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `bank_loan_fee` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_loan_fee` ENABLE KEYS */;
DROP TABLE IF EXISTS `bank_loan_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_loan_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bank_loan_id` int unsigned NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `total` decimal(12,2) DEFAULT '0.00',
  `total_interest` decimal(12,2) DEFAULT '0.00',
  `total_ingress` decimal(12,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `bank_loan_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_loan_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `bank_loan_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_loan_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bank_loan_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `card_brand_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `bank_loan_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_loan_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `bank_loan_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_loan_reasons` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `bank_loan_reasons` DISABLE KEYS */;
INSERT INTO `bank_loan_reasons` VALUES (1,'Varios');
/*!40000 ALTER TABLE `bank_loan_reasons` ENABLE KEYS */;
DROP TABLE IF EXISTS `bank_loan_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_loan_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `bank_loan_types` DISABLE KEYS */;
INSERT INTO `bank_loan_types` VALUES (1,'Prestamo','2026-07-26 19:39:39','2026-07-26 19:39:39');
/*!40000 ALTER TABLE `bank_loan_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `bank_loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_loans` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `bank_loan_type_id` int unsigned NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `bank_id` int unsigned NOT NULL,
  `bank_account_id` int unsigned NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `bank` json NOT NULL,
  `exchange_rate_sale` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) DEFAULT '0.00',
  `total_interest` decimal(12,2) DEFAULT '0.00',
  `total_ingress` decimal(12,2) DEFAULT '0.00',
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state_type_id` char(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `bank_loans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_loans` ENABLE KEYS */;
DROP TABLE IF EXISTS `banks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banks` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `banks` DISABLE KEYS */;
INSERT INTO `banks` VALUES (1,'BANCO SCOTIABANK',NULL,NULL,1),(2,'BANCO DE CREDITO DEL PERU',NULL,NULL,1),(3,'BANCO DE COMERCIO',NULL,NULL,1),(4,'BANCO PICHINCHA',NULL,NULL,1),(5,'BBVA CONTINENTAL',NULL,NULL,1),(6,'INTERBANK',NULL,NULL,1);
/*!40000 ALTER TABLE `banks` ENABLE KEYS */;
DROP TABLE IF EXISTS `billing_cycles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing_cycles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `date_time_start` datetime NOT NULL,
  `renew` tinyint(1) NOT NULL DEFAULT '0',
  `quantity_documents` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `billing_cycles` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_cycles` ENABLE KEYS */;
DROP TABLE IF EXISTS `brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brands` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `brands_name_index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `brands` DISABLE KEYS */;
/*!40000 ALTER TABLE `brands` ENABLE KEYS */;
DROP TABLE IF EXISTS `business_turns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_turns` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `business_turns` DISABLE KEYS */;
INSERT INTO `business_turns` VALUES (1,'hotel','Hoteles',0,'2026-07-26 19:37:13','2026-07-26 19:37:13'),(2,'transport','Empresa de transporte de pasajeros',0,'2026-07-26 19:37:13','2026-07-26 19:37:13'),(3,'restaurant','Restaurantes',0,'2026-07-26 19:37:13','2026-07-26 19:37:13'),(4,'tap','Grifos',0,'2026-07-26 19:37:13','2026-07-26 19:37:13');
/*!40000 ALTER TABLE `business_turns` ENABLE KEYS */;
DROP TABLE IF EXISTS `cabecera_documento_electronicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cabecera_documento_electronicas` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `idComporbante` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idEstado` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '01',
  `fecha` date NOT NULL,
  `fechaFizcal` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderNo` int NOT NULL,
  `cliente` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipoComprobante` int NOT NULL,
  `tipoIdentificador` int NOT NULL,
  `correo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'email@email.com',
  `establecimiento` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ptoEmision` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rucEmpresa` char(13) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secuencial` char(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ambiente` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `razonSocial` text COLLATE utf8mb4_unicode_ci,
  `nombreComercial` text COLLATE utf8mb4_unicode_ci,
  `direccionMatriz` text COLLATE utf8mb4_unicode_ci,
  `direccionEstablecimiento` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `obligadoContabilidad` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NO',
  `notaNo` int DEFAULT NULL,
  `numeroCE` int DEFAULT NULL,
  `codSustento` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codDocSustento` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parteRel` char(2) COLLATE utf8mb4_unicode_ci DEFAULT 'NO',
  `numAuthSustento` char(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fPago` char(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pagoLocExt` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipoDocAfectado` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `secuencialDocAfectado` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `motivoDev` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaDocSustento` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombreDoc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `importeTotal` double DEFAULT NULL,
  `importeSinImpuestos` double DEFAULT NULL,
  `descuento` double DEFAULT NULL,
  `baseIva12` double DEFAULT NULL,
  `valorIva12` double DEFAULT NULL,
  `baseIva0` double DEFAULT NULL,
  `claveAcceso` char(49) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `regularizeShipping` tinyint DEFAULT NULL,
  `responseRegularizeShipping` json DEFAULT NULL,
  `dateAuthorization` date DEFAULT NULL,
  `timeAuthorization` time DEFAULT NULL,
  `fPagos` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `qr` text COLLATE utf8mb4_unicode_ci,
  `adicionales` text COLLATE utf8mb4_unicode_ci,
  `tipoRegi` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paisEfecPago` int DEFAULT NULL,
  `aplicConvDobTrib` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pagExtSujRetNorLeg` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pagoRegFis` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idInterno` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccionDePartida` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaIniTranporte` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaFinTransporte` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `placa` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipoSujetoRetenido` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `send_email` tinyint(1) DEFAULT '0',
  `emailed` tinyint(1) DEFAULT '0',
  `impuestos` longtext COLLATE utf8mb4_unicode_ci,
  `icg` tinyint(1) NOT NULL DEFAULT '0',
  `propina` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cabecera_documento_electronicas_idcomporbante_unique` (`idComporbante`),
  KEY `idx_cde_fecha` (`fecha`),
  KEY `idx_cde_tipoComprobante` (`tipoComprobante`),
  KEY `idx_cde_idEstado` (`idEstado`),
  KEY `idx_cde_orderNo` (`orderNo`),
  KEY `idx_cde_ruc` (`ruc`),
  KEY `idx_cde_idInterno` (`idInterno`),
  CONSTRAINT `cabecera_documento_electronicas_idestado_foreign` FOREIGN KEY (`idEstado`) REFERENCES `state_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cabecera_documento_electronicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `cabecera_documento_electronicas` ENABLE KEYS */;
DROP TABLE IF EXISTS `card_brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `card_brands` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `card_brands` DISABLE KEYS */;
INSERT INTO `card_brands` VALUES ('01','Visa',1),('02','Mastercard',1);
/*!40000 ALTER TABLE `card_brands` ENABLE KEYS */;
DROP TABLE IF EXISTS `cash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cash` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `date_opening` date NOT NULL,
  `time_opening` time NOT NULL,
  `date_closed` date DEFAULT NULL,
  `time_closed` time DEFAULT NULL,
  `beginning_balance` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `final_balance` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `income` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `state` tinyint(1) NOT NULL DEFAULT '0',
  `reference_number` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `apply_restaurant` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cash_user_id_foreign` (`user_id`),
  KEY `cash_date_opening_index` (`date_opening`),
  KEY `cash_income_index` (`income`),
  KEY `cash_state_index` (`state`),
  KEY `cash_reference_number_index` (`reference_number`),
  CONSTRAINT `cash_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cash` DISABLE KEYS */;
/*!40000 ALTER TABLE `cash` ENABLE KEYS */;
DROP TABLE IF EXISTS `cash_document_credits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cash_document_credits` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cash_id` int unsigned NOT NULL,
  `cash_id_processed` int unsigned DEFAULT NULL,
  `document_id` int unsigned DEFAULT NULL,
  `sale_note_id` int unsigned DEFAULT NULL,
  `status` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cash_document_credits_document_id_foreign` (`document_id`),
  KEY `cash_document_credits_sale_note_id_foreign` (`sale_note_id`),
  KEY `cash_document_credits_cash_id_foreign` (`cash_id`),
  CONSTRAINT `cash_document_credits_cash_id_foreign` FOREIGN KEY (`cash_id`) REFERENCES `cash` (`id`),
  CONSTRAINT `cash_document_credits_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`),
  CONSTRAINT `cash_document_credits_sale_note_id_foreign` FOREIGN KEY (`sale_note_id`) REFERENCES `sale_notes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cash_document_credits` DISABLE KEYS */;
/*!40000 ALTER TABLE `cash_document_credits` ENABLE KEYS */;
DROP TABLE IF EXISTS `cash_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cash_documents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cash_id` int unsigned NOT NULL,
  `document_id` int unsigned DEFAULT NULL,
  `sale_note_id` int unsigned DEFAULT NULL,
  `technical_service_id` int unsigned DEFAULT NULL,
  `expense_payment_id` int unsigned DEFAULT NULL,
  `purchase_id` int unsigned DEFAULT NULL,
  `bank_loan_payment_id` int unsigned DEFAULT NULL,
  `quotation_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cash_documents_cash_id_foreign` (`cash_id`),
  KEY `cash_documents_document_id_foreign` (`document_id`),
  KEY `cash_documents_sale_note_id_foreign` (`sale_note_id`),
  KEY `cash_documents_expense_payment_id_foreign` (`expense_payment_id`),
  KEY `cash_documents_technical_service_id_foreign` (`technical_service_id`),
  KEY `cash_documents_purchase_id_foreign` (`purchase_id`),
  KEY `cash_documents_quotation_id_foreign` (`quotation_id`),
  CONSTRAINT `cash_documents_cash_id_foreign` FOREIGN KEY (`cash_id`) REFERENCES `cash` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cash_documents_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cash_documents_expense_payment_id_foreign` FOREIGN KEY (`expense_payment_id`) REFERENCES `expense_payments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cash_documents_purchase_id_foreign` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cash_documents_quotation_id_foreign` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`),
  CONSTRAINT `cash_documents_sale_note_id_foreign` FOREIGN KEY (`sale_note_id`) REFERENCES `sale_notes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cash_documents_technical_service_id_foreign` FOREIGN KEY (`technical_service_id`) REFERENCES `technical_services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cash_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `cash_documents` ENABLE KEYS */;
DROP TABLE IF EXISTS `cash_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cash_transactions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cash_id` int unsigned NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment` decimal(14,4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cash_transactions_cash_id_foreign` (`cash_id`),
  KEY `cash_transactions_payment_method_type_id_foreign` (`payment_method_type_id`),
  CONSTRAINT `cash_transactions_cash_id_foreign` FOREIGN KEY (`cash_id`) REFERENCES `cash` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cash_transactions_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cash_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cash_transactions` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_accounting_ledger_code_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_accounting_ledger_code_account` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code_account` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Codigo de plan de cuenta',
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de cuenta',
  `disabled` tinyint unsigned DEFAULT '0' COMMENT 'Permite realizar modificaciones',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_accounting_ledger_code_account` DISABLE KEYS */;
INSERT INTO `cat_accounting_ledger_code_account` VALUES (1,'1','Activos',1,NULL,NULL),(2,'1.1','Activos corrientes',1,NULL,NULL),(3,'1.1.1','Efectivo y equivalentes de efectivo',1,NULL,NULL),(4,'1.1.1.1','Caja',1,NULL,NULL),(5,'1.1.1.2','Bancos',1,NULL,NULL),(6,'1.1.2','Deudores comerciales y otras cuentas por cobrar',1,NULL,NULL),(7,'1.1.2.0','Activos por impuestos corrientes',1,NULL,NULL),(8,'1.1.2.1','Otras cuentas por cobrar',1,NULL,NULL),(9,'1.1.3','Inventarios',1,NULL,NULL),(10,'1.1.4','Inversiones a corto plazo',1,NULL,NULL),(11,'1.1.5','Otros activos corrientes',1,NULL,NULL),(12,'1.2','Activos no corrientes',1,NULL,NULL),(13,'1.2.1','Propiedad, planta y equipo (Activos fijos)',1,NULL,NULL),(14,'1.2.2','Otros Activos no corrientes',1,NULL,NULL),(15,'2','Pasivos',1,NULL,NULL),(16,'2.1','Pasivos corrientes',1,NULL,NULL),(17,'2.1.1','Cuentas por pagar',1,NULL,NULL),(18,'2.1.1.1','Otras cuentas por pagar',1,NULL,NULL),(19,'2.1.2','Provisiones',1,NULL,NULL),(20,'2.1.3','Obligaciones laborales y de seguridad social',1,NULL,NULL),(21,'2.1.4','Pasivos por impuestos corrientes',1,NULL,NULL),(22,'2.1.4.1','Impuestos por pagar',1,NULL,NULL),(23,'2.1.4.2','Retenciones por pagar',1,NULL,NULL),(24,'2.1.5','Cuentas por pagar con costo financiero',1,NULL,NULL),(25,'2.1.6','Obligaciones financieras',1,NULL,NULL),(26,'2.1.6.1','Tarjetas de crédito',1,NULL,NULL),(27,'2.1.7','Otros pasivos corrientes',1,NULL,NULL),(28,'2.2','Pasivos no corrientes',1,NULL,NULL),(29,'2.2.1','Préstamos a largo plazo',1,NULL,NULL),(30,'2.2.2','Otros pasivos no corrientes',1,NULL,NULL),(31,'3','Patrimonio',1,NULL,NULL),(32,'3.1','Capital social',1,NULL,NULL),(33,'3.2','Ganancias acumuladas',1,NULL,NULL),(34,'3.3','Ajustes por saldos iniciales',1,NULL,NULL),(35,'3.3.1','Ajustes iniciales en bancos',1,NULL,NULL),(36,'3.3.2','Ajustes iniciales en inventario',1,NULL,NULL),(37,'4','Ingresos',1,NULL,NULL),(38,'4.1','Ingresos de actividades ordinarias',1,NULL,NULL),(39,'4.2','Otros Ingresos',1,NULL,NULL),(40,'4.2.1','Otros ingresos diversos',1,NULL,NULL);
/*!40000 ALTER TABLE `cat_accounting_ledger_code_account` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_address_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_address_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_address_types` DISABLE KEYS */;
INSERT INTO `cat_address_types` VALUES ('01','Punto de venta'),('02','Producción'),('03','Extracción'),('04','Explotación'),('05','Otros');
/*!40000 ALTER TABLE `cat_address_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_affectation_igv_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_affectation_igv_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `exportation` tinyint(1) DEFAULT NULL,
  `free` tinyint(1) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_affectation_igv_types` DISABLE KEYS */;
INSERT INTO `cat_affectation_igv_types` VALUES ('10',1,0,0,'Gravado - IVA 12'),('11',1,0,0,'Gravado – IVA 8'),('12',1,0,0,'Gravado – IVA 14'),('13',0,0,0,'Gravado – Retiro'),('14',0,0,1,'Gravado – Retiro por publicidad'),('15',0,0,1,'Gravado – Bonificaciones'),('16',0,0,1,'Gravado – Retiro por entrega a trabajadores'),('17',0,0,1,'Gravado – IVAP'),('20',0,0,0,'Exonerado - Operación Onerosa'),('21',0,0,1,'Exonerado – Transferencia Gratuita'),('30',1,0,0,'Inafecto - IVA 0'),('31',0,0,1,'Inafecto – Retiro por Bonificación'),('32',0,0,1,'Inafecto – Retiro'),('33',0,0,1,'Inafecto – Retiro por Muestras Médicas'),('34',0,0,1,'Inafecto - Retiro por Convenio Colectivo'),('35',0,0,1,'Inafecto – Retiro por premio'),('36',0,0,1,'Inafecto - Retiro por publicidad'),('37',0,0,1,'Inafecto - Transferencia gratuita'),('40',0,1,0,'Exportación de bienes o servicios'),('50',0,0,0,'Iva - 0'),('51',0,0,0,'Iva - 8'),('52',0,0,0,'Iva - 12'),('53',0,0,0,'Iva - 14'),('60',0,0,0,'Sin IVA');
/*!40000 ALTER TABLE `cat_affectation_igv_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_attribute_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_attribute_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_attribute_types` DISABLE KEYS */;
INSERT INTO `cat_attribute_types` VALUES ('3001',1,'Detracciones: Recursos Hidrobiológicos-Matrícula de la embarcación'),('3002',1,'Detracciones: Recursos Hidrobiológicos-Nombre de la embarcación'),('3003',1,'Detracciones: Recursos Hidrobiológicos-Tipo de especie vendida'),('3004',1,'Detracciones: Recursos Hidrobiológicos-Lugar de descarga'),('3005',1,'Detracciones: Recursos Hidrobiológicos-Fecha de descarga'),('3006',1,'Detracciones: Recursos Hidrobiológicos-Cantidad de especie vendida'),('3050',1,'Transportre Terreste - Número de asiento'),('3051',1,'Transporte Terrestre - Información de manifiesto de pasajeros'),('3052',1,'Transporte Terrestre - Número de documento de identidad del pasajero'),('3053',1,'Transporte Terrestre - Tipo de documento de identidad del pasajero'),('3054',1,'Transporte Terrestre - Nombres y apellidos del pasajero'),('3055',1,'Transporte Terrestre - Ciudad o lugar de destino - Ubigeo'),('3056',1,'Transporte Terrestre - Ciudad o lugar de destino - Dirección detallada'),('3057',1,'Transporte Terrestre - Ciudad o lugar de origen - Ubigeo'),('3058',1,'Transporte Terrestre - Ciudad o lugar de origen - Dirección detallada'),('3059',1,'Transporte Terrestre - Fecha de inicio programado'),('3060',1,'Transporte Terrestre - Hora de inicio programado'),('4000',1,'Beneficio Hospedajes-Paquete turístico: Código de país de emisión del pasaporte'),('4001',1,'Beneficio Hospedajes: Código de país de residencia del sujeto no domiciliado'),('4002',1,'Beneficio Hospedajes: Fecha de ingreso al país'),('4003',1,'Beneficio Hospedajes: Fecha de Ingreso al Establecimiento'),('4004',1,'Beneficio Hospedajes: Fecha de Salida del Establecimiento'),('4005',1,'Beneficio Hospedajes: Número de Días de Permanencia'),('4006',1,'Beneficio Hospedajes: Fecha de Consumo'),('4007',1,'Beneficio Hospedajes-Paquete turístico: Nombres y apellidos del huesped'),('4008',1,'Beneficio Hospedajes-Paquete turístico: Tipo de documento de identidad del huesped'),('4009',1,'Beneficio Hospedajes-Paquete turístico: Número de documento de identidad del huesped'),('4030',1,'Carta Porte Aéreo:  Lugar de origen - Código de ubigeo'),('4031',1,'Carta Porte Aéreo:  Lugar de origen - Dirección detallada'),('4032',1,'Carta Porte Aéreo:  Lugar de destino - Código de ubigeo'),('4033',1,'Carta Porte Aéreo:  Lugar de destino - Dirección detallada'),('4040',1,'BVME transporte ferroviario: Pasajero - Apellidos y Nombres'),('4041',1,'BVME transporte ferroviario: Pasajero - Tipo de documento de identidad'),('4042',1,'BVME transporte ferroviario: Servicio transporte: Ciudad o lugar de origen - Código de ubigeo'),('4043',1,'BVME transporte ferroviario: Servicio transporte: Ciudad o lugar de origen - Dirección detallada'),('4044',1,'BVME transporte ferroviario: Servicio transporte: Ciudad o lugar de destino - Código de ubigeo'),('4045',1,'BVME transporte ferroviario: Servicio transporte: Ciudad o lugar de destino - Dirección detallada'),('4046',1,'BVME transporte ferroviario: Servicio transporte:Número de asiento'),('4047',1,'BVME transporte ferroviario: Servicio transporte: Hora programada de inicio de viaje'),('4048',1,'BVME transporte ferroviario: Servicio transporte: Fecha programada de inicio de viaje'),('4049',1,'BVME transporte ferroviario: Pasajero - Número de documento de identidad'),('4060',1,'Regalía Petrolera: Decreto Supremo de aprobación del contrato'),('4061',1,'Regalía Petrolera: Area de contrato (Lote)'),('4062',1,'Regalía Petrolera: Periodo de pago - Fecha de inicio'),('4063',1,'Regalía Petrolera: Periodo de pago - Fecha de fin'),('4064',1,'Regalía Petrolera: Fecha de Pago'),('5000',1,'Proveedores Estado: Número de Expediente'),('5001',1,'Proveedores Estado: Código de Unidad Ejecutora'),('5002',1,'Proveedores Estado: N° de Proceso de Selección'),('5003',1,'Proveedores Estado: N° de Contrato'),('5010',1,'Numero de Placa'),('5011',1,'Categoria'),('5012',1,'Marca'),('5013',1,'Modelo'),('5014',1,'Color'),('5015',1,'Motor'),('5016',1,'Combustible'),('5017',1,'Form. Rodante'),('5018',1,'VIN'),('5019',1,'Serie/Chasis'),('5020',1,'Año fabricacion'),('5021',1,'Año modelo'),('5022',1,'Version'),('5023',1,'Ejes'),('5024',1,'Asientos'),('5025',1,'Pasajeros'),('5026',1,'Ruedas'),('5027',1,'Carroceria'),('5028',1,'Potencia'),('5029',1,'Cilindros'),('5030',1,'Ciliindrada'),('5031',1,'Peso Bruto'),('5032',1,'Peso Neto'),('5033',1,'Carga Util'),('5034',1,'Longitud'),('5035',1,'Altura'),('5036',1,'Ancho'),('6000',1,'Comercialización de Oro:  Código Unico Concesión Minera'),('6001',1,'Comercialización de Oro:  N° declaración compromiso'),('6002',1,'Comercialización de Oro:  N° Reg. Especial .Comerci. Oro'),('6003',1,'Comercialización de Oro:  N° Resolución que autoriza Planta de Beneficio'),('6004',1,'Comercialización de Oro: Ley Mineral (% concent. oro)'),('7000',1,'Gastos Art. 37 Renta:  Número de Placa'),('7001',1,'Créditos Hipotecarios: Tipo de préstamo'),('7002',1,'Créditos Hipotecarios: Indicador de Primera Vivienda'),('7003',1,'Créditos Hipotecarios: Partida Registral'),('7004',1,'Créditos Hipotecarios: Número de contrato'),('7005',1,'Créditos Hipotecarios: Fecha de otorgamiento del crédito'),('7006',1,'Créditos Hipotecarios: Dirección del predio - Código de ubigeo'),('7007',1,'Créditos Hipotecarios: Dirección del predio - Dirección completa'),('7008',1,'Créditos Hipotecarios: Dirección del predio - Urbanización'),('7009',1,'Créditos Hipotecarios: Dirección del predio - Provincia'),('7010',1,'Créditos Hipotecarios: Dirección del predio - Distrito'),('7011',1,'Créditos Hipotecarios: Dirección del predio - Departamento'),('7020',1,'Partida Arancelaria');
/*!40000 ALTER TABLE `cat_attribute_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_charge_discount_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_charge_discount_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `base` tinyint(1) NOT NULL,
  `level` enum('item','global') COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('discount','charge') COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_charge_discount_types` DISABLE KEYS */;
INSERT INTO `cat_charge_discount_types` VALUES ('00',1,1,'item','discount','Descuentos que afectan la base imponible'),('01',0,0,'item','discount','Descuentos que no afectan la base imponible del IGV/IVAP'),('02',1,1,'global','discount','Descuentos globales que afectan la base imponible del IGV/IVAP'),('03',0,0,'global','discount','Descuentos globales que no afectan la base imponible del IGV/IVAP'),('04',0,1,'global','discount','Descuentos globales por anticipos gravados que afectan la base imponible del IGV/IVAP'),('05',0,0,'global','discount','Descuentos globales por anticipos exonerados'),('06',0,0,'global','discount','Descuentos globales por anticipos inafectos'),('45',0,1,'global','charge','FISE'),('46',1,0,'global','charge','Recargo al consumo y/o propinas'),('47',0,1,'item','charge','Cargos que afectan la base imponible del IGV/IVAP'),('48',1,0,'item','charge','Cargos que no afectan la base imponible del IGV/IVAP'),('49',1,1,'global','charge','Cargos globales que afectan la base imponible del IGV/IVAP'),('50',1,0,'global','charge','Cargos globales que no afectan la base imponible del IGV/IVAP'),('51',0,1,'global','charge','Percepción venta interna'),('52',0,1,'global','charge','Percepción a la adquisición de combustible'),('53',0,1,'global','charge','Percepción realizada al agente de percepción con tasa especial'),('62',1,0,'global','discount','Retención del IGV');
/*!40000 ALTER TABLE `cat_charge_discount_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_colors_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_colors_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del color',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_colors_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_colors_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_currency_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_currency_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `symbol` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_currency_types` DISABLE KEYS */;
INSERT INTO `cat_currency_types` VALUES ('PEN',1,'S/','Soles'),('USD',1,'$','Dólares Americanos');
/*!40000 ALTER TABLE `cat_currency_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_detraction_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_detraction_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage` decimal(6,2) NOT NULL,
  `operation_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cat_detraction_types_operation_type_id_foreign` (`operation_type_id`),
  CONSTRAINT `cat_detraction_types_operation_type_id_foreign` FOREIGN KEY (`operation_type_id`) REFERENCES `cat_operation_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_detraction_types` DISABLE KEYS */;
INSERT INTO `cat_detraction_types` VALUES ('001',1,'Azúcar y melaza de caña',10.00,'1001'),('003',1,'Alcohol etílico',10.00,'1001'),('005',1,'Maíz amarillo duro',4.00,'1001'),('008',1,'Madera',4.00,'1001'),('016',1,'Aceite de pescado',10.00,'1001'),('019',1,'Arrendamiento de bienes',10.00,'1001'),('020',1,'Mantenimiento y reparación de bienes muebles',12.00,'1001'),('022',1,'Otros servicios empresariales',12.00,'1001'),('023',1,'Leche',4.00,'1001'),('025',1,'Fabricación de bienes por encargo',10.00,'1001'),('027',1,'Servicio de transporte de carga',4.00,'1004');
/*!40000 ALTER TABLE `cat_detraction_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_digemid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_digemid` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL COMMENT 'Id de la tabla de item',
  `cod_digemid` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Codigo digmid',
  `nom_prod` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Nombre segun digemid',
  `concent` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Dosificacion segun digemid',
  `nom_form_farm` longtext COLLATE utf8mb4_unicode_ci,
  `nom_form_farm_simplif` longtext COLLATE utf8mb4_unicode_ci,
  `presentac` longtext COLLATE utf8mb4_unicode_ci,
  `fracciones` longtext COLLATE utf8mb4_unicode_ci,
  `fec_vcto_reg_sanitario` longtext COLLATE utf8mb4_unicode_ci,
  `num_reg_san` longtext COLLATE utf8mb4_unicode_ci,
  `nom_titular` longtext COLLATE utf8mb4_unicode_ci,
  `prices` longtext COLLATE utf8mb4_unicode_ci,
  `max_prices` int unsigned DEFAULT '0',
  `active` tinyint unsigned NOT NULL DEFAULT '0',
  `last_update` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_digemid` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_digemid` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_document_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_document_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `short` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_document_types` DISABLE KEYS */;
INSERT INTO `cat_document_types` VALUES ('01',1,'FT','FACTURA ELECTRÓNICA'),('02',0,NULL,'RECIBO POR HONORARIOS'),('03',1,'BV','LIQUIDACIÓN DE COMPRA'),('04',1,'NC','NOTA DE CRÉDITO'),('05',1,'ND','NOTA DE DÉBITO'),('06',1,NULL,'GUÍA DE REMISIÓN'),('07',1,'CO','RETENCIÓN'),('09',0,NULL,'GUIA DE REMISIÓN REMITENTE'),('14',0,NULL,'SERVICIOS PÚBLICOS'),('19',1,'PD','COMPROBANTES DE PAGO DE CUOTAS O APORTES'),('20',0,NULL,'COMPROBANTE DE RETENCIÓN ELECTRÓNICA'),('31',0,NULL,'Guía de remisión transportista'),('40',0,NULL,'COMPROBANTE DE PERCEPCIÓN ELECTRÓNICA'),('71',0,NULL,'Guia de remisión remitente complementaria'),('72',0,NULL,'Guia de remisión transportista complementaria'),('80',0,NULL,'NOTA DE VENTA'),('NE76',0,NULL,'NOTA DE ENTRADA');
/*!40000 ALTER TABLE `cat_document_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_identity_document_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_identity_document_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_identity_document_types` DISABLE KEYS */;
INSERT INTO `cat_identity_document_types` VALUES ('0',0,'CONSUMIDOR FINAL'),('1',1,'CÉDULA'),('4',1,'IDENTIFICACIÓN DEL EXTERIOR'),('6',1,'RUC'),('7',1,'Pasaporte'),('A',0,'Ced. Diplomática de identidad'),('B',0,'Documento identidad país residencia-no.d'),('C',0,'Tax Identification Number - TIN – Doc Trib PP.NN'),('D',0,'Identification Number - IN – Doc Trib PP. JJ'),('E',0,'TAM- Tarjeta Andina de Migración');
/*!40000 ALTER TABLE `cat_identity_document_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_item_mold_cavities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_item_mold_cavities` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de cavidades del molde',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_item_mold_cavities` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_item_mold_cavities` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_item_mold_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_item_mold_properties` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de propiedades por molde',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_item_mold_properties` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_item_mold_properties` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_item_package_measurements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_item_package_measurements` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de medidas del paquete',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_item_package_measurements` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_item_package_measurements` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_item_product_family`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_item_product_family` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de familia d eproductos',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_item_product_family` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_item_product_family` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_item_size`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_item_size` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de unidad de medida',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_item_size` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_item_size` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_item_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_item_status` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del status',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_item_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_item_status` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_item_unit_business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_item_unit_business` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de unidad de negocio',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_item_unit_business` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_item_unit_business` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_item_units_per_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_item_units_per_package` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de unidades por paquete',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_item_units_per_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_item_units_per_package` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_legend_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_legend_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_legend_types` DISABLE KEYS */;
INSERT INTO `cat_legend_types` VALUES ('1000',1,'Monto en Letras'),('1002',1,'TRANSFERENCIA GRATUITA DE UN BIEN Y/O SERVICIO PRESTADO GRATUITAMENTE'),('2000',1,'COMPROBANTE DE PERCEPCIÓN'),('2001',1,'BIENES TRANSFERIDOS EN LA AMAZONÍA REGIÓN SELVA PARA SER CONSUMIDOS EN LA MISMA'),('2002',1,'SERVICIOS PRESTADOS EN LA AMAZONÍA  REGIÓN SELVA PARA SER CONSUMIDOS EN LA MISMA'),('2003',1,'CONTRATOS DE CONSTRUCCIÓN EJECUTADOS  EN LA AMAZONÍA REGIÓN SELVA'),('2004',1,'Agencia de Viaje - Paquete turístico'),('2005',1,'Venta realizada por emisor itinerante'),('2006',1,'Operación sujeta a detracción'),('2007',1,'Operación sujeta al IVAP'),('2008',1,'VENTA EXONERADA DEL IGV-ISC-IPM. PROHIBIDA LA VENTA FUERA DE LA ZONA COMERCIAL DE TACNA'),('2009',1,'PRIMERA VENTA DE MERCANCÍA IDENTIFICABLE ENTRE USUARIOS DE LA ZONA COMERCIAL'),('2010',1,'Restitucion Simplificado de Derechos Arancelarios');
/*!40000 ALTER TABLE `cat_legend_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_note_credit_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_note_credit_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_note_credit_types` DISABLE KEYS */;
INSERT INTO `cat_note_credit_types` VALUES ('01',1,'Anulación de la operación'),('02',1,'Anulación por error en el RUC'),('03',1,'Corrección por error en la descripción'),('04',1,'Descuento global'),('05',1,'Descuento por ítem'),('06',1,'Devolución total'),('07',1,'Devolución por ítem'),('08',1,'Bonificación'),('09',1,'Disminución en el valor'),('10',1,'Otros Conceptos'),('11',1,'Ajustes de operaciones de exportación'),('12',1,'Ajustes afectos al IVAP'),('13',1,'Ajustes – montos y/o fechas de pago');
/*!40000 ALTER TABLE `cat_note_credit_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_note_debit_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_note_debit_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_note_debit_types` DISABLE KEYS */;
INSERT INTO `cat_note_debit_types` VALUES ('01',1,'Intereses por mora'),('02',1,'Aumento en el valor'),('03',1,'Penalidades/ otros conceptos'),('10',1,'Ajustes de operaciones de exportación'),('11',1,'Ajustes afectos al IVAP');
/*!40000 ALTER TABLE `cat_note_debit_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_operation_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_operation_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `exportation` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_operation_types` DISABLE KEYS */;
INSERT INTO `cat_operation_types` VALUES ('0101',1,0,'Venta interna'),('0112',0,0,'Venta Interna - Sustenta Gastos Deducibles Persona Natural'),('0113',0,0,'Venta Interna - NRUS'),('0200',1,1,'Exportación de Bienes'),('0201',0,1,'Exportación de Servicios – Prestación servicios realizados íntegramente en el país'),('0202',0,1,'Exportación de Servicios – Prestación de servicios de hospedaje No Domiciliado'),('0203',0,1,'Exportación de Servicios – Transporte de navieras'),('0204',0,1,'Exportación de Servicios – Servicios a naves y aeronaves de bandera extranjera'),('0205',0,1,'Exportación de Servicios - Servicios que conformen un Paquete Turístico'),('0206',0,1,'Exportación de Servicios – Servicios complementarios al transporte de carga'),('0207',0,1,'Exportación de Servicios – Suministro de energía eléctrica a favor de sujetos domiciliados en ZED'),('0208',0,1,'Exportación de Servicios – Prestación servicios realizados parcialmente en el extranjero'),('0301',0,0,'Operaciones con Carta de porte aéreo (emitidas en el ámbito nacional)'),('0302',0,0,'Operaciones de Transporte ferroviario de pasajeros'),('0303',0,0,'Operaciones de Pago de regalía petrolera'),('0401',1,0,'Ventas no domiciliados que no califican como exportación'),('0501',1,0,'Compra interna'),('1001',1,0,'Operación Sujeta a Detracción'),('1002',0,0,'Operación Sujeta a Detracción- Recursos Hidrobiológicos'),('1003',0,0,'Operación Sujeta a Detracción- Servicios de Transporte Pasajeros'),('1004',1,0,'Operación Sujeta a Detracción- Servicios de Transporte Carga'),('2001',0,0,'Operación Sujeta a Percepción');
/*!40000 ALTER TABLE `cat_operation_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_other_tax_concept_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_other_tax_concept_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_other_tax_concept_types` DISABLE KEYS */;
INSERT INTO `cat_other_tax_concept_types` VALUES ('1000',1,'Total valor de venta - operaciones exportadas'),('1001',1,'Total valor de venta - operaciones gravadas'),('1002',1,'Total valor de venta - operaciones inafectas'),('1003',1,'Total valor de venta - operaciones exoneradas'),('1004',1,'Total valor de venta – Operaciones gratuitas'),('1005',1,'Sub total de venta'),('2001',1,'Percepciones'),('2002',1,'Retenciones'),('2003',1,'Detracciones'),('2004',1,'Bonificaciones'),('2005',1,'Total descuentos'),('3001',1,'FISE (Ley 29852) Fondo Inclusión Social Energético');
/*!40000 ALTER TABLE `cat_other_tax_concept_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_payment_method_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_payment_method_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_payment_method_types` DISABLE KEYS */;
INSERT INTO `cat_payment_method_types` VALUES ('001',1,'Depósito en cuenta'),('002',1,'Giro'),('003',1,'Transferencia de fondos'),('004',1,'Orden de pago'),('005',1,'Tarjeta de débito'),('006',1,'Tarjeta de crédito emitida en el país por una empresa del sistema financiero'),('007',1,'Cheques con la cláusula de \"NO NEGOCIABLE\", \"INTRANSFERIBLES\", \"NO A LA ORDEN\" u otra equivalente, a que se refiere el inciso g) del artículo 5° de la ley'),('008',1,'Efectivo, por operaciones en las que no existe obligación de utilizar medio de pago'),('009',1,'Efectivo, en los demás casos'),('010',1,'Medios de pago usados en comercio exterior'),('011',1,'Documentos emitidos por las EDPYMES y las cooperativas de ahorro y crédito no autorizadas a captar depósitos del público'),('012',1,'Tarjeta de crédito emitida en el país o en el exterior por una empresa no perteneciente al sistema financiero, cuyo objeto principal sea la emisión y administración de tarjetas de crédito'),('013',1,'Tarjetas de crédito emitidas en el exterior por empresas bancarias o financieras no domiciliadas'),('101',1,'Transferencias – Comercio exterior'),('102',1,'Cheques bancarios - Comercio exterior'),('103',1,'Orden de pago simple - Comercio exterior'),('104',1,'Orden de pago documentario - Comercio exterior'),('105',1,'Remesa simple - Comercio exterior'),('106',1,'Remesa documentaria - Comercio exterior'),('107',1,'Carta de crédito simple - Comercio exterior'),('108',1,'Carta de crédito documentario - Comercio exterior'),('999',1,'Otros medios de pago');
/*!40000 ALTER TABLE `cat_payment_method_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_perception_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_perception_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `percentage` decimal(10,2) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_perception_types` DISABLE KEYS */;
INSERT INTO `cat_perception_types` VALUES ('01',1,2.00,'Percepción Venta Interna'),('02',1,1.00,'Percepción a la adquisición de combustible'),('03',1,0.50,'Percepción realizada al agente de percepción con tasa especial');
/*!40000 ALTER TABLE `cat_perception_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_periods` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `period` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Define si es dia, mes o año - D/M/Y',
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del periodo',
  `active` tinyint NOT NULL DEFAULT '0' COMMENT 'Si esta activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_periods` DISABLE KEYS */;
INSERT INTO `cat_periods` VALUES (1,'M','Mensual',1,NULL,NULL),(2,'Y','Anual',1,NULL,NULL);
/*!40000 ALTER TABLE `cat_periods` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_price_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_price_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_price_types` DISABLE KEYS */;
INSERT INTO `cat_price_types` VALUES ('01',1,'Precio unitario (incluye el IGV)'),('02',1,'Valor referencial unitario en operaciones no onerosas');
/*!40000 ALTER TABLE `cat_price_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_related_documents_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_related_documents_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_related_documents_types` DISABLE KEYS */;
INSERT INTO `cat_related_documents_types` VALUES ('01',1,'Numeración DAM'),('02',1,'Número de orden de entrega'),('03',1,'Número SCOP'),('04',1,'Número de manifiesto de carga'),('05',1,'Número de constancia de detracción'),('06',1,'Otros');
/*!40000 ALTER TABLE `cat_related_documents_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_related_tax_document_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_related_tax_document_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_related_tax_document_types` DISABLE KEYS */;
INSERT INTO `cat_related_tax_document_types` VALUES ('01',1,'Factura – emitida para corregir error en el RUC'),('02',1,'Factura – emitida por anticipos'),('03',1,'Boleta de Venta – emitida por anticipos'),('04',1,'Ticket de Salida - ENAPU'),('05',1,'Código SCOP'),('99',1,'Otros');
/*!40000 ALTER TABLE `cat_related_tax_document_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_retention_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_retention_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `percentage` decimal(10,2) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_retention_types` DISABLE KEYS */;
INSERT INTO `cat_retention_types` VALUES ('01',1,3.00,'Tasa 3%'),('02',1,6.00,'Tasa 6%');
/*!40000 ALTER TABLE `cat_retention_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_summary_status_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_summary_status_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_summary_status_types` DISABLE KEYS */;
INSERT INTO `cat_summary_status_types` VALUES ('1',1,'Adicionar'),('2',1,'Modificar'),('3',1,'Anulado');
/*!40000 ALTER TABLE `cat_summary_status_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_system_isc_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_system_isc_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_system_isc_types` DISABLE KEYS */;
INSERT INTO `cat_system_isc_types` VALUES ('01',1,'Sistema al valor'),('02',1,'Aplicación del Monto Fijo'),('03',1,'Sistema de Precios de Venta al Público');
/*!40000 ALTER TABLE `cat_system_isc_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_transfer_reason_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_transfer_reason_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_stock` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_transfer_reason_types` DISABLE KEYS */;
INSERT INTO `cat_transfer_reason_types` VALUES ('01',1,'Venta',0),('02',1,'Compra',0),('04',1,'Traslado entre establecimientos de la misma empresa',0),('08',1,'Importación',0),('09',1,'Exportación',0),('13',1,'Otros',0),('14',1,'Venta sujeta a confirmación del comprador',0),('18',1,'Traslado emisor itinerante CP',0),('19',1,'Traslado a zona primaria',0);
/*!40000 ALTER TABLE `cat_transfer_reason_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_transport_mode_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_transport_mode_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_transport_mode_types` DISABLE KEYS */;
INSERT INTO `cat_transport_mode_types` VALUES ('01',1,'Transporte público'),('02',1,'Transporte privado');
/*!40000 ALTER TABLE `cat_transport_mode_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `cat_unit_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_unit_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `symbol` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `cat_unit_types` DISABLE KEYS */;
INSERT INTO `cat_unit_types` VALUES ('BX',1,NULL,'Caja'),('FOT',1,NULL,'Pies'),('GLL',1,NULL,'Galones'),('GRM',1,NULL,'Gramos'),('HUR',1,NULL,'Hora'),('INH',1,NULL,'Pulgadas'),('KGM',1,NULL,'Kilos'),('LTR',1,NULL,'Litros'),('MTR',1,NULL,'Metros'),('NIU',1,NULL,'Unidades'),('YRD',1,NULL,'Yardas'),('ZZ',1,NULL,'Servicio');
/*!40000 ALTER TABLE `cat_unit_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories_name_index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
DROP TABLE IF EXISTS `charge_padrones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `charge_padrones` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `charge_padrones` DISABLE KEYS */;
/*!40000 ALTER TABLE `charge_padrones` ENABLE KEYS */;
DROP TABLE IF EXISTS `client_error_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_error_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `client_error_types` DISABLE KEYS */;
INSERT INTO `client_error_types` VALUES ('data_entry','Errores de ingreso de datos'),('token_creation','Errores en la creación del token de tarjeta');
/*!40000 ALTER TABLE `client_error_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `client_errors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_errors` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_error_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `client_errors_client_error_type_id_foreign` (`client_error_type_id`),
  KEY `client_errors_code_index` (`code`),
  CONSTRAINT `client_errors_client_error_type_id_foreign` FOREIGN KEY (`client_error_type_id`) REFERENCES `client_error_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `client_errors` DISABLE KEYS */;
INSERT INTO `client_errors` VALUES (1,'205','data_entry','parameter cardNumber can not be null/empty','Ingresa el número de tu tarjeta.'),(2,'208','data_entry','parameter cardExpirationMonth can not be null/empty','Elige un mes.'),(3,'209','data_entry','parameter cardExpirationYear can not be null/empty','Elige un año.'),(4,'212','data_entry','parameter docType can not be null/empty','Ingresa tu tipo de documento.'),(5,'213','data_entry','The parameter cardholder.document.subtype can not be null or empty','Ingresa tu documento.'),(6,'214','data_entry','parameter docNumber can not be null/empty','Ingresa tu documento.'),(7,'220','data_entry','parameter cardIssuerId can not be null/empty','Ingresa tu banco.'),(8,'221','data_entry','parameter cardholderName can not be null/empty','Ingresa el nombre y apellido.'),(9,'224','data_entry','parameter securityCode can not be null/empty','Ingresa el código de seguridad.'),(10,'E301','data_entry','invalid parameter cardNumber','Ingresa un número de tarjeta válido.'),(11,'E302','data_entry','invalid parameter securityCode','Revisa el código de seguridad.'),(12,'316','data_entry','invalid parameter cardholderName','Ingresa un nombre válido.'),(13,'322','data_entry','	invalid parameter docType','El tipo de documento es inválido.'),(14,'323','data_entry','invalid parameter cardholder.document.subtype','Revisa tu documento.'),(15,'324','data_entry','invalid parameter docNumber','El documento es inválido.'),(16,'325','data_entry','invalid parameter cardExpirationMonth','El mes es inválido'),(17,'326','data_entry','invalid parameter cardExpirationYear','El año es inválido'),(18,'default','data_entry','Otro código de error','Revisa los datos.'),(19,'106','token_creation','Cannot operate between users from different countries','No puedes realizar pagos a otros países.'),(20,'109','token_creation','Invalid number of shares for this payment_method_id','El medio de pago no procesa pagos en installments cuotas. Elige otra tarjeta u otro medio de pago.'),(21,'126','token_creation','The action requested is not valid for the current payment state','No pudimos procesar tu pago.'),(22,'129','token_creation','Cannot pay this amount with this paymentMethod','El medio de pago no procesa pagos del monto seleccionado. Elige otra tarjeta u otro medio de pago.'),(23,'145','token_creation','Invalid users involved','Una de las partes con la que intentas hacer el pago es de prueba y la otra es usuario real.'),(24,'150','token_creation','The payer_id cannot do payments currently','No puedes realizar pagos.'),(25,'151','token_creation','The payer_id cannot do payments with this payment_method_id','No puedes realizar pagos.'),(26,'160','token_creation','Collector not allowed to operate','No pudimos procesar tu pago.'),(27,'204','token_creation','Unavailable payment_method','El medio de pago no está disponible en este momento. Elige otra tarjeta u otro medio de pago.'),(28,'801','token_creation','Already posted the same request in the last minute','Realizaste un pago similar hace instantes. Intenta de nuevo en unos minutos.'),(29,'default','token_creation','Otro código de error','No pudimos procesar tu pago.');
/*!40000 ALTER TABLE `client_errors` ENABLE KEYS */;
DROP TABLE IF EXISTS `columns_to_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `columns_to_reports` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `report` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `columns` json NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `columns_to_reports_user_id_foreign` (`user_id`),
  CONSTRAINT `columns_to_reports_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `columns_to_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `columns_to_reports` ENABLE KEYS */;
DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `identity_document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `trade_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `soap_send_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '01',
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `soap_username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `soap_password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `soap_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `certificate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `certificate_pass` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `certificate_due` date DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `detraction_account` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `app_logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo_store` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `favicon` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `img_firm` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `operation_amazonia` tinyint(1) NOT NULL DEFAULT '0',
  `integrated_query_client_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `integrated_query_client_secret` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_login_pse` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_pse` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_pse` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id_pse` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '8',
  `send_document_to_pse` tinyint(1) NOT NULL DEFAULT '0',
  `url_send_cdr_pse` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_signature_pse` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ws_api_phone_number_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ws_api_token` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `cod_digemid` text COLLATE utf8mb4_unicode_ci COMMENT 'Codigo de establecimiento DIGEMID',
  `rimpe_emp` tinyint(1) DEFAULT NULL,
  `rimpe_np` tinyint(1) DEFAULT NULL,
  `rise` tinyint(1) DEFAULT NULL,
  `contribuyente_especial` tinyint(1) DEFAULT NULL,
  `obligado_contabilidad` tinyint(1) DEFAULT NULL,
  `agente_retencion` tinyint(1) DEFAULT NULL,
  `agente_retencion_num` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contribuyente_especial_num` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ftpEmitidosServer` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ftpEmitidosPort` char(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ftpEmitidosUser` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ftpEmitidosPass` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ftpEmitidosRutaFac` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ftpEmitidosRutaNota` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ftpEmitidosRutaRetencion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emailLogo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tokenApi` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sql_host` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sql_pot` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sql_username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sql_password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sql_db` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sql_db2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active_icg` tinyint(1) NOT NULL DEFAULT '0',
  `extra_emails` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `companies_identity_document_type_id_foreign` (`identity_document_type_id`),
  KEY `companies_soap_type_id_foreign` (`soap_type_id`),
  CONSTRAINT `companies_identity_document_type_id_foreign` FOREIGN KEY (`identity_document_type_id`) REFERENCES `cat_identity_document_types` (`id`),
  CONSTRAINT `companies_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
DROP TABLE IF EXISTS `company_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_accounts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `subtotal_pen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_pen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `igv_pen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtotal_usd` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_usd` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `igv_usd` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `company_accounts` DISABLE KEYS */;
INSERT INTO `company_accounts` VALUES (1,'70111','12121','40111','70111','12122','40111');
/*!40000 ALTER TABLE `company_accounts` ENABLE KEYS */;
DROP TABLE IF EXISTS `configuration_ecommerce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuration_ecommerce` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `information_contact_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `information_contact_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `information_contact_phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `information_contact_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_whatsapp` text COLLATE utf8mb4_unicode_ci,
  `script_paypal` text COLLATE utf8mb4_unicode_ci,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `link_youtube` text COLLATE utf8mb4_unicode_ci,
  `link_twitter` text COLLATE utf8mb4_unicode_ci,
  `link_facebook` text COLLATE utf8mb4_unicode_ci,
  `tag_support` text COLLATE utf8mb4_unicode_ci,
  `tag_dollar` text COLLATE utf8mb4_unicode_ci,
  `tag_shipping` text COLLATE utf8mb4_unicode_ci,
  `token_public_culqui` text COLLATE utf8mb4_unicode_ci,
  `token_private_culqui` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `configuration_ecommerce` DISABLE KEYS */;
INSERT INTO `configuration_ecommerce` VALUES (1,'Admin','admin@mail.com','01 505-5555',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `configuration_ecommerce` ENABLE KEYS */;
DROP TABLE IF EXISTS `configuration_mi_tienda_pe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuration_mi_tienda_pe` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `establishment_id` int unsigned DEFAULT '1',
  `series_order_note_id` int unsigned DEFAULT '0',
  `series_document_ft_id` int unsigned DEFAULT '0',
  `series_document_bt_id` int unsigned DEFAULT '0',
  `user_id` int unsigned DEFAULT '0',
  `payment_destination_id` int unsigned DEFAULT '0',
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `autogenerate` tinyint unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `configuration_mi_tienda_pe` DISABLE KEYS */;
/*!40000 ALTER TABLE `configuration_mi_tienda_pe` ENABLE KEYS */;
DROP TABLE IF EXISTS `configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configurations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `send_auto` tinyint(1) NOT NULL,
  `formats` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `cron` tinyint(1) NOT NULL DEFAULT '1',
  `stock` tinyint(1) NOT NULL DEFAULT '1',
  `sunat_alternate_server` tinyint(1) NOT NULL DEFAULT '0',
  `limit_documents` bigint NOT NULL DEFAULT '0',
  `limit_users` bigint NOT NULL DEFAULT '10',
  `locked_emission` tinyint(1) NOT NULL DEFAULT '0',
  `permission_to_edit_cpe` tinyint(1) NOT NULL DEFAULT '0',
  `customer_filter_by_seller` tinyint(1) NOT NULL DEFAULT '0',
  `detraction_amount_rounded_int` tinyint(1) NOT NULL DEFAULT '0',
  `set_address_by_establishment` tinyint(1) NOT NULL DEFAULT '0',
  `plan` json DEFAULT NULL,
  `enable_whatsapp` tinyint(1) NOT NULL DEFAULT '1',
  `phone_whatsapp` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apk_url` text COLLATE utf8mb4_unicode_ci,
  `visual` json DEFAULT NULL,
  `decimal_quantity` tinyint NOT NULL DEFAULT '2',
  `locked_users` tinyint(1) NOT NULL DEFAULT '0',
  `date_time_start` datetime DEFAULT NULL,
  `quantity_documents` int NOT NULL,
  `quantity_sales_notes` int NOT NULL,
  `locked_tenant` tinyint(1) NOT NULL DEFAULT '0',
  `compact_sidebar` tinyint(1) NOT NULL DEFAULT '0',
  `amount_plastic_bag_taxes` decimal(6,2) NOT NULL DEFAULT '0.10',
  `config_system_env` tinyint(1) NOT NULL DEFAULT '1',
  `colums_grid_item` tinyint DEFAULT '4',
  `options_pos` tinyint(1) NOT NULL DEFAULT '1',
  `edit_name_product` tinyint(1) NOT NULL DEFAULT '1',
  `restrict_receipt_date` tinyint(1) NOT NULL DEFAULT '1',
  `shipping_time_days` int NOT NULL DEFAULT '4',
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '10',
  `global_discount_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '03',
  `include_igv` tinyint(1) DEFAULT NULL,
  `percentage_allowance_charge` decimal(12,2) DEFAULT '0.00',
  `igv_retention_percentage` decimal(8,5) NOT NULL DEFAULT '3.00000',
  `active_allowance_charge` tinyint(1) DEFAULT '0',
  `active_warehouse_prices` tinyint(1) DEFAULT '0',
  `product_only_location` tinyint(1) DEFAULT NULL,
  `terms_condition` text COLLATE utf8mb4_unicode_ci,
  `terms_condition_sale` text COLLATE utf8mb4_unicode_ci,
  `cotizaction_finance` tinyint(1) NOT NULL DEFAULT '1',
  `quotation_allow_seller_generate_sale` tinyint(1) NOT NULL DEFAULT '0',
  `allow_edit_unit_price_to_seller` tinyint(1) NOT NULL DEFAULT '0',
  `legend_footer` tinyint(1) NOT NULL DEFAULT '0',
  `header_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destination_sale` tinyint(1) NOT NULL DEFAULT '1',
  `default_document_type_03` tinyint(1) NOT NULL DEFAULT '1',
  `default_document_type_80` tinyint(1) NOT NULL DEFAULT '0',
  `search_item_by_barcode` tinyint(1) NOT NULL DEFAULT '0',
  `login` text COLLATE utf8mb4_unicode_ci,
  `navbar` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  `finances` text COLLATE utf8mb4_unicode_ci,
  `smtp_encryption` text COLLATE utf8mb4_unicode_ci COMMENT 'Tipo de cifrado de correo',
  `smtp_password` text COLLATE utf8mb4_unicode_ci COMMENT 'contraseña de usuario para el envio de correo',
  `smtp_user` text COLLATE utf8mb4_unicode_ci COMMENT 'Nombre de usuario para el envio de correo',
  `smtp_port` int unsigned NOT NULL DEFAULT '0' COMMENT 'Puerto de correo del cliente',
  `smtp_host` text COLLATE utf8mb4_unicode_ci COMMENT 'Host de correo del cliente',
  `ticket_58` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `url_apiruc` text COLLATE utf8mb4_unicode_ci,
  `token_apiruc` text COLLATE utf8mb4_unicode_ci,
  `seller_can_create_product` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Define si los vendedores pueden crear productos',
  `seller_can_view_balance` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Define si los vendedores pueden ver el balance en finanzas',
  `seller_can_generate_sale_opportunities` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Define si los vendedores pueden crear productos',
  `update_document_on_dispaches` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Si esta activo, al momento de crear una guia, se actualiza el pdf de documentos.',
  `is_pharmacy` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Establece si se activa el modulo de farmacia',
  `auto_send_dispatchs_to_sunat` tinyint DEFAULT '1' COMMENT 'define si se mandan las guias automaticamente a sunat',
  `send_data_to_other_server` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Habilita la posibilidad de enviar datos a otro servidor',
  `search_item_by_series` tinyint(1) NOT NULL DEFAULT '0',
  `mi_tienda_pe` tinyint(1) NOT NULL DEFAULT '0',
  `group_items_generate_document` tinyint(1) NOT NULL DEFAULT '1',
  `change_free_affectation_igv` tinyint(1) NOT NULL DEFAULT '0',
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'USD' COMMENT 'Id de cat_currency_types_id',
  `select_available_price_list` tinyint(1) NOT NULL DEFAULT '0',
  `show_extra_info_to_item` tinyint unsigned DEFAULT '0' COMMENT 'Habilita datos extra para item',
  `enabled_global_igv_to_purchase` tinyint unsigned DEFAULT '0' COMMENT 'Habilita el igv global en la compra. Sobreescribe has_igv del item',
  `show_pdf_name` tinyint unsigned DEFAULT '0' COMMENT 'Muestra el nombre de pdf en vez del producto',
  `dispatches_address_text` tinyint unsigned DEFAULT '0' COMMENT 'En guias, habilita colocar la direccion de destino como texto',
  `show_items_only_user_stablishment` int unsigned DEFAULT '1',
  `name_product_pdf_to_xml` tinyint(1) NOT NULL DEFAULT '0',
  `item_name_pdf_description` tinyint NOT NULL DEFAULT '0' COMMENT 'Si esta activado, el nombre de pdf será por defecto la descripcion del item',
  `auto_print` tinyint(1) NOT NULL DEFAULT '0',
  `show_service_on_pos` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Permite listar al inicio, los servicios en pos',
  `pos_cost_price` tinyint(1) NOT NULL DEFAULT '1',
  `pos_history` tinyint(1) NOT NULL DEFAULT '1',
  `show_totals_on_cpe_list` tinyint(1) NOT NULL DEFAULT '0',
  `show_terms_condition_pos` tinyint(1) NOT NULL DEFAULT '0',
  `show_ticket_80` tinyint(1) NOT NULL DEFAULT '1',
  `show_ticket_58` tinyint(1) NOT NULL DEFAULT '0',
  `show_ticket_50` tinyint(1) NOT NULL DEFAULT '0',
  `show_complete_name_pos` tinyint(1) NOT NULL DEFAULT '0',
  `show_last_price_sale` tinyint(1) NOT NULL DEFAULT '0',
  `show_logo_by_establishment` tinyint(1) NOT NULL DEFAULT '0',
  `print_new_line_to_observation` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Añade la posiblidad de colocar salto de linea en observación de pdf',
  `new_validator_pagination` mediumint unsigned DEFAULT '0',
  `validate_purchase_sale_unit_price` tinyint(1) NOT NULL DEFAULT '0',
  `checked_global_igv_to_purchase` tinyint(1) NOT NULL DEFAULT '0',
  `checked_update_purchase_price` tinyint(1) NOT NULL DEFAULT '0',
  `set_global_purchase_currency_items` tinyint(1) NOT NULL DEFAULT '0',
  `set_unit_price_dispatch_related_record` tinyint(1) NOT NULL DEFAULT '0',
  `restrict_voided_send` tinyint(1) NOT NULL DEFAULT '1',
  `shipping_time_days_voided` int NOT NULL DEFAULT '7',
  `enabled_tips_pos` tinyint(1) NOT NULL DEFAULT '0',
  `top_menu_a_id` int unsigned DEFAULT NULL,
  `top_menu_b_id` int unsigned DEFAULT NULL,
  `top_menu_c_id` int unsigned DEFAULT NULL,
  `top_menu_d_id` int unsigned DEFAULT NULL,
  `skin_id` int unsigned NOT NULL DEFAULT '1',
  `legend_forest_to_xml` tinyint(1) NOT NULL DEFAULT '0',
  `change_currency_item` tinyint(1) NOT NULL DEFAULT '0',
  `enabled_advanced_records_search` tinyint(1) NOT NULL DEFAULT '0',
  `change_decimal_quantity_unit_price_pdf` tinyint(1) NOT NULL DEFAULT '0',
  `decimal_quantity_unit_price_pdf` int NOT NULL DEFAULT '2',
  `separate_cash_transactions` tinyint(1) NOT NULL DEFAULT '0',
  `order_cash_income` tinyint(1) NOT NULL DEFAULT '0',
  `generate_order_note_from_quotation` tinyint(1) NOT NULL DEFAULT '0',
  `list_items_by_warehouse` tinyint(1) NOT NULL DEFAULT '0',
  `hide_pdf_view_documents` tinyint(1) NOT NULL DEFAULT '0',
  `ticket_single_shipment` tinyint(1) NOT NULL DEFAULT '0',
  `affect_all_documents` tinyint(1) NOT NULL DEFAULT '0',
  `dashboard_sales` tinyint(1) NOT NULL DEFAULT '1',
  `dashboard_general` tinyint(1) NOT NULL DEFAULT '1',
  `dashboard_clients` tinyint(1) NOT NULL DEFAULT '1',
  `dashboard_products` tinyint(1) NOT NULL DEFAULT '0',
  `restrict_series_selection_seller` tinyint(1) NOT NULL DEFAULT '0',
  `regex_password_user` tinyint(1) NOT NULL DEFAULT '0',
  `enabled_remember_change_password` tinyint(1) NOT NULL DEFAULT '0',
  `quantity_month_remember_change_password` int NOT NULL DEFAULT '1',
  `enabled_point_system` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'sistema por puntos',
  `point_system_sale_amount` decimal(12,2) NOT NULL DEFAULT '1.00' COMMENT 'sistema por puntos',
  `quantity_of_points` decimal(12,2) NOT NULL DEFAULT '1.00' COMMENT 'sistema por puntos',
  `round_points_of_sale` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'sistema por puntos',
  `enable_categories_products_view` tinyint(1) NOT NULL DEFAULT '0',
  `restrict_seller_discount` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'limitar descuento a los vendedores',
  `sellers_discount_limit` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'limitar descuento a los vendedores',
  `enabled_sales_agents` tinyint(1) NOT NULL DEFAULT '0',
  `change_affectation_exonerated_igv` tinyint(1) NOT NULL DEFAULT '0',
  `search_factory_code_items` tinyint(1) NOT NULL DEFAULT '0',
  `show_load_voucher` tinyint(1) NOT NULL DEFAULT '0',
  `register_series_invoice_xml` tinyint(1) NOT NULL DEFAULT '0',
  `enable_discount_by_customer` tinyint(1) NOT NULL DEFAULT '0',
  `enabled_dispatch_ticket_pdf` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `configurations` DISABLE KEYS */;
/*!40000 ALTER TABLE `configurations` ENABLE KEYS */;
DROP TABLE IF EXISTS `contract_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_value` decimal(16,6) NOT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(16,6) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  `name_product_pdf` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `contract_items_contract_id_foreign` (`contract_id`),
  KEY `contract_items_item_id_foreign` (`item_id`),
  KEY `contract_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `contract_items_system_isc_type_id_foreign` (`system_isc_type_id`),
  KEY `contract_items_price_type_id_foreign` (`price_type_id`),
  CONSTRAINT `contract_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `contract_items_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contract_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `contract_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `contract_items_system_isc_type_id_foreign` FOREIGN KEY (`system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `contract_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `contract_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `card_brand_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `change` decimal(12,2) DEFAULT NULL,
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contract_payments_contract_id_foreign` (`contract_id`),
  KEY `contract_payments_card_brand_id_foreign` (`card_brand_id`),
  KEY `contract_payments_payment_method_type_id_foreign` (`payment_method_type_id`),
  CONSTRAINT `contract_payments_card_brand_id_foreign` FOREIGN KEY (`card_brand_id`) REFERENCES `card_brands` (`id`),
  CONSTRAINT `contract_payments_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contract_payments_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `contract_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `contract_state_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_state_types` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `contract_state_types` DISABLE KEYS */;
INSERT INTO `contract_state_types` VALUES ('01','Registrado'),('05','Entregado'),('09','Rechazado');
/*!40000 ALTER TABLE `contract_state_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contracts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `seller_id` int unsigned DEFAULT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `date_of_due` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `shipping_address` text COLLATE utf8mb4_unicode_ci,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `total_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exportation` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `charges` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `guides` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `perception` json DEFAULT NULL,
  `detraction` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `terms_condition` text COLLATE utf8mb4_unicode_ci,
  `account_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `changed` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `quotation_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contracts_user_id_foreign` (`user_id`),
  KEY `contracts_establishment_id_foreign` (`establishment_id`),
  KEY `contracts_customer_id_foreign` (`customer_id`),
  KEY `contracts_soap_type_id_foreign` (`soap_type_id`),
  KEY `contracts_currency_type_id_foreign` (`currency_type_id`),
  KEY `contracts_payment_method_type_id_foreign` (`payment_method_type_id`),
  KEY `contracts_quotation_id_foreign` (`quotation_id`),
  KEY `contracts_state_type_id_foreign` (`state_type_id`),
  CONSTRAINT `contracts_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `contracts_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `contracts_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `contracts_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `contracts_quotation_id_foreign` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`),
  CONSTRAINT `contracts_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `contracts_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `contract_state_types` (`id`),
  CONSTRAINT `contracts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES ('AD','ANDORRA',1),('AE','UNITED ARAB EMIRATES',1),('AF','AFGHANISTAN',1),('AG','ANTIGUA AND BARBUDA',1),('AI','ANGUILLA',1),('AL','ALBANIA',1),('AM','ARMENIA',1),('AN','NETHERLANDS ANTILLES',1),('AO','ANGOLA',1),('AQ','ANTARCTICA',1),('AR','ARGENTINA',1),('AS','AMERICAN SAMOA',1),('AT','AUSTRIA',1),('AU','AUSTRALIA',1),('AW','ARUBA',1),('AX','AALAND ISLANDS',1),('AZ','AZERBAIJAN',1),('BA','BOSNIA AND HERZEGOWINA',1),('BB','BARBADOS',1),('BD','BANGLADESH',1),('BE','BELGIUM',1),('BF','BURKINA FASO',1),('BG','BULGARIA',1),('BH','BAHRAIN',1),('BI','BURUNDI',1),('BJ','BENIN',1),('BM','BERMUDA',1),('BN','BRUNEI DARUSSALAM',1),('BO','BOLIVIA',1),('BR','BRAZIL',1),('BS','BAHAMAS',1),('BT','BHUTAN',1),('BV','BOUVET ISLAND',1),('BW','BOTSWANA',1),('BY','BELARUS',1),('BZ','BELIZE',1),('CA','CANADA',1),('CC','COCOS (KEELING) ISLANDS',1),('CD','CONGO, Democratic Republic of (was Zaire)',1),('CF','CENTRAL AFRICAN REPUBLIC',1),('CG','CONGO, Republic of',1),('CH','SWITZERLAND',1),('CI','COTE D`IVOIRE',1),('CK','COOK ISLANDS',1),('CL','CHILE',1),('CM','CAMEROON',1),('CN','CHINA',1),('CO','COLOMBIA',1),('CR','COSTA RICA',1),('CS','SERBIA AND MONTENEGRO',1),('CU','CUBA',1),('CV','CAPE VERDE',1),('CX','CHRISTMAS ISLAND',1),('CY','CYPRUS',1),('CZ','CZECH REPUBLIC',1),('DE','GERMANY',1),('DJ','DJIBOUTI',1),('DK','DENMARK',1),('DM','DOMINICA',1),('DO','DOMINICAN REPUBLIC',1),('DZ','ALGERIA',1),('EC','ECUADOR',1),('EE','ESTONIA',1),('EG','EGYPT',1),('EH','WESTERN SAHARA',1),('ER','ERITREA',1),('ES','SPAIN',1),('ET','ETHIOPIA',1),('FI','FINLAND',1),('FJ','FIJI',1),('FK','FALKLAND ISLANDS (MALVINAS)',1),('FM','MICRONESIA, FEDERATED STATES OF',1),('FO','FAROE ISLANDS',1),('FR','FRANCE',1),('GA','GABON',1),('GB','UNITED KINGDOM',1),('GD','GRENADA',1),('GE','GEORGIA',1),('GF','FRENCH GUIANA',1),('GH','GHANA',1),('GI','GIBRALTAR',1),('GL','GREENLAND',1),('GM','GAMBIA',1),('GN','GUINEA',1),('GP','GUADELOUPE',1),('GQ','EQUATORIAL GUINEA',1),('GR','GREECE',1),('GS','SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS',1),('GT','GUATEMALA',1),('GU','GUAM',1),('GW','GUINEA-BISSAU',1),('GY','GUYANA',1),('HK','HONG KONG',1),('HM','HEARD AND MC DONALD ISLANDS',1),('HN','HONDURAS',1),('HR','CROATIA (local name: Hrvatska)',1),('HT','HAITI',1),('HU','HUNGARY',1),('ID','INDONESIA',1),('IE','IRELAND',1),('IL','ISRAEL',1),('IN','INDIA',1),('IO','BRITISH INDIAN OCEAN TERRITORY',1),('IQ','IRAQ',1),('IR','IRAN (ISLAMIC REPUBLIC OF)',1),('IS','ICELAND',1),('IT','ITALY',1),('JM','JAMAICA',1),('JO','JORDAN',1),('JP','JAPAN',1),('KE','KENYA',1),('KG','KYRGYZSTAN',1),('KH','CAMBODIA',1),('KI','KIRIBATI',1),('KM','COMOROS',1),('KN','SAINT KITTS AND NEVIS',1),('KP','KOREA, DEMOCRATIC PEOPLE`S REPUBLIC OF',1),('KR','KOREA, REPUBLIC OF',1),('KW','KUWAIT',1),('KY','CAYMAN ISLANDS',1),('KZ','KAZAKHSTAN',1),('LA','LAO PEOPLE`S DEMOCRATIC REPUBLIC',1),('LB','LEBANON',1),('LC','SAINT LUCIA',1),('LI','LIECHTENSTEIN',1),('LK','SRI LANKA',1),('LR','LIBERIA',1),('LS','LESOTHO',1),('LT','LITHUANIA',1),('LU','LUXEMBOURG',1),('LV','LATVIA',1),('LY','LIBYAN ARAB JAMAHIRIYA',1),('MA','MOROCCO',1),('MC','MONACO',1),('MD','MOLDOVA, REPUBLIC OF',1),('MG','MADAGASCAR',1),('MH','MARSHALL ISLANDS',1),('MK','MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF',1),('ML','MALI',1),('MM','MYANMAR',1),('MN','MONGOLIA',1),('MO','MACAU',1),('MP','NORTHERN MARIANA ISLANDS',1),('MQ','MARTINIQUE',1),('MR','MAURITANIA',1),('MS','MONTSERRAT',1),('MT','MALTA',1),('MU','MAURITIUS',1),('MV','MALDIVES',1),('MW','MALAWI',1),('MX','MEXICO',1),('MY','MALAYSIA',1),('MZ','MOZAMBIQUE',1),('NA','NAMIBIA',1),('NC','NEW CALEDONIA',1),('NE','NIGER',1),('NF','NORFOLK ISLAND',1),('NG','NIGERIA',1),('NI','NICARAGUA',1),('NL','NETHERLANDS',1),('NO','NORWAY',1),('NP','NEPAL',1),('NR','NAURU',1),('NU','NIUE',1),('NZ','NEW ZEALAND',1),('OM','OMAN',1),('PA','PANAMA',1),('PE','PERU',1),('PF','FRENCH POLYNESIA',1),('PG','PAPUA NEW GUINEA',1),('PH','PHILIPPINES',1),('PK','PAKISTAN',1),('PL','POLAND',1),('PM','SAINT PIERRE AND MIQUELON',1),('PN','PITCAIRN',1),('PR','PUERTO RICO',1),('PS','PALESTINIAN TERRITORY, Occupied',1),('PT','PORTUGAL',1),('PW','PALAU',1),('PY','PARAGUAY',1),('QA','QATAR',1),('RE','REUNION',1),('RO','ROMANIA',1),('RU','RUSSIAN FEDERATION',1),('RW','RWANDA',1),('SA','SAUDI ARABIA',1),('SB','SOLOMON ISLANDS',1),('SC','SEYCHELLES',1),('SD','SUDAN',1),('SE','SWEDEN',1),('SG','SINGAPORE',1),('SH','SAINT HELENA',1),('SI','SLOVENIA',1),('SJ','SVALBARD AND JAN MAYEN ISLANDS',1),('SK','SLOVAKIA',1),('SL','SIERRA LEONE',1),('SM','SAN MARINO',1),('SN','SENEGAL',1),('SO','SOMALIA',1),('SR','SURINAME',1),('ST','SAO TOME AND PRINCIPE',1),('SV','EL SALVADOR',1),('SY','SYRIAN ARAB REPUBLIC',1),('SZ','SWAZILAND',1),('TC','TURKS AND CAICOS ISLANDS',1),('TD','CHAD',1),('TF','FRENCH SOUTHERN TERRITORIES',1),('TG','TOGO',1),('TH','THAILAND',1),('TJ','TAJIKISTAN',1),('TK','TOKELAU',1),('TL','TIMOR-LESTE',1),('TM','TURKMENISTAN',1),('TN','TUNISIA',1),('TO','TONGA',1),('TR','TURKEY',1),('TT','TRINIDAD AND TOBAGO',1),('TV','TUVALU',1),('TW','TAIWAN',1),('TZ','TANZANIA, UNITED REPUBLIC OF',1),('UA','UKRAINE',1),('UG','UGANDA',1),('UM','UNITED STATES MINOR OUTLYING ISLANDS',1),('US','UNITED STATES',1),('UY','URUGUAY',1),('UZ','UZBEKISTAN',1),('VA','VATICAN CITY STATE (HOLY SEE)',1),('VC','SAINT VINCENT AND THE GRENADINES',1),('VE','VENEZUELA',1),('VG','VIRGIN ISLANDS (BRITISH)',1),('VI','VIRGIN ISLANDS (U.S.)',1),('VN','VIET NAM',1),('VU','VANUATU',1),('WF','WALLIS AND FUTUNA ISLANDS',1),('WS','SAMOA',1),('YE','YEMEN',1),('YT','MAYOTTE',1),('ZA','SOUTH AFRICA',1),('ZM','ZAMBIA',1),('ZW','ZIMBABWE',1);
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES ('01','AZUAY',1),('02','BOLIVAR',1),('03','CAÑAR',1),('04','CARCHI',1),('05','COTOPAXI',1),('06','CHIMBORAZO',1),('07','EL ORO',1),('08','ESMERALDAS',1),('09','GUAYAS',1),('10','IMBABURA',1),('11','LOJA',1),('12','LOS RIOS',1),('13','MANABI',1),('14','MORONA SANTIAGO',1),('15','NAPO',1),('16','PASTAZA',1),('17','PICHINCHA',1),('18','TUNGURAHUA',1),('19','ZAMORA CHINCHIPE',1),('20','GALAPAGOS',1),('21','SUCUMBIOS',1),('22','ORELLANA',1),('23','SANTO DOMINGO DE LOS TSACHILAS',1),('24','SANTA ELENA',1),('90','OTROS',1);
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
DROP TABLE IF EXISTS `destinatarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `destinatarios` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `identificacion` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `docAduaneroUnico` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codEstablecimiento` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruta` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codDocSustento` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numDocSustento` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numAutDocSustento` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaEmisionDocSustento` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_documento` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `destinatarios_id_documento_foreign` (`id_documento`),
  CONSTRAINT `destinatarios_id_documento_foreign` FOREIGN KEY (`id_documento`) REFERENCES `cabecera_documento_electronicas` (`idComporbante`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `destinatarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `destinatarios` ENABLE KEYS */;
DROP TABLE IF EXISTS `destinatarios_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `destinatarios_detalle` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codItem` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codAdicional` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` double NOT NULL,
  `adicionales` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_destinatario` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `destinatarios_detalle_id_destinatario_foreign` (`id_destinatario`),
  CONSTRAINT `destinatarios_detalle_id_destinatario_foreign` FOREIGN KEY (`id_destinatario`) REFERENCES `destinatarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `destinatarios_detalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `destinatarios_detalle` ENABLE KEYS */;
DROP TABLE IF EXISTS `detalle_factura_electronicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_factura_electronicas` (
  `idComporbante` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` double NOT NULL,
  `item` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codItem` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '001',
  `precioUnitario` double NOT NULL,
  `total` double NOT NULL,
  `iva` int NOT NULL DEFAULT '12',
  `ice` int NOT NULL DEFAULT '0',
  `irbpnr` int NOT NULL DEFAULT '0',
  `codigoIce` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '3',
  `codigoPorcentajeIce` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `baseImponibleIce` double NOT NULL DEFAULT '0',
  `tarifaIce` double NOT NULL DEFAULT '0',
  `valorIce` double NOT NULL DEFAULT '0',
  `codigoIrbpnr` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '5',
  `codigoPorcentajeIrbpnr` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `baseImponibleIrbpnr` double NOT NULL DEFAULT '0',
  `tarifaIrbpnr` double NOT NULL DEFAULT '0',
  `valorIrbpnr` double NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `idLinea` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descuento` double DEFAULT '0',
  `iva_code` int unsigned DEFAULT NULL,
  `lote` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creado` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_vencimiento` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  UNIQUE KEY `detalle_factura_electronicas_idlinea_unique` (`idLinea`),
  KEY `detalle_factura_electronicas_idcomporbante_foreign` (`idComporbante`),
  CONSTRAINT `detalle_factura_electronicas_idcomporbante_foreign` FOREIGN KEY (`idComporbante`) REFERENCES `cabecera_documento_electronicas` (`idComporbante`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `detalle_factura_electronicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_factura_electronicas` ENABLE KEYS */;
DROP TABLE IF EXISTS `detalle_retencion_electronicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_retencion_electronicas` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `idComporbante` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigoRet` char(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `baseRet` double NOT NULL,
  `porcentajeRet` double NOT NULL,
  `valorRet` double NOT NULL,
  `tipoDocAfectado` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serieDocAfectado` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaDocAfectado` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `idLinea` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaPagoDiv` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `imRentaSoc` decimal(12,8) DEFAULT NULL,
  `ejerFisUtDiv` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `detalle_retencion_electronicas_idlinea_unique` (`idLinea`),
  KEY `detalle_retencion_electronicas_idcomporbante_foreign` (`idComporbante`),
  CONSTRAINT `detalle_retencion_electronicas_idcomporbante_foreign` FOREIGN KEY (`idComporbante`) REFERENCES `cabecera_documento_electronicas` (`idComporbante`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `detalle_retencion_electronicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_retencion_electronicas` ENABLE KEYS */;
DROP TABLE IF EXISTS `devolution_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devolution_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `devolution_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `devolution_items_devolution_id_foreign` (`devolution_id`),
  KEY `devolution_items_item_id_foreign` (`item_id`),
  CONSTRAINT `devolution_items_devolution_id_foreign` FOREIGN KEY (`devolution_id`) REFERENCES `devolutions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `devolution_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `devolution_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `devolution_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `devolution_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devolution_reasons` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `devolution_reasons` DISABLE KEYS */;
INSERT INTO `devolution_reasons` VALUES (1,'Productos vencidos',NULL,NULL),(2,'Productos dañados',NULL,NULL),(3,'Productos con errores de Fábrica',NULL,NULL);
/*!40000 ALTER TABLE `devolution_reasons` ENABLE KEYS */;
DROP TABLE IF EXISTS `devolutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devolutions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `devolution_reason_id` int unsigned NOT NULL,
  `observation` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `devolutions_user_id_foreign` (`user_id`),
  KEY `devolutions_establishment_id_foreign` (`establishment_id`),
  KEY `devolutions_devolution_reason_id_foreign` (`devolution_reason_id`),
  KEY `devolutions_soap_type_id_foreign` (`soap_type_id`),
  KEY `devolutions_state_type_id_foreign` (`state_type_id`),
  CONSTRAINT `devolutions_devolution_reason_id_foreign` FOREIGN KEY (`devolution_reason_id`) REFERENCES `devolution_reasons` (`id`),
  CONSTRAINT `devolutions_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `devolutions_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `devolutions_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `devolutions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `devolutions` DISABLE KEYS */;
/*!40000 ALTER TABLE `devolutions` ENABLE KEYS */;
DROP TABLE IF EXISTS `dispatch_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispatch_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `dispatch_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `name_product_pdf` longtext COLLATE utf8mb4_unicode_ci,
  `additional_data` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dispatch_items_dispatch_id_foreign` (`dispatch_id`),
  KEY `dispatch_items_item_id_foreign` (`item_id`),
  CONSTRAINT `dispatch_items_dispatch_id_foreign` FOREIGN KEY (`dispatch_id`) REFERENCES `dispatches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `dispatch_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dispatch_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispatch_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `dispatchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispatchers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `identity_document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dispatchers_identity_document_type_id_foreign` (`identity_document_type_id`),
  KEY `dispatchers_number_index` (`number`),
  KEY `dispatchers_name_index` (`name`),
  CONSTRAINT `dispatchers_identity_document_type_id_foreign` FOREIGN KEY (`identity_document_type_id`) REFERENCES `cat_identity_document_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dispatchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispatchers` ENABLE KEYS */;
DROP TABLE IF EXISTS `dispatches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispatches` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clave_SRI` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubl_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_sale_note_id` int unsigned DEFAULT NULL,
  `reference_document_id` int unsigned DEFAULT NULL,
  `reference_quotation_id` int unsigned DEFAULT NULL,
  `reference_order_form_id` int unsigned DEFAULT NULL,
  `reference_order_note_id` int unsigned DEFAULT NULL,
  `series` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `observations` text COLLATE utf8mb4_unicode_ci,
  `transport_mode_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transfer_reason_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transfer_reason_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_shipping` date NOT NULL,
  `transshipment_indicator` tinyint(1) NOT NULL,
  `port_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_weight` decimal(10,2) NOT NULL,
  `packages_number` int DEFAULT NULL,
  `container_number` int DEFAULT NULL,
  `related` json DEFAULT NULL COMMENT 'Numero de DAM',
  `origin` json NOT NULL,
  `delivery` json NOT NULL,
  `dispatcher` json DEFAULT NULL,
  `driver` json DEFAULT NULL,
  `order_form_external` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `license_plate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `secondary_license_plates` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `optional` json DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `soap_shipping_response` json DEFAULT NULL,
  `send_to_pse` tinyint(1) NOT NULL DEFAULT '0',
  `response_signature_pse` json DEFAULT NULL,
  `response_send_cdr_pse` json DEFAULT NULL,
  `has_xml` tinyint(1) NOT NULL DEFAULT '0',
  `has_pdf` tinyint(1) NOT NULL DEFAULT '0',
  `has_cdr` tinyint(1) NOT NULL DEFAULT '0',
  `document_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `data_affected_document` longtext COLLATE utf8mb4_unicode_ci,
  `terms_condition` text COLLATE utf8mb4_unicode_ci,
  `additional_data` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dispatches_user_id_foreign` (`user_id`),
  KEY `dispatches_establishment_id_foreign` (`establishment_id`),
  KEY `dispatches_soap_type_id_foreign` (`soap_type_id`),
  KEY `dispatches_state_type_id_foreign` (`state_type_id`),
  KEY `dispatches_document_type_id_foreign` (`document_type_id`),
  KEY `dispatches_customer_id_foreign` (`customer_id`),
  KEY `dispatches_unit_type_id_foreign` (`unit_type_id`),
  KEY `dispatches_transport_mode_type_id_foreign` (`transport_mode_type_id`),
  KEY `dispatches_transfer_reason_type_id_foreign` (`transfer_reason_type_id`),
  KEY `dispatches_document_id_foreign` (`document_id`),
  CONSTRAINT `dispatches_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `dispatches_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `dispatches_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `dispatches_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `dispatches_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `dispatches_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `dispatches_transfer_reason_type_id_foreign` FOREIGN KEY (`transfer_reason_type_id`) REFERENCES `cat_transfer_reason_types` (`id`),
  CONSTRAINT `dispatches_transport_mode_type_id_foreign` FOREIGN KEY (`transport_mode_type_id`) REFERENCES `cat_transport_mode_types` (`id`),
  CONSTRAINT `dispatches_unit_type_id_foreign` FOREIGN KEY (`unit_type_id`) REFERENCES `cat_unit_types` (`id`),
  CONSTRAINT `dispatches_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `dispatches` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispatches` ENABLE KEYS */;
DROP TABLE IF EXISTS `districts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `districts` (
  `id` char(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `province_id` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `districts_province_id_foreign` (`province_id`),
  CONSTRAINT `districts_province_id_foreign` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `districts` DISABLE KEYS */;
INSERT INTO `districts` VALUES ('010101','0101',' BELLAVISTA',1),('010102','0101',' CAÑARIBAMBA',1),('010103','0101',' EL BATÁN',1),('010104','0101',' EL SAGRARIO',1),('010105','0101',' EL VECINO',1),('010106','0101',' GIL RAMÍREZ DÁVALOS',1),('010107','0101',' HUAYNACÁPAC',1),('010108','0101',' MACHÁNGARA',1),('010109','0101',' MONAY',1),('010110','0101',' SAN BLAS',1),('010111','0101',' SAN SEBASTIÁN',1),('010112','0101',' SUCRE',1),('010113','0101',' TOTORACOCHA',1),('010114','0101',' YANUNCAY',1),('010115','0101',' HERMANO MIGUEL',1),('010150','0101',' CUENCA',1),('010151','0101',' BAÑOS',1),('010152','0101',' CUMBE',1),('010153','0101',' CHAUCHA',1),('010154','0101',' CHECA (JIDCAY)',1),('010155','0101',' CHIQUINTAD',1),('010156','0101',' LLACAO',1),('010157','0101',' MOLLETURO',1),('010158','0101',' NULTI',1),('010159','0101',' OCTAVIO CORDERO PALACIOS (S',1),('010160','0101',' PACCHA',1),('010161','0101',' QUINGEO',1),('010162','0101',' RICAURTE',1),('010163','0101',' SAN JOAQUÍN',1),('010164','0101',' SANTA ANA',1),('010165','0101',' SAYAUSÍ',1),('010166','0101',' SIDCAY',1),('010167','0101',' SININCAY',1),('010168','0101',' TARQUI',1),('010169','0101',' TURI',1),('010170','0101',' VALLE',1),('010171','0101',' VICTORIA DEL PORTETE (IRQUI',1),('010250','0102',' GIRÓN',1),('010251','0102',' ASUNCIÓN',1),('010252','0102',' SAN GERARDO',1),('010350','0103',' GUALACEO',1),('010351','0103',' CHORDELEG',1),('010352','0103',' DANIEL CÓRDOVA TORAL (EL OR',1),('010353','0103',' JADÁN',1),('010354','0103',' MARIANO MORENO',1),('010355','0103',' PRINCIPAL',1),('010356','0103',' REMIGIO CRESPO TORAL (GÚLAG',1),('010357','0103',' SAN JUAN',1),('010358','0103',' ZHIDMAD',1),('010359','0103',' LUIS CORDERO VEGA',1),('010360','0103',' SIMÓN BOLÍVAR (CAB. EN GAÑA',1),('010450','0104',' NABÓN',1),('010451','0104',' COCHAPATA',1),('010452','0104',' EL PROGRESO (CAB.EN ZHOTA)',1),('010453','0104',' LAS NIEVES (CHAYA)',1),('010454','0104',' OÑA',1),('010550','0105',' PAUTE',1),('010551','0105',' AMALUZA',1),('010552','0105',' BULÁN (JOSÉ VÍCTOR IZQUIERD',1),('010553','0105',' CHICÁN (GUILLERMO ORTEGA)',1),('010554','0105',' EL CABO',1),('010555','0105',' GUACHAPALA',1),('010556','0105',' GUARAINAG',1),('010557','0105',' PALMAS',1),('010558','0105',' PAN',1),('010559','0105',' SAN CRISTÓBAL (CARLOS ORDÓÑ',1),('010560','0105',' SEVILLA DE ORO',1),('010561','0105',' TOMEBAMBA',1),('010562','0105',' DUG DUG',1),('010650','0106',' PUCARÁ',1),('010651','0106',' CAMILO PONCE ENRÍQUEZ (CAB.',1),('010652','0106',' SAN RAFAEL DE SHARUG',1),('010750','0107',' SAN FERNANDO',1),('010751','0107',' CHUMBLÍN',1),('010850','0108',' SANTA ISABEL (CHAGUARURCO)',1),('010851','0108',' ABDÓN CALDERÓN (LA UNIÓN)',1),('010852','0108',' EL CARMEN DE PIJILÍ',1),('010853','0108',' ZHAGLLI (SHAGLLI)',1),('010854','0108',' SAN SALVADOR DE CAÑARIBAMBA',1),('010950','0109',' SIGSIG',1),('010951','0109',' CUCHIL (CUTCHIL)',1),('010952','0109',' GIMA',1),('010953','0109',' GUEL',1),('010954','0109',' LUDO',1),('010955','0109',' SAN BARTOLOMÉ',1),('010956','0109',' SAN JOSÉ DE RARANGA',1),('011050','0110',' SAN FELIPE DE OÑA CABECERA ',1),('011051','0110',' SUSUDEL',1),('011150','0111',' CHORDELEG',1),('011151','0111',' PRINCIPAL',1),('011152','0111',' LA UNIÓN',1),('011153','0111',' LUIS GALARZA ORELLANA (CAB.',1),('011154','0111',' SAN MARTÍN DE PUZHIO',1),('011250','0112',' EL PAN',1),('011251','0112',' AMALUZA',1),('011252','0112',' PALMAS',1),('011253','0112',' SAN VICENTE',1),('011350','0113',' SEVILLA DE ORO',1),('011351','0113',' AMALUZA',1),('011352','0113',' PALMAS',1),('011450','0114',' GUACHAPALA',1),('011550','0115',' CAMILO PONCE ENRÍQUEZ',1),('011551','0115',' EL CARMEN DE PIJILÍ',1),('020101','0201',' ÁNGEL POLIBIO CHÁVES',1),('020102','0201',' GABRIEL IGNACIO VEINTIMILLA',1),('020103','0201',' GUANUJO',1),('020150','0201',' GUARANDA',1),('020151','0201',' FACUNDO VELA',1),('020152','0201',' GUANUJO',1),('020153','0201',' JULIO E. MORENO (CATANAHUÁN',1),('020154','0201',' LAS NAVES',1),('020155','0201',' SALINAS',1),('020156','0201',' SAN LORENZO',1),('020157','0201',' SAN SIMÓN (YACOTO)',1),('020158','0201',' SANTA FÉ (SANTA FÉ)',1),('020159','0201',' SIMIÁTUG',1),('020160','0201',' SAN LUIS DE PAMBIL',1),('020250','0202',' CHILLANES',1),('020251','0202',' SAN JOSÉ DEL TAMBO (TAMBOPA',1),('020350','0203',' SAN JOSÉ DE CHIMBO',1),('020351','0203',' ASUNCIÓN (ASANCOTO)',1),('020352','0203',' CALUMA',1),('020353','0203',' MAGDALENA (CHAPACOTO)',1),('020354','0203',' SAN SEBASTIÁN',1),('020355','0203',' TELIMBELA',1),('020450','0204',' ECHEANDÍA',1),('020550','0205',' SAN MIGUEL',1),('020551','0205',' BALSAPAMBA',1),('020552','0205',' BILOVÁN',1),('020553','0205',' RÉGULO DE MORA',1),('020554','0205',' SAN PABLO (SAN PABLO DE ATE',1),('020555','0205',' SANTIAGO',1),('020556','0205',' SAN VICENTE',1),('020650','0206',' CALUMA',1),('020701','0207',' LAS MERCEDES',1),('020702','0207',' LAS NAVES',1),('020750','0207',' LAS NAVES',1),('030101','0301',' AURELIO BAYAS MARTÍNEZ',1),('030102','0301',' AZOGUES',1),('030103','0301',' BORRERO',1),('030104','0301',' SAN FRANCISCO',1),('030150','0301',' AZOGUES',1),('030151','0301',' COJITAMBO',1),('030152','0301',' DÉLEG',1),('030153','0301',' GUAPÁN',1),('030154','0301',' JAVIER LOYOLA (CHUQUIPATA)',1),('030155','0301',' LUIS CORDERO',1),('030156','0301',' PINDILIG',1),('030157','0301',' RIVERA',1),('030158','0301',' SAN MIGUEL',1),('030159','0301',' SOLANO',1),('030160','0301',' TADAY',1),('030250','0302',' BIBLIÁN',1),('030251','0302',' NAZÓN (CAB. EN PAMPA DE DOM',1),('030252','0302',' SAN FRANCISCO DE SAGEO',1),('030253','0302',' TURUPAMBA',1),('030254','0302',' JERUSALÉN',1),('030350','0303',' CAÑAR',1),('030351','0303',' CHONTAMARCA',1),('030352','0303',' CHOROCOPTE',1),('030353','0303',' GENERAL MORALES (SOCARTE)',1),('030354','0303',' GUALLETURO',1),('030355','0303',' HONORATO VÁSQUEZ (TAMBO VIE',1),('030356','0303',' INGAPIRCA',1),('030357','0303',' JUNCAL',1),('030358','0303',' SAN ANTONIO',1),('030359','0303',' SUSCAL',1),('030360','0303',' TAMBO',1),('030361','0303',' ZHUD',1),('030362','0303',' VENTURA',1),('030363','0303',' DUCUR',1),('030450','0304',' LA TRONCAL',1),('030451','0304',' MANUEL J. CALLE',1),('030452','0304',' PANCHO NEGRO',1),('030550','0305',' EL TAMBO',1),('030650','0306',' DÉLEG',1),('030651','0306',' SOLANO',1),('030750','0307',' SUSCAL',1),('040101','0401',' GONZÁLEZ SUÁREZ',1),('040102','0401',' TULCÁN',1),('040150','0401',' TULCÁN',1),('040151','0401',' EL CARMELO (EL PUN)',1),('040152','0401',' HUACA',1),('040153','0401',' JULIO ANDRADE (OREJUELA)',1),('040154','0401',' MALDONADO',1),('040155','0401',' PIOTER',1),('040156','0401',' TOBAR DONOSO (LA BOCANA DE ',1),('040157','0401',' TUFIÑO',1),('040158','0401',' URBINA (TAYA)',1),('040159','0401',' EL CHICAL',1),('040160','0401',' MARISCAL SUCRE',1),('040161','0401',' SANTA MARTHA DE CUBA',1),('040250','0402',' BOLÍVAR',1),('040251','0402',' GARCÍA MORENO',1),('040252','0402',' LOS ANDES',1),('040253','0402',' MONTE OLIVO',1),('040254','0402',' SAN VICENTE DE PUSIR',1),('040255','0402',' SAN RAFAEL',1),('040301','0403',' EL ÁNGEL',1),('040302','0403',' 27 DE SEPTIEMBRE',1),('040350','0403',' EL ANGEL',1),('040351','0403',' EL GOALTAL',1),('040352','0403',' LA LIBERTAD (ALIZO)',1),('040353','0403',' SAN ISIDRO',1),('040450','0404',' MIRA (CHONTAHUASI)',1),('040451','0404',' CONCEPCIÓN',1),('040452','0404',' JIJÓN Y CAAMAÑO (CAB. EN RÍ',1),('040453','0404',' JUAN MONTALVO (SAN IGNACIO ',1),('040501','0405',' GONZÁLEZ SUÁREZ',1),('040502','0405',' SAN JOSÉ',1),('040550','0405',' SAN GABRIEL',1),('040551','0405',' CRISTÓBAL COLÓN',1),('040552','0405',' CHITÁN DE NAVARRETE',1),('040553','0405',' FERNÁNDEZ SALVADOR',1),('040554','0405',' LA PAZ',1),('040555','0405',' PIARTAL',1),('040650','0406',' HUACA',1),('040651','0406',' MARISCAL SUCRE',1),('050101','0501',' ELOY ALFARO (SAN FELIPE)',1),('050102','0501',' IGNACIO FLORES (PARQUE FLOR',1),('050103','0501',' JUAN MONTALVO (SAN SEBASTIÁ',1),('050104','0501',' LA MATRIZ',1),('050105','0501',' SAN BUENAVENTURA',1),('050150','0501',' LATACUNGA',1),('050151','0501',' ALAQUES (ALÁQUEZ)',1),('050152','0501',' BELISARIO QUEVEDO (GUANAILÍ',1),('050153','0501',' GUAITACAMA (GUAYTACAMA)',1),('050154','0501',' JOSEGUANGO BAJO',1),('050155','0501',' LAS PAMPAS',1),('050156','0501',' MULALÓ',1),('050157','0501',' 11 DE NOVIEMBRE (ILINCHISI)',1),('050158','0501',' POALÓ',1),('050159','0501',' SAN JUAN DE PASTOCALLE',1),('050160','0501',' SIGCHOS',1),('050161','0501',' TANICUCHÍ',1),('050162','0501',' TOACASO',1),('050163','0501',' PALO QUEMADO',1),('050201','0502',' EL CARMEN',1),('050202','0502',' LA MANÁ',1),('050203','0502',' EL TRIUNFO',1),('050250','0502',' LA MANÁ',1),('050251','0502',' GUASAGANDA (CAB.EN GUASAGAN',1),('050252','0502',' PUCAYACU',1),('050350','0503',' EL CORAZÓN',1),('050351','0503',' MORASPUNGO',1),('050352','0503',' PINLLOPATA',1),('050353','0503',' RAMÓN CAMPAÑA',1),('050450','0504',' PUJILÍ',1),('050451','0504',' ANGAMARCA',1),('050452','0504',' CHUCCHILÁN (CHUGCHILÁN)',1),('050453','0504',' GUANGAJE',1),('050454','0504',' ISINLIBÍ (ISINLIVÍ)',1),('050455','0504',' LA VICTORIA',1),('050456','0504',' PILALÓ',1),('050457','0504',' TINGO',1),('050458','0504',' ZUMBAHUA',1),('050550','0505',' SAN MIGUEL',1),('050551','0505',' ANTONIO JOSÉ HOLGUÍN (SANTA',1),('050552','0505',' CUSUBAMBA',1),('050553','0505',' MULALILLO',1),('050554','0505',' MULLIQUINDIL (SANTA ANA)',1),('050555','0505',' PANSALEO',1),('050650','0506',' SAQUISILÍ',1),('050651','0506',' CANCHAGUA',1),('050652','0506',' CHANTILÍN',1),('050653','0506',' COCHAPAMBA',1),('050750','0507',' SIGCHOS',1),('050751','0507',' CHUGCHILLÁN',1),('050752','0507',' ISINLIVÍ',1),('050753','0507',' LAS PAMPAS',1),('050754','0507',' PALO QUEMADO',1),('060101','0601',' LIZARZABURU',1),('060102','0601',' MALDONADO',1),('060103','0601',' VELASCO',1),('060104','0601',' VELOZ',1),('060105','0601',' YARUQUÍES',1),('060150','0601',' RIOBAMBA',1),('060151','0601',' CACHA (CAB. EN MACHÁNGARA)',1),('060152','0601',' CALPI',1),('060153','0601',' CUBIJÍES',1),('060154','0601',' FLORES',1),('060155','0601',' LICÁN',1),('060156','0601',' LICTO',1),('060157','0601',' PUNGALÁ',1),('060158','0601',' PUNÍN',1),('060159','0601',' QUIMIAG',1),('060160','0601',' SAN JUAN',1),('060161','0601',' SAN LUIS',1),('060250','0602',' ALAUSÍ',1),('060251','0602',' ACHUPALLAS',1),('060252','0602',' CUMANDÁ',1),('060253','0602',' GUASUNTOS',1),('060254','0602',' HUIGRA',1),('060255','0602',' MULTITUD',1),('060256','0602',' PISTISHÍ (NARIZ DEL DIABLO)',1),('060257','0602',' PUMALLACTA',1),('060258','0602',' SEVILLA',1),('060259','0602',' SIBAMBE',1),('060260','0602',' TIXÁN',1),('060301','0603',' CAJABAMBA',1),('060302','0603',' SICALPA',1),('060350','0603',' VILLA LA UNIÓN (CAJABAMBA)',1),('060351','0603',' CAÑI',1),('060352','0603',' COLUMBE',1),('060353','0603',' JUAN DE VELASCO (PANGOR)',1),('060354','0603',' SANTIAGO DE QUITO (CAB. EN ',1),('060450','0604',' CHAMBO',1),('060550','0605',' CHUNCHI',1),('060551','0605',' CAPZOL',1),('060552','0605',' COMPUD',1),('060553','0605',' GONZOL',1),('060554','0605',' LLAGOS',1),('060650','0606',' GUAMOTE',1),('060651','0606',' CEBADAS',1),('060652','0606',' PALMIRA',1),('060701','0607',' EL ROSARIO',1),('060702','0607',' LA MATRIZ',1),('060750','0607',' GUANO',1),('060751','0607',' GUANANDO',1),('060752','0607',' ILAPO',1),('060753','0607',' LA PROVIDENCIA',1),('060754','0607',' SAN ANDRÉS',1),('060755','0607',' SAN GERARDO DE PACAICAGUÁN',1),('060756','0607',' SAN ISIDRO DE PATULÚ',1),('060757','0607',' SAN JOSÉ DEL CHAZO',1),('060758','0607',' SANTA FÉ DE GALÁN',1),('060759','0607',' VALPARAÍSO',1),('060850','0608',' PALLATANGA',1),('060950','0609',' PENIPE',1),('060951','0609',' EL ALTAR',1),('060952','0609',' MATUS',1),('060953','0609',' PUELA',1),('060954','0609',' SAN ANTONIO DE BAYUSHIG',1),('060955','0609',' LA CANDELARIA',1),('060956','0609',' BILBAO (CAB.EN QUILLUYACU)',1),('061050','0610',' CUMANDÁ',1),('070101','0701',' LA PROVIDENCIA',1),('070102','0701',' MACHALA',1),('070103','0701',' PUERTO BOLÍVAR',1),('070104','0701',' NUEVE DE MAYO',1),('070105','0701',' EL CAMBIO',1),('070150','0701',' MACHALA',1),('070151','0701',' EL CAMBIO',1),('070152','0701',' EL RETIRO',1),('070250','0702',' ARENILLAS',1),('070251','0702',' CHACRAS',1),('070252','0702',' LA LIBERTAD',1),('070253','0702',' LAS LAJAS (CAB. EN LA VICTO',1),('070254','0702',' PALMALES',1),('070255','0702',' CARCABÓN',1),('070350','0703',' PACCHA',1),('070351','0703',' AYAPAMBA',1),('070352','0703',' CORDONCILLO',1),('070353','0703',' MILAGRO',1),('070354','0703',' SAN JOSÉ',1),('070355','0703',' SAN JUAN DE CERRO AZUL',1),('070450','0704',' BALSAS',1),('070451','0704',' BELLAMARÍA',1),('070550','0705',' CHILLA',1),('070650','0706',' EL GUABO',1),('070651','0706',' BARBONES (SUCRE)',1),('070652','0706',' LA IBERIA',1),('070653','0706',' TENDALES (CAB.EN PUERTO TEN',1),('070654','0706',' RÍO BONITO',1),('070701','0707',' ECUADOR',1),('070702','0707',' EL PARAÍSO',1),('070703','0707',' HUALTACO',1),('070704','0707',' MILTON REYES',1),('070705','0707',' UNIÓN LOJANA',1),('070750','0707',' HUAQUILLAS',1),('070850','0708',' MARCABELÍ',1),('070851','0708',' EL INGENIO',1),('070901','0709',' BOLÍVAR',1),('070902','0709',' LOMA DE FRANCO',1),('070903','0709',' OCHOA LEÓN (MATRIZ)',1),('070904','0709',' TRES CERRITOS',1),('070950','0709',' PASAJE',1),('070951','0709',' BUENAVISTA',1),('070952','0709',' CASACAY',1),('070953','0709',' LA PEAÑA',1),('070954','0709',' PROGRESO',1),('070955','0709',' UZHCURRUMI',1),('070956','0709',' CAÑAQUEMADA',1),('071001','0710',' LA MATRIZ',1),('071002','0710',' LA SUSAYA',1),('071003','0710',' PIÑAS GRANDE',1),('071050','0710',' PIÑAS',1),('071051','0710',' CAPIRO (CAB. EN LA CAPILLA ',1),('071052','0710',' LA BOCANA',1),('071053','0710',' MOROMORO (CAB. EN EL VADO)',1),('071054','0710',' PIEDRAS',1),('071055','0710',' SAN ROQUE (AMBROSIO MALDONA',1),('071056','0710',' SARACAY',1),('071150','0711',' PORTOVELO',1),('071151','0711',' CURTINCAPA',1),('071152','0711',' MORALES',1),('071153','0711',' SALATÍ',1),('071201','0712',' SANTA ROSA',1),('071202','0712',' PUERTO JELÍ',1),('071203','0712',' BALNEARIO JAMBELÍ (SATÉLITE',1),('071204','0712',' JUMÓN (SATÉLITE)',1),('071205','0712',' NUEVO SANTA ROSA',1),('071250','0712',' SANTA ROSA',1),('071251','0712',' BELLAVISTA',1),('071252','0712',' JAMBELÍ',1),('071253','0712',' LA AVANZADA',1),('071254','0712',' SAN ANTONIO',1),('071255','0712',' TORATA',1),('071256','0712',' VICTORIA',1),('071257','0712',' BELLAMARÍA',1),('071350','0713',' ZARUMA',1),('071351','0713',' ABAÑÍN',1),('071352','0713',' ARCAPAMBA',1),('071353','0713',' GUANAZÁN',1),('071354','0713',' GUIZHAGUIÑA',1),('071355','0713',' HUERTAS',1),('071356','0713',' MALVAS',1),('071357','0713',' MULUNCAY GRANDE',1),('071358','0713',' SINSAO',1),('071359','0713',' SALVIAS',1),('071401','0714',' LA VICTORIA',1),('071402','0714',' PLATANILLOS',1),('071403','0714',' VALLE HERMOSO',1),('071450','0714',' LA VICTORIA',1),('071451','0714',' LA LIBERTAD',1),('071452','0714',' EL PARAÍSO',1),('071453','0714',' SAN ISIDRO',1),('080101','0801',' BARTOLOMÉ RUIZ (CÉSAR FRANC',1),('080102','0801',' 5 DE AGOSTO',1),('080103','0801',' ESMERALDAS',1),('080104','0801',' LUIS TELLO (LAS PALMAS)',1),('080105','0801',' SIMÓN PLATA TORRES',1),('080150','0801',' ESMERALDAS',1),('080151','0801',' ATACAMES',1),('080152','0801',' CAMARONES (CAB. EN SAN VICE',1),('080153','0801',' CRNEL. CARLOS CONCHA TORRES',1),('080154','0801',' CHINCA',1),('080155','0801',' CHONTADURO',1),('080156','0801',' CHUMUNDÉ',1),('080157','0801',' LAGARTO',1),('080158','0801',' LA UNIÓN',1),('080159','0801',' MAJUA',1),('080160','0801',' MONTALVO (CAB. EN HORQUETA)',1),('080161','0801',' RÍO VERDE',1),('080162','0801',' ROCAFUERTE',1),('080163','0801',' SAN MATEO',1),('080164','0801',' SÚA (CAB. EN LA BOCANA)',1),('080165','0801',' TABIAZO',1),('080166','0801',' TACHINA',1),('080167','0801',' TONCHIGÜE',1),('080168','0801',' VUELTA LARGA',1),('080250','0802',' VALDEZ (LIMONES)',1),('080251','0802',' ANCHAYACU',1),('080252','0802',' ATAHUALPA (CAB. EN CAMARONE',1),('080253','0802',' BORBÓN',1),('080254','0802',' LA TOLA',1),('080255','0802',' LUIS VARGAS TORRES (CAB. EN',1),('080256','0802',' MALDONADO',1),('080257','0802',' PAMPANAL DE BOLÍVAR',1),('080258','0802',' SAN FRANCISCO DE ONZOLE',1),('080259','0802',' SANTO DOMINGO DE ONZOLE',1),('080260','0802',' SELVA ALEGRE',1),('080261','0802',' TELEMBÍ',1),('080262','0802',' COLÓN ELOY DEL MARÍA',1),('080263','0802',' SAN JOSÉ DE CAYAPAS',1),('080264','0802',' TIMBIRÉ',1),('080350','0803',' MUISNE',1),('080351','0803',' BOLÍVAR',1),('080352','0803',' DAULE',1),('080353','0803',' GALERA',1),('080354','0803',' QUINGUE (OLMEDO PERDOMO FRA',1),('080355','0803',' SALIMA',1),('080356','0803',' SAN FRANCISCO',1),('080357','0803',' SAN GREGORIO',1),('080358','0803',' SAN JOSÉ DE CHAMANGA (CAB.E',1),('080450','0804',' ROSA ZÁRATE (QUININDÉ)',1),('080451','0804',' CUBE',1),('080452','0804',' CHURA (CHANCAMA) (CAB. EN E',1),('080453','0804',' MALIMPIA',1),('080454','0804',' VICHE',1),('080455','0804',' LA UNIÓN',1),('080550','0805',' SAN LORENZO',1),('080551','0805',' ALTO TAMBO (CAB. EN GUADUAL',1),('080552','0805',' ANCÓN (PICHANGAL) (CAB. EN ',1),('080553','0805',' CALDERÓN',1),('080554','0805',' CARONDELET',1),('080555','0805',' 5 DE JUNIO (CAB. EN UIMBI)',1),('080556','0805',' CONCEPCIÓN',1),('080557','0805',' MATAJE (CAB. EN SANTANDER)',1),('080558','0805',' SAN JAVIER DE CACHAVÍ (CAB.',1),('080559','0805',' SANTA RITA',1),('080560','0805',' TAMBILLO',1),('080561','0805',' TULULBÍ (CAB. EN RICAURTE)',1),('080562','0805',' URBINA',1),('080650','0806',' ATACAMES',1),('080651','0806',' LA UNIÓN',1),('080652','0806',' SÚA (CAB. EN LA BOCANA)',1),('080653','0806',' TONCHIGÜE',1),('080654','0806',' TONSUPA',1),('080750','0807',' RIOVERDE',1),('080751','0807',' CHONTADURO',1),('080752','0807',' CHUMUNDÉ',1),('080753','0807',' LAGARTO',1),('080754','0807',' MONTALVO (CAB. EN HORQUETA)',1),('080755','0807',' ROCAFUERTE',1),('080850','0808',' LA CONCORDIA',1),('080851','0808',' MONTERREY',1),('080852','0808',' LA VILLEGAS',1),('080853','0808',' PLAN PILOTO',1),('090101','0901',' AYACUCHO',1),('090102','0901',' BOLÍVAR (SAGRARIO)',1),('090103','0901',' CARBO (CONCEPCIÓN)',1),('090104','0901',' FEBRES CORDERO',1),('090105','0901',' GARCÍA MORENO',1),('090106','0901',' LETAMENDI',1),('090107','0901',' NUEVE DE OCTUBRE',1),('090108','0901',' OLMEDO (SAN ALEJO)',1),('090109','0901',' ROCA',1),('090110','0901',' ROCAFUERTE',1),('090111','0901',' SUCRE',1),('090112','0901',' TARQUI',1),('090113','0901',' URDANETA',1),('090114','0901',' XIMENA',1),('090115','0901',' PASCUALES',1),('090150','0901',' GUAYAQUIL',1),('090151','0901',' CHONGÓN',1),('090152','0901',' JUAN GÓMEZ RENDÓN (PROGRESO',1),('090153','0901',' MORRO',1),('090154','0901',' PASCUALES',1),('090155','0901',' PLAYAS (GRAL. VILLAMIL)',1),('090156','0901',' POSORJA',1),('090157','0901',' PUNÁ',1),('090158','0901',' TENGUEL',1),('090250','0902',' ALFREDO BAQUERIZO MORENO (J',1),('090350','0903',' BALAO',1),('090450','0904',' BALZAR',1),('090550','0905',' COLIMES',1),('090551','0905',' SAN JACINTO',1),('090601','0906',' DAULE',1),('090602','0906',' LA AURORA (SATÉLITE)',1),('090603','0906',' BANIFE',1),('090604','0906',' EMILIANO CAICEDO MARCOS',1),('090605','0906',' MAGRO',1),('090606','0906',' PADRE JUAN BAUTISTA AGUIRRE',1),('090607','0906',' SANTA CLARA',1),('090608','0906',' VICENTE PIEDRAHITA',1),('090650','0906',' DAULE',1),('090651','0906',' ISIDRO AYORA (SOLEDAD)',1),('090652','0906',' JUAN BAUTISTA AGUIRRE (LOS ',1),('090653','0906',' LAUREL',1),('090654','0906',' LIMONAL',1),('090655','0906',' LOMAS DE SARGENTILLO',1),('090656','0906',' LOS LOJAS (ENRIQUE BAQUERIZ',1),('090657','0906',' PIEDRAHITA (NOBOL)',1),('090701','0907',' ELOY ALFARO (DURÁN)',1),('090702','0907',' EL RECREO',1),('090750','0907',' ELOY ALFARO (DURÁN)',1),('090850','0908',' VELASCO IBARRA (EL EMPALME)',1),('090851','0908',' GUAYAS (PUEBLO NUEVO)',1),('090852','0908',' EL ROSARIO',1),('090950','0909',' EL TRIUNFO',1),('091050','0910',' MILAGRO',1),('091051','0910',' CHOBO',1),('091052','0910',' GENERAL ELIZALDE (BUCAY)',1),('091053','0910',' MARISCAL SUCRE (HUAQUES)',1),('091054','0910',' ROBERTO ASTUDILLO (CAB. EN ',1),('091150','0911',' NARANJAL',1),('091151','0911',' JESÚS MARÍA',1),('091152','0911',' SAN CARLOS',1),('091153','0911',' SANTA ROSA DE FLANDES',1),('091154','0911',' TAURA',1),('091250','0912',' NARANJITO',1),('091350','0913',' PALESTINA',1),('091450','0914',' PEDRO CARBO',1),('091451','0914',' VALLE DE LA VIRGEN',1),('091452','0914',' SABANILLA',1),('091601','0916',' SAMBORONDÓN',1),('091602','0916',' LA PUNTILLA (SATÉLITE)',1),('091650','0916',' SAMBORONDÓN',1),('091651','0916',' TARIFA',1),('091850','0918',' SANTA LUCÍA',1),('091901','0919',' BOCANA',1),('091902','0919',' CANDILEJOS',1),('091903','0919',' CENTRAL',1),('091904','0919',' PARAÍSO',1),('091905','0919',' SAN MATEO',1),('091950','0919',' EL SALITRE (LAS RAMAS)',1),('091951','0919',' GRAL. VERNAZA (DOS ESTEROS)',1),('091952','0919',' LA VICTORIA (ÑAUZA)',1),('091953','0919',' JUNQUILLAL',1),('092050','0920',' SAN JACINTO DE YAGUACHI',1),('092051','0920',' CRNEL. LORENZO DE GARAICOA ',1),('092052','0920',' CRNEL. MARCELINO MARIDUEÑA ',1),('092053','0920',' GRAL. PEDRO J. MONTERO (BOL',1),('092054','0920',' SIMÓN BOLÍVAR',1),('092055','0920',' YAGUACHI VIEJO (CONE)',1),('092056','0920',' VIRGEN DE FÁTIMA',1),('092150','0921',' GENERAL VILLAMIL (PLAYAS)',1),('092250','0922',' SIMÓN BOLÍVAR',1),('092251','0922',' CRNEL.LORENZO DE GARAICOA (',1),('092350','0923',' CORONEL MARCELINO MARIDUEÑA',1),('092450','0924',' LOMAS DE SARGENTILLO',1),('092451','0924',' ISIDRO AYORA (SOLEDAD)',1),('092550','0925',' NARCISA DE JESÚS',1),('092750','0927',' GENERAL ANTONIO ELIZALDE (B',1),('092850','0928',' ISIDRO AYORA',1),('100101','1001',' CARANQUI',1),('100102','1001',' GUAYAQUIL DE ALPACHACA',1),('100103','1001',' SAGRARIO',1),('100104','1001',' SAN FRANCISCO',1),('100105','1001',' LA DOLOROSA DEL PRIORATO',1),('100150','1001',' SAN MIGUEL DE IBARRA',1),('100151','1001',' AMBUQUÍ',1),('100152','1001',' ANGOCHAGUA',1),('100153','1001',' CAROLINA',1),('100154','1001',' LA ESPERANZA',1),('100155','1001',' LITA',1),('100156','1001',' SALINAS',1),('100157','1001',' SAN ANTONIO',1),('100201','1002',' ANDRADE MARÍN (LOURDES)',1),('100202','1002',' ATUNTAQUI',1),('100250','1002',' ATUNTAQUI',1),('100251','1002',' IMBAYA (SAN LUIS DE COBUEND',1),('100252','1002',' SAN FRANCISCO DE NATABUELA',1),('100253','1002',' SAN JOSÉ DE CHALTURA',1),('100254','1002',' SAN ROQUE',1),('100301','1003',' SAGRARIO',1),('100302','1003',' SAN FRANCISCO',1),('100350','1003',' COTACACHI',1),('100351','1003',' APUELA',1),('100352','1003',' GARCÍA MORENO (LLURIMAGUA)',1),('100353','1003',' IMANTAG',1),('100354','1003',' PEÑAHERRERA',1),('100355','1003',' PLAZA GUTIÉRREZ (CALVARIO)',1),('100356','1003',' QUIROGA',1),('100357','1003',' 6 DE JULIO DE CUELLAJE (CAB',1),('100358','1003',' VACAS GALINDO (EL CHURO) (C',1),('100401','1004',' JORDÁN',1),('100402','1004',' SAN LUIS',1),('100450','1004',' OTAVALO',1),('100451','1004',' DR. MIGUEL EGAS CABEZAS (PE',1),('100452','1004',' EUGENIO ESPEJO (CALPAQUÍ)',1),('100453','1004',' GONZÁLEZ SUÁREZ',1),('100454','1004',' PATAQUÍ',1),('100455','1004',' SAN JOSÉ DE QUICHINCHE',1),('100456','1004',' SAN JUAN DE ILUMÁN',1),('100457','1004',' SAN PABLO',1),('100458','1004',' SAN RAFAEL',1),('100459','1004',' SELVA ALEGRE (CAB.EN SAN MI',1),('100550','1005',' PIMAMPIRO',1),('100551','1005',' CHUGÁ',1),('100552','1005',' MARIANO ACOSTA',1),('100553','1005',' SAN FRANCISCO DE SIGSIPAMBA',1),('100650','1006',' URCUQUÍ CABECERA CANTONAL',1),('100651','1006',' CAHUASQUÍ',1),('100652','1006',' LA MERCED DE BUENOS AIRES',1),('100653','1006',' PABLO ARENAS',1),('100654','1006',' SAN BLAS',1),('100655','1006',' TUMBABIRO',1),('110101','1101',' EL SAGRARIO',1),('110102','1101',' SAN SEBASTIÁN',1),('110103','1101',' SUCRE',1),('110104','1101',' VALLE',1),('110150','1101',' LOJA',1),('110151','1101',' CHANTACO',1),('110152','1101',' CHUQUIRIBAMBA',1),('110153','1101',' EL CISNE',1),('110154','1101',' GUALEL',1),('110155','1101',' JIMBILLA',1),('110156','1101',' MALACATOS (VALLADOLID)',1),('110157','1101',' SAN LUCAS',1),('110158','1101',' SAN PEDRO DE VILCABAMBA',1),('110159','1101',' SANTIAGO',1),('110160','1101',' TAQUIL (MIGUEL RIOFRÍO)',1),('110161','1101',' VILCABAMBA (VICTORIA)',1),('110162','1101',' YANGANA (ARSENIO CASTILLO)',1),('110163','1101',' QUINARA',1),('110201','1102',' CARIAMANGA',1),('110202','1102',' CHILE',1),('110203','1102',' SAN VICENTE',1),('110250','1102',' CARIAMANGA',1),('110251','1102',' COLAISACA',1),('110252','1102',' EL LUCERO',1),('110253','1102',' UTUANA',1),('110254','1102',' SANGUILLÍN',1),('110301','1103',' CATAMAYO',1),('110302','1103',' SAN JOSÉ',1),('110350','1103',' CATAMAYO (LA TOMA)',1),('110351','1103',' EL TAMBO',1),('110352','1103',' GUAYQUICHUMA',1),('110353','1103',' SAN PEDRO DE LA BENDITA',1),('110354','1103',' ZAMBI',1),('110450','1104',' CELICA',1),('110451','1104',' CRUZPAMBA (CAB. EN CARLOS B',1),('110452','1104',' CHAQUINAL',1),('110453','1104',' 12 DE DICIEMBRE (CAB. EN AC',1),('110454','1104',' PINDAL (FEDERICO PÁEZ)',1),('110455','1104',' POZUL (SAN JUAN DE POZUL)',1),('110456','1104',' SABANILLA',1),('110457','1104',' TNTE. MAXIMILIANO RODRÍGUEZ',1),('110550','1105',' CHAGUARPAMBA',1),('110551','1105',' BUENAVISTA',1),('110552','1105',' EL ROSARIO',1),('110553','1105',' SANTA RUFINA',1),('110554','1105',' AMARILLOS',1),('110650','1106',' AMALUZA',1),('110651','1106',' BELLAVISTA',1),('110652','1106',' JIMBURA',1),('110653','1106',' SANTA TERESITA',1),('110654','1106',' 27 DE ABRIL (CAB. EN LA NAR',1),('110655','1106',' EL INGENIO',1),('110656','1106',' EL AIRO',1),('110750','1107',' GONZANAMÁ',1),('110751','1107',' CHANGAIMINA (LA LIBERTAD)',1),('110752','1107',' FUNDOCHAMBA',1),('110753','1107',' NAMBACOLA',1),('110754','1107',' PURUNUMA (EGUIGUREN)',1),('110755','1107',' QUILANGA (LA PAZ)',1),('110756','1107',' SACAPALCA',1),('110757','1107',' SAN ANTONIO DE LAS ARADAS (',1),('110801','1108',' GENERAL ELOY ALFARO (SAN SE',1),('110802','1108',' MACARÁ (MANUEL ENRIQUE RENG',1),('110850','1108',' MACARÁ',1),('110851','1108',' LARAMA',1),('110852','1108',' LA VICTORIA',1),('110853','1108',' SABIANGO (LA CAPILLA)',1),('110901','1109',' CATACOCHA',1),('110902','1109',' LOURDES',1),('110950','1109',' CATACOCHA',1),('110951','1109',' CANGONAMÁ',1),('110952','1109',' GUACHANAMÁ',1),('110953','1109',' LA TINGUE',1),('110954','1109',' LAURO GUERRERO',1),('110955','1109',' OLMEDO (SANTA BÁRBARA)',1),('110956','1109',' ORIANGA',1),('110957','1109',' SAN ANTONIO',1),('110958','1109',' CASANGA',1),('110959','1109',' YAMANA',1),('111050','1110',' ALAMOR',1),('111051','1110',' CIANO',1),('111052','1110',' EL ARENAL',1),('111053','1110',' EL LIMO (MARIANA DE JESÚS)',1),('111054','1110',' MERCADILLO',1),('111055','1110',' VICENTINO',1),('111150','1111',' SARAGURO',1),('111151','1111',' EL PARAÍSO DE CELÉN',1),('111152','1111',' EL TABLÓN',1),('111153','1111',' LLUZHAPA',1),('111154','1111',' MANÚ',1),('111155','1111',' SAN ANTONIO DE QUMBE (CUMBE',1),('111156','1111',' SAN PABLO DE TENTA',1),('111157','1111',' SAN SEBASTIÁN DE YÚLUC',1),('111158','1111',' SELVA ALEGRE',1),('111159','1111',' URDANETA (PAQUISHAPA)',1),('111160','1111',' SUMAYPAMBA',1),('111250','1112',' SOZORANGA',1),('111251','1112',' NUEVA FÁTIMA',1),('111252','1112',' TACAMOROS',1),('111350','1113',' ZAPOTILLO',1),('111351','1113',' MANGAHURCO (CAZADEROS)',1),('111352','1113',' GARZAREAL',1),('111353','1113',' LIMONES',1),('111354','1113',' PALETILLAS',1),('111355','1113',' BOLASPAMBA',1),('111450','1114',' PINDAL',1),('111451','1114',' CHAQUINAL',1),('111452','1114',' 12 DE DICIEMBRE (CAB.EN ACH',1),('111453','1114',' MILAGROS',1),('111550','1115',' QUILANGA',1),('111551','1115',' FUNDOCHAMBA',1),('111552','1115',' SAN ANTONIO DE LAS ARADAS (',1),('111650','1116',' OLMEDO',1),('111651','1116',' LA TINGUE',1),('120101','1201',' CLEMENTE BAQUERIZO',1),('120102','1201',' DR. CAMILO PONCE',1),('120103','1201',' BARREIRO',1),('120104','1201',' EL SALTO',1),('120150','1201',' BABAHOYO',1),('120151','1201',' BARREIRO (SANTA RITA)',1),('120152','1201',' CARACOL',1),('120153','1201',' FEBRES CORDERO (LAS JUNTAS)',1),('120154','1201',' PIMOCHA',1),('120155','1201',' LA UNIÓN',1),('120250','1202',' BABA',1),('120251','1202',' GUARE',1),('120252','1202',' ISLA DE BEJUCAL',1),('120350','1203',' MONTALVO',1),('120450','1204',' PUEBLOVIEJO',1),('120451','1204',' PUERTO PECHICHE',1),('120452','1204',' SAN JUAN',1),('120501','1205',' QUEVEDO',1),('120502','1205',' SAN CAMILO',1),('120503','1205',' SAN JOSÉ',1),('120504','1205',' GUAYACÁN',1),('120505','1205',' NICOLÁS INFANTE DÍAZ',1),('120506','1205',' SAN CRISTÓBAL',1),('120507','1205',' SIETE DE OCTUBRE',1),('120508','1205',' 24 DE MAYO',1),('120509','1205',' VENUS DEL RÍO QUEVEDO',1),('120510','1205',' VIVA ALFARO',1),('120550','1205',' QUEVEDO',1),('120551','1205',' BUENA FÉ',1),('120552','1205',' MOCACHE',1),('120553','1205',' SAN CARLOS',1),('120554','1205',' VALENCIA',1),('120555','1205',' LA ESPERANZA',1),('120650','1206',' CATARAMA',1),('120651','1206',' RICAURTE',1),('120701','1207',' 10 DE NOVIEMBRE',1),('120750','1207',' VENTANAS',1),('120751','1207',' QUINSALOMA',1),('120752','1207',' ZAPOTAL',1),('120753','1207',' CHACARITA',1),('120754','1207',' LOS ÁNGELES',1),('120850','1208',' VINCES',1),('120851','1208',' ANTONIO SOTOMAYOR (CAB. EN ',1),('120852','1208',' PALENQUE',1),('120950','1209',' PALENQUE',1),('121001','1210',' SAN JACINTO DE BUENA FÉ',1),('121002','1210',' 7 DE AGOSTO',1),('121003','1210',' 11 DE OCTUBRE',1),('121050','1210',' SAN JACINTO DE BUENA FÉ',1),('121051','1210',' PATRICIA PILAR',1),('121150','1211',' VALENCIA',1),('121250','1212',' MOCACHE',1),('121350','1213',' QUINSALOMA',1),('130101','1301',' PORTOVIEJO',1),('130102','1301',' 12 DE MARZO',1),('130103','1301',' COLÓN',1),('130104','1301',' PICOAZÁ',1),('130105','1301',' SAN PABLO',1),('130106','1301',' ANDRÉS DE VERA',1),('130107','1301',' FRANCISCO PACHECO',1),('130108','1301',' 18 DE OCTUBRE',1),('130109','1301',' SIMÓN BOLÍVAR',1),('130150','1301',' PORTOVIEJO',1),('130151','1301',' ABDÓN CALDERÓN (SAN FRANCIS',1),('130152','1301',' ALHAJUELA (BAJO GRANDE)',1),('130153','1301',' CRUCITA',1),('130154','1301',' PUEBLO NUEVO',1),('130155','1301',' RIOCHICO (RÍO CHICO)',1),('130156','1301',' SAN PLÁCIDO',1),('130157','1301',' CHIRIJOS',1),('130250','1302',' CALCETA',1),('130251','1302',' MEMBRILLO',1),('130252','1302',' QUIROGA',1),('130301','1303',' CHONE',1),('130302','1303',' SANTA RITA',1),('130350','1303',' CHONE',1),('130351','1303',' BOYACÁ',1),('130352','1303',' CANUTO',1),('130353','1303',' CONVENTO',1),('130354','1303',' CHIBUNGA',1),('130355','1303',' ELOY ALFARO',1),('130356','1303',' RICAURTE',1),('130357','1303',' SAN ANTONIO',1),('130401','1304',' EL CARMEN',1),('130402','1304',' 4 DE DICIEMBRE',1),('130450','1304',' EL CARMEN',1),('130451','1304',' WILFRIDO LOOR MOREIRA (MAIC',1),('130452','1304',' SAN PEDRO DE SUMA',1),('130550','1305',' FLAVIO ALFARO',1),('130551','1305',' SAN FRANCISCO DE NOVILLO (C',1),('130552','1305',' ZAPALLO',1),('130601','1306',' DR. MIGUEL MORÁN LUCIO',1),('130602','1306',' MANUEL INOCENCIO PARRALES Y',1),('130603','1306',' SAN LORENZO DE JIPIJAPA',1),('130650','1306',' JIPIJAPA',1),('130651','1306',' AMÉRICA',1),('130652','1306',' EL ANEGADO (CAB. EN ELOY AL',1),('130653','1306',' JULCUY',1),('130654','1306',' LA UNIÓN',1),('130655','1306',' MACHALILLA',1),('130656','1306',' MEMBRILLAL',1),('130657','1306',' PEDRO PABLO GÓMEZ',1),('130658','1306',' PUERTO DE CAYO',1),('130659','1306',' PUERTO LÓPEZ',1),('130750','1307',' JUNÍN',1),('130801','1308',' LOS ESTEROS',1),('130802','1308',' MANTA',1),('130803','1308',' SAN MATEO',1),('130804','1308',' TARQUI',1),('130805','1308',' ELOY ALFARO',1),('130850','1308',' MANTA',1),('130851','1308',' SAN LORENZO',1),('130852','1308',' SANTA MARIANITA (BOCA DE PA',1),('130901','1309',' ANIBAL SAN ANDRÉS',1),('130902','1309',' MONTECRISTI',1),('130903','1309',' EL COLORADO',1),('130904','1309',' GENERAL ELOY ALFARO',1),('130905','1309',' LEONIDAS PROAÑO',1),('130950','1309',' MONTECRISTI',1),('130951','1309',' JARAMIJÓ',1),('130952','1309',' LA PILA',1),('131050','1310',' PAJÁN',1),('131051','1310',' CAMPOZANO (LA PALMA DE PAJÁ',1),('131052','1310',' CASCOL',1),('131053','1310',' GUALE',1),('131054','1310',' LASCANO',1),('131150','1311',' PICHINCHA',1),('131151','1311',' BARRAGANETE',1),('131152','1311',' SAN SEBASTIÁN',1),('131250','1312',' ROCAFUERTE',1),('131301','1313',' SANTA ANA',1),('131302','1313',' LODANA',1),('131350','1313',' SANTA ANA DE VUELTA LARGA',1),('131351','1313',' AYACUCHO',1),('131352','1313',' HONORATO VÁSQUEZ (CAB. EN V',1),('131353','1313',' LA UNIÓN',1),('131354','1313',' OLMEDO',1),('131355','1313',' SAN PABLO (CAB. EN PUEBLO N',1),('131401','1314',' BAHÍA DE CARÁQUEZ',1),('131402','1314',' LEONIDAS PLAZA GUTIÉRREZ',1),('131450','1314',' BAHÍA DE CARÁQUEZ',1),('131451','1314',' CANOA',1),('131452','1314',' COJIMÍES',1),('131453','1314',' CHARAPOTÓ',1),('131454','1314',' 10 DE AGOSTO',1),('131455','1314',' JAMA',1),('131456','1314',' PEDERNALES',1),('131457','1314',' SAN ISIDRO',1),('131458','1314',' SAN VICENTE',1),('131550','1315',' TOSAGUA',1),('131551','1315',' BACHILLERO',1),('131552','1315',' ANGEL PEDRO GILER (LA ESTAN',1),('131650','1316',' SUCRE',1),('131651','1316',' BELLAVISTA',1),('131652','1316',' NOBOA',1),('131653','1316',' ARQ. SIXTO DURÁN BALLÉN',1),('131750','1317',' PEDERNALES',1),('131751','1317',' COJIMÍES',1),('131752','1317',' 10 DE AGOSTO',1),('131753','1317',' ATAHUALPA',1),('131850','1318',' OLMEDO',1),('131950','1319',' PUERTO LÓPEZ',1),('131951','1319',' MACHALILLA',1),('131952','1319',' SALANGO',1),('132050','1320',' JAMA',1),('132150','1321',' JARAMIJÓ',1),('132250','1322',' SAN VICENTE',1),('132251','1322',' CANOA',1),('140150','1401',' MACAS',1),('140151','1401',' ALSHI (CAB. EN 9 DE OCTUBRE',1),('140152','1401',' CHIGUAZA',1),('140153','1401',' GENERAL PROAÑO',1),('140154','1401',' HUASAGA (CAB.EN WAMPUIK)',1),('140155','1401',' MACUMA',1),('140156','1401',' SAN ISIDRO',1),('140157','1401',' SEVILLA DON BOSCO',1),('140158','1401',' SINAÍ',1),('140159','1401',' TAISHA',1),('140160','1401',' ZUÑA (ZÚÑAC)',1),('140161','1401',' TUUTINENTZA',1),('140162','1401',' CUCHAENTZA',1),('140163','1401',' SAN JOSÉ DE MORONA',1),('140164','1401',' RÍO BLANCO',1),('140201','1402',' GUALAQUIZA',1),('140202','1402',' MERCEDES MOLINA',1),('140250','1402',' GUALAQUIZA',1),('140251','1402',' AMAZONAS (ROSARIO DE CUYES)',1),('140252','1402',' BERMEJOS',1),('140253','1402',' BOMBOIZA',1),('140254','1402',' CHIGÜINDA',1),('140255','1402',' EL ROSARIO',1),('140256','1402',' NUEVA TARQUI',1),('140257','1402',' SAN MIGUEL DE CUYES',1),('140258','1402',' EL IDEAL',1),('140350','1403',' GENERAL LEONIDAS PLAZA GUTI',1),('140351','1403',' INDANZA',1),('140352','1403',' PAN DE AZÚCAR',1),('140353','1403',' SAN ANTONIO (CAB. EN SAN AN',1),('140354','1403',' SAN CARLOS DE LIMÓN (SAN CA',1),('140355','1403',' SAN JUAN BOSCO',1),('140356','1403',' SAN MIGUEL DE CONCHAY',1),('140357','1403',' SANTA SUSANA DE CHIVIAZA (C',1),('140358','1403',' YUNGANZA (CAB. EN EL ROSARI',1),('140450','1404',' PALORA (METZERA)',1),('140451','1404',' ARAPICOS',1),('140452','1404',' CUMANDÁ (CAB. EN COLONIA AG',1),('140453','1404',' HUAMBOYA',1),('140454','1404',' SANGAY (CAB. EN NAYAMANACA)',1),('140550','1405',' SANTIAGO DE MÉNDEZ',1),('140551','1405',' COPAL',1),('140552','1405',' CHUPIANZA',1),('140553','1405',' PATUCA',1),('140554','1405',' SAN LUIS DE EL ACHO (CAB. E',1),('140555','1405',' SANTIAGO',1),('140556','1405',' TAYUZA',1),('140557','1405',' SAN FRANCISCO DE CHINIMBIMI',1),('140650','1406',' SUCÚA',1),('140651','1406',' ASUNCIÓN',1),('140652','1406',' HUAMBI',1),('140653','1406',' LOGROÑO',1),('140654','1406',' YAUPI',1),('140655','1406',' SANTA MARIANITA DE JESÚS',1),('140750','1407',' HUAMBOYA',1),('140751','1407',' CHIGUAZA',1),('140752','1407',' PABLO SEXTO',1),('140850','1408',' SAN JUAN BOSCO',1),('140851','1408',' PAN DE AZÚCAR',1),('140852','1408',' SAN CARLOS DE LIMÓN',1),('140853','1408',' SAN JACINTO DE WAKAMBEIS',1),('140854','1408',' SANTIAGO DE PANANZA',1),('140950','1409',' TAISHA',1),('140951','1409',' HUASAGA (CAB. EN WAMPUIK)',1),('140952','1409',' MACUMA',1),('140953','1409',' TUUTINENTZA',1),('140954','1409',' PUMPUENTSA',1),('141050','1410',' LOGROÑO',1),('141051','1410',' YAUPI',1),('141052','1410',' SHIMPIS',1),('141150','1411',' PABLO SEXTO',1),('141250','1412',' SANTIAGO',1),('141251','1412',' SAN JOSÉ DE MORONA',1),('150150','1501',' TENA',1),('150151','1501',' AHUANO',1),('150152','1501',' CARLOS JULIO AROSEMENA TOLA',1),('150153','1501',' CHONTAPUNTA',1),('150154','1501',' PANO',1),('150155','1501',' PUERTO MISAHUALLI',1),('150156','1501',' PUERTO NAPO',1),('150157','1501',' TÁLAG',1),('150158','1501',' SAN JUAN DE MUYUNA',1),('150350','1503',' ARCHIDONA',1),('150351','1503',' AVILA',1),('150352','1503',' COTUNDO',1),('150353','1503',' LORETO',1),('150354','1503',' SAN PABLO DE USHPAYACU',1),('150355','1503',' PUERTO MURIALDO',1),('150450','1504',' EL CHACO',1),('150451','1504',' GONZALO DíAZ DE PINEDA (EL ',1),('150452','1504',' LINARES',1),('150453','1504',' OYACACHI',1),('150454','1504',' SANTA ROSA',1),('150455','1504',' SARDINAS',1),('150750','1507',' BAEZA',1),('150751','1507',' COSANGA',1),('150752','1507',' CUYUJA',1),('150753','1507',' PAPALLACTA',1),('150754','1507',' SAN FRANCISCO DE BORJA (VIR',1),('150755','1507',' SAN JOSÉ DEL PAYAMINO',1),('150756','1507',' SUMACO',1),('150950','1509',' CARLOS JULIO AROSEMENA TOLA',1),('160150','1601',' PUYO',1),('160151','1601',' ARAJUNO',1),('160152','1601',' CANELOS',1),('160153','1601',' CURARAY',1),('160154','1601',' DIEZ DE AGOSTO',1),('160155','1601',' FÁTIMA',1),('160156','1601',' MONTALVO (ANDOAS)',1),('160157','1601',' POMONA',1),('160158','1601',' RÍO CORRIENTES',1),('160159','1601',' RÍO TIGRE',1),('160160','1601',' SANTA CLARA',1),('160161','1601',' SARAYACU',1),('160162','1601',' SIMÓN BOLÍVAR (CAB. EN MUSH',1),('160163','1601',' TARQUI',1),('160164','1601',' TENIENTE HUGO ORTIZ',1),('160165','1601',' VERACRUZ (INDILLAMA) (CAB. ',1),('160166','1601',' EL TRIUNFO',1),('160250','1602',' MERA',1),('160251','1602',' MADRE TIERRA',1),('160252','1602',' SHELL',1),('160350','1603',' SANTA CLARA',1),('160351','1603',' SAN JOSÉ',1),('160450','1604',' ARAJUNO',1),('160451','1604',' CURARAY',1),('170101','1701',' BELISARIO QUEVEDO',1),('170102','1701',' CARCELÉN',1),('170103','1701',' CENTRO HISTÓRICO',1),('170104','1701',' COCHAPAMBA',1),('170105','1701',' COMITÉ DEL PUEBLO',1),('170106','1701',' COTOCOLLAO',1),('170107','1701',' CHILIBULO',1),('170108','1701',' CHILLOGALLO',1),('170109','1701',' CHIMBACALLE',1),('170110','1701',' EL CONDADO',1),('170111','1701',' GUAMANÍ',1),('170112','1701',' IÑAQUITO',1),('170113','1701',' ITCHIMBÍA',1),('170114','1701',' JIPIJAPA',1),('170115','1701',' KENNEDY',1),('170116','1701',' LA ARGELIA',1),('170117','1701',' LA CONCEPCIÓN',1),('170118','1701',' LA ECUATORIANA',1),('170119','1701',' LA FERROVIARIA',1),('170120','1701',' LA LIBERTAD',1),('170121','1701',' LA MAGDALENA',1),('170122','1701',' LA MENA',1),('170123','1701',' MARISCAL SUCRE',1),('170124','1701',' PONCEANO',1),('170125','1701',' PUENGASÍ',1),('170126','1701',' QUITUMBE',1),('170127','1701',' RUMIPAMBA',1),('170128','1701',' SAN BARTOLO',1),('170129','1701',' SAN ISIDRO DEL INCA',1),('170130','1701',' SAN JUAN',1),('170131','1701',' SOLANDA',1),('170132','1701',' TURUBAMBA',1),('170150','1701',' QUITO DISTRITO METROPOLITAN',1),('170151','1701',' ALANGASÍ',1),('170152','1701',' AMAGUAÑA',1),('170153','1701',' ATAHUALPA',1),('170154','1701',' CALACALÍ',1),('170155','1701',' CALDERÓN',1),('170156','1701',' CONOCOTO',1),('170157','1701',' CUMBAYÁ',1),('170158','1701',' CHAVEZPAMBA',1),('170159','1701',' CHECA',1),('170160','1701',' EL QUINCHE',1),('170161','1701',' GUALEA',1),('170162','1701',' GUANGOPOLO',1),('170163','1701',' GUAYLLABAMBA',1),('170164','1701',' LA MERCED',1),('170165','1701',' LLANO CHICO',1),('170166','1701',' LLOA',1),('170167','1701',' MINDO',1),('170168','1701',' NANEGAL',1),('170169','1701',' NANEGALITO',1),('170170','1701',' NAYÓN',1),('170171','1701',' NONO',1),('170172','1701',' PACTO',1),('170173','1701',' PEDRO VICENTE MALDONADO',1),('170174','1701',' PERUCHO',1),('170175','1701',' PIFO',1),('170176','1701',' PÍNTAG',1),('170177','1701',' POMASQUI',1),('170178','1701',' PUÉLLARO',1),('170179','1701',' PUEMBO',1),('170180','1701',' SAN ANTONIO',1),('170181','1701',' SAN JOSÉ DE MINAS',1),('170182','1701',' SAN MIGUEL DE LOS BANCOS',1),('170183','1701',' TABABELA',1),('170184','1701',' TUMBACO',1),('170185','1701',' YARUQUÍ',1),('170186','1701',' ZAMBIZA',1),('170187','1701',' PUERTO QUITO',1),('170201','1702',' AYORA',1),('170202','1702',' CAYAMBE',1),('170203','1702',' JUAN MONTALVO',1),('170250','1702',' CAYAMBE',1),('170251','1702',' ASCÁZUBI',1),('170252','1702',' CANGAHUA',1),('170253','1702',' OLMEDO (PESILLO)',1),('170254','1702',' OTÓN',1),('170255','1702',' SANTA ROSA DE CUZUBAMBA',1),('170350','1703',' MACHACHI',1),('170351','1703',' ALÓAG',1),('170352','1703',' ALOASÍ',1),('170353','1703',' CUTUGLAHUA',1),('170354','1703',' EL CHAUPI',1),('170355','1703',' MANUEL CORNEJO ASTORGA (TAN',1),('170356','1703',' TAMBILLO',1),('170357','1703',' UYUMBICHO',1),('170450','1704',' TABACUNDO',1),('170451','1704',' LA ESPERANZA',1),('170452','1704',' MALCHINGUÍ',1),('170453','1704',' TOCACHI',1),('170454','1704',' TUPIGACHI',1),('170501','1705',' SANGOLQUÍ',1),('170502','1705',' SAN PEDRO DE TABOADA',1),('170503','1705',' SAN RAFAEL',1),('170550','1705',' SANGOLQUI',1),('170551','1705',' COTOGCHOA',1),('170552','1705',' RUMIPAMBA',1),('170750','1707',' SAN MIGUEL DE LOS BANCOS',1),('170751','1707',' MINDO',1),('170752','1707',' PEDRO VICENTE MALDONADO',1),('170753','1707',' PUERTO QUITO',1),('170850','1708',' PEDRO VICENTE MALDONADO',1),('170950','1709',' PUERTO QUITO',1),('180101','1801',' ATOCHA – FICOA',1),('180102','1801',' CELIANO MONGE',1),('180103','1801',' HUACHI CHICO',1),('180104','1801',' HUACHI LORETO',1),('180105','1801',' LA MERCED',1),('180106','1801',' LA PENÍNSULA',1),('180107','1801',' MATRIZ',1),('180108','1801',' PISHILATA',1),('180109','1801',' SAN FRANCISCO',1),('180150','1801',' AMBATO',1),('180151','1801',' AMBATILLO',1),('180152','1801',' ATAHUALPA (CHISALATA)',1),('180153','1801',' AUGUSTO N. MARTÍNEZ (MUNDUG',1),('180154','1801',' CONSTANTINO FERNÁNDEZ (CAB.',1),('180155','1801',' HUACHI GRANDE',1),('180156','1801',' IZAMBA',1),('180157','1801',' JUAN BENIGNO VELA',1),('180158','1801',' MONTALVO',1),('180159','1801',' PASA',1),('180160','1801',' PICAIGUA',1),('180161','1801',' PILAGÜÍN (PILAHÜÍN)',1),('180162','1801',' QUISAPINCHA (QUIZAPINCHA)',1),('180163','1801',' SAN BARTOLOMÉ DE PINLLOG',1),('180164','1801',' SAN FERNANDO (PASA SAN FERN',1),('180165','1801',' SANTA ROSA',1),('180166','1801',' TOTORAS',1),('180167','1801',' CUNCHIBAMBA',1),('180168','1801',' UNAMUNCHO',1),('180250','1802',' BAÑOS DE AGUA SANTA',1),('180251','1802',' LLIGUA',1),('180252','1802',' RÍO NEGRO',1),('180253','1802',' RÍO VERDE',1),('180254','1802',' ULBA',1),('180350','1803',' CEVALLOS',1),('180450','1804',' MOCHA',1),('180451','1804',' PINGUILÍ',1),('180550','1805',' PATATE',1),('180551','1805',' EL TRIUNFO',1),('180552','1805',' LOS ANDES (CAB. EN POATUG)',1),('180553','1805',' SUCRE (CAB. EN SUCRE-PATATE',1),('180650','1806',' QUERO',1),('180651','1806',' RUMIPAMBA',1),('180652','1806',' YANAYACU - MOCHAPATA (CAB. ',1),('180701','1807',' PELILEO',1),('180702','1807',' PELILEO GRANDE',1),('180750','1807',' PELILEO',1),('180751','1807',' BENÍTEZ (PACHANLICA)',1),('180752','1807',' BOLÍVAR',1),('180753','1807',' COTALÓ',1),('180754','1807',' CHIQUICHA (CAB. EN CHIQUICH',1),('180755','1807',' EL ROSARIO (RUMICHACA)',1),('180756','1807',' GARCÍA MORENO (CHUMAQUI)',1),('180757','1807',' GUAMBALÓ (HUAMBALÓ)',1),('180758','1807',' SALASACA',1),('180801','1808',' CIUDAD NUEVA',1),('180802','1808',' PÍLLARO',1),('180850','1808',' PÍLLARO',1),('180851','1808',' BAQUERIZO MORENO',1),('180852','1808',' EMILIO MARÍA TERÁN (RUMIPAM',1),('180853','1808',' MARCOS ESPINEL (CHACATA)',1),('180854','1808',' PRESIDENTE URBINA (CHAGRAPA',1),('180855','1808',' SAN ANDRÉS',1),('180856','1808',' SAN JOSÉ DE POALÓ',1),('180857','1808',' SAN MIGUELITO',1),('180950','1809',' TISALEO',1),('180951','1809',' QUINCHICOTO',1),('190101','1901',' EL LIMÓN',1),('190102','1901',' ZAMORA',1),('190150','1901',' ZAMORA',1),('190151','1901',' CUMBARATZA',1),('190152','1901',' GUADALUPE',1),('190153','1901',' IMBANA (LA VICTORIA DE IMBA',1),('190154','1901',' PAQUISHA',1),('190155','1901',' SABANILLA',1),('190156','1901',' TIMBARA',1),('190157','1901',' ZUMBI',1),('190158','1901',' SAN CARLOS DE LAS MINAS',1),('190250','1902',' ZUMBA',1),('190251','1902',' CHITO',1),('190252','1902',' EL CHORRO',1),('190253','1902',' EL PORVENIR DEL CARMEN',1),('190254','1902',' LA CHONTA',1),('190255','1902',' PALANDA',1),('190256','1902',' PUCAPAMBA',1),('190257','1902',' SAN FRANCISCO DEL VERGEL',1),('190258','1902',' VALLADOLID',1),('190259','1902',' SAN ANDRÉS',1),('190350','1903',' GUAYZIMI',1),('190351','1903',' ZURMI',1),('190352','1903',' NUEVO PARAÍSO',1),('190450','1904',' 28 DE MAYO (SAN JOSÉ DE YAC',1),('190451','1904',' LA PAZ',1),('190452','1904',' TUTUPALI',1),('190550','1905',' YANTZAZA (YANZATZA)',1),('190551','1905',' CHICAÑA',1),('190552','1905',' EL PANGUI',1),('190553','1905',' LOS ENCUENTROS',1),('190650','1906',' EL PANGUI',1),('190651','1906',' EL GUISME',1),('190652','1906',' PACHICUTZA',1),('190653','1906',' TUNDAYME',1),('190750','1907',' ZUMBI',1),('190751','1907',' PAQUISHA',1),('190752','1907',' TRIUNFO-DORADO',1),('190753','1907',' PANGUINTZA',1),('190850','1908',' PALANDA',1),('190851','1908',' EL PORVENIR DEL CARMEN',1),('190852','1908',' SAN FRANCISCO DEL VERGEL',1),('190853','1908',' VALLADOLID',1),('190854','1908',' LA CANELA',1),('190950','1909',' PAQUISHA',1),('190951','1909',' BELLAVISTA',1),('190952','1909',' NUEVO QUITO',1),('200150','2001',' PUERTO BAQUERIZO MORENO',1),('200151','2001',' EL PROGRESO',1),('200152','2001',' ISLA SANTA MARÍA (FLOREANA)',1),('200250','2002',' PUERTO VILLAMIL',1),('200251','2002',' TOMÁS DE BERLANGA (SANTO TO',1),('200350','2003',' PUERTO AYORA',1),('200351','2003',' BELLAVISTA',1),('200352','2003',' SANTA ROSA (INCLUYE LA ISLA',1),('210150','2101',' NUEVA LOJA',1),('210151','2101',' CUYABENO',1),('210152','2101',' DURENO',1),('210153','2101',' GENERAL FARFÁN',1),('210154','2101',' TARAPOA',1),('210155','2101',' EL ENO',1),('210156','2101',' PACAYACU',1),('210157','2101',' JAMBELÍ',1),('210158','2101',' SANTA CECILIA',1),('210159','2101',' AGUAS NEGRAS',1),('210250','2102',' EL DORADO DE CASCALES',1),('210251','2102',' EL REVENTADOR',1),('210252','2102',' GONZALO PIZARRO',1),('210253','2102',' LUMBAQUÍ',1),('210254','2102',' PUERTO LIBRE',1),('210255','2102',' SANTA ROSA DE SUCUMBÍOS',1),('210350','2103',' PUERTO EL CARMEN DEL PUTUMA',1),('210351','2103',' PALMA ROJA',1),('210352','2103',' PUERTO BOLÍVAR (PUERTO MONT',1),('210353','2103',' PUERTO RODRÍGUEZ',1),('210354','2103',' SANTA ELENA',1),('210450','2104',' SHUSHUFINDI',1),('210451','2104',' LIMONCOCHA',1),('210452','2104',' PAÑACOCHA',1),('210453','2104',' SAN ROQUE (CAB. EN SAN VICE',1),('210454','2104',' SAN PEDRO DE LOS COFANES',1),('210455','2104',' SIETE DE JULIO',1),('210550','2105',' LA BONITA',1),('210551','2105',' EL PLAYÓN DE SAN FRANCISCO',1),('210552','2105',' LA SOFÍA',1),('210553','2105',' ROSA FLORIDA',1),('210554','2105',' SANTA BÁRBARA',1),('210650','2106',' EL DORADO DE CASCALES',1),('210651','2106',' SANTA ROSA DE SUCUMBÍOS',1),('210652','2106',' SEVILLA',1),('210750','2107',' TARAPOA',1),('210751','2107',' CUYABENO',1),('210752','2107',' AGUAS NEGRAS',1),('220150','2201',' PUERTO FRANCISCO DE ORELLAN',1),('220151','2201',' DAYUMA',1),('220152','2201',' TARACOA (NUEVA ESPERANZA: Y',1),('220153','2201',' ALEJANDRO LABAKA',1),('220154','2201',' EL DORADO',1),('220155','2201',' EL EDÉN',1),('220156','2201',' GARCÍA MORENO',1),('220157','2201',' INÉS ARANGO (CAB. EN WESTER',1),('220158','2201',' LA BELLEZA',1),('220159','2201',' NUEVO PARAÍSO (CAB. EN UNIÓ',1),('220160','2201',' SAN JOSÉ DE GUAYUSA',1),('220161','2201',' SAN LUIS DE ARMENIA',1),('220201','2202',' TIPITINI',1),('220250','2202',' NUEVO ROCAFUERTE',1),('220251','2202',' CAPITÁN AUGUSTO RIVADENEYRA',1),('220252','2202',' CONONACO',1),('220253','2202',' SANTA MARÍA DE HUIRIRIMA',1),('220254','2202',' TIPUTINI',1),('220255','2202',' YASUNÍ',1),('220350','2203',' LA JOYA DE LOS SACHAS',1),('220351','2203',' ENOKANQUI',1),('220352','2203',' POMPEYA',1),('220353','2203',' SAN CARLOS',1),('220354','2203',' SAN SEBASTIÁN DEL COCA',1),('220355','2203',' LAGO SAN PEDRO',1),('220356','2203',' RUMIPAMBA',1),('220357','2203',' TRES DE NOVIEMBRE',1),('220358','2203',' UNIÓN MILAGREÑA',1),('220450','2204',' LORETO',1),('220451','2204',' AVILA (CAB. EN HUIRUNO)',1),('220452','2204',' PUERTO MURIALDO',1),('220453','2204',' SAN JOSÉ DE PAYAMINO',1),('220454','2204',' SAN JOSÉ DE DAHUANO',1),('220455','2204',' SAN VICENTE DE HUATICOCHA',1),('230101','2301',' ABRAHAM CALAZACÓN',1),('230102','2301',' BOMBOLÍ',1),('230103','2301',' CHIGUILPE',1),('230104','2301',' RÍO TOACHI',1),('230105','2301',' RÍO VERDE',1),('230106','2301',' SANTO DOMINGO DE LOS COLORA',1),('230107','2301',' ZARACAY',1),('230150','2301',' SANTO DOMINGO DE LOS COLORA',1),('230151','2301',' ALLURIQUÍN',1),('230152','2301',' PUERTO LIMÓN',1),('230153','2301',' LUZ DE AMÉRICA',1),('230154','2301',' SAN JACINTO DEL BÚA',1),('230155','2301',' VALLE HERMOSO',1),('230156','2301',' EL ESFUERZO',1),('230157','2301',' SANTA MARÍA DEL TOACHI',1),('240101','2401',' BALLENITA',1),('240102','2401',' SANTA ELENA',1),('240150','2401',' SANTA ELENA',1),('240151','2401',' ATAHUALPA',1),('240152','2401',' COLONCHE',1),('240153','2401',' CHANDUY',1),('240154','2401',' MANGLARALTO',1),('240155','2401',' SIMÓN BOLÍVAR (JULIO MORENO',1),('240156','2401',' SAN JOSÉ DE ANCÓN',1),('240250','2402',' LA LIBERTAD',1),('240301','2403',' CARLOS ESPINOZA LARREA',1),('240302','2403',' GRAL. ALBERTO ENRÍQUEZ GALL',1),('240303','2403',' VICENTE ROCAFUERTE',1),('240304','2403',' SANTA ROSA',1),('240350','2403',' SALINAS',1),('240351','2403',' ANCONCITO',1),('240352','2403',' JOSÉ LUIS TAMAYO (MUEY)',1),('900151','9001',' LAS GOLONDRINAS',1),('900351','9003',' MANGA DEL CURA',1),('900451','9004',' EL PIEDRERO',1);
/*!40000 ALTER TABLE `districts` ENABLE KEYS */;
DROP TABLE IF EXISTS `document_fee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_fee` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int unsigned NOT NULL,
  `date` date NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Relacion con el metodo de pago, Nulo es pago a cuotas',
  PRIMARY KEY (`id`),
  KEY `document_fee_document_id_foreign` (`document_id`),
  KEY `document_fee_currency_type_id_foreign` (`currency_type_id`),
  CONSTRAINT `document_fee_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `document_fee_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `document_fee` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_fee` ENABLE KEYS */;
DROP TABLE IF EXISTS `document_hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_hotels` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int unsigned NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identity_document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sex` enum('M','F') COLLATE utf8mb4_unicode_ci NOT NULL,
  `age` int NOT NULL,
  `civil_status` enum('S','C','V','D') COLLATE utf8mb4_unicode_ci NOT NULL,
  `nacionality` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `origin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `room_number` int NOT NULL,
  `date_entry` date NOT NULL,
  `time_entry` time NOT NULL,
  `date_exit` date NOT NULL,
  `time_exit` time NOT NULL,
  `ocupation` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `room_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `guests` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `document_hotels_document_id_foreign` (`document_id`),
  KEY `document_hotels_identity_document_type_id_foreign` (`identity_document_type_id`),
  CONSTRAINT `document_hotels_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `document_hotels_identity_document_type_id_foreign` FOREIGN KEY (`identity_document_type_id`) REFERENCES `cat_identity_document_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `document_hotels` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_hotels` ENABLE KEYS */;
DROP TABLE IF EXISTS `document_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_value` decimal(16,6) NOT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_plastic_bag_taxes` decimal(6,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(16,6) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  `additional_information` text COLLATE utf8mb4_unicode_ci,
  `warehouse_id` int unsigned DEFAULT NULL,
  `name_product_pdf` longtext COLLATE utf8mb4_unicode_ci,
  `additional_data` json DEFAULT NULL,
  `name_product_xml` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `document_items_document_id_foreign` (`document_id`),
  KEY `document_items_item_id_foreign` (`item_id`),
  KEY `document_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `document_items_system_isc_type_id_foreign` (`system_isc_type_id`),
  KEY `document_items_price_type_id_foreign` (`price_type_id`),
  KEY `document_items_warehouse_id_foreign` (`warehouse_id`),
  CONSTRAINT `document_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `document_items_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `document_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `document_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `document_items_system_isc_type_id_foreign` FOREIGN KEY (`system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`),
  CONSTRAINT `document_items_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `document_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `document_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `card_brand_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_received` tinyint(1) DEFAULT NULL,
  `change` decimal(12,2) DEFAULT NULL,
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `document_payments_document_id_foreign` (`document_id`),
  KEY `document_payments_card_brand_id_foreign` (`card_brand_id`),
  KEY `document_payments_payment_method_type_id_foreign` (`payment_method_type_id`),
  KEY `document_payments_date_of_payment_index` (`date_of_payment`),
  CONSTRAINT `document_payments_card_brand_id_foreign` FOREIGN KEY (`card_brand_id`) REFERENCES `card_brands` (`id`),
  CONSTRAINT `document_payments_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `document_payments_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `document_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `document_transports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_transports` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int unsigned NOT NULL,
  `seat_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `passenger_manifest` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identity_document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number_identity_document` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `passenger_fullname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `origin_district_id` json NOT NULL,
  `origin_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destinatation_district_id` json NOT NULL,
  `destinatation_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `document_transports_document_id_foreign` (`document_id`),
  KEY `document_transports_identity_document_type_id_foreign` (`identity_document_type_id`),
  CONSTRAINT `document_transports_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `document_transports_identity_document_type_id_foreign` FOREIGN KEY (`identity_document_type_id`) REFERENCES `cat_identity_document_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `document_transports` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_transports` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_actions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_actions` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_documents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_documents` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_file_offices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_file_offices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `documentary_file_id` int unsigned NOT NULL,
  `documentary_office_id` int unsigned NOT NULL,
  `documentary_action_id` int unsigned NOT NULL DEFAULT '0',
  `status` enum('POR DERIVAR','POR RECIBIR','EN PROCESO','FINALIZADO','ARCHIVADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'POR DERIVAR',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `office_name` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Nombre de la etapa',
  `process_name` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Nombre del tramite',
  `documentary_process_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'Tramite relacionado',
  `complete` int NOT NULL DEFAULT '0' COMMENT 'Define si la etapa esta completa',
  `start_date` datetime DEFAULT NULL COMMENT 'Fecha de inicio',
  `end_date` datetime DEFAULT NULL COMMENT 'Fecha de finalizacion',
  `days` int unsigned DEFAULT '0' COMMENT 'dias para el tramite',
  `observation` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `documentary_file_offices_documentary_file_id_foreign` (`documentary_file_id`),
  KEY `documentary_file_offices_documentary_office_id_foreign` (`documentary_office_id`),
  KEY `documentary_file_offices_documentary_action_id_foreign` (`documentary_action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_file_offices` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_file_offices` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_files` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `documentary_document_id` int unsigned DEFAULT '0',
  `documentary_process_id` int unsigned NOT NULL,
  `number` mediumtext COLLATE utf8mb4_unicode_ci,
  `year` int unsigned NOT NULL,
  `invoice` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_register` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time_register` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `person_id` int unsigned NOT NULL,
  `sender` longtext COLLATE utf8mb4_unicode_ci,
  `subject` longtext COLLATE utf8mb4_unicode_ci,
  `attached_file` longtext COLLATE utf8mb4_unicode_ci,
  `observation` text COLLATE utf8mb4_unicode_ci,
  `status` enum('RECIBIDO','DERIVADO','FINALIZADO','ARCHIVADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RECIBIDO',
  `documentary_office_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'Define el ultimo proceso',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `requirements` longtext COLLATE utf8mb4_unicode_ci,
  `is_archive` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'define si el tramite es simplificado',
  `is_simplify` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'define si el tramite es simplificado',
  `documentary_guides_number_status_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'Cuando es simplificado, se usará este status',
  `is_completed` tinyint(1) NOT NULL DEFAULT '0',
  `establishment_id` int unsigned NOT NULL DEFAULT '0',
  `date_end` datetime DEFAULT NULL COMMENT 'Fecha de finalización',
  PRIMARY KEY (`id`),
  KEY `documentary_files_documentary_document_id_foreign` (`documentary_document_id`),
  KEY `documentary_files_documentary_process_id_foreign` (`documentary_process_id`),
  KEY `documentary_files_person_id_foreign` (`person_id`),
  KEY `documentary_files_user_id_foreign` (`user_id`),
  CONSTRAINT `documentary_files_documentary_process_id_foreign` FOREIGN KEY (`documentary_process_id`) REFERENCES `documentary_processes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `documentary_files_person_id_foreign` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `documentary_files_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_files` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_files_archives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_files_archives` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'usuario asociado',
  `documentary_file_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'Solicitud asociada',
  `documentary_office_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'etapa asociada',
  `observation` longtext COLLATE utf8mb4_unicode_ci COMMENT 'observacion',
  `attached_file` longtext COLLATE utf8mb4_unicode_ci COMMENT 'etapa asociada',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `documentary_guides_number_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_files_archives` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_files_archives` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_files_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_files_requirements` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Nombre a mostrar',
  `file` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Define si tiene archivo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_files_requirements` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_files_requirements` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_guides_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_guides_number` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `doc_file_id` int unsigned DEFAULT '0' COMMENT 'Expediente relacionado',
  `doc_office_id` int unsigned DEFAULT '0' COMMENT 'Etapa observada',
  `guide` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Especifica la guia',
  `origin` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Especifica la instucion',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `date_of_due` datetime DEFAULT NULL,
  `observation` longtext COLLATE utf8mb4_unicode_ci,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `date_take` datetime DEFAULT NULL COMMENT 'Fecha estimada de finalización',
  `date_end` datetime DEFAULT NULL COMMENT 'Fecha de finalización',
  `documentary_guides_number_status_id` int unsigned DEFAULT '0' COMMENT 'relacionado con documentary_guides_number_status',
  `user_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'Responsable',
  `total_day` int unsigned DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_guides_number` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_guides_number` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_guides_number_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_guides_number_status` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_guides_number_status` DISABLE KEYS */;
INSERT INTO `documentary_guides_number_status` VALUES (1,'En Calificación',NULL),(2,'Concluidos',NULL),(3,'Observados',NULL),(4,'Archivados',NULL);
/*!40000 ALTER TABLE `documentary_guides_number_status` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_observation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_observation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `doc_file_id` int unsigned DEFAULT '0' COMMENT 'Expediente relacionado',
  `observation` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Conjunto de etapas.',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_observation` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_observation` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_offices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_offices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `days` mediumint unsigned NOT NULL DEFAULT '0',
  `default` tinyint unsigned NOT NULL DEFAULT '0',
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_offices` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_offices` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_processes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_processes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,5) NOT NULL DEFAULT '0.00000',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `documentary_offices` longtext COLLATE utf8mb4_unicode_ci COMMENT 'etapas que contiene',
  `documentary_offices_order` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_processes` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_processes` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_processes_rel_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_processes_rel_file` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `doc_processes_id` int unsigned DEFAULT '0' COMMENT 'Requerimiento relacionado',
  `doc_file_id` int unsigned DEFAULT '0' COMMENT 'Expediente relacionado',
  `doc_office_id` int unsigned DEFAULT '0' COMMENT 'Etapa actual',
  `stages` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Conjunto de etapas.',
  `complete` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Define si se ha completado',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_processes_rel_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_processes_rel_file` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_processes_rel_off`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_processes_rel_off` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `doc_processes_id` int unsigned DEFAULT '0' COMMENT 'Requerimiento relacionado',
  `doc_offices_id` int unsigned DEFAULT '0' COMMENT 'Proceso relacionado',
  `active` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Status de la relacion',
  `order` int unsigned DEFAULT '1' COMMENT 'Establece el orden del proceso',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_processes_rel_off` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_processes_rel_off` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentary_processes_rel_req`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentary_processes_rel_req` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `doc_processes_id` int unsigned DEFAULT '0' COMMENT 'Requerimiento relacionado',
  `doc_files_requirements_id` int unsigned DEFAULT '0' COMMENT 'Proceso relacionado',
  `active` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Status de la relacion',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentary_processes_rel_req` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentary_processes_rel_req` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentos_recibidos_aditional_sri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentos_recibidos_aditional_sri` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int unsigned NOT NULL,
  `nombre` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `documentos_recibidos_aditional_sri_document_id_foreign` (`document_id`),
  CONSTRAINT `documentos_recibidos_aditional_sri_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documentos_recibidos_sri` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentos_recibidos_aditional_sri` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentos_recibidos_aditional_sri` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentos_recibidos_detail_sri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentos_recibidos_detail_sri` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int unsigned NOT NULL,
  `codigoPrincipal` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` double NOT NULL,
  `precioUnitario` double NOT NULL,
  `descuento` double NOT NULL,
  `precioTotalSinImpuesto` double NOT NULL,
  `impuestos` json NOT NULL,
  PRIMARY KEY (`id`),
  KEY `documentos_recibidos_detail_sri_document_id_foreign` (`document_id`),
  CONSTRAINT `documentos_recibidos_detail_sri_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documentos_recibidos_sri` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentos_recibidos_detail_sri` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentos_recibidos_detail_sri` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentos_recibidos_pendientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentos_recibidos_pendientes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `archivo_id` bigint unsigned NOT NULL,
  `ruc_emisor` varchar(13) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social_emisor` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_documento` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serie_comprobante` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clave_acceso` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_autorizacion` datetime NOT NULL,
  `fecha_emision` date NOT NULL,
  `identificador_receptor` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_sin_impuestos` float DEFAULT NULL,
  `iva` float DEFAULT NULL,
  `importe_total` float DEFAULT NULL,
  `numero_documento_modificado` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `documentos_recibidos_pendientes_archivo_id_foreign` (`archivo_id`),
  CONSTRAINT `documentos_recibidos_pendientes_archivo_id_foreign` FOREIGN KEY (`archivo_id`) REFERENCES `archivos_procesar` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentos_recibidos_pendientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentos_recibidos_pendientes` ENABLE KEYS */;
DROP TABLE IF EXISTS `documentos_recibidos_sri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentos_recibidos_sri` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `ambiente` int NOT NULL,
  `tipoEmision` int NOT NULL,
  `razonSocial` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombreComercial` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc` varchar(13) COLLATE utf8mb4_unicode_ci NOT NULL,
  `claveAcceso` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codDoc` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estab` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ptoEmi` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secuencial` char(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dirMatriz` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `agenteRetencion` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contribuyenteRimpe` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaEmision` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dirEstablecimiento` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `obligadoContabilidad` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipoIdentificacionComprador` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razonSocialComprador` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identificacionComprador` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccionComprador` longtext COLLATE utf8mb4_unicode_ci,
  `totalSinImpuestos` double NOT NULL,
  `totalDescuento` double NOT NULL,
  `totalConImpuestos` json NOT NULL,
  `propina` double NOT NULL,
  `importeTotal` double NOT NULL,
  `moneda` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'DOLAR',
  `pagos` json NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documentos_recibidos_sri` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentos_recibidos_sri` ENABLE KEYS */;
DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_authorization` date DEFAULT NULL,
  `time_authorization` time DEFAULT NULL,
  `clave_SRI` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubl_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ticket_single_shipment` tinyint(1) NOT NULL DEFAULT '0',
  `force_send_by_summary` tinyint(1) NOT NULL DEFAULT '0',
  `group_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_condition_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purchase_order` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `plate_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quotation_id` int unsigned DEFAULT NULL,
  `sale_note_id` int unsigned DEFAULT NULL,
  `user_rel_suscription_plan_id` int unsigned DEFAULT '0' COMMENT 'Relacion con suscripciones',
  `technical_service_id` int unsigned DEFAULT NULL,
  `order_note_id` int unsigned DEFAULT NULL,
  `dispatch_id` int unsigned DEFAULT NULL,
  `seller_id` int unsigned DEFAULT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `point_system` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'indica si el documento se uso en sistema por puntos',
  `point_system_data` json DEFAULT NULL COMMENT 'datos de sistema por puntos',
  `automatic_date_of_issue` date DEFAULT NULL,
  `type_period` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity_period` int DEFAULT NULL,
  `enabled_concurrency` tinyint unsigned DEFAULT '0',
  `apply_concurrency` tinyint unsigned DEFAULT '0',
  `total_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exportation` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_plastic_bag_taxes` decimal(6,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `dispatch_ticket_pdf` tinyint(1) NOT NULL DEFAULT '0',
  `has_prepayment` tinyint(1) NOT NULL DEFAULT '0',
  `affectation_type_prepayment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `was_deducted_prepayment` tinyint(1) NOT NULL DEFAULT '0',
  `pending_amount_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_pending_payment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `charges` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `guides` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `perception` json DEFAULT NULL,
  `detraction` json DEFAULT NULL,
  `retention` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `additional_information` text COLLATE utf8mb4_unicode_ci,
  `additional_data` json DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unique_filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qr` longtext COLLATE utf8mb4_unicode_ci COMMENT ' ',
  `reference_data` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `agent_id` int unsigned DEFAULT NULL,
  `has_xml` tinyint(1) NOT NULL DEFAULT '0',
  `has_pdf` tinyint(1) NOT NULL DEFAULT '0',
  `has_cdr` tinyint(1) NOT NULL DEFAULT '0',
  `data_json` json DEFAULT NULL,
  `send_server` tinyint(1) NOT NULL DEFAULT '1',
  `success_shipping_status` tinyint(1) NOT NULL DEFAULT '0',
  `shipping_status` json DEFAULT NULL,
  `success_sunat_shipping_status` tinyint(1) NOT NULL DEFAULT '0',
  `sunat_shipping_status` json DEFAULT NULL,
  `query_status` json DEFAULT NULL,
  `success_query_status` tinyint(1) NOT NULL DEFAULT '0',
  `total_canceled` tinyint(1) NOT NULL DEFAULT '0',
  `soap_shipping_response` json DEFAULT NULL,
  `regularize_shipping` tinyint(1) NOT NULL DEFAULT '0',
  `response_regularize_shipping` json DEFAULT NULL,
  `send_to_pse` tinyint(1) NOT NULL DEFAULT '0',
  `response_signature_pse` json DEFAULT NULL,
  `response_send_cdr_pse` json DEFAULT NULL,
  `sale_notes_relateds` json DEFAULT NULL COMMENT 'registros asociados cuando se genera cpe desde multiples notas de venta',
  `terms_condition` text COLLATE utf8mb4_unicode_ci,
  `folio` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_editable` tinyint(1) NOT NULL DEFAULT '0',
  `grade` text COLLATE utf8mb4_unicode_ci COMMENT 'Grado designado - utilizado en matricula',
  `section` text COLLATE utf8mb4_unicode_ci COMMENT 'Seccion designado - utilizado en matricula',
  PRIMARY KEY (`id`),
  UNIQUE KEY `documents_unique_filename_unique` (`unique_filename`),
  KEY `documents_user_id_foreign` (`user_id`),
  KEY `documents_establishment_id_foreign` (`establishment_id`),
  KEY `documents_customer_id_foreign` (`customer_id`),
  KEY `documents_soap_type_id_foreign` (`soap_type_id`),
  KEY `documents_state_type_id_foreign` (`state_type_id`),
  KEY `documents_group_id_foreign` (`group_id`),
  KEY `documents_document_type_id_foreign` (`document_type_id`),
  KEY `documents_currency_type_id_foreign` (`currency_type_id`),
  KEY `documents_quotation_id_foreign` (`quotation_id`),
  KEY `documents_external_id_index` (`external_id`),
  KEY `documents_sale_note_id_foreign` (`sale_note_id`),
  KEY `documents_series_index` (`series`),
  KEY `documents_number_index` (`number`),
  KEY `documents_date_of_issue_index` (`date_of_issue`),
  KEY `documents_order_note_id_foreign` (`order_note_id`),
  KEY `documents_payment_method_type_id_foreign` (`payment_method_type_id`),
  KEY `documents_seller_id_foreign` (`seller_id`),
  KEY `documents_payment_condition_id_foreign` (`payment_condition_id`),
  KEY `documents_dispatch_id_foreign` (`dispatch_id`),
  KEY `documents_technical_service_id_foreign` (`technical_service_id`),
  KEY `documents_type_period_index` (`type_period`),
  KEY `documents_regularize_shipping_index` (`regularize_shipping`),
  KEY `documents_ticket_single_shipment_index` (`ticket_single_shipment`),
  KEY `documents_agent_id_foreign` (`agent_id`),
  KEY `documents_force_send_by_summary_index` (`force_send_by_summary`),
  CONSTRAINT `documents_agent_id_foreign` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`),
  CONSTRAINT `documents_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `documents_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `documents_dispatch_id_foreign` FOREIGN KEY (`dispatch_id`) REFERENCES `dispatches` (`id`),
  CONSTRAINT `documents_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `documents_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `documents_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `documents_order_note_id_foreign` FOREIGN KEY (`order_note_id`) REFERENCES `order_notes` (`id`),
  CONSTRAINT `documents_payment_condition_id_foreign` FOREIGN KEY (`payment_condition_id`) REFERENCES `payment_conditions` (`id`),
  CONSTRAINT `documents_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `documents_quotation_id_foreign` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`),
  CONSTRAINT `documents_sale_note_id_foreign` FOREIGN KEY (`sale_note_id`) REFERENCES `sale_notes` (`id`),
  CONSTRAINT `documents_seller_id_foreign` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`),
  CONSTRAINT `documents_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `documents_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `documents_technical_service_id_foreign` FOREIGN KEY (`technical_service_id`) REFERENCES `technical_services` (`id`),
  CONSTRAINT `documents_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
DROP TABLE IF EXISTS `download_tray`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `download_tray` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `module` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IN_PROCESS',
  `date_init` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `payload_request` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `download_tray_user_id_foreign` (`user_id`),
  CONSTRAINT `download_tray_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `download_tray` DISABLE KEYS */;
/*!40000 ALTER TABLE `download_tray` ENABLE KEYS */;
DROP TABLE IF EXISTS `drivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drivers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `identity_document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `license` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `drivers_identity_document_type_id_foreign` (`identity_document_type_id`),
  KEY `drivers_number_index` (`number`),
  KEY `drivers_name_index` (`name`),
  CONSTRAINT `drivers_identity_document_type_id_foreign` FOREIGN KEY (`identity_document_type_id`) REFERENCES `cat_identity_document_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `drivers` DISABLE KEYS */;
/*!40000 ALTER TABLE `drivers` ENABLE KEYS */;
DROP TABLE IF EXISTS `email_send_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_send_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `relation_id` int unsigned DEFAULT '0' COMMENT 'Id de modelo',
  `type` int unsigned DEFAULT '0' COMMENT 'Tipo de relacion',
  `relation_model` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Modelo a relacion',
  `file_line` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Archivo qu elo llama',
  `sendit` tinyint unsigned DEFAULT '1' COMMENT 'Booleano para envio de correo',
  `email` text COLLATE utf8mb4_unicode_ci COMMENT 'Correo de destino',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `email_send_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_send_log` ENABLE KEYS */;
DROP TABLE IF EXISTS `establishments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `establishments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `province_id` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `district_id` char(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telephone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `aditional_information` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `web_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trade_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_id` int unsigned DEFAULT NULL,
  `logo` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template_pdf` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `has_igv_31556` tinyint(1) NOT NULL DEFAULT '0',
  `template_ticket_pdf` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `establishments_country_id_foreign` (`country_id`),
  KEY `establishments_department_id_foreign` (`department_id`),
  KEY `establishments_province_id_foreign` (`province_id`),
  KEY `establishments_district_id_foreign` (`district_id`),
  CONSTRAINT `establishments_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`),
  CONSTRAINT `establishments_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  CONSTRAINT `establishments_district_id_foreign` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `establishments_province_id_foreign` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `establishments` DISABLE KEYS */;
/*!40000 ALTER TABLE `establishments` ENABLE KEYS */;
DROP TABLE IF EXISTS `exchange_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exchange_rates` (
  `date` date NOT NULL,
  `sale_original` decimal(13,3) NOT NULL,
  `purchase_original` decimal(13,3) NOT NULL,
  `purchase` decimal(13,3) NOT NULL,
  `sale` decimal(13,3) NOT NULL,
  `date_original` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `exchange_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `exchange_rates` ENABLE KEYS */;
DROP TABLE IF EXISTS `expense_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `expense_id` int unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `expense_items_expense_id_foreign` (`expense_id`),
  CONSTRAINT `expense_items_expense_id_foreign` FOREIGN KEY (`expense_id`) REFERENCES `expenses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `expense_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `expense_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `expense_method_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_method_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `expense_method_types` DISABLE KEYS */;
INSERT INTO `expense_method_types` VALUES (1,'CAJA GENERAL',0);
/*!40000 ALTER TABLE `expense_method_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `expense_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `expense_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `expense_method_type_id` int unsigned NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `card_brand_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `expense_payments_expense_id_foreign` (`expense_id`),
  KEY `expense_payments_card_brand_id_foreign` (`card_brand_id`),
  KEY `expense_payments_expense_method_type_id_foreign` (`expense_method_type_id`),
  KEY `expense_payments_date_of_payment_index` (`date_of_payment`),
  CONSTRAINT `expense_payments_card_brand_id_foreign` FOREIGN KEY (`card_brand_id`) REFERENCES `card_brands` (`id`),
  CONSTRAINT `expense_payments_expense_id_foreign` FOREIGN KEY (`expense_id`) REFERENCES `expenses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `expense_payments_expense_method_type_id_foreign` FOREIGN KEY (`expense_method_type_id`) REFERENCES `expense_method_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `expense_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `expense_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `expense_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_reasons` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `expense_reasons` DISABLE KEYS */;
INSERT INTO `expense_reasons` VALUES (1,'Varios'),(2,'Representación de la organización'),(3,'Trabajo de campo');
/*!40000 ALTER TABLE `expense_reasons` ENABLE KEYS */;
DROP TABLE IF EXISTS `expense_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `expense_types` DISABLE KEYS */;
INSERT INTO `expense_types` VALUES (1,'PLANILLA','2026-07-26 19:36:56','2026-07-26 19:36:56'),(2,'RECIBO POR HONORARIO','2026-07-26 19:36:56','2026-07-26 19:36:56'),(3,'SERVICIO PÚBLICO','2026-07-26 19:36:56','2026-07-26 19:36:56'),(4,'OTROS','2026-07-26 19:36:56','2026-07-26 19:36:56');
/*!40000 ALTER TABLE `expense_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expense_type_id` int unsigned NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `supplier_id` int unsigned NOT NULL,
  `expense_reason_id` int unsigned NOT NULL DEFAULT '1',
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `supplier` json NOT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `expenses_filename_unique` (`filename`),
  KEY `expenses_user_id_foreign` (`user_id`),
  KEY `expenses_establishment_id_foreign` (`establishment_id`),
  KEY `expenses_supplier_id_foreign` (`supplier_id`),
  KEY `expenses_expense_type_id_foreign` (`expense_type_id`),
  KEY `expenses_currency_type_id_foreign` (`currency_type_id`),
  KEY `expenses_expense_reason_id_foreign` (`expense_reason_id`),
  KEY `expenses_soap_type_id_foreign` (`soap_type_id`),
  KEY `expenses_state_type_id_foreign` (`state_type_id`),
  CONSTRAINT `expenses_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `expenses_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `expenses_expense_reason_id_foreign` FOREIGN KEY (`expense_reason_id`) REFERENCES `expense_reasons` (`id`),
  CONSTRAINT `expenses_expense_type_id_foreign` FOREIGN KEY (`expense_type_id`) REFERENCES `expense_types` (`id`),
  CONSTRAINT `expenses_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `expenses_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `expenses_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `expenses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
DROP TABLE IF EXISTS `fixed_asset_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fixed_asset_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `internal_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `purchase_unit_price` decimal(16,6) NOT NULL,
  `purchase_affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fixed_asset_items_item_type_id_foreign` (`item_type_id`),
  KEY `fixed_asset_items_unit_type_id_foreign` (`unit_type_id`),
  KEY `fixed_asset_items_currency_type_id_foreign` (`currency_type_id`),
  KEY `fixed_asset_items_purchase_affectation_igv_type_id_foreign` (`purchase_affectation_igv_type_id`),
  CONSTRAINT `fixed_asset_items_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `fixed_asset_items_item_type_id_foreign` FOREIGN KEY (`item_type_id`) REFERENCES `item_types` (`id`),
  CONSTRAINT `fixed_asset_items_purchase_affectation_igv_type_id_foreign` FOREIGN KEY (`purchase_affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `fixed_asset_items_unit_type_id_foreign` FOREIGN KEY (`unit_type_id`) REFERENCES `cat_unit_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `fixed_asset_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `fixed_asset_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `fixed_asset_purchase_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fixed_asset_purchase_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `fixed_asset_purchase_id` int unsigned NOT NULL,
  `fixed_asset_item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_value` decimal(16,6) NOT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(16,6) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fixed_asset_purchase_items_fixed_asset_purchase_id_foreign` (`fixed_asset_purchase_id`),
  KEY `fixed_asset_purchase_items_fixed_asset_item_id_foreign` (`fixed_asset_item_id`),
  KEY `fixed_asset_purchase_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `fixed_asset_purchase_items_system_isc_type_id_foreign` (`system_isc_type_id`),
  KEY `fixed_asset_purchase_items_price_type_id_foreign` (`price_type_id`),
  CONSTRAINT `fixed_asset_purchase_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `fixed_asset_purchase_items_fixed_asset_item_id_foreign` FOREIGN KEY (`fixed_asset_item_id`) REFERENCES `fixed_asset_items` (`id`),
  CONSTRAINT `fixed_asset_purchase_items_fixed_asset_purchase_id_foreign` FOREIGN KEY (`fixed_asset_purchase_id`) REFERENCES `fixed_asset_purchases` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fixed_asset_purchase_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `fixed_asset_purchase_items_system_isc_type_id_foreign` FOREIGN KEY (`system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `fixed_asset_purchase_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `fixed_asset_purchase_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `fixed_asset_purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fixed_asset_purchases` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `group_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `date_of_due` date DEFAULT NULL,
  `time_of_issue` time NOT NULL,
  `supplier_id` int unsigned NOT NULL,
  `supplier` json NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `total_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exportation` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `customer_id` int unsigned DEFAULT NULL,
  `perception_date` date DEFAULT NULL,
  `perception_number` int DEFAULT NULL,
  `total_perception` decimal(12,2) DEFAULT NULL,
  `charges` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `guides` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `perception` json DEFAULT NULL,
  `detraction` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fixed_asset_purchases_user_id_foreign` (`user_id`),
  KEY `fixed_asset_purchases_establishment_id_foreign` (`establishment_id`),
  KEY `fixed_asset_purchases_supplier_id_foreign` (`supplier_id`),
  KEY `fixed_asset_purchases_customer_id_foreign` (`customer_id`),
  KEY `fixed_asset_purchases_soap_type_id_foreign` (`soap_type_id`),
  KEY `fixed_asset_purchases_state_type_id_foreign` (`state_type_id`),
  KEY `fixed_asset_purchases_group_id_foreign` (`group_id`),
  KEY `fixed_asset_purchases_document_type_id_foreign` (`document_type_id`),
  KEY `fixed_asset_purchases_currency_type_id_foreign` (`currency_type_id`),
  CONSTRAINT `fixed_asset_purchases_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `fixed_asset_purchases_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `fixed_asset_purchases_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `fixed_asset_purchases_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `fixed_asset_purchases_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `fixed_asset_purchases_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `fixed_asset_purchases_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `fixed_asset_purchases_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `fixed_asset_purchases_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `fixed_asset_purchases` DISABLE KEYS */;
/*!40000 ALTER TABLE `fixed_asset_purchases` ENABLE KEYS */;
DROP TABLE IF EXISTS `format_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `format_templates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `formats` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `urls` json DEFAULT NULL,
  `is_custom_ticket` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `format_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `format_templates` ENABLE KEYS */;
DROP TABLE IF EXISTS `full_suscription_server_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `full_suscription_server_data` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `person_id` int unsigned DEFAULT '0',
  `host` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `full_suscription_server_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `full_suscription_server_data` ENABLE KEYS */;
DROP TABLE IF EXISTS `full_suscription_user_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `full_suscription_user_data` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `person_id` int unsigned DEFAULT '0',
  `discord_user` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slack_channel` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discord_channel` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gitlab_user` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `full_suscription_user_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `full_suscription_user_data` ENABLE KEYS */;
DROP TABLE IF EXISTS `general_payment_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `general_payment_conditions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `general_payment_conditions` DISABLE KEYS */;
INSERT INTO `general_payment_conditions` VALUES ('01','Contado'),('02','Crédito'),('03','Crédito con cuotas');
/*!40000 ALTER TABLE `general_payment_conditions` ENABLE KEYS */;
DROP TABLE IF EXISTS `global_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `global_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_id` int DEFAULT NULL,
  `destination_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_id` int NOT NULL,
  `payment_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `destination_index` (`destination_id`,`destination_type`),
  KEY `payment_index` (`payment_id`,`payment_type`),
  KEY `global_payments_soap_type_id_foreign` (`soap_type_id`),
  KEY `global_payments_user_id_foreign` (`user_id`),
  CONSTRAINT `global_payments_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `global_payments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `global_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `global_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES ('01','Facturas'),('02','Boletas');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
DROP TABLE IF EXISTS `guide_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guide_files` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `filename` text COLLATE utf8mb4_unicode_ci COMMENT 'Nombre de archivo',
  `purchase_id` int unsigned DEFAULT '0' COMMENT 'Relacion con purchases',
  `document_id` int unsigned DEFAULT '0' COMMENT 'Relacion con documents',
  `order_note_id` int unsigned DEFAULT '0' COMMENT 'Relacion con order_notes',
  `quotation_id` int unsigned DEFAULT '0' COMMENT 'Relacion con quotations',
  `sale_note_id` int unsigned DEFAULT '0' COMMENT 'Relacion con sale_notes',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `guide_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `guide_files` ENABLE KEYS */;
DROP TABLE IF EXISTS `hotel_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `hotel_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_categories` ENABLE KEYS */;
DROP TABLE IF EXISTS `hotel_floors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_floors` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `hotel_floors` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_floors` ENABLE KEYS */;
DROP TABLE IF EXISTS `hotel_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_rates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `hotel_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_rates` ENABLE KEYS */;
DROP TABLE IF EXISTS `hotel_rent_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_rent_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hotel_rent_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` text COLLATE utf8mb4_unicode_ci,
  `payment_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hotel_rent_items_hotel_rent_id_foreign` (`hotel_rent_id`),
  KEY `hotel_rent_items_item_id_foreign` (`item_id`),
  CONSTRAINT `hotel_rent_items_hotel_rent_id_foreign` FOREIGN KEY (`hotel_rent_id`) REFERENCES `hotel_rents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hotel_rent_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `hotel_rent_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_rent_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `hotel_rents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_rents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int unsigned NOT NULL,
  `customer` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `towels` int NOT NULL DEFAULT '1',
  `hotel_room_id` int unsigned NOT NULL,
  `hotel_rate_id` int unsigned DEFAULT NULL,
  `duration` int NOT NULL DEFAULT '1',
  `quantity_persons` int NOT NULL DEFAULT '1',
  `payment_status` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `output_date` date NOT NULL,
  `output_time` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `arrears` int NOT NULL DEFAULT '0',
  `status` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'INICIADO',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `input_date` date DEFAULT NULL,
  `input_time` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hotel_rents_hotel_rate_id_foreign` (`hotel_rate_id`),
  CONSTRAINT `hotel_rents_hotel_rate_id_foreign` FOREIGN KEY (`hotel_rate_id`) REFERENCES `hotel_rates` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `hotel_rents` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_rents` ENABLE KEYS */;
DROP TABLE IF EXISTS `hotel_room_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_room_rates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `hotel_room_id` int unsigned NOT NULL,
  `hotel_rate_id` int unsigned NOT NULL,
  `price` double NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hotel_room_rates_hotel_room_id_foreign` (`hotel_room_id`),
  KEY `hotel_room_rates_hotel_rate_id_foreign` (`hotel_rate_id`),
  CONSTRAINT `hotel_room_rates_hotel_rate_id_foreign` FOREIGN KEY (`hotel_rate_id`) REFERENCES `hotel_rates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hotel_room_rates_hotel_room_id_foreign` FOREIGN KEY (`hotel_room_id`) REFERENCES `hotel_rooms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `hotel_room_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_room_rates` ENABLE KEYS */;
DROP TABLE IF EXISTS `hotel_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_rooms` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned DEFAULT NULL,
  `hotel_category_id` int unsigned NOT NULL,
  `hotel_floor_id` int unsigned NOT NULL,
  `name` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DISPONIBLE',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hotel_rooms_hotel_category_id_foreign` (`hotel_category_id`),
  KEY `hotel_rooms_hotel_floor_id_foreign` (`hotel_floor_id`),
  KEY `hotel_rooms_item_id_foreign` (`item_id`),
  CONSTRAINT `hotel_rooms_hotel_category_id_foreign` FOREIGN KEY (`hotel_category_id`) REFERENCES `hotel_categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hotel_rooms_hotel_floor_id_foreign` FOREIGN KEY (`hotel_floor_id`) REFERENCES `hotel_floors` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hotel_rooms_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `hotel_rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_rooms` ENABLE KEYS */;
DROP TABLE IF EXISTS `impuestos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `impuestos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `retencion_id` bigint unsigned NOT NULL,
  `codigo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_retencion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `base_imponible` decimal(10,2) NOT NULL,
  `porcentaje_retener` decimal(5,2) NOT NULL,
  `valor_retenido` decimal(10,2) NOT NULL,
  `cod_doc_sustento` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `num_doc_sustento` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_emision_doc_sustento` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `impuestos_retencion_id_foreign` (`retencion_id`),
  CONSTRAINT `impuestos_retencion_id_foreign` FOREIGN KEY (`retencion_id`) REFERENCES `retenciones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `impuestos` DISABLE KEYS */;
/*!40000 ALTER TABLE `impuestos` ENABLE KEYS */;
DROP TABLE IF EXISTS `income`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `income_type_id` int unsigned NOT NULL,
  `income_reason_id` int unsigned NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `customer` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `income_filename_unique` (`filename`),
  KEY `income_user_id_foreign` (`user_id`),
  KEY `income_establishment_id_foreign` (`establishment_id`),
  KEY `income_income_type_id_foreign` (`income_type_id`),
  KEY `income_income_reason_id_foreign` (`income_reason_id`),
  KEY `income_state_type_id_foreign` (`state_type_id`),
  KEY `income_soap_type_id_foreign` (`soap_type_id`),
  KEY `income_currency_type_id_foreign` (`currency_type_id`),
  KEY `income_number_index` (`number`),
  KEY `income_date_of_issue_index` (`date_of_issue`),
  KEY `income_external_id_index` (`external_id`),
  CONSTRAINT `income_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `income_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `income_income_reason_id_foreign` FOREIGN KEY (`income_reason_id`) REFERENCES `income_reasons` (`id`),
  CONSTRAINT `income_income_type_id_foreign` FOREIGN KEY (`income_type_id`) REFERENCES `income_types` (`id`),
  CONSTRAINT `income_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `income_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `income_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `income` DISABLE KEYS */;
/*!40000 ALTER TABLE `income` ENABLE KEYS */;
DROP TABLE IF EXISTS `income_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `income_id` int unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `income_items_income_id_foreign` (`income_id`),
  CONSTRAINT `income_items_income_id_foreign` FOREIGN KEY (`income_id`) REFERENCES `income` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `income_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `income_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `income_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `income_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `card_brand_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `change` decimal(12,2) DEFAULT NULL,
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `income_payments_income_id_foreign` (`income_id`),
  KEY `income_payments_card_brand_id_foreign` (`card_brand_id`),
  KEY `income_payments_payment_method_type_id_foreign` (`payment_method_type_id`),
  CONSTRAINT `income_payments_card_brand_id_foreign` FOREIGN KEY (`card_brand_id`) REFERENCES `card_brands` (`id`),
  CONSTRAINT `income_payments_income_id_foreign` FOREIGN KEY (`income_id`) REFERENCES `income` (`id`) ON DELETE CASCADE,
  CONSTRAINT `income_payments_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `income_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `income_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `income_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income_reasons` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `income_reasons` DISABLE KEYS */;
INSERT INTO `income_reasons` VALUES (1,'Varios');
/*!40000 ALTER TABLE `income_reasons` ENABLE KEYS */;
DROP TABLE IF EXISTS `income_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `income_types` DISABLE KEYS */;
INSERT INTO `income_types` VALUES (1,'INGRESOS FINANCIEROS','2026-07-26 19:37:51','2026-07-26 19:37:51'),(2,'PRESTAMOS','2026-07-26 19:37:51','2026-07-26 19:37:51'),(3,'OTROS','2026-07-26 19:37:51','2026-07-26 19:37:51');
/*!40000 ALTER TABLE `income_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('1','2','3') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `detail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` int unsigned NOT NULL,
  `warehouse_id` int unsigned NOT NULL,
  `warehouse_destination_id` int unsigned DEFAULT NULL,
  `inventory_transaction_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `lot_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inventories_transfer_id` int unsigned DEFAULT NULL,
  `comments` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_issue` date DEFAULT NULL,
  `system_stock` decimal(12,4) DEFAULT NULL,
  `real_stock` decimal(12,4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inventories_item_id_foreign` (`item_id`),
  KEY `inventories_warehouse_id_foreign` (`warehouse_id`),
  KEY `inventories_inventory_transaction_id_foreign` (`inventory_transaction_id`),
  KEY `inventories_inventories_transfer_id_foreign` (`inventories_transfer_id`),
  CONSTRAINT `inventories_inventories_transfer_id_foreign` FOREIGN KEY (`inventories_transfer_id`) REFERENCES `inventories_transfer` (`id`),
  CONSTRAINT `inventories_inventory_transaction_id_foreign` FOREIGN KEY (`inventory_transaction_id`) REFERENCES `inventory_transactions` (`id`),
  CONSTRAINT `inventories_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inventories_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `inventories` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventories` ENABLE KEYS */;
DROP TABLE IF EXISTS `inventories_transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventories_transfer` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warehouse_id` int unsigned NOT NULL,
  `warehouse_destination_id` int unsigned NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_id` int unsigned DEFAULT '0' COMMENT 'usuario que crea el registro',
  PRIMARY KEY (`id`),
  KEY `inventories_transfer_warehouse_id_foreign` (`warehouse_id`),
  KEY `inventories_transfer_warehouse_destination_id_foreign` (`warehouse_destination_id`),
  CONSTRAINT `inventories_transfer_warehouse_destination_id_foreign` FOREIGN KEY (`warehouse_destination_id`) REFERENCES `warehouses` (`id`),
  CONSTRAINT `inventories_transfer_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `inventories_transfer` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventories_transfer` ENABLE KEYS */;
DROP TABLE IF EXISTS `inventory_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_configurations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `stock_control` tinyint(1) NOT NULL DEFAULT '0',
  `validate_stock_add_item` tinyint(1) NOT NULL DEFAULT '0',
  `inventory_review` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `generate_internal_id` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `inventory_configurations` DISABLE KEYS */;
INSERT INTO `inventory_configurations` VALUES (1,0,0,0,NULL,NULL,0);
/*!40000 ALTER TABLE `inventory_configurations` ENABLE KEYS */;
DROP TABLE IF EXISTS `inventory_kardex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_kardex` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `date_of_issue` date NOT NULL,
  `item_id` int unsigned NOT NULL,
  `inventory_kardexable_id` int unsigned NOT NULL,
  `inventory_kardexable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `warehouse_id` int unsigned NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inventory_kardex_item_id_foreign` (`item_id`),
  KEY `inventory_kardex_warehouse_id_foreign` (`warehouse_id`),
  CONSTRAINT `inventory_kardex_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_kardex_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `inventory_kardex` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_kardex` ENABLE KEYS */;
DROP TABLE IF EXISTS `inventory_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_transactions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('input','output') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `inventory_transactions` DISABLE KEYS */;
INSERT INTO `inventory_transactions` VALUES ('01','Venta nacional','output'),('02','Compra nacional','input'),('03','Consignación recibida','input'),('04','Consignación entregada','output'),('05','Devolución recibida','input'),('06','Devolución entregada','output'),('07','Bonificación','output'),('08','Premio','output'),('09','Donación','output'),('10','Salida a producción','output'),('100','Ingreso insumos por molino','input'),('101','Salida por insumo','output'),('102','Entrada por importacion masiva (xlsx)','input'),('11','Salida por transferencia entre almacenes','output'),('12','Retiro','output'),('13','Mermas','output'),('14','Desmedros','output'),('15','Destrucción','output'),('16','Inventario inicial','input'),('17','Exportación','output'),('18','Entrada de importación','input'),('19','Ingreso de producción','input'),('20','Entrada por devolución de producción','input'),('21','Entrada por transferencia entre almacenes','input'),('22','Entrada por identificación erronea','input'),('23','Salida por identificación erronea','output'),('24','Entrada por devolución del cliente','input'),('25','Salida por devolución al proveedor','output'),('26','Entrada para servicio de producción','input'),('27','Salida por servicio de producción','output'),('28','Ajuste por diferencia de inventario','output'),('29','Entrada de bienes en prestamo','input'),('30','Salida de bienes en prestamo','output'),('31','Entrada de bienes en custodia','input'),('32','Salida de bienes en custodia','output'),('33','Muestras médicas','output'),('34','Publicidad','output'),('35','Gastos de representación','output'),('36','Retiro para entrega a trabajadores','output'),('37','Retiro por convenio colectivo','output'),('38','Retiro por sustitución de bien siniestrado','output'),('50','Ingreso temporal','input'),('51','Salida temporal','output'),('52','Ingreso por transformación','input'),('53','Salida para servicios terceros','output'),('54','Ingreso de producción','input'),('55','Entrada de importación','input'),('56','Salida por conversión de medida','output'),('57','Entrada por conversión de medida','input'),('91','Ingreso por transformación','input'),('93','Ingreso temporal','input'),('96','Entrada por conversión de medida','input'),('99','Otros','input');
/*!40000 ALTER TABLE `inventory_transactions` ENABLE KEYS */;
DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int unsigned NOT NULL,
  `operation_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_due` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `invoices_document_id_foreign` (`document_id`),
  KEY `invoices_operation_type_id_foreign` (`operation_type_id`),
  CONSTRAINT `invoices_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoices_operation_type_id_foreign` FOREIGN KEY (`operation_type_id`) REFERENCES `cat_operation_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_color`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_color` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `cat_colors_item_id` int unsigned NOT NULL,
  `active` tinyint DEFAULT '1' COMMENT 'Define si se encuentra activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_color` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_color` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_images` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_images_item_id_foreign` (`item_id`),
  CONSTRAINT `item_images_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_images` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_lots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_lots` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `series` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `item_id` int unsigned NOT NULL,
  `warehouse_id` int unsigned DEFAULT NULL,
  `item_loteable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_loteable_id` int unsigned NOT NULL,
  `has_sale` tinyint(1) NOT NULL DEFAULT '0',
  `state` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_lots_item_id_foreign` (`item_id`),
  KEY `item_lots_warehouse_id_foreign` (`warehouse_id`),
  KEY `item_lots_series_index` (`series`),
  KEY `item_lots_date_index` (`date`),
  KEY `item_lots_has_sale_index` (`has_sale`),
  KEY `item_lots_item_loteable_type_index` (`item_loteable_type`),
  KEY `item_lots_item_loteable_id_index` (`item_loteable_id`),
  CONSTRAINT `item_lots_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `item_lots_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_lots` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_lots` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_lots_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_lots_group` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `old_quantity` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `date_of_due` date NOT NULL,
  `item_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_lots_group_item_id_foreign` (`item_id`),
  CONSTRAINT `item_lots_group_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_lots_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_lots_group` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_mold_cavities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_mold_cavities` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `cat_item_mold_cavities_id` int unsigned NOT NULL,
  `active` tinyint DEFAULT '1' COMMENT 'Define si se encuentra activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_mold_cavities` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_mold_cavities` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_mold_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_mold_properties` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `cat_item_mold_properties_id` int unsigned NOT NULL,
  `active` tinyint DEFAULT '1' COMMENT 'Define si se encuentra activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_mold_properties` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_mold_properties` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_movement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_movement` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con item',
  `quantity` decimal(12,4) DEFAULT '0.0000' COMMENT 'Cantidad de venta del item',
  `date_of_movement` timestamp NULL DEFAULT NULL,
  `countable` tinyint unsigned DEFAULT '0' COMMENT 'Define si se toma en cuenta para el conteo de inventario',
  `establishment_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `contract_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `devolution_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `dispatch_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `document_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `expense_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `fixed_asset_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `fixed_asset_purchase_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `order_form_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `order_note_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `purchase_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `purchase_order_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `purchase_quotation_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `quotation_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `sale_note_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `sale_opportunity_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `technical_service_item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con la tabla',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_movement` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_movement` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_movement_rel_extra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_movement_rel_extra` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned DEFAULT '0',
  `item_movement_id` int unsigned DEFAULT '0',
  `item_color_id` int unsigned DEFAULT '0',
  `item_status_id` int unsigned DEFAULT '0',
  `item_unit_business_id` int unsigned DEFAULT '0',
  `item_mold_cavities_id` int unsigned DEFAULT '0',
  `item_package_measurements_id` int unsigned DEFAULT '0',
  `item_units_per_package_id` int unsigned DEFAULT '0',
  `item_mold_properties_id` int unsigned DEFAULT '0',
  `item_product_family_id` int unsigned DEFAULT '0',
  `item_size_id` int unsigned DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_movement_rel_extra_item_movement_id_foreign` (`item_movement_id`),
  KEY `index_item_status_id` (`item_status_id`),
  KEY `index_item_unit_business_id` (`item_unit_business_id`),
  KEY `index_item_mold_cavities_id` (`item_mold_cavities_id`),
  KEY `index_item_package_measurements_id` (`item_package_measurements_id`),
  KEY `index_item_units_per_package_id` (`item_units_per_package_id`),
  KEY `index_item_mold_properties_id` (`item_mold_properties_id`),
  KEY `index_item_product_family_id` (`item_product_family_id`),
  KEY `index_item_size_id` (`item_size_id`),
  CONSTRAINT `item_movement_rel_extra_item_movement_id_foreign` FOREIGN KEY (`item_movement_id`) REFERENCES `item_movement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_movement_rel_extra` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_movement_rel_extra` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_package_measurements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_package_measurements` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `cat_item_package_measurements_id` int unsigned NOT NULL,
  `active` tinyint DEFAULT '1' COMMENT 'Define si se encuentra activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_package_measurements` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_package_measurements` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_product_family`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_product_family` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `cat_item_product_family_id` int unsigned NOT NULL,
  `active` tinyint DEFAULT '1' COMMENT 'Define si se encuentra activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_product_family` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_product_family` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_rel_suscription_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_rel_suscription_plans` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned DEFAULT '0' COMMENT 'Relacion con items',
  `item` json DEFAULT NULL,
  `suscription_plan_id` int unsigned DEFAULT '0' COMMENT 'Relacion con planes de suscripcion',
  `quantity` decimal(12,2) DEFAULT '0.00',
  `unit_value` decimal(16,2) DEFAULT '0.00',
  `affectation_igv_type_id` char(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_igv` decimal(12,2) DEFAULT '0.00',
  `percentage_igv` decimal(12,2) DEFAULT '0.00',
  `total_igv` decimal(12,2) DEFAULT '0.00',
  `system_isc_type_id` char(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_isc` decimal(12,2) DEFAULT '0.00',
  `percentage_isc` decimal(12,2) DEFAULT '0.00',
  `total_isc` decimal(12,2) DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) DEFAULT '0.00',
  `percentage_other_taxes` decimal(12,2) DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) DEFAULT '0.00',
  `total_taxes` decimal(12,2) DEFAULT '0.00',
  `price_type_id` char(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_price` decimal(16,6) DEFAULT '0.000000',
  `total_value` decimal(12,2) DEFAULT '0.00',
  `total_charge` decimal(12,2) DEFAULT '0.00',
  `total_discount` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) DEFAULT '0.00',
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  `additional_information` text COLLATE utf8mb4_unicode_ci,
  `warehouse_id` int unsigned DEFAULT '0',
  `name_product_pdf` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_rel_suscription_plans` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_rel_suscription_plans` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_sets` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `individual_item_id` int unsigned NOT NULL,
  `quantity` decimal(12,4) NOT NULL DEFAULT '1.0000',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_sets_item_id_foreign` (`item_id`),
  KEY `item_sets_individual_item_id_foreign` (`individual_item_id`),
  CONSTRAINT `item_sets_individual_item_id_foreign` FOREIGN KEY (`individual_item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `item_sets_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_sets` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_sets` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_size`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_size` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `cat_item_size_id` int unsigned NOT NULL,
  `active` tinyint DEFAULT '1' COMMENT 'Define si se encuentra activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_size` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_size` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_status` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `cat_item_status_id` int unsigned NOT NULL,
  `active` tinyint DEFAULT '1' COMMENT 'Define si se encuentra activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_status` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_supplies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_supplies` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `individual_item_id` int unsigned NOT NULL,
  `quantity` decimal(13,3) NOT NULL,
  `unit_price` decimal(12,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_supplies_item_id_foreign` (`item_id`),
  KEY `item_supplies_individual_item_id_foreign` (`individual_item_id`),
  CONSTRAINT `item_supplies_individual_item_id_foreign` FOREIGN KEY (`individual_item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `item_supplies_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_supplies` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_supplies` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_tags` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `tag_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_tags_item_id_foreign` (`item_id`),
  KEY `item_tags_tag_id_foreign` (`tag_id`),
  CONSTRAINT `item_tags_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_tags_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_tags` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_types` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_types` DISABLE KEYS */;
INSERT INTO `item_types` VALUES ('01','Producto'),('02','Servicio');
/*!40000 ALTER TABLE `item_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_unit_business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_unit_business` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `cat_item_unit_business_id` int unsigned NOT NULL,
  `active` tinyint DEFAULT '1' COMMENT 'Define si se encuentra activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_unit_business` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_unit_business` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_unit_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_unit_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_id` int unsigned NOT NULL,
  `unit_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity_unit` decimal(12,4) NOT NULL,
  `price1` decimal(12,4) NOT NULL,
  `price2` decimal(12,4) NOT NULL,
  `price3` decimal(12,4) NOT NULL,
  `price_default` tinyint(1) NOT NULL DEFAULT '2',
  `barcode` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_unit_types_unit_type_id_foreign` (`unit_type_id`),
  KEY `item_unit_types_item_id_foreign` (`item_id`),
  KEY `item_unit_types_barcode_index` (`barcode`),
  CONSTRAINT `item_unit_types_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `item_unit_types_unit_type_id_foreign` FOREIGN KEY (`unit_type_id`) REFERENCES `cat_unit_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_unit_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_unit_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_units_per_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_units_per_package` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `cat_item_units_per_package_id` int unsigned NOT NULL,
  `active` tinyint DEFAULT '1' COMMENT 'Define si se encuentra activo',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_units_per_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_units_per_package` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_warehouse` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `warehouse_id` int unsigned NOT NULL,
  `stock` decimal(12,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_warehouse_item_id_foreign` (`item_id`),
  KEY `item_warehouse_warehouse_id_foreign` (`warehouse_id`),
  CONSTRAINT `item_warehouse_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_warehouse_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_warehouse` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_warehouse` ENABLE KEYS */;
DROP TABLE IF EXISTS `item_warehouse_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_warehouse_prices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `warehouse_id` int unsigned NOT NULL,
  `price` decimal(16,6) NOT NULL DEFAULT '0.000000',
  PRIMARY KEY (`id`),
  KEY `item_warehouse_prices_item_id_foreign` (`item_id`),
  KEY `item_warehouse_prices_warehouse_id_foreign` (`warehouse_id`),
  CONSTRAINT `item_warehouse_prices_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_warehouse_prices_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `item_warehouse_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_warehouse_prices` ENABLE KEYS */;
DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(600) COLLATE utf8mb4_unicode_ci NOT NULL,
  `second_name` varchar(600) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(600) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text_filter` longtext COLLATE utf8mb4_unicode_ci,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `factory_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `barcode` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `technical_specifications` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `internal_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_due` date DEFAULT NULL,
  `account_id` int unsigned DEFAULT NULL,
  `item_code_gs1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sale_unit_price` decimal(16,6) NOT NULL,
  `purchase_has_igv` tinyint(1) NOT NULL DEFAULT '1',
  `has_igv` tinyint(1) NOT NULL DEFAULT '1',
  `subject_to_detraction` tinyint(1) NOT NULL DEFAULT '0',
  `purchase_unit_price` decimal(16,6) NOT NULL,
  `has_isc` tinyint(1) NOT NULL DEFAULT '0',
  `exchange_points` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'sistema por puntos',
  `quantity_of_points` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'sistema por puntos',
  `commission_amount` decimal(8,2) DEFAULT NULL,
  `line` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `commission_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount_plastic_bag_taxes` decimal(6,2) NOT NULL DEFAULT '0.10',
  `system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `suggested_price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `purchase_has_isc` tinyint(1) NOT NULL DEFAULT '0',
  `purchase_system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purchase_percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `sale_affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `purchase_affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `calculate_quantity` tinyint(1) NOT NULL DEFAULT '0',
  `sale_unit_price_set` decimal(16,6) DEFAULT NULL,
  `is_set` tinyint(1) NOT NULL DEFAULT '0',
  `favorite` tinyint(1) NOT NULL DEFAULT '0',
  `category_id` int unsigned DEFAULT NULL,
  `brand_id` int unsigned DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'imagen-no-disponible.jpg',
  `image_medium` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'imagen-no-disponible.jpg',
  `image_small` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'imagen-no-disponible.jpg',
  `stock` decimal(16,4) NOT NULL,
  `stock_min` decimal(12,2) NOT NULL DEFAULT '0.00',
  `has_plastic_bag_taxes` tinyint(1) NOT NULL DEFAULT '0',
  `lot_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lots_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `series_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `percentage_of_profit` decimal(12,2) NOT NULL DEFAULT '0.00',
  `has_perception` tinyint(1) NOT NULL DEFAULT '0',
  `percentage_perception` decimal(12,2) DEFAULT NULL,
  `attributes` json DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `web_platform_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `warehouse_id` int unsigned DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `apply_store` tinyint(1) NOT NULL DEFAULT '0',
  `apply_restaurant` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'visible en menu restaurante',
  `cod_digemid` text COLLATE utf8mb4_unicode_ci COMMENT 'Codigo de producto DIGEMID',
  `sanitary` text COLLATE utf8mb4_unicode_ci COMMENT 'Registro sanitario',
  `is_for_production` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Define si es compuesto para produccion',
  `percentage_igv` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '12',
  PRIMARY KEY (`id`),
  KEY `items_item_type_id_foreign` (`item_type_id`),
  KEY `items_unit_type_id_foreign` (`unit_type_id`),
  KEY `items_currency_type_id_foreign` (`currency_type_id`),
  KEY `items_system_isc_type_id_foreign` (`system_isc_type_id`),
  KEY `items_sale_affectation_igv_type_id_foreign` (`sale_affectation_igv_type_id`),
  KEY `items_purchase_affectation_igv_type_id_foreign` (`purchase_affectation_igv_type_id`),
  KEY `items_warehouse_id_foreign` (`warehouse_id`),
  KEY `items_account_id_foreign` (`account_id`),
  KEY `items_brand_id_foreign` (`brand_id`),
  KEY `items_category_id_foreign` (`category_id`),
  KEY `items_name_index` (`name`),
  KEY `items_second_name_index` (`second_name`),
  KEY `items_description_index` (`description`),
  KEY `items_internal_id_index` (`internal_id`),
  KEY `items_item_code_index` (`item_code`),
  KEY `items_web_platform_id_foreign` (`web_platform_id`),
  KEY `items_purchase_system_isc_type_id_foreign` (`purchase_system_isc_type_id`),
  KEY `items_favorite_index` (`favorite`),
  KEY `items_factory_code_index` (`factory_code`),
  FULLTEXT KEY `items_text_filter_fulltext` (`text_filter`),
  CONSTRAINT `items_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `items_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`),
  CONSTRAINT `items_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `items_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `items_item_type_id_foreign` FOREIGN KEY (`item_type_id`) REFERENCES `item_types` (`id`),
  CONSTRAINT `items_purchase_affectation_igv_type_id_foreign` FOREIGN KEY (`purchase_affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `items_purchase_system_isc_type_id_foreign` FOREIGN KEY (`purchase_system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`),
  CONSTRAINT `items_sale_affectation_igv_type_id_foreign` FOREIGN KEY (`sale_affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `items_system_isc_type_id_foreign` FOREIGN KEY (`system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`),
  CONSTRAINT `items_unit_type_id_foreign` FOREIGN KEY (`unit_type_id`) REFERENCES `cat_unit_types` (`id`),
  CONSTRAINT `items_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`),
  CONSTRAINT `items_web_platform_id_foreign` FOREIGN KEY (`web_platform_id`) REFERENCES `web_platforms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `items` DISABLE KEYS */;
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
DROP TABLE IF EXISTS `items_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items_rating` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `value` tinyint NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `items_rating_user_id_foreign` (`user_id`),
  KEY `items_rating_item_id_foreign` (`item_id`),
  CONSTRAINT `items_rating_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `items_rating_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `items_rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `items_rating` ENABLE KEYS */;
DROP TABLE IF EXISTS `kardex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kardex` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `date_of_issue` date NOT NULL,
  `type` enum('sale','purchase') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` int unsigned NOT NULL,
  `document_id` int unsigned DEFAULT NULL,
  `purchase_id` int unsigned DEFAULT NULL,
  `purchase_settlement_id` int unsigned DEFAULT NULL,
  `sale_note_id` int unsigned DEFAULT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kardex_purchase_id_foreign` (`purchase_id`),
  KEY `kardex_document_id_foreign` (`document_id`),
  KEY `kardex_item_id_foreign` (`item_id`),
  KEY `kardex_sale_note_id_foreign` (`sale_note_id`),
  KEY `kardex_purchase_settlement_id_foreign` (`purchase_settlement_id`),
  CONSTRAINT `kardex_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kardex_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `kardex_purchase_id_foreign` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kardex_purchase_settlement_id_foreign` FOREIGN KEY (`purchase_settlement_id`) REFERENCES `purchase_settlements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kardex_sale_note_id_foreign` FOREIGN KEY (`sale_note_id`) REFERENCES `sale_notes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `kardex` DISABLE KEYS */;
/*!40000 ALTER TABLE `kardex` ENABLE KEYS */;
DROP TABLE IF EXISTS `log_sri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_sri` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `document_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `log_sri_document_id_foreign` (`document_id`),
  CONSTRAINT `log_sri_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `cabecera_documento_electronicas` (`idComporbante`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `log_sri` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_sri` ENABLE KEYS */;
DROP TABLE IF EXISTS `machine_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `machine_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `machine_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `machine_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `machines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `machines` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `machine_type_id` int unsigned NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci,
  `brand` text COLLATE utf8mb4_unicode_ci,
  `model` text COLLATE utf8mb4_unicode_ci,
  `closing_force` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `machines` DISABLE KEYS */;
/*!40000 ALTER TABLE `machines` ENABLE KEYS */;
DROP TABLE IF EXISTS `mi_tienda_pe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mi_tienda_pe` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_number` text COLLATE utf8mb4_unicode_ci COMMENT 'Numero de pedido',
  `transaction_code` text COLLATE utf8mb4_unicode_ci COMMENT 'Codigo de pasareña',
  `order_note_id` int unsigned DEFAULT '0',
  `document_id` int unsigned DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `mi_tienda_pe` DISABLE KEYS */;
/*!40000 ALTER TABLE `mi_tienda_pe` ENABLE KEYS */;
DROP TABLE IF EXISTS `migration_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_configuration` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `migration_configuration` DISABLE KEYS */;
/*!40000 ALTER TABLE `migration_configuration` ENABLE KEYS */;
DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2018_00_00_000000_tenant_catalogs_table',1),(2,'2018_01_00_000000_tenant_system_table',1),(3,'2018_01_01_000000_tenant_users_table',1),(4,'2018_01_01_000001_tenant_password_resets_table',1),(5,'2018_01_01_000004_tenant_modules_table',1),(6,'2018_01_01_000006_tenant_module_user_table',1),(7,'2018_01_01_000013_tenant_location_table',1),(8,'2018_05_16_000800_tenant_companies_table',1),(9,'2018_05_16_000810_tenant_establishments_table',1),(10,'2018_05_16_000900_tenant_configurations_table',1),(11,'2018_05_17_000002_tenant_series_table',1),(12,'2018_05_17_000101_tenant_persons_table',1),(13,'2018_06_17_000001_tenant_items_table',1),(14,'2018_06_17_000002_tenant_documents_table',1),(15,'2018_06_17_000005_tenant_document_items_table',1),(16,'2018_06_19_000020_tenant_invoices_table',1),(17,'2018_06_19_000021_tenant_notes_table',1),(18,'2018_06_21_000002_tenant_summaries_table',1),(19,'2018_06_21_000003_tenant_summary_documents_table',1),(20,'2018_06_21_000004_tenant_voided_table',1),(21,'2018_06_21_000005_tenant_voided_documents_table',1),(22,'2018_06_22_000022_tenant_retentions_table',1),(23,'2018_06_22_000023_tenant_retention_documents_table',1),(24,'2018_06_22_000024_tenant_perceptions_table',1),(25,'2018_06_22_000026_tenant_perception_details_table',1),(26,'2018_07_22_000024_tenant_dispatches_table',1),(27,'2018_07_22_000030_tenant_dispatch_items_table',1),(28,'2019_02_12_000002_tenant_purchases_table',1),(29,'2019_02_12_000005_tenant_purchase_items_table',1),(30,'2019_02_12_000007_tenant_kardex_table',1),(31,'2019_02_13_150334_tenant_add_cront_to_configurations',1),(32,'2019_02_13_175903_tenant_change_type_column_quantity_to_document_items',1),(33,'2019_02_13_190940_tenant_add_information_to_documents',1),(34,'2019_02_14_100645_tenant_add_establishment_id_to_users',1),(35,'2019_02_19_150123_tenant_change_columns_to_exchange_rates',1),(36,'2019_02_25_074400_tenant_add_data_json_to_documents',1),(37,'2019_02_26_084922_tenant_change_columns_offline_to_documents',1),(38,'2019_02_27_093803_tenant_add_send_online_to_documents',1),(39,'2019_02_27_150015_create_tasks_table',1),(40,'2019_02_28_100503_tenant_add_calculate_quantity_to_items',1),(41,'2019_02_28_154355_tenant_delete_unique_class_to_tasks',1),(42,'2019_02_28_215128_tenant_change_decimal_column_quantity_to_document_items',1),(43,'2019_03_01_100028_tenant_change_decimal_column_stock_to_items',1),(44,'2019_03_01_100550_tenant_change_type_column_quantity_to_purchase_items',1),(45,'2019_03_01_100938_tenant_change_type_column_quantity_to_kardex',1),(46,'2019_03_01_163938_tenant_add_locked_to_users',1),(47,'2019_03_16_095539_tenant_quotations_table',1),(48,'2019_03_16_095620_tenant_quotation_items_table',1),(49,'2019_03_19_155345_tenant_sale_notes_table',1),(50,'2019_03_19_155546_tenant_sale_note_items_table',1),(51,'2019_03_20_152101_tenant_add_sale_note_id_to_kardex',1),(52,'2019_03_22_095723_tenant_change_nullable_colum_type_to_kardex',1),(53,'2019_03_23_114011_tenant_warehouses_table',1),(54,'2019_03_23_134515_add_warehouse_id_to_items',1),(55,'2019_03_23_154011_tenant_item_warehouse_table',1),(56,'2019_03_25_120709_tenant_inventories_table',1),(57,'2019_03_26_120709_tenant_inventory_kardex_table',1),(58,'2019_03_27_104823_tenant_add_record_to_warehouses',1),(59,'2019_03_28_102106_tenant_add_quotation_id_to_documents',1),(60,'2019_03_28_112106_tenant_add_foreign_establishment_id_to_warehouses',1),(61,'2019_03_29_100403_tenant_add_foreign_to_item_warehouse',1),(62,'2019_03_29_100413_tenant_add_foreign_to_inventories',1),(63,'2019_03_29_100433_tenant_add_foreign_to_inventory_kardex',1),(64,'2019_03_29_100503_tenant_add_has_igv_to_items',1),(65,'2019_04_24_151702_tenant_add_stock_to_configurations',1),(66,'2019_04_26_105302_tenant_add_contingency_to_series',1),(67,'2019_04_29_111659_tenant_inventory_configurations_table',1),(68,'2019_04_29_164935_tenant_add_record_to_inventory_configurations',1),(69,'2019_04_30_140509_tenant_add_type_to_users',1),(70,'2019_05_06_174801_tenant_change_column_type_to_users',1),(71,'2019_05_07_160954_tenant_item_unit_types_table',1),(72,'2019_05_10_172128_tenant_add_price_default_to_item_unit_types',1),(73,'2019_05_13_145524_tenant_fix_error_to_inventories',1),(74,'2019_05_14_091046_tenant_description_to_item_unit_types',1),(75,'2019_05_27_185903_tenant_change_type_column_qr_to_documents',1),(76,'2019_05_28_172128_tenant_add_percentage_of_profit_to_items',1),(77,'2019_06_12_000005_tenant_document_payments_table',1),(78,'2019_06_12_000015_tenant_sale_note_payments_table',1),(79,'2019_06_12_172128_tenant_add_total_canceled_to_sale_notes',1),(80,'2019_06_13_100503_tenant_change_unit_price_to_items',1),(81,'2019_06_14_100503_tenant_person_address_table',1),(82,'2019_06_24_122116_tenant_add_changed_to_sale_notes',1),(83,'2019_07_09_141248_tenant_expense_types_table',1),(84,'2019_07_09_141408_tenant_expenses_table',1),(85,'2019_07_09_141508_tenant_expense_items_table',1),(86,'2019_07_09_172826_tenant_add_perception_agent_to_persons',1),(87,'2019_07_10_092347_tenant_add_percentage_perception_to_items',1),(88,'2019_07_10_103811_tenant_add_columns_perceptions_to_purchases',1),(89,'2019_07_10_120610_tenant_add_columns_purchases_to_payment_method_types',1),(90,'2019_07_10_123325_tenant_purchase_payments_table',1),(91,'2019_07_10_140636_tenant_add_date_of_due_to_purchases',1),(92,'2019_07_10_151332_tenant_add_warehouse_id_to_purchase_items',1),(93,'2019_07_12_181618_tenant_add_columns_aditional_to_establishments',1),(94,'2019_07_19_163617_tenant_add_columns_system_to_configurations',1),(95,'2019_07_22_094601_tenant_cash_table',1),(96,'2019_07_22_094658_tenant_cash_documents_table',1),(97,'2019_07_22_094725_tenant_add_image_to_items',1),(98,'2019_07_22_094803_tenant_modify_document_id_to_cash_documents',1),(99,'2019_07_22_102243_tenant_accounts_table',1),(100,'2019_07_22_103459_tenant_add_account_id_to_items',1),(101,'2019_07_23_175808_tenant_modify_decimals_to_item_unit_types',1),(102,'2019_07_24_162847_tenant_add_data_module_for_pos',1),(103,'2019_07_25_144505_tenant_add_ose_to_companies',1),(104,'2019_07_27_181623_tenant_add_name_name2_to_items',1),(105,'2019_07_31_165537_tenant_add_subtotal_account_to_configurations',1),(106,'2019_08_01_002801_tenant_add_status_to_item',1),(107,'2019_08_01_005553_tenant_add_status_to_persons',1),(108,'2019_08_01_011908_tenant_add_description_to_quotations',1),(109,'2019_08_01_095140_tenant_add_status_to_bank_accounts',1),(110,'2019_08_01_101234_tenant_add_active_to_banks',1),(111,'2019_08_01_102419_tenant_add_active_to_card_brands',1),(112,'2019_08_01_105836_tenant_delete_subtotal_account_to_configurations',1),(113,'2019_08_01_110045_tenant_company_accounts_table',1),(114,'2019_08_03_162431_tenant_add_data_modules_for_dashboard',1),(115,'2019_08_05_130830_tenant_add_index_external_id_to_documents',1),(116,'2019_08_12_125016_tenant_up_unit_price_to_items',1),(117,'2019_08_13_082230_tenant_add_column_limit_user_to_configurations',1),(118,'2019_08_16_153648_tenant_add_more_decimal_column_stock_to_items',1),(119,'2019_08_16_161756_tenant_add_total_plastic_bag_taxes_to_documents',1),(120,'2019_08_16_161824_tenant_add_total_plastic_bag_taxes_to_document_items',1),(121,'2019_08_16_161854_tenant_add_amount_plastic_bag_taxes_to_items',1),(122,'2019_08_19_112540_tenant_add_quotation_id_to_sale_notes',1),(123,'2019_08_19_115344_tenant_add_sale_note_id_to_documents',1),(124,'2019_08_19_124610_tenant_add_state_condition_to_persons',1),(125,'2019_08_20_121326_tenant_add_indexes_to_documents',1),(126,'2019_08_20_144511_tenant_add_indexes_to_summaries',1),(127,'2019_08_20_151037_tenant_add_indexes_to_persons',1),(128,'2019_08_21_145954_tenant_modify_name_name2_to_items',1),(129,'2019_08_23_115358_tenant_add_data_accounnting_inventory_to_modules',1),(130,'2019_08_23_160411_tenant_modify_description_to_items',1),(131,'2019_09_03_153427_tenant_change_nullable_column_affected_document_id_to_notes',1),(132,'2019_09_03_153656_tenant_add_data_affected_document_to_notes',1),(133,'2019_09_09_153206_tenant_add_sale_note_id_to_cash_documents',1),(134,'2019_09_09_174848_tenant_modify_columns_to_perceptions',1),(135,'2019_09_09_174916_tenant_modify_columns_to_perception_details',1),(136,'2019_09_10_102854_tenant_modify_series_id_to_perceptions',1),(137,'2019_09_11_131559_tenant_add_apply_store_to_items',1),(138,'2019_09_11_154949_tenant_expense_method_types',1),(139,'2019_09_11_155535_tenant_expense_payments',1),(140,'2019_09_11_174858_tenant_expense_reasons',1),(141,'2019_09_11_174929_tenant_add_expense_reason_id_to_expenses',1),(142,'2019_09_13_112026_tenant_add_column_image_medium_and_image_small_to_items',1),(143,'2019_09_15_233528_tenant_create_table_tag',1),(144,'2019_09_15_233537_tenant_create_table_item_tag',1),(145,'2019_09_16_121938_tenant_add_date_of_due_to_items',1),(146,'2019_09_16_133219_tenant_add_data_ecommerce_to_modules',1),(147,'2019_09_16_160453_tenant_add_timestamps_to_tag',1),(148,'2019_09_16_161726_tenant_add_status_to_tags',1),(149,'2019_09_17_131050_tenant_add_type_client_to_users',1),(150,'2019_09_17_202003_tenant_promotions_table',1),(151,'2019_09_18_152416_tenant_add_percentage_perception_to_persons',1),(152,'2019_09_18_160838_tenant_add_has_perception_to_items',1),(153,'2019_09_30_151349_tenant_add_has_prepayment_to_documents',1),(154,'2019_09_30_160541_tenant_inventory_transactions_table',1),(155,'2019_09_30_160919_tenant_change_columns_to_inventories',1),(156,'2019_10_04_092658_tenant_business_turns_table',1),(157,'2019_10_04_094841_tenant_document_hotels_table',1),(158,'2019_10_09_101229_tenant_add_locked_tenant_to_configurations',1),(159,'2019_10_10_155554_tenant_add_quantity_documents_date_time_start_to_configurations',1),(160,'2019_10_11_095050_tenant_billing_cycles_table',1),(161,'2019_10_11_153948_tenant_add_locked_users_to_configurations',1),(162,'2019_10_14_101501_tenant_add_column_set_to_items',1),(163,'2019_10_14_102317_tenant_item_sets_table',1),(164,'2019_10_14_235308_tenant_orders_table',1),(165,'2019_10_15_122633_tenant_person_types_table',1),(166,'2019_10_15_123201_tenant_add_person_types_to_persons',1),(167,'2019_10_16_001052_tenant_add_identity_and_number_to_users',1),(168,'2019_10_17_100307_tenant_add_data_to_document_types',1),(169,'2019_10_18_150004_tenant_categories_table',1),(170,'2019_10_18_150414_tenant_brands_table',1),(171,'2019_10_18_150604_tenant_brand_category_to_items',1),(172,'2019_10_18_194622_tenant_add_soft_delete_to_purchases',1),(173,'2019_10_20_190039_tenant_add_plan_to_configurations',1),(174,'2019_10_20_195730_tenant_add_cuenta_to_modules',1),(175,'2019_10_20_200958_tenant_account_payments_table',1),(176,'2019_10_22_173407_tenant_add_was_deducted_prepayment_to_documents',1),(177,'2019_10_24_103947_tenant_add_sunat_alternate_server_to_configurations',1),(178,'2019_10_24_183250_tenant_add_document_id_to_orders',1),(179,'2019_10_24_210806_tenant_items_rating_table',1),(180,'2019_10_26_213130_tenant_add_logo_store_to_companies',1),(181,'2019_10_28_202116_tenant_add_reference_number_to_cash',1),(182,'2019_11_05_113236_create_padrones_table',1),(183,'2019_11_05_113320_create_charge_padrones_table',1),(184,'2019_11_06_095251_tenant_add_success_shipping_status_to_documents',1),(185,'2019_11_06_102422_tenant_add_success_sunat_shipping_status_to_documents',1),(186,'2019_11_06_110606_tenant_add_success_query_status_to_documents',1),(187,'2019_11_06_113035_tenant_offline_configurations_table',1),(188,'2019_11_11_102124_tenant_series_configurations_table',1),(189,'2019_11_12_223340_tenant_add_reference_document_id_to_dispatches',1),(190,'2019_11_13_124821_tenant_add_document_type_id_to_series_configurations',1),(191,'2019_11_18_154307_tenant_create_congiguration_ecommerce_table',1),(192,'2019_11_19_113132_tenant_cat_detraction_types_table',1),(193,'2019_11_20_175549_tenant_add_inventory_kardex_id_to_sale_note_items',1),(194,'2019_11_20_221547_tenant_add_address_to_configuration_ecommerce',1),(195,'2019_11_25_213648_tenant_add_social_to_configuration_ecommerce',1),(196,'2019_11_29_093342_tenant_add_detraction_account_to_companies',1),(197,'2019_12_02_105910_tenant_add_purchase_expense_to_cash_documents',1),(198,'2019_12_02_111743_tenant_change_expense_reason_id_to_expenses',1),(199,'2019_12_02_111837_tenant_add_soap_type_id_to_expenses',1),(200,'2019_12_02_152128_tenant_add_date_of_due_to_quotations',1),(201,'2019_12_02_161856_tenant_add_data_to_payment_method_types',1),(202,'2019_12_02_163726_tenant_add_payment_method_type_id_to_quotations',1),(203,'2019_12_05_104120_tenant_fixed_columns_to_cash_documents',1),(204,'2019_12_06_114132_tenant_add_shipping_address_to_quotations',1),(205,'2019_12_06_120917_tenant_add_commission_amount_to_items',1),(206,'2019_12_11_111224_tenant_purchase_quotations_table',1),(207,'2019_12_11_112209_tenant_purchase_quotation_items_table',1),(208,'2019_12_11_122830_tenant_add_reference_quotation_id_to_dispatches',1),(209,'2019_12_11_174726_tenant_purchase_orders_table',1),(210,'2019_12_11_175353_tenant_purchase_order_items_table',1),(211,'2019_12_16_103759_tenant_add_decimal_quantity_to_configurations',1),(212,'2019_12_16_181022_tenant_add_prefix_to_purchase_orders',1),(213,'2019_12_17_101130_tenant_add_purchase_order_id_to_purchases',1),(214,'2019_12_19_102946_tenant_item_lots_table',1),(215,'2019_12_19_105644_tenant_add_lot_code_to_items',1),(216,'2019_12_19_141604_tenant_add_operation_amazonia_to_companies',1),(217,'2019_12_20_123931_tenant_module_levels_table',1),(218,'2019_12_20_123945_tenant_module_level_user_table',1),(219,'2019_12_23_144236_tenant_add_apply_concurrency_to_sale_notes',1),(220,'2019_12_23_171335_tenant_add_columns_periods_to_sale_notes',1),(221,'2019_12_24_114350_tenant_add_columns_lots_to_item_lots',1),(222,'2019_12_24_123601_tenant_add_lot_code_to_purchase_items',1),(223,'2019_12_27_111848_tenant_add_lot_code_to_inventories',1),(224,'2019_12_30_095201_tenant_add_lots_enabled_to_items',1),(225,'2020_01_03_111747_tenant_add_amount_plastic_bag_taxes_to_configurations',1),(226,'2020_01_08_102051_tenant_add_total_canceled_to_documents',1),(227,'2020_01_09_094728_tenant_change_decimal_column_quantity_to_dispatch_items',1),(228,'2020_01_09_102017_tenant_change_type_decimal_column_quantity_to_dispatch_items',1),(229,'2020_01_09_153023_tenant_add_compact_sidebar_to_configurations',1),(230,'2020_01_10_095143_tenant_add_cci_to_bank_accounts',1),(231,'2020_01_10_121518_tenant_add_warehouse_id_to_document_items',1),(232,'2020_01_15_095621_tenant_add_change_decimal_exchange_rate_sale_tables',1),(233,'2020_01_15_100032_tenant_add_data_to_cat_document_types',1),(234,'2020_01_15_144606_tenant_add_series_number_to_sale_notes',1),(235,'2020_01_15_172447_tenant_add_paid_to_sale_notes',1),(236,'2020_01_15_181229_tenant_add_plate_to_sale_notes',1),(237,'2020_01_16_101424_tenant_add_detail_to_inventories',1),(238,'2020_01_16_103741_tenant_change_decimals_unit_price_tables',1),(239,'2020_01_16_121313_tenant_add_state_to_item_lots',1),(240,'2020_01_17_095233_tenant_document_transports_table',1),(241,'2020_01_17_115328_tenant_add_plate_number_to_documents',1),(242,'2020_01_17_175217_tenant_add_state_type_to_expenses',1),(243,'2020_01_21_153921_tenant_inventories_transfer_table',1),(244,'2020_01_21_155245_tenant_add_inventories_transfer_id_to_inventories',1),(245,'2020_01_23_120700_tenant_drop_compact_sidebar_to_configurations',1),(246,'2020_01_23_120830_tenant_re_create_compact_sidebar_to_configurations',1),(247,'2020_01_23_123235_tenant_add_columns_to_document_hotels',1),(248,'2020_01_27_121553_tenant_add_commission_type_to_items',1),(249,'2020_01_27_150915_tenant_change_column_number_to_sale_notes',1),(250,'2020_01_28_135422_tenant_add_tag_to_configuration_ecommerce',1),(251,'2020_01_31_122444_tenant_add_config_system_to_configurations',1),(252,'2020_02_05_124542_tenant_add_guests_to_document_hotels',1),(253,'2020_02_07_164026_tenant_create_person_addresses',1),(254,'2020_02_10_111943_tenant_add_affectation_type_prepayment_to_documents',1),(255,'2020_02_11_210535_tenant_add_active_to_items',1),(256,'2020_02_12_203736_tenant_add_contact_to_users',1),(257,'2020_02_17_115050_tenant_add_delivery_date_to_quotations',1),(258,'2020_02_17_141658_tenant_create_format_templates_table',1),(259,'2020_02_17_194731_tenant_add_formats_to_configurations',1),(260,'2020_02_17_202910_tenant_item_images_table',1),(261,'2020_02_19_102018_tenant_order_notes_table',1),(262,'2020_02_19_121619_tenant_order_note_items_table',1),(263,'2020_02_19_150814_tenant_add_order_note_id_to_documents',1),(264,'2020_02_19_150828_tenant_add_order_note_id_to_sale_notes',1),(265,'2020_02_19_160926_tenant_add_reference_order_note_id_to_dispatches',1),(266,'2020_02_20_224501_tenant_add_colums_grid_items_to_configurations',1),(267,'2020_02_21_172411_tenant_add_soap_shipping_response_to_documents',1),(268,'2020_02_24_213558_tenant_date_of_due_column_to_purchase_items',1),(269,'2020_02_25_103837_tenant_add_options_pos_to_configurations',1),(270,'2020_02_25_154338_tenant_add_change_to_document_payments',1),(271,'2020_02_26_201604_tenant_item_lots_group_table',1),(272,'2020_02_26_203030_tenant_add_series_enabled_to_items',1),(273,'2020_02_27_113111_tenant_add_change_to_sale_note_payments',1),(274,'2020_03_03_172821_tenant_add_additional_information_to_document_items',1),(275,'2020_03_06_101730_tenant_global_payments_table',1),(276,'2020_03_10_165850_tenant_add_data_module_for_finance',1),(277,'2020_03_11_151338_tenant_add_edit_name_product_purchase',1),(278,'2020_03_13_110238_add_column_name_product_pdf',1),(279,'2020_03_13_134951_add_column_name_product_pdf_update',1),(280,'2020_03_13_134955_add_column_name_product_pdf_change',1),(281,'2020_03_16_152939_tenant_add_indexes_to_payments_tables_for_finances',1),(282,'2020_03_16_162652_tenant_add_enabled_to_persons',1),(283,'2020_03_20_030559_add_columna_restrict_receipt_date',1),(284,'2020_03_20_174637_tenant_add_affectation_igv_type_id_to_configurations',1),(285,'2020_03_25_173128_tenant_sale_opportunities_table',1),(286,'2020_03_25_173442_tenant_sale_opportunity_items_table',1),(287,'2020_03_26_121642_tenant_add_sale_opportunity_id_to_quotations',1),(288,'2020_03_26_170415_tenant_sale_opportunity_files_table',1),(289,'2020_03_27_111133_tenant_quotation_payments_table',1),(290,'2020_03_27_123343_tenant_add_changed_to_quotations',1),(291,'2020_03_27_141008_tenant_add_column_visual_to_configurations',1),(292,'2020_03_27_143825_tenant_add_account_number_to_quotations',1),(293,'2020_03_27_150024_tenant_add_terms_condition_to_quotations',1),(294,'2020_03_30_112859_tenant_payment_files_table',1),(295,'2020_03_31_111522_tenant_add_customer_id_to_purchases',1),(296,'2020_03_31_122445_tenant_fixed_asset_items_table',1),(297,'2020_03_31_141008_tenant_add_column_show_ws_to_configurations',1),(298,'2020_03_31_151057_tenant_fixed_asset_purchases_table',1),(299,'2020_03_31_151323_tenant_fixed_asset_purchase_items_table',1),(300,'2020_04_01_150413_tenant_add_terms_condition_to_configurations',1),(301,'2020_04_02_124023_tenant_add_sale_opportunity_id_to_purchase_orders',1),(302,'2020_04_02_151534_tenant_add_total_canceled_to_purchases',1),(303,'2020_04_02_154134_tenant_contracts_table',1),(304,'2020_04_02_154147_tenant_contract_items_table',1),(305,'2020_04_02_154244_tenant_contract_payments_table',1),(306,'2020_04_03_111019_tenant_income_types_table',1),(307,'2020_04_03_111139_tenant_income_reasons_table',1),(308,'2020_04_03_111209_tenant_income_table',1),(309,'2020_04_03_111703_tenant_income_items_table',1),(310,'2020_04_03_124629_tenant_income_payments_table',1),(311,'2020_04_03_143703_tenant_insert_internal_to_soap_types',1),(312,'2020_05_06_205001_create_status_orders_table',1),(313,'2020_05_06_210451_tenant_add_status_orders_to_orders',1),(314,'2020_05_07_123152_tenant_technical_services_table',1),(315,'2020_05_07_164323_tenant_user_commissions_table',1),(316,'2020_05_12_131218_add_product_to_configurations',1),(317,'2020_05_12_204311_tenant_add_cotizaction_finance_configurations',1),(318,'2020_05_19_162014_tenant_add_contact_to_persons',1),(319,'2020_05_25_140825_tenant_add_column_plate_number_to_sales_note',1),(320,'2020_05_30_132013_tenant_add_certificate_due_to_companies',1),(321,'2020_06_05_111820_tenant_add_line_to_items',1),(322,'2020_06_10_102549_tenant_add_columns_technical_specifications_items',1),(323,'2020_06_11_093739_tenant_add_columns_header_image_legend_footer_to_configurations',1),(324,'2020_06_11_152155_tenant_add_purchase_orders',1),(325,'2020_06_23_122822_tenant_drivers_table',1),(326,'2020_06_23_122938_tenant_dispatchers_table',1),(327,'2020_06_23_123012_tenant_order_forms_table',1),(328,'2020_06_23_123126_tenant_order_form_items_table',1),(329,'2020_06_24_173951_tenant_add_reference_order_form_id_to_dispatches',1),(330,'2020_07_03_124017_tenant_add_purchase_has_igv_to_items',1),(331,'2020_07_08_163451_tenant_change_column_name_product_pdf_to_document_items',1),(332,'2020_07_21_213555_tenant_add_columns_to_technical_services',1),(333,'2020_07_23_153920_tenant_add_user_id_to_global_payments',1),(334,'2020_07_23_215548_tenant_add_img_firm_to_companies',1),(335,'2020_07_23_221614_tenant_add_qr_to_order_forms',1),(336,'2020_07_27_184250_add_apiruc_to_configurations',1),(337,'2020_07_30_101311_tenant_add_soap_shipping_response_to_summaries',1),(338,'2020_07_30_105514_tenant_add_soap_shipping_response_to_voided',1),(339,'2020_08_03_123426_tenant_add_secondary_license_plates_to_dispatches',1),(340,'2020_08_04_104159_tenant_add_initial_balance_to_bank_accounts',1),(341,'2020_08_04_123149_tenant_add_pending_amount_prepayment_to_documents',1),(342,'2020_08_05_104849_tenant_add_payment_method_type_id_to_documents',1),(343,'2020_08_05_125307_tenant_add_filename_to_purchases',1),(344,'2020_08_06_101100_tenant_change_columns_delivery_date_date_of_due_to_quotations',1),(345,'2020_08_06_120140_tenant_add_data_to_module_levels',1),(346,'2020_08_20_151205_tenant_change_column_terms_condition_to_quotations',1),(347,'2020_08_20_151856_tenant_change_column_terms_condition_to_configurations',1),(348,'2020_08_20_172938_tenant_change_decimal_column_quantity_to_item_lots_group',1),(349,'2020_08_26_142025_tenant_add_indexes_to_items',1),(350,'2020_08_27_101335_tenant_add_indexes_to_item_lots',1),(351,'2020_08_28_100623_tenant_change_type_column_terms_condition_to_contracts',1),(352,'2020_09_01_160245_tenant_add_warehouse_id_to_sale_note_items',1),(353,'2020_09_02_103127_tenant_add_warehouse_id_to_order_note_items',1),(354,'2020_09_02_124906_tenant_add_customer_id_to_establishments',1),(355,'2020_09_04_094513_tenant_add_quantity_to_item_sets',1),(356,'2020_09_04_165849_tenant_active_data_to_cat_operation_types',1),(357,'2020_09_07_110546_tenant_add_data_module_for_establishments_users',1),(358,'2020_09_08_141513_tenant_add_regularize_shipping_to_documents',1),(359,'2020_09_08_142658_tenant_add_response_regularize_shipping_to_documents',1),(360,'2020_09_09_144419_tenant_modify_text_description_to_expense_method_types',1),(361,'2020_09_09_151848_tenant_change_column_number_to_expenses',1),(362,'2020_09_09_160249_tenant_contract_state_types_table',1),(363,'2020_09_09_161329_tenant_change_state_type_id_to_contracts',1),(364,'2020_09_11_105705_tenant_cash_transactions_table',1),(365,'2020_09_14_123539_tenant_technical_service_payments_table',1),(366,'2020_09_25_113553_tenant_add_data_rh_to_cat_document_types',1),(367,'2020_09_29_110506_tenant_change_description_to_items',1),(368,'2020_10_09_153402_tenant_add_default_document_type_03_to_configurations',1),(369,'2020_10_13_095308_tenant_add_data_public_services_to_cat_document_types',1),(370,'2020_10_13_111740_tenant_web_platforms_table',1),(371,'2020_10_13_112548_tenant_add_destination_default_to_configurations',1),(372,'2020_10_13_120454_tenant_add_web_platform_id_to_items',1),(373,'2020_10_15_120313_tenant_active_transport_1004_to_cat_operation_types',1),(374,'2020_10_15_173515_tenant_add_contact_phone_to_quotations',1),(375,'2020_10_16_101845_teanant_add_data_to_module_levels',1),(376,'2020_10_16_143042_tenant_add_columns_aditional_to_modules',1),(377,'2020_10_26_151606_tenant_change_columns_nullable_to_dispatches',1),(378,'2020_11_05_103808_tenant_add_seller_to_documents',1),(379,'2020_11_05_120923_tenant_add_payment_method_type_id_to_sale_notes',1),(380,'2020_11_06_104926_tenant_add_soap_shipping_response_to_retentions',1),(381,'2020_11_10_101728_tenant_change_column_name_to_items',1),(382,'2020_11_12_143726_tenant_add_observation_to_sale_notes',1),(383,'2020_11_12_164451_tenant_add_reference_sale_note_id_to_dispatches',1),(384,'2020_11_18_123948_tenant_add_soap_shipping_response_to_dispatches',1),(385,'2020_11_19_115728_tenant_devolution_reasons_table',1),(386,'2020_11_19_115848_tenant_devolutions_table',1),(387,'2020_11_19_115944_tenant_devolution_items_table',1),(388,'2020_11_25_115944_tenant_create_preprinted_format_templates_table',1),(389,'2020_12_01_172908_tenant_add_reference_data_to_documents_sale_notes',1),(390,'2020_12_03_141335_tenant_change_text_description_to_cat_document_types',1),(391,'2020_12_31_103348_tenant_add_has_plastic_bag_taxes_to_items',1),(392,'2021_01_05_145928_add_model_column_to_items_table',1),(393,'2021_01_08_095018_add_barcode_column_to_items_table',1),(394,'2021_01_08_103402_update_barcode_column_to_items_table',1),(395,'2021_01_18_143008_change_lenght_to_items_table',1),(396,'2021_01_19_111533_add_internal_code_column_to_persons_table',1),(397,'2021_01_21_181843_add_terms_condition_sale_to_configurations_table',1),(398,'2021_01_21_183856_add_terms_condition_column_to_documents_table',1),(399,'2021_01_26_102448_create_hotel_rates_table',1),(400,'2021_01_26_152649_create_hotel_categories_table',1),(401,'2021_01_26_161851_create_hotel_floors_table',1),(402,'2021_01_26_171515_create_hotel_rooms_table',1),(403,'2021_01_27_155235_create_hotel_room_rates_table',1),(404,'2021_01_28_205134_create_hotel_rents_table',1),(405,'2021_01_31_163211_create_hotel_rent_items_table',1),(406,'2021_02_01_102051_add_columns_to_hotel_rents_table',1),(407,'2021_02_01_112617_add_column_item_id_to_hotel_rooms_table',1),(408,'2021_02_02_180153_add_arrears_column_to_hotel_rents_table',1),(409,'2021_02_04_215327_add_show_in_document_column_to_bank_accounts_table',1),(410,'2021_02_08_111945_add_document_id_column_to_dispatches_table',1),(411,'2021_02_10_153546_add_login_column_to_configurations_table',1),(412,'2021_02_11_113008_change_destination_to_global_payments_table',1),(413,'2021_02_15_101110_add_favicon_column_to_companies_table',1),(414,'2021_02_15_175921_add_navbar_column_to_configurations_table',1),(415,'2021_02_19_165318_add_finances_column_to_configurations_table',1),(416,'2021_02_25_165224_create_documentary_offices_table',1),(417,'2021_02_25_180958_create_documentary_processes_table',1),(418,'2021_02_25_183124_create_documentary_documents_table',1),(419,'2021_02_26_102851_create_documentary_actions_table',1),(420,'2021_02_26_102900_create_documentary_files_table',1),(421,'2021_03_01_120554_add_user_id_column_to_documentary_files_table',1),(422,'2021_03_01_120931_create_documentary_file_offices_table',1),(423,'2021_03_10_163436_add_extra_modules_to_modules_table',1),(424,'2021_03_11_111743_add_logo_column_to_establishments_table',1),(425,'2021_03_19_204148_add_items_to_modules_table',1),(426,'2021_03_19_221614_add_referential_information_to_quotations_table',1),(427,'2021_03_20_112202_change_order_items_to_modules_table',1),(428,'2021_03_20_115648_add_seller_id_column_to_quotations_table',1),(429,'2021_03_20_132104_add_seller_id_column_to_contracts_table',1),(430,'2021_03_21_165318_add_quotation_allow_seller_generate_sale_column_to_configurations_table',1),(431,'2021_03_24_111209_tenant_payment_conditions_table',1),(432,'2021_03_24_111211_tenant_add_payment_condition_to_documents',1),(433,'2021_03_24_141211_tenant_document_fee_table',1),(434,'2021_03_25_162827_add_purchase_order_column_to_sale_notes_table',1),(435,'2021_03_31_212318_add_document_id_column_to_sale_notes_table',1),(436,'2021_04_01_113520_add_levels_to_module_levels_table',1),(437,'2021_04_05_115318_add_allow_edit_unit_price_to_seller_column_to_configurations_table',1),(438,'2021_04_06_172009_create_item_warehouse_prices_table',1),(439,'2021_04_08_175347_change_electronico_at_cat_document_type',1),(440,'2021_04_17_163456_add_technical_service_id_to_cash_documents_table',1),(441,'2021_04_22_170915_add_template_pdf_to_establishments_table',1),(442,'2021_04_23_143433_add_edit_flag_to_documents_table',1),(443,'2021_04_27_105557_add_payment_type_to_payment_method',1),(444,'2021_04_29_122333_add_visual_ticket_58_to_configurations_table',1),(445,'2021_05_03_131833_add_mail_configuration',1),(446,'2021_05_06_152551_add_due_date_to_sales_note',1),(447,'2021_05_07_154207_add_soft_delete_to_document',1),(448,'2021_05_07_154207_remove_soft_delete_to_document',1),(449,'2021_05_12_163406_add_seller_can_create_porduct_to_configuration',1),(450,'2021_05_13_120615_add_seller_can_view_balance_on_finance_to_configuration',1),(451,'2021_05_27_124620_add_generate_option_to_sale_opportunities',1),(452,'2021_06_03_122337_add_method_type_to_documents_fee',1),(453,'2021_06_03_165209_add_serie_and_document_to_user',1),(454,'2021_06_07_140759_change_format_number_to_expenses_table',1),(455,'2021_06_09_124243_add_update_documents_by_dispaches_to_configurations',1),(456,'2021_06_10_092525_add_pharmacy_to_items',1),(457,'2021_06_15_094333_add_name_product_pdf_to_order_note_items',1),(458,'2021_06_16_154233_add_send_auto_sunat_to_dispatches',1),(459,'2021_06_18_141048_add_modules_digemid',1),(460,'2021_06_22_112855_add_fields_to_client',1),(461,'2021_06_23_130016_create_digemid_catalog',1),(462,'2021_06_28_125907_add_fields_to_documentary_office',1),(463,'2021_06_28_142358_tenant_add_active_warehouse_prices_to_configurations',1),(464,'2021_06_29_173743_tenant_add_allowance_charge_to_configurations',1),(465,'2021_06_29_184419_remove_key_from_documentary',1),(466,'2021_06_30_175311_tenant_add_purchase_to_cash_documents',1),(467,'2021_07_01_171620_adjust_to_docymentary_procedure',1),(468,'2021_07_02_133558_add_office_to_process',1),(469,'2021_07_05_091229_change_data_to',1),(470,'2021_07_05_094927_create_documentary_guides_number',1),(471,'2021_07_05_125811_add_field_to_documentary_file',1),(472,'2021_07_05_141048_add_modules_docymentary_requirements',1),(473,'2021_07_05_213052_change_observation_from_file_offices',1),(474,'2021_07_05_220241_add_requirements_to_documentary_file',1),(475,'2021_07_06_114113_tenant_add_discount_stock_to_cat_transfer_reason_types',1),(476,'2021_07_06_173358_tenant_add_dispatch_id_to_documents',1),(477,'2021_07_06_174510_add_name_pdf_to_sale_note_item',1),(478,'2021_07_14_103324_add_data_affected_document',1),(479,'2021_07_16_204722_add_phone_to_configuration_ecommerce',1),(480,'2021_07_19_132554_add_days_to_client',1),(481,'2021_08_03_115743_add_field_to_send_sale_note_to_other_site',1),(482,'2021_08_05_143043_add_quotation_to_order_note',1),(483,'2021_08_05_144042_tenant_add_search_item_by_series_to_configurations',1),(484,'2021_08_06_094151_tenant_add_change_free_affectation_igv_to_configurations',1),(485,'2021_08_09_115837_add_currency_to_configuration',1),(486,'2021_08_09_131738_tenant_add_select_available_price_list_to_configurations',1),(487,'2021_08_16_111909_create_colors_for_items',1),(488,'2021_08_17_091109_add_more_propertys_to_item',1),(489,'2021_08_20_153033_add_extra_data_of_product_to_configuration',1),(490,'2021_08_20_161555_add_extra_data_item_menu',1),(491,'2021_08_23_105050_tenant_add_group_items_generate_document_to_configurations',1),(492,'2021_08_23_172828_adjust_inventory_item_extra_data',1),(493,'2021_08_24_153219_tenant_add_columns_unknown_error_to_summaries',1),(494,'2021_08_25_155900_tenant_add_columns_integrated_query_to_companies',1),(495,'2021_09_08_165136_add_optional_emails_to_person',1),(496,'2021_09_10_120216_create_email_send_log',1),(497,'2021_09_10_143648_tenant_add_subtotal_to_documents',1),(498,'2021_09_13_171757_tenat_add_total_igv_free_to_documents',1),(499,'2021_09_15_115746_add_global_igv_to_purchase',1),(500,'2021_09_15_170619_tenant_change_length_description_to_quotations',1),(501,'2021_09_16_144202_add_app_to_modules',1),(502,'2021_09_17_120309_add_url_apk_to_configurations',1),(503,'2021_09_17_150025_transfer_accounts_payment',1),(504,'2021_09_21_172056_add_file_to_format_templates',1),(505,'2021_09_22_120834_add_fields_technical_services',1),(506,'2021_09_22_120835_create_technical_service_items',1),(507,'2021_09_24_114832_add_configuration_to_show_name_of_pdf',1),(508,'2021_09_28_183535_add_name_pdf_to_quotation_items',1),(509,'2021_09_29_123827_add_text_to_address_in_configuration',1),(510,'2021_09_29_180607_tenant_add_set_address_by_establishment_to_configurations',1),(511,'2021_09_30_135325_tenant_add_order_id_to_sale_notes',1),(512,'2021_09_30_170149_tenant_add_permission_to_edit_cpe_to_configurations',1),(513,'2021_09_30_171912_tenant_add_permission_edit_cpe_to_users',1),(514,'2021_10_04_154837_tenant_change_nullable_packages_number_to_dispatches',1),(515,'2021_10_05_171912_add_configuration_module_to_user',1),(516,'2021_10_05_174410_tenant_add_total_igv_free_to_quotations',1),(517,'2021_10_06_132920_tenant_add_total_igv_free_to_order_notes',1),(518,'2021_10_07_144354_create_guide_file',1),(519,'2021_10_11_110825_create_item_movement_table',1),(520,'2021_10_12_111345_create_item_movement_rel_extra_table',1),(521,'2021_10_13_113504_add_only_user_warehouse_item_to_config',1),(522,'2021_10_18_110547_tenant_add_technical_service_id_to_documents',1),(523,'2021_10_18_110700_change_default_show_items_only_user_stablishment',1),(524,'2021_10_18_110700_change_value_show_items_only_user_stablishment',1),(525,'2021_10_18_110907_tenant_add_technical_service_id_to_sale_notes',1),(526,'2021_10_18_150100_tenant_add_document_type_04_to_cat_document_types',1),(527,'2021_10_18_150136_tenant_add_data_operation_type_0501_to_cat_operation_types',1),(528,'2021_10_18_150154_tenant_cat_address_types_table',1),(529,'2021_10_18_150215_tenant_add_address_type_id_to_persons',1),(530,'2021_10_18_150306_tenant_purchase_settlements_table',1),(531,'2021_10_18_150324_tenant_purchase_settlement_items_table',1),(532,'2021_10_18_153949_tenant_add_data_purchase_settlements_to_module_levels',1),(533,'2021_10_18_174146_tenant_add_subtotal_to_purchase_settlements',1),(534,'2021_10_19_150956_tenant_add_pending_amount_detraction_to_documents',1),(535,'2021_10_20_160503_tenant_add_retention_to_documents',1),(536,'2021_10_20_161035_tenant_add_data_retention_to_cat_charge_discount_types',1),(537,'2021_10_20_174401_tenant_rename_pending_amount_detraction_to_documents',1),(538,'2021_10_21_093921_tenant_add_igv_retention_percentage_to_configurations',1),(539,'2021_10_22_130040_create_app_suscription',1),(540,'2021_10_25_112316_tenant_add_subtotal_to_quotations',1),(541,'2021_10_25_142908_create_suscription_plans_table',1),(542,'2021_10_25_154009_tenant_add_option_13_to_cat_note_credit_types',1),(543,'2021_10_27_105710_tenant_add_subtotal_to_sale_notes',1),(544,'2021_10_27_133333_add_parent_id_field_to_persons',1),(545,'2021_10_28_110438_alter_sale_notes_and_documents',1),(546,'2021_10_28_173041_tenant_add_name_product_xml_to_document_items',1),(547,'2021_10_29_110421_tenant_add_name_product_pdf_to_xml_to_configurations',1),(548,'2021_10_29_114826_change_value_alternate_server_to_configurations',1),(549,'2021_11_09_113608_tenant_add_default_document_type_80_to_configurations',1),(550,'2021_11_09_143629_tenant_add_search_item_by_barcode_to_configurations',1),(551,'2021_11_09_173326_add_grade_and_section_touser_rel_suscription_plan',1),(552,'2021_11_11_113443_tenant_general_payment_conditions_table',1),(553,'2021_11_11_114229_tenant_add_payment_condition_id_to_purchases',1),(554,'2021_11_11_152521_tenant_purchase_fee_table',1),(555,'2021_11_11_180653_tenant_add_recreate_documents_to_users',1),(556,'2021_11_12_102347_add_grade_and_section_tables',1),(557,'2021_11_15_152956_additem_description_default_pdf_name_configuration',1),(558,'2021_11_16_150657_add_user_id_to_inventories_transfer',1),(559,'2021_11_25_105300_create_accounting_ledger_table',1),(560,'2021_11_25_154025_add_auto_print_to_configurations',1),(561,'2021_12_01_113756_add_show_services_on_pos',1),(562,'2021_12_02_141408_tenant_bank_loans_table',1),(563,'2021_12_08_211200_add_pos_history_and_cost_to_configuration',1),(564,'2021_12_09_182924_add_flag_to_production_for_item',1),(565,'2021_12_10_122529_add_zone_id_to_person',1),(566,'2021_12_10_130040_create_app_production',1),(567,'2021_12_10_172959_add_name_to_mill',1),(568,'2021_12_11_101624_add_data_to_inventory_transactions',1),(569,'2021_12_11_114856_add_item_to_mill_item',1),(570,'2021_12_11_170251_create_item_supplies',1),(571,'2021_12_15_112106_create_columns_to_show_by_user',1),(572,'2021_12_16_144057_add_show_totals_on_c_p_e_list',1),(573,'2021_12_21_134408_add_simplify_to_documentary',1),(574,'2021_12_22_150753_add_guide_to_documentary_archive',1),(575,'2021_12_25_163345_add_colors_to_documentary',1),(576,'2021_12_31_105910_change_documentary_process_characters',1),(577,'2022_01_05_170742_create_machine_for_production',1),(578,'2022_01_07_124919_add_complete_to_documentary_files',1),(579,'2022_01_11_140319_tenant_add_columns_send_pse_to_documents',1),(580,'2022_01_11_174033_tenant_add_columns_send_pse_to_companies',1),(581,'2022_01_12_180810_tenant_add_detraction_amount_rounded_int_to_configurations',1),(582,'2022_01_13_141051_tenant_add_sale_notes_relateds_to_documents',1),(583,'2022_01_15_130321_add_old_quantity_to_item_lot_group',1),(584,'2022_01_18_094821_tenant_add_data_to_inventory_transactions',1),(585,'2022_01_18_120000_add_show_term_condition_pos_to_configurations',1),(586,'2022_01_18_213317_tenant_create_cash_documents_credit',1),(587,'2022_01_20_202655_tenant_add_unique_filename_to_documents',1),(588,'2022_01_22_001715_add_date_end_to_documentary_files',1),(589,'2022_01_25_150315_add_apply_restaurant_to_items',1),(590,'2022_01_25_152940_create_app_restaurant',1),(591,'2022_01_26_175429_create_mi_tienda_pe',1),(592,'2022_01_28_110155_tenant_add_related_to_dispatches',1),(593,'2022_01_29_141957_add_purchase_order_and_observation_to_purchase',1),(594,'2022_01_29_191503_create_packaging_table',1),(595,'2022_01_30_120653_create_configuration_to_mi_tienda_pe',1),(596,'2022_02_02_203403_add_autogenerate_c_p_e_to_mi_tienda_pe',1),(597,'2022_02_07_110836_add_ticket_template_pdf_to_establishments_table',1),(598,'2022_02_07_121152_add_is_custom_ticket_to_format_templates',1),(599,'2022_02_07_142617_add_format_tickets_to_configurations',1),(600,'2022_02_07_161128_tenant_add_data_to_promotions_table',1),(601,'2022_02_08_213251_tenant_add_restaurant_to_orders',1),(602,'2022_02_11_162919_tenant_add_last_sale_price_to_configurations',1),(603,'2022_02_14_222010_tenant_add_flasg_to_inventory_configurations',1),(604,'2022_02_14_224820_tenant_add_barcode_to_item_unit_types',1),(605,'2022_02_16_150615_tenant_add_show_logo_establishment_to_configuration',1),(606,'2022_02_17_195824_add_colaborator_to_production_as_text',1),(607,'2022_02_22_111659_tenant_add_columns_send_pse_to_voided',1),(608,'2022_02_24_134926_tenant_add_columns_purchase_isc_to_items',1),(609,'2022_02_24_201345_tenant_download_tray_table',1),(610,'2022_02_25_172811_add_print_next_line_to_pdf_on_observation',1),(611,'2022_02_27_120405_tenant_add_comments_to_inventories',1),(612,'2022_03_03_110115_tenant_add_global_discount_type_id_to_configurations',1),(613,'2022_03_04_003932_tenant_add_quotation_to_cash_documents',1),(614,'2022_03_08_112351_tenant_add_columns_send_pse_to_dispatches',1),(615,'2022_03_09_111107_tenant_add_restaurant_to_cash',1),(616,'2022_03_10_094902_tenant_add_shipping_time_days_to_configurations',1),(617,'2022_03_11_120508_add_trace_to_api_peru_service',1),(618,'2022_03_14_221802_tenant_add_type_to_download_tray',1),(619,'2022_03_18_140238_tenant_add_total_igv_free_to_sale_notes',1),(620,'2022_03_21_110605_create_restaurant_configuration',1),(621,'2022_03_21_161851_add_configuration_new_valdiator_pagination',1),(622,'2022_03_25_134555_tenant_add_customer_filter_by_seller_to_configurations',1),(623,'2022_03_25_143916_tenant_add_index_seller_id_to_persons',1),(624,'2022_03_25_170158_tenant_add_validate_purchase_sale_unit_price_to_configurations',1),(625,'2022_03_28_174245_add_barcode_column_to_persons_table',1),(626,'2022_03_29_101534_add_quantity_to_restaurant_configuration',1),(627,'2022_03_30_145732_tenant_add_nationality_to_persons',1),(628,'2022_03_31_132849_create_app_pos_garage',1),(629,'2022_04_04_151234_add_commands_to_restaurant_configurations',1),(630,'2022_04_06_111531_create_restaurant_roles_table',1),(631,'2022_04_06_112454_add_restaurant_role_to_users',1),(632,'2022_04_06_170626_tenant_add_unique_filename_to_sale_notes',1),(633,'2022_04_11_143145_tenant_add_name_product_pdf_to_contract_items',1),(634,'2022_04_11_152502_tenant_add_name_product_pdf_to_dispatch_items',1),(635,'2022_04_12_111023_tenant_add_columns_igv_unit_price_purchases_to_configurations',1),(636,'2022_04_12_121903_addindex_to_item_movement_rel_extra',1),(637,'2022_04_12_162742_tenant_report_configurations_table',1),(638,'2022_04_18_153331_tenant_add_payment_permissions_to_users',1),(639,'2022_04_19_114422_tenant_add_set_global_purchase_currency_items_to_configurations',1),(640,'2022_04_20_115118_tenant_add_subject_to_detraction_to_items',1),(641,'2022_04_22_101547_tenant_change_type_observation_to_sale_notes',1),(642,'2022_04_22_133909_tenant_add_set_unit_price_dispatch_related_record_to_configurations',1),(643,'2022_04_25_151827_tenant_add_index_barcode_to_item_unit_types',1),(644,'2022_04_26_175613_tenant_add_columns_restrict_voided_to_configurations',1),(645,'2022_04_28_175537_tenant_add_order_form_external_to_dispatches',1),(646,'2022_04_29_140515_tenant_add_enabled_tips_pos_to_configurations',1),(647,'2022_04_29_144947_tenant_tips_table',1),(648,'2022_05_02_135252_tenant_add_fields_to_module_levels',1),(649,'2022_05_02_152925_tenant_add_top_menu_to_configurations',1),(650,'2022_05_03_143911_tenant_create_skins_table',1),(651,'2022_05_03_171845_tenant_add_purchase_settlement_id_to_kardex',1),(652,'2022_05_04_143113_tenant_add_payment_method_type_id_to_purchase_settlements',1),(653,'2022_05_04_150922_tenant_change_type_column_quantity_to_item_supplies',1),(654,'2022_05_04_155103_tenant_workers_table',1),(655,'2022_05_04_174017_tenant_add_unique_filename_to_summaries',1),(656,'2022_05_05_110908_tenant_add_soap_type_id_to_production',1),(657,'2022_05_05_115054_tenant_add_soap_type_id_to_mill',1),(658,'2022_05_05_134703_tenant_add_soap_type_id_to_packaging',1),(659,'2022_05_06_162034_add_fields_to_person',1),(660,'2022_05_08_122934_tenant_add_route_path_to_module_levels',1),(661,'2022_05_08_130040_create_app_full_suscription',1),(662,'2022_05_08_130054_tenant_update_data_to_skins',1),(663,'2022_05_09_105130_tenant_payment_configurations_table',1),(664,'2022_05_09_122150_tenant_add_defaults_to_configurations',1),(665,'2022_05_09_141114_tenant_payment_link_types_table',1),(666,'2022_05_09_143633_tenant_payment_links_table',1),(667,'2022_05_09_212753_tenant_register_app_generate_link_to_modules',1),(668,'2022_05_10_113515_tenant_transaction_states_table',1),(669,'2022_05_10_113608_tenant_transactions_table',1),(670,'2022_05_10_113734_tenant_transaction_queries_table',1),(671,'2022_05_10_113800_tenant_client_error_types_table',1),(672,'2022_05_10_113813_tenant_client_errors_table',1),(673,'2022_05_10_163722_tenant_config_default_to_configurations',1),(674,'2022_05_11_104030_tenant_add_soap_type_id_to_transactions',1),(675,'2022_05_11_115321_tenant_add_query_transaction_to_payment_links',1),(676,'2022_05_11_161435_tenant_change_nullable_payment_to_payment_links',1),(677,'2022_05_12_180154_tenant_add_legend_forest_to_xml_to_configurations',1),(678,'2022_05_13_162912_tenant_add_index_regularize_shipping_to_documents',1),(679,'2022_05_13_163802_tenant_purchase_settlement_payments_table',1),(680,'2022_05_13_172504_tenant_add_change_currency_item_to_configurations',1),(681,'2022_05_17_164646_tenant_add_enabled_advanced_records_search_to_configurations',1),(682,'2022_05_23_133515_tenant_add_decimal_quantity_unit_price_pdf_to_configurations',1),(683,'2022_06_01_114042_tenant_add_separate_cash_transactions_to_configurations',1),(684,'2022_06_01_161857_add_column_hotel_rate_id_to_hotel_rents_table',1),(685,'2022_06_01_164204_tenant_add_order_cash_income_to_configurations',1),(686,'2022_06_02_160925_tenant_add_data_district_080915_to_districts',1),(687,'2022_06_03_135513_tenant_add_generate_order_note_from_quotation_to_configurations',1),(688,'2022_06_06_144610_tenant_add_list_items_by_warehouse_to_configurations',1),(689,'2022_06_16_143605_tenant_app_configurations_table',1),(690,'2022_06_17_143817_tenant_add_payment_received_to_document_payments',1),(691,'2022_06_21_101957_tenant_add_columns_login_pse_to_companies',1),(692,'2022_06_21_165810_tenant_add_user_pse_to_companies',1),(693,'2022_06_23_141216_tenant_add_print_format_pdf_to_app_configurations',1),(694,'2022_06_28_164504_tenant_add_date_of_issue_to_inventories',1),(695,'2022_06_30_110007_tenant_add_columns_send_pse_to_summaries',1),(696,'2022_06_30_172004_tenant_add_index_external_id_to_income',1),(697,'2022_06_30_172247_tenant_add_filename_to_income',1),(698,'2022_07_01_103451_tenant_add_filename_to_expenses',1),(699,'2022_07_01_172113_tenant_add_hide_pdf_view_documents_to_configurations',1),(700,'2022_07_04_152229_tenant_add_ticket_single_shipment_to_configurations',1),(701,'2022_07_04_153343_tenant_add_ticket_single_shipment_to_documents',1),(702,'2022_07_05_103856_tenant_add_purchase_permissions_to_users',1),(703,'2022_07_06_113107_tenant_add_columns_theme_configuration_to_app_configurations',1),(704,'2022_07_06_233507_tenant_add_columns_header_configuration_to_app_configurations',1),(705,'2022_07_07_100534_tenant_add_module_app_2_generator_to_modules',1),(706,'2022_07_07_131216_tenant_app_modules_table',1),(707,'2022_07_07_143039_tenant_app_module_user_table',1),(708,'2022_07_08_101718_tenant_add_data_configuration_to_app_modules',1),(709,'2022_07_08_165430_tenant_add_indexes_columns_to_cash',1),(710,'2022_07_11_180145_tenant_add_data_quotation_to_app_modules',1),(711,'2022_07_14_095450_tenant_add_app_logo_to_companies',1),(712,'2022_07_14_120321_tenant_add_affect_all_documents_to_configuration',1),(713,'2022_07_14_143450_tenant_add_terms_condition_column_to_sale_notes_table',1),(714,'2022_07_14_162144_tenant_add_terms_condition_column_to_dispatches_table',1),(715,'2022_07_15_110508_tenant_add_text_filter_to_items',1),(716,'2022_07_18_172843_tenant_add_app_mode_to_app_configurations',1),(717,'2022_07_19_033009_tenant_add_dashboard_options_to_configurations',1),(718,'2022_07_25_115003_tenant_add_quantity_sales_notes_to_configurations',1),(719,'2022_07_30_133127_tenant_add_direct_print_to_app_configurations',1),(720,'2022_08_05_110445_tenant_add_columns_whatsapp_to_companies',1),(721,'2022_08_05_174505_tenant_add_favorite_to_items',1),(722,'2022_08_07_122150_tenant_add_folio_to_documents',1),(723,'2022_08_11_151009_tenant_add_data_district_080916_to_districts',1),(724,'2022_08_11_151307_tenant_add_data_district_080917_to_districts',1),(725,'2022_08_11_151330_tenant_add_data_district_080918_to_districts',1),(726,'2022_08_11_151345_tenant_add_data_district_080919_to_districts',1),(727,'2022_08_14_190940_tenant_add_additional_data_to_documents',1),(728,'2022_08_15_101024_tenant_add_data_default_various_clients_to_persons',1),(729,'2022_08_23_140943_tenant_add_personal_information_to_users',1),(730,'2022_08_23_174028_tenant_user_default_document_types_table',1),(731,'2022_08_24_155445_tenant_add_data_district_080914_to_districts',1),(732,'2022_08_24_160940_tenant_add_additional_data_to_document_items',1),(733,'2022_08_24_165942_tenant_add_restrict_series_selection_seller_to_configurations',1),(734,'2022_08_25_113149_tenant_system_activity_logs_table',1),(735,'2022_08_29_015753_tenant_add_igv_31556_to_establishments',1),(736,'2022_08_30_104544_tenant_add_location_to_system_activity_logs',1),(737,'2022_08_30_140345_tenant_rename_column_auth_transaction_type_to_system_activity_logs',1),(738,'2022_08_30_175558_tenant_add_regex_password_user_to_configurations',1),(739,'2022_08_31_105919_tenant_add_route_to_system_activity_logs',1),(740,'2022_08_31_112916_tenant_system_activity_log_types_table',1),(741,'2022_08_31_131222_tenant_add_foreign_transaction_type_to_system_activity_logs',1),(742,'2022_08_31_142530_tenant_add_columns_remember_change_password_to_configurations',1),(743,'2022_08_31_150743_tenant_add_last_password_update_to_users',1),(744,'2022_09_01_173835_tenant_add_columns_point_system_to_configurations',1),(745,'2022_09_02_100607_tenant_add_accumulated_points_to_persons',1),(746,'2022_09_02_130726_tenant_add_point_system_to_documents',1),(747,'2022_09_02_152858_tenant_add_columns_point_system_to_items',1),(748,'2022_09_02_172003_tenant_add_show_complete_name_pos_to_configurations',1),(749,'2022_09_03_190940_tenant_add_additional_data_to_documents_error',1),(750,'2022_09_06_165424_tenant_add_round_points_of_sale_to_configurations',1),(751,'2022_09_07_101240_tenant_add_columns_point_system_to_sale_notes',1),(752,'2022_09_08_102133_tenant_add_enable_categories_products_view_to_configurations',1),(753,'2022_09_08_113936_tenant_add_columns_restrict_seller_discount_to_configurations',1),(754,'2022_09_08_151132_tenant_authorized_discount_users_table',1),(755,'2022_09_09_110646_tenant_enabled_sales_agents_to_configurations',1),(756,'2022_09_09_113545_tenant_agents_table',1),(757,'2022_09_09_144216_tenant_add_agent_id_to_documents_sale_notes',1),(758,'2022_09_10_114510_tenant_add_inventory_review_to_inventory_configurations',1),(759,'2022_09_14_170825_tenant_add_change_affectation_exonerated_igv_to_configurations',1),(760,'2022_09_20_101814_tenant_add_data_login_lockout_to_system_activity_log_types',1),(761,'2022_09_20_155523_tenant_add_request_email_to_system_activity_logs',1),(762,'2022_09_27_104853_tenant_add_factory_code_to_items',1),(763,'2022_09_27_115234_tenant_add_search_factory_code_items_to_configurations',1),(764,'2022_09_28_101354_tenant_add_show_load_voucher_to_configurations',1),(765,'2022_09_29_114005_tenant_add_force_send_by_summary_to_documents',1),(766,'2022_09_29_115507_tenant_add_permission_force_send_by_summary_to_users',1),(767,'2022_10_04_141907_tenant_change_description_value_to_module_levels',1),(768,'2022_10_05_152438_tenant_add_environment_to_restaurant_configurations',1),(769,'2022_10_05_162751_tenant_add_index_changed_to_sale_notes',1),(770,'2022_10_12_141349_tenant_add_real_system_stock_to_inventories',1),(771,'2022_10_14_172645_tenant_add_register_series_invoice_xml_to_configurations',1),(772,'2022_10_16_101354_tenant_add_enable_discount_by_customer_to_configurations',1),(773,'2022_10_16_110607_tenant_add_discount_to_persons',1),(774,'2022_10_20_123539_tenant_add_image_default_to_items',1),(775,'2022_10_21_190940_tenant_add_additional_data_to_dispatches',1),(776,'2022_10_21_210941_tenant_add_additional_data_to_dispatch_items',1),(777,'2022_10_21_213010_tenant_add_config_to_restaurant_configurations',1),(778,'2022_10_22_113308_tenant_create_waiters_table',1),(779,'2022_10_22_174921_tenant_add_quantity_mesas_and_and_env4_to_environment_restaurant',1),(780,'2022_11_04_142103_tenant_add_enabled_dispatch_ticket_pdf_to_configurations',1),(781,'2022_11_04_173318_tenant_add_dispatch_ticket_pdf_to_document_sale_notes',1),(782,'2022_11_10_132533_tenant_add_item_lot_group_id_to_purchase_items',1),(783,'2022_11_14_162628_tenant_add_validate_stock_add_item_to_inventory_configurations',1),(784,'2022_11_17_154241_tenant_add_direct_send_documents_whatsapp_to_app_configurations',1),(785,'2022_11_25_144444_tenat_add_fields_companies',1),(786,'2022_11_28_121323_tenant_add_certificatepss_company',1),(787,'2022_11_28_131233_tenant_add_clavesri_documents',1),(788,'2022_11_28_144231_tenant_add_percentageicg_items',1),(789,'2022_12_27_123337_tenant_add_clave__s_r_i_to_voided_table',1),(790,'2022_12_28_091554_tenant_add_clave__s_r_i_to_dispatches_table',1),(791,'2022_12_28_142326_tenant_fromas_pago_sri',1),(792,'2022_12_28_150923_tenant_add_pagosri_payment_methods',1),(793,'2022_12_29_105825_tenant_modify_cat_identity_document_types_ce',1),(794,'2022_12_29_144022_tenant_modify_cat_identity_document_types_id_4_to_true',1),(795,'2023_01_03_144941_tenant_modify_expense_method_types_default',1),(796,'2023_01_03_175007_tenant_modify_sri_formas_pago_default',1),(797,'2023_01_04_112547_tenant_change_sri_formas_pago_05',1),(798,'2023_01_04_112620_tenant_change_sri_formas_pago_sri',1),(799,'2023_01_04_174039_tenant_modify_sri_formas_pago_all',1),(800,'2023_01_05_091748_tenant_modify_sri_formas_pago_extras',1),(801,'2023_01_10_143323_tenant_sri_documents_api_get',1),(802,'2023_01_10_143648_tenant_sri_documents_detail_api_get',1),(803,'2023_01_10_143710_tenant_sri_documents_aditional_info_api_get',1),(804,'2023_01_17_092504_tenant_create_cabecera_documento_electronicas_table',1),(805,'2023_01_17_111752_create_detalle_factura_electronicas_table',1),(806,'2023_01_20_093827_create_detalle_retencion_electronicas_table',1),(807,'2023_01_23_103138_tenant_change_text_and_code_to_cat_document_types',1),(808,'2023_01_23_160943_tenant_add_qr_to_cabecera_documento_electronicas',1),(809,'2023_01_23_171635_tenan_add_fields_companies_ftp_emitidos',1),(810,'2023_01_25_125151_tenan_campo_adicional_cabecera_documentos',1),(811,'2023_01_30_102326_tenant_add_url_logo_to_companies',1),(812,'2023_02_01_144622_tenant_update_configurations_top_menu',1),(813,'2023_02_02_130442_tenant_add_token_api_companies',1),(814,'2023_02_02_164517_tenant_add_id_linea_detalles_electronicas',1),(815,'2023_02_03_144606_tennt_add_fields_cabecera_document_eletronicas',1),(816,'2023_02_03_153810_tenant_add_id_linea_detalles_electronicas_retencion',1),(817,'2023_02_07_150746_tenan_addc_coditem_to_cabecera',1),(818,'2023_05_15_172210_tenant_alter_detalle_factura_electronica',1),(819,'2023_05_24_095154_tenant_alter_cabecera_docs',1),(820,'2023_07_04_090822_tenant_a_lter_cabeceradocumentos',1),(821,'2023_07_04_142327_tenan_alter_to_cat_document_types',1),(822,'2023_07_05_153917_tenant_a_lter_liquidations_to_cat_document_types',1),(823,'2023_07_07_095933_tenant_alter_to_cabecera_documento_electronicascabecer',1),(824,'2023_07_07_134244_tenant_adddirection_suc_to_cabecera_documento_electronicas',1),(825,'2023_07_10_164533_tenant_add_fields_to_cabecera_documento_electronicas',1),(826,'2023_07_10_170616_tenantcreate_detalle_destinatario',1),(827,'2023_07_14_163456_tenantadd_guidesto_catdocuments',1),(828,'2023_07_19_171403_tenant_cretaet_liquidation',1),(829,'2023_07_28_103105_tenant_add_dividendos_to_detalle_retencion_electronicas',1),(830,'2023_08_10_110838_tenantalter_to_cabecera_documento_electronicas1',1),(831,'2023_09_11_112321_tenant_send_meail_to_cabecera_documento_electronicas',1),(832,'2024_03_26_112832_tenant_alter_to_cabecera_documento_electronicas2',1),(833,'2025_04_28_150022_add_db_fields_to_companies',1),(834,'2025_05_06_102804_documentos_recibidos_pendientes',1),(835,'2025_05_08_164420_create_retenciones_table',1),(836,'2025_07_28_123835_create_reporocesar_sp',1),(837,'2025_07_30_091156_create_log_s_r_i_s_table',1),(838,'2026_03_20_164847_add__propina__cabecera',1),(839,'2026_03_23_084558_add_fiel_detalles',1),(840,'2026_04_13_145534_add_indexes_to_cabecera_documento_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
DROP TABLE IF EXISTS `mill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `date_start` date DEFAULT NULL,
  `time_start` time DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `time_end` time DEFAULT NULL,
  `user_id` int unsigned DEFAULT '0',
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` longtext COLLATE utf8mb4_unicode_ci,
  `mill_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lot_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mill_soap_type_id_foreign` (`soap_type_id`),
  CONSTRAINT `mill_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `mill` DISABLE KEYS */;
/*!40000 ALTER TABLE `mill` ENABLE KEYS */;
DROP TABLE IF EXISTS `mill_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mill_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned DEFAULT '0',
  `mill_id` int unsigned DEFAULT '0',
  `height_to_mill` decimal(12,3) DEFAULT '0.000' COMMENT 'Peso de entrada',
  `total_height` decimal(12,3) DEFAULT '0.000' COMMENT 'Peso dle insumo ',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,3) DEFAULT '0.000' COMMENT 'Peso dle insumo ',
  `item_extra_data` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `mill_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `mill_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `module_level_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_level_user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module_level_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `module_level_user` DISABLE KEYS */;
INSERT INTO `module_level_user` VALUES (1,76,0),(2,77,0),(3,78,0);
/*!40000 ALTER TABLE `module_level_user` ENABLE KEYS */;
DROP TABLE IF EXISTS `module_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_levels` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module_id` int unsigned NOT NULL,
  `route_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label_menu` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `module_levels_module_id_foreign` (`module_id`),
  CONSTRAINT `module_levels_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `module_levels` DISABLE KEYS */;
INSERT INTO `module_levels` VALUES (1,'new_document','Nuevo comprobante',1,'tenant.documents.create','/documents/create','NC',NULL,NULL),(2,'list_document','L. Comprobantes',1,NULL,NULL,NULL,NULL,NULL),(3,'document_not_sent','Doc. No enviados',1,NULL,NULL,NULL,NULL,NULL),(4,'document_contingengy','Doc. Contingencia',1,NULL,NULL,NULL,NULL,NULL),(5,'catalogs','Catálogos',1,NULL,NULL,NULL,NULL,NULL),(6,'summary_voided','Resúmenes y Anulaciones',1,NULL,NULL,NULL,NULL,NULL),(7,'quotations','Cotizaciones',1,NULL,NULL,NULL,NULL,NULL),(8,'sale_notes','Notas de Venta',1,'tenant.sale_notes.index','/sale-notes','NV',NULL,NULL),(9,'incentives','Comisiones',1,NULL,NULL,NULL,NULL,NULL),(10,'sale-opportunity','Oportunidad de venta',1,NULL,NULL,NULL,NULL,NULL),(11,'contracts','Contratos',1,NULL,NULL,NULL,NULL,NULL),(12,'order-note','Pedidos',1,'tenant.order_notes.index','/order-notes','PED',NULL,NULL),(13,'technical-service','Servicios de soporte técnico',1,NULL,NULL,NULL,NULL,NULL),(14,'regularize_shipping','CPE pendientes de rectificación',1,NULL,NULL,NULL,NULL,NULL),(15,'pos','Punto de venta',6,'tenant.pos.index','/pos','POS',NULL,NULL),(16,'cash','Caja chica POS',6,NULL,NULL,NULL,NULL,NULL),(17,'ecommerce','Ir a la tienda',10,NULL,NULL,NULL,NULL,NULL),(18,'ecommerce_orders','Pedidos',10,NULL,NULL,NULL,NULL,NULL),(19,'ecommerce_items','Productos tienda virtual',10,NULL,NULL,NULL,NULL,NULL),(20,'ecommerce_tags','Etiquetas',10,NULL,NULL,NULL,NULL,NULL),(21,'ecommerce_promotions','Promociones - Banners',10,NULL,NULL,NULL,NULL,NULL),(22,'ecommerce_settings','Configuración',10,NULL,NULL,NULL,NULL,NULL),(23,'items','Productos',17,'tenant.items.index','/items','PRO',NULL,NULL),(24,'items_packs','Packs',17,NULL,NULL,NULL,NULL,NULL),(25,'items_services','Servicios',17,NULL,NULL,NULL,NULL,NULL),(26,'items_categories','Categorías',17,NULL,NULL,NULL,NULL,NULL),(27,'items_brands','Marcas',17,NULL,NULL,NULL,NULL,NULL),(28,'items_lots','Series',17,NULL,NULL,NULL,NULL,NULL),(29,'clients','Clientes',18,NULL,NULL,NULL,NULL,NULL),(30,'clients_types','Tipos de clientes',18,NULL,NULL,NULL,NULL,NULL),(31,'purchases_create','Nueva Compra',2,'tenant.purchases.create','/purchases/create','NC',NULL,NULL),(32,'purchases_list','Listado',2,NULL,NULL,NULL,NULL,NULL),(33,'purchases_orders','Ordenes de compra',2,NULL,NULL,NULL,NULL,NULL),(34,'purchases_expenses','Gastos diversos',2,NULL,NULL,NULL,NULL,NULL),(35,'purchases_suppliers','Proveedores',2,NULL,NULL,NULL,NULL,NULL),(36,'purchases_quotations','Solicitar cotización',2,NULL,NULL,NULL,NULL,NULL),(37,'purchases_fixed_assets_items','Activos fijos - Ítems',2,NULL,NULL,NULL,NULL,NULL),(38,'purchases_fixed_assets_purchases','Activos fijos - Compras',2,NULL,NULL,NULL,NULL,NULL),(39,'inventory','Movimientos',8,'inventory.index','/inventory','INV',NULL,NULL),(40,'inventory_transfers','Traslados',8,NULL,NULL,NULL,NULL,NULL),(41,'inventory_devolutions','Devoluciones',8,NULL,NULL,NULL,NULL,NULL),(42,'inventory_report_kardex','Reporte kardex',8,NULL,NULL,NULL,NULL,NULL),(43,'inventory_report','Reporte inventario',8,NULL,NULL,NULL,NULL,NULL),(44,'inventory_report_valued_kardex','Kardex valorizado',8,NULL,NULL,NULL,NULL,'2026-07-26 19:40:59'),(45,'users','Usuarios',14,'tenant.users.index','/users','USR',NULL,NULL),(46,'users_establishments','Establecimientos',14,'tenant.establishments.index','/establishments','ES',NULL,NULL),(47,'advanced_retentions','Retenciones',3,NULL,NULL,NULL,NULL,NULL),(48,'advanced_dispatches','Guías de remisión',3,NULL,NULL,NULL,NULL,NULL),(49,'advanced_perceptions','Percepciones',3,NULL,NULL,NULL,NULL,NULL),(50,'advanced_order_forms','Ordenes de pedido',3,NULL,NULL,NULL,NULL,NULL),(51,'account_report','Exportar reporte',9,NULL,NULL,NULL,NULL,NULL),(52,'account_formats','Exportar formatos',9,NULL,NULL,NULL,NULL,NULL),(53,'account_summary','Reporte resumido - Ventas',9,NULL,NULL,NULL,NULL,NULL),(54,'finances_movements','Movimientos',12,NULL,NULL,NULL,NULL,NULL),(55,'finances_incomes','Ingresos',12,NULL,NULL,NULL,NULL,NULL),(56,'finances_unpaid','Cuentas por cobrar',12,NULL,NULL,NULL,NULL,NULL),(57,'finances_to_pay','Cuentas por pagar',12,NULL,NULL,NULL,NULL,NULL),(58,'finances_payments','Pagos',12,NULL,NULL,NULL,NULL,NULL),(59,'finances_balance','Balance',12,NULL,NULL,NULL,NULL,NULL),(60,'finances_payment_method_types','Ingresos y Egresos - M. Pago',12,NULL,NULL,NULL,NULL,NULL),(61,'account_users_settings','Configuración',11,NULL,NULL,NULL,NULL,NULL),(62,'account_users_list','Lista de pagos',11,NULL,NULL,NULL,NULL,NULL),(63,'hotels_reception','Recepción',15,NULL,NULL,NULL,NULL,NULL),(64,'hotels_rates','Tarifas',15,NULL,NULL,NULL,NULL,NULL),(65,'hotels_floors','Pisos',15,NULL,NULL,NULL,NULL,NULL),(66,'hotels_cats','Categorías',15,NULL,NULL,NULL,NULL,NULL),(67,'hotels_rooms','Habitaciones',15,NULL,NULL,NULL,NULL,NULL),(68,'documentary_offices','Oficinas',16,NULL,NULL,NULL,NULL,NULL),(69,'documentary_process','Procesos',16,NULL,NULL,NULL,NULL,NULL),(70,'documentary_documents','Tipos de documento',16,NULL,NULL,NULL,NULL,NULL),(71,'documentary_actions','Acciones',16,NULL,NULL,NULL,NULL,NULL),(72,'documentary_files','Expedientes',16,NULL,NULL,NULL,NULL,NULL),(73,'digemid','Productos',19,NULL,NULL,NULL,'2026-07-26 19:38:49','2026-07-26 19:38:49'),(74,'documentary_requirements','Requerimientos',16,NULL,NULL,NULL,'2026-07-26 19:38:57','2026-07-26 19:38:57'),(75,'inventory_item_extra_data','Datos extra de items',8,NULL,NULL,NULL,NULL,NULL),(76,'configuration_company','Empresa',5,'tenant.companies.create','/companies/create','ME',NULL,NULL),(77,'configuration_advance','Avanzado',5,NULL,NULL,NULL,NULL,NULL),(78,'configuration_visual','Visual',5,NULL,NULL,NULL,NULL,NULL),(79,'advanced_purchase_settlements','Liquidaciones de compra',3,NULL,NULL,NULL,NULL,NULL),(80,'suscription_app_client','Cliente',21,NULL,NULL,NULL,NULL,NULL),(81,'suscription_app_service','Servicio',21,NULL,NULL,NULL,NULL,NULL),(82,'suscription_app_payments','Pagos',21,NULL,NULL,NULL,NULL,NULL),(83,'suscription_app_plans','Planes',21,NULL,NULL,NULL,NULL,NULL),(84,'pos_garage','Venta rapida',6,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `module_levels` ENABLE KEYS */;
DROP TABLE IF EXISTS `module_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `module_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `module_user` ENABLE KEYS */;
DROP TABLE IF EXISTS `modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_menu` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `modules` DISABLE KEYS */;
INSERT INTO `modules` VALUES (1,'documents','Ventas',2,NULL,NULL),(2,'purchases','Compras',7,NULL,NULL),(3,'advanced','Documentos Avanzados',8,NULL,NULL),(4,'reports','Reportes',9,NULL,NULL),(5,'configuration','Configuration',12,NULL,NULL),(6,'pos','Punto de venta (POS)',3,NULL,NULL),(7,'dashboard','Dashboard',1,NULL,NULL),(8,'inventory','Inventario',7,NULL,NULL),(9,'accounting','Contabilidad',10,NULL,NULL),(10,'ecommerce','Ecommerce',4,NULL,NULL),(11,'cuenta','Cuenta',13,NULL,NULL),(12,'finance','Finanzas',11,NULL,NULL),(14,'establishments','Usuarios/Locales & Series',7,NULL,NULL),(15,'hotels','Hoteles',14,NULL,NULL),(16,'documentary-procedure','Trámite documentario',15,NULL,NULL),(17,'items','Productos/Servicios',5,NULL,NULL),(18,'persons','Clientes',6,NULL,NULL),(19,'digemid','Farmacia',15,'2026-07-26 19:38:49','2026-07-26 19:38:49'),(20,'apps','Apps',13,NULL,NULL),(21,'suscription_app','Suscriptiones',16,NULL,NULL),(22,'production_app','Producción',17,NULL,NULL),(23,'restaurant_app','Restaurante',18,NULL,NULL),(24,'full_suscription_app','Suscripción Servicios SAAS',17,NULL,NULL),(25,'generate_link_app','Generador de link de pago',19,NULL,NULL),(26,'app_2_generator','Generador APP 2.0',20,NULL,NULL);
/*!40000 ALTER TABLE `modules` ENABLE KEYS */;
DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int unsigned NOT NULL,
  `note_type` enum('credit','debit') COLLATE utf8mb4_unicode_ci NOT NULL,
  `note_credit_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note_debit_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note_description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `affected_document_id` int unsigned DEFAULT NULL,
  `data_affected_document` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notes_document_id_foreign` (`document_id`),
  KEY `notes_note_credit_type_id_foreign` (`note_credit_type_id`),
  KEY `notes_note_debit_type_id_foreign` (`note_debit_type_id`),
  KEY `notes_affected_document_id_foreign` (`affected_document_id`),
  CONSTRAINT `notes_affected_document_id_foreign` FOREIGN KEY (`affected_document_id`) REFERENCES `documents` (`id`),
  CONSTRAINT `notes_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notes_note_credit_type_id_foreign` FOREIGN KEY (`note_credit_type_id`) REFERENCES `cat_note_credit_types` (`id`),
  CONSTRAINT `notes_note_debit_type_id_foreign` FOREIGN KEY (`note_debit_type_id`) REFERENCES `cat_note_debit_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
DROP TABLE IF EXISTS `offline_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offline_configurations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `is_client` tinyint(1) NOT NULL DEFAULT '0',
  `token_server` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_server` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `offline_configurations` DISABLE KEYS */;
INSERT INTO `offline_configurations` VALUES (1,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `offline_configurations` ENABLE KEYS */;
DROP TABLE IF EXISTS `order_form_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_form_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_form_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_form_items_order_form_id_foreign` (`order_form_id`),
  KEY `order_form_items_item_id_foreign` (`item_id`),
  CONSTRAINT `order_form_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `order_form_items_order_form_id_foreign` FOREIGN KEY (`order_form_id`) REFERENCES `order_forms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `order_form_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_form_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `order_forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_forms` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `observations` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `transport_mode_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transfer_reason_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transfer_reason_description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_shipping` date NOT NULL,
  `transshipment_indicator` tinyint(1) NOT NULL,
  `port_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_weight` decimal(10,2) NOT NULL,
  `packages_number` int NOT NULL,
  `container_number` int DEFAULT NULL,
  `origin` json NOT NULL,
  `delivery` json NOT NULL,
  `dispatcher_id` int unsigned NOT NULL,
  `driver_id` int unsigned NOT NULL,
  `license_plates` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `optional` json DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qr` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_forms_dispatcher_id_foreign` (`dispatcher_id`),
  KEY `order_forms_driver_id_foreign` (`driver_id`),
  KEY `order_forms_user_id_foreign` (`user_id`),
  KEY `order_forms_establishment_id_foreign` (`establishment_id`),
  KEY `order_forms_soap_type_id_foreign` (`soap_type_id`),
  KEY `order_forms_state_type_id_foreign` (`state_type_id`),
  KEY `order_forms_customer_id_foreign` (`customer_id`),
  KEY `order_forms_unit_type_id_foreign` (`unit_type_id`),
  KEY `order_forms_transport_mode_type_id_foreign` (`transport_mode_type_id`),
  KEY `order_forms_transfer_reason_type_id_foreign` (`transfer_reason_type_id`),
  KEY `order_forms_date_of_issue_index` (`date_of_issue`),
  CONSTRAINT `order_forms_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `order_forms_dispatcher_id_foreign` FOREIGN KEY (`dispatcher_id`) REFERENCES `dispatchers` (`id`),
  CONSTRAINT `order_forms_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  CONSTRAINT `order_forms_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `order_forms_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `order_forms_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `order_forms_transfer_reason_type_id_foreign` FOREIGN KEY (`transfer_reason_type_id`) REFERENCES `cat_transfer_reason_types` (`id`),
  CONSTRAINT `order_forms_transport_mode_type_id_foreign` FOREIGN KEY (`transport_mode_type_id`) REFERENCES `cat_transport_mode_types` (`id`),
  CONSTRAINT `order_forms_unit_type_id_foreign` FOREIGN KEY (`unit_type_id`) REFERENCES `cat_unit_types` (`id`),
  CONSTRAINT `order_forms_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `order_forms` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_forms` ENABLE KEYS */;
DROP TABLE IF EXISTS `order_note_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_note_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_note_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_value` decimal(16,6) NOT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_plastic_bag_taxes` decimal(6,2) DEFAULT '0.00' COMMENT 'Impuesto bolsa plastica',
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(16,6) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  `additional_information` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Informacion adcional',
  `warehouse_id` int unsigned DEFAULT NULL,
  `name_product_pdf` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Nombre del producto para el pdf',
  PRIMARY KEY (`id`),
  KEY `order_note_items_order_note_id_foreign` (`order_note_id`),
  KEY `order_note_items_item_id_foreign` (`item_id`),
  KEY `order_note_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `order_note_items_system_isc_type_id_foreign` (`system_isc_type_id`),
  KEY `order_note_items_price_type_id_foreign` (`price_type_id`),
  KEY `order_note_items_warehouse_id_foreign` (`warehouse_id`),
  CONSTRAINT `order_note_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `order_note_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `order_note_items_order_note_id_foreign` FOREIGN KEY (`order_note_id`) REFERENCES `order_notes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_note_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `order_note_items_system_isc_type_id_foreign` FOREIGN KEY (`system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`),
  CONSTRAINT `order_note_items_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `order_note_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_note_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `order_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_notes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `date_of_due` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `shipping_address` text COLLATE utf8mb4_unicode_ci,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `total_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exportation` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `charges` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `guides` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `perception` json DEFAULT NULL,
  `detraction` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observation` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `quotation_id` int unsigned DEFAULT '0' COMMENT 'Relacion con cotizaciones',
  PRIMARY KEY (`id`),
  KEY `order_notes_user_id_foreign` (`user_id`),
  KEY `order_notes_establishment_id_foreign` (`establishment_id`),
  KEY `order_notes_customer_id_foreign` (`customer_id`),
  KEY `order_notes_soap_type_id_foreign` (`soap_type_id`),
  KEY `order_notes_state_type_id_foreign` (`state_type_id`),
  KEY `order_notes_currency_type_id_foreign` (`currency_type_id`),
  KEY `order_notes_payment_method_type_id_foreign` (`payment_method_type_id`),
  CONSTRAINT `order_notes_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `order_notes_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `order_notes_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `order_notes_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `order_notes_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `order_notes_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `order_notes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `order_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_notes` ENABLE KEYS */;
DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer` json NOT NULL,
  `shipping_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `items` json NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `reference_payment` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_external_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number_document` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_order_id` tinyint unsigned DEFAULT NULL,
  `purchase` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `apply_restaurant` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `orders_status_order_id_foreign` (`status_order_id`),
  CONSTRAINT `orders_status_order_id_foreign` FOREIGN KEY (`status_order_id`) REFERENCES `status_orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
DROP TABLE IF EXISTS `packaging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `packaging` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int unsigned NOT NULL,
  `user_id` int unsigned DEFAULT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_extra_data` json DEFAULT NULL,
  `establishment_id` int unsigned DEFAULT NULL,
  `quantity` decimal(8,2) DEFAULT '0.00',
  `number_packages` decimal(8,2) DEFAULT '0.00',
  `item` json DEFAULT NULL,
  `observation` longtext COLLATE utf8mb4_unicode_ci,
  `lot_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_start` date DEFAULT NULL,
  `time_start` time DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `time_end` time DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `packaging_collaborator` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `packaging_soap_type_id_foreign` (`soap_type_id`),
  CONSTRAINT `packaging_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `packaging` DISABLE KEYS */;
/*!40000 ALTER TABLE `packaging` ENABLE KEYS */;
DROP TABLE IF EXISTS `padrones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `padrones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ruc` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_razon_social` varchar(155) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_contribuyente` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `condicion_domicilio` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubigeo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_via` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_via` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_zona` varchar(155) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_zona` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero` varchar(155) COLLATE utf8mb4_unicode_ci NOT NULL,
  `interior` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lote` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `departamento` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `manzana` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kilometro` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `padrones_ruc_index` (`ruc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `padrones` DISABLE KEYS */;
/*!40000 ALTER TABLE `padrones` ENABLE KEYS */;
DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
DROP TABLE IF EXISTS `payment_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_conditions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `days` int NOT NULL DEFAULT '0',
  `is_locked` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `payment_conditions` DISABLE KEYS */;
INSERT INTO `payment_conditions` VALUES ('01','Contado',0,1,1),('02','Crédito',0,1,1);
/*!40000 ALTER TABLE `payment_conditions` ENABLE KEYS */;
DROP TABLE IF EXISTS `payment_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_configurations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `enabled_yape` tinyint(1) NOT NULL,
  `qrcode_yape` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_yape` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone_yape` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `enabled_mp` tinyint(1) NOT NULL DEFAULT '0',
  `access_token_mp` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `public_key_mp` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `payment_configurations` DISABLE KEYS */;
INSERT INTO `payment_configurations` VALUES (1,0,NULL,NULL,NULL,0,NULL,NULL,'2026-07-26 19:40:18','2026-07-26 19:40:18');
/*!40000 ALTER TABLE `payment_configurations` ENABLE KEYS */;
DROP TABLE IF EXISTS `payment_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_files` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_id` int NOT NULL,
  `payment_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_index` (`payment_id`,`payment_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `payment_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_files` ENABLE KEYS */;
DROP TABLE IF EXISTS `payment_link_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_link_types` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `payment_link_types` DISABLE KEYS */;
INSERT INTO `payment_link_types` VALUES ('01','Yape'),('02','Mercado Pago');
/*!40000 ALTER TABLE `payment_link_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `payment_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_links` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uuid` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int unsigned NOT NULL,
  `payment_link_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_id` int DEFAULT NULL,
  `payment_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total` decimal(12,2) NOT NULL,
  `uploaded_filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `query_transaction` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_links_uuid_unique` (`uuid`),
  KEY `payment_index` (`payment_id`,`payment_type`),
  KEY `payment_links_user_id_foreign` (`user_id`),
  KEY `payment_links_soap_type_id_foreign` (`soap_type_id`),
  KEY `payment_links_payment_link_type_id_foreign` (`payment_link_type_id`),
  CONSTRAINT `payment_links_payment_link_type_id_foreign` FOREIGN KEY (`payment_link_type_id`) REFERENCES `payment_link_types` (`id`),
  CONSTRAINT `payment_links_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `payment_links_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `payment_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_links` ENABLE KEYS */;
DROP TABLE IF EXISTS `payment_method_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_method_types` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `charge` decimal(12,2) DEFAULT NULL,
  `number_days` int DEFAULT NULL,
  `is_credit` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Define si es tipo credito',
  `is_cash` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Define si es es efectivo',
  `pago_sri` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `payment_method_types` DISABLE KEYS */;
INSERT INTO `payment_method_types` VALUES ('01','Efectivo',0,NULL,NULL,0,1,'01'),('02','Tarjeta de crédito',1,NULL,NULL,0,0,'19'),('03','Tarjeta de débito',1,NULL,NULL,0,0,'16'),('04','Transferencia',0,NULL,NULL,0,0,'20'),('05','Crédito 30 días',0,NULL,30,1,0,'01'),('06','Pago Inmediato',1,3.68,NULL,0,0,'01'),('07','Contado contraentrega',0,NULL,NULL,0,0,'01'),('08','Crédito a 60 días',0,NULL,60,1,0,'01'),('09','Crédito a 15 días',1,NULL,15,1,0,'01'),('10','Canje',0,NULL,NULL,0,1,'01'),('12','Crédito 90 días',0,NULL,90,1,0,'01'),('13','Cheque',0,NULL,NULL,0,1,'20');
/*!40000 ALTER TABLE `payment_method_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `perception_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perception_documents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `perception_id` int unsigned NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `date_of_perception` date NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_document` decimal(10,2) NOT NULL,
  `total_perception` decimal(10,2) NOT NULL,
  `payments` json NOT NULL,
  `series` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `exchange_rate` json NOT NULL,
  `total_to_pay` decimal(10,2) NOT NULL,
  `total_payment` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `perception_details_perception_id_foreign` (`perception_id`),
  KEY `perception_documents_document_type_id_foreign` (`document_type_id`),
  KEY `perception_documents_currency_type_id_foreign` (`currency_type_id`),
  CONSTRAINT `perception_details_perception_id_foreign` FOREIGN KEY (`perception_id`) REFERENCES `perceptions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `perception_documents_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `perception_documents_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `perception_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `perception_documents` ENABLE KEYS */;
DROP TABLE IF EXISTS `perceptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perceptions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubl_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `perception_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observations` text COLLATE utf8mb4_unicode_ci,
  `total_perception` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `optional` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time_of_issue` time NOT NULL,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_xml` tinyint(1) NOT NULL DEFAULT '0',
  `has_pdf` tinyint(1) NOT NULL DEFAULT '0',
  `has_cdr` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `perceptions_user_id_foreign` (`user_id`),
  KEY `perceptions_establishment_id_foreign` (`establishment_id`),
  KEY `perceptions_soap_type_id_foreign` (`soap_type_id`),
  KEY `perceptions_state_type_id_foreign` (`state_type_id`),
  KEY `perceptions_document_type_id_foreign` (`document_type_id`),
  KEY `perceptions_currency_type_id_foreign` (`currency_type_id`),
  KEY `perceptions_perception_type_id_foreign` (`perception_type_id`),
  KEY `perceptions_customer_id_foreign` (`customer_id`),
  KEY `perceptions_number_index` (`number`),
  KEY `perceptions_series_index` (`series`),
  CONSTRAINT `perceptions_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `perceptions_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `perceptions_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `perceptions_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `perceptions_perception_type_id_foreign` FOREIGN KEY (`perception_type_id`) REFERENCES `cat_perception_types` (`id`),
  CONSTRAINT `perceptions_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `perceptions_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `perceptions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `perceptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `perceptions` ENABLE KEYS */;
DROP TABLE IF EXISTS `person_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_address` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `person_id` int unsigned NOT NULL,
  `department_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `province_id` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district_id` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `person_address_person_id_foreign` (`person_id`),
  KEY `person_address_department_id_foreign` (`department_id`),
  KEY `person_address_province_id_foreign` (`province_id`),
  KEY `person_address_district_id_foreign` (`district_id`),
  CONSTRAINT `person_address_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  CONSTRAINT `person_address_district_id_foreign` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `person_address_person_id_foreign` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `person_address_province_id_foreign` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `person_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `person_address` ENABLE KEYS */;
DROP TABLE IF EXISTS `person_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_addresses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `person_id` int unsigned NOT NULL,
  `country_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `province_id` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district_id` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `main` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `person_addresses_person_id_foreign` (`person_id`),
  KEY `person_addresses_country_id_foreign` (`country_id`),
  KEY `person_addresses_department_id_foreign` (`department_id`),
  KEY `person_addresses_province_id_foreign` (`province_id`),
  KEY `person_addresses_district_id_foreign` (`district_id`),
  CONSTRAINT `person_addresses_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`),
  CONSTRAINT `person_addresses_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  CONSTRAINT `person_addresses_district_id_foreign` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `person_addresses_person_id_foreign` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `person_addresses_province_id_foreign` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `person_addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `person_addresses` ENABLE KEYS */;
DROP TABLE IF EXISTS `person_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `person_types` DISABLE KEYS */;
INSERT INTO `person_types` VALUES (1,'Interno','2026-07-26 19:37:15','2026-07-26 19:37:15'),(2,'Distribuidor','2026-07-26 19:37:15','2026-07-26 19:37:15');
/*!40000 ALTER TABLE `person_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persons` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('customers','suppliers') COLLATE utf8mb4_unicode_ci NOT NULL,
  `identity_document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `trade_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `internal_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `barcode` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nationality_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `department_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `province_id` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district_id` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `condition` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `accumulated_points` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'sistema por puntos',
  `perception_agent` tinyint(1) NOT NULL DEFAULT '0',
  `person_type_id` int unsigned DEFAULT NULL,
  `contact` json DEFAULT NULL,
  `comment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `percentage_perception` decimal(12,2) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `website` text COLLATE utf8mb4_unicode_ci COMMENT 'Sitio Web',
  `zone` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Zona',
  `observation` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Observaciones',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `credit_days` int unsigned DEFAULT '0' COMMENT 'establece los dias de credito',
  `optional_email` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Conjunto de correos de envio',
  `parent_id` int unsigned DEFAULT '0' COMMENT 'Se relaciona con si mismo, numero mayor a 0 es el id del padre.',
  `zone_id` int unsigned DEFAULT NULL,
  `seller_id` int unsigned DEFAULT NULL,
  `has_discount` tinyint(1) NOT NULL DEFAULT '0',
  `discount_type` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '01',
  `discount_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `persons_identity_document_type_id_foreign` (`identity_document_type_id`),
  KEY `persons_country_id_foreign` (`country_id`),
  KEY `persons_department_id_foreign` (`department_id`),
  KEY `persons_province_id_foreign` (`province_id`),
  KEY `persons_district_id_foreign` (`district_id`),
  KEY `persons_name_index` (`name`),
  KEY `persons_number_index` (`number`),
  KEY `persons_type_index` (`type`),
  KEY `persons_person_type_id_foreign` (`person_type_id`),
  KEY `persons_enabled_index` (`enabled`),
  KEY `persons_address_type_id_foreign` (`address_type_id`),
  KEY `persons_seller_id_index` (`seller_id`),
  KEY `persons_nationality_id_foreign` (`nationality_id`),
  CONSTRAINT `persons_address_type_id_foreign` FOREIGN KEY (`address_type_id`) REFERENCES `cat_address_types` (`id`),
  CONSTRAINT `persons_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`),
  CONSTRAINT `persons_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  CONSTRAINT `persons_district_id_foreign` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `persons_identity_document_type_id_foreign` FOREIGN KEY (`identity_document_type_id`) REFERENCES `cat_identity_document_types` (`id`),
  CONSTRAINT `persons_nationality_id_foreign` FOREIGN KEY (`nationality_id`) REFERENCES `countries` (`id`),
  CONSTRAINT `persons_person_type_id_foreign` FOREIGN KEY (`person_type_id`) REFERENCES `person_types` (`id`),
  CONSTRAINT `persons_province_id_foreign` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `persons` DISABLE KEYS */;
INSERT INTO `persons` VALUES (1,'customers','0','9999999999999','Consumidor final',NULL,NULL,NULL,'EC',NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'9999999999',0.00,0,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,'2026-07-26 19:40:37','2026-07-26 19:40:37',1,0,NULL,0,NULL,NULL,0,'01',0.00);
/*!40000 ALTER TABLE `persons` ENABLE KEYS */;
DROP TABLE IF EXISTS `preprinted_format_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preprinted_format_templates` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `formats` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `preprinted_format_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `preprinted_format_templates` ENABLE KEYS */;
DROP TABLE IF EXISTS `production`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `production` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT '0',
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` int unsigned DEFAULT '0',
  `inventory_id_reference` int unsigned DEFAULT NULL,
  `quantity` decimal(12,4) DEFAULT '0.0000' COMMENT 'Peso dle insumo ',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `machine_id` int unsigned NOT NULL DEFAULT '0',
  `production_order` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` longtext COLLATE utf8mb4_unicode_ci,
  `date_start` date DEFAULT NULL,
  `time_start` time DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `time_end` time DEFAULT NULL,
  `lot_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_extra_data` json DEFAULT NULL,
  `mix_date_start` date DEFAULT NULL,
  `mix_time_start` time DEFAULT NULL,
  `mix_date_end` date DEFAULT NULL,
  `mix_time_end` time DEFAULT NULL,
  `informative` tinyint unsigned DEFAULT '0',
  `agreed` decimal(8,2) DEFAULT '0.00',
  `imperfect` decimal(8,2) DEFAULT '0.00',
  `proccess_type` longtext COLLATE utf8mb4_unicode_ci,
  `production_collaborator` text COLLATE utf8mb4_unicode_ci,
  `mix_collaborator` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `production_soap_type_id_foreign` (`soap_type_id`),
  CONSTRAINT `production_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `production` DISABLE KEYS */;
/*!40000 ALTER TABLE `production` ENABLE KEYS */;
DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_id` int unsigned NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `apply_restaurant` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `promotions_item_id_foreign` (`item_id`),
  CONSTRAINT `promotions_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
DROP TABLE IF EXISTS `provinces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provinces` (
  `id` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `provinces_department_id_foreign` (`department_id`),
  CONSTRAINT `provinces_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `provinces` DISABLE KEYS */;
INSERT INTO `provinces` VALUES ('0101','01','CUENCA',1),('0102','01','GIRÓN',1),('0103','01','GUALACEO',1),('0104','01','NABÓN',1),('0105','01','PAUTE',1),('0106','01','PUCARA',1),('0107','01','SAN FERNANDO',1),('0108','01','SANTA ISABEL',1),('0109','01','SIGSIG',1),('0110','01','OÑA',1),('0111','01','CHORDELEG',1),('0112','01','EL PAN',1),('0113','01','SEVILLA DE ORO',1),('0114','01','GUACHAPALA',1),('0115','01','CAMILO PONCE ENRÍQUEZ',1),('0201','02','GUARANDA',1),('0202','02','CHILLANES',1),('0203','02','CHIMBO',1),('0204','02','ECHEANDÍA',1),('0205','02','SAN MIGUEL',1),('0206','02','CALUMA',1),('0207','02','LAS NAVES',1),('0301','03','AZOGUES',1),('0302','03','BIBLIÁN',1),('0303','03','CAÑAR',1),('0304','03','LA TRONCAL',1),('0305','03','EL TAMBO',1),('0306','03','DÉLEG',1),('0307','03','SUSCAL',1),('0401','04','TULCÁN',1),('0402','04','BOLÍVAR',1),('0403','04','ESPEJO',1),('0404','04','MIRA',1),('0405','04','MONTÚFAR',1),('0406','04','SAN PEDRO DE HUACA',1),('0501','05','LATACUNGA',1),('0502','05','LA MANÁ',1),('0503','05','PANGUA',1),('0504','05','PUJILI',1),('0505','05','SALCEDO',1),('0506','05','SAQUISILÍ',1),('0507','05','SIGCHOS',1),('0601','06','RIOBAMBA',1),('0602','06','ALAUSI',1),('0603','06','COLTA',1),('0604','06','CHAMBO',1),('0605','06','CHUNCHI',1),('0606','06','GUAMOTE',1),('0607','06','GUANO',1),('0608','06','PALLATANGA',1),('0609','06','PENIPE',1),('0610','06','CUMANDÁ',1),('0701','07','MACHALA',1),('0702','07','ARENILLAS',1),('0703','07','ATAHUALPA',1),('0704','07','BALSAS',1),('0705','07','CHILLA',1),('0706','07','EL GUABO',1),('0707','07','HUAQUILLAS',1),('0708','07','MARCABELÍ',1),('0709','07','PASAJE',1),('0710','07','PIÑAS',1),('0711','07','PORTOVELO',1),('0712','07','SANTA ROSA',1),('0713','07','ZARUMA',1),('0714','07','LAS LAJAS',1),('0801','08','ESMERALDAS',1),('0802','08','ELOY ALFARO',1),('0803','08','MUISNE',1),('0804','08','QUININDÉ',1),('0805','08','SAN LORENZO',1),('0806','08','ATACAMES',1),('0807','08','RIOVERDE',1),('0808','08','LA CONCORDIA',1),('0901','09','GUAYAQUIL',1),('0902','09','ALFREDO BAQUERIZO MORENO (JUJÁN)',1),('0903','09','BALAO',1),('0904','09','BALZAR',1),('0905','09','COLIMES',1),('0906','09','DAULE',1),('0907','09','DURÁN',1),('0908','09','EL EMPALME',1),('0909','09','EL TRIUNFO',1),('0910','09','MILAGRO',1),('0911','09','NARANJAL',1),('0912','09','NARANJITO',1),('0913','09','PALESTINA',1),('0914','09','PEDRO CARBO',1),('0916','09','SAMBORONDÓN',1),('0918','09','SANTA LUCÍA',1),('0919','09','SALITRE (URBINA JADO)',1),('0920','09','SAN JACINTO DE YAGUACHI',1),('0921','09','PLAYAS',1),('0922','09','SIMÓN BOLÍVAR',1),('0923','09','CORONEL MARCELINO MARIDUEÑA',1),('0924','09','LOMAS DE SARGENTILLO',1),('0925','09','NOBOL',1),('0927','09','GENERAL ANTONIO ELIZALDE',1),('0928','09','ISIDRO AYORA',1),('1001','10','IBARRA',1),('1002','10','ANTONIO ANTE',1),('1003','10','COTACACHI',1),('1004','10','OTAVALO',1),('1005','10','PIMAMPIRO',1),('1006','10','SAN MIGUEL DE URCUQUÍ',1),('1101','11','LOJA',1),('1102','11','CALVAS',1),('1103','11','CATAMAYO',1),('1104','11','CELICA',1),('1105','11','CHAGUARPAMBA',1),('1106','11','ESPÍNDOLA',1),('1107','11','GONZANAMÁ',1),('1108','11','MACARÁ',1),('1109','11','PALTAS',1),('1110','11','PUYANGO',1),('1111','11','SARAGURO',1),('1112','11','SOZORANGA',1),('1113','11','ZAPOTILLO',1),('1114','11','PINDAL',1),('1115','11','QUILANGA',1),('1116','11','OLMEDO',1),('1201','12','BABAHOYO',1),('1202','12','BABA',1),('1203','12','MONTALVO',1),('1204','12','PUEBLOVIEJO',1),('1205','12','QUEVEDO',1),('1206','12','URDANETA',1),('1207','12','VENTANAS',1),('1208','12','VÍNCES',1),('1209','12','PALENQUE',1),('1210','12','BUENA FÉ',1),('1211','12','VALENCIA',1),('1212','12','MOCACHE',1),('1213','12','QUINSALOMA',1),('1301','13','PORTOVIEJO',1),('1302','13','BOLÍVAR',1),('1303','13','CHONE',1),('1304','13','EL CARMEN',1),('1305','13','FLAVIO ALFARO',1),('1306','13','JIPIJAPA',1),('1307','13','JUNÍN',1),('1308','13','MANTA',1),('1309','13','MONTECRISTI',1),('1310','13','PAJÁN',1),('1311','13','PICHINCHA',1),('1312','13','ROCAFUERTE',1),('1313','13','SANTA ANA',1),('1314','13','SUCRE',1),('1315','13','TOSAGUA',1),('1316','13','24 DE MAYO',1),('1317','13','PEDERNALES',1),('1318','13','OLMEDO',1),('1319','13','PUERTO LÓPEZ',1),('1320','13','JAMA',1),('1321','13','JARAMIJÓ',1),('1322','13','SAN VICENTE',1),('1401','14','MORONA',1),('1402','14','GUALAQUIZA',1),('1403','14','LIMÓN INDANZA',1),('1404','14','PALORA',1),('1405','14','SANTIAGO',1),('1406','14','SUCÚA',1),('1407','14','HUAMBOYA',1),('1408','14','SAN JUAN BOSCO',1),('1409','14','TAISHA',1),('1410','14','LOGROÑO',1),('1411','14','PABLO SEXTO',1),('1412','14','TIWINTZA',1),('1501','15','TENA',1),('1503','15','ARCHIDONA',1),('1504','15','EL CHACO',1),('1507','15','QUIJOS',1),('1509','15','CARLOS JULIO AROSEMENA TOLA',1),('1601','16','PASTAZA',1),('1602','16','MERA',1),('1603','16','SANTA CLARA',1),('1604','16','ARAJUNO',1),('1701','17','QUITO',1),('1702','17','CAYAMBE',1),('1703','17','MEJIA',1),('1704','17','PEDRO MONCAYO',1),('1705','17','RUMIÑAHUI',1),('1707','17','SAN MIGUEL DE LOS BANCOS',1),('1708','17','PEDRO VICENTE MALDONADO',1),('1709','17','PUERTO QUITO',1),('1801','18','AMBATO',1),('1802','18','BAÑOS DE AGUA SANTA',1),('1803','18','CEVALLOS',1),('1804','18','MOCHA',1),('1805','18','PATATE',1),('1806','18','QUERO',1),('1807','18','SAN PEDRO DE PELILEO',1),('1808','18','SANTIAGO DE PÍLLARO',1),('1809','18','TISALEO',1),('1901','19','ZAMORA',1),('1902','19','CHINCHIPE',1),('1903','19','NANGARITZA',1),('1904','19','YACUAMBI',1),('1905','19','YANTZAZA (YANZATZA)',1),('1906','19','EL PANGUI',1),('1907','19','CENTINELA DEL CÓNDOR',1),('1908','19','PALANDA',1),('1909','19','PAQUISHA',1),('2001','20','SAN CRISTÓBAL',1),('2002','20','ISABELA',1),('2003','20','SANTA CRUZ',1),('2101','21','LAGO AGRIO',1),('2102','21','GONZALO PIZARRO',1),('2103','21','PUTUMAYO',1),('2104','21','SHUSHUFINDI',1),('2105','21','SUCUMBÍOS',1),('2106','21','CASCALES',1),('2107','21','CUYABENO',1),('2201','22','ORELLANA',1),('2202','22','AGUARICO',1),('2203','22','LA JOYA DE LOS SACHAS',1),('2204','22','LORETO',1),('2301','23','SANTO DOMINGO',1),('2401','24','SANTA ELENA',1),('2402','24','LA LIBERTAD',1),('2403','24','SALINAS',1),('9001','90','LAS GOLONDRINAS',1),('9003','90','MANGA DEL CURA',1),('9004','90','EL PIEDRERO',1);
/*!40000 ALTER TABLE `provinces` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_fee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_fee` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `purchase_id` int unsigned NOT NULL,
  `date` date NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_fee_purchase_id_foreign` (`purchase_id`),
  KEY `purchase_fee_currency_type_id_foreign` (`currency_type_id`),
  KEY `purchase_fee_payment_method_type_id_foreign` (`payment_method_type_id`),
  CONSTRAINT `purchase_fee_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `purchase_fee_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `purchase_fee_purchase_id_foreign` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_fee` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_fee` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `purchase_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `item_lot_group_id` int unsigned DEFAULT NULL,
  `lot_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_value` decimal(16,6) NOT NULL,
  `date_of_due` date DEFAULT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(16,6) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  `warehouse_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_items_purchase_id_foreign` (`purchase_id`),
  KEY `purchase_items_item_id_foreign` (`item_id`),
  KEY `purchase_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `purchase_items_system_isc_type_id_foreign` (`system_isc_type_id`),
  KEY `purchase_items_price_type_id_foreign` (`price_type_id`),
  KEY `purchase_items_warehouse_id_foreign` (`warehouse_id`),
  KEY `purchase_items_item_lot_group_id_index` (`item_lot_group_id`),
  CONSTRAINT `purchase_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `purchase_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `purchase_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `purchase_items_purchase_id_foreign` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE,
  CONSTRAINT `purchase_items_system_isc_type_id_foreign` FOREIGN KEY (`system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`),
  CONSTRAINT `purchase_items_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `purchase_order_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` int NOT NULL,
  `unit_value` decimal(16,6) NOT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(16,6) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_order_items_purchase_order_id_foreign` (`purchase_order_id`),
  KEY `purchase_order_items_item_id_foreign` (`item_id`),
  KEY `purchase_order_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `purchase_order_items_system_isc_type_id_foreign` (`system_isc_type_id`),
  KEY `purchase_order_items_price_type_id_foreign` (`price_type_id`),
  CONSTRAINT `purchase_order_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `purchase_order_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `purchase_order_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `purchase_order_items_purchase_order_id_foreign` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `purchase_order_items_system_isc_type_id_foreign` FOREIGN KEY (`system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OC',
  `date_of_issue` date NOT NULL,
  `date_of_due` date DEFAULT NULL,
  `time_of_issue` time NOT NULL,
  `supplier_id` int unsigned NOT NULL,
  `supplier` json NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `total_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exportation` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `upload_filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purchase_quotation_id` int unsigned DEFAULT NULL,
  `sale_opportunity_id` int unsigned DEFAULT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_orders_purchase_quotation_id_foreign` (`purchase_quotation_id`),
  KEY `purchase_orders_user_id_foreign` (`user_id`),
  KEY `purchase_orders_establishment_id_foreign` (`establishment_id`),
  KEY `purchase_orders_supplier_id_foreign` (`supplier_id`),
  KEY `purchase_orders_soap_type_id_foreign` (`soap_type_id`),
  KEY `purchase_orders_state_type_id_foreign` (`state_type_id`),
  KEY `purchase_orders_currency_type_id_foreign` (`currency_type_id`),
  KEY `purchase_orders_payment_method_type_id_foreign` (`payment_method_type_id`),
  KEY `purchase_orders_sale_opportunity_id_foreign` (`sale_opportunity_id`),
  CONSTRAINT `purchase_orders_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `purchase_orders_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `purchase_orders_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `purchase_orders_purchase_quotation_id_foreign` FOREIGN KEY (`purchase_quotation_id`) REFERENCES `purchase_quotations` (`id`),
  CONSTRAINT `purchase_orders_sale_opportunity_id_foreign` FOREIGN KEY (`sale_opportunity_id`) REFERENCES `sale_opportunities` (`id`),
  CONSTRAINT `purchase_orders_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `purchase_orders_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `purchase_orders_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `purchase_orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_orders` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `purchase_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `card_brand_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_payments_purchase_id_foreign` (`purchase_id`),
  KEY `purchase_payments_card_brand_id_foreign` (`card_brand_id`),
  KEY `purchase_payments_payment_method_type_id_foreign` (`payment_method_type_id`),
  KEY `purchase_payments_date_of_payment_index` (`date_of_payment`),
  CONSTRAINT `purchase_payments_card_brand_id_foreign` FOREIGN KEY (`card_brand_id`) REFERENCES `card_brands` (`id`),
  CONSTRAINT `purchase_payments_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `purchase_payments_purchase_id_foreign` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_quotation_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_quotation_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `purchase_quotation_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_quotation_items_purchase_quotation_id_foreign` (`purchase_quotation_id`),
  KEY `purchase_quotation_items_item_id_foreign` (`item_id`),
  CONSTRAINT `purchase_quotation_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `purchase_quotation_items_purchase_quotation_id_foreign` FOREIGN KEY (`purchase_quotation_id`) REFERENCES `purchase_quotations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_quotation_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_quotation_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_quotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_quotations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `suppliers` json NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_quotations_user_id_foreign` (`user_id`),
  KEY `purchase_quotations_establishment_id_foreign` (`establishment_id`),
  KEY `purchase_quotations_soap_type_id_foreign` (`soap_type_id`),
  KEY `purchase_quotations_state_type_id_foreign` (`state_type_id`),
  CONSTRAINT `purchase_quotations_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `purchase_quotations_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `purchase_quotations_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `purchase_quotations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_quotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_quotations` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_settlement_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_settlement_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `purchase_settlement_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,2) NOT NULL,
  `unit_value` decimal(12,2) NOT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `income_tax_affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `income_retention_percentage` decimal(12,2) NOT NULL DEFAULT '0.00',
  `income_retention_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `purchase_settlement_items_purchase_settlement_id_foreign` (`purchase_settlement_id`),
  KEY `purchase_settlement_items_item_id_foreign` (`item_id`),
  KEY `p_s_i_income_tax_affectation_igv_type_id_fk` (`income_tax_affectation_igv_type_id`),
  KEY `purchase_settlement_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `purchase_settlement_items_price_type_id_foreign` (`price_type_id`),
  CONSTRAINT `p_s_i_income_tax_affectation_igv_type_id_fk` FOREIGN KEY (`income_tax_affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `purchase_settlement_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `purchase_settlement_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `purchase_settlement_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `purchase_settlement_items_purchase_settlement_id_foreign` FOREIGN KEY (`purchase_settlement_id`) REFERENCES `purchase_settlements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_settlement_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_settlement_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_settlement_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_settlement_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `purchase_settlement_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `change` decimal(12,2) NOT NULL DEFAULT '0.00',
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_settlement_payments_purchase_settlement_id_foreign` (`purchase_settlement_id`),
  KEY `purchase_settlement_payments_payment_method_type_id_foreign` (`payment_method_type_id`),
  CONSTRAINT `purchase_settlement_payments_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `purchase_settlement_payments_purchase_settlement_id_foreign` FOREIGN KEY (`purchase_settlement_id`) REFERENCES `purchase_settlements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_settlement_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_settlement_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchase_settlements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_settlements` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubl_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operation_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `supplier_id` int unsigned NOT NULL,
  `supplier` json NOT NULL,
  `operation_data` json NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exchange_rate_sale` decimal(12,2) NOT NULL,
  `total_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `legends` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `observations` text COLLATE utf8mb4_unicode_ci,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_xml` tinyint(1) NOT NULL DEFAULT '0',
  `has_pdf` tinyint(1) NOT NULL DEFAULT '0',
  `has_cdr` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `purchase_settlements_filename_unique` (`filename`),
  KEY `purchase_settlements_user_id_foreign` (`user_id`),
  KEY `purchase_settlements_establishment_id_foreign` (`establishment_id`),
  KEY `purchase_settlements_supplier_id_foreign` (`supplier_id`),
  KEY `purchase_settlements_soap_type_id_foreign` (`soap_type_id`),
  KEY `purchase_settlements_state_type_id_foreign` (`state_type_id`),
  KEY `purchase_settlements_document_type_id_foreign` (`document_type_id`),
  KEY `purchase_settlements_currency_type_id_foreign` (`currency_type_id`),
  KEY `purchase_settlements_operation_type_id_foreign` (`operation_type_id`),
  KEY `purchase_settlements_series_index` (`series`),
  KEY `purchase_settlements_number_index` (`number`),
  KEY `purchase_settlements_date_of_issue_index` (`date_of_issue`),
  KEY `purchase_settlements_payment_method_type_id_foreign` (`payment_method_type_id`),
  CONSTRAINT `purchase_settlements_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `purchase_settlements_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `purchase_settlements_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `purchase_settlements_operation_type_id_foreign` FOREIGN KEY (`operation_type_id`) REFERENCES `cat_operation_types` (`id`),
  CONSTRAINT `purchase_settlements_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `purchase_settlements_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `purchase_settlements_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `purchase_settlements_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `purchase_settlements_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchase_settlements` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_settlements` ENABLE KEYS */;
DROP TABLE IF EXISTS `purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchases` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `group_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `date_of_due` date DEFAULT NULL,
  `time_of_issue` time NOT NULL,
  `supplier_id` int unsigned NOT NULL,
  `supplier` json NOT NULL,
  `purchase_order_id` int unsigned DEFAULT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_condition_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observation` text COLLATE utf8mb4_unicode_ci,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `total_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exportation` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_canceled` tinyint(1) NOT NULL DEFAULT '0',
  `customer_id` int unsigned DEFAULT NULL,
  `perception_date` date DEFAULT NULL,
  `perception_number` int DEFAULT NULL,
  `total_perception` decimal(12,2) DEFAULT NULL,
  `charges` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `guides` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `perception` json DEFAULT NULL,
  `detraction` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchases_user_id_foreign` (`user_id`),
  KEY `purchases_establishment_id_foreign` (`establishment_id`),
  KEY `purchases_supplier_id_foreign` (`supplier_id`),
  KEY `purchases_soap_type_id_foreign` (`soap_type_id`),
  KEY `purchases_state_type_id_foreign` (`state_type_id`),
  KEY `purchases_group_id_foreign` (`group_id`),
  KEY `purchases_document_type_id_foreign` (`document_type_id`),
  KEY `purchases_currency_type_id_foreign` (`currency_type_id`),
  KEY `purchases_purchase_order_id_foreign` (`purchase_order_id`),
  KEY `purchases_customer_id_foreign` (`customer_id`),
  KEY `purchases_payment_condition_id_foreign` (`payment_condition_id`),
  CONSTRAINT `purchases_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `purchases_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `purchases_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `purchases_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `purchases_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `purchases_payment_condition_id_foreign` FOREIGN KEY (`payment_condition_id`) REFERENCES `general_payment_conditions` (`id`),
  CONSTRAINT `purchases_purchase_order_id_foreign` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`),
  CONSTRAINT `purchases_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `purchases_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `purchases_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `purchases_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `purchases` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchases` ENABLE KEYS */;
DROP TABLE IF EXISTS `quotation_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `quotation_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_value` decimal(16,6) NOT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(16,6) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  `additional_information` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Informacion adicional',
  `warehouse_id` int unsigned DEFAULT '0' COMMENT 'Id de warehouse',
  `name_product_pdf` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Nombre de producto en el pdf',
  PRIMARY KEY (`id`),
  KEY `quotation_items_quotation_id_foreign` (`quotation_id`),
  KEY `quotation_items_item_id_foreign` (`item_id`),
  KEY `quotation_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `quotation_items_system_isc_type_id_foreign` (`system_isc_type_id`),
  KEY `quotation_items_price_type_id_foreign` (`price_type_id`),
  CONSTRAINT `quotation_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `quotation_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `quotation_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `quotation_items_quotation_id_foreign` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `quotation_items_system_isc_type_id_foreign` FOREIGN KEY (`system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `quotation_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `quotation_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `quotation_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `card_brand_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `change` decimal(12,2) DEFAULT NULL,
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `quotation_payments_quotation_id_foreign` (`quotation_id`),
  KEY `quotation_payments_card_brand_id_foreign` (`card_brand_id`),
  KEY `quotation_payments_payment_method_type_id_foreign` (`payment_method_type_id`),
  CONSTRAINT `quotation_payments_card_brand_id_foreign` FOREIGN KEY (`card_brand_id`) REFERENCES `card_brands` (`id`),
  CONSTRAINT `quotation_payments_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `quotation_payments_quotation_id_foreign` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `quotation_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `quotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `seller_id` int unsigned DEFAULT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `date_of_due` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_date` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `shipping_address` text COLLATE utf8mb4_unicode_ci,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `total_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exportation` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `charges` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `guides` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `perception` json DEFAULT NULL,
  `detraction` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `terms_condition` text COLLATE utf8mb4_unicode_ci,
  `referential_information` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `changed` tinyint(1) NOT NULL DEFAULT '0',
  `sale_opportunity_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quotations_user_id_foreign` (`user_id`),
  KEY `quotations_establishment_id_foreign` (`establishment_id`),
  KEY `quotations_customer_id_foreign` (`customer_id`),
  KEY `quotations_soap_type_id_foreign` (`soap_type_id`),
  KEY `quotations_state_type_id_foreign` (`state_type_id`),
  KEY `quotations_currency_type_id_foreign` (`currency_type_id`),
  KEY `quotations_payment_method_type_id_foreign` (`payment_method_type_id`),
  KEY `quotations_sale_opportunity_id_foreign` (`sale_opportunity_id`),
  CONSTRAINT `quotations_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `quotations_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `quotations_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `quotations_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `quotations_sale_opportunity_id_foreign` FOREIGN KEY (`sale_opportunity_id`) REFERENCES `sale_opportunities` (`id`),
  CONSTRAINT `quotations_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `quotations_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `quotations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `quotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotations` ENABLE KEYS */;
DROP TABLE IF EXISTS `rel_user_to_documentary_offices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rel_user_to_documentary_offices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `active` tinyint unsigned NOT NULL DEFAULT '0',
  `user_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'usuario asociado',
  `documentary_office_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'etapa asociada',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `rel_user_to_documentary_offices` DISABLE KEYS */;
/*!40000 ALTER TABLE `rel_user_to_documentary_offices` ENABLE KEYS */;
DROP TABLE IF EXISTS `report_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_configurations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `route_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `route_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `convert_pen` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `report_configurations_route_name_unique` (`route_name`),
  UNIQUE KEY `report_configurations_route_path_unique` (`route_path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `report_configurations` DISABLE KEYS */;
INSERT INTO `report_configurations` VALUES (1,'tenant.reports.general_items.index','reports/general-items','Ventas - Reporte general de productos',0,'2026-07-26 19:40:09','2026-07-26 19:40:09'),(2,'tenant.reports.purchases.general_items.index','reports/purchases/general_items','Compras - Reporte general de productos',0,'2026-07-26 19:40:09','2026-07-26 19:40:09'),(3,'tenant.reports.purchases.index','reports/purchases','Compras - Compras totales',0,'2026-07-26 19:40:09','2026-07-26 19:40:09');
/*!40000 ALTER TABLE `report_configurations` ENABLE KEYS */;
DROP TABLE IF EXISTS `restaurant_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_configurations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `menu_pos` tinyint(1) NOT NULL,
  `menu_order` tinyint(1) NOT NULL,
  `menu_tables` tinyint(1) NOT NULL,
  `first_menu` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tables_quantity` int NOT NULL DEFAULT '15',
  `menu_bar` tinyint(1) NOT NULL DEFAULT '1',
  `menu_kitchen` tinyint(1) NOT NULL DEFAULT '1',
  `items_maintenance` tinyint(1) NOT NULL DEFAULT '0',
  `enabled_environment_1` tinyint(1) NOT NULL DEFAULT '1',
  `enabled_environment_2` tinyint(1) NOT NULL DEFAULT '0',
  `tables_quantity_environment_2` int NOT NULL DEFAULT '5',
  `enabled_environment_3` tinyint(1) NOT NULL DEFAULT '0',
  `tables_quantity_environment_3` int NOT NULL DEFAULT '5',
  `enabled_environment_4` tinyint(1) NOT NULL DEFAULT '0',
  `tables_quantity_environment_4` int NOT NULL DEFAULT '5',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `restaurant_configurations` DISABLE KEYS */;
INSERT INTO `restaurant_configurations` VALUES (1,1,1,1,'POS',15,1,1,0,1,0,5,0,5,0,5);
/*!40000 ALTER TABLE `restaurant_configurations` ENABLE KEYS */;
DROP TABLE IF EXISTS `restaurant_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_roles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `restaurant_roles` DISABLE KEYS */;
INSERT INTO `restaurant_roles` VALUES (1,'MOZO','Mozo','Usuario que genera pedidos en mesas',NULL,NULL),(2,'CAJA','Caja','Usuario que genera pago de pedidos',NULL,NULL),(3,'ADM','Administrador','Usuario con permisos totales',NULL,NULL),(4,'KIT','Comanda/Cocina','Usuario con acceso a cocina',NULL,NULL),(5,'BAR','Comanda/Bar','Usuario con acceso a bar',NULL,NULL);
/*!40000 ALTER TABLE `restaurant_roles` ENABLE KEYS */;
DROP TABLE IF EXISTS `retenciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retenciones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ambiente` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_emision` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_comercial` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clave_acceso` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cod_doc` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estab` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pto_emi` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secuencial` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dir_matriz` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_emision` date NOT NULL,
  `contribuyente_especial` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `obligado_contabilidad` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_identificacion_sujeto_retenido` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social_sujeto_retenido` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identificacion_sujeto_retenido` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `periodo_fiscal` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `retenciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `retenciones` ENABLE KEYS */;
DROP TABLE IF EXISTS `retention_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retention_documents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `retention_id` int unsigned NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_document` decimal(10,2) NOT NULL,
  `payments` json NOT NULL,
  `exchange_rate` json NOT NULL,
  `date_of_retention` date NOT NULL,
  `total_retention` decimal(10,2) NOT NULL,
  `total_to_pay` decimal(10,2) NOT NULL,
  `total_payment` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `retention_documents_retention_id_foreign` (`retention_id`),
  KEY `retention_documents_document_type_id_foreign` (`document_type_id`),
  KEY `retention_documents_currency_type_id_foreign` (`currency_type_id`),
  CONSTRAINT `retention_documents_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `retention_documents_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `retention_documents_retention_id_foreign` FOREIGN KEY (`retention_id`) REFERENCES `retentions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `retention_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `retention_documents` ENABLE KEYS */;
DROP TABLE IF EXISTS `retentions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retentions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubl_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `supplier_id` int unsigned NOT NULL,
  `supplier` json NOT NULL,
  `retention_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observations` text COLLATE utf8mb4_unicode_ci,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_retention` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `legends` json DEFAULT NULL,
  `optional` json DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `soap_shipping_response` json DEFAULT NULL,
  `has_xml` tinyint(1) NOT NULL DEFAULT '0',
  `has_pdf` tinyint(1) NOT NULL DEFAULT '0',
  `has_cdr` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `retentions_user_id_foreign` (`user_id`),
  KEY `retentions_establishment_id_foreign` (`establishment_id`),
  KEY `retentions_soap_type_id_foreign` (`soap_type_id`),
  KEY `retentions_state_type_id_foreign` (`state_type_id`),
  KEY `retentions_document_type_id_foreign` (`document_type_id`),
  KEY `retentions_supplier_id_foreign` (`supplier_id`),
  KEY `retentions_retention_type_id_foreign` (`retention_type_id`),
  KEY `retentions_currency_type_id_foreign` (`currency_type_id`),
  CONSTRAINT `retentions_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `retentions_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `retentions_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `retentions_retention_type_id_foreign` FOREIGN KEY (`retention_type_id`) REFERENCES `cat_retention_types` (`id`),
  CONSTRAINT `retentions_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `retentions_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `retentions_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `retentions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `retentions` DISABLE KEYS */;
/*!40000 ALTER TABLE `retentions` ENABLE KEYS */;
DROP TABLE IF EXISTS `sale_note_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_note_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `sale_note_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_value` decimal(16,6) NOT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `system_isc_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `percentage_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_plastic_bag_taxes` decimal(6,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(16,6) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  `additional_information` text COLLATE utf8mb4_unicode_ci,
  `inventory_kardex_id` int unsigned DEFAULT NULL,
  `warehouse_id` int unsigned DEFAULT NULL,
  `name_product_pdf` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `sale_note_items_sale_note_id_foreign` (`sale_note_id`),
  KEY `sale_note_items_item_id_foreign` (`item_id`),
  KEY `sale_note_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `sale_note_items_system_isc_type_id_foreign` (`system_isc_type_id`),
  KEY `sale_note_items_price_type_id_foreign` (`price_type_id`),
  KEY `sale_note_items_inventory_kardex_id_foreign` (`inventory_kardex_id`),
  KEY `sale_note_items_warehouse_id_foreign` (`warehouse_id`),
  CONSTRAINT `sale_note_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `sale_note_items_inventory_kardex_id_foreign` FOREIGN KEY (`inventory_kardex_id`) REFERENCES `inventory_kardex` (`id`),
  CONSTRAINT `sale_note_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `sale_note_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `sale_note_items_sale_note_id_foreign` FOREIGN KEY (`sale_note_id`) REFERENCES `sale_notes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sale_note_items_system_isc_type_id_foreign` FOREIGN KEY (`system_isc_type_id`) REFERENCES `cat_system_isc_types` (`id`),
  CONSTRAINT `sale_note_items_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `sale_note_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_note_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `sale_note_migration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_note_migration` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `sale_notes_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `success` tinyint unsigned NOT NULL DEFAULT '0',
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remote_id` int unsigned NOT NULL DEFAULT '0',
  `number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `sale_note_migration` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_note_migration` ENABLE KEYS */;
DROP TABLE IF EXISTS `sale_note_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_note_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `sale_note_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_card` tinyint(1) NOT NULL DEFAULT '0',
  `card_brand_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `change` decimal(12,2) DEFAULT NULL,
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_note_payments_sale_note_id_foreign` (`sale_note_id`),
  KEY `sale_note_payments_card_brand_id_foreign` (`card_brand_id`),
  KEY `sale_note_payments_payment_method_type_id_foreign` (`payment_method_type_id`),
  KEY `sale_note_payments_date_of_payment_index` (`date_of_payment`),
  CONSTRAINT `sale_note_payments_card_brand_id_foreign` FOREIGN KEY (`card_brand_id`) REFERENCES `card_brands` (`id`),
  CONSTRAINT `sale_note_payments_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `sale_note_payments_sale_note_id_foreign` FOREIGN KEY (`sale_note_id`) REFERENCES `sale_notes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `sale_note_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_note_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `sale_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_notes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number` int DEFAULT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `point_system` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'indica si se uso en sistema por puntos',
  `point_system_data` json DEFAULT NULL COMMENT 'datos de sistema por puntos',
  `created_from_pos` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'indica si se registro desde pos',
  `apply_concurrency` tinyint(1) NOT NULL DEFAULT '0',
  `enabled_concurrency` tinyint(1) NOT NULL DEFAULT '0',
  `automatic_date_of_issue` date DEFAULT NULL,
  `quantity_period` int DEFAULT NULL,
  `type_period` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exportation` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_isc` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_plastic_bag_taxes` decimal(6,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `dispatch_ticket_pdf` tinyint(1) NOT NULL DEFAULT '0',
  `charges` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `guides` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `perception` json DEFAULT NULL,
  `detraction` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `additional_information` text COLLATE utf8mb4_unicode_ci,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unique_filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quotation_id` int unsigned DEFAULT NULL,
  `order_note_id` int unsigned DEFAULT NULL,
  `technical_service_id` int unsigned DEFAULT NULL,
  `order_id` int unsigned DEFAULT NULL,
  `total_canceled` tinyint(1) NOT NULL DEFAULT '0',
  `changed` tinyint(1) NOT NULL DEFAULT '0',
  `paid` tinyint(1) NOT NULL DEFAULT '0',
  `license_plate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `plate_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_data` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `agent_id` int unsigned DEFAULT NULL,
  `observation` text COLLATE utf8mb4_unicode_ci,
  `purchase_order` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `document_id` int unsigned DEFAULT NULL,
  `user_rel_suscription_plan_id` int unsigned DEFAULT '0' COMMENT 'Relacion con suscripciones',
  `due_date` date DEFAULT NULL COMMENT 'Fecha de vencimiento',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `seller_id` int unsigned DEFAULT '0',
  `grade` text COLLATE utf8mb4_unicode_ci COMMENT 'Grado designado - utilizado en matricula',
  `section` text COLLATE utf8mb4_unicode_ci COMMENT 'Seccion designado - utilizado en matricula',
  `terms_condition` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sale_notes_unique_filename_unique` (`unique_filename`),
  KEY `sale_notes_user_id_foreign` (`user_id`),
  KEY `sale_notes_establishment_id_foreign` (`establishment_id`),
  KEY `sale_notes_customer_id_foreign` (`customer_id`),
  KEY `sale_notes_soap_type_id_foreign` (`soap_type_id`),
  KEY `sale_notes_state_type_id_foreign` (`state_type_id`),
  KEY `sale_notes_currency_type_id_foreign` (`currency_type_id`),
  KEY `sale_notes_quotation_id_foreign` (`quotation_id`),
  KEY `sale_notes_apply_concurrency_index` (`apply_concurrency`),
  KEY `sale_notes_type_period_index` (`type_period`),
  KEY `sale_notes_quantity_period_index` (`quantity_period`),
  KEY `sale_notes_automatic_date_of_issue_index` (`automatic_date_of_issue`),
  KEY `sale_notes_enabled_concurrency_index` (`enabled_concurrency`),
  KEY `sale_notes_order_note_id_foreign` (`order_note_id`),
  KEY `sale_notes_payment_method_type_id_foreign` (`payment_method_type_id`),
  KEY `sale_notes_order_id_foreign` (`order_id`),
  KEY `sale_notes_technical_service_id_foreign` (`technical_service_id`),
  KEY `sale_notes_agent_id_foreign` (`agent_id`),
  KEY `sale_notes_changed_index` (`changed`),
  CONSTRAINT `sale_notes_agent_id_foreign` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`),
  CONSTRAINT `sale_notes_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `sale_notes_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `sale_notes_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `sale_notes_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `sale_notes_order_note_id_foreign` FOREIGN KEY (`order_note_id`) REFERENCES `order_notes` (`id`),
  CONSTRAINT `sale_notes_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `sale_notes_quotation_id_foreign` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`),
  CONSTRAINT `sale_notes_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `sale_notes_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `sale_notes_technical_service_id_foreign` FOREIGN KEY (`technical_service_id`) REFERENCES `technical_services` (`id`),
  CONSTRAINT `sale_notes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `sale_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_notes` ENABLE KEYS */;
DROP TABLE IF EXISTS `sale_opportunities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_opportunities` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned NOT NULL,
  `establishment` json NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `exchange_rate_sale` decimal(13,3) NOT NULL,
  `total_exportation` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_free` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxed` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_unaffected` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_exonerated` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_igv` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_taxes` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `detail` text COLLATE utf8mb4_unicode_ci,
  `observation` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_opportunities_user_id_foreign` (`user_id`),
  KEY `sale_opportunities_establishment_id_foreign` (`establishment_id`),
  KEY `sale_opportunities_customer_id_foreign` (`customer_id`),
  KEY `sale_opportunities_soap_type_id_foreign` (`soap_type_id`),
  KEY `sale_opportunities_state_type_id_foreign` (`state_type_id`),
  KEY `sale_opportunities_currency_type_id_foreign` (`currency_type_id`),
  CONSTRAINT `sale_opportunities_currency_type_id_foreign` FOREIGN KEY (`currency_type_id`) REFERENCES `cat_currency_types` (`id`),
  CONSTRAINT `sale_opportunities_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `sale_opportunities_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `sale_opportunities_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `sale_opportunities_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `sale_opportunities_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `sale_opportunities` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_opportunities` ENABLE KEYS */;
DROP TABLE IF EXISTS `sale_opportunity_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_opportunity_files` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `sale_opportunity_id` int unsigned NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_opportunity_files_sale_opportunity_id_foreign` (`sale_opportunity_id`),
  CONSTRAINT `sale_opportunity_files_sale_opportunity_id_foreign` FOREIGN KEY (`sale_opportunity_id`) REFERENCES `sale_opportunities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `sale_opportunity_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_opportunity_files` ENABLE KEYS */;
DROP TABLE IF EXISTS `sale_opportunity_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_opportunity_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `sale_opportunity_id` int unsigned NOT NULL,
  `item_id` int unsigned NOT NULL,
  `item` json NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_value` decimal(16,6) NOT NULL,
  `affectation_igv_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_base_igv` decimal(12,2) NOT NULL,
  `percentage_igv` decimal(12,2) NOT NULL,
  `total_igv` decimal(12,2) NOT NULL,
  `total_taxes` decimal(12,2) NOT NULL,
  `price_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_price` decimal(16,6) NOT NULL,
  `total_value` decimal(12,2) NOT NULL,
  `total_charge` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `charges` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_opportunity_items_sale_opportunity_id_foreign` (`sale_opportunity_id`),
  KEY `sale_opportunity_items_item_id_foreign` (`item_id`),
  KEY `sale_opportunity_items_affectation_igv_type_id_foreign` (`affectation_igv_type_id`),
  KEY `sale_opportunity_items_price_type_id_foreign` (`price_type_id`),
  CONSTRAINT `sale_opportunity_items_affectation_igv_type_id_foreign` FOREIGN KEY (`affectation_igv_type_id`) REFERENCES `cat_affectation_igv_types` (`id`),
  CONSTRAINT `sale_opportunity_items_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `sale_opportunity_items_price_type_id_foreign` FOREIGN KEY (`price_type_id`) REFERENCES `cat_price_types` (`id`),
  CONSTRAINT `sale_opportunity_items_sale_opportunity_id_foreign` FOREIGN KEY (`sale_opportunity_id`) REFERENCES `sale_opportunities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `sale_opportunity_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_opportunity_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `series` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `establishment_id` int unsigned NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contingency` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `series_establishment_id_foreign` (`establishment_id`),
  KEY `series_document_type_id_foreign` (`document_type_id`),
  CONSTRAINT `series_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `series_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `series` DISABLE KEYS */;
/*!40000 ALTER TABLE `series` ENABLE KEYS */;
DROP TABLE IF EXISTS `series_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `series_configurations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `series_id` int unsigned NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `series_configurations_series_id_foreign` (`series_id`),
  KEY `series_configurations_series_index` (`series`),
  KEY `series_configurations_number_index` (`number`),
  KEY `series_configurations_document_type_id_foreign` (`document_type_id`),
  CONSTRAINT `series_configurations_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `series_configurations_series_id_foreign` FOREIGN KEY (`series_id`) REFERENCES `series` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `series_configurations` DISABLE KEYS */;
/*!40000 ALTER TABLE `series_configurations` ENABLE KEYS */;
DROP TABLE IF EXISTS `skins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skins` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `skins` DISABLE KEYS */;
INSERT INTO `skins` VALUES (1,'Default','default.css',1,NULL,NULL),(2,'Light','light.css',1,NULL,NULL);
/*!40000 ALTER TABLE `skins` ENABLE KEYS */;
DROP TABLE IF EXISTS `soap_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soap_types` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `soap_types` DISABLE KEYS */;
INSERT INTO `soap_types` VALUES ('01','Demo'),('02','Producción'),('03','Interno');
/*!40000 ALTER TABLE `soap_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `sri_formas_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sri_formas_pago` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `sri_formas_pago` DISABLE KEYS */;
INSERT INTO `sri_formas_pago` VALUES (1,'01','SIN UTILIZACION DEL SISTEMA FINANCIERO'),(2,'15','COMPENSACIÓN DE DEUDAS'),(3,'16','TARJETA DE DÉBITO'),(4,'17','DINERO ELECTRÓNICO'),(5,'18','TARJETA PREPAGO'),(6,'19','TARJETA DE CRÉDITO'),(7,'20','OTROS CON UTILIZACIÓN DEL SISTEMA FINANCIERO'),(8,'21','ENDOSO DE TÍTULOS');
/*!40000 ALTER TABLE `sri_formas_pago` ENABLE KEYS */;
DROP TABLE IF EXISTS `state_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `state_types` (
  `id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `state_types` DISABLE KEYS */;
INSERT INTO `state_types` VALUES ('01','Registrado'),('03','Enviado'),('05','Autorizado'),('07','Recibido'),('09','No Autorizado'),('11','Anulado'),('13','Por anular'),('30','Devuelto'),('31','Rechazado');
/*!40000 ALTER TABLE `state_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `status_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_orders` (
  `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `status_orders` DISABLE KEYS */;
INSERT INTO `status_orders` VALUES (1,'Pago sin verificar','2026-07-26 19:37:52',NULL),(2,'Pago verificado','2026-07-26 19:37:52',NULL),(3,'Despachado','2026-07-26 19:37:52',NULL),(4,'Confirmado por el cliente','2026-07-26 19:37:52',NULL);
/*!40000 ALTER TABLE `status_orders` ENABLE KEYS */;
DROP TABLE IF EXISTS `summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `summaries` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary_status_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubl_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `date_of_reference` date NOT NULL,
  `identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unique_filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ticket` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_ticket` tinyint(1) NOT NULL DEFAULT '0',
  `has_cdr` tinyint(1) NOT NULL DEFAULT '0',
  `soap_shipping_response` json DEFAULT NULL,
  `send_to_pse` tinyint(1) NOT NULL DEFAULT '0',
  `response_signature_pse` json DEFAULT NULL,
  `response_send_cdr_pse` json DEFAULT NULL,
  `unknown_error_status_response` tinyint(1) NOT NULL DEFAULT '0',
  `manually_regularized` tinyint(1) NOT NULL DEFAULT '0',
  `error_manually_regularized` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `summaries_unique_filename_unique` (`unique_filename`),
  KEY `summaries_user_id_foreign` (`user_id`),
  KEY `summaries_soap_type_id_foreign` (`soap_type_id`),
  KEY `summaries_state_type_id_foreign` (`state_type_id`),
  KEY `summaries_summary_status_type_id_foreign` (`summary_status_type_id`),
  KEY `summaries_date_of_issue_index` (`date_of_issue`),
  CONSTRAINT `summaries_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `summaries_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `summaries_summary_status_type_id_foreign` FOREIGN KEY (`summary_status_type_id`) REFERENCES `cat_summary_status_types` (`id`),
  CONSTRAINT `summaries_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `summaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `summaries` ENABLE KEYS */;
DROP TABLE IF EXISTS `summary_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `summary_documents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `summary_id` int unsigned NOT NULL,
  `document_id` int unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `summary_documents_summary_id_foreign` (`summary_id`),
  KEY `summary_documents_document_id_foreign` (`document_id`),
  CONSTRAINT `summary_documents_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`),
  CONSTRAINT `summary_documents_summary_id_foreign` FOREIGN KEY (`summary_id`) REFERENCES `summaries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `summary_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `summary_documents` ENABLE KEYS */;
DROP TABLE IF EXISTS `suscription_grade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suscription_grade` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `suscription_grade` DISABLE KEYS */;
INSERT INTO `suscription_grade` VALUES (1,'1er'),(2,'2do'),(3,'3ro'),(4,'4to'),(5,'5to'),(6,'6to'),(7,'7mo'),(8,'8vo');
/*!40000 ALTER TABLE `suscription_grade` ENABLE KEYS */;
DROP TABLE IF EXISTS `suscription_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suscription_plans` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cat_period_id` int unsigned DEFAULT '0' COMMENT 'Relacion con el periodo de tiempo',
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del plan',
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Descripcion del plan',
  `total` float DEFAULT '0' COMMENT 'El total del costo del plan',
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_method_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity_period` int unsigned DEFAULT NULL,
  `exchange_rate_sale` float DEFAULT '0',
  `total_prepayment` float DEFAULT '0',
  `total_charge` float DEFAULT '0',
  `total_discount` float DEFAULT '0',
  `total_exportation` float DEFAULT '0',
  `total_free` float DEFAULT '0',
  `total_taxed` float DEFAULT '0',
  `total_unaffected` float DEFAULT '0',
  `total_exonerated` float DEFAULT '0',
  `total_igv` float DEFAULT '0',
  `total_igv_free` float DEFAULT '0',
  `total_base_isc` float DEFAULT '0',
  `total_isc` float DEFAULT '0',
  `total_base_other_taxes` float DEFAULT '0',
  `total_other_taxes` float DEFAULT '0',
  `total_taxes` float DEFAULT '0',
  `total_value` float DEFAULT '0',
  `charges` json DEFAULT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `perception` json DEFAULT NULL,
  `detraction` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `terms_condition` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `suscription_plans` DISABLE KEYS */;
INSERT INTO `suscription_plans` VALUES (1,1,'Matricula Escolar','Demostración de matricula escolar',1,'PEN','01',12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `suscription_plans` ENABLE KEYS */;
DROP TABLE IF EXISTS `suscription_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suscription_section` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `suscription_section` DISABLE KEYS */;
INSERT INTO `suscription_section` VALUES (1,'A'),(2,'B'),(3,'C'),(4,'D'),(5,'E'),(6,'F'),(7,'G'),(8,'H');
/*!40000 ALTER TABLE `suscription_section` ENABLE KEYS */;
DROP TABLE IF EXISTS `system_activity_log_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_activity_log_types` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `system_activity_log_types` DISABLE KEYS */;
INSERT INTO `system_activity_log_types` VALUES ('companies_certificate','Actualización del campo certificado en configuración de empresa'),('companies_name','Actualización del campo nombre en configuración de empresa'),('companies_number','Actualización del campo número en configuración de empresa'),('companies_soap_password','Actualización del campo SOAP Contraseña en configuración de empresa'),('companies_soap_send_id','Actualización del campo SOAP envío en configuración de empresa'),('companies_soap_type_id','Actualización del campo SOAP tipo en configuración de empresa'),('companies_soap_url','Actualización del campo SOAP url envío en configuración de empresa'),('companies_soap_username','Actualización del campo SOAP Usuario en configuración de empresa'),('failed','Error de inicio de sesión'),('level_module_access_error','Error de acceso al submódulo (no tiene permiso)'),('login','Iniciar sesión'),('login_lockout','Bloqueo de usuario por exceder límite de intentos permitidos al iniciar sesión'),('logout','Cerrar sesión'),('module_access_error','Error de acceso al módulo (no tiene permiso)');
/*!40000 ALTER TABLE `system_activity_log_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `system_activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_activity_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `system_activity_log_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `origin_id` int DEFAULT NULL,
  `origin_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `platform_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `platform_version` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `browser_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `browser_version` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_index` (`origin_id`,`origin_type`),
  KEY `system_activity_logs_user_id_foreign` (`user_id`),
  KEY `system_activity_logs_auth_transaction_type_index` (`system_activity_log_type_id`),
  KEY `system_activity_logs_date_index` (`date`),
  KEY `system_activity_logs_time_index` (`time`),
  KEY `system_activity_logs_device_type_index` (`device_type`),
  CONSTRAINT `system_activity_logs_system_activity_log_type_id_foreign` FOREIGN KEY (`system_activity_log_type_id`) REFERENCES `system_activity_log_types` (`id`),
  CONSTRAINT `system_activity_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `system_activity_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_activity_logs` ENABLE KEYS */;
DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `class` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `execution_time` time NOT NULL,
  `output` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
DROP TABLE IF EXISTS `technical_service_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technical_service_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `technical_services_id` int unsigned DEFAULT '0' COMMENT 'Id de technical_services',
  `item_id` int unsigned DEFAULT '0' COMMENT 'Id de item',
  `item` json DEFAULT NULL COMMENT 'Json con el contenido de item',
  `quantity` float DEFAULT '0' COMMENT 'Cantidad de item usado',
  `unit_value` float DEFAULT '0' COMMENT 'unit_value',
  `affectation_igv_type_id` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Tipo de afectacion dde igv. cat_affectation_igv_types',
  `total_base_igv` float DEFAULT '0' COMMENT 'Monto base del IGV',
  `percentage_igv` float DEFAULT '0',
  `total_igv` float DEFAULT '0',
  `system_isc_type_id` longtext COLLATE utf8mb4_unicode_ci,
  `total_base_isc` float DEFAULT '0',
  `percentage_isc` float DEFAULT '0',
  `total_isc` float DEFAULT '0',
  `total_base_other_taxes` float DEFAULT '0',
  `percentage_other_taxes` float DEFAULT '0',
  `total_other_taxes` float DEFAULT '0',
  `total_plastic_bag_taxes` float DEFAULT '0',
  `total_taxes` float DEFAULT '0',
  `price_type_id` longtext COLLATE utf8mb4_unicode_ci,
  `unit_price` float DEFAULT '0',
  `total_value` float DEFAULT '0',
  `total_charge` float DEFAULT '0',
  `total_discount` float DEFAULT '0',
  `total` float DEFAULT '0',
  `attributes` json DEFAULT NULL COMMENT 'Atributos',
  `discounts` json DEFAULT NULL COMMENT 'Descuentos',
  `charges` json DEFAULT NULL COMMENT 'Cargos',
  `additional_information` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Informacion adicional',
  `warehouse_id` int unsigned DEFAULT '0' COMMENT 'Id de item',
  `name_product_pdf` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Nombre de producto en el pdf',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `technical_service_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `technical_service_items` ENABLE KEYS */;
DROP TABLE IF EXISTS `technical_service_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technical_service_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `technical_service_id` int unsigned NOT NULL,
  `date_of_payment` date NOT NULL,
  `payment_method_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `change` decimal(12,2) NOT NULL DEFAULT '0.00',
  `payment` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `technical_service_payments_technical_service_id_foreign` (`technical_service_id`),
  KEY `technical_service_payments_payment_method_type_id_foreign` (`payment_method_type_id`),
  CONSTRAINT `technical_service_payments_payment_method_type_id_foreign` FOREIGN KEY (`payment_method_type_id`) REFERENCES `payment_method_types` (`id`),
  CONSTRAINT `technical_service_payments_technical_service_id_foreign` FOREIGN KEY (`technical_service_id`) REFERENCES `technical_services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `technical_service_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `technical_service_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `technical_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technical_services` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `establishment_id` int unsigned DEFAULT '0',
  `establishment` json DEFAULT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer` json NOT NULL,
  `currency_type_id` text COLLATE utf8mb4_unicode_ci,
  `payment_condition_id` text COLLATE utf8mb4_unicode_ci,
  `payment_method_type_id` text COLLATE utf8mb4_unicode_ci,
  `seller_id` int unsigned DEFAULT '0',
  `exchange_rate_sale` decimal(13,3) DEFAULT '0.000',
  `total_prepayment` decimal(12,2) DEFAULT '0.00',
  `total_charge` decimal(12,2) DEFAULT '0.00',
  `total_discount` decimal(12,2) DEFAULT '0.00',
  `total_exportation` decimal(12,2) DEFAULT '0.00',
  `total_free` decimal(12,2) DEFAULT '0.00',
  `total_taxed` decimal(12,2) DEFAULT '0.00',
  `total_unaffected` decimal(12,2) DEFAULT '0.00',
  `total_exonerated` decimal(12,2) DEFAULT '0.00',
  `total_igv` decimal(12,2) DEFAULT '0.00',
  `total_igv_free` decimal(12,2) DEFAULT '0.00',
  `total_base_isc` decimal(12,2) DEFAULT '0.00',
  `total_isc` decimal(12,2) DEFAULT '0.00',
  `total_base_other_taxes` decimal(12,2) DEFAULT '0.00',
  `total_other_taxes` decimal(12,2) DEFAULT '0.00',
  `total_plastic_bag_taxes` decimal(6,2) DEFAULT '0.00',
  `total_taxes` decimal(12,2) DEFAULT '0.00',
  `total_value` decimal(12,2) DEFAULT '0.00',
  `subtotal` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) DEFAULT '0.00',
  `is_editable` tinyint unsigned DEFAULT '0',
  `cellphone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `time_of_issue` time NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `serial_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `prepayment` decimal(12,2) NOT NULL DEFAULT '0.00',
  `activities` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `brand` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `equipment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `important_note` text COLLATE utf8mb4_unicode_ci,
  `repair` tinyint(1) NOT NULL DEFAULT '0',
  `warranty` tinyint(1) NOT NULL DEFAULT '0',
  `maintenance` tinyint(1) NOT NULL DEFAULT '0',
  `diagnosis` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `technical_services_user_id_foreign` (`user_id`),
  KEY `technical_services_soap_type_id_foreign` (`soap_type_id`),
  KEY `technical_services_customer_id_foreign` (`customer_id`),
  KEY `technical_services_date_of_issue_index` (`date_of_issue`),
  KEY `technical_services_serial_number_index` (`serial_number`),
  CONSTRAINT `technical_services_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `technical_services_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `technical_services_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `technical_services` DISABLE KEYS */;
/*!40000 ALTER TABLE `technical_services` ENABLE KEYS */;
DROP TABLE IF EXISTS `tips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tips` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL COMMENT 'Fecha de registro',
  `origin_date_of_issue` date NOT NULL COMMENT 'Fecha del documento origen de la propina',
  `origin_id` int NOT NULL,
  `origin_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `worker_full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `origin_index` (`origin_id`,`origin_type`),
  KEY `tips_soap_type_id_foreign` (`soap_type_id`),
  KEY `tips_date_index` (`date`),
  KEY `tips_origin_date_of_issue_index` (`origin_date_of_issue`),
  KEY `tips_worker_full_name_index` (`worker_full_name`),
  CONSTRAINT `tips_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `tips` DISABLE KEYS */;
/*!40000 ALTER TABLE `tips` ENABLE KEYS */;
DROP TABLE IF EXISTS `track_api_peru_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track_api_peru_services` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `service` int unsigned DEFAULT '0' COMMENT 'Tipo de servicio  1 => sunat/dni, 2 => validacion_multiple_cpe, 3 => CPE, 4 => tipo_de_cambio, 5 => printer_ticket',
  `date_of_issue` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `track_api_peru_services` DISABLE KEYS */;
/*!40000 ALTER TABLE `track_api_peru_services` ENABLE KEYS */;
DROP TABLE IF EXISTS `transaction_queries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_queries` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `response` json NOT NULL,
  `transaction_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transaction_queries_transaction_id_foreign` (`transaction_id`),
  CONSTRAINT `transaction_queries_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `transaction_queries` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_queries` ENABLE KEYS */;
DROP TABLE IF EXISTS `transaction_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_states` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `success` tinyint(1) NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_detail` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `transaction_states_name_index` (`name`),
  KEY `transaction_states_success_index` (`success`),
  KEY `transaction_states_status_index` (`status`),
  KEY `transaction_states_status_detail_index` (`status_detail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `transaction_states` DISABLE KEYS */;
INSERT INTO `transaction_states` VALUES ('00','Rechazado (Error desconocido)',0,'other','other','Error desconocido','Lo sentimos, ocurrió un error inesperado.'),('01','Aceptado',1,'approved','accredited','¡Listo! Se acreditó tu pago. En tu resumen verás el cargo de amount como statement_descriptor.','¡Listo! Se acreditó tu pago. En tu resumen verás el cargo del pago.'),('02','En proceso',1,'in_process','pending_contingency','Estamos procesando tu pago. No te preocupes, menos de 2 días hábiles te avisaremos por e-mail si se acreditó.','Estamos procesando tu pago. No te preocupes, en menos de 2 días hábiles te avisaremos por e-mail si se acreditó.'),('03','En proceso',1,'in_process','pending_review_manual','Estamos procesando tu pago. No te preocupes, menos de 2 días hábiles te avisaremos por e-mail si se acreditó o si necesitamos más información.','Estamos procesando tu pago. No te preocupes, en menos de 2 días hábiles te avisaremos por e-mail si se acreditó o si necesitamos más información.'),('04','Rechazado',0,'rejected','cc_rejected_bad_filled_card_number','Revisa el número de tarjeta.','Lo sentimos, ocurrió un inconveniente. Revisa el número de tarjeta.'),('05','Rechazado',0,'rejected','cc_rejected_bad_filled_date','Revisa la fecha de vencimiento.','Lo sentimos, ocurrió un inconveniente. Revisa la fecha de vencimiento.'),('06','Rechazado',0,'rejected','cc_rejected_bad_filled_other','Revisa los datos.','Lo sentimos, ocurrió un inconveniente. Revisa los datos.'),('07','Rechazado',0,'rejected','cc_rejected_bad_filled_security_code','Revisa el código de seguridad de la tarjeta.','Lo sentimos, ocurrió un inconveniente. Revisa el código de seguridad de la tarjeta.'),('08','Rechazado',0,'rejected','cc_rejected_blacklist','No pudimos procesar tu pago.','Lo sentimos, ocurrió un inconveniente. No pudimos procesar tu pago.'),('09','Rechazado',0,'rejected','cc_rejected_call_for_authorize','Debes autorizar ante payment_method_id el pago de amount.','Debes autorizar ante el medio de pago, el pago a realizar.'),('10','Rechazado',0,'rejected','cc_rejected_card_disabled','Llama a payment_method_id para activar tu tarjeta o usa otro medio de pago. El teléfono está al dorso de tu tarjeta.','Llama a la entidad para activar tu tarjeta o usa otro medio de pago. El teléfono está al dorso de tu tarjeta.'),('11','Rechazado',0,'rejected','cc_rejected_card_error','No pudimos procesar tu pago.','Lo sentimos, ocurrió un inconveniente. No pudimos procesar tu pago.'),('12','Rechazado',0,'rejected','cc_rejected_duplicated_payment','Ya hiciste un pago por ese valor. Si necesitas volver a pagar usa otra tarjeta u otro medio de pago.','Ya hiciste un pago por ese valor. Si necesitas volver a pagar usa otra tarjeta u otro medio de pago.'),('13','Rechazado',0,'rejected','cc_rejected_high_risk','Tu pago fue rechazado. Elige otro de los medios de pago, te recomendamos con medios en efectivo.','Tu pago fue rechazado. Elige otro de los medios de pago, te recomendamos con medios en efectivo.'),('14','Rechazado',0,'rejected','cc_rejected_insufficient_amount','Tu payment_method_id no tiene fondos suficientes.','Lo sentimos, ocurrió un inconveniente. Tu medio de pago no tiene fondos suficientes.'),('15','Rechazado',0,'rejected','cc_rejected_invalid_installments','payment_method_id no procesa pagos en installments cuotas.','Para el medio de pago ingresado, no se puede procesar los pagos en la cantidad de cuotas seleccionadas.'),('16','Rechazado',0,'rejected','cc_rejected_max_attempts','Llegaste al límite de intentos permitidos. Elige otra tarjeta u otro medio de pago.','Llegaste al límite de intentos permitidos. Elige otra tarjeta u otro medio de pago.'),('17','Rechazado',0,'rejected','cc_rejected_other_reason','payment_method_id no procesó el pago.','Lo sentimos, ocurrió un inconveniente. El pago no pudo ser procesado por el medio usado');
/*!40000 ALTER TABLE `transaction_states` ENABLE KEYS */;
DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `payment_link_id` int unsigned NOT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `uuid` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(16,2) NOT NULL,
  `transaction_state_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transactions_uuid_unique` (`uuid`),
  KEY `transactions_payment_link_id_foreign` (`payment_link_id`),
  KEY `transactions_transaction_state_id_foreign` (`transaction_state_id`),
  KEY `transactions_date_index` (`date`),
  KEY `transactions_time_index` (`time`),
  KEY `transactions_description_index` (`description`),
  KEY `transactions_payment_id_index` (`payment_id`),
  KEY `transactions_amount_index` (`amount`),
  KEY `transactions_soap_type_id_foreign` (`soap_type_id`),
  CONSTRAINT `transactions_payment_link_id_foreign` FOREIGN KEY (`payment_link_id`) REFERENCES `payment_links` (`id`),
  CONSTRAINT `transactions_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `transactions_transaction_state_id_foreign` FOREIGN KEY (`transaction_state_id`) REFERENCES `transaction_states` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
DROP TABLE IF EXISTS `transfer_account_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transfer_account_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `origin_id` int unsigned DEFAULT '0' COMMENT 'id Cuenta de origen',
  `origin_type` text COLLATE utf8mb4_unicode_ci COMMENT 'Modelo de origen',
  `destiny_id` int unsigned DEFAULT '0' COMMENT 'id Cuenta de destino',
  `destiny_type` text COLLATE utf8mb4_unicode_ci COMMENT 'Modelo de destino',
  `amount` decimal(9,2) DEFAULT '0.00' COMMENT 'Monto a transferir',
  `date_of_movement` datetime DEFAULT NULL COMMENT 'Fecha de movimiento',
  `user_id` int unsigned DEFAULT '0' COMMENT 'Usuario que realiza el movimiento',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `transfer_account_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfer_account_payments` ENABLE KEYS */;
DROP TABLE IF EXISTS `user_commissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_commissions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_commissions_user_id_foreign` (`user_id`),
  CONSTRAINT `user_commissions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `user_commissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_commissions` ENABLE KEYS */;
DROP TABLE IF EXISTS `user_default_document_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_default_document_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `series_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_default_document_types_user_id_foreign` (`user_id`),
  KEY `user_default_document_types_document_type_id_foreign` (`document_type_id`),
  KEY `user_default_document_types_series_id_foreign` (`series_id`),
  CONSTRAINT `user_default_document_types_document_type_id_foreign` FOREIGN KEY (`document_type_id`) REFERENCES `cat_document_types` (`id`),
  CONSTRAINT `user_default_document_types_series_id_foreign` FOREIGN KEY (`series_id`) REFERENCES `series` (`id`),
  CONSTRAINT `user_default_document_types_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `user_default_document_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_default_document_types` ENABLE KEYS */;
DROP TABLE IF EXISTS `user_rel_suscription_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_rel_suscription_plans` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT '0' COMMENT 'Relacion con usuario',
  `suscription_plan_id` int unsigned DEFAULT '0' COMMENT 'Relacion con planes de suscripcion',
  `cat_period_id` int unsigned DEFAULT '0' COMMENT 'Relacion con el periodo de tiempo',
  `items` json NOT NULL COMMENT 'Pega los items relacionados a modo de standar',
  `editable` tinyint NOT NULL DEFAULT '0' COMMENT 'Si ya ha sido adquirido, no puede ser modificado',
  `deletable` tinyint NOT NULL DEFAULT '0' COMMENT 'Si ya ha sido adquirido, no puede ser borrado',
  `start_date` date DEFAULT NULL COMMENT 'Fecha de inicio',
  `sale_notes` text COLLATE utf8mb4_unicode_ci,
  `documents` text COLLATE utf8mb4_unicode_ci,
  `dates_of_documents` text COLLATE utf8mb4_unicode_ci,
  `automatic_date_of_issue` date DEFAULT NULL,
  `customer_id` int unsigned DEFAULT '0',
  `customer` json NOT NULL,
  `parent_customer_id` int unsigned DEFAULT '0',
  `parent_customer` json NOT NULL,
  `children_customer_id` int unsigned DEFAULT '0',
  `children_customer` longtext COLLATE utf8mb4_unicode_ci,
  `quantity_period` int unsigned DEFAULT '0',
  `apply_concurrency` int unsigned NOT NULL DEFAULT '0',
  `enabled_concurrency` int unsigned NOT NULL DEFAULT '1' COMMENT 'Se pasará a nota de ventas como activo',
  `currency_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_method_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exchange_rate_sale` float DEFAULT '0',
  `total_prepayment` float DEFAULT '0',
  `total_charge` float DEFAULT '0',
  `total_discount` float DEFAULT '0',
  `total_exportation` float DEFAULT '0',
  `total_free` float DEFAULT '0',
  `total_taxed` float DEFAULT '0',
  `total_unaffected` float DEFAULT '0',
  `total_exonerated` float DEFAULT '0',
  `total_igv` float DEFAULT '0',
  `total_igv_free` float DEFAULT '0',
  `total_base_isc` float DEFAULT '0',
  `total_isc` float DEFAULT '0',
  `total_base_other_taxes` float DEFAULT '0',
  `total_other_taxes` float DEFAULT '0',
  `total_taxes` float DEFAULT '0',
  `total_value` float DEFAULT '0',
  `total` decimal(12,2) DEFAULT '0.00',
  `charges` json DEFAULT NULL,
  `attributes` json DEFAULT NULL,
  `discounts` json DEFAULT NULL,
  `prepayments` json DEFAULT NULL,
  `related` json DEFAULT NULL,
  `perception` json DEFAULT NULL,
  `detraction` json DEFAULT NULL,
  `legends` json DEFAULT NULL,
  `terms_condition` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `grade` text COLLATE utf8mb4_unicode_ci COMMENT 'Grado designado - utilizado en matricula',
  `section` text COLLATE utf8mb4_unicode_ci COMMENT 'Seccion designado - utilizado en matricula',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `user_rel_suscription_plans` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_rel_suscription_plans` ENABLE KEYS */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `api_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `establishment_id` int unsigned DEFAULT NULL,
  `type` enum('admin','seller','integrator','client') COLLATE utf8mb4_unicode_ci NOT NULL,
  `permission_force_send_by_summary` tinyint(1) NOT NULL DEFAULT '0',
  `permission_edit_cpe` tinyint(1) NOT NULL DEFAULT '0',
  `create_payment` tinyint(1) NOT NULL DEFAULT '1',
  `delete_purchase` tinyint(1) NOT NULL DEFAULT '1',
  `annular_purchase` tinyint(1) NOT NULL DEFAULT '1',
  `edit_purchase` tinyint(1) NOT NULL DEFAULT '1',
  `delete_payment` tinyint(1) NOT NULL DEFAULT '1',
  `recreate_documents` tinyint(1) NOT NULL DEFAULT '0',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `multiple_default_document_types` tinyint(1) NOT NULL DEFAULT '0',
  `photo_filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contract_date` date DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `corporate_cell_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `personal_cell_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `corporate_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `personal_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_names` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `names` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `identity_document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_password_update` datetime DEFAULT NULL,
  `restaurant_role_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `document_id` char(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Relacion con tipo de documentos',
  `series_id` int unsigned DEFAULT NULL COMMENT 'Relacion con series',
  `zone_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_api_token_unique` (`api_token`),
  KEY `users_establishment_id_foreign` (`establishment_id`),
  KEY `users_restaurant_role_id_foreign` (`restaurant_role_id`),
  CONSTRAINT `users_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`),
  CONSTRAINT `users_restaurant_role_id_foreign` FOREIGN KEY (`restaurant_role_id`) REFERENCES `restaurant_roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
DROP TABLE IF EXISTS `voided`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voided` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `external_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clave_SRI` json DEFAULT NULL,
  `soap_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_type_id` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubl_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_issue` date NOT NULL,
  `date_of_reference` date NOT NULL,
  `identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ticket` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_ticket` tinyint(1) NOT NULL DEFAULT '0',
  `has_cdr` tinyint(1) NOT NULL DEFAULT '0',
  `soap_shipping_response` json DEFAULT NULL,
  `send_to_pse` tinyint(1) NOT NULL DEFAULT '0',
  `response_signature_pse` json DEFAULT NULL,
  `response_send_cdr_pse` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `voided_user_id_foreign` (`user_id`),
  KEY `voided_soap_type_id_foreign` (`soap_type_id`),
  KEY `voided_state_type_id_foreign` (`state_type_id`),
  CONSTRAINT `voided_soap_type_id_foreign` FOREIGN KEY (`soap_type_id`) REFERENCES `soap_types` (`id`),
  CONSTRAINT `voided_state_type_id_foreign` FOREIGN KEY (`state_type_id`) REFERENCES `state_types` (`id`),
  CONSTRAINT `voided_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `voided` DISABLE KEYS */;
/*!40000 ALTER TABLE `voided` ENABLE KEYS */;
DROP TABLE IF EXISTS `voided_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voided_documents` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `voided_id` int unsigned NOT NULL,
  `document_id` int unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `voided_documents_voided_id_foreign` (`voided_id`),
  KEY `voided_documents_document_id_foreign` (`document_id`),
  CONSTRAINT `voided_documents_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`),
  CONSTRAINT `voided_documents_voided_id_foreign` FOREIGN KEY (`voided_id`) REFERENCES `voided` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `voided_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `voided_documents` ENABLE KEYS */;
DROP TABLE IF EXISTS `waiters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `waiters` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `waiters` DISABLE KEYS */;
/*!40000 ALTER TABLE `waiters` ENABLE KEYS */;
DROP TABLE IF EXISTS `warehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `establishment_id` int unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `warehouses_establishment_id_foreign` (`establishment_id`),
  CONSTRAINT `warehouses_establishment_id_foreign` FOREIGN KEY (`establishment_id`) REFERENCES `establishments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `warehouses` DISABLE KEYS */;
/*!40000 ALTER TABLE `warehouses` ENABLE KEYS */;
DROP TABLE IF EXISTS `web_platforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `web_platforms` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `web_platforms` DISABLE KEYS */;
INSERT INTO `web_platforms` VALUES (1,'Saga Falabella',NULL,NULL),(2,'Mercado Libre ',NULL,NULL),(3,'Linio',NULL,NULL);
/*!40000 ALTER TABLE `web_platforms` ENABLE KEYS */;
DROP TABLE IF EXISTS `workers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `identity_document_type_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date NOT NULL,
  `admission_date` date NOT NULL,
  `occupation` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workers_identity_document_type_id_foreign` (`identity_document_type_id`),
  KEY `workers_number_index` (`number`),
  KEY `workers_name_index` (`name`),
  CONSTRAINT `workers_identity_document_type_id_foreign` FOREIGN KEY (`identity_document_type_id`) REFERENCES `cat_identity_document_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `workers` DISABLE KEYS */;
/*!40000 ALTER TABLE `workers` ENABLE KEYS */;
DROP TABLE IF EXISTS `zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zones` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `zones` DISABLE KEYS */;
/*!40000 ALTER TABLE `zones` ENABLE KEYS */;
/*!50003 DROP PROCEDURE IF EXISTS `SP_REPROCESAR_DOCUMENTOS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`facturador`@`%` PROCEDURE `SP_REPROCESAR_DOCUMENTOS`()
BEGIN
            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '01', fpagos = REPLACE(fPagos,'unidadtiempo": ""','unidadtiempo": "DIAS"')  
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%unidadTiempo%' 
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '07' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%CLAVE ACCESO REGISTRADA%'  
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '07' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%CLAVE DE ACCESO EN PROCESAMIENTO%'  
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '07' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%DOCUMENTO AUTORIZADO POR EL SRI%'  
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '07' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%DOCUMENTO RECIBIDO POR EL SRI%'  
                AND IdEstado = '30';

            UPDATE cabecera_documento_electronicas 
                SET IdEstado = '01' 
                WHERE fecha >= '2025-01-01' 
                AND responseRegularizeShipping LIKE '%NO SE PUDO VALIDAR EL DOCUMENTO EN EL SRI%'  
                AND IdEstado = '30';
            END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

