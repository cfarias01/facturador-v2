<?php

namespace App\Providers;

use App\Models\Tenant\Document;
use App\Observers\DocumentObserver;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
	public function boot()
	{
		if (config('tenant.force_https')) {
			URL::forceScheme('https');
		}
		Document::observe(DocumentObserver::class);
	}

	public function register()
	{
		// El schema dump de tenants se carga con el cliente "mysql" vía Symfony
		// Process, que hereda el PATH del proceso PHP.
		$mysqlBin = config('database.mysql_bin_path');
		if ($mysqlBin && is_dir($mysqlBin)) {
			$path = $mysqlBin . PATH_SEPARATOR . getenv('PATH');
			putenv('PATH=' . $path);
			$_ENV['PATH'] = $_SERVER['PATH'] = $path;
		}
	}
}
