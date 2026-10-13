@extends('system.layouts.auth')

@section('content')

    <section class="body-sign">
        <div class="center-sign">
            <div class="card sia-login-card">
                <div class="sia-login-brand">
                    <img src="{{ asset('logo/logo-principal.png') }}" alt="SIA - Sistema Integrado de Aplicaciones">
                    <div class="sia-login-module">Facturación Electrónica</div>
                </div>
                <div class="card-body">
                    <h1>Acceso al panel administrador</h1>
                    <form method="POST" action="{{ route('system.login') }}">
                        @csrf
                        <div class="form-group mb-3">
                            <label for="email">Correo electrónico</label>
                            <div class="input-group">
                                <input id="email" type="email" name="email" class="form-control form-control-lg" value="{{ old('email') }}" autocomplete="email" autofocus>
                                <span class="input-group-append">
                                    <span class="input-group-text">
                                        <i class="fas fa-user"></i>
                                    </span>
                                </span>
                            </div>
                            @if ($errors->has('email'))
                                <label class="error">
                                    <strong>{{ $errors->first('email') }}</strong>
                                </label>
                            @endif
                        </div>
                        <div class="form-group mb-3 {{ $errors->has('password') ? ' error' : '' }}">
                            <label for="password">Contraseña</label>
                            <div class="input-group">
                                <input id="password" name="password" type="password" class="form-control form-control-lg" autocomplete="current-password">
                                <span class="input-group-append">
                                    <span class="input-group-text">
                                        <i class="fas fa-lock"></i>
                                    </span>
                                </span>
                            </div>
                            @if ($errors->has('password'))
                                <label class="error">
                                    <strong>{{ $errors->first('password') }}</strong>
                                </label>
                            @endif
                        </div>
                        <div class="form-group mb-4">
                            <div class="checkbox-custom checkbox-default">
                                <input name="remember" id="RememberMe" type="checkbox" {{ old('remember') ? 'checked' : '' }}>
                                <label for="RememberMe">Recordarme</label>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary sia-login-submit">Iniciar sesión</button>
                    </form>
                </div>
            </div>
            <p class="sia-login-footer">&copy; {{ date('Y') }} SIA · By Semaan Group. Todos los derechos reservados</p>
        </div>
    </section>

@endsection
