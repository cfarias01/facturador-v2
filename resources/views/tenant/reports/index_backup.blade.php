@extends('tenant.layouts.app')


@section('content')
<div class="row">
    <div class="col-md-12">
        <div class="card card-primary">
            <div class="card-header">
                   <div>
                <h4 class="card-title">Consulta de Documentos</h4>
                </div></div>
            <div class="card-body">

                @php
                    $formData = Session::get('form_document_list', []);
                @endphp
                <form role="form" autocomplete="off" method="POST">
                    @csrf
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="document_type">Tipo de Documento</label>
                                <select name="document_type" id="document_type" class="form-control">
                                    @foreach (['' => 'Todos', '01' => 'Factura', '03' => 'Boleta', '07' => 'Nota de Credito', '08' => 'Nota de Debito'] as $value => $label)
                                        <option value="{{ $value }}" @selected(($formData['document_type'] ?? '') == $value)>{{ $label }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="serie">Serie</label>
                                <input type="text" name="serie" id="serie" class="form-control" value="{{ $formData['serie'] ?? '' }}">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="number">Correlativo</label>
                                <input type="text" name="number" id="number" class="form-control" value="{{ $formData['number'] ?? '' }}">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="total">Importe Total</label>
                                <input type="text" name="total" id="total" class="form-control" value="{{ $formData['total'] ?? '' }}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="state">Estado</label>
                                <select name="state" id="state" class="form-control">
                                    @foreach ($states as $value => $label)
                                        <option value="{{ $value }}" @selected($value == 0)>{{ $label }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>


                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="ruc">RUC Cliente</label>
                                <input type="text" name="ruc" id="ruc" class="form-control" value="{{ $formData['ruc'] ?? '' }}">
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="client">Cliente</label>
                                <input type="text" name="client" id="client" class="form-control" value="{{ $formData['client'] ?? '' }}">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="daterange">Rango Fechas de Emisión</label>
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <i class="fa fa-calendar"></i>
                                        </span>
                                    </div>
                                    <input type="text" name="daterange" id="daterange" class="form-control pull-right" value="{{ $formData['daterange'] ?? '' }}">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <br>
                <div class="box-footer">
                    <button type="submit" class="btn btn-primary">Buscar</button>
                    <button type="reset" class="btn btn-default btn_reset">Limpiar</button>
                </div>
                </form>


                @if(!empty($reports) && $reports->count())
                <div class="callout callout-info">
                    <p>Se encontraron {{$reports->count()}} registros.</p>
                </div>
                <div class="box">
                    <div class="box-body table-responsive no-padding">
                        <table class="table table-striped table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th class="">#</th>
                                    <th class="">Tipo Documento</th>
                                    <th class="">Número</th>
                                    <th class="">Fecha emisión</th>
                                    <th class="">Código Externo</th>
                                    <th class="">Estado</th>
                                    <th class="">Fecha creación </th>
                                    <th class="">Descargas</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($reports as $key => $value)
                                <tr>
                                    <td>{{$value->id}}</td>
                                    <td>{{$value->document_type_code}}</td>
                                    <td>{{$value->series}}-{{$value->number}}</td>
                                    <td>{{$value->date_of_issue->format('Y-m-d')}}</td>
                                    <td>{{$value->external_id}}</td>
                                    <td>{{$value->state_type->description}}</td>
                                    <td>{{$value->created_at}}</td>
                                    <td class="">
                                        @if ($value->external_id)
                                        <div>
                                            <i class="fa fa-download"></i>
                                            <a href="{{asset($value->download_pdf)}}" class="descarga" target="_blank">PDF</a>
                                        </div>
                                        <div>
                                            <i class="fa fa-download"></i>
                                            <a href="{{asset($value->download_xml)}}" class="descarga" target="_blank">XML</a>
                                        </div>
                                            @if($value->state_type_id !== '01')
                                        <div>
                                            <i class="fa fa-download"></i>
                                            <a href="{{asset($value->download_cdr)}}" class="descarga" target="_blank">CDR</a>
                                        </div>
                                            @endif
                                        @endif
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                        <div class="pagination-wrapper">

                            {!! $reports->appends(['search' => Session::get('form_document_list')])->render() !!}

                        </div>
                    </div>
                </div>
                @else
                <div class="callout callout-info">
                    <p>No se encontraron registros.</p>
                </div>
                @endif

            </div>
        </div>
    </div>
</div>
@endsection


@push('scripts')

<script>

    $('.btn_reset').on('click', function (e) {
        e.preventDefault()
        reset()
    })

    function reset(){

        $('form input.form-control').val('')
        $('form select.form-control').val(0)

    }

    $('#daterange').daterangepicker({
        format: 'YYYY-MM-DD',
        autoApply: true,
        locale: {
            applyLabel: 'Aceptar',
            cancelLabel: 'Cancelar',
            fromLabel: 'Desde',
            toLabel: 'Hasta',
            daysOfWeek: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa'],
            monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Setiembre', 'Octubre', 'Noviembre', 'Diciembre'],
            firstDay: 1
        }
    })

    @if(!isset(Session::get('form_document_list')['daterange']))
      $("#daterange").val('')
    @endif


</script>

@endpush


