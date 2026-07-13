/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

require('./bootstrap');


import Vue from 'vue'
import store from './store'
import ElementUI from 'element-ui'

import lang from 'element-ui/lib/locale/lang/es'
import locale from 'element-ui/lib/locale'

locale.use(lang)

window.Vue = require('vue').default;

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

Vue.component('example-component', require('./components/ExampleComponent.vue').default);

/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

Vue.component('tenant-dashboard-index', require('../../modules/Dashboard/Resources/assets/js/views/index.vue').default);
Vue.component('tenant-dashboard-sales-by-product', require('../../modules/Dashboard/Resources/assets/js/views/items/SalesByProduct.vue').default);

Vue.component('x-graph', require('./components/graph/src/Graph.vue').default);
Vue.component('x-graph-line', require('./components/graph/src/GraphLine.vue').default);

// configuracion pse
Vue.component('tenant-signature-pse-index', require('./views/tenant/companies/signature_pse/index.vue').default);
Vue.component('tenant-whatsapp-api-index', require('./views/tenant/companies/whatsapp_api/index.vue').default);

Vue.component('tenant-item-aditional-info-selector', require('./views/tenant/components/partials/item_extra_info.vue').default);
Vue.component('tenant-item-aditional-info-modal', require('./views/tenant/components/partials/modal_item_info_attributes.vue').default);


Vue.component('tenant-dashboard-index', require('../../modules/Dashboard/Resources/assets/js/views/index.vue').default);
Vue.component('tenant-dashboard-sales-by-product', require('../../modules/Dashboard/Resources/assets/js/views/items/SalesByProduct.vue').default);

Vue.component('x-graph', require('./components/graph/src/Graph.vue').default);
Vue.component('x-graph-line', require('./components/graph/src/GraphLine.vue').default);

// configuracion pse
Vue.component('tenant-signature-pse-index', require('./views/tenant/companies/signature_pse/index.vue').default);
Vue.component('tenant-whatsapp-api-index', require('./views/tenant/companies/whatsapp_api/index.vue').default);

Vue.component('tenant-companies-form', require('./views/tenant/companies/form.vue').default);
Vue.component('tenant-companies-logo', require('./views/tenant/companies/logo.vue').default);
Vue.component('tenant-certificates-index', require('./views/tenant/certificates/index.vue').default);
Vue.component('tenant-certificates-form', require('./views/tenant/certificates/form.vue').default);
Vue.component('tenant-configurations-form', require('./views/tenant/configurations/form.vue').default);
Vue.component('tenant-configurations-form-purchases', require('./views/tenant/configurations/partials/purchases.vue').default);
Vue.component('tenant-configurations-visual', require('./views/tenant/configurations/visual.vue').default);
Vue.component('tenant-configurations-pdf', require('./views/tenant/configurations/pdf_templates.vue').default);
Vue.component('tenant-configurations-ticket-pdf', require('./views/tenant/configurations/pdf_ticket_templates.vue').default);
Vue.component('tenant-configurations-sale-notes', require('./views/tenant/configurations/sale_notes.vue').default);
Vue.component('tenant-configurations-pdf-guide', require('./views/tenant/configurations/pdf_guide_templates.vue').default);
Vue.component('tenant-configurations-preprinted-pdf', require('./views/tenant/configurations/pdf_preprinted_templates.vue').default);
Vue.component('tenant-dialog-header-menu', require('./views/tenant/configurations/partials/dialog_header_menu.vue').default);



Vue.component('tenant-users-form', require('./views/tenant/users/form.vue').default);
Vue.component('tenant-documents-index', require('./views/tenant/documents/index.vue').default);
Vue.component('tenant-documents-failed-index', require('./views/tenant/documents_failed/index.vue').default);
Vue.component('tenant-documents-returned-index', require('./views/tenant/documents_returned/index.vue').default);
Vue.component('tenant-documents-received-index', require('./views/tenant/documents_received/index.vue').default);
Vue.component('tenant-documents-received-uploaded', require('./views/tenant/documents_uploaded/index.vue').default);
Vue.component('tenant-documents-invoice', require('./views/tenant/documents/invoice.vue').default);
Vue.component('tenant-documents-invoice-generate', require('./views/tenant/documents/invoice_generate').default);
Vue.component('tenant-documents-invoicetensu', require('./views/tenant/documents/invoicetensu.vue').default);
Vue.component('tenant-documents-note', require('./views/tenant/documents/note.vue').default);


Vue.component('tenant-documents-items-list', require('./views/tenant/documents/partials/item.vue').default);

Vue.component('tenant-options-form', require('./views/tenant/options/form.vue').default);
Vue.component('tenant-users-index', require('./views/tenant/users/index.vue').default);
Vue.component('tenant-establishments-index', require('./views/tenant/establishments/index.vue').default);



Vue.component('tenant-guides-modal', require('./views/tenant/components/guides.vue').default);



Vue.component('tenant-calendar', require('./views/tenant/components/calendar.vue').default);
Vue.component('tenant-warehouses', require('./views/tenant/components/warehouses.vue').default);
Vue.component('tenant-calendar-quotation', require('./views/tenant/components/calendarquotations.vue').default);

//Vue.component('tenant-calendar', require('./views/tenant/components/calendar.vue').default);
Vue.component('tenant-product', require('./views/tenant/components/products.vue').default);

Vue.component('tenant-tasks-lists', require('./views/tenant/tasks/lists.vue').default);
Vue.component('tenant-tasks-form', require('./views/tenant/tasks/form.vue').default);
Vue.component('tenant-reports-consistency-documents-lists', require('./views/tenant/reports/consistency-documents/lists.vue').default);



// Modules
Vue.component('tenant-account-export', require('../../modules/Account/Resources/assets/js/views/account/export.vue').default);
Vue.component('tenant-account-summary-report', require('../../modules/Account/Resources/assets/js/views/summary_report/index.vue').default);
Vue.component('tenant-account-format', require('../../modules/Account/Resources/assets/js/views/account/format.vue').default);
Vue.component('tenant-company-accounts', require('../../modules/Account/Resources/assets/js/views/company_accounts/form.vue').default);
Vue.component('tenant-ledger-accounts', require('../../modules/Account/Resources/assets/js/views/ledger_accounts/form.vue').default);

Vue.component('tenant-documents-not-sent', require('../../modules/Document/Resources/assets/js/views/documents/not_sent.vue').default);

/** Reporte de guias */
Vue.component('tenant-index-configuration', require('../../modules/BusinessTurn/Resources/assets/js/views/configurations/index.vue').default);
Vue.component('tenant-offline-configurations-index', require('../../modules/Offline/Resources/assets/js/views/offline_configurations/index.vue').default);
Vue.component('tenant-series-configurations-index', require('../../modules/Document/Resources/assets/js/views/series_configurations/index.vue').default);
Vue.component('tenant-validate-documents-index', require('../../modules/Document/Resources/assets/js/views/validate_documents/index.vue').default);
Vue.component('tenant-documents-regularize-shipping', require('../../modules/Document/Resources/assets/js/views/documents/regularize_shipping.vue').default);

Vue.component('x-input-service', require('./components/InputService.vue').default);

// System
Vue.component('system-clients-index', require('./views/system/clients/index.vue').default);
Vue.component('system-clients-form', require('./views/system/clients/form.vue').default);
Vue.component('system-users-form', require('./views/system/users/form.vue').default);

Vue.component('system-certificate-index', require('./views/system/certificate/index.vue').default);
Vue.component('system-companies-form', require('./views/system/companies/form.vue').default);

Vue.component('system-plans-index', require('./views/system/plans/index.vue').default);
Vue.component('system-plans-form', require('./views/system/plans/form.vue').default);

//Cuenta
Vue.component('tenant-account-payment-index', require('./views/tenant/account/payment_index.vue').default);
Vue.component('tenant-account-configuration-index', require('./views/tenant/account/configuration.vue').default);

//auto update
Vue.component('system-update', require('./views/system/update/index.vue').default);

//auto update
Vue.component('system-backup', require('./views/system/backup/index.vue').default);

//culqi
Vue.component('system-configuration-culqi', require('./views/system/configuration/culqi.vue').default);

//apk url
Vue.component('system-configuration-apk-url', require('./views/system/configuration/apk-url.vue').default);

//token
Vue.component('system-configuration-token', require('./views/system/configuration/token_ruc_dni.vue').default);

// php info
Vue.component('system-php-configuration', require('./views/system/configuration/php_info.vue').default);
Vue.component('system-server-status', require('./views/system/configuration/server_status.vue').default);

//Configuración global del login
Vue.component('system-login-settings', require('./views/system/configuration/login.vue').default);

Vue.component('system-login-other-configuration', require('./views/system/configuration/other_configuration.vue').default);

// Configuración del login
Vue.component('tenant-login-page', require('./views/tenant/login/index.vue').default);

/** Modulo DIGEMID **/
Vue.component('tenant-digemid-index', require('../../modules/Digemid/Resources/assets/js/view/index.vue').default);

Vue.component('data-table-payment-receipt', require('../js/components/DataTablePaymentReceipt.vue').default);

// LevelAccess
Vue.component('tenant-system-activity-logs-generals-index', require('@viewsModuleLevelAccess/system_activity_logs/generals/index.vue').default);
Vue.component('tenant-system-activity-logs-transactions-index', require('@viewsModuleLevelAccess/system_activity_logs/transactions/index.vue').default);
Vue.component('tenant-remember-change-password', require('./views/tenant/users/partials/remember_change_password.vue').default);


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
