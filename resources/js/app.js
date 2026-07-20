/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

import './bootstrap';


import Vue from 'vue'
import store from './store'
import ElementUI from 'element-ui'

import lang from 'element-ui/lib/locale/lang/es'
import locale from 'element-ui/lib/locale'

locale.use(lang)

// Imports generados automaticamente al migrar de require() (Mix/webpack) a import (Vite).
import __c1 from './components/ExampleComponent.vue';
import __c2 from '../../modules/Dashboard/Resources/assets/js/views/index.vue';
import __c3 from '../../modules/Dashboard/Resources/assets/js/views/items/SalesByProduct.vue';
import __c4 from './components/graph/src/Graph.vue';
import __c5 from './components/graph/src/GraphLine.vue';
import __c6 from './views/tenant/companies/signature_pse/index.vue';
import __c7 from './views/tenant/companies/whatsapp_api/index.vue';
import __c8 from './views/tenant/components/partials/item_extra_info.vue';
import __c9 from './views/tenant/components/partials/modal_item_info_attributes.vue';
import __c10 from '../../modules/Dashboard/Resources/assets/js/views/index.vue';
import __c11 from '../../modules/Dashboard/Resources/assets/js/views/items/SalesByProduct.vue';
import __c12 from './components/graph/src/Graph.vue';
import __c13 from './components/graph/src/GraphLine.vue';
import __c14 from './views/tenant/companies/signature_pse/index.vue';
import __c15 from './views/tenant/companies/whatsapp_api/index.vue';
import __c16 from './views/tenant/companies/form.vue';
import __c17 from './views/tenant/companies/logo.vue';
import __c18 from './views/tenant/certificates/index.vue';
import __c19 from './views/tenant/certificates/form.vue';
import __c20 from './views/tenant/configurations/form.vue';
import __c21 from './views/tenant/configurations/partials/purchases.vue';
import __c22 from './views/tenant/configurations/visual.vue';
import __c23 from './views/tenant/configurations/pdf_templates.vue';
import __c24 from './views/tenant/configurations/pdf_ticket_templates.vue';
import __c25 from './views/tenant/configurations/sale_notes.vue';
import __c26 from './views/tenant/configurations/pdf_guide_templates.vue';
import __c27 from './views/tenant/configurations/pdf_preprinted_templates.vue';
import __c28 from './views/tenant/configurations/partials/dialog_header_menu.vue';
import __c29 from './views/tenant/users/form.vue';
import __c30 from './views/tenant/documents/index.vue';
import __c31 from './views/tenant/documents_failed/index.vue';
import __c32 from './views/tenant/documents_returned/index.vue';
import __c33 from './views/tenant/documents_received/index.vue';
import __c34 from './views/tenant/documents_uploaded/index.vue';
import __c35 from './views/tenant/documents/invoice.vue';
import __c36 from './views/tenant/documents/invoice_generate.vue';
import __c37 from './views/tenant/documents/invoicetensu.vue';
import __c38 from './views/tenant/documents/note.vue';
import __c39 from './views/tenant/documents/partials/item.vue';
import __c40 from './views/tenant/options/form.vue';
import __c41 from './views/tenant/users/index.vue';
import __c42 from './views/tenant/establishments/index.vue';
import __c43 from './views/tenant/components/guides.vue';
import __c44 from './views/tenant/components/calendar.vue';
import __c45 from './views/tenant/components/warehouses.vue';
import __c46 from './views/tenant/components/calendarquotations.vue';
import __c47 from './views/tenant/components/products.vue';
import __c48 from './views/tenant/tasks/lists.vue';
import __c49 from './views/tenant/tasks/form.vue';
import __c50 from './views/tenant/reports/consistency-documents/lists.vue';
import __c51 from '../../modules/Account/Resources/assets/js/views/account/export.vue';
import __c52 from '../../modules/Account/Resources/assets/js/views/summary_report/index.vue';
import __c53 from '../../modules/Account/Resources/assets/js/views/account/format.vue';
import __c54 from '../../modules/Account/Resources/assets/js/views/company_accounts/form.vue';
import __c55 from '../../modules/Account/Resources/assets/js/views/ledger_accounts/form.vue';
import __c56 from '../../modules/Document/Resources/assets/js/views/documents/not_sent.vue';
import __c57 from '../../modules/BusinessTurn/Resources/assets/js/views/configurations/index.vue';
import __c58 from '../../modules/Offline/Resources/assets/js/views/offline_configurations/index.vue';
import __c59 from '../../modules/Document/Resources/assets/js/views/series_configurations/index.vue';
import __c60 from '../../modules/Document/Resources/assets/js/views/validate_documents/index.vue';
import __c61 from '../../modules/Document/Resources/assets/js/views/documents/regularize_shipping.vue';
import __c62 from './components/InputService.vue';
import __c63 from './views/system/clients/index.vue';
import __c64 from './views/system/clients/form.vue';
import __c65 from './views/system/users/form.vue';
import __c66 from './views/system/certificate/index.vue';
import __c67 from './views/system/companies/form.vue';
import __c68 from './views/system/plans/index.vue';
import __c69 from './views/system/plans/form.vue';
import __c70 from './views/tenant/account/payment_index.vue';
import __c71 from './views/tenant/account/configuration.vue';
import __c72 from './views/system/update/index.vue';
import __c73 from './views/system/backup/index.vue';
import __c74 from './views/system/configuration/culqi.vue';
import __c75 from './views/system/configuration/apk-url.vue';
import __c76 from './views/system/configuration/token_ruc_dni.vue';
import __c77 from './views/system/configuration/php_info.vue';
import __c78 from './views/system/configuration/server_status.vue';
import __c79 from './views/system/configuration/login.vue';
import __c80 from './views/system/configuration/other_configuration.vue';
import __c81 from './views/tenant/login/index.vue';
import __c82 from '../../modules/Digemid/Resources/assets/js/view/index.vue';
import __c83 from '../js/components/DataTablePaymentReceipt.vue';
import __c84 from '@viewsModuleLevelAccess/system_activity_logs/generals/index.vue';
import __c85 from '@viewsModuleLevelAccess/system_activity_logs/transactions/index.vue';
import __c86 from './views/tenant/users/partials/remember_change_password.vue';

window.Vue = Vue;

ElementUI.Select.computed.readonly = function () {
    const isIE = !this.$isServer && !Number.isNaN(Number(document.documentMode).default);
    return !(this.filterable || this.multiple || !isIE) && !this.visible;
};

export default ElementUI;

Vue.use(ElementUI, { size: 'small' })
Vue.prototype.$eventHub = new Vue()

/**
 * The following block of code may be used to automatically register your
 * Vue components. It will recursively scan this directory for the Vue
 * components and automatically register them with their "basename".
 *
 * Eg. ./components/ExampleComponent.vue -> <example-component></example-component>
 */

// const files = require.context('./', true, /\.vue$/i)
// files.keys().map(key => Vue.component(key.split('/').pop().split('.')[0], files(key).default))

Vue.component('example-component', __c1);

/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

Vue.component('tenant-dashboard-index', __c2);
Vue.component('tenant-dashboard-sales-by-product', __c3);

Vue.component('x-graph', __c4);
Vue.component('x-graph-line', __c5);

// configuracion pse
Vue.component('tenant-signature-pse-index', __c6);
Vue.component('tenant-whatsapp-api-index', __c7);

Vue.component('tenant-item-aditional-info-selector', __c8);
Vue.component('tenant-item-aditional-info-modal', __c9);


Vue.component('tenant-dashboard-index', __c10);
Vue.component('tenant-dashboard-sales-by-product', __c11);

Vue.component('x-graph', __c12);
Vue.component('x-graph-line', __c13);

// configuracion pse
Vue.component('tenant-signature-pse-index', __c14);
Vue.component('tenant-whatsapp-api-index', __c15);

Vue.component('tenant-companies-form', __c16);
Vue.component('tenant-companies-logo', __c17);
Vue.component('tenant-certificates-index', __c18);
Vue.component('tenant-certificates-form', __c19);
Vue.component('tenant-configurations-form', __c20);
Vue.component('tenant-configurations-form-purchases', __c21);
Vue.component('tenant-configurations-visual', __c22);
Vue.component('tenant-configurations-pdf', __c23);
Vue.component('tenant-configurations-ticket-pdf', __c24);
Vue.component('tenant-configurations-sale-notes', __c25);
Vue.component('tenant-configurations-pdf-guide', __c26);
Vue.component('tenant-configurations-preprinted-pdf', __c27);
Vue.component('tenant-dialog-header-menu', __c28);



Vue.component('tenant-users-form', __c29);
Vue.component('tenant-documents-index', __c30);
Vue.component('tenant-documents-failed-index', __c31);
Vue.component('tenant-documents-returned-index', __c32);
Vue.component('tenant-documents-received-index', __c33);
Vue.component('tenant-documents-received-uploaded', __c34);
Vue.component('tenant-documents-invoice', __c35);
Vue.component('tenant-documents-invoice-generate', __c36);
Vue.component('tenant-documents-invoicetensu', __c37);
Vue.component('tenant-documents-note', __c38);


Vue.component('tenant-documents-items-list', __c39);

Vue.component('tenant-options-form', __c40);
Vue.component('tenant-users-index', __c41);
Vue.component('tenant-establishments-index', __c42);



Vue.component('tenant-guides-modal', __c43);



Vue.component('tenant-calendar', __c44);
Vue.component('tenant-warehouses', __c45);
Vue.component('tenant-calendar-quotation', __c46);

//Vue.component('tenant-calendar', require('./views/tenant/components/calendar.vue').default);
Vue.component('tenant-product', __c47);

Vue.component('tenant-tasks-lists', __c48);
Vue.component('tenant-tasks-form', __c49);
Vue.component('tenant-reports-consistency-documents-lists', __c50);



// Modules
Vue.component('tenant-account-export', __c51);
Vue.component('tenant-account-summary-report', __c52);
Vue.component('tenant-account-format', __c53);
Vue.component('tenant-company-accounts', __c54);
Vue.component('tenant-ledger-accounts', __c55);

Vue.component('tenant-documents-not-sent', __c56);

/** Reporte de guias */
Vue.component('tenant-index-configuration', __c57);
Vue.component('tenant-offline-configurations-index', __c58);
Vue.component('tenant-series-configurations-index', __c59);
Vue.component('tenant-validate-documents-index', __c60);
Vue.component('tenant-documents-regularize-shipping', __c61);

Vue.component('x-input-service', __c62);

// System
Vue.component('system-clients-index', __c63);
Vue.component('system-clients-form', __c64);
Vue.component('system-users-form', __c65);

Vue.component('system-certificate-index', __c66);
Vue.component('system-companies-form', __c67);

Vue.component('system-plans-index', __c68);
Vue.component('system-plans-form', __c69);

//Cuenta
Vue.component('tenant-account-payment-index', __c70);
Vue.component('tenant-account-configuration-index', __c71);

//auto update
Vue.component('system-update', __c72);

//auto update
Vue.component('system-backup', __c73);

//culqi
Vue.component('system-configuration-culqi', __c74);

//apk url
Vue.component('system-configuration-apk-url', __c75);

//token
Vue.component('system-configuration-token', __c76);

// php info
Vue.component('system-php-configuration', __c77);
Vue.component('system-server-status', __c78);

//Configuración global del login
Vue.component('system-login-settings', __c79);

Vue.component('system-login-other-configuration', __c80);

// Configuración del login
Vue.component('tenant-login-page', __c81);

/** Modulo DIGEMID **/
Vue.component('tenant-digemid-index', __c82);

Vue.component('data-table-payment-receipt', __c83);

// LevelAccess
Vue.component('tenant-system-activity-logs-generals-index', __c84);
Vue.component('tenant-system-activity-logs-transactions-index', __c85);
Vue.component('tenant-remember-change-password', __c86);


import VueClipboard from 'vue-clipboard2'
Vue.use(VueClipboard)


import moment from 'moment';

Vue.mixin({
    filters: {
        toDecimals(number, decimal = 2) {
            return Number(number).toFixed(decimal);
        },
        DecimalText: function (number, decimal = 2) {
            return isNaN(parseFloat(number)) ? number : Number(number).toFixed(decimal);
        },
        toDate(date) {
            if (date) {
                return moment(date).format('DD/MM/YYYY');
            }
            return '';
        },
        toTime(time) {
            if (time) {
                if (time.length === 5) {
                    return moment(time + ':00', 'HH:mm:ss').format('HH:mm:ss');
                }
                return moment(time, 'HH:mm:ss').format('HH:mm:ss');
            }
            return '';
        },
        pad(value, fill = '', length = 3) {
            if (value) {
                return String(value).padStart(length, fill);
            }
            return value;
        }
    },
    methods: {
        axiosError(error) {
            const response = error.response;
            const status = response.status;
            if (status === 422) {
                this.errors = response.data
            }
            if (status === 500) {
                this.$message({
                    type: 'info',
                    message: response.data.message
                  });
            }
        }
    }
})

const app = new Vue({
    store: store,
    el: '#main-wrapper'
});
