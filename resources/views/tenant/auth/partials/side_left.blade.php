@php
    // Sin imagen propia, con un fondo antiguo por defecto (login-v2.svg, fondo-5.svg)
    // o con un archivo local que ya no existe, se usa el fondo de marca SIA
    $authImage = $login->image ?? null;
    $localPath = $authImage ? parse_url($authImage, PHP_URL_PATH) : null;
    if (! $authImage
        || in_array(basename((string) $localPath), ['login-v2.svg', 'fondo-5.svg'])
        || ($localPath && str_starts_with($localPath, '/images/') && ! file_exists(public_path($localPath)))) {
        $authImage = asset('logo/fondo.png');
    }
@endphp
<article class="auth__image" style="background-image: url({{ $authImage }});">
    @if ($useLoginGlobal)
        @if ($login->logo ?? false)
            @if ($login->position_logo != 'none')
            <img class="auth__logo {{ $login->position_logo }}" src="{{ $login->logo }}" alt="Logo" />
            @endif
        @endif
    @else
        @if($company->logo)
            <img class="auth__logo {{ $login->position_logo }}" src="{{ asset('storage/uploads/logos/' . $company->logo) }}" alt="Logo" />
        @else
            <img class="auth__logo {{ $login->position_logo }}" src="{{asset('logo/icono-app.png')}}" alt="Logo" />
        @endif
    @endif
</article>
