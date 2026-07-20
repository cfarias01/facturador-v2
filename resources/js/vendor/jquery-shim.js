// Reemplaza el paquete npm "jquery" en todo el bundle (ver alias en
// vite.config.js) para que TODO el codigo empaquetado (bootstrap.js, los
// componentes Vue con "import $ from 'jquery'") use la MISMA instancia
// global que ya cargo porto-light/vendor/jquery/jquery.js como <script>
// clasico en los layouts. Si cada uno importara su propia copia empaquetada,
// $(...).miPlugin() fallaria con "is not a function" porque el plugin quedo
// registrado en el prototipo de OTRA instancia de jQuery.
export default window.jQuery;
