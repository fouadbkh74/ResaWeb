<?php
        namespace App\Controllers;
        use App\Models\Db_model;
        use CodeIgniter\Exceptions\PageNotFoundException;


        class Compte extends BaseController
            {
            public function __construct()
            {
            //...
            }
            public function lister()
            {
            $model = model(Db_model::class);
            $data['titre']="Liste de tous les comptes";
            $data['logins'] = $model->get_all_compte();
            $data['nbr']=$model->get_nbr_compte();
            return view('template/haut', $data)
            .view('menu_visiteur.php')
            . view('affichage_comptes')
            . view('template/bas');
            }



                            public function creer(){
                helper('form');
                $model = model(Db_model::class);
                // L’utilisateur a validé le formulaire en cliquant sur le bouton
                if ($this->request->getMethod()=="POST")
                {
                if (! $this->validate([
                'pseudo' => 'required|max_length[255]|min_length[2]',
                'mdp' => 'required|max_length[255]|min_length[8]'
                ],
                [ // Configuration des messages d’erreurs
                'pseudo' => [
                'required' => 'Veuillez entrer un pseudo pour le compte !',
                ],
                'mdp' => [
                'required' => 'Veuillez entrer un mot de passe !',
                'min_length' => 'Le mot de passe saisi est trop court !',
                ],
                ]))
                {
                // La validation du formulaire a échoué, retour au formulaire !
                return view('template/haut', ['titre' => 'Créer un compte'])
                .view('menu_visiteur.php')
                . view('compte/compte_creer')
                . view('template/bas');
                }
                // La validation du formulaire a réussi, traitement du formulaire
                $recuperation = $this->validator->getValidated();
                $model->set_compte($recuperation);
                $data['le_compte']=$recuperation['pseudo'];
                $data['le_message']="Nouveau nombre de comptes : ";


                //Appel de la fonction créée dans le précédent tutoriel :
                $data['le_total']=$model->get_nbr_compte();
                return view('template/haut', $data)
                .view('menu_visiteur.php')
                . view('compte/compte_succes')
                . view('template/bas');
                }

            // L’utilisateur veut afficher le formulaire pour créer un compte
                    return view('template/haut', ['titre' => 'Créer un compte'])
                    .view('menu_visiteur.php')
                    . view('compte/compte_creer')
                    . view('template/bas'); }
            }
    
?>