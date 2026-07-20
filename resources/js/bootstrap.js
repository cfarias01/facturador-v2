import Vue from 'vue';
import _ from 'lodash';
import moment from 'moment';
// 'jquery' esta aliaseado (vite.config.js) a la instancia global real, ver
// resources/js/vendor/jquery-shim.js.
import $ from 'jquery';
import 'bootstrap';

window._ = _;
window.moment = moment;

/**
 * We'll load the axios HTTP library which allows us to easily issue requests
 * to our Laravel back-end. This library automatically handles sending the
 * CSRF token as a header based on the value of the "XSRF" token cookie.
 */


import axios from 'axios';

axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
axios.defaults.withCredentials = true;

let token = document.head.querySelector('meta[name="csrf-token"]');

if (token) {
    axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content;
    window.headers_token = {
        'X-CSRF-TOKEN': token.content,
    }
} else {
    console.error('CSRF token not found: https://laravel.com/docs/csrf#csrf-x-csrf-token');
}

Vue.prototype.$http = axios;

Vue.prototype.$setStorage =   function(name,obj){
    localStorage.setItem(name, JSON.stringify(obj));
};
Vue.prototype.$getStorage = function(name){
    return JSON.parse(localStorage.getItem(name));
};

// perfect-scrollbar/sidebarmenu/waves/custom (public/js/vendor/*, cargados
// como <script> clasico en los layouts, no via import): son UMD que Rollup
// no puede empaquetar correctamente en el grafo de modulos ES (su rama
// require('jquery') queda como codigo real inejecutable en el navegador).
// Ver layouts tenant/system app.blade.php.

$(function () {
    const listElements = document.getElementsByClassName('nav-active');
    if (listElements.length > 0) {
        listElements[0].scrollIntoView();
    }
});

