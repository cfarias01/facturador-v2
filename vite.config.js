import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue2 from '@vitejs/plugin-vue2';
import path from 'path';

export default defineConfig(({ mode }) => ({
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
        // IMPORTANTE: se usa la forma array {find, replacement} y no el atajo
        // objeto {'clave$': ...}. Con Vite 5.4.21 el sufijo "$" (exact match)
        // en la forma objeto NO redirige correctamente los imports "vue"/
        // "jquery" (se comprobo en la practica: el bundle resultante seguia
        // sin el codigo esperado pese a que la config se leia bien) — la
        // forma array con RegExp si funciona de manera confiable.
        alias: [
            {
                // El build por defecto de Vite usa vue.runtime (sin compilador
                // de templates). Esta app monta Vue sobre HTML ya renderizado
                // por Blade (new Vue({ el: '#main-wrapper' }) sin template/
                // render), asi que necesita compilar ese HTML existente en
                // tiempo real: hace falta el build completo, no el
                // runtime-only.
                //
                // Se apunta directo a vue.common.dev.js/vue.common.prod.js
                // (no a vue.esm.js ni al despachador vue.common.js):
                // - vue.esm.js: vue/package.json declara "sideEffects": false,
                //   y Rollup elimina por tree-shaking la asignacion
                //   "Vue.compile = compileToFunctions" (no detecta que el
                //   acceso dinamico Vue.compile en runtime la necesita).
                // - vue.common.js: es un despachador
                //   "require(NODE_ENV==='production' ? prod : dev)"; ese
                //   require condicional no se resuelve de forma fiable dentro
                //   del bundle (se comprobo que el resultado no incluia el
                //   compilador tampoco).
                // Ambos archivos .common.*.js vienen pre-minificados por Vue
                // mismo, asi que Rollup los trata como opacos y no aplica
                // tree-shaking agresivo sobre su contenido.
                find: /^vue$/,
                replacement: mode === 'production'
                    ? 'vue/dist/vue.common.prod.js'
                    : 'vue/dist/vue.common.dev.js',
            },
            {
                // jQuery ya se carga como <script> clasico (porto-light/
                // vendor/jquery/jquery.js) en los layouts, ANTES de este
                // bundle. Si cada "import $ from 'jquery'" empaquetara su
                // propia copia via npm, quedaria una instancia DISTINTA a la
                // que los plugins vendored (perfect-scrollbar, sidebarmenu,
                // datatables, select2, etc) ya tienen enganchada, y
                // $(...).miPlugin() fallaria con "is not a function". Se
                // redirige todo import de 'jquery' a la instancia global real.
                find: /^jquery$/,
                replacement: path.resolve(__dirname, 'resources/js/vendor/jquery-shim.js'),
            },
            { find: '@components', replacement: path.resolve(__dirname, 'resources/js/components') },
            { find: '@views', replacement: path.resolve(__dirname, 'resources/js/views/tenant') },
            { find: '@helpers', replacement: path.resolve(__dirname, 'resources/js/helpers') },
            { find: '@mixins', replacement: path.resolve(__dirname, 'resources/js/mixins') },
            { find: '@viewsModuleLevelAccess', replacement: path.resolve(__dirname, 'modules/LevelAccess/Resources/assets/js/views') },
        ],
    },
}));
