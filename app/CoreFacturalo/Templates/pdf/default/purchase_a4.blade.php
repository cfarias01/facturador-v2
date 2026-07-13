@php
    //$document_base = ($document->note) ? $document->note : null;

    //$path_style = app_path('CoreFacturalo'.DIRECTORY_SEPARATOR.'Templates'.DIRECTORY_SEPARATOR.'pdf'.DIRECTORY_SEPARATOR.'style.css');
    $document_number = $document->estab.''.substr($returnPurchases->series,0,3).''.str_pad($returnPurchases->number, 9, '0', STR_PAD_LEFT);
    //$accounts = \App\Models\Tenant\BankAccount::where('show_in_documents', true)->get();

    /*
    if($document_base) {

        $affected_document_number = ($document_base->affected_document) ? $document_base->affected_document->series.'-'.str_pad($document_base->affected_document->number, 8, '0', STR_PAD_LEFT) : $document_base->data_affected_document->series.'-'.str_pad($document_base->data_affected_document->number, 8, '0', STR_PAD_LEFT);

    } else {

        $affected_document_number = null;
    }
    */

    $payments = $document->payments;

    //$document->load('reference_guides');

    //$total_payment = $document->payments->sum('payment');
    //$balance = ($document->total - $total_payment) - $document->payments->sum('change');

    //$configuration_decimal_quantity = App\CoreFacturalo\Helpers\Template\TemplateHelper::getConfigurationDecimalQuantity();

    /*
    $total12=0;
    $totalIVA12=0;

    $total8=0;
    $totalIVA8=0;

    $total0=0.00;
    $totalIVA0=0.00;

    $total14=0;
    $totalIVA14=0;

    foreach($returnPurchases->items as $item){

        if($item->affectation_igv_type_id === '10'){
            //JOINSOFTWARE
            $total12=$total12 + $item->total_value;
            $totalIVA12= $totalIVA12 + $item->total_taxes;
        }
        if($item->affectation_igv_type_id === '11'){
            //JOINSOFTWARE
            $total8=$total8 + $item->total_value;
            $totalIVA8= $totalIVA8 + $item->total_taxes;
        }
        if($item->affectation_igv_type_id === '12'){
            //JOINSOFTWARE
            $total14=$total14 + $item->total_value;
            $totalIVA14= $totalIVA14 + $item->total_taxes;
        }
        if($item->affectation_igv_type_id === '30'){
            //JOINSOFTWARE
            $total0=$total0 + $item->total_value;
            $totalIVA0= $totalIVA0 + $item->total_taxes;
        }
    }
    */
@endphp


<html>
<head>
</head>
<body>
    <!-- Separeted code2 -->
    <!-- Code from JOINSOFTWARE -->

    <table class="full-width">
        <tbody>
            <tr>
                <td width="50%">
                    <table>
                        <tbody>
                            <tr>
                                <td style="text-transform: uppercase; background: #eaeaea; padding-left: 15px; padding-right: 15px; padding-bottom: 60px; padding-top: 15px;">
                                    <strong>Emisor: </strong>{{ $document->razonSocial }}<br></br>
                                    <strong>RUC: </strong>{{ $document->ruc }}<br></br>
                                    <strong>Matriz: </strong> <h7 style="text-transform: uppercase;">{{ ($document->dirEstablecimiento !== '')? $document->dirEstablecimiento : 'sin dirección' }}</h7><br></br>
                                    @if($document->obligadoContabilidad === 'SI')
                                    <strong>Obligado a llevar contabilidad: </strong>SI<br></br>
                                    @else
                                    <strong>Obligado a llevar contabilidad: </strong>NO<br></br>
                                    @endif
                                    @if($company->contribuyente_especial)
                                    <strong>Contribuyente especial: </strong>{{ $company->contribuyente_especial_num }}<br></br>
                                    @endif
                                    @if($company->agente_retencion)
                                    <strong>Agente de Retención Resolución No.: </strong>{{ $company->agente_retencion_num }}<br></br>
                                    @endif
                                    @if($document->contribuyenteRimpe !== null)
                                    <strong>CONTRIBUYENTE RÉGIMEN RIMPE</strong><br></br>
                                    @endif
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
                <td width="50%">
                    <table>
                        <tbody>
                            <tr>
                                <td style="background: #eaeaea; height: 30px;"></td>
                            </tr>
                            <tr>
                                <td style="padding: 10px 15px 10px 15px; text-align: center;">
                                    <pre style="tab-size: 16; font-size: 14px"><strong>FACTURA         </strong>         No.{{$document_number}}</pre>
                                </td>
                            </tr>
                            <tr>
                                <td style="background: #eaeaea; padding-top: 20px; padding-left: 15px; padding-right: 15px;">
                                    <strong>Número de Autorización:</strong>
                                    <br></br>
                                    <h6 style="font-size: 13px;">{{$document->claveAcceso}}</h6>
                                    <br></br>
                                    <br></br>
                                    <!--
                                    <strong>Fecha y hora de Autorización:</strong>
                                    <br></br>
                                    {{$document->date_authorization}} {{ $document->time_authorization}}
                                    <br></br>
                                    <br></br>
                                    -->
                                    @if($company->soap_type_id === '01')
                                    <strong>Ambiente: </strong>PRUEBAS
                                    <br></br>
                                    @endif
                                    @if($company->soap_type_id === '03')
                                    <strong>Ambiente: </strong>INTERNO
                                    <br></br>
                                    @endif
                                    @if($company->soap_type_id === '02')
                                    <strong>Ambiente: </strong>PRODUCCION
                                    <br></br>
                                    @endif
                                    <strong>Emisión: </strong>NORMAL
                                    <br></br>
                                    <strong>Clave de Acceso:</strong>
                                    <br></br>
                                    <!--
                                    <div class="text-left">&nbsp;&nbsp;<img class="qr_code" src="data:image/png;base64, {{ $document->qr }}" /></div>
                                    -->
                                    <h6 style="font-size: 13px;">{{ $document->claveAcceso }}</h6>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
    <div style=" background: #eaeaea; padding-bottom: 20px; padding-left: 15px; padding-right: 15px;">
        <table class="full-width">
            <tbody>
                <tr>
                    <td style="text-transform: uppercase;" width="50%">
                        <div>
                            <strong>Razón Social/ Nombres y Apellidos: </strong>{{ $document->razonSocialComprador }}<br></br>
                            <strong>Dirección: </strong> {{ $document->direccionComprador }}<br></br>
                            <strong>Fecha Emisión: </strong> {{$returnPurchases->date_of_issue}}
                        </div>
                    </td>
                    <td style="text-transform: uppercase;" width="50%">
                        <div>
                            <br></br>
                            <strong>Identificación: </strong> {{ $document->identificacionComprador }}<br></br><br></br>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div>
        <table class="full-width mt-10 mb-10">
            <thead>
            <tr style="background: #eaeaea;">
                <th class="text-center py-2 pl-4" width="10%">CANT.</th>
                <!--
                <th class="text-center py-2" width="8%">UNIDAD</th>
                -->
                <th class="text-left py-2">DESCRIPCIÓN</th>
                <th class="text-left py-2">MODELO/REF</th>
                <!--
                <th class="text-center py-2" width="8%">LOTE</th>
                <th class="text-center py-2" width="8%">SERIE</th>
                -->
                <th class="text-right py-2" width="12%">P.UNIT</th>
                <th class="text-right py-2" width="8%">DTO.</th>
                <th class="text-right py-2 pr-4" width="12%">TOTAL</th>
            </tr>
            </thead>
            <tbody>
            @foreach($returnPurchases->items as $row)
                <tr style="background: #f7f7f5;">
                    <td class="text-left align-top pl-4">
                        @if(((int)$row['quantity'] != $row['quantity']))
                            {{ $row['quantity'] }}
                        @else
                            {{ number_format($row['quantity'], 0) }}
                        @endif
                    </td>
                    <td class="text-left align-top">
                        {!!$row['description']!!}
                    </td>
                    <td class="text-left align-top">{{ $row['model'] ?? '' }}</td>
                    <!-- JOINSOFTWARE -->
                    <td class="text-right align-top">{{ number_format($row['unit_price'], 2) }}</td>
                    <td class="text-right align-top">
                        @if($row['discounts'])
                            {{ number_format($row['discounts'], 2) }}
                        @else
                        0
                        @endif
                    </td>
                    <td class="text-right align-top pr-4">{{ number_format($row['total'], 2) }}</td>
                </tr>
                <tr style="background: #f7f7f5;">
                    <td colspan="6"></td>
                </tr>
            @endforeach
            </tbody>
        </table>
    </div>

    <table class="full-width">
        <tbody>
            <tr>
                <td width="60%" style="position: relative;">
                    <div style="position: absolute; width: 50%; padding-top: 7px; padding-bottom: 7px">
                        <table class="full-width">
                            <thead class="">
                                <tr style="background: #eaeaea;">
                                    <th class="py-2" style="text-align: start; padding-left: 15px; padding-right: 15px;">Información Adicional</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                        <table class="full-width">
                            <thead class="">
                                <tr style="background: #eaeaea;">
                                    <th class="py-2" style="text-align: start; padding-left: 15px; padding-right: 15px;">Formas de pago</th>
                                </tr>
                            </thead>
                            <tbody>
                            @foreach($returnPurchases->payments as $pago)
                                @if ($returnPurchases->currency_type_id === 'USD')
                                <tr style="background: #f7f7f5;">
                                    <td style="text-align: start; padding-left: 15px; padding-right: 15px;">{{ $pago->descripcion }}</td>
                                    <td style="text-align: start; padding-left: 15px; padding-right: 15px;">${{ number_format($pago->totalP, 2) }}</td>
                                    <td style="text-align: start; padding-left: 15px; padding-right: 15px;">{{ $pago->plazoP }} {{ $pago->unidadTiempoP }}</td>
                                </tr>
                                @endif
                            @endforeach
                            </tbody>
                        </table>
                    </div>
                </td>
                <td width="40%">
                    <table class="full-width" style="border-spacing: 0px 5px; border-collapse: separate;">
                    @if ($returnPurchases->currency_type_id === 'USD')
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Subtotal 0%:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format($returnPurchases->total_unaffected, 2) }}</td>
                        </tr>
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Subtotal 12%:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format($returnPurchases->total_taxed, 2) }}</td>
                        </tr>
                        @if ($document->codDoc === '07')
                            @if($returnPurchases->total_taxed >= 0)
                            <tr>
                                <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">OP. GRAVADAS:</td>
                                <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format($returnPurchases->total_taxed, 2) }}</td>
                            </tr>
                            @endif
                        @elseif($returnPurchases->total_taxed > 0)
                            <tr>
                                <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Subtotal Sin Impuestos:</td>
                                <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format($document->totalSinImpuestos, 2) }}</td>
                            </tr>
                        @endif
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Descuentos:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format($document->totalDescuento, 2) }}</td>
                        </tr>
                        <!-- JOINSOFTWARE -->
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">IVA 0%:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">$0.00</td>
                        </tr>
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">IVA 12%:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format($returnPurchases->total_igv, 2) }}</td>
                        </tr>
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Servicio %:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">$0.00</td>
                        </tr>
                        @if($returnPurchases->total_perception)
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">IMPORTE TOTAL:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format($document->importeTotal, 2) }}</td>
                        </tr>
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">PERCEPCIÓN:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format($returnPurchases->total_perception, 2) }}</td>
                        </tr>
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">TOTAL:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format(($returnPurchases->total + $returnPurchases->total_perception), 2) }}</td>
                        </tr>
                        @else
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Valor Total:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format(($returnPurchases->total - $document->totalDescuento), 2) }}</td>
                        </tr>
                        <!--
                        @endif
                        -->
                    @endif
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
</body>
</html>
