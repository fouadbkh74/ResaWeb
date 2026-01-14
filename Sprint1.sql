--%%%%%%%%%%%%%%%%%%%%%--SPRINT 1--%%%%%%%%%%%%%%%%%%%%%%%%
--En tant que visiteur
--1
SELECT a.*, c.cpt_pseudo AS auteur_login FROM t_Actualite_actu a
JOIN t_compte_cpt c ON a.idt_compte_cpt = c.idt_compte_cpt;

--2
SELECT * FROM t_Actualite_actu WHERE idt_actualite_actu = 4;
--3
SELECT * FROM t_Actualite_actu ORDER BY actu_date_pub DESC LIMIT 5;
--4
SELECT * FROM t_Actualite_actu
WHERE actu_texte LIKE '%serre%';
--5
SELECT a.*, c.cpt_pseudo AS auteur_login FROM t_Actualite_actu a
JOIN t_compte_cpt c ON a.idt_compte_cpt = c.idt_compte_cpt
WHERE DATE(actu_date_pub) = '2025-09-15';

------------------------------------------------------------
--En tant que visiteur/administrateur
--1
SELECT * FROM t_Message_msg WHERE msg_code = '50615668A00715E7D372';

--2
INSERT INTO t_Message_msg (msg_email, msg_code)
VALUES ('john.doe@example.com', 'MSG2025AUIJH98HGNBOI');

--3
SELECT * FROM t_Message_msg; 
--4
UPDATE t_Message_msg
SET msg_repense = 'Nouvelle réponse mise à jour'
WHERE idt_Message_msg = 1;
--5

-------------------------------------------------------------
--En tant qu’administrateur/ membre
---1
SELECT P.* ,C.cpt_Role FROM t_compte_cpt C JOIN t_profile_pfl P
ON C.idt_compte_cpt = P.idt_compte_cpt
ORDER BY cpt_etat ;
---2
SELECT P.pfl_nom , P.pfl_prenom ,P.pfl_numTel ,P.pfl_email FROM t_profile_pfl P JOIN t_compte_cpt C
ON P.idt_compte_cpt = C.idt_compte_cpt
WHERE C.cpt_Role = 'Membre' ;
---3
-- Exemple en pseudo-SQL pour vérifier le login et le mot de passe
SELECT *
FROM t_compte_cpt
WHERE cpt_pseudo = 'LOGIN_UTILISATEUR'
  AND cpt_mdp = SHA2(CONCAT('MOTDEPASSE_UTILISATEUR', cpt_sel), 256);
---4
SELECT p.*, c.cpt_pseudo, c.cpt_Role, c.cpt_etat
FROM t_profile_pfl p
JOIN t_compte_cpt c ON p.idt_compte_cpt = c.idt_compte_cpt
WHERE c.idt_compte_cpt = 8; 

---5
SELECT COUNT(*) AS nb
FROM t_compte_cpt
WHERE cpt_pseudo = 'LOGIN_UTILISATEUR';


---6
INSERT INTO t_profile_pfl (pfl_Nom, pfl_prenom, pfl_numTel, pfl_date_ncs, pfl_email, idt_compte_cpt, idt_codepostale_vil, pfl_adresse)
VALUES ('NOM', 'PRENOM', '0601020304', '2000-01-01', 'email@example.com', @id_compte, 75001, 'Adresse complète');

INSERT INTO t_compte_cpt (cpt_pseudo, cpt_mdp, cpt_sel, cpt_Role, cpt_etat)
VALUES ('LOGIN_UTILISATEUR', @mdp_hash, @sel, 'membre', 'A'); -- ou 'admin'

---7
-- Un compte invité
INSERT INTO t_compte_cpt (cpt_pseudo, cpt_mdp, cpt_sel, cpt_Role, cpt_etat)
VALUES ('user345', @mdp_hash, @sel, 'invite', 'A');


