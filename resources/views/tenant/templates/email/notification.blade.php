@php
    $document_number = isset($document) ? count($document) : 0;
@endphp

<!doctype html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Notificaciones automáticas</title>
        <style>
            body { color: #111; font-family: Arial, sans-serif; background: #f5f7f9; margin: 0; padding: 0; }
            .container { width: 90%; max-width: 760px; margin: 0 auto; background: #fff; border: 1px solid #e6eaf0; padding: 20px; }
            .header { text-align: center; margin-bottom: 20px; }
            .header h1 { margin: 0; font-size: 26px; color: #333; }
            .header p { margin: 2px 0; color: #555; }
            .summary { background: #eef3fb; border: 1px solid #d8e2ef; border-radius: 8px; padding: 12px; margin-bottom: 16px; }
            .summary strong { color: #084298; }
            table { width: 100%; border-collapse: collapse; font-size: 13px; margin-top: 12px; }
            th, td { border: 1px solid #d9dde2; padding: 8px 6px; text-align: left; }
            th { background: #f1f5fa; color: #2b3a54; }
            .footer { margin-top: 18px; padding-top: 12px; border-top: 1px solid #e6eaf0; color: #667085; font-size: 12px; }
            .badge { background: #dbeafe; color: #1d4ed8; font-weight: bold; padding: 3px 8px; border-radius: 4px; }
        </style>
    </head>
    <body>
        <div class="container">

            <div class="header">
                @if(isset($company) && $company->logo)
                    <img alt="{{$company->nombreComercial ?? 'Logo'}}" src="data:{{mime_content_type(public_path("storage/uploads/logos/{$company->logo}"))}};base64, {{base64_encode(file_get_contents(public_path("storage/uploads/logos/{$company->logo}")))}}" style="max-height: 120px; margin-bottom: 10px;">
                @elseif(isset($company) && $company->emailLogo)
                    <img alt="{{$company->nombreComercial ?? 'Logo'}}" src="{{ $company->emailLogo }}" style="max-height: 120px; margin-bottom: 10px;">
                @endif
                <h1>Notificación de documentos pendientes de carga</h1>
                <p>Se detectaron documentos que no se cargaron al sistema de facturación.</p>
            </div>

            <div class="summary">
                <p>Estimado equipo, {{$company->name }}</p>
                <p>Actualmente hay <strong class="badge">{{ $document_number }}</strong> documento(s) pendientes de carga.</p>
                <p>Revise la lista para identificar errores SQL o respuestas de envío con fallo.</p>
            </div>

            @if($document_number > 0)
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>NUMSERIE</th>
                            <th>NUMDOC</th>
                            <th>ERRORSQL</th>
                            <th>RESPUESTAENVIO</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($document as $index => $doc)
                            <tr>
                                <td>{{ $index + 1 }}</td>
                                <td>{{ $doc['NUMSERIE'] ?? $doc->NUMSERIE ?? '-' }}</td>
                                <td>{{ $doc['NUMDOC'] ?? $doc->NUMDOC ?? '-' }}</td>
                                <td>{{ $doc['ERRORSQL'] ?? $doc->ERRORSQL ?? '-' }}</td>
                                <td>{{ $doc['RESPUESTAENVIO'] ?? $doc->RESPUESTAENVIO ?? '-' }}</td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            @else
                <p>No se encontraron documentos pendientes de carga en este momento.</p>
            @endif

            <div class="footer">
                <p>Este correo es automático. Por favor no responda directamente.</p>
            </div>
        </div>
    </body>
</html>
