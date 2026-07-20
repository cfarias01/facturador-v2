<?php

    namespace App\Http\Middleware;

    use Closure;
    use Illuminate\Http\RedirectResponse;
    use Illuminate\Http\Request;
    use Illuminate\Support\Facades\Route;
    use Modules\LevelAccess\Traits\SystemActivityTrait;

    /**
     * Class RedirectModule
     *
     * @package App\Http\Middleware
     */
    class RedirectModule
    {

        use SystemActivityTrait;

        private $route_path;

        /**
         * Handle an incoming request.
         *
         * @param Request $request
         * @param Closure $next
         *
         * @return mixed
         */
        public function handle($request, Closure $next)
        {

            $module = $request->user()->getModule();
            $path = explode('/', $request->path());
            $modules = $request->user()->getModules();
            $this->route_path = $request->path();

            if (!$request->ajax()) {

                if (count($modules)) {

                    $group = $this->getGroup($path, $module);

                    if ($group) {
                        if ($this->getModuleByGroup($modules, $group) === 0) {
                            return $this->redirectRoute($module);
                        }
                    }

                }
            }

            return $next($request);

        }

        /**
         * @param $path
         * @param $module
         *
         * @return string
         */
        private function getGroup($path, $module)
        {

            $firstLevel = $path[0] ?? null;
            $secondLevel = $path[1] ?? null;
            $group = null;
            ///* Module Documents */
            if (
                $firstLevel == "documents" ||
                $firstLevel == "dashboard" ||
                $firstLevel == "quotations" ||
                $firstLevel == "items" ||
                $firstLevel == "summaries" ||
                $firstLevel == "voided") {
                $group = "documents";
            } ///* Module purchases  */
            elseif (
                $firstLevel == "purchases" ||
                $firstLevel == "expenses") {
                $group = "purchases";
            } ///* Module advanced */
            elseif (
                $firstLevel == "retentions" ||
                $firstLevel == "dispatches" ||
                $firstLevel == "perceptions") {
                $group = "advanced";
            } ///* Module reports */
            elseif (
                $firstLevel == "list-reports" ||
                ($firstLevel == "reports" && $secondLevel == "purchases") ||
                ($firstLevel == "reports" && $secondLevel == "sales") ||
                ($firstLevel == "reports" && $secondLevel == "consistency-documents")) {
                $group = "reports";
            } // cuenta / listado de pagos
            elseif (
                $firstLevel == "cuenta") {
                $group = "cuenta";
            } ///* Module configuration */
            elseif (
                $firstLevel == "users" ||
                $firstLevel == "establishments") {
                $group = "establishments";
                // $group = "configuration";
            }//
            elseif (
                $firstLevel == "companies") {
                $group = "configuration";
                if (count($path) > 0 && $secondLevel == "uploads" && $module == "documents") {
                    $group = "documents";
                }
            }//
            elseif (
                $firstLevel == "catalogs" ||
                $firstLevel == "advanced") {
                $group = "configuration";
            } ///* Determinate type person */
            elseif (
                $firstLevel == "persons") {
                if ($secondLevel == "suppliers") {
                    $group = "purchases";
                }//
                elseif ($secondLevel == "customers") {
                    $group = "persons";
                } else {
                    $group = null;
                }
            }//
            elseif (
                $firstLevel == "person-types") {
                $group = "persons";
            } ///* Module pos */
            elseif (
                $firstLevel == "pos" ||
                $firstLevel == "cash") {
                $group = "pos";
            } ///* Module inventory */
            elseif (
                $firstLevel == "warehouses"||
                $firstLevel == "inventory" ||
                ($firstLevel == "reports" && $secondLevel == "kardex") ||
                ($firstLevel == "reports" && $secondLevel == "inventory")) {
                $group = "inventory";
            } ///* Module accounting */
            elseif (
                $firstLevel == "account") {
                $group = "accounting";
            } ///* Module finance */
            elseif (
                $firstLevel == "finances") {
                $group = "finance";
            }//
            elseif (
                $firstLevel == "orders" ||
                ($firstLevel == "ecommerce" && $secondLevel == "configuration") ||
                $firstLevel == "items_ecommerce" ||
                $firstLevel == "tags" ||
                $firstLevel == "promotions") {
                $group = "ecommerce";
            }//
            elseif (
                $firstLevel == "hotels" ||
                ($firstLevel == "hotels" && $secondLevel == "document-hotels")) {
                $group = "hotels";
            }//
            elseif (
                $firstLevel == "documentary-procedure") {
                $group = "documentary-procedure";
            }//
            elseif (
                $firstLevel == "digemid") {
                $group = "digemid";
            }//
            elseif (
                $firstLevel == "suscription") {
                $group = "suscription_app";
            }

            return $group;
        }

        /**
         * @param $modules
         * @param $group
         *
         * @return mixed
         */
        private function getModuleByGroup($modules, $group)
        {

            $modules_x_group = $modules->filter(function ($module, $key) use ($group) {
                return $module->value === $group;
            });

            return $modules_x_group->count();
        }

        /**
         * @param $module
         *
         * @return RedirectResponse
         */
        private function redirectRoute($module)
        {
            // registrar log de actividades cuando el usuario no tiene permiso al modulo
            $this->saveGeneralSystemActivity(auth()->user(), 'module_access_error', $this->route_path);

            $routes = [
                'pos' => 'tenant.pos.index',
                'documents' => 'tenant.documents.create',
                'purchases' => 'tenant.documents_received.index',
                'advanced' => 'tenant.retentions.index',
                'reports' => 'tenant.reports.purchases.index',
                'configuration' => 'tenant.companies.create',
                'inventory' => 'warehouses.index',
                'accounting' => 'tenant.account.index',
                'finance' => 'tenant.finances.global_payments.index',
                'establishments' => 'tenant.users.index',
                'documentary-procedure' => 'tenant.hotels.index',
                'hotels' => 'tenant.hotels.index',
                'digemid' => 'tenant.digemid.index',
                'suscription_app' => 'tenant.suscription.client.index',
            ];

            // Algunos de estos destinos ya no existen (controladores retirados en
            // limpiezas anteriores); si el destino esperado no esta definido, cae
            // al dashboard en vez de lanzar RouteNotFoundException.
            $route = $routes[$module] ?? null;

            if ($route && Route::has($route)) {
                return redirect()->route($route);
            }

            return redirect()->route('tenant.dashboard.index');
        }

    }
