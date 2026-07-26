<?php

namespace App\Support\Xml;

use RuntimeException;
use SimpleXMLElement;

/**
 * Reemplazo minimo de Orchestra\Parser\Xml\Facade::extract()->parse($schema),
 * unico uso real de ese paquete (retirado: laravie/parser, su dependencia,
 * no tiene version compatible con Laravel 13). Solo replica el subconjunto
 * de comportamiento que SriDocumentController usa: leer los hijos directos
 * de nivel superior de un XML por nombre de tag ('uses' => 'tagName'), sin
 * soporte de colecciones/atributos/namespaces/filtros del paquete original.
 */
class SimpleXmlExtractor
{
    /**
     * @param  array<string, array{uses: string}>  $schema
     * @return array<string, string|array|null>
     */
    public static function extract(string $xml, array $schema): array
    {
        $root = @simplexml_load_string($xml);

        if (! $root instanceof SimpleXMLElement) {
            throw new RuntimeException('Unable to parse XML from string.');
        }

        $output = [];

        foreach ($schema as $key => $data) {
            $tag = $data['uses'];
            $value = $root->{$tag} ?? null;

            if (! ($value instanceof SimpleXMLElement)) {
                $output[$key] = null;
                continue;
            }

            $value = $value->count() > 1 ? (array) $value : (string) $value;

            $output[$key] = ($value === '' || $value === []) ? null : $value;
        }

        return $output;
    }
}
