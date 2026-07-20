// Bajo Mix/webpack, require('jquery') dentro de vendor/*.js (UMD) resolvia
// jQuery via CommonJS real. Bajo Vite esos archivos no ven require/exports y
// caen a su rama "global" (window.jQuery/window.$/window.jquery), asi que
// jQuery tiene que estar en window ANTES de que esos plugins se importen. Los
// imports de un modulo se ejecutan en orden antes que el cuerpo del modulo que
// los importa, asi que este archivo debe ser el primero en importarse de la
// cadena jquery -> vendor/* en bootstrap.js.
import $ from 'jquery';

window.$ = window.jQuery = window.jquery = $;

export default $;
