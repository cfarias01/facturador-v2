@php
    //$document_base = ($document->note) ? $document->note : null;

    //$path_style = app_path('CoreFacturalo'.DIRECTORY_SEPARATOR.'Templates'.DIRECTORY_SEPARATOR.'pdf'.DIRECTORY_SEPARATOR.'style.css');
    $document_number = $document->establecimiento.'-'.substr($returnPurchases->series,0,3).'-'.str_pad($returnPurchases->number, 9, '0', STR_PAD_LEFT);
    $str1 = explode("-", $document->secuencialDocAfectado);
    $str2 = explode("|", $document->correo);
    $fullStr = $str1[0].$str1[1].$str1[2];
    $affected_document_number = $document->secuencialDocAfectado;
    if ($document->adicionales != null) {
        $fixStr = rtrim($document->adicionales, ";");
        $str3 = explode(";", $fixStr);
        if (count($str3) > 0) {
            $infoMails = explode("=", $str3[0]);
            $arrayMails = explode("|", $infoMails[1]);
            for($info = 1; $info < count($str3); $info++) {
                $arrayStr[] = $str3[$info];
            };
            $addInfo = array_reduce($arrayStr, function ($carry, $kvp) {
            list($key, $value)=explode('=', $kvp);
            $carry[trim($key)]=trim($value);
            return $carry;
            }, []);
        }
    }

    $payments = $document->payments;


    $logo = "storage/uploads/logos/{$company->logo}";

    $totales = [];
    $subtotal = 0;

    foreach($details as $item){

        Log::info(json_encode($item));
        $existe = false;
        foreach ($totales as $key => $value) {
            if($value['tarifa'] == intVal($item['iva'])){
                $existe = true;
                $totales[$key]['iva'] += round(floatVal($item['total']) * ((intVal($item['iva'])/100)),2);
                $totales[$key]['subtotal'] += round(floatVal($item['total']),2);
            }
        }
        if( $existe ==  false){
            array_push($totales,[
                'tarifa'=> intVal($item['iva']),
                'iva' => round(floatVal($item['total']) * ((intVal($item['iva'])/100)),2),
                'subtotal' => round(floatVal($item['total']),2),
            ]);
        }
    }

    $hasFechaVencimiento = false;
    $hasFechaElaborado = false;
    $hasLote = false;
    foreach($returnPurchases->items as $row) {
        if (!empty($row['fecha_vencimiento'])) $hasFechaVencimiento = true;
        if (!empty($row['fecha_elaborado'])) $hasFechaElaborado = true;
        if (!empty($row['lote'])) $hasLote = true;
    }
    $numColumns = 6;
    if ($hasFechaVencimiento) $numColumns++;
    if ($hasFechaElaborado) $numColumns++;
    if ($hasLote) $numColumns++;

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
                    @if($company->logo)

                        <div class="company_logo_box">
                            <img src="data:{{mime_content_type(public_path("storage/uploads/logos/{$company->logo}"))}};base64, {{base64_encode(file_get_contents(public_path("storage/uploads/logos/{$company->logo}")))}}" alt="{{$company->name}}" class="company_logo" style="margin-left: 50px; padding-bottom: 40px; max-width: 150px;">
                        </div>

                    @endif
                    @if($company->emailLogo)

                        <div class="company_logo_box">
                            <img src="{{ $company->emailLogo }}" alt="{{$document->nombreComercial}}" class="company_logo" style="margin-left: 50px; padding-bottom: 40px; max-width: 150px" >
                        </div>

                    @endif
                    <table>
                        <tbody>
                            <tr>
                                <td style="text-transform: uppercase; background: #eaeaea; padding-left: 15px; padding-right: 15px; padding-bottom: 60px; padding-top: 15px;">
                                    <strong>Emisor: </strong>{{ $document->razonSocial }}<br></br>
                                    <strong>RUC: </strong>{{ $document->rucEmpresa }}<br></br>
                                    <strong>Matriz: </strong> <h7 style="text-transform: uppercase;">{{ ($document->direccionMatriz !== '')? $document->direccionMatriz : 'sin dirección' }}</h7><br></br>
                                    <strong>Establecimiento: </strong> <h7 style="text-transform: uppercase;">{{ ($document->direccionEstablecimiento !== '')? $document->direccionEstablecimiento : 'sin dirección' }}</h7><br></br>
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
                                    @if($company->rimpe_emp || $company->rimpe_np)
                                    <strong>CONTRIBUYENTE RÉGIMEN RIMPE</strong><br></br>
                                    @endif
                                    @if($company->detraction_account)
                                    <strong>{{$company->detraction_account}}</strong><br></br>
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
                                    <pre style="tab-size: 16; font-size: 14px"><strong>{{ $returnPurchases->document_type_description }}     </strong>     No.{{$document_number}}</pre>
                                </td>
                            </tr>
                            <tr>
                                <td style="background: #eaeaea; padding-top: 20px; padding-left: 15px; padding-right: 15px;">
                                    <strong>Número de Autorización:</strong>
                                    <br></br>
                                    <h6 style="font-size: 13px;">{{$document->claveAcceso}}</h6>
                                    <br></br>
                                    <br></br>
                                    <strong>Fecha y hora de Autorización:</strong>
                                    <br></br>
                                    {{$document->dateAuthorization}} {{ $document->timeAuthorization}}
                                    <br></br>
                                    <br></br>
                                    @if($returnPurchases->soap_type_id === '1')
                                    <strong>Ambiente: </strong>PRUEBAS
                                    <br></br>
                                    @endif
                                    @if($returnPurchases->soap_type_id === '3')
                                    <strong>Ambiente: </strong>INTERNO
                                    <br></br>
                                    @endif
                                    @if($returnPurchases->soap_type_id === '2')
                                    <strong>Ambiente: </strong>PRODUCCION
                                    <br></br>
                                    @endif
                                    <strong>Emisión: </strong>NORMAL
                                    <br></br>
                                    <strong>Clave de Acceso:</strong>
                                    <br></br>
                                    <div class="text-left">&nbsp;&nbsp;<img class="qr_code" src="data:image/png;base64, {{ $document->qr }}" /></div>
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
                            <strong>Razón Social/ Nombres y Apellidos: </strong>{{ $document->cliente }}<br></br>
                            <strong>Dirección: </strong> {{ $document->direccion }}<br></br>
                            <strong>Fecha Emisión: </strong> {{$returnPurchases->date_of_issue}}
                        </div>
                    </td>
                    <td style="text-transform: uppercase;" width="50%">
                        <div>
                            <br></br>
                            <strong>Identificación: </strong> {{ $returnPurchases->supplier_number }}<br></br><br></br>
                            <strong>Teléfono: </strong> {{ $document->telefono }}<br></br>
                            <strong>Correo: </strong>
                            @foreach($str2 as $email)
                            {{ $email }}
                            @endforeach
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <hr style="width: 97%; border-top: 1px solid #eaeaea;">
        <table class="full-width">
            <tbody>
                <tr>
                    <td style="text-transform: uppercase;">
                        <strong>Comprobante que se modifica: </strong>
                    </td>
                    <td>
                        <pre>FACTURA&nbsp;&nbsp;    {{ $affected_document_number }}</pre>
                    </td>
                </tr>
                <tr>
                    <td>
                        <strong>FECHA EMISIÓN (comprobante a modificar): </strong>
                    </td>
                    <td>
                        {{ $document->fechaDocSustento }}
                    </td>
                </tr>
                <tr>
                    <td style="text-transform: uppercase;">
                        <strong>Razón de Modificación: </strong>
                    </td>
                    <td>
                        {{ $document->motivoDev }}
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div>
        <table class="full-width mt-10 mb-10">
            <thead>
            <tr style="background: #eaeaea;">
                <th class="text-left py-1">CANT.</th>
                <th class="text-left py-2" >COD.</th>
                <th class="text-left py-3">DESCRIPCIÓN</th>
                @if($hasFechaElaborado)
                    <th class="text-left py-2" width="10%">F. ELAB</th>
                @endif
                @if($hasLote)
                    <th class="text-left py-2">LOTE</th>
                @endif
                @if($hasFechaVencimiento)
                    <th class="text-right py-2" width="10%">F. VENCE</th>
                @endif
                <th class="text-right py-1" width="10%">P.UNIT</th>
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
                        {!!$row['codItem']!!}
                    </td>
                    <td class="text-left align-top">
                        {!!$row['description']!!}
                    </td>
                    @if($hasFechaElaborado)
                        <td class="text-left align-top">{{ $row['fecha_elaborado'] ?? '' }}</td>
                    @endif
                    @if($hasLote)
                        <td class="text-left align-top" >{{ $row['lote'] ?? '' }}</td>
                    @endif
                    @if($hasFechaVencimiento)
                        <td class="text-right align-top">{{ $row['fecha_vencimiento'] ?? '' }}</td>
                    @endif
                    <td class="text-right align-top">{{ number_format($row['unit_price'], 2)}}</td>
                    <td class="text-right align-top">{{ number_format($row['descuento'], 2) }}</td>
                    <td class="text-right align-top pr-4">{{ number_format($row['total'], 2) }}</td>
                </tr>
                <tr style="background: #f7f7f5;">
                    <td colspan="{{ $numColumns }}"></td>
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
                            @if($document->adicionales != null)
                                @if(count($arrayMails) > 0)
                                    @foreach($arrayMails as $mails)
                                    <tr style="background: #f7f7f5;">
                                        <td width="40%" style="text-align: start; padding-left: 15px; padding-right: 15px;">{!!$infoMails[0]!!}</td>
                                        <td style="text-align: start; padding-left: 15px; padding-right: 15px;">{!!$mails!!}</td>
                                    </tr>
                                    @endforeach
                                @endif
                                @if(count($str3) > 0)
                                    @foreach($addInfo as $key => $value)
                                    <tr style="background: #f7f7f5;">
                                        <td style="text-align: start; padding-left: 15px; padding-right: 15px;">{!!$key!!}</td>
                                        <td style="text-align: start; padding-left: 15px; padding-right: 15px;">{!!$value!!}</td>
                                    </tr>
                                    @endforeach
                                @endif
                            @endif
                            </tbody>
                        </table>
                    </div>
                </td>
                <td width="40%">
                    <table class="full-width" style="border-spacing: 0px 5px; border-collapse: separate;">
                    @if ($returnPurchases->currency_type_id === 'USD')
                        @foreach( $totales as $total)
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Subtotal {{ $total['tarifa'] }}%:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format($total['subtotal'], 2) }}</td>
                        </tr>
                        @endforeach
                        @if ($document->tipoComprobante === '7')
                            @if($returnPurchases->total_taxed >= 0)
                            <tr>
                                <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">OP. GRAVADAS:</td>
                                <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format(($returnPurchases->total_taxed > 0 )? $returnPurchases->total_taxed : $returnPurchases->total_taxed * -1, 2) }}</td>
                            </tr>
                            @endif
                        @elseif($returnPurchases->total_taxed > 0)
                            <tr>
                                <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Subtotal Sin Impuestos:</td>
                                <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format(($document->importeSinImpuestos > -1)? $document->importeSinImpuestos : $document->importeSinImpuestos * -1, 2) }}</td>
                            </tr>
                        @endif
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Descuentos:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format(($document->descuento > -1) ? $document->descuento : $document->descuento * -1, 2) }}</td>
                        </tr>
                        <!-- JOINSOFTWARE -->
                        @foreach($totales as $total)
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">IVA {{$total['tarifa']}}%:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{$total['iva']}}</td>
                        </tr>
                        @endforeach
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Servicio %:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">$0.00</td>
                        </tr>
                        <tr>
                            <td style="padding-left: 15px; padding-right: 15px; background: #f7f7f5;">Valor Total:</td>
                            <td class="text-right" style="padding-left: 15px; padding-right: 15px; background: #eaeaea;">${{ number_format((($document->importeTotal > -1)?$document->importeTotal:$document->importeTotal * -1), 2) }}</td>
                        </tr>
                    @endif
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
</body>
</html>
