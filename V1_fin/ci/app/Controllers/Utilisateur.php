<?php

namespace App\Controllers;

use App\Models\Db_model;

class Utilisateur extends BaseController
{
    public function __construct()
    {
        helper(['form', 'url']);
    }

    /**
     * Page d'accueil pour les membres (utilisateurs normaux)
     */
    public function index()
    {
        $session = session();
        
        // Vérifier si l'utilisateur est connecté
        if (!$session->has('user')) {
            return redirect()->to(base_url('index.php/compte/connexion'));
        }

        // Vérifier que c'est bien un membre (pas un admin)
        if ($session->get('role') === 'Administrateur') {
            return redirect()->to(base_url('index.php/admin/lister_ressources'));
        }

        $data = [
            'titre' => 'Tableau de bord - Membre',
            'user' => $session->get('user'),
            'role' => $session->get('role')
        ];

        return view('menu_membre', $data)
                     . view('membre/accueil_membre', $data)
                     . view('template/bas2');
    }

    /**
     * Afficher le profil du membre
     */
    public function afficher_profil()
    {
        $session = session();
        
        if (!$session->has('user')) {
            return redirect()->to(base_url('index.php/compte/connexion'));
        }

        $model = model(Db_model::class);
        $id = $session->get('id');
        
        // Récupérer les informations du profil
        $profil = $model->get_profil($id);

        $data = [
            'titre' => 'Mon Profil',
            'profil' => $profil,
            'user' => $session->get('user'),
            'role' => $session->get('role')
        ];

        return view('menu_membre', $data)
                     . view('membre/affichage_profil', $data)
                     . view('template/bas2');
    }

    /**
     * Afficher les réservations du membre
     */
    public function mes_reservations()
    {
        $session = session();
        
        if (!$session->has('user')) {
            return redirect()->to(base_url('index.php/compte/connexion'));
        }

        $model = model(Db_model::class);
        $pseudo = $session->get('user');
        $id = $session->get('id');
        
        // Récupérer les réservations
        $reservations = $model->get_reservations_membre($id);

        $data = [
            'titre' => 'Mes Réservations',
            'reservations' => $reservations,
            'user' => $pseudo,
            'role' => $session->get('role')
        ];

        return view('menu_membre', $data)
                     . view('membre/affichage_reservations', $data)
                     . view('template/bas2');
    }

    /**
     * Afficher la liste des adhérents
     */
    public function liste_adherents()
    {
        $session = session();
        
        if (!$session->has('user')) {
            return redirect()->to(base_url('index.php/compte/connexion'));
        }

        $model = model(Db_model::class);
        $currentUser = $session->get('user');
        
        // Récupérer tous les adhérents
        $adherents = $model->get_liste_adherents();

        // Filtrer pour exclure l'utilisateur connecté
        $adherents = array_filter($adherents, function($a) use ($currentUser) {
            return $a['cpt_pseudo'] !== $currentUser;
        });

        $data = [
            'titre' => 'Liste des Adhérents',
            'adherents' => $adherents,
            'user' => $currentUser,
            'role' => $session->get('role')
        ];

        return view('menu_membre', $data)
                     . view('membre/liste_adherents', $data)
                     . view('template/bas2');
    }

    /**
     * Afficher les séances réservées par ressource pour une date donnée (SPRINT 2)
     */
    public function seances_reservees()
    {
        $session = session();
        
        // Vérifier que l'utilisateur est connecté
        if (!$session->has('user')) {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        // Vérifier que c'est un membre (pas un admin)
        if ($session->get('role') === 'Administrateur') {
            return redirect()->to(base_url('index.php/admin/lister_ressources'));
        }

        $model = model(Db_model::class);
        $date_choisie = $this->request->getGet('date_choisie');
        
        $data = [
            'titre' => 'Séances Réservées',
            'user' => $session->get('user'),
            'role' => $session->get('role'),
            'date_choisie' => $date_choisie ?? '',
            'reservations' => [],
            'reservations_par_ressource' => []
        ];

        // Si une date est choisie, récupérer les réservations
        if ($date_choisie) {
            $reservations = $model->get_reservations_par_ressource_et_date($date_choisie);
            
            // Grouper les réservations par ressource
            $reservations_par_ressource = [];
            foreach ($reservations as $res) {
                $ressource_id = $res['idt_Ressources_rcs'] ?? 0;
                $ressource_nom = $res['ressource_nom'] ?? 'Ressource non définie';
                
                if (!isset($reservations_par_ressource[$ressource_id])) {
                    $reservations_par_ressource[$ressource_id] = [
                        'nom' => $ressource_nom,
                        'materiels' => $res['rcs_listeMateriels'] ?? '',
                        'photo' => $res['rcs_photo'] ?? '',
                        'reservations' => []
                    ];
                }
                
                // Récupérer les participants pour cette réservation
                $participants = $model->get_participants_reservation($res['idt_Reservation_res']);
                
                $reservations_par_ressource[$ressource_id]['reservations'][] = [
                    'id' => $res['idt_Reservation_res'],
                    'nom' => $res['res_nom'],
                    'heure' => $res['res_heur'],
                    'responsable' => $res['responsable'] ?? 'Non défini',
                    'responsable_nom' => $res['responsable_nom'] ?? '',
                    'responsable_prenom' => $res['responsable_prenom'] ?? '',
                    'bilan' => $res['res_bilan'],
                    'date' => $res['res_date'],
                    'participants' => $participants
                ];
            }
            
            $data['reservations_par_ressource'] = $reservations_par_ressource;
        }

        return view('template/haut2', $data)
                     . view('menu_membre', $data)
                     . view('membre/seances_reservees', $data)
                     . view('template/bas2');
    }
}
