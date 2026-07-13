<template>
    <div>
        <div>
            <div class="page-header pr-0">
                <h2><a href="/dashboard"><i class="fas fa-tachometer-alt"></i></a></h2>
                <ol class="breadcrumbs">
                    <li class="active"><span>Comprobantes Recibidos</span></li>
                    <li><span class="text-muted">Documentos cargados</span></li>
                </ol>
            </div>
        </div>
        <div class="card mb-0">
            <div class="card-body ">
                <data-table :resource="resource">
                    <tr slot="heading">
                        <th>Emisor</th>
                        <th>Razon Social</th>
                        <th>Tipo Documento</th>
                        <th>Serie Documento</th>
                        <th>clave Acceso</th>
                        <th>Fecha Autorizado</th>
                        <th>Fecha emitido</th>
                        <th>Receptor</th>
                        <th>Valor sin impuestos</th>
                        <th>IVA</th>
                        <th>Importe Total</th>
                        <th>Documento Modificado</th>
                        <th>Procesado</th>
                        <th class="text-center">Acciones</th>
                    </tr>
                    <tr slot-scope="{ index, row }">
                        <td class="text-center">{{ row.ruc_emisor }}</td>
                        <td>{{ row.razon_social_emisor }}</td>
                        <td>{{ row.tipo_documento }}</td>
                        <td>{{ row.serie_comprobante }}</td>
                        <td>{{ row.clave_acceso }}</td>
                        <td>{{ row.fecha_autorizacion }}</td>
                        <td>{{ row.fecha_emision }}</td>
                        <td>{{ row.identificador_receptor }}</td>
                        <td>{{ row.valor_sin_impuestos }}</td>
                        <td>{{ row.iva }}</td>  
                        <td>{{ row.importe_total }}</td>
                        <td>{{ row.numero_documento_modificado }}</td>
                        <td>{{ row.estado }}</td>
                        <td class="text-center">
                            <button type="button" style="min-width: 41px"
                                class="btn waves-effect waves-light btn-xs btn-info m-1__2"
                                @click.prevent="clickReporcesar(row.id)">Reprocesar
                            </button>
                            <button type="button" style="min-width: 41px"
                                class="btn waves-effect waves-light btn-xs btn-danger m-1__2"
                                @click.prevent="clickDeleteDocument(row.id)">Eliminar
                            </button>
                        </td>
                    </tr>
                </data-table>
            </div>
        </div>
    </div>
</template>

<script>

import DataTable from '../../../components/DataTableDocumentsReceived2.vue'
import { deletable } from '../../../mixins/deletable'
import { mapActions, mapState } from "vuex/dist/vuex.mjs";

export default {
    mixins: [deletable],
    props: [
    ],
    computed: {
        ...mapState([
            'config',
        ]),
    },
    components: {
        DataTable,
    },
    data() {
        return {
            resource: 'purchases/received2',
            recordId: null,
            showImportDialog: false,
            file: null,
            mes: null,
            anio: null,
        }
    },
    created() {
        this.$store.commit('setConfiguration', this.configuration)
        this.loadConfiguration();

    },
    methods: {
        ...mapActions(['loadConfiguration']),

        async clickReporcesar(serie, numdoc, fechaInim = null, fechafin = null) {

            await this.$http.post(`/${this.resource}/returned/process`, {
                serie: serie,
                numero: numdoc,
                fechaIni: fechaInim,
                fechafin: fechafin,
            });
        },

        clickReenviar($id) {

            this.$http.get(`/${this.resource}/returned/resend/${this.id}`)
                .then(response => {
                    if (response.data.success) {
                        this.$message.success(response.data.message)
                        this.$eventHub.$emit('reloadData')
                    } else {
                        this.$message.error(response.data.message)
                    }
                })
                .catch(error => {
                    this.$message.error(error.response.data.message)
                })
        },

        clickReprocesar() {

            this.$http.get(`/${this.resource}/returned/recreate/${this.id}`)
                .then(response => {
                    if (response.data.success) {
                        this.$message.success(response.data.message)
                        this.$eventHub.$emit('reloadData')
                    } else {
                        this.$message.error(response.data.message)
                    }
                })
                .catch(error => {
                    this.$message.error(error.response.data.message)
                })

        },
        clickSendOnline(document_id) {

            this.$http.get(`/${this.resource}/send_server/${document_id}/1`).then(response => {
                if (response.data.success) {
                    this.$message.success('Se envio satisfactoriamente el comprobante.');
                    this.$eventHub.$emit('reloadData');

                    this.clickCheckOnline(document_id);
                } else {
                    this.$message.error(response.data.message);
                }
            }).catch(error => {
                this.$message.error(error.response.data.message)
            });

        },

        clickOptions(recordId = null) {
            this.recordId = recordId
            this.showDialogOptions = true
        },

        tooltip(row, message = true) {
            if (message) {
                if (row.shipping_status) return row.shipping_status.message;

                if (row.sunat_shipping_status) return row.sunat_shipping_status.message;

                if (row.query_status) return row.query_status.message;
            }

            if ((row.shipping_status) || (row.sunat_shipping_status) || (row.query_status)) return true;

            return false;
        },

        clickImport() {
            this.showImportDialog = true
        },

        clickDeleteDocument(document_id) {

            this.destroy(`/${this.resource}/delete_document/${document_id}`).then(() =>
                this.$eventHub.$emit('reloadData')
            )
        },
    }
}
</script>
