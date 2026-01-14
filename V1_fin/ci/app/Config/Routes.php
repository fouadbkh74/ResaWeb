<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
use App\Controllers\Accueil;
use App\Controllers\Compte;
use App\Controllers\Actualite;
use App\Controllers\Message;




$routes->get('/', [Actualite::class , 'affichage']);
$routes->get('accueil/afficher', [Actualite::class, 'affichage']);
$routes->get('accueil/afficher/(:num)', [Accueil::class, 'afficher']);
$routes->get('compte/lister', [Compte::class, 'lister']);

$routes->match(["get","post"],'compte/creer', [Compte::class, 'creer']);
$routes->get('actualite/afficher', [Actualite::class, 'affichage']);
$routes->get('actualite/afficher/(:num)', [Actualite::class, 'afficher']);


$routes->get('message/faire_suivi/(:segment)', [Message::class, 'faire_suivi']);
$routes->match(["get","post"],'message/verifier', [Message::class, 'verifier']);
$routes->match(["get","post"],'message/envoyer', [Message::class, 'envoyer']);


/*


$routes->get('compte/creer', [Compte::class, 'creer']);
$routes->post('compte/creer', [Compte::class, 'creer']);*/

/*$routes->get('accueil/afficher/(:segment)', [Accueil::class, 'afficher']);*/
?>