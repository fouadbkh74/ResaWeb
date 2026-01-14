

--%%%%%%%%%%%%%%%%%%%%%--SPRINT 2--%%%%%%%%%%%%%%%%%%%%%%%%
--Réservations
--En tant qu’administrateur/ membre

--2
SELECT * FROM t_Reservation_res
WHERE DATE(res_date) = '2025-09-14';


--3

--SANS filtre L'UTILISATEUR
SELECT r.*,   rc.rcs_type,
GROUP_CONCAT(c.cpt_pseudo SEPARATOR ', ') AS participants
FROM t_Reservation_res r
JOIN t_compte_cpt_has_t_Reservation_res tc
ON r.idt_Reservation_res = tc.idt_Reservation_res
JOIN t_compte_cpt c
ON  c.idt_compte_cpt = tc.idt_compte_cpt
JOIN t_Ressources_rcs rc
ON rc.idt_Ressources_rcs = r.idt_Ressources_rcs
WHERE r.res_date >= CURDATE()  
GROUP BY r.idt_Reservation_res;
--AVEC filtre L'UTILISATEUR
SELECT 
    r.*,
    rc.rcs_type AS ressource,
    GROUP_CONCAT(c.cpt_pseudo SEPARATOR ', ') AS participants
FROM t_Reservation_res r
JOIN  t_Ressources_rcs rc ON rc.idt_Ressources_rcs = r.idt_Ressources_rcs
JOIN  t_compte_cpt_has_t_Reservation_res tc ON r.idt_Reservation_res = tc.idt_Reservation_res
JOIN  t_compte_cpt c ON c.idt_compte_cpt = tc.idt_compte_cpt
WHERE 
    r.res_date >= CURDATE()
    AND r.idt_Reservation_res IN (
        SELECT idt_Reservation_res
        FROM t_compte_cpt_has_t_Reservation_res
        WHERE idt_compte_cpt = 2  -- id de l'utilisateur connecté
    )
GROUP BY   r.idt_Reservation_res, r.res_date, r.res_heur, rc.rcs_type
ORDER BY  r.res_date ASC, r.res_heur ASC;

--4
SELECT r.*, rc.rcs_type,
CASE
    WHEN r.res_date < CURDATE() THEN 'Passée'
    WHEN r.res_date = CURDATE() THEN 'En cours'
    ELSE 'À venir'
END AS statut,
GROUP_CONCAT(c.cpt_pseudo SEPARATOR ', ') AS participants
FROM t_Reservation_res r
JOIN t_compte_cpt_has_t_Reservation_res tc
ON r.idt_Reservation_res = tc.idt_Reservation_res
JOIN t_compte_cpt c
ON  c.idt_compte_cpt = tc.idt_compte_cpt
JOIN t_Ressources_rcs rc
ON rc.idt_Ressources_rcs = r.idt_Ressources_rcs
GROUP BY r.idt_Reservation_res
ORDER BY tc.cpt_res_Date DESC ;

--5
SELECT r.*, rc.rcs_type ,d.* FROM t_Reservation_res r
JOIN t_Ressources_rcs rc ON rc.idt_Ressources_rcs = r.idt_Ressources_rcs
JOIN t_Ressources_rese_has_t_Indisponibilite_dsp rd ON rd.idt_Ressources_rcs = rc.idt_Ressources_rcs
JOIN t_Indisponibilite_dsp d ON d.idt_Indisponibilite_dsp = rd.idt_Indisponibilite_dsp
WHERE rc.idt_Ressources_rcs = 1
AND r.res_date >= CURDATE()
ORDER BY r.res_date ASC;

--6
SELECT COUNT(*) AS existe
FROM t_Reservation_res
WHERE idt_Ressources_rcs = 6
  AND DATE(res_date) = '2025-09-14'
  AND HOUR(res_heur) = 19;

--7
SELECT COUNT(*) AS existe
FROM t_Reservation_res r
JOIN t_compte_cpt_has_t_Reservation_res tc
ON r.idt_Reservation_res = tc.idt_Reservation_res
WHERE idt_compte_cpt = 3
  AND DATE(res_date) = DATE('2025-09-14')
  AND TIME(res_heur) = TIME('19:00:00');

--8
SELECT COUNT(*) AS nb_participants
FROM t_compte_cpt_has_t_Reservation_res
WHERE idt_Reservation_res = 5;  
--9
START TRANSACTION;

-- Vérifier si la réservation existe
SELECT idt_Reservation_res INTO @idRes
FROM t_Reservation_res
WHERE res_nom = @nomRes
  AND idt_Ressources_rcs = @idRessource
LIMIT 1;

-- Si non existante, création
IF @idRes IS NULL THEN
    INSERT INTO t_Reservation_res (res_nom, res_date, res_heur, idt_Ressources_rcs)
    VALUES (@nomRes, @date, @heure, @idRessource);
    SET @idRes = LAST_INSERT_ID();
END IF;

-- Ajouter la participation
INSERT INTO t_compte_cpt_has_t_Reservation_rese (idt_compte_cpt, idt_Reservation_res, cpt_res_Role, cpt_res_Date)
VALUES (@idUser, @idRes, @role, NOW());

COMMIT;


--10
DELETE FROM t_compte_cpt_has_t_Reservation_rese
WHERE idt_compte_cpt = 3
  AND idt_Reservation_res = 7;
--11
UPDATE t_Reservation_res r
JOIN t_compte_cpt_has_t_Reservation_res tc 
    ON r.idt_Reservation_res = tc.idt_Reservation_res
SET r.res_bilan = 'Réunion réussie avec tous les objectifs atteints.'
WHERE tc.idt_compte_cpt = 3
  AND tc.cpt_res_Role = 'responsable'
  AND r.res_date < NOW()
  AND r.idt_Reservation_res = 5;

-------------------------------------------------------------
--Ressources
--En tant qu’administrateur/ membre

--1
SELECT rc.* FROM t_Ressources_rcs rc;
--2
SELECT rc.* FROM t_Ressources_rcs rc
WHERE rc.idt_Ressources_rcs = 2;
--3
SELECT rcs_jauge FROM t_Ressources_rcs 
WHERE rc.idt_Ressources_rcs = 3;
--4
INSERT INTO t_Ressources_rcs (rcs_type, rcs_listeMateriels, rcs_jauge, rcs_photo)
VALUES ('Serre', 'Salle équipée pour les réunions déquipe', 10, 'serre.jpg');

--5
DELETE FROM t_Ressources_rcs 
WHERE idt_Ressources_rcs = 4;


