
--%%%%  ACTIVITE 2 : %%%%--

SELECT GROUP_CONCAT(`cpt_user-name` ) FROM `t_compte_cpt`;


DELIMITER //

CREATE FUNCTION getEmailsParticipants(p_reu_id INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE email_list TEXT;

    SELECT GROUP_CONCAT(pfl_email SEPARATOR ', ')
    INTO email_list
    FROM t_profile_pfl
    JOIN t_compte_cpt 
        ON t_profile_pfl.idt_compte_cpt = t_compte_cpt.idt_compte_cpt
    JOIN t_Participe 
        ON t_Participe.idt_compte_cpt = t_compte_cpt.idt_compte_cpt
    WHERE t_Participe.idt_Reunion_reu  = p_reu_id;

    RETURN email_list;
END;
//

DELIMITER ;





--%%%%  ACTIVITE 3 :  %%%%--


DELIMITER //

CREATE TRIGGER trg_before_update_doc_pdf
BEFORE UPDATE ON t_Doc_Pdf
FOR EACH ROW
BEGIN
      IF OLD.pdf_chemin LIKE 'CR en attente'
    AND NEW.pdf_chemin LIKE '%.pdf' THEN

        SET NEW.pdf_intitule = CONCAT(
            NEW.pdf_intitule,
            ' - CR mis en ligne le ',
            DATE_FORMAT(CURDATE(), '%d/%m/%Y')
        );
    END IF;
END
//

DELIMITER ;

--Les testes :

INSERT INTO t_Doc_Pdf ( idt_DocPDF,pdf_intitule, pdf_chemin, t_Reunion_reu)
VALUES ( 1,'Compte rendu réunion projet', 'CR en attente',5);



INSERT INTO t_Reunion_reu (idt_Reunion_reu,  reu_sujet, reu_date, reu_lieu)
VALUES ( 1, 'Réunion des membres', '2025-10-20 10:00:00', 'Salle de conférence 3');



DELIMITER //

CREATE TRIGGER before_delete_reunion
BEFORE DELETE ON t_Reunion_reu
FOR EACH ROW
BEGIN
    -- Supprimer les participations associées à la réunion
    DELETE FROM t_Participe
    WHERE idt_Reunion_reu = OLD.idt_Reunion_reu;

    -- Supprimer le document PDF associé à la réunion
    DELETE FROM t_Doc_Pdf
    WHERE t_Reunion_reu = OLD.idt_Reunion_reu;
END;
//

DELIMITER ;


-- 1️D’abord, supprimer l’ancien trigger
DROP TRIGGER IF EXISTS after_delete_participe;

-- 2️ Créer le nouveau trigger
-- (coller le code du trigger ci-dessus)

-- 3️Tester :
DELETE FROM t_Reunion_reu WHERE idt_Reunion_reu = 1;



--%%%%  TRIGGER BONUS  %%%%

DELIMITER //


--test



DELETE FROM t_compte_cpt WHERE idt_compte_cpt = 4;









SELECT getEmailsParticipants(3); 

DELETE FROM t_Reunion_reu WHERE idt_Reunion_reu = 1;

UPDATE t_Doc_Pdf
SET pdf_chemin = 'documents/CR_1234.pdf'
WHERE id = 1;














CREATE TRIGGER before_delete_admin
BEFORE DELETE ON t_compte_cpt
FOR EACH ROW
BEGIN
    DECLARE id_admin_principal INT;

    -- On cherche l'id du compte qui a le rôle 'admin_principal'
   SELECT idt_compte_cpt
    INTO id_admin_principal
    FROM t_compte_cpt
    WHERE cpt_Role = 'Administrateur' AND cpt_pseudo ='principal'   
    LIMIT 1;

    -- Si le compte supprimé est un admin
    IF (
       OLD.cpt_Role = 'Administrateur' 
    ) THEN

 -- Supprimer les réservations associées (sinon FK bloque)
    DELETE FROM t_compte_cpt_has_t_reservation_rese
    WHERE idt_compte_cpt = OLD.idt_compte_cpt;

        -- Supprimer les actualités qu’il a créées
        DELETE FROM t_Actualite_act
        WHERE idt_compte_cpt = OLD.idt_compte_cpt;

        -- Réassigner ses messages à l’admin principal
        UPDATE t_Message_msg
        SET idt_compte_cpt = id_admin_principal
        WHERE idt_compte_cpt = OLD.idt_compte_cpt;

    DELETE FROM t_profile_pfl WHERE idt_compte_cpt = OLD.idt_compte_cpt;
    END IF;
END;
//

DELIMITER ;


CREATE TRIGGER  trg_hash_password_before_update

BEGIN
    -- Si le mot de passe a été modifié et qu’il n’est pas déjà hashé
    IF NEW.cpt_mdp <> OLD.cpt_mdp AND CHAR_LENGTH(NEW.cpt_mdp) <> 64 THEN
        SET NEW.cpt_mdp = SHA2(CONCAT(NEW.cpt_sel, NEW.cpt_mdp), 256);
    END IF;
END


https://obiwan.univ-brest.fr/~e22509077/index.php/admin/lister_membre
