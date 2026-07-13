<template>
    <div>
        <div>
            <div class="page-header pr-0">
                <h2><a href="/dashboard"><i class="fas fa-tachometer-alt"></i></a></h2>
                <ol class="breadcrumbs">
                    <li class="active"><span>Comprobantes Devueltos</span></li>
                    <li><span class="text-muted">Facturas - Notas crédito - Retenciones - Liquidaciónes </span></li>
                </ol>
            </div>
        </div>
        <div class="card mb-0">
            <div class="card-body ">
                <data-table :resource="resource">
                    <tr slot="heading">
                        <th class="text-center" style="min-width: 95px;">Id interno</th>
                        <th>Comprobante</th>
                        <th>Fecha</th>
                        <th>Clave de acceso</th>
                        <th>Cliente</th>
                        <th>Ruc/CI</th>
                        <th>Respuesta SRI</th>
                        <th class="text-center">Acciones</th>
                        <th class="text-center">Acciones</th>
                    </tr>
                    <tr slot-scope="{ index, row }" :class="{
                        'border-left border-info': (row.TIPODOC === '01'),
                        'border-left border-success': (row.state_type_id === '02'),
                        'border-left border-secondary': (row.state_type_id === '03'),
                        'border-left border-dark': (row.state_type_id === '04'),
                        'border-left border-danger': (row.state_type_id === '07'),
                        'border-left border-warning': (row.state_type_id === '08')
                    }">
                        <td class="text-center">{{ row.idInterno }}</td>
                        <td>{{ row.idComporbante }}</td>
                        <td>{{ row.fecha }}</td>
                        <td>{{ row.claveAcceso }}</td>
                        <td>{{ row.cliente }}</td>
                        <td>{{ row.ruc }}</td>
                        <td>{{ row.responseRegularizeShipping }}</td>
                        <td class="text-center">
                            <button type="button" style="min-width: 41px"
                                class="btn waves-effect waves-light btn-xs btn-info m-1__2"
                                @click.prevent="clickReenviar(row.NUMSERIE, row.NUMDOC)"> Reenviar
                            </button>
                        </td>
                        <td class="text-center">
                            <button type="button" style="min-width: 41px"
                                class="btn waves-effect waves-light btn-xs btn-info m-1__2"
                                @click.prevent="clickReprocesar(row.idComporbante)"> Reprocesar
                            </button>
                        </td>
                    </tr>
                </data-table>
            </div>
        </div>
    </div>
</template>

<script>
import DataTable from '../../../components/DataTableDocumentsReturned.vue'
import { deletable } from '../../../mixins/deletable'
import { mapActions, mapState } from "vuex/dist/vuex.mjs";

export default {
    mixins: [deletable],
    props: [
        'isClient',
        'typeUser',
        'userId',
        'configuration',
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
            resource: 'documents',
            recordId: null,
            showDialogOptions: false,
        }
    },
    created() {
        this.$store.commit('setConfiguration', this.configuration)
        this.loadConfiguration();

    },
    methods: {
        ...mapActions(['loadConfiguration']),

        clickVoided(recordId = null) {
            this.recordId = recordId
            this.showDialogVoided = true
        },

        async clickReporcesar(serie, numdoc, fechaInim = null, fechafin = null) {

            await this.$http.post(`/${this.resource}/returned/process`, {
                serie: serie,
                numero: numdoc,
                fechaIni: fechaInim,
                fechafin: fechafin,
            });

            //window.open(`/downloads/cabeceraDocumentoElectronica/${download}/${claveAcceso}`, '_blank');
            //window.open(download, '_blank');
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
        clickReprocesar(idInterno) {
   
			console.log(idInterno);
			
            this.$http.get(`/${this.resource}/returned/recreate/${idInterno}`)
                .then(response => {
				
					console.log("Responde data: ",response);
					
                    if (response.data.success) {
                        this.$message.success(response.data.message)
						
                        this.$eventHub.$emit('reloadData')
                    } else {
                        this.$message.error(response.data.message)
                    }
                })
                .catch(error => {
					console.log("Error: ",error)
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
        clickCheckOnline(document_id) {
            this.$http.get(`/${this.resource}/check_server/${document_id}`)
                .then(response => {
                    if (response.data.success) {
                        this.$message.success('Consulta satisfactoria.')
                        this.$eventHub.$emit('reloadData')
                    } else {
                        this.$message.error(response.data.message)
                    }
                })
                .catch(error => {
                    this.$message.error(error.response.data.message)
                })
        },
        clickCDetraction(recordId) {
            this.recordId = recordId
            this.showDialogCDetraction = true
        },
        clickOptions(recordId = null) {
            this.recordId = recordId
            this.showDialogOptions = true
        },
        clickReStore(document_id) {
            this.$http.get(`/${this.resource}/re_store/${document_id}`)
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
        tooltip(row, message = true) {
            if (message) {
                if (row.shipping_status) return row.shipping_status.message;

                if (row.sunat_shipping_status) return row.sunat_shipping_status.message;

                if (row.query_status) return row.query_status.message;
            }

            if ((row.shipping_status) || (row.sunat_shipping_status) || (row.query_status)) return true;

            return false;
        },
        clickPayment(recordId) {
            console.log('Record ID: ', recordId);
            this.recordId = recordId;
            this.showDialogPayments = true;
        },
        clickImport() {
            this.showImportDialog = true
        },
        clickDeleteDocument(document_id) {

            this.destroy(`/${this.resource}/delete_document/${document_id}`).then(() =>
                this.$eventHub.$emit('reloadData')
            )
        },
        clickDocumentDetail(document){
            $('#documentDetail').modal('show')
        },
        clickEnvioDetail(){
            $('#envioDetail').modal('show')
        }
    }
}
</script>
