<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;

class Admin extends BaseController
{
    /**
     * Vérifie que l'utilisateur est un administrateur connecté
     * Redirige vers la page de connexion si ce n'est pas le cas
     */
    private function checkAdminAccess()
    {
        $session = session();
        
        // Si l'utilisateur n'est pas connecté OU n'est pas administrateur
        // Rediriger vers la page de connexion
        if (!$session->has('user') || $session->get('role') !== 'Administrateur') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }
        
        return null; // Accès autorisé
    }

    public function lister_membre() 
    {
        // Vérification de sécurité : seuls les administrateurs peuvent accéder
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }

        $session = session();
        $model = model(Db_model::class);
        $data['titre'] = "Gestion des Comptes/Profils";
        
        // Récupérer tous les membres sauf l'utilisateur connecté
        // Le tri (invités à la fin) est géré par la requête SQL
        $current_user_id = $session->get('id');
        $data['logins'] = $model->get_all_membre($current_user_id);

        return view('template/haut2', $data)
             . view('menu_administrateur.php')
             . view('admin/affichage_membre')
             . view('template/bas2');
    }

    public function lister_message() 
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        helper('form');
        $model = model(Db_model::class);
        $data['titre'] = 'Table des Messages';
        $data['messages'] = $model->get_all_messages();

        return view('template/haut2', $data)
             . view('menu_administrateur.php')
             . view('admin/affichage_messages.php')
             . view('template/bas2');
    }


  public function envoyer_reponse($code = null)
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        helper('form');
        $session = session();
        $model = model(Db_model::class);

        //  Vérifier si le code est fourni
        if ($code === null) {
            $session->setFlashdata('error', 'Pas de message avec ce code !');
            return redirect()->to(base_url('index.php/admin/lister_message'));
        }

        $message = $model->get_data_msg($code);
        if (!$message) {
            $session->setFlashdata('error', 'Message introuvable !');
            return redirect()->to(base_url('index.php/admin/lister_message'));
        }

        //  Traitement POST
        if ($this->request->getMethod() === 'post') {
            
            // Validation des données
            if (!$this->validate([
                'reponse' => 'required|min_length[5]|max_length[200]'
            ], [
                'reponse' => [
                    'required' => 'Veuillez saisir une réponse.',
                    'min_length' => 'La réponse doit contenir au moins 5 caractères.',
                    'max_length' => 'La réponse ne peut pas dépasser 200 caractères.'
                ]
            ])) {
                // Validation échouée - retour au formulaire avec erreurs
                $data = [
                    'msg_code'    => $code,
                    'msg_reponse' => $message->msg_repense ?? '',
                    'message'     => $message,
                    'titre'       => 'Répondre au message'
                ];
                
                return view('template/haut2', $data)
                    . view('menu_administrateur.php')
                    . view('admin/envoyer_repense.php')
                    . view('template/bas2');
            }

            // Récupération de la réponse validée
            $reponse = $this->request->getPost('reponse');

            // Récupérer l'ID de l'admin connecté
            $admin_id = $session->get('id');
            
            // Envoyer la réponse et récupérer le nombre de lignes affectées
            $affectedRows = $model->envoyer_reponse($code, $reponse, $admin_id);

            if ($affectedRows > 0) {
                $session->setFlashdata('success', 'Réponse envoyée avec succès. (' . $affectedRows . ' ligne(s) modifiée(s))');
            } else {
                $session->setFlashdata('error', 'Aucune ligne modifiée. Vérifiez que le code du message est correct : ' . $code);
            }
            
            return redirect()->to(base_url('index.php/admin/lister_message'));
        }

        // Affichage du formulaire
        $data = [
            'msg_code'    => $code,
            'msg_reponse' => $message->msg_repense ?? '',
            'message'     => $message,
            'titre'       => 'Répondre au message'
        ];

        return view('template/haut2', $data)
            . view('menu_administrateur.php')
            . view('admin/envoyer_repense.php')
            . view('template/bas2');
    }


    public function envoyer_reponse_modal()
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        helper('form');
        $session = session();
        $model = model(Db_model::class);

        // Vérifier que c'est une requête POST
        if ($this->request->getMethod() == "POST") {
            
            // Validation des données
            if (!$this->validate([
                'msg_code' => 'required|min_length[10]|max_length[20]',
                'reponse' => 'required|max_length[200]'
            ], [
                'msg_code' => [
                    'required' => 'Le code du message est requis.',
                    'min_length' => 'Le code du message doit contenir au moins 10 caractères.',
                    'max_length' => 'Le code du message ne peut pas dépasser 20 caractères.'
                ],
                'reponse' => [
                    'required' => 'Veuillez saisir une réponse.',
                    'max_length' => 'La réponse ne peut pas dépasser 200 caractères.'
                ]
            ])) {
                // Validation échouée - recharger la page avec les erreurs
                $data['titre'] = 'Table des Messages';
                $data['messages'] = $model->get_all_messages();
                
                // Passer les erreurs directement (pas de flashdata)
                $data['validation_errors'] = $this->validator->getErrors();
                $data['old_input'] = $this->request->getPost();
                
                return view('template/haut2', $data)
                     . view('menu_administrateur.php')
                     . view('admin/affichage_messages.php', $data)
                     . view('template/bas2');
            }

            // Récupération des données validées
            $msgCode = $this->request->getPost('msg_code');
            $reponse = $this->request->getPost('reponse');

            // Récupérer l'ID de l'admin connecté
            $admin_id = $session->get('id');
            
            // Envoyer la réponse
            $affectedRows = $model->envoyer_reponse($msgCode, $reponse, $admin_id);

            if ($affectedRows > 0) {
                $session->setFlashdata('success', 'Réponse envoyée avec succès !');
            } else {
                $session->setFlashdata('error', 'Erreur : Aucune ligne modifiée. Code: ' . $msgCode);
            }

            return redirect()->to(base_url('index.php/admin/lister_message'));
        }

        // Si ce n'est pas une requête POST, rediriger
        return redirect()->to(base_url('index.php/admin/lister_message'));
    }

    public function supprimer_message($code)
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        $session = session();
        $model = model(Db_model::class);

        if (empty($code)) {
            $session->setFlashdata('error', 'Code message manquant.');
            return redirect()->to(base_url('index.php/admin/lister_message'));
        }

        $affectedRows = $model->supprimer_message($code);

        if ($affectedRows > 0) {
            $session->setFlashdata('success', 'Message supprimé avec succès.');
        } else {
            $session->setFlashdata('error', 'Impossible de supprimer le message ou message introuvable.');
        }

        return redirect()->to(base_url('index.php/admin/lister_message'));
    }

    
    public function afficher_profil()
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        helper('form');
        $model = model(\App\Models\Db_model::class);
    
        $session = session();
        if (!$session->has('user')) {
            return redirect()->to('/connexion');
        }
    
        $id = $session->get('id');
    
        // Récupération dynamique du profil avec compte associé
        $data['profil'] = $model->get_profil($id);
    
        return view('template/haut2')
             . view('menu_administrateur')
             . view('admin/affichage_profile', $data)
             . view('template/bas2');
    }

    public function valider_modification()
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        helper('form');
        $session = session();
        $model = model(Db_model::class);
        $id = $session->get('id');

        if (!$id) {
            return redirect()->to('/connexion');
        }

        // Validation des données
        if (!$this->validate([
            'nom' => 'required|min_length[2]|max_length[50]',
            'prenom' => 'required|min_length[2]|max_length[50]',
            'email' => 'required|valid_email|max_length[100]'
        ], [
            'nom' => [
                'required' => 'Le nom est requis.',
                'min_length' => 'Le nom doit contenir au moins 2 caractères.',
                'max_length' => 'Le nom ne peut pas dépasser 50 caractères.'
            ],
            'prenom' => [
                'required' => 'Le prénom est requis.',
                'min_length' => 'Le prénom doit contenir au moins 2 caractères.',
                'max_length' => 'Le prénom ne peut pas dépasser 50 caractères.'
            ],
            'email' => [
                'required' => 'L\'email est requis.',
                'valid_email' => 'Veuillez saisir une adresse email valide.',
                'max_length' => 'L\'email ne peut pas dépasser 100 caractères.'
            ]
        ])) {
            // Validation échouée
            $session->setFlashdata('error', 'Erreur de validation. Veuillez vérifier les champs.');
            return redirect()->back()->withInput();
        }

        // Récupération des données POST
        $data = [
            'Nom'     => $this->request->getPost('nom'),
            'Prenom'  => $this->request->getPost('prenom'),
            'Email'   => $this->request->getPost('email'),
            'Tel'     => $this->request->getPost('tel'),
            'Adresse' => $this->request->getPost('adresse'),
            'Cp'      => $this->request->getPost('cp'),
            'Date'    => $this->request->getPost('date_ncs')
        ];

        if ($model->update_profil($id, $data)) {
            $session->setFlashdata('success', 'Profil mis à jour avec succès !');
        } else {
            $session->setFlashdata('error', 'Erreur lors de la mise à jour du profil.');
        }

        return redirect()->to(base_url('index.php/admin/afficher_profil'));
    }


    public function create_compte_invite()
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        helper('form');
        $session = session();
        $model = model(Db_model::class);

        // Vérification session admin
        if (!$session->has('user') || $session->get('role') != 'Administrateur') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        // Traitement du formulaire
        if ($this->request->getMethod() == "POST") { 
            
            if (!$this->validate([
                'pseudo' => 'required|min_length[3]|max_length[50]|is_unique[t_compte_cpt.cpt_pseudo]',
                'mdp' => 'required|min_length[8]|max_length[255]'
            ], [
                'pseudo' => [
                    'required' => 'Le pseudo est requis.',
                    'min_length' => 'Le pseudo doit contenir au moins 3 caractères.',
                    'max_length' => 'Le pseudo ne peut pas dépasser 50 caractères.',
                    'is_unique' => 'Ce compte existe déjà !'
                ],
                'mdp' => [
                    'required' => 'Le mot de passe est requis.',
                    'min_length' => 'Le mot de passe doit contenir au moins 8 caractères.',
                    'max_length' => 'Le mot de passe ne peut pas dépasser 255 caractères.'
                ]
            ])) {
                // Validation échouée
                $data['titre'] = 'Créer un compte invité';
                return view('template/haut2', $data)
                     . view('menu_administrateur')
                     . view('admin/create_compte_invite')
                     . view('template/bas2');
            }

            // Validation réussie
            $pseudo = $this->request->getPost('pseudo');
            $mdp = $this->request->getPost('mdp');

            // Appel au modèle avec le mot de passe saisi
            if ($model->set_compte_invite($pseudo, $mdp)) {
                $session->setFlashdata('success', 'Compte invité créé avec succès !<br><strong>Pseudo:</strong> ' . $pseudo);
                return redirect()->to(base_url('index.php/admin/lister_membre'));
            } else {
                $session->setFlashdata('error', "Erreur lors de la création du compte en base de données.");
                return redirect()->back()->withInput();
            }
        }

        // Affichage du formulaire (GET)
        $data['titre'] = 'Créer un compte invité';
        return view('template/haut2', $data)
             . view('menu_administrateur')
             . view('admin/create_compte_invite')
             . view('template/bas2');
    }

    // Lister toutes les réservations (Admin)
    public function lister_reservations()
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        $session = session();

        $model = model(Db_model::class);
        $data['titre'] = 'Gestion des Réservations';
        $data['reservations'] = $model->get_all_reservations();
        
        // Vérifier s'il y a un filtre par date
        $date_filtre = $this->request->getGet('date_filtre');
        if ($date_filtre) {
            $data['reservations_filtrees'] = $model->get_reservations_by_date($date_filtre);
            $data['date_selectionnee'] = $date_filtre;
        } else {
            $data['reservations_filtrees'] = [];
            $data['date_selectionnee'] = '';
        }

        return view('template/haut2', $data)
             . view('menu_administrateur')
             . view('admin/affichage_reservation', $data)
             . view('template/bas2');
    }

    /**
     * GESTION DES RESSOURCES
     */

    // Lister toutes les ressources
    public function lister_ressources()
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        helper('form');
        $session = session();

        $model = model(Db_model::class);
        $data['titre'] = 'Gestion des Ressources';
        $data['ressources'] = $model->get_all_ressources();
        
        // Récupérer les erreurs de validation et indicateurs de modale depuis la session
        $data['validation_errors'] = $session->getFlashdata('validation_errors');
        $data['show_modal_add'] = $session->getFlashdata('show_modal_add');
        $data['show_modal_edit_id'] = $session->getFlashdata('show_modal_edit_id');

        return view('template/haut2', $data)
             . view('menu_administrateur')
             . view('admin/affichage_ressources', $data)
             . view('template/bas2');
    }

    // Upload photo pour une ressource
    public function upload_photo_ressource($id)
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        $session = session();
        $model = model(Db_model::class);

        if (!$session->has('user') || $session->get('role') != 'Administrateur') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        // Vérifier que la ressource existe
        $ressource = $model->get_ressource($id);
        if (!$ressource) {
            $session->setFlashdata('error', 'Ressource introuvable.');
            return redirect()->to(base_url('index.php/admin/lister_ressources'));
        }

        // Validation du fichier avec syntaxe en tableau
        $validationRule = [
            'photo' => [
                'label' => 'Photo',
                'rules' => [
                    'uploaded[photo]',
                    'is_image[photo]',
                    'mime_in[photo,image/jpg,image/jpeg,image/gif,image/png,image/webp]',
                    'max_size[photo,2048]',
                ],
            ],
        ];

        if (!$this->validate($validationRule)) {
            $session->setFlashdata('error', 'Erreur : ' . $this->validator->getError('photo'));
            return redirect()->to(base_url('index.php/admin/lister_ressources'));
        }

        $photo = $this->request->getFile('photo');

        if (!empty($photo) && $photo->isValid() && !$photo->hasMoved()) {
            // Utiliser le dossier app/Images
            $uploadPath = APPPATH . 'Images/';
            
            // Vérifier que le dossier existe
            if (!is_dir($uploadPath)) {
                $session->setFlashdata('error', 'Le dossier Images n\'existe pas dans app/');
                return redirect()->to(base_url('index.php/admin/lister_ressources'));
            }

            // Supprimer l'ancienne photo si elle existe
            if (!empty($ressource->rcs_photo)) {
                $oldPhotoPath = $uploadPath . $ressource->rcs_photo;
                if (file_exists($oldPhotoPath)) {
                    @unlink($oldPhotoPath);
                }
            }

            // Récupération du nom du fichier téléversé (ou générer un nom unique)
            $newName = $photo->getRandomName();
            
            // Dépôt du fichier dans le répertoire app/Images
            if ($photo->move($uploadPath, $newName)) {
                // Mettre à jour la base de données
                if ($model->update_photo_ressource($id, $newName)) {
                    $session->setFlashdata('success', 'Photo uploadée avec succès !');
                } else {
                    $session->setFlashdata('error', 'Erreur lors de la mise à jour de la base de données.');
                }
            } else {
                $session->setFlashdata('error', 'Erreur lors du déplacement du fichier.');
            }
        } else {
            $session->setFlashdata('error', 'Erreur lors de l\'upload du fichier.');
        }

        return redirect()->to(base_url('index.php/admin/lister_ressources'));
    }






    // Ajouter une ressource
    public function ajouter_ressource()
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        helper('form');
        $session = session();
        $model = model(Db_model::class);

        if ($this->request->getMethod() == 'POST') {
            // Validation des données
            if (!$this->validate([
                'rcs_type' => 'required|min_length[3]|max_length[100]',
                'rcs_listeMateriels' => 'required|min_length[3]|max_length[255]',
                'rcs_jauge' => 'required|integer|greater_than[0]'
            ], [
                'rcs_type' => [
                    'required' => 'Le type de ressource est requis.',
                    'min_length' => 'Le type doit contenir au moins 3 caractères.',
                    'max_length' => 'Le type ne peut pas dépasser 100 caractères.'
                ],
                'rcs_listeMateriels' => [
                    'required' => 'La liste du matériel est requise.',
                    'min_length' => 'La liste doit contenir au moins 3 caractères.',
                    'max_length' => 'La liste ne peut pas dépasser 255 caractères.'
                ],
                'rcs_jauge' => [
                    'required' => 'La jauge est requise.',
                    'integer' => 'La jauge doit être un nombre entier.',
                    'greater_than' => 'La jauge doit être supérieure à 0.'
                ]
            ])) {
                // Validation échouée - stocker les erreurs et rouvrir la modale
                $session->setFlashdata('validation_errors', $this->validator->getErrors());
                $session->setFlashdata('error', 'Erreur de validation : ' . implode('<br>', $this->validator->getErrors()));
                $session->setFlashdata('show_modal_add', true);
                return redirect()->to(base_url('index.php/admin/lister_ressources'))->withInput();
            }

            $data = [
                'rcs_type' => $this->request->getPost('rcs_type'),
                'rcs_listeMateriels' => $this->request->getPost('rcs_listeMateriels'),
                'rcs_jauge' => $this->request->getPost('rcs_jauge'),
                'rcs_photo' => ''  // Chaîne vide au lieu de null
            ];

            if ($model->add_ressource($data)) {
                $session->setFlashdata('success', 'Ressource ajoutée avec succès !');
                return redirect()->to(base_url('index.php/admin/lister_ressources'));
            } else {
                $session->setFlashdata('error', 'Erreur lors de l\'ajout de la ressource.');
                return redirect()->to(base_url('index.php/admin/lister_ressources'))->withInput();
            }
        }

        // Si GET, rediriger vers la liste
        return redirect()->to(base_url('index.php/admin/lister_ressources'));
    }





    // Modifier une ressource
    public function modifier_ressource($id)
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        helper('form');
        $session = session();
        $model = model(Db_model::class);

        if (!$session->has('user') || $session->get('role') != 'Administrateur') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        if ($this->request->getMethod() == 'POST') {
            // Validation des données
            if (!$this->validate([
                'rcs_type' => 'required|min_length[3]|max_length[100]',
                'rcs_listeMateriels' => 'required|min_length[3]|max_length[255]',
                'rcs_jauge' => 'required|integer|greater_than[0]'
            ], [
                'rcs_type' => [
                    'required' => 'Le type de ressource est requis.',
                    'min_length' => 'Le type doit contenir au moins 3 caractères.',
                    'max_length' => 'Le type ne peut pas dépasser 100 caractères.'
                ],
                'rcs_listeMateriels' => [
                    'required' => 'La liste du matériel est requise.',
                    'min_length' => 'La liste doit contenir au moins 3 caractères.',
                    'max_length' => 'La liste ne peut pas dépasser 255 caractères.'
                ],
                'rcs_jauge' => [
                    'required' => 'La jauge est requise.',
                    'integer' => 'La jauge doit être un nombre entier.',
                    'greater_than' => 'La jauge doit être supérieure à 0.'
                ]
            ])) {
                // Validation échouée - stocker les erreurs et rediriger
                $session->setFlashdata('validation_errors', $this->validator->getErrors());
                $session->setFlashdata('show_modal_edit_id', $id);
                return redirect()->to(base_url('index.php/admin/lister_ressources'))->withInput();
            }

            $data = [
                'rcs_type' => $this->request->getPost('rcs_type'),
                'rcs_listeMateriels' => $this->request->getPost('rcs_listeMateriels'),
                'rcs_jauge' => $this->request->getPost('rcs_jauge')
            ];

            if ($model->update_ressource($id, $data)) {
                $session->setFlashdata('success', 'Ressource modifiée avec succès !');
            } else {
                $session->setFlashdata('error', 'Erreur lors de la modification de la ressource.');
            }
        }

        return redirect()->to(base_url('index.php/admin/lister_ressources'));
    }






    // Supprimer une ressource
    public function supprimer_ressource($id)
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        $session = session();
        $model = model(Db_model::class);

        if (!$session->has('user') || $session->get('role') != 'Administrateur') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        // Récupérer la ressource pour supprimer la photo
        $ressource = $model->get_ressource($id);
        if ($ressource && !empty($ressource->rcs_photo)) {
            $photoPath = WRITEPATH . '../public/uploads/ressources/' . $ressource->rcs_photo;
            if (file_exists($photoPath)) {
                unlink($photoPath);
            }
        }

        if ($model->delete_ressource($id)) {
            $session->setFlashdata('success', 'Ressource supprimée avec succès !');
        } else {
            $session->setFlashdata('error', 'Erreur lors de la suppression de la ressource.');
        }

        return redirect()->to(base_url('index.php/admin/lister_ressources'));
    }

    // Servir les images depuis app/Images
    public function get_image($filename)
    {
        $imagePath = APPPATH . 'Images/' . $filename;
        
        if (file_exists($imagePath)) {
            $mime = mime_content_type($imagePath);
            header('Content-Type: ' . $mime);
            header('Content-Length: ' . filesize($imagePath));
            readfile($imagePath);
            exit;
        } else {
            // Image par défaut ou erreur 404
            throw \CodeIgniter\Exceptions\PageNotFoundException::forPageNotFound();
        }
    }




    

    // Supprimer un membre (compte + profil)
    public function supprimer_membre($id)
    {
        if ($redirect = $this->checkAdminAccess()) {
            return $redirect;
        }
        
        $session = session();
        $model = model(Db_model::class);

        if (!$session->has('user') || $session->get('role') != 'Administrateur') {
            return redirect()->to(base_url('index.php/compte/connecter'));
        }

        // Vérifier que l'admin ne supprime pas son propre compte
        if ($id == $session->get('id')) {
            $session->setFlashdata('error', 'Vous ne pouvez pas supprimer votre propre compte !');
            return redirect()->to(base_url('index.php/admin/lister_membre'));
        }

        if ($model->delete_compte($id)) {
            $session->setFlashdata('success', 'Compte supprimé avec succès !');
        } else {
            $session->setFlashdata('error', 'Erreur lors de la suppression du compte.');
        }

        return redirect()->to(base_url('index.php/admin/lister_membre'));
    }

}
?>
