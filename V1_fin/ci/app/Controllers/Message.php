<?php
namespace App\Controllers;
use App\Models\Db_model;
use CodeIgniter\Exceptions\PageNotFoundException;
class Message extends BaseController
{
   
    public function faire_suivi($code = null)
    {
        $session = session(); // Nécessaire pour utiliser Flashdata
    
        // 1Vérifier si le code est vide
        if ($code == null) {
    
            $session->setFlashdata('erreur', 'Pas de message avec ce code !');
    
            echo view('template/haut')
                . view('menu_visiteur')
                . view('message/message_erreur')
                . view('template/bas');
    
            header("refresh:2;url=" . base_url('index.php/message/verifier'));
            return;
        }
    
        // 2 Vérifier si le code fait 20 caractères
        if (strlen($code) !== 20) {
    
       echo 'erreur', 'Le code fourni n’est pas valide : il doit contenir exactement 20 caractères.';
        }
    
            
    
        // 3️ Code valide → récupération des données
        $model = model(Db_model::class);
    
        $data['titre'] = 'Message :';
        $data['donne'] = $model->get_data_msg($code);
    
        return view('template/haut', $data)
            . view('menu_visiteur')
            . view('message/suivi_message')
            . view('template/bas');
    }
    


        
 
        public function verifier()
        {
            helper('form');
            $session = session();
            $model = model(Db_model::class);
        
            // Si formulaire soumis
            if ($this->request->getMethod() == "POST") {
        
                // Validation
                if (!$this->validate([
                    'code' => 'required|max_length[20]|min_length[20]'
                ], [
                    'code' => [
                        'required' => 'Veuillez entrer le code !',
                        'min_length' => 'Le code doit être de 20 caractères !',
                    ]
                ])) {
        
                    // Retour au formulaire
                    return view('template/haut')
                        . view('menu_visiteur')
                        . view('message/verifier_message')
                        . view('template/bas');
                }
        
                // Validation OK → récupération du code
                $code = $this->validator->getValidated()['code'];
        
                // Recherche en BDD
                $donne = $model->get_data_msg($code);
        
                // SI LE CODE N’EXISTE PAS
                if (!$donne) {
        
                    // Message temporaire
                    $session->setFlashdata('erreur', 'Pas de message avec ce code !');
        
                    // Affiche la vue d’erreur + redirection en 3 sec
                    echo view('template/haut')
                        . view('menu_visiteur')
                        . view('message/message_erreur')
                        . view('template/bas');
        
                    // Redirection automatique en 3 secondes
                    header("refresh:2;url=" . base_url('index.php/message/verifier'));
        
                    return;
                }
        
                // SI LE CODE EXISTE
                $data['titre'] = 'Message :';
                $data['donne'] = $donne;
        
                return view('template/haut', $data)
                    . view('menu_visiteur')
                    . view('message/suivi_message')
                    . view('template/bas');
            }
        
                    // Affichage initial du formulaire
                    return view('template/haut')
                        . view('menu_visiteur')
                        . view('message/verifier_message')
                        . view('template/bas');
                }
        









       public function envoyer()
                {
                    helper('form'); // Chargement du helper de formulaire
                    $model = model(Db_model::class); // Chargement du modèle
                
                    if ($this->request->getMethod() == "POST") {
                        // Configuration des règles de validation pour chaque champ
                         // Validation des données du formulaire
                    if (! $this->validate([
                        'email' => 'required|valid_email', // Validation de l'email (obligatoire et format valide)
                        'sujet' => 'required|max_length[100]', // Validation du sujet (obligatoire)
                        'contenu' => 'required', // Validation du contenu (obligatoire)
                    ], [
                        // Configuration des messages d’erreurs
                        'email' => [
                            'required' => 'Veuillez entrer une adresse email.',
                            'valid_email' => 'Veuillez entrer une adresse email valide.',
                        ],
                        'sujet' => [
                            'required' => 'Veuillez entrer un sujet pour votre message.',
                        ],
                        'contenu' => [
                            'required' => 'Veuillez entrer le contenu du message.',
                        ]
                    ])) {
                                        // La validation a échoué, retour au formulaire avec les erreurs
                            return view('template/haut')
                                . view('menu_visiteur.php')
                                . view('message/envoi_message')
                                . view('template/bas');
                            
                    }
                            
                                                // Données valides
                            $validated = $this->validator->getValidated();

                            // Génération du code ici (et une seule fois)
                            $validated['code'] = strtoupper(bin2hex(random_bytes(10)));

                            // Insertion dans la BDD
                            $model->set_message($validated);
                  
                            $data = [
                                'titre' => "Confirmation d'envoi du message",
                                'donne' => (object)[
                                    'msg_code' => $validated['code']
                                ]
                            ];


                            // Récupérer les informations du message (par exemple, pour l'affichage après envoi)
                            return view('template/haut', $data)
                                . view('menu_visiteur.php')
                                . view('message/message_succes',$data) // Vue de confirmation
                                . view('template/bas');
                        }
                    
                
                            // Si la méthode n'est pas POST, afficher le formulaire
                            return view('template/haut')
                                . view('menu_visiteur.php')
                                . view('message/envoi_message') // Formulaire de saisie
                                . view('template/bas');
                        }
                        
                

    
    
   }


?>