import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue2 from '@vitejs/plugin-vue2';
import path from 'path';

export default defineConfig({
    plugins: [
        laravel({
            input: [
                'resources/js/app.js',
                'resources/sass/style.scss',
                'resources/sass/auth.scss',
            ],
            refresh: true,
        }),
        vue2({
            // El codigo fuente no usa rutas relativas para imagenes en los
            // templates (todas son absolutas hacia public/, ej. "/logo/x.jpg"),
            // asi que se desactiva la reescritura automatica de src a imports:
            // esas rutas deben quedar literales para servirse desde public/.
            template: { transformAssetUrls: false },
        }),
    ],
    resolve: {
        // Bajo Mix/webpack, resolve.extensions incluia .vue por defecto, asi
        // que el codigo fuente importa muchos .vue sin la extension explicita.
        // Vite no incluye .vue por defecto; se agrega aca para no tener que
        // tocar cada import uno por uno.
        extensions: ['.mjs', '.js', '.mts', '.ts', '.jsx', '.tsx', '.json', '.vue'],
        alias: {
            '@components': path.resolve(__dirname, 'resources/js/components'),
            '@views': path.resolve(__dirname, 'resources/js/views/tenant'),
            '@helpers': path.resolve(__dirname, 'resources/js/helpers'),
            '@mixins': path.resolve(__dirname, 'resources/js/mixins'),
            '@viewsModuleLevelAccess': path.resolve(__dirname, 'modules/LevelAccess/Resources/assets/js/views'),
        },
    },
});
