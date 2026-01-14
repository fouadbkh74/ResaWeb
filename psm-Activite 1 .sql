--%%%%  ACTIVITE 1 :  %%%%--

DELIMITER //
CREATE FUNCTION Nbr_prs_reu(id_reu INT) RETURNS INT|
BEGIN
 IF id_reu THEN
    SELECT idt_compte_cpt AS nbr_part
    FROM t_particip WHERE id_reu =
 RETURN nbr_part;
 ELSE
 RETURN -1;
 END IF;
END;
//
DELIMITER ;


--La procedure


DELIMITER //

CREATE PROCEDURE CR_reu_pdf(IN id_reu INT)
BEGIN
    DECLARE nb_part INT DEFAULT 0;
    DECLARE sujet_reu VARCHAR(100);
    DECLARE doc_existe INT DEFAULT 0;

    IF Nbr_prs_reu(id_reu) != -1 THEN
        SELECT reu_sujet INTO sujet_reu
        FROM t_Reunion_reu
        WHERE idt_Reunion_reu = id_reu;

        SET nb_part = Nbr_prs_reu(id_reu);

        SELECT COUNT(*) INTO doc_existe
        FROM t_Doc_Pdf
        WHERE t_Reunion_reu = id_reu;

        IF doc_existe = 0 THEN
            INSERT INTO t_Doc_Pdf (pdf_intitule, pdf_chemin, t_Reunion_reu)
            VALUES (CONCAT('CR ', sujet_reu, ' (', nb_part, ')','Participants'), 'CR en attente', id_reu);
        ELSE
            UPDATE t_Doc_Pdf
            SET pdf_intitule = CONCAT('CR ', sujet_reu, ' (', nb_part, ')')
            WHERE t_Reunion_reu = id_reu;
        END IF;
    END IF;
END




DELIMITER //

CREATE TRIGGER after_insert_participe
AFTER INSERT ON t_Participe
FOR EACH ROW
BEGIN
    CALL CR_reu_pdf(NEW.idt_Reunion_reu);
END;
//

CREATE TRIGGER after_delete_participe
AFTER DELETE ON t_Participe
FOR EACH ROW
BEGIN
    CALL CR_reu_pdf(OLD.idt_Reunion_reu);
END;
//
DELIMITER ;

--les testes :

CALL CR_reu_pdf(90);

INSERT INTO t_Participe (idt_compte_cpt, idt_Reunion_reu)
VALUES (5, 3);

DELETE FROM t_Participe
WHERE idt_compte_cpt = 5 AND idt_Reunion_reu = 3;


CALL CR_reu_pdf_SPA(3);



--La procedure avec le separateur


DROP PROCEDURE IF EXISTS CR_reu_pdf_SPA;
DELIMITER //

CREATE PROCEDURE CR_reu_pdf_SPA(IN id_reu INT)
BEGIN
    DECLARE nb_part INT DEFAULT 0;
    DECLARE sujet_reu VARCHAR(100);
    DECLARE doc_existe INT DEFAULT 0;

    IF Nbr_prs_reu(id_reu) != -1 THEN
        SELECT reu_sujet INTO sujet_reu
        FROM t_Reunion_reu
        WHERE idt_Reunion_reu = id_reu;

        SET nb_part = Nbr_prs_reu(id_reu);

        SELECT COUNT(*) INTO doc_existe
        FROM t_Doc_Pdf
        WHERE t_Reunion_reu = id_reu;

        IF doc_existe = 0 THEN
            INSERT INTO t_Doc_Pdf (pdf_intitule, pdf_chemin, t_Reunion_reu)
            VALUES (
                CONCAT('CR - ', sujet_reu, ' (', nb_part, ')'),
                'CR en attente',
                id_reu
            );
        ELSE
            UPDATE t_Doc_Pdf
            SET pdf_intitule = CONCAT('CR - ', sujet_reu, ' (', nb_part, ')')
            WHERE t_Reunion_reu = id_reu;
        END IF;
    END IF;
END;
//
DELIMITER ;

--Les tests :

CALL CR_reu_pdf_SPA(3);


