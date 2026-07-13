<template>
    <div>
        <div class="page-header pr-0">
            <h2><a href="#"><i class="fas fa-cogs"></i></a></h2>
            <ol class="breadcrumbs">
                <li class="active"><span>Configuración</span></li>
                <li><span class="text-muted">Empresa</span></li>
            </ol>
        </div>
        <div class="card">
            <div class="card-header bg-info">
                <h3 class="my-0">Datos de la Empresa</h3>
            </div>
            <div class="card-body">
                <form autocomplete="off" @submit.prevent="submit">
                    <div class="form-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div :class="{ 'has-danger': errors.number }" class="form-group">
                                    <label class="control-label">Número</label>
                                    <el-input v-model="form.number" :disabled="true" :maxlength="11"></el-input>
                                    <small v-if="errors.number" class="form-control-feedback"
                                        v-text="errors.number[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div :class="{ 'has-danger': errors.name }" class="form-group">
                                    <label class="control-label">Nombre <span class="text-danger">*</span></label>
                                    <el-input v-model="form.name"></el-input>
                                    <small v-if="errors.name" class="form-control-feedback"
                                        v-text="errors.name[0]"></small>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div :class="{ 'has-danger': errors.trade_name }" class="form-group">
                                    <label class="control-label">Nombre comercial
                                        <span class="text-danger">*</span></label>
                                    <el-input v-model="form.trade_name"></el-input>
                                    <small v-if="errors.trade_name" class="form-control-feedback"
                                        v-text="errors.trade_name[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div :class="{ 'has-danger': errors.emailLogo }" class="form-group">
                                    <label class="control-label">Logo URL</label>
                                    <el-input v-model="form.emailLogo">
                                    </el-input>
                                    <small v-if="errors.emailLogo" class="form-control-feedback"
                                        v-text="errors.emailLogo[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label">Logo IMG</label>
                                    <el-input v-model="form.logo" :readonly="true">
                                        <el-upload slot="append" :data="{ 'type': 'logo' }" :headers="headers"
                                            :on-success="successUpload" :on-error="errorUpload" :show-file-list="false"
                                            action="/companies/uploads">
                                            <el-button icon="el-icon-upload" type="primary"></el-button>
                                        </el-upload>
                                    </el-input>
                                    <div class="sub-title text-danger"><small>Se recomienda resoluciones 700x300</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div :class="{ 'has-danger': errors.detraction_account }" class="form-group">
                                    <label class="control-label">Etiqueta Adicional</label>
                                    <el-input v-model="form.detraction_account"></el-input>
                                    <small v-if="errors.detraction_account" class="form-control-feedback"
                                        v-text="errors.detraction_account[0]"></small>
                                </div>
                            </div>
                            <!--
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label">Rúbrica (Firma digital)</label>
                                    <el-input v-model="form.img_firm"
                                              :readonly="true">
                                        <el-upload slot="append"
                                                   :data="{'type': 'img_firm'}"
                                                   :headers="headers"
                                                   :on-success="successUpload"
                                                   :on-error="errorUpload"
                                                   :show-file-list="false"
                                                   action="/companies/uploads">
                                            <el-button icon="el-icon-upload"
                                                       type="primary"></el-button>
                                        </el-upload>
                                    </el-input>
                                    <div class="sub-title text-danger"><small>Se recomienda resoluciones 700x300</small>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label">Favicon</label>
                                    <el-input v-model="form.favicon"
                                              :readonly="true">
                                        <el-upload slot="append"
                                                   :data="{'type': 'favicon'}"
                                                   :headers="headers"
                                                   :on-success="successUpload"
                                                   :on-error="errorUpload"
                                                   :show-file-list="false"
                                                   action="/companies/uploads">
                                            <el-button icon="el-icon-upload"
                                                       type="primary"></el-button>
                                        </el-upload>
                                    </el-input>
                                    <div class="sub-title text-danger"><small>Se recomienda una imagen con fondo
                                                                              transparente y cuadrada en formato
                                                                              PNG</small></div>
                                </div>
                            </div>
                        -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label">Logo APP</label>
                                    <el-input v-model="form.app_logo" :readonly="true">
                                        <el-upload slot="append" :data="{ 'type': 'app_logo' }" :headers="headers"
                                            :on-success="successUpload" :on-error="errorUpload" :show-file-list="false"
                                            action="/companies/uploads">
                                            <el-button icon="el-icon-upload" type="primary"></el-button>
                                        </el-upload>
                                    </el-input>
                                    <div class="sub-title text-danger"><small>Se recomienda color blanco</small>
                                    </div>
                                </div>
                            </div>


                            <div v-if="form.soap_type_id == '02'" class="col-md-6">
                                <div :class="{ 'has-danger': errors.certificate_due }" class="form-group">
                                    <label class="control-label">Vencimiento de Certificado</label>
                                    <el-date-picker v-model="form.certificate_due" :clearable="true" type="date"
                                        value-format="yyyy-MM-dd"></el-date-picker>
                                    <small v-if="errors.certificate_due" class="form-control-feedback"
                                        v-text="errors.certificate_due[0]"></small>
                                </div>
                            </div>
                            <div v-show="false" class="col-md-6 mt-4">
                                <div :class="{ 'has-danger': errors.operation_amazonia }" class="form-group">
                                    <el-checkbox v-model="form.operation_amazonia">¿Emite en la Amazonía?</el-checkbox>
                                </div>
                            </div>
                        </div>
                        <!-- Datos de farmacia -->
                        <div v-show="form.is_pharmacy" class="row">
                            <div class="col-md-12 mt-2">
                                <h4 class="border-bottom">Datos de farmacia</h4>
                            </div>
                        </div>
                        <div v-show="form.is_pharmacy" class="row">
                            <div class="col-md-12">
                                <div :class="{ 'has-danger': errors.cod_digemid }" class="form-group">
                                    <label class="control-label">Código de observación DIGEMID</label>
                                    <!-- :disabled="!form.config_system_env" -->
                                    <el-input v-model="form.cod_digemid"></el-input>
                                    <!-- <div class="sub-title text-muted"><small>RUC + Usuario. Ejemplo: 01234567890ELUSUARIO</small></div>-->
                                    <small v-if="errors.cod_digemid" class="form-control-feedback"
                                        v-text="errors.cod_digemid[0]"></small>
                                </div>
                            </div>
                        </div>
                        <!-- API del sistema -->
                        <div class="row">
                            <div class="col-md-12 mt-2">
                                <h4 class="border-bottom">API del sistema</h4>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="control-label">Api Token</label>
                                <el-input v-model="form.tokenApi"></el-input>
                                <br><br>
                                <el-button icon="el-icon-refresh" type="primary"
                                    @click.prevent="generateApiToken()">Generar</el-button>
                                <br>
                                <div v-if="form.tokenApyBool == false" class="sub-title text-danger">
                                    <small>Copia el token antes de guardarlo, es visible una unica vez.</small>
                                </div>
                                <div v-if="form.tokenApyBool == true" class="sub-title text-success">
                                    <small>Ya tienes un TOKEN generado para el sistema, si generas uno nuevo deberas
                                        actualizar tus integraciones, no olvides copiar el token generado ya que solo
                                        sera visible por una vez.</small>
                                </div>
                            </div>
                        </div>
                        <!-- Entorno del sistema -->
                        <div class="row">
                            <div class="col-md-12 mt-2">
                                <h4 class="border-bottom">Entorno del sistema</h4>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div :class="{ 'has-danger': errors.soap_type_id }" class="form-group">
                                    <label class="control-label">SOAP Tipo</label>
                                    <el-select v-model="form.soap_type_id" :disabled="!form.config_system_env">
                                        <el-option v-for="option in soap_types" :key="option.id"
                                            :label="option.description" :value="option.id"></el-option>
                                    </el-select>

                                    <!-- <el-checkbox
                                           v-if="form.soap_send_id == '02' && form.soap_type_id == '01'"
                                           v-model="toggle"
                                           label="Ingresar Usuario">
                                    </el-checkbox> -->
                                    <small v-if="errors.soap_type_id" class="form-control-feedback"
                                        v-text="errors.soap_type_id[0]"></small>
                                </div>
                            </div>
                            <div v-if="form.soap_send_id != '03'" class="col-md-6">
                                <div :class="{ 'has-danger': errors.soap_send_id }" class="form-group">
                                    <label class="control-label">SOAP Envio</label>
                                    <el-select v-model="form.soap_send_id" :disabled="!form.config_system_env">
                                        <el-option v-for="(option, index) in soap_sends" :key="index" :label="option"
                                            :value="index"></el-option>
                                    </el-select>
                                    <small v-if="errors.soap_send_id" class="form-control-feedback"
                                        v-text="errors.soap_send_id[0]"></small>
                                </div>
                            </div>
                        </div>

                        <!-- Tipo de contribuyente -->
                        <div class="row">
                            <div class="col-md-12 mt-2">
                                <h4 class="border-bottom">Tipo de contribuyente</h4>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 center-el-checkbox mt-4">
                                <div :class="{ 'has-danger': errors.rimpe_emp }" class="form-group">
                                    <el-checkbox v-model="form.rimpe_emp">
                                        Régimen RIMPE (Emprendedores)
                                    </el-checkbox>
                                    <br>
                                    <small v-if="errors.rimpe_emp" class="form-control-feedback"
                                        v-text="errors.rimpe_emp[0]">
                                    </small>
                                </div>
                            </div>
                            <div class="col-md-6 center-el-checkbox mt-4">
                                <div :class="{ 'has-danger': errors.rimpe_np }" class="form-group">
                                    <el-checkbox v-model="form.rimpe_np">
                                        Régimen RIMPE (Negocio Popular)
                                    </el-checkbox>
                                    <br>
                                    <small v-if="errors.rimpe_np" class="form-control-feedback"
                                        v-text="errors.rimpe_np[0]">
                                    </small>
                                </div>
                            </div>
                            <div class="col-md-6 center-el-checkbox mt-4">
                                <div :class="{ 'has-danger': errors.rise }" class="form-group">
                                    <el-checkbox v-model="form.rise">
                                        Régimen RISE
                                    </el-checkbox>
                                    <br>
                                    <small v-if="errors.rise" class="form-control-feedback" v-text="errors.rise[0]">
                                    </small>
                                </div>
                            </div>
                            <div class="col-md-6 center-el-checkbox mt-4">
                                <div :class="{ 'has-danger': errors.contribuyente_especial }" class="form-group">
                                    <el-checkbox v-model="form.contribuyente_especial">
                                        Contribuyente Especial
                                    </el-checkbox>
                                    <br>
                                    <small v-if="errors.contribuyente_especial" class="form-control-feedback"
                                        v-text="errors.contribuyente_especial[0]">
                                    </small>
                                </div>
                            </div>
                            <div class="col-md-6 center-el-checkbox mt-4">
                                <div :class="{ 'has-danger': errors.obligado_contabilidad }" class="form-group">
                                    <el-checkbox v-model="form.obligado_contabilidad">
                                        Obligado Contabilidad
                                    </el-checkbox>
                                    <br>
                                    <small v-if="errors.obligado_contabilidad" class="form-control-feedback"
                                        v-text="errors.obligado_contabilidad[0]">
                                    </small>
                                </div>
                            </div>
                            <div class="col-md-6 center-el-checkbox mt-4">
                                <div :class="{ 'has-danger': errors.agente_retencion }" class="form-group">
                                    <el-checkbox v-model="form.agente_retencion">
                                        Agente de Retención
                                    </el-checkbox>
                                    <br>
                                    <small v-if="errors.agente_retencion" class="form-control-feedback"
                                        v-text="errors.agente_retencion[0]">
                                    </small>
                                </div>
                            </div>
                        </div>

                        <template v-if="form.agente_retencion == true">
                            <div class="col-md-6 center-el-checkbox mt-4">
                                <div :class="{ 'has-danger': errors.agente_retencion_num }" class="form-group">
                                    <label class="control-label">
                                        Numero de Agente de Retención
                                    </label>
                                    <el-input v-model="form.agente_retencion_num" dusk="name">
                                    </el-input>
                                    <br>
                                    <small v-if="errors.agente_retencion_num" class="form-control-feedback"
                                        v-text="errors.agente_retencion_num[0]">
                                    </small>
                                </div>
                            </div>
                        </template>

                        <template v-if="form.contribuyente_especial == true">
                            <div class="col-md-6 center-el-checkbox mt-4">
                                <div :class="{ 'has-danger': errors.contribuyente_especial_num }" class="form-group">
                                    <label class="control-label">
                                        Numero de Contribuyente Especial
                                    </label>
                                    <el-input v-model="form.contribuyente_especial_num" dusk="name">
                                    </el-input>
                                    <br>
                                    <small v-if="errors.contribuyente_especial_num" class="form-control-feedback"
                                        v-text="errors.contribuyente_especial_num[0]">
                                    </small>
                                </div>
                            </div>
                        </template>

                        <template v-if="form.soap_type_id == '02' && form.soap_send_id == '02'">
                            <div class="row">
                                <div class="col-md-12 mt-2">
                                    <h4 class="border-bottom">Usuario Secundario Sunat/OSE</h4>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div :class="{ 'has-danger': errors.soap_username }" class="form-group">
                                        <label class="control-label">SOAP Usuario <span
                                                class="text-danger">*</span></label>
                                        <el-input v-model="form.soap_username"
                                            :disabled="!form.config_system_env"></el-input>
                                        <div class="sub-title text-muted"><small>RUC + Usuario. Ejemplo:
                                                01234567890ELUSUARIO</small></div>
                                        <small v-if="errors.soap_username" class="form-control-feedback"
                                            v-text="errors.soap_username[0]"></small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div :class="{ 'has-danger': errors.soap_password }" class="form-group">
                                        <label class="control-label">SOAP Password
                                            <span class="text-danger">*</span></label>
                                        <el-input v-model="form.soap_password"
                                            :disabled="!form.config_system_env"></el-input>
                                        <small v-if="errors.soap_password" class="form-control-feedback"
                                            v-text="errors.soap_password[0]"></small>
                                    </div>
                                </div>
                            </div>
                        </template>

                        <div v-if="form.soap_send_id == '02'" class="row">
                            <div class="col-md-12">
                                <div :class="{ 'has-danger': errors.soap_url }" class="form-group">
                                    <label class="control-label">SOAP Url</label>
                                    <el-input v-model="form.soap_url"></el-input>
                                    <small v-if="errors.soap_url" class="form-control-feedback"
                                        v-text="errors.soap_url[0]"></small>
                                </div>
                            </div>
                        </div>

                        <template v-if="form.soap_type_id == '02' && form.soap_send_id != '03'">
                            <div class="row">
                                <div class="col-md-12 mt-2">
                                    <h4 class="border-bottom">Consulta integrada de CPE - Validador de documentos
                                        <el-tooltip class="item" content="Obtener los datos desde el portal de Sunat"
                                            effect="dark" placement="top-start">
                                            <i class="fa fa-info-circle"></i>
                                        </el-tooltip>
                                    </h4>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div :class="{ 'has-danger': errors.integrated_query_client_id }" class="form-group">
                                        <label class="control-label">Client ID</label>
                                        <el-input v-model="form.integrated_query_client_id"></el-input>
                                        <small v-if="errors.integrated_query_client_id" class="form-control-feedback"
                                            v-text="errors.integrated_query_client_id[0]"></small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div :class="{ 'has-danger': errors.integrated_query_client_secret }"
                                        class="form-group">
                                        <label class="control-label">Client Secret (Clave)</label>
                                        <el-input v-model="form.integrated_query_client_secret"></el-input>
                                        <small v-if="errors.integrated_query_client_secret"
                                            class="form-control-feedback"
                                            v-text="errors.integrated_query_client_secret[0]"></small>
                                    </div>
                                </div>
                            </div>
                        </template>

                        <div class="row">
                            <div class="col-md-12 mt-2">
                                <h4 class="border-bottom">Datos SMTP (Envío de correos)</h4>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div :class="{ 'has-danger': errors.number }" class="form-group">
                                    <label class="control-label">Servidor</label>
                                    <el-input v-model="form.smtp_host"></el-input>
                                    <small v-if="errors.smtp_host" class="form-control-feedback"
                                        v-text="errors.smtp_host[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div :class="{ 'has-danger': errors.smtp_port }" class="form-group">
                                    <label class="control-label">Puerto <span class="text-danger"></span></label>
                                    <el-input v-model="form.smtp_port"></el-input>
                                    <small v-if="errors.smtp_port" class="form-control-feedback"
                                        v-text="errors.smtp_port[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div :class="{ 'has-danger': errors.smtp_encryption }" class="form-group">
                                    <label class="control-label">Encryptado <span class="text-danger"></span></label>
                                    <el-input v-model="form.smtp_encryption"></el-input>
                                    <small v-if="errors.smtp_encryption" class="form-control-feedback"
                                        v-text="errors.smtp_encryption[0]"></small>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div :class="{ 'has-danger': errors.number }" class="form-group">
                                    <label class="control-label">Usuario</label>
                                    <el-input v-model="form.smtp_user"></el-input>
                                    <small v-if="errors.smtp_user" class="form-control-feedback"
                                        v-text="errors.smtp_user[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div :class="{ 'has-danger': errors.smtp_port }" class="form-group">
                                    <label class="control-label">Contraseña <span class="text-danger"></span></label>
                                    <el-input v-model="form.smtp_password" type="password"></el-input>
                                    <small v-if="errors.smtp_password" class="form-control-feedback"
                                        v-text="errors.smtp_password[0]"></small>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 mt-2">
                                <div :class="{ 'has-danger': errors.smtp_port }" class="form-group">
                                    <label class="control-label">Correos copia (separados por ;) <span
                                            class="text-danger"></span></label>
                                    <el-input v-model="form.extra_emails"></el-input>
                                    <small v-if="errors.extra_emails" class="form-control-feedback"
                                        v-text="errors.extra_emails[0]"></small>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 mt-2">
                                <h4 class="border-bottom">Integracion ICG</h4>
                            </div>
                        </div>

                         <div class="row">
                            <div class="col-md-12 mt-2">
                                <el-checkbox v-model="form.active_icg">Activar Integración ICG</el-checkbox>
                                <div class="sub-title text-muted"><small>Si se activa, se debe ingresar los datos de la
                                        base de datos de ICG</small></div>
                            </div>
                        </div>

                        <div class="row" v-if="form.active_icg">
                            <div class="col-md-4">
                                <div :class="{ 'has-danger': errors.sql_host }" class="form-group">
                                    <label class="control-label">Servidor</label>
                                    <el-input v-model="form.sql_host"></el-input>
                                    <small v-if="errors.sql_host" class="form-control-feedback"
                                        v-text="errors.sql_host[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div :class="{ 'has-danger': errors.sql_pot }" class="form-group">
                                    <label class="control-label">Puerto <span class="text-danger"></span></label>
                                    <el-input v-model="form.sql_pot"></el-input>
                                    <small v-if="errors.sql_pot" class="form-control-feedback"
                                        v-text="errors.sql_pot[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div :class="{ 'has-danger': errors.sql_db }" class="form-group">
                                    <label class="control-label">Base 1 <span class="text-danger"></span></label>
                                    <el-input v-model="form.sql_db"></el-input>
                                    <small v-if="errors.sql_db" class="form-control-feedback"
                                        v-text="errors.sql_db[0]"></small>
                                </div>
                            </div>
                        </div>

                        <div class="row" v-if="form.active_icg" >
                            <div class="col-md-4">
                                <div :class="{ 'has-danger': errors.sql_username }" class="form-group">
                                    <label class="control-label">Usuario</label>
                                    <el-input v-model="form.sql_username"></el-input>
                                    <small v-if="errors.sql_username" class="form-control-feedback"
                                        v-text="errors.sql_username[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div :class="{ 'has-danger': errors.sql_password }" class="form-group">
                                    <label class="control-label">contraseña <span class="text-danger"></span></label>
                                    <el-input v-model="form.sql_password" type="password" ></el-input>
                                    <small v-if="errors.sql_password" class="form-control-feedback"
                                        v-text="errors.sql_password[0]"></small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div :class="{ 'has-danger': errors.sql_db2 }" class="form-group">
                                    <label class="control-label">Base 2 <span class="text-danger"></span></label>
                                    <el-input v-model="form.sql_db2"></el-input>
                                    <small v-if="errors.sql_db2" class="form-control-feedback"
                                        v-text="errors.sql_db2[0]"></small>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="form-actions text-right pt-2">
                        <el-button :loading="loading_submit" native-type="submit" type="primary">Guardar
                        </el-button>
                    </div>
                </form>

            </div>
        </div>
        <TokenRucDni></TokenRucDni>
    </div>
</template>


<style>
.input-with-select .el-input-group__prepend {
    background-color: var(--el-fill-color-blank);
}
</style>

<script>
import { mapActions, mapState } from "vuex";
import TokenRucDni from './token_ruc_dni.vue'


export default {
    components: {
        TokenRucDni
    },
    computed: {
        ...mapState([
            'config',
        ]),
    },
    data() {
        return {
            loading_submit: false,
            headers: headers_token,
            resource: 'companies',
            errors: {},
            form: {},
            soap_sends: [],
            soap_types: [],
            toggle: false, //Creando el objeto a retornar con v-model
        }
    },
    async created() {
        await this.initForm()
        await this.$http.get(`/${this.resource}/tables`)
            .then(response => {
                this.soap_sends = response.data.soap_sends
                this.soap_types = response.data.soap_types
                // console.log(1)
            })
        await this.$http.get(`/${this.resource}/record`)
            .then(response => {
                if (response.data !== '') {
                    //JOINSOFTWARE
                    console.log("Data: ", response.data.data);
                    this.form = response.data.data
                }
                // console.log(2)

            })

        this.events()
    },
    methods: {
        ...mapActions([
            'loadConfiguration',
        ]),
        generateApiToken() {
            var clave = this.uniqid('JN', true)
            this.form.tokenApi = clave
            this.form.tokenApi = clave
            console.log(clave)

        },
        uniqid(prefix = "", random = false) {
            const sec = Date.now() * 1000 + Math.random() * 1000
            const id = sec.toString(16).replace(/\./g, "").padEnd(14, "0")
            return `${prefix}${id}${random ? `${Math.trunc(Math.random() * 100000000)}` : ""}`
        },
        events() {

            this.$eventHub.$on('reloadDataCompany', () => {
                this.getRecord()
            })

        },
        async getRecord() {

            await this.$http.get(`/${this.resource}/record`)
                .then(response => {
                    if (response.data !== '') {
                        this.form = response.data.data
                    }
                })
        },
        initForm() {
            this.errors = {}
            this.form = {
                id: null,
                identity_document_type_id: '06000006',
                number: null,
                name: null,
                //JOINSOFTWARE
                rimpe_emp: null,
                rimpe_np: null,
                rise: null,
                contribuyente_especial: null,
                obligado_contabilidad: null,
                agente_retencion: null,
                agente_retencion_num: null,
                contribuyente_especial_num: null,
                trade_name: null,
                soap_send_id: '01',
                soap_type_id: '01',
                soap_username: null,
                soap_password: null,
                soap_url: null,
                certificate: null,
                certificate_due: null,
                logo: null,
                emailLogo: null,
                logo_store: null,
                detraction_account: null,
                operation_amazonia: false,
                toggle: false,
                config_system_env: false,
                img_firm: null,
                is_pharmacy: false,
                cod_digemid: null,
                integrated_query_client_id: null,
                integrated_query_client_secret: null,
                app_logo: null,
                apiTokenBool: false,
                tokenApi: 'TokenApi',
                smtp_encryption: null,
                smtp_host: null,
                smtp_port: 0,
                smtp_user: null,
                smtp_password: null,
                sql_host: null,
                sql_pot: 0,
                sql_username: null,
                sql_password: null,
                sql_db: null,
                sql_db2: null,
                extra_emails: null,
                active_icg: false,

            }
        },
        submit() {
            this.loading_submit = true
            this.$http.post(`/${this.resource}`, this.form)
                .then(response => {
                    if (response.data.success) {
                        this.$message.success(response.data.message)
                    } else {
                        this.$message.error(response.data.message)
                    }
                })
                .catch(error => {
                    if (error.response.status === 422) {
                        this.errors = error.response.data
                    } else {
                        console.log(error)
                    }
                })
                .then(() => {
                    this.loading_submit = false
                })
        },
        successUpload(response, file, fileList) {

            if (response.success) {
                this.$message.success(response.message)
                this.form[response.type] = response.name
            } else {
                this.$message({ message: 'Error al subir el archivo', type: 'error' })
            }
        },
        errorUpload(error) {
            this.$message({ message: 'Error al subir el archivo', type: 'error' })
        }
    }
}
</script>
