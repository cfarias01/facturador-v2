<?php

namespace App\Http\ViewComposers\Tenant;

use App\Http\Resources\Tenant\ConfigurationResource;
use App\Models\Tenant\Configuration;

class ConfigurationVisualViewComposer
{
    /** Temas disponibles en Configuración > Visual (public/css/sia-tenant.css). */
    const SIA_THEMES = ['sia', 'oceano', 'violeta', 'medianoche', 'vino', 'claro'];

    /** Valores guardados con los temas antiguos de Porto. */
    const LEGACY_THEMES = [
        'white' => 'claro',
        'blue' => 'violeta',
        'green' => 'sia',
        'red' => 'vino',
        'dark' => 'medianoche',
        'gray' => 'sia',
        'warning' => 'sia',
        'ligth-blue' => 'oceano',
    ];

    public static function siaTheme($sidebarTheme)
    {
        $theme = self::LEGACY_THEMES[$sidebarTheme] ?? $sidebarTheme;

        return in_array($theme, self::SIA_THEMES) ? $theme : 'sia';
    }

    public function compose($view)
    {
        $configuration = Configuration::first();
        if(is_null($configuration->visual)) {
            $defaults = [
                'bg' => 'light',
                'header' => 'light',
                'sidebars' => 'light',
            ];
            $configuration->visual = $defaults;
            $configuration->save();
        }
        $configuration = Configuration::first();
        $record = new ConfigurationResource($configuration);
        $view->visual = $record->visual;
        $view->siaTheme = self::siaTheme($record->visual->sidebar_theme ?? null);
    }
}
