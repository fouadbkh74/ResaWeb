<?php
        namespace App\Models;
        use CodeIgniter\Model;
        class Db_model extends Model
        {

            // Devloppeur : Fouad
            // Date : 01/11/2025
            protected $db;
            public function __construct()
            {
            $this->db = db_connect(); //charger la base de données
            // ou
            // $this->db = \Config\Database::connect();
            }




            public function get_all_compte()
            {
            $resultat = $this->db->query("SELECT cpt_pseudo FROM t_compte_cpt;");
            return $resultat->getResultArray();

            }

            public function get_nbr_compte()
            {
            $resultat1 = $this->db->query("SELECT COUNT(*) AS nb FROM t_compte_cpt;");
            return $resultat1->getRow();
           
            }


            public function set_compte($saisie) {
                // Récupération des données du formulaire
                $login = $saisie['pseudo'];
                $mot_de_passe = $saisie['mdp'];
            
                // 1. Génération d’un sel aléatoire (32 caractères hex)
                $sel = bin2hex(random_bytes(16));  // 16 bytes = 32 chars
            
                // 2. Hash SHA-256 avec sel
                $hash = hash('sha256', $mot_de_passe . $sel);
            
                // 3. Requête SQL sécurisée
                $sql = "INSERT INTO t_compte_cpt (cpt_mdp, cpt_pseudo, cpt_etat, cpt_Role, cpt_sel)
                        VALUES (?, ?, 'E', 'invite', ?)";
            
                // 4. Utilisation d'une requête préparée
                return $this->db->query($sql, array($hash, $login, $sel));
            }
            
            
        

            public function get_actualite($numero){
                $requete="SELECT * FROM t_Actualite_act WHERE idt_Actualite_act=".$numero.";";
                $resultat = $this->db->query($requete);
                return $resultat->getRow();
                }

                
            public function get_actualites(){
                    $requete="SELECT a.* , c.cpt_pseudo FROM t_Actualite_act a JOIN  t_compte_cpt c 
                    ON c.idt_compte_cpt = a.idt_compte_cpt  
                    WHERE a.act_etat='Activee'
                    ORDER BY act_date_pub DESC LIMIT 5;";
                    $resultat = $this->db->query($requete);
                    return $resultat->getResultArray();
                    }
    

           public function  get_data_msg($code){
                  $requete="SELECT * FROM t_Message_msg WHERE msg_code ='".$code."';";
                  $resultat = $this->db->query($requete);
                  return $resultat->getRow();

           }
         public function   get_data_msg_by_email($email){
                $requete="SELECT * FROM t_Message_msg WHERE msg_email ='".$email."';";
                $resultat = $this->db->query($requete);
                return $resultat->getRow();
            }


    
                public function generatecode()
                {
                return strtoupper(bin2hex(random_bytes(10))); // 20 chars
                }

                public function set_message($data)
                {
                // Récupération des données envoyées par le contrôleur
                $email    = $data['email'];
                $sujet    = $data['sujet'];
                $contenu  = $data['contenu'];
                $msg_code = $data['code'];   // On prend bien le code du contrôleur !!!

                // Construction de la requête SQL (ancienne version)
                $sql = "INSERT INTO t_Message_msg 
                        (msg_email, msg_sujet, msg_contenue, msg_date_envoie, msg_code)
                        VALUES (
                                '" . addslashes($email) . "',
                                '" . addslashes($sujet) . "',
                                '" . addslashes($contenu) . "',
                                NOW(),
                                '" . $msg_code . "'
                        );";

                // Exécution
                return $this->db->query($sql);
                }

           
            }
          
?>

