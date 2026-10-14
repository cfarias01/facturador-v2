<template>
    <div id="styleSwitcher" class="style-switcher">

        <a id="styleSwitcherOpen" class="style-switcher-open" href="#">
            <i class="fas fa-paint-brush"></i>
        </a>

        <form class="style-switcher-wrap" autocomplete="off">
            <h4>Configuraciones visuales</h4>
            <div v-if="visual == null">
                <h5 class="">No posee ajustes actualmente</h5>
                <a href="" class="text-warning" v-if="typeUser != 'integrator'">cargar ajustes por defecto</a>
                <br>
            </div>
            <div v-if="typeUser != 'integrator'" class="pt-3">
                <div class="text-right">
                    <a v-if="visuals.bg == 'white'"
                        href="/configurations/change-mode"
                        class="notification-icon text-secondary"
                        data-toggle="tooltip"
                        data-placement="bottom"
                        title="Modo noche"
                        style="text-decoration: none;">
                        <i class="fas fa-2x fa-moon"></i>
                    </a>
                    <a v-if="visuals.bg == 'dark'"
                        href="/configurations/change-mode"
                        class="notification-icon text-white"
                        data-toggle="tooltip"
                        data-placement="bottom"
                        title="Modo día"
                        style="text-decoration: none;">
                        <i class="fa-2x wi-sun"></i>
                    </a>
                </div>

                <div class="pt-3">
                    <h5>Tema de color</h5>
                    <div class="sia-themes">
                        <button v-for="theme in themes"
                                :key="theme.key"
                                type="button"
                                class="sia-theme"
                                :class="{ 'is-active': currentTheme === theme.key }"
                                :title="theme.name"
                                @click="onChangeBgSidebar(theme.key)">
                            <span class="sia-theme__preview">
                                <span class="sia-theme__sidebar" :style="{ background: theme.sidebar }">
                                    <span class="sia-theme__item" :style="{ background: theme.accent }"></span>
                                    <span class="sia-theme__line" :style="{ background: theme.line }"></span>
                                    <span class="sia-theme__line" :style="{ background: theme.line }"></span>
                                </span>
                                <span class="sia-theme__content">
                                    <span class="sia-theme__bar" :style="{ background: theme.accent }"></span>
                                    <span class="sia-theme__row"></span>
                                    <span class="sia-theme__row"></span>
                                </span>
                                <i v-if="currentTheme === theme.key" class="fas fa-check sia-theme__check" :style="{ background: theme.accent }"></i>
                            </span>
                            <span class="sia-theme__name">{{ theme.name }}</span>
                        </button>
                    </div>
                </div>

                <div class="pt-3">
                    <h5>Menú lateral contraído</h5>
                    <div :class="{'has-danger': errors.compact_sidebar}">
                        <el-switch
                            v-model="form.compact_sidebar"
                            active-text="Si"
                            inactive-text="No"
                            @change="submitForm">
                        </el-switch>
                        <br>
                        <small class="form-control-feedback" v-if="errors.compact_sidebar" v-text="errors.compact_sidebar[0]"></small>
                    </div>
                </div>

                <div class="pt-3">
                    <h5>Cantidad de columnas en POS</h5>
                    <div :class="{'has-danger': errors.amount_plastic_bag_taxes}">
                        <el-slider
                            @change="submitForm"
                            v-model="form.colums_grid_item"
                            :min="3"
                            :max="6">
                        </el-slider>
                        <small class="form-control-feedback" v-if="errors.amount_plastic_bag_taxes" v-text="errors.amount_plastic_bag_taxes[0]"></small>
                    </div>
                </div>

                <div class="pt-3">
                    <h5>Cambiar tema</h5>
                    <div :class="{'has-danger': errors.compact_sidebar}">
                        <el-select
                            v-model="form.skin_id"
                            placeholder="Tema"
                            @change="submitForm"
                            class="pb-3">
                            <el-option
                                v-for="item in skins"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                            </el-option>
                        </el-select>
                        <small class="form-control-feedback" v-if="errors.compact_sidebar" v-text="errors.compact_sidebar[0]"></small>
                        <el-button type="button" @click="dialogSkins()" color="primary">Subir tema</el-button>
                    </div>
                </div>

            </div>
        </form>
        <dialog-skins :showDialog.sync="dialogSkinsVisible" :skins.sync="skins"/>
    </div>
</template>

<script>
    import DialogSkins from './partials/dialog_skins.vue'
    export default {
        props:['visual','typeUser'],
        components: {
            DialogSkins
        },
        data() {
            return {
                loading_submit: false,
                resource: 'configurations',
                errors: {},
                form: {},
                visuals: {},
                skins: {},
                dialogSkinsVisible: false,
                // Mismos temas que ConfigurationVisualViewComposer::SIA_THEMES y public/css/sia-tenant.css
                themes: [
                    {key: 'sia', name: 'SIA', sidebar: '#414141', accent: '#9AC446', line: 'rgba(255,255,255,.35)'},
                    {key: 'oceano', name: 'Océano', sidebar: '#0F2A44', accent: '#2F80ED', line: 'rgba(255,255,255,.35)'},
                    {key: 'violeta', name: 'Violeta', sidebar: '#2E2250', accent: '#7C5CFC', line: 'rgba(255,255,255,.35)'},
                    {key: 'medianoche', name: 'Medianoche', sidebar: '#111827', accent: '#10B981', line: 'rgba(255,255,255,.35)'},
                    {key: 'vino', name: 'Vino', sidebar: '#3A1F24', accent: '#E25563', line: 'rgba(255,255,255,.35)'},
                    {key: 'claro', name: 'Claro', sidebar: '#FFFFFF', accent: '#9AC446', line: 'rgba(65,65,65,.25)'},
                ],
                legacyThemes: {
                    white: 'claro', blue: 'violeta', green: 'sia', red: 'vino', dark: 'medianoche',
                    gray: 'sia', warning: 'sia', 'ligth-blue': 'oceano',
                },
            }
        },
        computed: {
            currentTheme() {
                const saved = this.visuals ? this.visuals.sidebar_theme : null;
                const theme = this.legacyThemes[saved] || saved;
                return this.themes.some(t => t.key === theme) ? theme : 'sia';
            },
        },
        async created() {
            await this.initForm()
            await this.getRecords()
        },
        methods: {
            onChangeBgSidebar(theme) {
                // Vista previa inmediata mientras se guarda (submit recarga la página)
                const html = document.documentElement;
                html.className = html.className.replace(/\bsia-theme-[a-z]+\b/g, '').trim() + ' sia-theme-' + theme;
                this.$set(this.visuals, 'sidebar_theme', theme);
                this.submit();
            },
            initForm() {
                this.errors = {}
                this.form = {
                    id: 1,
                    compact_sidebar: true,
                    colums_grid_item: 4,
                    enable_whatsapp: true,
                    phone_whatsapp: '',
                    skins: 1,
                }
            },
            getRecords() {
                this.$http.get(`/${this.resource}/record`) .then(response => {
                    if (response.data !== ''){
                        this.visuals = response.data.data.visual;
                        this.form = response.data.data;
                        this.skins = response.data.data.skins;
                    }
                });
            },
            submit() {
                this.visuals.navbar = 'fixed';
                this.$http.post(`/${this.resource}/visual_settings`, this.visuals).then(response => {
                    if (response.data.success) {
                        this.$message.success(response.data.message);
                    }
                    else {
                        this.$message.error(response.data.message);
                    }
                }).catch(error => {
                    if (error.response.status === 422) {
                        this.errors = error.response.data.errors;
                    }
                    else {
                        console.log(error);
                    }
                }).then(() => {
                    location.reload();
                });
            },
            submitForm() {
                this.loading_submit = true;
                this.$http.post(`/${this.resource}`, this.form).then(response => {
                    if (response.data.success) {
                        this.$message.success(response.data.message);
                        location.reload()
                    }
                    else {
                        this.$message.error(response.data.message);
                    }
                }).catch(error => {
                    if (error.response.status === 422) {
                        this.errors = error.response.data.errors;
                    }
                    else {
                        console.log(error);
                    }
                }).then(() => {
                    this.loading_submit = false;
                });
            },
            dialogSkins() {
                this.dialogSkinsVisible = true
            },
        }
    }
</script>
<style scoped lang=scss>
.el-custom-control{
    display: flex;
    align-content: center;
    .btn{
        margin-right: .5rem;
        $size: 20px;
        width: $size;
        height: $size;
        border-radius: 2px;
        border: 1px solid #f6f6f6;
        padding: 0;
        &.active{
            box-shadow: 0 0 0 0.2rem rgba(38, 143, 255, .5);
        }
    }
}

.sia-themes {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 10px;
}

.sia-theme {
    display: flex;
    flex-direction: column;
    align-items: stretch;
    gap: 6px;
    padding: 0;
    background: transparent;
    border: 0;
    cursor: pointer;

    &__preview {
        position: relative;
        display: flex;
        height: 52px;
        border-radius: 10px;
        overflow: hidden;
        border: 2px solid #E4E8DC;
        background: #fff;
        transition: border-color .15s ease, box-shadow .15s ease, transform .15s ease;
    }

    &__sidebar {
        width: 34%;
        padding: 6px 4px;
        display: flex;
        flex-direction: column;
        gap: 4px;
    }

    &__item {
        height: 7px;
        border-radius: 3px;
    }

    &__line {
        height: 4px;
        width: 80%;
        border-radius: 2px;
    }

    &__content {
        flex: 1;
        padding: 6px;
        display: flex;
        flex-direction: column;
        gap: 4px;
        background: #F7F8F5;
    }

    &__bar {
        height: 6px;
        width: 60%;
        border-radius: 3px;
    }

    &__row {
        height: 5px;
        border-radius: 2px;
        background: #E2E5DD;
    }

    &__check {
        position: absolute;
        right: 4px;
        bottom: 4px;
        width: 16px;
        height: 16px;
        border-radius: 50%;
        color: #fff;
        font-size: 9px;
        line-height: 16px;
        text-align: center;
    }

    &__name {
        font-size: 11px;
        font-weight: 600;
        color: #6B6B6B;
        text-align: center;
    }

    &:hover &__preview {
        transform: translateY(-2px);
        box-shadow: 0 6px 14px rgba(0, 0, 0, .12);
    }

    &.is-active &__preview {
        border-color: #414141;
        box-shadow: 0 6px 14px rgba(0, 0, 0, .15);
    }

    &.is-active &__name {
        color: #414141;
    }
}
</style>
