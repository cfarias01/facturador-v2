<template>
    <div>
        <div class="row ">
            <div class="col-md-12 col-lg-12 col-xl-12 ">
                <div class="row col-12">
                    <div class="col-lg-9 col-md-8 col-sm-12 mb-2">
                        <div class="form-group">
                            <label class="control-label font-custom"><strong>Filtros de busqueda</strong></label>
                            <template v-if="!see_more">
                                <a class="control-label font-weight-bold text-info font-custom" href="#"
                                    @click="clickSeeMore"><strong> [+ Ver más]</strong></a>
                            </template>
                            <template v-else>
                                <a class="control-label font-weight-bold text-info font-custom" href="#"
                                    @click="clickSeeMore"><strong> [- Ver menos]</strong></a>
                            </template>
                        </div>
                    </div>
                </div>
                <div class="row mt-2" v-if="see_more">
                    <div class="col-lg-2 col-md-2">
                        <div class="form-group">
                            <label class="control-label">Ruc Emisor</label>
                            <el-input placeholder="Ingresar" v-model="search.ruc_emisor">
                            </el-input>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-2">
                        <div class="form-group">
                            <label class="control-label">Razon Social Emisor</label>
                            <el-input placeholder="Ingresar" v-model="search.razon_social_emisor">
                            </el-input>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-2">
                        <div class="form-group">
                            <label class="control-label">Comprobante</label>
                            <el-input placeholder="Ingresar" v-model="search.serie_comprobante">
                            </el-input>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-2">
                        <div class="form-group">
                            <label class="control-label">Tipo documento</label>
                            <el-input placeholder="Ingresar" v-model="search.tipo_comprobante">
                            </el-input>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-2">
                        <div class="form-group">
                            <label class="control-label">Documento modificado</label>
                            <el-input placeholder="Ingresar" v-model="search.numero_documento_modificado">
                            </el-input>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-2 pb-2">
                        <div class="form-group">
                            <label class="control-label">Fecha Autorizacion</label>

                            <el-date-picker v-model="search.autorizacion_start" type="date" style="width: 100%;"
                                placeholder="Fecha Inicio" value-format="yyyy-MM-dd" @change="changeDisabledDates">
                            </el-date-picker>

                            <el-date-picker v-model="search.autorizacion_end" type="datetime" style="width: 100%;"
                                placeholder="Fecha Fin" value-format="yyyy-MM-dd" @change="changeDisabledDates">
                            </el-date-picker>

                        </div>
                    </div>
                    <div class="col-lg-2 col-md-2 pb-2">
                        <div class="form-group">
                            <label class="control-label">Fecha Emision</label>

                            <el-date-picker v-model="search.emision_start" type="date" style="width: 100%;" placeholder="Fecha Inicio"
                                value-format="yyyy-MM-dd" :picker-options="pickerOptionsDates" @change="changeEndDate">
                            </el-date-picker>

                            <el-date-picker v-model="search.emision_end" type="date" style="width: 100%;" placeholder="Fecha Fin"
                                value-format="yyyy-MM-dd" :picker-options="pickerOptionsDates" @change="changeEndDate">
                            </el-date-picker>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-6 col-md-6 col-sm-12" style="margin-top:29px">
                        <el-button class="submit" type="primary" @click.prevent="getRecordsByFilter"
                            :loading="loading_submit" icon="el-icon-search">Buscar</el-button>
                        <el-button class="submit" type="info" @click.prevent="cleanInputs" icon="el-icon-delete">Limpiar
                        </el-button>
                    </div>

                </div>
                <div class="row mt-1 mb-3">
                </div>
            </div>
            <div class="col-md-12">
                <div id="scroll1" style="overflow-x:auto;">
                    <div style="height: 20px;"></div>
                </div>
                <div class="table-responsive" id="scroll2" style="overflow-x:auto;">
                    <table class="table" :v-loading="loading_search" style="width: 100%;">
                        <thead>
                            <slot name="heading"></slot>
                        </thead>
                        <tbody>
                            <slot v-for="(row, index) in records" :row="row" :index="customIndex(index)"></slot>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</template>
<style>
.font-custom {
    font-size: 15px !important
}
</style>
<script>

import moment from 'moment'
import queryString from 'query-string'
import $ from 'jquery'
import { mapActions, mapState } from "vuex/dist/vuex.mjs";

export default {
    props: {
        resource: String,
    },
    data() {
        return {
            loading_submit: false,
            records: [],
            loading_search: false,
            loading_search_item: false,
            pagination: {},
            search: {},
            activePanel: 0,
            see_more: false,
            pickerOptionsDates: {
                disabledDate: (time) => {
                    time = moment(time).format('YYYY-MM-DD')
                    return this.search.d_start > time
                }
            },
        }
    },
    computed: {
        ...mapState([
            'config',
        ]),
    },
    created() {
        this.loadConfiguration();
        this.initForm()
        this.$eventHub.$on('reloadData', () => {
            this.getRecords()
        })
    },
    async mounted() {

        await this.getRecords()
        await this.filterItems()
        await this.cargalo()
    },
    methods: {
        ...mapActions(['loadConfiguration']),
        filterItems() {
            this.items = this.all_items
        },
        clickSeeMore() {
            this.see_more = (this.see_more) ? false : true
        },
        initForm() {

            this.search = {
                ruc_emisor: null,
                razon_social_emisor: null,
                serie_comprobante: null,
                tipo_comprobante: null,
                numero_documento_modificado: null,
                autorizacion_start: null,
                autorizacion_end: null,
                emision_start: null,
                emision_end: null,
            }
        },
        customIndex(index) {
            return (this.pagination.per_page * (this.pagination.current_page - 1)) + index + 1
        },
        async getRecordsByFilter() {

            this.loading_submit = await true
            await this.getRecords()
            this.loading_submit = await false

        },
        getRecords() {

            this.loading_search = true
            this.$http.post(`/${this.resource}/records`, this.search).then((response) => {
                console.log(response)
                this.records = response.data.documentos
                this.loading_search = false
            });

        },
        changeClearInput() {
            this.search.value = ''

        },
        changeDisabledDates() {
            this.search.date_of_issue = null
            if (this.search.d_end < this.search.d_start) {
                this.search.d_end = this.search.d_start
            }
        },
        changeDateOfIssue() {
            this.search.d_start = null
            this.search.d_end = null
        },
        changeEndDate() {
            this.search.date_of_issue = null
        },
        cleanInputs() {
            this.initForm()
        },
        cargalo() {
            $("#scroll1 div").width($(".table").width());
            $("#scroll1").on("scroll", function () {
                $("#scroll2").scrollLeft($(this).scrollLeft());
            });
            $("#scroll2").on("scroll", function () {
                $("#scroll1").scrollLeft($(this).scrollLeft());
            });
        }
    }
}
</script>
