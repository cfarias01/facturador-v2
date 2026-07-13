<?php

namespace App\Console\Commands;

use App\Models\Tenant\Company;
use App\Models\Tenant\Configuration;
use App\Services\TelegramService;
use Illuminate\Console\Command;

class NotificacionesTelegram extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'telegram:send';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Este comando envia las notificaicones a Telegram';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        if (Configuration::firstOrFail()->cron) {

            $company = Company::active();
            $service = new TelegramService();

            if($company->active_icg){

                $this->info('EMPRESA : '.$company->name);
                
                try {

                    $documents = $service->sendNotificationToBot2($company,-1003763801201);
                    $documents = $service->sendNotificationToBot($company,-1003763801201);
                }
                catch (\Exception $e) {

                    $this->info('ERROR: '.$e->getMessage());
                }
                
            }         
        }
        else {
            $this->info('The crontab is disabled');
        }

        $this->info('Notificación de sistema enviada');
    }
}
