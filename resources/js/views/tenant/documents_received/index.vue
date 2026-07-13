<template>
    <div>
        <div>
            <div class="page-header pr-0">
                <h2><a href="/dashboard"><i class="fas fa-tachometer-alt"></i></a></h2>
                <ol class="breadcrumbs">
                    <li class="active"><span>Comprobantes Recibidos</span></li>
                    <li><span class="text-muted">Archivo Resumen DEL SRI</span></li>
                    <button class="btn btn-primary" @click.prevent="clickImport">Importar</button>
                </ol>
            </div>
        </div>
        <div class="card mb-0">
            <div class="card-body ">
                <data-table :resource="resource">
                    <tr slot="heading">
                        <th class="text-center" style="min-width: 95px;">Documento</th>
                        <th>Fecha de carga</th>
                        <th>Accion</th>
                    </tr>
                    <tr slot-scope="{ index, row }">
                        <td class="text-center">{{ row.nombre_archivo }}</td>
                        <td>{{ row.created_at }}</td>
                        <td class="text-center">
                            <button type="button" style="min-width: 41px"
                                class="btn waves-effect waves-light btn-xs btn-info m-1__2"
                                @click.prevent="clickReenviar(row.NUMSERIE, row.NUMDOC)"> Eliminar
                            </button>
                        </td>
                    </tr>
                </data-table>
            </div>
        </div>
        <el-dialog :visible="showImportDialog" top="7vh" width="50%" :close-on-click-modal="false"
            :close-on-press-escape="false" :show-close="true" @close="showImportDialog = false">
            <div class="row">
                <div class="col-md-12">

                    <h4>Opciones</h4>

                    <el-date-picker v-model="anio" type="year" value-format="yyyy" placeholder="Seleccione un año" required />
                    <el-date-picker v-model="mes" type="month" format="MM" value-format="MM" placeholder="Selecione un mes" required />

                    <input type="file" ref="file" class="form-control" accept=".txt" @change="file = $event.target.files[0]">

                    <br>

                    <button type="file" class="btn btn-primary" @click.prevent="clickUploadFile()">Procesar</button>

                </div>
            </div>
        </el-dialog>
    </div>
</template>

<script>
import { data } from 'jquery';
import DataTable from '../../../components/DataTableDocumentsReceived.vue'
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
            resource: 'purchases/received',
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

        clickUploadFile() {

            console.log(this.file)
            console.log(this.$refs.file.files[0])

            const formData = new FormData();
            formData.append('file', this.$refs.file.files[0]);
            formData.append('mes', this.mes);
            formData.append('anio', this.anio);

            this.$http.post(`/${this.resource}/import`, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(response => {
                console.log("Respuesta de post");
                console.log(response);
                this.$message.success('Archivo importado exitosamente');
                this.showImportDialog = false;
                this.$eventHub.$emit('reloadData');
                this.anio = null;
                this.mes = null;
                this.file = null;
                this.$refs.file.value = null;
            }).catch(error => {
                this.$message.error(error.response.data.message);
            });
        },
    }
}
</script>
