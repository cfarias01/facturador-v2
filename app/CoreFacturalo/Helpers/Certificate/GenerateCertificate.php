<?php
namespace App\CoreFacturalo\Helpers\Certificate;

use App\CoreFacturalo\WS\Signed\Certificate\X509Certificate;
use App\CoreFacturalo\WS\Signed\Certificate\X509ContentType;
use Exception;
use Symfony\Component\Process\Process;

class GenerateCertificate
{
    public static function typePEM($pfx, $password)
    {
        $certificate = new X509Certificate($pfx, $password);
        return $certificate->export(X509ContentType::PEM);
    }

    public static function typeP12($pfx, $password)
    {
        $certificate = new X509Certificate($pfx, $password);
        return $certificate->export(X509ContentType::CER);
    }

    /**
     * Devuelve un .p12 legible por el OpenSSL 3 de PHP.
     *
     * Muchas firmas emitidas en Ecuador vienen cifradas con algoritmos legacy
     * (RC2-40/3DES) y openssl_pkcs12_read() falla con
     * "error:0308010C:digital envelope routines::unsupported". En ese caso se
     * extraen certificado y clave con el binario openssl y se vuelve a exportar
     * el .p12 con el cifrado actual, con la misma contraseña.
     *
     * @throws Exception
     */
    public static function modernizePfx($pfx, $password)
    {
        if (openssl_pkcs12_read($pfx, $certs, $password)) {
            return $pfx;
        }

        $error = self::opensslErrors();
        if (stripos($error, 'unsupported') === false) {
            throw new Exception('No se pudo leer la firma electrónica. Verifique la contraseña. (' . $error . ')');
        }

        $pem = self::extractLegacyPem($pfx, $password);

        $key = openssl_pkey_get_private($pem);
        preg_match_all('/-----BEGIN CERTIFICATE-----.+?-----END CERTIFICATE-----/s', $pem, $matches);
        if ($key === false || empty($matches[0])) {
            throw new Exception('La firma electrónica no contiene el certificado o la clave privada.');
        }

        // El certificado del firmante es el que corresponde a la clave privada
        $certificates = $matches[0];
        $signer = null;
        foreach ($certificates as $index => $certificate) {
            if (openssl_x509_check_private_key($certificate, $key)) {
                $signer = $certificate;
                unset($certificates[$index]);
                break;
            }
        }
        if ($signer === null) {
            throw new Exception('Ningún certificado de la firma electrónica corresponde a su clave privada.');
        }

        $options = $certificates ? ['extracerts' => array_values($certificates)] : [];
        if (!openssl_pkcs12_export($signer, $modern, $key, $password, $options)) {
            throw new Exception('No se pudo convertir la firma electrónica. (' . self::opensslErrors() . ')');
        }

        return $modern;
    }

    /**
     * Extrae certificados y clave (PEM sin cifrar) de un .p12 legacy usando el binario openssl.
     * OpenSSL 3 necesita -legacy; OpenSSL 1.1 no conoce la opción pero lee el formato directamente.
     *
     * @throws Exception
     */
    private static function extractLegacyPem($pfx, $password)
    {
        $file = tempnam(sys_get_temp_dir(), 'p12');
        file_put_contents($file, $pfx);

        try {
            $output = '';
            foreach ([['-legacy'], []] as $extra) {
                $process = new Process(
                    array_merge([config('services.openssl.bin'), 'pkcs12', '-in', $file, '-nodes', '-passin', 'env:SIA_P12_PASS'], $extra),
                    null,
                    ['SIA_P12_PASS' => (string) $password]
                );
                $process->run();

                if ($process->isSuccessful()) {
                    return $process->getOutput();
                }
                $output = trim($process->getErrorOutput() ?: $process->getOutput());
            }
        } catch (\Throwable $e) {
            $output = $e->getMessage();
        } finally {
            @unlink($file);
        }

        if (stripos($output, 'mac verify') !== false || stripos($output, 'invalid password') !== false) {
            throw new Exception('La contraseña de la firma electrónica es incorrecta.');
        }

        throw new Exception('La firma electrónica usa un cifrado antiguo y no se pudo convertir. '
            . 'Verifique que el comando openssl esté disponible (OPENSSL_BIN). Detalle: ' . $output);
    }

    private static function opensslErrors()
    {
        $errors = [];
        while ($message = openssl_error_string()) {
            $errors[] = $message;
        }
        return implode(' | ', $errors);
    }
}
