<?php

    use App\Models\Tenant\Configuration;

    $configuration = Configuration::first();
    $firstLevel = $path[0] ?? null;
    $secondLevel = $path[1] ?? null;
    $thridLevel = $path[2] ?? null;

?>
<aside id="sidebar-left"
       class="sidebar-left">
    <div class="sidebar-header">
        <a href="{{route('tenant.dashboard.index')}}"
           class="logo pt-2 pt-md-0">
            @if($vc_company->logo)
                <img src="{{ asset('storage/uploads/logos/'.$vc_company->logo) }}"
                alt="Logo"/>
            @elseif($vc_company->emailLogo)
                <img src="{{ $vc_company->emailLogo }}"
                     alt="Logo"/>
            @else
                <img src="{{asset('logo/tulogo.png')}}"
                     alt="Logo"/>
            @endif
        </a>
        <div class="d-md-none toggle-sidebar-left"
             data-toggle-class="sidebar-left-opened"
             data-target="html"
             data-fire-event="sidebar-left-opened">
            <i class="fas fa-bars"
               aria-label="Toggle sidebar"></i>
        </div>
    </div>
    <div class="nano">
        <div class="nano-content">
            <nav id="menu"
                 class="nav-main"
                 role="navigation">
                <ul class="nav nav-main">
                    @if(in_array('dashboard', $vc_modules))
                        <li class="{{ ($firstLevel === 'dashboard')?'nav-active':'' }}">
                            <a class="nav-link"
                               href="{{ route('tenant.dashboard.index') }}">
                                <svg xmlns="http://www.w3.org/2000/svg"
                                     width="24"
                                     height="24"
                                     viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round"
                                     class="feather feather-airplay">
                                    <path d="M5 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-1"></path>
                                    <polygon points="12 15 17 21 7 21 12 15"></polygon>
                                </svg>
                                <span>DASHBOARD</span>
                            </a>
                        </li>
                    @endif

                    {{-- Ventas --}}
                    @if(in_array('documents', $vc_modules))
                        <li class="
                        nav-parent
                        {{ ($firstLevel === 'documents')?'nav-active nav-expanded':'' }}
                            ">
                            <a class="nav-link"
                               href="#">
                                <svg xmlns="http://www.w3.org/2000/svg"
                                     width="24"
                                     height="24"
                                     viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round"
                                     class="feather feather-file-text">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                    <line x1="16"
                                          y1="13"
                                          x2="8"
                                          y2="13"></line>
                                    <line x1="16"
                                          y1="17"
                                          x2="8"
                                          y2="17"></line>
                                    <polyline points="10 9 9 9 8 9"></polyline>
                                </svg>
                                <span>EMITIDOS</span>
                            </a>
                            <ul class="nav nav-children"
                                style="">
                                @if(in_array('documents', $vc_modules) && $vc_company->soap_type_id != '03')
                                    @if(in_array('list_document', $vc_module_levels))
                                        <li class="{{ ($firstLevel === 'documents' && $secondLevel !== 'received' && $secondLevel !== 'returned' && $secondLevel !== 'failed' && $secondLevel !== 'create' && $secondLevel !== 'not-sent'&& $secondLevel != 'regularize-shipping')?'nav-active':'' }}">
                                            <a class="nav-link"
                                               href="{{route('tenant.documents.index')}}">Listado de comprobantes</a>
                                        </li>

                                        <li class="{{ ($firstLevel === 'documents' && $secondLevel !== 'received' && $secondLevel !== 'returned' && $secondLevel === 'failed')?'nav-active':'' }}">
                                            <a class="nav-link"
                                               href="{{route('tenant.documents.failed.index')}}">No cargados</a>
                                        </li>

                                        <li class="{{ ($firstLevel === 'documents' && $secondLevel !== 'received' && $secondLevel === 'returned')?'nav-active':'' }}">
                                            <a class="nav-link"
                                               href="{{route('tenant.documents.returned.index')}}">Devueltos SRI</a>
                                        </li>
                                           
                                    @endif
                                @endif
                            </ul>
                        </li>
                    @endif

                    @if(auth()->user()->type != 'integrator')
                        @if(in_array('purchases', $vc_modules))
                            <li class="
                            nav-parent
                            {{ (
	                            $firstLevel === 'purchases' ||
                                ($firstLevel === 'persons' && $secondLevel === 'suppliers')
                                ) ?'nav-active nav-expanded':'' }}
                                ">
                                <a class="nav-link"
                                   href="#">
                                    <svg xmlns="http://www.w3.org/2000/svg"
                                         width="24"
                                         height="24"
                                         viewBox="0 0 24 24"
                                         fill="none"
                                         stroke="currentColor"
                                         stroke-width="2"
                                         stroke-linecap="round"
                                         stroke-linejoin="round"
                                         class="feather feather-shopping-bag">
                                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
                                        <line x1="3"
                                              y1="6"
                                              x2="21"
                                              y2="6"></line>
                                        <path d="M16 10a4 4 0 0 1-8 0"></path>
                                    </svg>
                                    <span>RECIBIDOS</span>
                                </a>
                                <ul class="nav nav-children">
                                    @if(in_array('purchases_list', $vc_module_levels))
                                        <li class="{{ ($firstLevel === 'purchases' && $secondLevel !== 'received2' && $secondLevel !== 'received' && $secondLevel != 'create')?'nav-active':'' }}">
                                            <a class="nav-link"
                                               href="{{route('tenant.purchases.index')}}">Listado</a>
                                        </li>
                                        <li class="{{ ($firstLevel === 'purchases' && $secondLevel !== 'received2' && $secondLevel === 'received')?'nav-active':'' }}">
                                            <a class="nav-link"
                                               href="{{route('tenant.documents_received.index')}}">Resumen Cargados</a>
                                        </li>
                                        <li class="{{ ($firstLevel === 'purchases' && $secondLevel === 'received2')?'nav-active':'' }}">
                                            <a class="nav-link"
                                               href="{{route('tenant.documents_received.index2')}}">Documento Cargados</a>
                                        </li>
                                    @endif
                                </ul>
                            </li>
                        @endif
                    @endif
                    @if(in_array('establishments', $vc_modules))
                        <li class="nav-parent {{ in_array($firstLevel, ['users', 'establishments'])?'nav-active nav-expanded':'' }}">
                            <a class="nav-link"
                               href="#">
                                <svg xmlns="http://www.w3.org/2000/svg"
                                     width="24"
                                     height="24"
                                     viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round"
                                     class="feather feather-users">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9"
                                            cy="7"
                                            r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                                <span>Usuarios/Locales & Series</span>
                            </a>
                            <ul class="nav nav-children"
                                style="">
                                @if(in_array('users', $vc_module_levels))
                                    <li class="{{ ($firstLevel === 'users')?'nav-active':'' }}">
                                        <a class="nav-link"
                                           href="{{route('tenant.users.index')}}">Usuarios</a>
                                    </li>
                                @endif
                                @if(in_array('users_establishments', $vc_module_levels))
                                    <li class="{{ ($firstLevel === 'establishments')?'nav-active':'' }}">
                                        <a class="nav-link"
                                           href="{{route('tenant.establishments.index')}}">Establecimientos</a>
                                    </li>
                                @endif
                            </ul>
                        </li>
                    @endif
                    @if(in_array('configuration', $vc_modules))
                        <li class="{{in_array($firstLevel, ['list-platforms', 'list-cards', 'list-currencies', 'list-bank-accounts', 'list-banks', 'list-attributes', 'list-detractions', 'list-units', 'list-payment-methods', 'list-incomes', 'list-payments', 'company_accounts', 'list-vouchers-type',     'companies', 'advanced', 'tasks', 'inventories','bussiness_turns','offline-configurations','series-configurations','configurations', 'login-page', 'list-settings']) ? 'nav-active' : ''}}">
                            <a class="nav-link"
                               href="{{ url('list-settings') }}">
                                <svg xmlns="http://www.w3.org/2000/svg"
                                     width="24"
                                     height="24"
                                     viewBox="0 0 24 24"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     stroke-linecap="round"
                                     stroke-linejoin="round"
                                     class="feather feather-settings">
                                    <circle cx="12"
                                            cy="12"
                                            r="3"></circle>
                                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                                </svg>
                                <span>Configuración</span>
                            </a>
                        </li>
                    @endif
                </ul>
            </nav>
        </div>
        <script>
            // Maintain Scroll Position
            if (typeof localStorage !== 'undefined') {
                if (localStorage.getItem('sidebar-left-position') !== null) {
                    var initialPosition = localStorage.getItem('sidebar-left-position'),
                        sidebarLeft = document.querySelector('#sidebar-left .nano-content');
                    sidebarLeft.scrollTop = initialPosition;
                }
            }
        </script>
    </div>
</aside>
