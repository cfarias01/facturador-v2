@php
    $document_number = $document->establecimiento.''.substr($document->ptoEmision,0,3).''.str_pad($document->secuencial, 9, '0', STR_PAD_LEFT);
    //$str =  asset("storage/uploads/logos/".$company->logo);
    //$imgCompany = base_path().'/public/storage/uploads/logos/'.$company->logo;
    //$url = explode('#', $str);
    $document_type_description = 'COMPROBANTE';
    if($document->tipoComprobante == '1'){
        $document_type_description = 'FACTURA';
    }elseif($document->tipoComprobante == '7'){
        $document_type_description = 'COMPROBANTE DE RETENCIÓN';
    }elseif($document->tipoComprobante == '4'){
        $document_type_description = 'NOTA DE CRÉDITO';
    }  elseif($document->tipoComprobante == '3'){
        $document_type_description = 'LIQUIDACIÓN DE COMPRA';
    }
@endphp

<!doctype html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0">
        <title>Envio de Comprobante de Pago Electrónico</title>
        <style>
            body {
                color: #000;
            }
            ul {
                list-style: none;
            }
            .main {
                display: grid;
                background: #f5f7f9;
                padding: 40px 0px;
                text-align: center;
            }
            .fdiv {
                background: white;
                width: 50%;
                margin: 0 auto;
                border-bottom: 1px solid #e4e8ea;
            }
            .fdiv > h1 {
                font-size: 55px;
				margin: 0;
			}
            .fdivM {
                background: white;
                width: 50%;
                margin: 0 auto;
                border-bottom: 1px solid #e4e8ea;
            }
            .fdivM > h1 {
                font-size: 55px;
				margin: 0;
			}
            #value {
				font-size: 15px;
				margin-bottom: 0;
			}
			#value1 {
				margin: 12px 0;
				font-size: 15px;
			}
			#value2 {
				margin-bottom: 15px;
				font-size: 15px;
			}
			.fdiv > h2 {
                font-size: 30px;
				margin-top: 0;
			}
            .fdivM > h2 {
                font-size: 30px;
				margin-top: 0;
			}
            #title1 {
				color: gray;
				margin-bottom: 0;
                padding-left: 90px;
			}
            #title {
                color: gray;
            }
            .solid {
                width: 80%;
                border-top: 1px solid #e4e8ea;
            }
            .sdiv {
                background: #e4e8ea;
                width: 50%;
                margin: 0 auto;
            }
            .tdiv {
                background: #dce4e4;
                width: 50%;
                height: 40px;
                margin: 0 auto;
            }
            .btn1 {
				margin-bottom: 25px;
                background: #348eda;
                border: 0;
                color: white;
                padding: 10px 25px;
                border-radius: 20px;
			}
            .btn2 {
                width: 40%;
                height: 40px;
                padding-top: 16px;
                margin: 0 auto;
                background: white;
                border: 0;
            }
            .fodiv {
                background: white;
                width: 50%;
                margin: 0 auto;
                border-top: 1px solid #e4e8ea;
            }
        </style>
    </head>
    <body>
        <!-- JOINSOFTWARE Code2 -->
        <div class="main">
            <div class="fdiv">
                <!--
                <img alt="logo" src="{{ asset('logo/logo.jpg') }}" width="50px" height="50px">
				<img alt="{{$document->nombreComercial}}" src="{{ asset("storage/uploads/logos/".$company->logo) }}" style="max-height: 160px">
                -->
                @if($company->logo)
				<img alt="{{$document->nombreComercial}}" src="data:{{mime_content_type(public_path("storage/uploads/logos/{$company->logo}"))}};base64, {{base64_encode(file_get_contents(public_path("storage/uploads/logos/{$company->logo}")))}}" style="max-height: 160px">
			    @elseif($company->emailLogo)
                <img alt="{{$document->nombreComercial}}" src="{{ $company->emailLogo }}" style="max-height: 260px">
                @else
                <h1></h1>
                @endif
            </div>
            <div class="fdivM">
                <h3 id="title">{{ $document->cliente }}</h3>
                <h3 id="title">Has recibido un Documento Electrónico de</h3>
                <h1>{{ $company->name }}</h1>
                <hr class="solid">
                <h3>{{ $document_type_description }} {{ $document_number }}</h3>
            </div>
            <div class="sdiv">
                <h6 id="value1">Fecha Emisión: {{$document->fecha}}</h6>
            </div>
            <div class="fdivM">

                @if($document->tipoComprobante == '7')
                <h6 id="value">Documento afectado:</h6>
                <h2>{{ substr($document->numAuthSustento,24,15) != '' ? substr($document->numAuthSustento,24,15) : $document->numAuthSustento }}</h2>
                @else
                <h6 id="value">Por el valor de:</h6>
                <h2>${{ ($document->importeTotal > -1)?$document->importeTotal:$document->importeTotal * -1 }}</h2>
                @endif

            </div>

            <p class="fodiv">Adjunto encontrará los archivos pdf y xml de su documento electrónico</p>

            <div class="fodiv">
                <p class="btn2">Correo generado de forma automática.
                    {{-- Para cualquier duda o inquietud enviar un correo a:
                    <a href="mailto:soporte@gruposeeman.com" style="color: #a5d055; text-decoration: underline;">Soporte Seeman Group</a> --}}
                </p>

			<!--
                <a href="https://myposcloud.com/" rel="noopener noreferrer" target="_blank">
                    <img alt="logoJOIN" src="https://ci5.googleusercontent.com/proxy/3Kkfuxe19b4tiEYa2cw7tAtpZzYzF-2_9VgsSu9QPsZQgw5T5WZpH83X2anapMl7D3m9gE6wnJR40YkTOQ=s0-d-e1-ft#https://demo.myposcloud.app/logo/logo2.png" width="25%" height="100%">
                </a>
			-->
            </div>
            <div class="tdiv"></div>
        </div>
    </body>
</html>
