<template>
    <el-dialog :title="titleDialog" :visible="showDialog" @close="close" @open="create" class="certificate-form">
        <div class="form-body">
            <div class="row">
                <div class="col-md-7">
                    <div class="form-group" :class="{'has-danger': errors.password}">
                        <label class="control-label">Contraseña</label>
                        <el-input v-model="form.password"></el-input>
                        <small class="form-control-feedback" v-if="errors.password" v-text="errors.password[0]"></small>
                    </div>
                </div>
                <div class="col-md-5">
                    <div class="form-group" :class="{'has-danger': errors.certificate}">
                        <label class="control-label">Archivo p12</label>
                        <el-upload
                                   ref="upload"
                                   :headers="headers"
                                   :data="{'password': form.password}"
                                   action="/certificates/uploads"
                                   :show-file-list="false"
                                   :auto-upload="false"
                                   :multiple="false"
                                    :accept="'.p12'"
                                   :on-error="errorUpload"
                                   :on-success="successUpload">
                            <el-button slot="trigger" type="primary">Selecciona un archivo</el-button>
                        </el-upload>
                        <small class="form-control-feedback" v-if="errors.certificate" v-text="errors.certificate[0]"></small>
                    </div>
                </div>
            </div>
            <div class="row mt-4">
                <div class="col-md-12 text-right">
                    <el-button @click.prevent="close()">Cancelar</el-button>
                    <el-button type="primary" @click.prevent="clickUpload" :loading="loading_submit">Aceptar</el-button>
                </div>
            </div>
        </div>
    </el-dialog>
</template>

<script>
    export default {
        props: ['showDialog', 'recordId'],
        data() {
            return {
                loading_submit: false,
                headers: headers_token,
                titleDialog: null,
                resource: 'items',
                errors: {},
                form: {}
            }
        },
        created() {
            this.initForm()
        },
        methods: {
            initForm() {
                this.errors = {}
                this.form = {
                    id: null,
                    certificate: null,
                    password: null,
                }
            },
            create() {
                this.titleDialog = 'Cargar Certificado/Firma Electrónica'
            },
            clickUpload() {
                this.$refs.upload.submit();
            },
            close() {
                this.$emit('update:showDialog', false)
                this.initForm()
            },
            successUpload(response, file, fileList) {
                if (response.success) {

                    this.$message.success(response.message)
                    this.$eventHub.$emit('reloadData')
                    this.$eventHub.$emit('reloadDataCompany')
                    this.close()
                    
                } else {
                    this.$message({message:response.message, type: 'error'})
                }
            },
            errorUpload(response) {
                console.log(response)
            }
        }
    }
</script>