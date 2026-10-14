<?php

namespace App\Console;

use Illuminate\Foundation\Console\Kernel as ConsoleKernel;
use Illuminate\Console\Scheduling\Schedule;

class Kernel extends ConsoleKernel
{
    /**
     * The Artisan commands provided by your application.
     *
     * @var array
     */
    protected $commands = [
        //
    ];

    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule) {

        $schedule->command('tenants:run icg:get')->everyMinute()->withoutOverlapping();
        $schedule->command('tenants:run sri:see')->everyMinute()->withoutOverlapping();
        $schedule->command('tenants:run sri:send')->everyMinute()->withoutOverlapping();
        $schedule->command('tenants:run sri:email')->everyFiveMinutes()->withoutOverlapping();
        $schedule->command('tenants:run sri:returned')->everyFiveMinutes()->withoutOverlapping();
        $schedule->command('tenants:run icg:failed')->everyFourHours()->withoutOverlapping();
        $schedule->command('tenants:run icg:returned')->everyFourHours()->withoutOverlapping();
        $schedule->command('tenants:run telegram:send')->everyTwoHours()->withoutOverlapping();

    }
    /**
     * Register the commands for the application.
     *
     * @return void
     */
    protected function commands() {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
