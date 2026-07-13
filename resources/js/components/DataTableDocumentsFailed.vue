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
                            <label class="control-label">Serie</label>
                            <el-input placeholder="Ingresar" v-model="search.serie">
                            </el-input>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-2">
                        <div class="form-group">
                            <label class="control-label">Número</label>
                            <el-input placeholder="Ingresar" v-model="search.numero">
                            </el-input>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-2 pb-2">
                        <div class="form-group">
                            <label class="control-label">Fecha inicio </label>

                            <el-date-picker v-model="search.d_start" type="date" style="width: 100%;"
                                placeholder="Buscar" value-format="yyyy/dd/MM" @change="changeDisabledDates">
                            </el-date-picker>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-2 pb-2">
                        <div class="form-group">
                            <label class="control-label">Fecha fin</label>

                            <el-date-picker v-model="search.d_end" type="date" style="width: 100%;" placeholder="Buscar"
                                value-format="yyyy/dd/MM" :picker-options="pickerOptionsDates" @change="changeEndDate">
                            </el-date-picker>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-6 col-md-6 col-sm-12" style="margin-top:29px">
                        <el-button class="submit" type="primary" @click.prevent="getRecordsByFilter"
                            :loading="loading_submit" icon="el-icon-search">Buscar</el-button>
                        <el-button class="submit" type="info" @click.prevent="cleanInputs" icon="el-icon-delete">Limpiar
                        </el-button>
                        <el-button class="submit" type="success" @click.prevent="reprocessMasive"
                            :loading="loading_submit" icon="el-icon-refresh">Reprocesar</el-button>
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
                    <table class="table" v-loading="loading_search">
                        <thead>
                            <slot name="heading"></slot>
                        </thead>
                        <tbody>
                            <slot v-for="(row, index) in records" :row="row" :index="customIndex(index)"></slot>
                        </tbody>
                    </table>
                    <!-- <div>
                        <el-pagination
                                @current-change="getRecords"
                                layout="total, prev, pager, next"
                                :total="pagination.total"
                                :current-page.sync="pagination.current_page"
                                :page-size="pagination.per_page">
                        </el-pagination>
                    </div> -->
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
                serie: null,
                numero: null,
                fechaIni: null,
                fechaFin: null,
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
            
            this.loading_search = true;
            return this.$http.post(`/${this.resource}/get_failed_documents`, this.search).then((response) => {
                //console.log(response.data)
                this.records = response.data
                this.loading_search = false
            });

        },
        reprocessMasive(){

            this.loading_submit = true;
            this.$http.post(`/${this.resource}/process_failed_documents`, this.search).then((response) => {
                console.log(response.data)
                this.records = response.data
                this.loading_submit = false
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
