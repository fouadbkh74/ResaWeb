-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : ven. 21 nov. 2025 à 19:06
-- Version du serveur : 10.11.11-MariaDB-0+deb12u1-log
-- Version de PHP : 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `e22509077_db1`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`e22509077sql`@`%` PROCEDURE `CR_reu_pdf` (IN `id_reu` INT)   BEGIN
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
END$$

CREATE DEFINER=`e22509077sql`@`%` PROCEDURE `CR_reu_pdf_SPA` (IN `id_reu` INT)   BEGIN
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
END$$

--
-- Fonctions
--
CREATE DEFINER=`e22509077sql`@`%` FUNCTION `getEmailsParticipants` (`p_reu_id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
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
END$$

CREATE DEFINER=`e22509077sql`@`%` FUNCTION `Nbr_prs_reu` (`id_reu` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE nbr_part INT;

    IF (SELECT COUNT(*) FROM t_Reunion_reu WHERE idt_Reunion_reu = id_reu) = 0 THEN
        RETURN -1;
    END IF;

    SELECT COUNT(*) INTO nbr_part
    FROM t_Participe
    WHERE idt_Reunion_reu = id_reu;

    RETURN nbr_part;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_Actualite_act`
--

CREATE TABLE `t_Actualite_act` (
  `idt_Actualite_act` int(11) NOT NULL,
  `act_titre` varchar(45) NOT NULL,
  `act_texte` varchar(200) DEFAULT NULL,
  `act_date_pub` datetime NOT NULL,
  `act_etat` varchar(20) NOT NULL,
  `idt_compte_cpt` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Actualite_act`
--

INSERT INTO `t_Actualite_act` (`idt_Actualite_act`, `act_titre`, `act_texte`, `act_date_pub`, `act_etat`, `idt_compte_cpt`) VALUES
(1, 'Lancement du jardin partagé', 'Le premier espace de culture est prêt ! Les membres peuvent réserver leurs parcelles dès aujourd’hui.', '2025-09-11 12:00:00', 'Desactivee', 1),
(2, 'Lancement du jardin partagé', 'Le premier espace de culture est prêt ! Les membres peuvent réserver leurs parcelles dès aujourd’hui.', '2026-01-19 19:11:34', 'Desactivee', 1),
(3, 'serre num2 déja occupée', 'Une serre éco-conçue est maintenant disponible. Réservez votre créneau pour vos semis et plantations bio.', '2025-09-13 12:00:00', 'Desactivee', 2),
(4, 'Lancement du laboratoire de recherche éco', 'Le laboratoire de recherche des Jardins Solidaires ouvre ses portes ! Un espace collaboratif dédié à l’expérimentation écologique et à l’agriculture', '2025-09-14 12:00:00', 'Desactivee', 3),
(5, 'Nouvelle serre écologique', 'Une serre éco-conçue est maintenant disponible. Réservez votre créneau pour vos semis et plantations bio.', '2025-12-14 19:11:01', 'Desactivee', 4),
(6, 'Atelier compostage', 'Venez apprendre à créer un compost naturel à partir de vos déchets organiques.', '2025-09-15 12:00:00', 'Desactivee', 5),
(7, 'Journée internationale du bio', 'Rencontre entre membres et partenaires étrangers pour partager autour de l’agriculture durable.', '2025-12-17 12:00:00', 'Desactivee', 6),
(8, 'Partage d’outils communs', 'Les outils collectifs sont disponibles via la plateforme. Pensez à réserver avant utilisation.', '2025-11-18 12:00:00', 'Desactivee', 3),
(21, 'Lancement du 2eme jardin partagé', 'Le premier espace de culture est prêt ! Les membres peuvent désormais commencer à planter.', '2025-12-11 12:00:00', 'Desactivee', 99);

-- --------------------------------------------------------

--
-- Structure de la table `t_compte_cpt`
--

CREATE TABLE `t_compte_cpt` (
  `idt_compte_cpt` int(11) NOT NULL,
  `cpt_mdp` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `cpt_pseudo` varchar(45) NOT NULL,
  `cpt_etat` char(1) NOT NULL,
  `cpt_Role` varchar(15) NOT NULL,
  `cpt_sel` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_compte_cpt`
--

INSERT INTO `t_compte_cpt` (`idt_compte_cpt`, `cpt_mdp`, `cpt_pseudo`, `cpt_etat`, `cpt_Role`, `cpt_sel`) VALUES
(1, 'a7b46f8edaeb5545b7ad3dbd57c9b3653166aa4c1a322e25302f6e420f6bbc78', 'principal', 'A', 'Administrateur', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(2, '3153e39b95bfa3e5084913916e21f6e20aad3d9dbde266dd98349cc9c959fbdc', 'samir.benkacem733', 'A', 'Administrateur', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(3, '7355275610b30c03feae9e0be4c004072311e85c1c40b1380bb978820be0d1db', 'hamad.alsuwaidi389', 'A', 'Administrateur', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(4, 'f89ce3edbaddef3ea6d95397f707b2276fa1de4edccdaf48d260d8ddbebd9e60', 'nour.jaziri591', 'A', 'Administrateur', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(5, 'fe471d45658b978e9d1d9e9ad46e61302b9c73446e3df22bd9d51c5d535cfbf3', 'rico.manu568', 'A', 'membre', 'f3a8a694-be61-11f0-8c92-bc24112d7a8d'),
(6, 'ba65a78056fa90f1922ca374486337be145deb1d8ecff20b25ad668b7c19d9ec', 'hassan.moulay863', 'A', 'Administrateur', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(7, 'ba65a78056fa90f1922ca374486337be145deb1d8ecff20b25ad668b7c19d9ec', 'tiago.medeiros146', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(8, 'fdde0b0293fba231bcad7ad82737635b98cb12bd357171ea3e55d8fb0f141b0f', 'imane.ouarzazi773', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(9, '888674703e0ff7dfb051c8fa70dd1f9f6444b7b28dffb585317556402673c414', 'rachid.ouarzazi698', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(10, 'cf3c900c02d592c790991e76ce3ace29fe37c48f7c591b69ab112d6109e2d2c5', 'william.taylor891', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(11, 'd72dac54e2a25a3cc4022a95631db39441da8be465390648430cb9b49a16b062', 'yacine.nacer899', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(12, '87d6d09d3fa7dd420cc1d36b3bf48c71020274e9fc89c50653f073ed8a24f248', 'alice.walker169', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(13, '44041c8529dbc72b2b7718fb92e3cd3624f5dfcfbf0a8ccd69e06b9cc88f5716', 'imane.ouarzazi253', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(14, '604dd341544a721248a8d8368b6ecabca782886109b49427d408a01422a6b236', 'nora.cherif927', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(15, '82dd791148564a7c6da0cce9d89d40a764f17a376b0ad7fc228c18ec40dce0e2', 'ana.medeiros826', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(16, 'b27da635009e2417b535c8b6c7354e10fd5adb7b0422f09415a4e13e8edd95ef', 'paul.lefevre745', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(17, '14744a79b3ad2a70375d1aaf80b834d0fe97e85e45af8f71b39f29c78e98163b', 'camille.robin100', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(18, 'fb45ffe462ac0199f534d1dd8d5de3584ece4d2562927c4307445daa29f7105a', 'carlos.perez271', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(19, 'b1e57c3260263458f3decc5f818172bd5e809ff72bb2ca019879eec9c10e157c', 'sonia.benali051', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(20, 'ca147c9fb00a3138659e03b287eb49805a1ad2f545a40fe16184a4a57a20648a', 'joshua.williams964', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(21, 'cd58a7f17ae1ba4b1f0593d29477f41d032c4f722903886dd9d9eb20afbfd4f1', 'lina.almohannadi405', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(22, 'c52071294f899907b3e2ccea671dcef0a2c0f88cb7eca55825df66dab9a26a80', 'andrew.davis135', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(23, 'd3bc58db2e54e72c413fcf27698dacface33b39bf5e5a2c74420915c9ce845b5', 'nora.ouarzazi961', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(24, 'b1991bf97f34c63128139e583aa564412f87bb9b6d20d7a2bc79b9f2afc82f0f', 'meriem.fakhfakh257', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(25, '47e72687bcfae5a8365e5cb217387b68ec899138fa2fb2b7ef0b160262afcf6c', 'carlos.rocha574', 'A', 'Membre', '0f8fd34c869e2fc7a0389ce1c2d7db66d46c726ed3a8bf19e2f5f78105fd3bb9'),
(26, 'ecc1aad57e2203fee853bee81ffa3a39efa90a4cf655a8fb98ffedce318d5b3f', 'safa.karim920', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(27, 'ef7edbc05931ecf58ad8a706b5e0a88b2a2ae7e361fb1f30f91e75f3a2f5b10e', 'thomas.smith183', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(28, '1167d475768de9a79c6d8e508fac2b10f58d66d7c1c60bb04eb6ea79f5bdb1f6', 'khalid.aldosari228', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(29, '3aa24fc776559cc59434e00b3754e4688d76cf3930cfc996a6d4797e5b02dea9', 'salma.elamrani118', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(30, '3df5a018cfc37268f7a2309e755a5f9465799be2d6dee76fce13d979ff60eec6', 'youssef.ait921', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(31, '6778427a5c2473fcad11fc1b881ef3b8ef876c84344a9e389f0ffb4ea277ef8a', 'reem.alobaidli679', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(32, '82b9e2915cda660be36770609ae6d9ac1949dbf044a948b43d4e64e88f06bf6b', 'javier.moreno582', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(33, '34920b7ce5cae0ac0ed38d3433bd5c614918b4f062320ac564197c75cecc0048', 'marta.santos523', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(34, '0015636f971ca38285e118b8b8945d43d6c69561859d0bd6c15af00928c8e097', 'james.smith250', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(35, '57fa1c29edd024cdb1b616a0921ae5dcca15c11c23f4033a31fd755512187f29', 'yacine.benaid224', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(36, '777c9cebdc1c9d3cd8f2fd71b0c9e74074418d8089ffc5c0fdaa7074fdd473c8', 'rana.alsaid834', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(37, 'd5b50a0d8f70e10fe5d7d2bf38735f1be6a83d2a0475c2444380cc0a1d09573c', 'meriem.fakhfakh641', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(38, '10a568478ac5f2f6780b7d49f953cea8de7f087b5aa8e4fd04fd1d0a1bead72a', 'emma.thomas710', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(39, '16be64110e4f3914990a65869a72bd5030ec4befb030537dc8a89113f7eb96e1', 'sofia.garcia877', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(40, '69d6970a2cb8c0ba3a89d8b41b2ba4ffa8795b14de302d6da3d76d49f43410e2', 'amanda.brown279', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(41, '38b4951d09a22531498a37d1c7fc248ee20fb75390ec4745093411b12c9dfd2d', 'yacine.benaid138', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(42, '665c64f3f12bfb3bcd55281f889264b322f709db381fcc76c1d3c9bcbeaaf3cb', 'alvaro.martinez481', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(43, '26de50b0bfa96d2f08bb2b49bca633a704619c09594ddfa477ee2b467e45659f', 'daniel.moore685', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(44, '16464fd4aa1f876dc07a783dbe85c3670ef2a5db7cf291bb1dc512b5920938ab', 'amel.zitoun693', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(45, '7d8d7d0d46220cef33fa07a67ccdcee19c29e798c0e8418157336871707fd065', 'omar.alkaabi677', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(46, 'a9e50b09a3c9640e473a797f207e6a30dbd13ca2280c377d828011b26aa606c4', 'thomas.brown751', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(47, 'c8c67fe1d0a6d67eea8ec98a5ed975d1348f2f5c6f4e31f78dbed1b15f1e44cb', 'karim.trabelsi768', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(48, '4a2b67d7f990c90dc9aaeaea99ffdfeec5ee9c57276161116e213b5b3ea426cb', 'safa.mansour901', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(49, 'f7aecd956559aba90a302e801623b03394a965c70d0dce672511fc45fe5b92de', 'amanda.moore458', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(50, '4199d247896ba03aecb55d28b01b801462bcc7221b277b8294f350b9491ddaa5', 'salma.moulay719', 'A', 'Membre', '2e8954fcac5e0a676e604a562df40e7ee8459fb5d65479ae0292d072abe4da1a'),
(51, '2ff194c50156069c8857794d7e186800dde049140ca780e5fa7ed98c482e76e0', 'emma.wilson756', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(52, 'fd334bce7d7cc931bdfc39e1dd7a8b1eeccf83cd0e364da484473810c64c145a', 'samir.boukhari280', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(53, '8decb71387581df05af79effab4fc9af83ab9e29d4ce8b5aa8fb35dfa30f45e0', 'nasser.althani258', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(54, 'e6bd9c67d9958f61d849d39e6bebe8c6d46a114c4876e2b8436253c31f631699', 'amina.trabelsi121', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(55, 'bf225197e89cf66b7230a1427f05256d4187862495eefca21c8704bc3597a498', 'alvaro.moreno635', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(56, '4b3d017a4fda705715543cc0b43a5087363b96ed01aa2e8d42d709df49ccd572', 'sofiane.messaoud705', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(57, '131ebaba9e45e8ceb7bf161bf279dbbaaff526d8d57f20e5167d5ac6cf81cf68', 'joshua.williams557', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(58, 'ee3d7fc003083bbabff9dff19f0523ed13497da7ccbfffda7f494c588167f509', 'ibrahim.mansour512', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(59, '53ae913fbe20dda9c0714be2c3840c98b0197407e3d9fa28d01aa9534e285b1e', 'sarah.anderson973', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(60, '57591f9d048f2d77ca4eb9dee5a47c735ca04ba1167d6fdb8f8799240ed84ea3', 'camille.laurent418', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(61, '2f5b98a27f7f3b9c87f9485d7085342a40c37cd170e01fd7310ef013f501fc8c', 'claire.moreau331', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(62, 'e73c593055f90eea4c22632cdfea6c051f677da3e6a9980bd58a3310f050bace', 'marta.costa208', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(63, '90e3fd8641277f745fa6759fc976dc742a43ef5809abb2621555aa27a26a4dc1', 'rachid.elidrissi417', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(64, 'aebb10e58dac08678bf7982c168a2f2343553d7e6c7d88da2b046f27e08eb64c', 'ana.medeiros564', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(65, 'f1d5712d34e37be1ad361807eb1dddbf188a62d48f20157868dd99c98acc0eb4', 'mouna.miled593', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(66, 'b92b43b405ff2f61187bd76f8384c4cafdf3df4878a1a651e7d7238e28866d1b', 'lina.aldosari585', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(67, '21c1bdbe86425961faee248f02b2331281634337b11ca71a2b1740227b2fe166', 'karim.khelif988', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(68, '10c16375a3c1f424c8d4850a90dd7020eae88b0195eb53617ed254938772ec6e', 'miguel.oliveira638', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(69, '1ab7620a22fb1909f1d5f63bedc5dad07bb45895eb0020d7e91e3165d2d42771', 'leila.khalifa444', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(70, 'e445a0688aa915e769648a0f87abf07418fa9507a8260448f8cb9fce326d8c9c', 'javier.sanchez543', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(71, 'a1d221127f305bbe963d6568682c547857cf1145dbba0bf25cc26da3d48a8dee', 'emma.robinson653', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(72, '85d74ff9e40c9e68504327d80fa2f8d3e990901d25e730bc80fa3f8ac6dcb9ef', 'alvaro.rodriguez865', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(73, 'de7b35d5104d49e5d6efb029e79781f72295fd895a84978d78e16162581d85b7', 'sofiane.bensaid008', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(74, '3a13b209cfe784958bf540211b398c5531206154f35855c44c90167ceeab7456', 'olivia.smith316', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(75, 'aae0d877484ab59fc9d06dbf8615c249c9ed8f8ac5f59a9c38162d4a993950d3', 'omar.alhajri935', 'A', 'Membre', '6492607f4ca9b02b817881ae33423ca93240cd5c138b27671eaf34a7aa329e9a'),
(76, '8070185a05ac40d93eaebb11a8d77a3b6d8574102a007222c4a27277bd37b0c5', 'pablo.fernandez092', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(77, '5490594dc0bd419934cf9176f1d4393c2304e8ffaa318095e73ec10b1a348388', 'amanda.johnson634', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(78, '6bd18b739f3ff77a40c2c5ddcfb2e487af32341613fc94a53c1456e1076c2b2a', 'marie.dubois908', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(79, '80ac32a600c2a22dc986d011ccc06a311462dff18a2b744535a6a3e6549948f0', 'alvaro.garcia706', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(80, '2018c35ce4bdbebe9be0da5f001f7d5d6a52b21eb4576a436c557a72740d4ff5', 'leila.khalifa971', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(81, 'f259635dbe2349f1bfabaa14e6cd368ab158e5e40c17699bbcadcc03cd66af58', 'hassan.ouaziz221', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(82, '9abd43ae3d7ed8deb696369f8cfdcad4b0a770188cb817b79d30222b11c6c2cb', 'karim.benali366', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(83, '65efbfebdba6b8f16e5d8dd1dd1cb0586c300de28040401657b0b96fa4204498', 'marta.oliveira525', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(84, '226de6c2f6990e2b9a928fe7c6894a055a4ade8baa6ce8dc92517e7cdc8e0f85', 'tiago.rocha702', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(85, 'fa10d6e4c2b72261fcb7c375a2fa88553b6bea8d7f8f5cafd792ec66f50d79dc', 'salma.ait611', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(86, '5d24f943e9673ffb9bcc1d96f41e2deb09f41207d1f26ea5b46c91b781918c36', 'joshua.miller847', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(87, 'd3d2fd44c18e4bbafd684c9a2586b93f89629245607b1bcc80d64e8d2eeab016', 'marie.lefevre098', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(88, 'e3e321507eafbc6bbc29025dafb5b29e26df23a6c988e3b827924f4115c8d2f9', 'carlos.gonzalez614', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(89, '27288c7f60d0d77c3f2f810003b2fb1bddbc6ecd3050ee0e257e8f34d498fb16', 'hamad.almohannadi587', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(90, '3cec60e108f34579e26873a5b4ca74437671d0f744625bec8268ddbdbba0e7de', 'henry.evans943', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(91, 'e80ddfdc7a678893f81131c2ae07544e9434a2f287cabd2e23eafc31c049203f', 'hassan.ait429', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(92, 'eec74ec0f030a44512665320314853140a00e761cd850853957088b5243fe0fe', 'yacine.bensaid453', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(93, 'ae4ce548bd7d00aa277ccaafa366cc548afc973b8b036a8ce27057d6321541d6', 'carlos.pereira046', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(94, '562960a04269eb39eef9e8601b73a823314b714a9a14fb9d315c869a8f7c5132', 'paul.rousseau764', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(95, '9d3919d9c4a3a5859f5bd9ce413339cca6e9787d7722a34eec9ba9f77f0a9acf', 'sofiane.benali470', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(96, 'b08bfcc0dd38ab5f6b82c6dc0dc6716aef924b623ace370eee369fa4397afc3c', 'beatriz.fernandes447', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(97, '01f949850ac44b84e8eb96233a4eef718ffd3631f575ca96387954ab68014183', 'olivia.walker648', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(98, '7293ed4de5e186689074f4165585373cdec63607a1d6f71b83a95222419eee6e', 'olivia.brown974', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(99, '65da5a9bc66ec6cabd345d8c953ec62fe918ed2b722bad05c2b7be46ae1b6955', 'miguel.pereira605', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(100, '17f393ae39b5915bdcf3f165043da2ad1b988eb064a53575d2343739d96029cf', 'lucas.faure519', 'A', 'Membre', '6288fd5003a704b41f2006c5643e5f35fc856638c7cb0acbe38faee2b31f8e11'),
(101, '51190e5d54b9372fa86983d491508e440030e721ab1ed43caee0f0e61c2996d7', 'youssef.cherif830', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(102, '872f61a04caad69c1a656cf060f5165b2afaf500d8c90e08ffafaac2bd7a3006', 'khalid.alkaabi418', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(103, '132a64823a8ea1bd7c902638ae773f1680e7de941f301e84b643d13c8468eca6', 'charlotte.taylor596', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(104, '0e37c31cfd6da9a5d10934096aaabaec3b03dc55fdeee13e2aaf1c27ca323ce7', 'william.taylor661', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(105, '6cd2ba3a2c9625d0ba374976b094a8f74fd0024e89f863d0c5e153447e5c6688', 'george.taylor302', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(106, 'b35f328bd9af017e41f68925b687461992830fe3b49777ae6baffd434ae1fe6e', 'alice.smith420', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(107, '579b9b17da5983defe8e16e6624023c2bd1d69c7b0c6e890254258070ffca89c', 'reem.alnaimi472', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(108, 'a66f86c7cf1fae44bdad5726c3f24528541edcb883665eb0a8ae55886b02ec53', 'beatriz.nunes956', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(109, 'bd4eae8f9790caa8d0a2abf7f57fb25b123bcd8898eeea937cd300a0b2cec4ec', 'beatriz.costa424', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(110, '8b1a933dfa3176074cb80ee50abbd87d344ac371009c523ee7caad29fdf24a68', 'nasser.alkuwari039', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(111, '6228bb1b55ab8b285199d981c292d489b6967d09bf25a5ef8312798b17bd40aa', 'lamia.elidrissi433', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(112, '0d2c95fa42cc6ea5881524dc57c121b83cd87bce13769a6b21a28fd2e77103aa', 'rachid.elidrissi588', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(113, 'bd893237ea4245101decb52316e0416282949331a1af7f33df50fc8b7372d389', 'marion.laurent069', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(114, '6e54dd767ef785a357cdf0435e6e38652f4640453891159dcb6da5db269e0795', 'sonia.cherif353', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(115, '3e6e6fff99fe74fc9237cb02612d292715d8a13fd43756c84dda3e3f41f8dd5a', 'marta.silva830', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(116, 'd1018cac142c15e3e1f9543c41277060604b7c61ddac055a53b80438cbdad0aa', 'imane.elhaddad037', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(117, '21adf903e76f37f1caa7c6c324728bc7b15aa7367e8fe7dc522782b9b9203582', 'nasser.alnaimi708', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(118, '916d48ac75f5d92e951d50719dc96e868077b8399f08683ffa74b1fe8f83d9b6', 'hamad.alsuwaidi335', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(119, '68044ab1fcadffb2372b3df1be9253d0b7e9a952a3731020a60bc8f16d0a8d23', 'alvaro.garcia076', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(120, '83fa7fa86c20e45f80913e1c83f4984a24fd97b0d1c7d5d5399140b62a7a1806', 'aisha.alkaabi972', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(121, 'd9df843477f73aaf06d6376a76f4fedb61c15f3bb653eae4ff958e643a0972aa', 'salma.ait321', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(122, '900256a838a6fc0624b50d6117b36f05ec1e5d88e4a8948e7855ec79153cd2db', 'ana.carvalho292', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(123, 'df1d191a43515b83c209227d6fd7c2d4b71735c45facf272fae0ff6ff137eac1', 'marion.robin297', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(124, '779b0763fa812f732f0a6d11f6d737849cf39fa0731d38fd627036444e8f369d', 'lamia.moulay478', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(125, '5263e932ae917c405d39b10f69c0dda142ee357aff99b99ac3a0bd6b29b6fb5c', 'luc.laurent657', 'A', 'Membre', '17df5295317a6c8297a2c91e394f4a6ca38e637d1160b48649a787cfe688734a'),
(126, '4f894ff02ad23b8d314d5a63797e728aa901add19eaa4764383957a29e56192a', 'yacine.khelif156', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(127, '2351ae5b8a8c0bfbeece7d1f4238b26022c1af1c65d63c7e7174d9ed003fdb03', 'habib.mansour629', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(128, 'ed016b58b2dd8c5d7ded2a0fcd2525ce9d18c2afc413a514c0da4525d781822a', 'reem.althani845', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(129, '3e656a9bc51d2cd034823d72377659ca180ca427ee7a010122c82db9f43cc433', 'nora.elhaddad494', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(130, 'b72748494a0550742e1fa9706fe2566b180c1b69b3ec86f696542a62c4b63666', 'charlotte.johnson751', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(131, '7785911b4b9f0118f6856fafcff5203068317aee8cc16f08bec22206c8ce1658', 'daniel.williams051', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(132, '1fdbbdca42e036dc43144990c1a62596a6de7bf34ffc2e92a621d6def2d8163d', 'marta.pereira509', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(133, '9f781698b8a737dab1d6cbcfb45976baf5dac6dbb8d9a226b0b9b77950bdb461', 'miguel.nunes008', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(134, '83e4faf4c2a9a0cbc7575f3f7d202eb53d75a84aecbc52e29cc15d41c55ce59f', 'omar.almohannadi075', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(135, '1504306f29e392156dc874408a01c73f6116f6454ff11299c133e3c3a28029ca', 'omar.alobaidli773', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(136, '5433f1ec7e7abe0dbaaf581e13c174d30c792647727897c7127b1032086dc0a3', 'carlos.medeiros152', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(137, '3f436dc6ba6b0470b4b0b6d8b13a8237631cc2090c5774ba06d4fd5dde958bfa', 'kamal.elidrissi501', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(138, '77f0541cc5db1117be945138db7709fb3a6d32b69c379b55e6e70e041453e429', 'khaled.messaoud271', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(139, '76e399a38dee58bb19866931e81cafe47b279dfb741daceb189f0fb732ca862d', 'michael.anderson970', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(140, '3a88f6c2b08f3bb56d57ff9ce9a420771aaf76a0818d0b653243d28de587d560', 'karim.khelif212', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(141, '46d115c3fefcf890a872888f1c3bb8547b4879a6490f63666eced6920da2a578', 'nour.fakhfakh196', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(142, '691471b2da56638fd56e9c56f2aa0d5c43eb8679b37c98260c4435cb29f2b6f9', 'beatriz.nunes814', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(143, 'b14f6e90fc43d466dada9f3fa63e9af52f0cdb27f2e28b441e78bbc9d74b19e2', 'claire.rousseau671', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(144, 'd70ee0851c1e97b3bb0818da61bd7793df7b102c31b87a0bb61bc2baebc6049d', 'ashley.johnson685', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(145, '638a92dde84695f018b0ee5bde6f87f0794adf2cbc27cfbce46c7f36f4bfbf57', 'marta.santos774', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(146, 'f86ea6d95a0826b5cf4dcb4a3a0c9f2f3039559f431f1394ccdf13805898faa5', 'sofiane.messaoud190', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(147, '5dbfcff5cbe7653491d75589f9bbac534fc3ec1099447ed674ec4befe9dcc87d', 'joao.nunes479', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(148, '3ed37b9979230f7122923f3b022038cb672ac2b27053523baafc7cfbb41c2117', 'daniel.anderson876', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(149, '2d659c5198d0197b23c0f40cdb24d60a2066142d0089d687ed1071e5c40ff8f9', 'lucia.rodriguez771', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(150, 'ac555433ba90d6a6ec8487723bb1c270f0af4c382276a193bff03eaa890901df', 'habib.gharbi702', 'A', 'Membre', '7ba78f2f3b5bde055ffe42b317ef50d1b781bf12260b86e7cb5cb1f158c48b80'),
(151, '5bc9896dc7e92d608000f45ac8d03fc25733a19150b5839d148981dc5a0ec752', 'faisal.alhajri934', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(152, 'dba0be0aebefe4ccd6b318dea9dfc05acb3234890a2c85ad37747e145a233838', 'paul.robin924', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(153, '68f62c1210dee290de482f0f9066f5bdb84eaf2bd3627261487d65979ad6c874', 'ines.nunes456', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(154, 'e1031a6d4ef5408bc2c7e02fff116da2b703b4a6f53aca20dac263c622f66a87', 'sofiane.bensaid836', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(155, 'd63a9cc08ab30cbebc43a80d6c397e6b9ee20c7510c2a6214361fd8e64287ffb', 'ibrahim.bensalah787', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(156, '2384ff164cc648455dabde97897adad5c5c28b4661f0acbac258b64a7c994afe', 'charlotte.taylor182', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(157, '0f6b5059b6878d48da6a1d5e44ccff1b47a5a00a9c53ac4e37694b019189d713', 'sofiane.boukari253', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(158, '718004902870b8a510b5f6a5697a573617f2cce4c203cfe736f100450181ba23', 'marie.faure034', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(159, '56ab67d326e75a9f21c09ddc464abcfc28948ac7d608cb128447158f91373461', 'leila.miled326', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(160, 'c5bf0cd5534237f21fdcdf617b6dc7fc36884a2e9583b70b89efe4b0a286ba4d', 'lamia.zouiten641', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(161, '45e1a3f4645d8991afb74263be8e490ffdb654c5c1f69dec75f55abcc6c6ff02', 'william.robinson246', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(162, '8786587d046c5344e778779eafcbc82735d4299c3b9bb3c4abe41800311e3f1a', 'leila.jaziri662', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(163, '40df0c4a6fdbca21112be6af13b235451efb537ed24a5057de1a2b5d91eb21d5', 'yacine.benkacem823', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(164, 'a6bf46e51f496ceb42424a512ad4b0b719d3c5e6f48ad6095a4178dcaa57aadb', 'ana.carvalho720', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(165, '8d46cc0b18dc9c324594d700942558d99b210631ada8f086ec061aab1528de1c', 'omar.alnaimi477', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(166, 'de7b10657a81fe2ac05024a0de2bac9df86b9759f7a3bf6761a1af7a94fe9f7b', 'amel.khelif957', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(167, '77e3b597e0cd63ba3c1b732c777489939916e80d388ed408d37523b816d8769e', 'khalid.alnaimi989', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(168, 'ebce257dd78e9d01c66d47324355b5c029f49f72b07a486e7c8c98e501dc88ac', 'rachid.ouarzazi967', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(169, '8f3c41eacd5f94b9d70053177a5b37771c34b6e580086dc09308f5514d9e14d2', 'marta.costa006', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(170, '674000bc5ab0541737d45df3cecec3520ce99c6bc7c4cede6e44dbc3527b8770', 'javier.martinez940', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(171, '75d9cc49872a35d2a864912600ef0e485f5c116909041a47a8d948b30ea5fcef', 'ana.moreno249', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(172, '473d65020847992cb907e5d4f7ffc01b2710bb1bc5a1be80b29808c5ff62c43f', 'olivia.robinson865', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(173, '008af777f3c857c4a619998bba0596db6dd3abf67f31dc54a6f16ff40e03674f', 'meriem.miled673', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(174, '028e53e12b9cfe753f89dfce9d36429c5626c138ffa0e88b82ca71aafbb31424', 'sarah.wilson693', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(175, '7f765a8011974160dc338b6e2b02625e09a0f999d4cfcc9a7050c2abab343b88', 'irene.garcia649', 'A', 'Membre', '93bd18390ac7877bcaabd7f4f71118735c76657acdc1921e2cf85637b232c62e'),
(176, '78b2251b6d5209361bb48a54b310ebbca359269317a603a7aa8ca40d31058bd0', 'lucas.moreau817', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(177, '4111f83b6c028e6fb222447b4ea439bf6ffc96a23110e77289046459b8f6914c', 'karim.jaziri779', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(178, 'dd695be0ac50ba1ad1876ca9cec9f55f9eee081275d33ac1276a5fc3ec60df64', 'yacine.nacer567', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(179, '7918a0ef75e3e5a23bcf45758f48ac7ff1a125637daa51ac1a8b5a0fc4cee0aa', 'sarah.taylor173', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(180, '988f09fea98a6d6ce566aa6d74d00a2defcc97f008de1e6e534bf08decbdfe45', 'ines.oliveira257', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(181, '746864729a5562b1775615881a589e726e5c81400da132b1019ece374406a465', 'irene.rodriguez342', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(182, '490db2abdfa14c8497b791b007333d0daa873263167775c4d7cd7a95e1bba7fd', 'sofia.santos333', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(183, '112704ca109f3af2d4938101ec4c01f347bfee8857d3935bb34f68bd90bce851', 'youssef.benkacem448', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(184, '2a04bc95a6dbb475cf7711d58d9ba42b24a43e9fde9eddbb123197ac1b6a0e42', 'camille.faure490', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(185, '02e99077233cad4e69d57e879f05c4f3e84b2f7b90309f7823460c4ab71ac801', 'emily.jones662', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(186, '74ace1ce8c0aa1bfb8b6e0eda2ff6f67c04030a3054486f711c48c1c78040b64', 'lamia.ouaziz226', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(187, '3af0398ae4585ca54ae60b3cfc7f18581107fa7cce2a07fa34ac0b37f9c68daf', 'marie.bernard356', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(188, 'e21b3386c82f5290e915bed5786a1a095fdb6132a0837028949bd03f219383c8', 'hamad.almohannadi045', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(189, 'bddbe180ce0512a8f987f3d35253273bbc1a1d6e118328a682eebbd4f69cdc4c', 'ana.sanchez816', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(190, '5489c162ef37d74f74cfd56a11c89ea2b004d51256601463684f2d6ade57bcc9', 'ashley.davis770', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(191, '393da7208e111329abc69ff35cf3281ddd53e379ba5a556e9c0b2e287b336c16', 'salma.ouaziz397', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(192, '1ffcda2be9d0ad0f6063e98bffeff8f75f707c01e2b54a5e2fdcedd445a994f9', 'luc.laurent120', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(193, '7dc384411000973cef64af730599e54f669a36baffb5a0d6124a3a369ed94272', 'javier.rodriguez650', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(194, '142a67e9fe98c85ef39bd74593c75b0d6e70129158b6e4d5bd96f5a931ac7272', 'youssef.boukhari199', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(195, '47161a9926b36c11ebe4593937d4061256c1a17057ddf413e53e6d675d69a148', 'matthew.johnson281', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(196, '04aec620e531f13e2b4f563342157d2cd5f9397e9665d0c902962384cc4c5e92', 'omar.althani778', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(197, 'a044a6296d84d6c35d1401655f4dc43c9e25bb9c7475400f9d64d434361e02b3', 'ines.santos214', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(198, 'f550bc849f4a249f234e222be254688aa74c86bed0fb1cdfee764c7362bf6bf5', 'nour.hassine172', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(199, '39ce3c5b5bccff2354fbdc08d671416fc6ae1e066255ae33988bd70af7646cd7', 'george.wilson149', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(200, 'ec4f7ff3cc88f92965a6efa2c71a549c99cc7155cb173b4642e31e578045ccc9', 'antoine.robin767', 'A', 'Membre', '74f9dc672d661af26439bc1a0f88ef28bdff6a472066fe752ce83c5ad171ba76'),
(201, 'e6c3da5b206634d7f3f3586d747ffdb36b5c675757b380c6a5fe5c570c714349', 'user1', 'A', 'Visiteur', 'aee15efced1956bda83f56da17c66d47462aed6cc54685843c7b3ffbc456b24a'),
(202, '1ba3d16e9881959f8c9a9762854f72c6e6321cdd44358a10a4e939033117eab9', 'user2', 'A', 'Visiteur', 'aee15efced1956bda83f56da17c66d47462aed6cc54685843c7b3ffbc456b24a'),
(203, '3acb59306ef6e660cf832d1d34c4fba3d88d616f0bb5c2a9e0f82d18ef6fc167', 'user3', 'A', 'Visiteur', 'aee15efced1956bda83f56da17c66d47462aed6cc54685843c7b3ffbc456b24a'),
(204, 'a417b5dc3d06d15d91c6687e27fc1705ebc56b3b2d813abe03066e5643fe4e74', 'user4', 'A', 'Visiteur', 'aee15efced1956bda83f56da17c66d47462aed6cc54685843c7b3ffbc456b24a'),
(205, '0eeac8171768d0cdef3a20fee6db4362d019c91e10662a6b55186336e1a42778', 'user5', 'A', 'Visiteur', 'aee15efced1956bda83f56da17c66d47462aed6cc54685843c7b3ffbc456b24a'),
(206, ' 147889652', 'invite', 'E', 'invite', 'sel'),
(207, 'motdepasse_hashe', 'pseudo_utilisateur', 'E', 'invite', 'sel'),
(209, ' 123456789', 'invite12', 'E', 'invite', 'sel'),
(210, ' 897564poiu', 'coucouana', 'E', 'invite', 'sel'),
(212, ' fsd67676khjghjGG', 'fdsfdsfsdf', 'E', 'invite', 'sel'),
(213, ' qW!IS22Z', 'e22509077sql', 'E', 'invite', 'sel'),
(214, ' qW!IS22Zgggg', 'gggg', 'E', 'invite', 'sel'),
(215, ' qW!IS22Z', 'fdgfdgfggggg', 'E', 'invite', 'sel'),
(217, ' qW!IS22Zbbgh', 'e22509077sqlgggg', 'E', 'invite', 'sel'),
(218, ' uadiiiiiiii', 'e22509077', 'E', 'invite', 'sel'),
(221, ' qW!IuuuuS22Z', 'e2250uuuuuu', 'E', 'invite', 'sel'),
(225, 'pppppppppp', 'e2rtgr2509077', 'E', 'invite', 'sel'),
(226, ' 12az!@AZfoggggggggggggggggggg', 'e2250uuuuuuuuuuuuuuuuu9077', 'E', 'invite', 'sel'),
(227, 'dd0ade97e766ddbc53cf76bd3c7621a2a3e016e0baa0d0bf62a56fe6679e2565', 'e225555555555555555555', 'E', 'invite', '366b5b15688d739164cfd3d28760289e');

--
-- Déclencheurs `t_compte_cpt`
--
DELIMITER $$
CREATE TRIGGER `before_delete_admin` BEFORE DELETE ON `t_compte_cpt` FOR EACH ROW BEGIN
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
        DELETE FROM t_Actualite_actu
        WHERE idt_compte_cpt = OLD.idt_compte_cpt;

        -- Réassigner ses messages à l’admin principal
        UPDATE t_Message_msg
        SET idt_compte_cpt = id_admin_principal
        WHERE idt_compte_cpt = OLD.idt_compte_cpt;

    DELETE FROM t_profile_pfl WHERE idt_compte_cpt = OLD.idt_compte_cpt;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_compte_cpt_has_t_Reservation_res`
--

CREATE TABLE `t_compte_cpt_has_t_Reservation_res` (
  `idt_compte_cpt` int(11) NOT NULL,
  `idt_Reservation_res` int(11) NOT NULL,
  `cpt_res_Role` char(1) NOT NULL,
  `cpt_res_Date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_compte_cpt_has_t_Reservation_res`
--

INSERT INTO `t_compte_cpt_has_t_Reservation_res` (`idt_compte_cpt`, `idt_Reservation_res`, `cpt_res_Role`, `cpt_res_Date`) VALUES
(1, 3, 'O', '0000-00-00'),
(2, 1, 'P', '0000-00-00'),
(2, 2, 'P', '0000-00-00'),
(2, 3, 'P', '0000-00-00'),
(4, 1, 'P', '0000-00-00'),
(21, 10, 'P', '0000-00-00'),
(29, 4, 'P', '0000-00-00'),
(34, 9, 'P', '0000-00-00'),
(35, 5, 'P', '0000-00-00'),
(39, 2, 'P', '0000-00-00'),
(46, 10, 'P', '0000-00-00'),
(48, 2, 'P', '0000-00-00'),
(52, 5, 'P', '0000-00-00'),
(74, 3, 'P', '0000-00-00'),
(75, 6, 'P', '0000-00-00'),
(90, 2, 'P', '0000-00-00'),
(93, 5, 'P', '0000-00-00'),
(97, 2, 'P', '0000-00-00'),
(101, 4, 'P', '0000-00-00'),
(104, 7, 'P', '0000-00-00'),
(108, 6, 'P', '0000-00-00'),
(113, 8, 'P', '0000-00-00'),
(118, 3, 'P', '0000-00-00'),
(122, 6, 'P', '0000-00-00'),
(128, 2, 'P', '0000-00-00'),
(165, 3, 'P', '0000-00-00'),
(172, 8, 'P', '0000-00-00'),
(182, 7, 'P', '0000-00-00'),
(184, 9, 'P', '0000-00-00'),
(191, 10, 'P', '0000-00-00'),
(193, 4, 'P', '0000-00-00');

-- --------------------------------------------------------

--
-- Structure de la table `t_Doc_Pdf`
--

CREATE TABLE `t_Doc_Pdf` (
  `idt_DocPDF` int(11) NOT NULL,
  `pdf_intitule` varchar(100) NOT NULL,
  `pdf_chemin` varchar(200) NOT NULL,
  `t_Reunion_reu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Doc_Pdf`
--

INSERT INTO `t_Doc_Pdf` (`idt_DocPDF`, `pdf_intitule`, `pdf_chemin`, `t_Reunion_reu`) VALUES
(1, 'Compte rendu réunion projet - CR mis en ligne le 24/10/2025', 'truc.pdf', 5),
(3, 'CR Journée portes ouvertes (79)', '/docs/portes_ouvertes.pdf', 3),
(5, 'CR Réunion des membres (1) - CR mis en ligne le 23/10/2025', '/docs/CR_Reunion_des_membres.pdf', 4),
(6, 'Compte rendu réunion projet', 'CR en attente', 3);

--
-- Déclencheurs `t_Doc_Pdf`
--
DELIMITER $$
CREATE TRIGGER `trg_before_update_doc_pdf` BEFORE UPDATE ON `t_Doc_Pdf` FOR EACH ROW BEGIN
      IF OLD.pdf_chemin LIKE 'CR en attente'
    AND NEW.pdf_chemin LIKE '%.pdf' THEN

        SET NEW.pdf_intitule = CONCAT(
            NEW.pdf_intitule,
            ' - CR mis en ligne le ',
            DATE_FORMAT(CURDATE(), '%d/%m/%Y')
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_Indisponibilite_dsp`
--

CREATE TABLE `t_Indisponibilite_dsp` (
  `idt_Indisponibilite_dsp` int(11) NOT NULL,
  `dsp_commentaire` varchar(200) DEFAULT NULL,
  `dsp_date_deb` datetime NOT NULL,
  `dsp_date_fin` datetime NOT NULL,
  `idt_Motif_mtf` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Indisponibilite_dsp`
--

INSERT INTO `t_Indisponibilite_dsp` (`idt_Indisponibilite_dsp`, `dsp_commentaire`, `dsp_date_deb`, `dsp_date_fin`, `idt_Motif_mtf`) VALUES
(1, 'Evenement', '2025-11-01 08:00:00', '2025-11-01 12:00:00', 1),
(2, 'Nettoyage', '2025-11-02 08:00:00', '2025-11-02 12:00:00', 2);

-- --------------------------------------------------------

--
-- Structure de la table `t_Message_msg`
--

CREATE TABLE `t_Message_msg` (
  `idt_Message_msg` int(11) NOT NULL,
  `msg_email` varchar(45) NOT NULL,
  `msg_sujet` varchar(100) NOT NULL,
  `msg_contenue` varchar(200) NOT NULL,
  `msg_date_envoie` datetime NOT NULL,
  `msg_code` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `idt_compte_cpt` int(11) DEFAULT NULL,
  `msg_repense` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Message_msg`
--

INSERT INTO `t_Message_msg` (`idt_Message_msg`, `msg_email`, `msg_sujet`, `msg_contenue`, `msg_date_envoie`, `msg_code`, `idt_compte_cpt`, `msg_repense`) VALUES
(1, 'paul.moreau65@example.com', 'Demande de participation à l\'événement - Groupe 1', 'Bonjour, est ce que je peux participer a l\'evenment celle du 15/11 ', '2025-11-10 10:00:00', '50615668A00715E7D372', 1, 'Bonjour , oui effectivement ....'),
(2, 'samir.benkacem28@example.com', 'Renseignement demandé sur l\'événement ', 'Bonjour, quels sont les critères pour participer à l\'événement ?', '2025-10-06 13:00:00', 'D35F782B60BFF900A75D', 2, 'Bonjour, Mr il est essentiel de faire une demande pour l\'inscription'),
(3, 'hamad.alsuwaidi71@example.com', 'Question concernant l\'inscription à l\'événement - Groupe 2', 'Bonjour, comment puis-je m\'inscrire à l\'événement ?', '2025-10-06 13:00:00', '4C88B95E0281A4D702F8', 3, NULL),
(4, 'nour.jaziri82@example.com', 'Demande de participation à l\'événement - Groupe 1', 'Bonjour, comment puis-je m\'inscrire à l\'événement ?', '2025-10-06 13:00:00', 'DEA29970C996D7E85C18', 4, NULL),
(5, 'nasser.alobaidli82@example.com', 'Demande de participation à l\'événement - Groupe 1', 'Bonjour, comment puis-je m\'inscrire à l\'événement ?', '2025-10-06 13:00:00', 'D68D3F043999D7795707', 1, NULL),
(6, 'hassan.moulay84@example.com', 'Question concernant l\'inscription à l\'événement - Groupe 2', 'Bonjour, est-ce que je peux participer à l\'événement ?', '2025-11-02 10:30:00', '29E5A64BB8AA7DD04D09', 6, NULL),
(7, 'tiago.medeiros18@example.com', 'Question concernant l\'inscription à l\'événement - Groupe 2', 'Bonjour, est-ce que je peux participer à l\'événement ?', '2025-11-02 10:30:00', 'C8B2D0D4F7F61BE47657', 7, NULL),
(8, 'imane.ouarzazi33@example.com', 'Question concernant l\'inscription à l\'événement - Groupe 2', 'Bonjour, est-ce que je peux participer à l\'événement ?', '2025-11-02 10:30:00', '7D750F42208D30F0A893', 8, NULL),
(9, 'rachid.ouarzazi65@example.com', 'Question concernant l\'inscription à l\'événement - Groupe 2', 'Bonjour, est-ce que je peux participer à l\'événement ?', '2025-11-02 10:30:00', 'B4BE82E00D864ED27B6E', 9, NULL),
(10, 'william.taylor63@example.com', 'Question concernant l\'inscription à l\'événement - Groupe 2', 'Bonjour, est-ce que je peux participer à l\'événement ?', '2025-11-02 10:30:00', '6DF0A81951219118A386', 10, NULL),
(11, 'yacine.nacer17@example.com', 'Renseignement demandé sur l\'événement - Groupe 3', 'Bonjour, j\'ai une question concernant l\'inscription. Pouvez-vous m\'aider ?', '2025-11-10 11:00:00', '953A020EA7849A554FF1', 11, NULL),
(12, 'alice.walker57@example.com', 'Renseignement demandé sur l\'événement - Groupe 3', 'Bonjour, j\'ai une question concernant l\'inscription. Pouvez-vous m\'aider ?', '2025-11-10 11:00:00', '2D5E39574600E9F9791E', 12, NULL),
(13, 'imane.ouarzazi81@example.com', 'Renseignement demandé sur l\'événement - Groupe 3', 'Bonjour, j\'ai une question concernant l\'inscription. Pouvez-vous m\'aider ?', '2025-11-10 11:00:00', 'D9B20ACCFC0A6A38DDC1', 13, NULL),
(14, 'nora.cherif74@example.com', 'Renseignement demandé sur l\'événement - Groupe 3', 'Bonjour, j\'ai une question concernant l\'inscription. Pouvez-vous m\'aider ?', '2025-11-10 11:00:00', '5C35EDBB5F0467A82029', 14, NULL),
(15, 'ana.medeiros84@example.com', 'Renseignement demandé sur l\'événement - Groupe 3', 'Bonjour, j\'ai une question concernant l\'inscription. Pouvez-vous m\'aider ?', '2025-11-10 11:00:00', '7DE789F3C6A48D146C08', 15, NULL),
(16, 'paul.lefevre32@example.com', 'Demande d\'informations supplémentaires sur l\'événement - Groupe 4', 'Bonjour, je voudrais en savoir plus sur l\'événement. Pouvez-vous me donner des informations ?', '2025-12-01 11:30:10', '04DBBEB9B740848533EA', 16, NULL),
(17, 'camille.robin22@example.com', 'Demande d\'informations supplémentaires sur l\'événement - Groupe 4', 'Bonjour, je voudrais en savoir plus sur l\'événement. Pouvez-vous me donner des informations ?', '2025-12-01 11:30:10', '11F42905BF95C80EEF97', 17, NULL),
(18, 'carlos.perez70@example.com', 'Demande d\'informations supplémentaires sur l\'événement - Groupe 4', 'Bonjour, je voudrais en savoir plus sur l\'événement. Pouvez-vous me donner des informations ?', '2025-12-01 11:30:10', '4CC3BCAB179B2CCF683B', 18, NULL),
(19, 'sonia.benali87@example.com', 'Demande d\'informations supplémentaires sur l\'événement - Groupe 4', 'Bonjour, je voudrais en savoir plus sur l\'événement. Pouvez-vous me donner des informations ?', '2025-12-01 11:30:10', '4C92591B2D917845931E', 19, NULL),
(20, 'joshua.williams27@example.com', 'Demande d\'informations supplémentaires sur l\'événement - Groupe 4', 'Bonjour, je voudrais en savoir plus sur l\'événement. Pouvez-vous me donner des informations ?', '2025-12-01 11:30:10', '061E34EB995BC5327A56', 20, NULL),
(21, 'lina.almohannadi69@example.com', 'Demande de confirmation d\'inscription - Groupe 5', 'Bonjour, quels sont les critères pour participer à l\'événement ?', '2025-12-10 12:45:19', 'AA8610E113FE2928E1E9', 21, NULL),
(22, 'andrew.davis86@example.com', 'Demande de confirmation d\'inscription - Groupe 5', 'Bonjour, quels sont les critères pour participer à l\'événement ?', '2025-12-10 12:45:19', '8342C00C90C33B9A5505', 22, NULL),
(23, 'nora.ouarzazi27@example.com', 'Demande de confirmation d\'inscription - Groupe 5', 'Bonjour, quels sont les critères pour participer à l\'événement ?', '2025-12-10 12:45:19', 'DD59372B48D5B56412C8', 23, NULL),
(24, 'meriem.fakhfakh95@example.com', 'Demande de confirmation d\'inscription - Groupe 5', 'Bonjour, quels sont les critères pour participer à l\'événement ?', '2025-12-10 12:45:19', 'FF4F62731B0836065A1D', 24, NULL),
(25, 'carlos.rocha6@example.com', 'Demande de confirmation d\'inscription - Groupe 5', 'Bonjour, quels sont les critères pour participer à l\'événement ?', '2025-12-10 12:45:19', '8BCC346168D4A9856CC5', 25, NULL),
(26, 'safa.karim21@example.com', 'Demande de modification d\'inscription - Groupe 6', '', '0000-00-00 00:00:00', '4968E6A4C799457ACCEB', 26, NULL),
(27, 'thomas.smith59@example.com', 'Demande de modification d\'inscription - Groupe 6', '', '0000-00-00 00:00:00', '81F4EED2D314E194A076', 27, NULL),
(28, 'khalid.aldosari87@example.com', 'Demande de modification d\'inscription - Groupe 6', '', '0000-00-00 00:00:00', 'D2A3C8E8A6D255A02171', 28, NULL),
(29, 'salma.elamrani78@example.com', 'Demande de modification d\'inscription - Groupe 6', '', '0000-00-00 00:00:00', '2900F7FBA519AB5ADDBF', 29, NULL),
(30, 'youssef.ait86@example.com', 'Demande de modification d\'inscription - Groupe 6', '', '0000-00-00 00:00:00', 'E4BA340F3A5CAE56A6AE', 30, NULL),
(31, 'reem.alobaidli54@example.com', '', '', '0000-00-00 00:00:00', '329F6CB79B0AA073D208', 31, NULL),
(32, 'javier.moreno60@example.com', '', '', '0000-00-00 00:00:00', '909917EA2516A36FD702', 32, NULL),
(33, 'marta.santos26@example.com', '', '', '0000-00-00 00:00:00', '9AC06C0AA118572292D6', 33, NULL),
(34, 'james.smith84@example.com', '', '', '0000-00-00 00:00:00', 'B3723B4773179B948CFD', 34, NULL),
(35, 'yacine.benaid72@example.com', '', '', '0000-00-00 00:00:00', '8742568216155FBD4684', 35, NULL),
(36, 'rana.alsaid82@example.com', '', '', '0000-00-00 00:00:00', 'AB916ABD54983CEE1356', 36, NULL),
(37, 'meriem.fakhfakh18@example.com', '', '', '0000-00-00 00:00:00', '7BB9C9925DECBC93BE9F', 37, NULL),
(38, 'emma.thomas54@example.com', '', '', '0000-00-00 00:00:00', '951F591C193EB4546435', 38, NULL),
(39, 'sofia.garcia78@example.com', '', '', '0000-00-00 00:00:00', '8E1146CFB4D0F69E9FF3', 39, NULL),
(40, 'amanda.brown76@example.com', '', '', '0000-00-00 00:00:00', 'BDFCC3394DD8FE3FB72E', 40, NULL),
(41, 'yacine.benaid97@example.com', '', '', '0000-00-00 00:00:00', '6A4C38833737D00B1CAA', 41, NULL),
(42, 'alvaro.martinez20@example.com', '', '', '0000-00-00 00:00:00', '285AA805073110C7E252', 42, NULL),
(43, 'daniel.moore14@example.com', '', '', '0000-00-00 00:00:00', '3671325B5A55EC4B84F0', 43, NULL),
(44, 'amel.zitoun6@example.com', '', '', '0000-00-00 00:00:00', '671174488E6A4FE1659E', 44, NULL),
(45, 'omar.alkaabi59@example.com', '', '', '0000-00-00 00:00:00', 'F2B3811870DBEDB1982B', 45, NULL),
(46, 'thomas.brown12@example.com', '', '', '0000-00-00 00:00:00', '365AB3F20DACF228BF26', 46, NULL),
(47, 'karim.trabelsi46@example.com', '', '', '0000-00-00 00:00:00', 'ABB01F0FFC35F71C81F7', 47, NULL),
(48, 'safa.mansour72@example.com', '', '', '0000-00-00 00:00:00', '6BE5358C293B050F4142', 48, NULL),
(49, 'amanda.moore55@example.com', '', '', '0000-00-00 00:00:00', 'AC605A3E9F617B86C6EF', 49, NULL),
(50, 'salma.moulay89@example.com', '', '', '0000-00-00 00:00:00', 'E09868A1A21C30365A48', 50, NULL),
(51, 'emma.wilson39@example.com', '', '', '0000-00-00 00:00:00', '9E096F859D1FE53A7DA8', 51, NULL),
(52, 'samir.boukhari57@example.com', '', '', '0000-00-00 00:00:00', '9E0B09681BD202761011', 52, NULL),
(53, 'nasser.althani73@example.com', '', '', '0000-00-00 00:00:00', '9C5E51A3E5DFAC81119B', 53, NULL),
(54, 'amina.trabelsi76@example.com', '', '', '0000-00-00 00:00:00', '48F9CD042A41D3B03575', 54, NULL),
(55, 'alvaro.moreno21@example.com', '', '', '0000-00-00 00:00:00', 'D32A38391D7F2B2A2782', 55, NULL),
(56, 'sofiane.messaoud81@example.com', '', '', '0000-00-00 00:00:00', 'A10C611CC13731FDA1F3', 56, NULL),
(57, 'joshua.williams60@example.com', '', '', '0000-00-00 00:00:00', 'E072C27E0C88BE8CE539', 57, NULL),
(58, 'ibrahim.mansour12@example.com', '', '', '0000-00-00 00:00:00', '237E4D90AB9D4FECC88B', 58, NULL),
(59, 'sarah.anderson63@example.com', '', '', '0000-00-00 00:00:00', 'D4E9287477AA8F945470', 59, NULL),
(60, 'camille.laurent59@example.com', '', '', '0000-00-00 00:00:00', 'C23983FA71D550744C70', 60, NULL),
(61, 'claire.moreau97@example.com', '', '', '0000-00-00 00:00:00', '12D7BB57442F68690D7D', 61, NULL),
(62, 'marta.costa40@example.com', '', '', '0000-00-00 00:00:00', '3DF4964CE0603233250C', 62, NULL),
(63, 'rachid.elidrissi62@example.com', '', '', '0000-00-00 00:00:00', 'DE3FD52DAB09313CE910', 63, NULL),
(64, 'ana.medeiros1@example.com', '', '', '0000-00-00 00:00:00', '935574D930C9791086FE', 64, NULL),
(65, 'mouna.miled59@example.com', '', '', '0000-00-00 00:00:00', '743DFFD3CB9DB12B0340', 65, NULL),
(66, 'lina.aldosari64@example.com', '', '', '0000-00-00 00:00:00', '6F221EB072336EF48597', 66, NULL),
(67, 'karim.khelif10@example.com', '', '', '0000-00-00 00:00:00', '621500E93FC094256EF1', 67, NULL),
(68, 'miguel.oliveira81@example.com', '', '', '0000-00-00 00:00:00', 'B5EC921B2AB9F118C96C', 68, NULL),
(69, 'leila.khalifa48@example.com', '', '', '0000-00-00 00:00:00', '4A8BD6E6B157283A7A86', 69, NULL),
(70, 'javier.sanchez75@example.com', '', '', '0000-00-00 00:00:00', '22582D167303202BF81B', 70, NULL),
(71, 'emma.robinson39@example.com', '', '', '0000-00-00 00:00:00', '68CA16F62E11EEED96B9', 71, NULL),
(72, 'alvaro.rodriguez38@example.com', '', '', '0000-00-00 00:00:00', 'EAA6A5538A004B7A6573', 72, NULL),
(73, 'sofiane.bensaid33@example.com', '', '', '0000-00-00 00:00:00', 'CB069EDE355605FE5B4C', 73, NULL),
(74, 'olivia.smith70@example.com', '', '', '0000-00-00 00:00:00', 'C96DFC0281255DF21925', 74, NULL),
(75, 'omar.alhajri29@example.com', '', '', '0000-00-00 00:00:00', '1C7B89B571D5F74C029D', 75, NULL),
(76, 'pablo.fernandez14@example.com', '', '', '0000-00-00 00:00:00', '68591D15479CA5A7550C', 76, NULL),
(77, 'amanda.johnson64@example.com', '', '', '0000-00-00 00:00:00', 'EAD565C073B92FBEC0BB', 77, NULL),
(78, 'marie.dubois63@example.com', '', '', '0000-00-00 00:00:00', 'D1E54C539E784EA57BBE', 78, NULL),
(79, 'alvaro.garcia51@example.com', '', '', '0000-00-00 00:00:00', '8455FEC98ED90127421E', 79, NULL),
(80, 'leila.khalifa9@example.com', '', '', '0000-00-00 00:00:00', 'C6F354D768C826F0A1F3', 80, NULL),
(96, 'miloo@gmail.com', 'd', 'f', '2025-11-18 11:23:38', 'ADE3B8DD6FB91815D945', NULL, NULL),
(97, 'toto@tutu.fr', 'adhesion', 'prix!', '2025-11-18 11:34:15', '5D843B27E83855A9CF4B', NULL, NULL),
(98, 'toto@tutu.fr', 'momo', 'yoyo\r\n', '2025-11-20 14:01:29', '59E95E06A7E796B9769A', NULL, NULL),
(99, 'toto@tutu.fr', 'gg', 'gg', '2025-11-20 14:02:48', '7CD7B5207C383E8AB7A5', NULL, NULL),
(100, 'totouu@tutu.fr', 'uuuuu', 'uuuu', '2025-11-20 15:17:20', '8447C26DED7B3685DF10', NULL, NULL),
(101, 'totouu@tutu.fr', 'iiii', 'iiiiii', '2025-11-20 15:17:44', '554C4F11DC4A1BCD62B5', NULL, NULL),
(102, 'totouu@tutu.fr', 'zzzz', 'zzzzzz', '2025-11-20 15:18:27', 'FD8549D946BE7D6BDCA0', NULL, NULL),
(103, 'toto@tutu.fr', 'f\'ddd', 'fffff', '2025-11-20 15:19:14', '0DB0DAE799AF06C41643', NULL, NULL),
(104, 'fouadbkh77@gmail.com', 'jj', 'jj', '2025-11-21 00:48:52', '4CA2A25FF9CD8D85EB90', NULL, NULL),
(105, 'fouadbkh77@gmail.com', 'lala', 'tt', '2025-11-21 00:49:48', 'ABCE0C6F318E46110B21', NULL, NULL),
(106, 'gdhhcvjuhd@mauil.com', 'hhhhh\'hhh', 'gggg', '2025-11-21 13:03:58', 'B76B3AAB0830F6402E58', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `t_Motif_mtf`
--

CREATE TABLE `t_Motif_mtf` (
  `idt_Motif_mtf` int(11) NOT NULL,
  `mtf_type` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Motif_mtf`
--

INSERT INTO `t_Motif_mtf` (`idt_Motif_mtf`, `mtf_type`) VALUES
(1, 'Conge'),
(2, 'Maintenance'),
(3, 'Prive');

-- --------------------------------------------------------

--
-- Structure de la table `t_Participe`
--

CREATE TABLE `t_Participe` (
  `idt_compte_cpt` int(11) NOT NULL,
  `idt_Reunion_reu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Participe`
--

INSERT INTO `t_Participe` (`idt_compte_cpt`, `idt_Reunion_reu`) VALUES
(1, 4),
(7, 3),
(9, 3),
(10, 3),
(11, 3),
(12, 3),
(13, 3),
(14, 3),
(15, 3),
(20, 3),
(22, 3),
(24, 3),
(26, 3),
(28, 3),
(32, 3),
(34, 3),
(36, 3),
(38, 3),
(39, 3),
(42, 3),
(44, 3),
(45, 3),
(51, 3),
(52, 3),
(53, 3),
(54, 3),
(57, 3),
(58, 3),
(59, 3),
(65, 3),
(66, 3),
(67, 3),
(69, 3),
(71, 3),
(74, 3),
(76, 3),
(77, 3),
(78, 3),
(79, 3),
(81, 3),
(82, 3),
(83, 3),
(88, 3),
(89, 3),
(92, 3),
(93, 3),
(94, 3),
(96, 3),
(97, 3),
(102, 3),
(104, 3),
(105, 3),
(106, 3),
(107, 3),
(108, 3),
(112, 3),
(117, 3),
(122, 3),
(126, 3),
(129, 3),
(131, 3),
(134, 3),
(138, 3),
(147, 3),
(150, 3),
(151, 3),
(159, 3),
(160, 3),
(161, 3),
(165, 3),
(166, 3),
(170, 3),
(175, 3),
(176, 3),
(180, 3),
(182, 3),
(183, 3),
(186, 3),
(195, 3),
(200, 3);

--
-- Déclencheurs `t_Participe`
--
DELIMITER $$
CREATE TRIGGER `after_insert_participe` AFTER INSERT ON `t_Participe` FOR EACH ROW BEGIN
    CALL CR_reu_pdf(NEW.idt_Reunion_reu);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_profile_pfl`
--

CREATE TABLE `t_profile_pfl` (
  `pfl_Nom` varchar(70) NOT NULL,
  `pfl_prenom` varchar(70) NOT NULL,
  `pfl_numTel` char(14) NOT NULL,
  `pfl_date_ncs` varchar(45) NOT NULL,
  `pfl_email` varchar(200) NOT NULL,
  `idt_compte_cpt` int(11) NOT NULL,
  `idt_codepostale_vil` int(11) DEFAULT NULL,
  `pfl_adresse` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_profile_pfl`
--

INSERT INTO `t_profile_pfl` (`pfl_Nom`, `pfl_prenom`, `pfl_numTel`, `pfl_date_ncs`, `pfl_email`, `idt_compte_cpt`, `idt_codepostale_vil`, `pfl_adresse`) VALUES
('Admin', 'Principal', '+33321819600', '1960-04-08', 'paul.moreau65@example.com', 1, 29200, '18 Rue du Marché'),
('Benkacem', 'Samir', '+213863794026', '1976-05-05', 'samir.benkacem28@example.com', 2, 29200, '127 Avenue de la Liberté'),
('AlSuwaidi', 'Hamad', '+97415594078', '1962-07-03', 'hamad.alsuwaidi71@example.com', 3, 29200, '44 Rue du Moulin'),
('Jaziri', 'Nour', '+21631034131', '1979-05-15', 'nour.jaziri82@example.com', 4, 29200, '94 Rue Victor Hugo'),
('Nom', 'Prenom', '0612345678', '1990-05-15', 'nom.prenom568@jardinsolidaires.fr', 5, 29200, '12 rue des Jardins, Paris'),
('Moulay', 'Hassan', '+212030564139', '2000-06-07', 'hassan.moulay84@example.com', 6, 29200, '93 Rue Pasteur'),
('Medeiros', 'Tiago', '+351423884969', '1980-06-08', 'tiago.medeiros18@example.com', 7, 29200, '183 Avenue des Champs-Élysées'),
('Ouarzazi', 'Imane', '+212012269166', '1993-08-17', 'imane.ouarzazi33@example.com', 8, 29200, '32 Rue Victor Hugo'),
('Ouarzazi', 'Rachid', '+212845146270', '2001-12-09', 'rachid.ouarzazi65@example.com', 9, 29200, '159 Boulevard Voltaire'),
('Taylor', 'William', '+44489325288', '1955-10-11', 'william.taylor63@example.com', 10, 29200, '122 Rue Pasteur'),
('Nacer', 'Yacine', '+213430391171', '2003-09-25', 'yacine.nacer17@example.com', 11, 29200, '88 Avenue de la Liberté'),
('Walker', 'Alice', '+44489638346', '1997-11-12', 'alice.walker57@example.com', 12, 29200, '166 Rue du Moulin'),
('Ouarzazi', 'Imane', '+212315098393', '1955-02-23', 'imane.ouarzazi81@example.com', 13, 29200, '152 Rue du Moulin'),
('Cherif', 'Nora', '+213051834738', '1963-12-19', 'nora.cherif74@example.com', 14, 29200, '195 Avenue des Champs-Élysées'),
('Medeiros', 'Ana', '+351631165667', '2001-01-22', 'ana.medeiros84@example.com', 15, 29200, '131 Boulevard Voltaire'),
('Lefevre', 'Paul', '+33513338726', '1966-05-15', 'paul.lefevre32@example.com', 16, 29200, '137 Avenue de la Liberté'),
('Robin', 'Camille', '+33080132677', '1968-07-02', 'camille.robin22@example.com', 17, 29200, '12 Rue Pasteur'),
('Perez', 'Carlos', '+34746872343', '1958-10-24', 'carlos.perez70@example.com', 18, 29200, '192 Rue du Marché'),
('Benali', 'Sonia', '+213978820812', '1959-10-03', 'sonia.benali87@example.com', 19, 29200, '132 Avenue des Champs-Élysées'),
('Williams', 'Joshua', '+19399091699', '1988-06-09', 'joshua.williams27@example.com', 20, 29200, '178 Boulevard Voltaire'),
('AlMohannadi', 'Lina', '+97424751079', '1991-02-03', 'lina.almohannadi69@example.com', 21, 29200, '194 Rue Pasteur'),
('Davis', 'Andrew', '+15135427849', '1996-09-01', 'andrew.davis86@example.com', 22, 29200, '77 Rue du Marché'),
('Ouarzazi', 'Nora', '+212241182449', '1968-12-11', 'nora.ouarzazi27@example.com', 23, 29200, '117 Rue Victor Hugo'),
('Fakhfakh', 'Meriem', '+21601640052', '1995-05-06', 'meriem.fakhfakh95@example.com', 24, 29200, '124 Rue de la Gare'),
('Rocha', 'Carlos', '+351011280598', '1964-07-05', 'carlos.rocha6@example.com', 25, 29200, '92 Boulevard Voltaire'),
('Karim', 'Safa', '+21653315869', '2002-03-08', 'safa.karim21@example.com', 26, 29200, '35 Boulevard Voltaire'),
('Smith', 'Thomas', '+44563421607', '1969-04-27', 'thomas.smith59@example.com', 27, 29200, '23 Rue des Lilas'),
('AlDosari', 'Khalid', '+97403654145', '1996-09-13', 'khalid.aldosari87@example.com', 28, 29200, '121 Rue de la Gare'),
('ElAmrani', 'Salma', '+212429401965', '2001-06-14', 'salma.elamrani78@example.com', 29, 29200, '78 Rue du Moulin'),
('Ait', 'Youssef', '+212934060883', '1978-07-03', 'youssef.ait86@example.com', 30, 29200, '199 Rue Pasteur'),
('AlObaidli', 'Reem', '+97414846564', '1990-03-07', 'reem.alobaidli54@example.com', 31, 29200, '74 Rue de la Gare'),
('Moreno', 'Javier', '+34468044369', '1993-11-11', 'javier.moreno60@example.com', 32, 29200, '1 Avenue des Champs-Élysées'),
('Santos', 'Marta', '+351721489513', '1998-05-08', 'marta.santos26@example.com', 33, 29200, '155 Avenue de la Liberté'),
('Smith', 'James', '+44791769367', '1980-04-05', 'james.smith84@example.com', 34, 29200, '138 Rue de la Gare'),
('Benaid', 'Yacine', '+213287083172', '1984-11-17', 'yacine.benaid72@example.com', 35, 29200, '23 Rue Victor Hugo'),
('AlSaid', 'Rana', '+97486872774', '2003-04-27', 'rana.alsaid82@example.com', 36, 29200, '194 Rue Pasteur'),
('Fakhfakh', 'Meriem', '+21634714345', '1975-09-03', 'meriem.fakhfakh18@example.com', 37, 29200, '81 Rue Victor Hugo'),
('Thomas', 'Emma', '+44231665876', '1958-04-27', 'emma.thomas54@example.com', 38, 29200, '182 Rue du Moulin'),
('Garcia', 'Sofia', '+34967054668', '2002-12-18', 'sofia.garcia78@example.com', 39, 29200, '124 Rue Pasteur'),
('Brown', 'Amanda', '+16706562729', '1989-01-13', 'amanda.brown76@example.com', 40, 29200, '106 Rue Pasteur'),
('Benaid', 'Yacine', '+213720465375', '1976-07-09', 'yacine.benaid97@example.com', 41, 29200, '92 Rue du Moulin'),
('Martinez', 'Alvaro', '+34080531003', '1967-01-20', 'alvaro.martinez20@example.com', 42, 29200, '196 Rue du Moulin'),
('Moore', 'Daniel', '+11937452991', '2004-03-10', 'daniel.moore14@example.com', 43, 29200, '93 Rue de la Gare'),
('Zitoun', 'Amel', '+213663193149', '1962-10-26', 'amel.zitoun6@example.com', 44, 29200, '199 Rue des Lilas'),
('AlKaabi', 'Omar', '+97451850671', '1982-06-21', 'omar.alkaabi59@example.com', 45, 29200, '142 Avenue des Champs-Élysées'),
('Brown', 'Thomas', '+44849877694', '1975-04-27', 'thomas.brown12@example.com', 46, 29200, '92 Boulevard Voltaire'),
('Trabelsi', 'Karim', '+21679965075', '1966-08-07', 'karim.trabelsi46@example.com', 47, 29200, '69 Rue du Moulin'),
('Mansour', 'Safa', '+21694808313', '2001-07-16', 'safa.mansour72@example.com', 48, 29200, '73 Rue des Lilas'),
('Moore', 'Amanda', '+10143634957', '1990-09-12', 'amanda.moore55@example.com', 49, 29200, '156 Boulevard Voltaire'),
('Moulay', 'Salma', '+212744431351', '2002-09-25', 'salma.moulay89@example.com', 50, 29200, '99 Rue de la République'),
('Wilson', 'Emma', '+44749894134', '1969-06-06', 'emma.wilson39@example.com', 51, 29490, '75 Rue des Lilas'),
('Boukhari', 'Samir', '+213008427109', '1973-08-16', 'samir.boukhari57@example.com', 52, 29490, '121 Rue du Marché'),
('AlThani', 'Nasser', '+97471167190', '1964-03-26', 'nasser.althani73@example.com', 53, 29490, '29 Boulevard Voltaire'),
('Trabelsi', 'Amina', '+21686999386', '1983-08-10', 'amina.trabelsi76@example.com', 54, 29490, '53 Rue Victor Hugo'),
('Moreno', 'Alvaro', '+34091334123', '1966-09-03', 'alvaro.moreno21@example.com', 55, 29490, '139 Rue de la République'),
('Messaoud', 'Sofiane', '+213974034471', '1998-04-09', 'sofiane.messaoud81@example.com', 56, 29490, '165 Avenue des Champs-Élysées'),
('Williams', 'Joshua', '+13242102499', '1973-08-04', 'joshua.williams60@example.com', 57, 29490, '82 Rue des Lilas'),
('Mansour', 'Ibrahim', '+21687719065', '1993-05-01', 'ibrahim.mansour12@example.com', 58, 29490, '61 Rue Pasteur'),
('Anderson', 'Sarah', '+10490278742', '1992-07-21', 'sarah.anderson63@example.com', 59, 29490, '24 Boulevard Voltaire'),
('Laurent', 'Camille', '+33551256746', '2003-09-02', 'camille.laurent59@example.com', 60, 29490, '97 Rue de la République'),
('Moreau', 'Claire', '+33168087603', '1988-06-20', 'claire.moreau97@example.com', 61, 29490, '25 Avenue de la Liberté'),
('Costa', 'Marta', '+351482477109', '1970-12-06', 'marta.costa40@example.com', 62, 29490, '189 Rue du Marché'),
('ElIdrissi', 'Rachid', '+212131712748', '2000-05-14', 'rachid.elidrissi62@example.com', 63, 29490, '174 Avenue des Champs-Élysées'),
('Medeiros', 'Ana', '+351263982146', '1976-09-09', 'ana.medeiros1@example.com', 64, 29490, '189 Rue de la République'),
('Miled', 'Mouna', '+21672787558', '2003-09-13', 'mouna.miled59@example.com', 65, 29490, '31 Rue de la République'),
('AlDosari', 'Lina', '+97463605766', '1997-11-05', 'lina.aldosari64@example.com', 66, 29490, '71 Avenue de la Liberté'),
('Khelif', 'Karim', '+213951718702', '1981-11-05', 'karim.khelif10@example.com', 67, 29490, '72 Rue du Marché'),
('Oliveira', 'Miguel', '+351615865780', '1994-02-08', 'miguel.oliveira81@example.com', 68, 29490, '114 Rue Victor Hugo'),
('Khalifa', 'Leila', '+21611724005', '1958-05-12', 'leila.khalifa48@example.com', 69, 29490, '123 Rue de la Gare'),
('Sanchez', 'Javier', '+34692221969', '1998-04-16', 'javier.sanchez75@example.com', 70, 29490, '103 Rue du Marché'),
('Robinson', 'Emma', '+44474074821', '1983-06-19', 'emma.robinson39@example.com', 71, 29490, '44 Avenue de la Liberté'),
('Rodriguez', 'Alvaro', '+34436713695', '1991-05-23', 'alvaro.rodriguez38@example.com', 72, 29490, '98 Boulevard Voltaire'),
('Bensaid', 'Sofiane', '+213909743953', '1995-04-20', 'sofiane.bensaid33@example.com', 73, 29490, '66 Rue des Lilas'),
('Smith', 'Olivia', '+44709521456', '1966-04-05', 'olivia.smith70@example.com', 74, 29490, '161 Rue du Marché'),
('AlHajri', 'Omar', '+97442474517', '1959-03-25', 'omar.alhajri29@example.com', 75, 29490, '62 Boulevard Voltaire'),
('Fernandez', 'Pablo', '+34604817549', '1979-11-12', 'pablo.fernandez14@example.com', 76, 29490, '119 Rue de la Gare'),
('Johnson', 'Amanda', '+18593174612', '1957-01-10', 'amanda.johnson64@example.com', 77, 29490, '104 Rue Victor Hugo'),
('Dubois', 'Marie', '+33826758692', '1981-11-04', 'marie.dubois63@example.com', 78, 29490, '95 Rue des Lilas'),
('Garcia', 'Alvaro', '+34537735158', '1996-06-02', 'alvaro.garcia51@example.com', 79, 29490, '67 Rue Pasteur'),
('Khalifa', 'Leila', '+21671390053', '1963-10-07', 'leila.khalifa9@example.com', 80, 29490, '21 Rue Pasteur'),
('Ouaziz', 'Hassan', '+212352904228', '1971-03-04', 'hassan.ouaziz85@example.com', 81, 29850, '192 Rue de la Gare'),
('Benali', 'Karim', '+213395024026', '1988-02-24', 'karim.benali9@example.com', 82, 29850, '54 Rue de la Gare'),
('Oliveira', 'Marta', '+351917839084', '1984-11-01', 'marta.oliveira8@example.com', 83, 29850, '91 Boulevard Voltaire'),
('Rocha', 'Tiago', '+351177115921', '1963-05-20', 'tiago.rocha82@example.com', 84, 29850, '30 Rue Pasteur'),
('Ait', 'Salma', '+212847896118', '2001-04-14', 'salma.ait58@example.com', 85, 29850, '160 Rue Victor Hugo'),
('Miller', 'Joshua', '+17661565452', '1998-08-03', 'joshua.miller12@example.com', 86, 29850, '156 Boulevard Voltaire'),
('Lefevre', 'Marie', '+33528098851', '1981-06-28', 'marie.lefevre86@example.com', 87, 29850, '114 Avenue des Champs-Élysées'),
('Gonzalez', 'Carlos', '+34451983273', '1961-06-28', 'carlos.gonzalez72@example.com', 88, 29850, '166 Rue Pasteur'),
('AlMohannadi', 'Hamad', '+97436899809', '1997-12-09', 'hamad.almohannadi4@example.com', 89, 29850, '115 Rue Victor Hugo'),
('Evans', 'Henry', '+44550229612', '2002-11-01', 'henry.evans12@example.com', 90, 29850, '95 Avenue de la Liberté'),
('Ait', 'Hassan', '+212752545991', '1958-03-06', 'hassan.ait97@example.com', 91, 29850, '165 Rue des Lilas'),
('Bensaid', 'Yacine', '+213679764381', '1977-07-04', 'yacine.bensaid37@example.com', 92, 29850, '77 Boulevard Voltaire'),
('Pereira', 'Carlos', '+351369003432', '2003-05-10', 'carlos.pereira42@example.com', 93, 29850, '170 Rue de la Gare'),
('Rousseau', 'Paul', '+33622683885', '1959-07-28', 'paul.rousseau95@example.com', 94, 29850, '130 Boulevard Voltaire'),
('Benali', 'Sofiane', '+213159696641', '1980-01-11', 'sofiane.benali22@example.com', 95, 29850, '138 Avenue de la Liberté'),
('Fernandes', 'Beatriz', '+351136968164', '2002-06-08', 'beatriz.fernandes43@example.com', 96, 29850, '48 Rue du Moulin'),
('Walker', 'Olivia', '+44188355231', '1964-05-07', 'olivia.walker23@example.com', 97, 29850, '59 Avenue de la Liberté'),
('Brown', 'Olivia', '+44779979955', '1964-08-03', 'olivia.brown61@example.com', 98, 29850, '93 Avenue des Champs-Élysées'),
('Pereira', 'Miguel', '+351058147700', '1978-05-03', 'miguel.pereira83@example.com', 99, 29850, '30 Avenue de la Liberté'),
('Faure', 'Lucas', '+33679807935', '1993-08-17', 'lucas.faure20@example.com', 100, 29850, '134 Rue Pasteur'),
('Cherif', 'Youssef', '+213518203778', '1988-10-06', 'youssef.cherif47@example.com', 101, 29850, '63 Avenue des Champs-Élysées'),
('AlKaabi', 'Khalid', '+97459051518', '1998-07-10', 'khalid.alkaabi33@example.com', 102, 29850, '181 Rue de la Gare'),
('Taylor', 'Charlotte', '+44254629148', '1979-11-26', 'charlotte.taylor43@example.com', 103, 29850, '73 Rue des Lilas'),
('Taylor', 'William', '+44685054235', '2004-08-07', 'william.taylor29@example.com', 104, 29850, '152 Rue Pasteur'),
('Taylor', 'George', '+44188805929', '1979-03-06', 'george.taylor24@example.com', 105, 29850, '34 Boulevard Voltaire'),
('Smith', 'Alice', '+44537947383', '1974-08-27', 'alice.smith25@example.com', 106, 29850, '79 Rue Pasteur'),
('AlNaimi', 'Reem', '+97446886239', '1963-05-02', 'reem.alnaimi83@example.com', 107, 29850, '190 Rue de la Gare'),
('Nunes', 'Beatriz', '+351181412478', '1964-07-03', 'beatriz.nunes29@example.com', 108, 29850, '101 Rue du Marché'),
('Costa', 'Beatriz', '+351068536153', '1956-06-04', 'beatriz.costa92@example.com', 109, 29850, '6 Rue du Moulin'),
('AlKuwari', 'Nasser', '+97447277901', '1956-05-07', 'nasser.alkuwari20@example.com', 110, 29850, '189 Rue du Moulin'),
('ElIdrissi', 'Lamia', '+212143410369', '1984-02-04', 'lamia.elidrissi64@example.com', 111, 29850, '129 Boulevard Voltaire'),
('ElIdrissi', 'Rachid', '+212324609539', '1981-03-22', 'rachid.elidrissi86@example.com', 112, 29850, '142 Rue des Lilas'),
('Laurent', 'Marion', '+33888880670', '1995-07-12', 'marion.laurent33@example.com', 113, 29850, '140 Rue du Moulin'),
('Cherif', 'Sonia', '+213319520585', '1996-03-27', 'sonia.cherif88@example.com', 114, 29850, '183 Rue des Lilas'),
('Silva', 'Marta', '+351217043030', '1975-05-17', 'marta.silva51@example.com', 115, 29850, '4 Rue Victor Hugo'),
('ElHaddad', 'Imane', '+212345054156', '1980-12-15', 'imane.elhaddad50@example.com', 116, 29850, '23 Rue du Moulin'),
('AlNaimi', 'Nasser', '+97475841616', '1993-03-18', 'nasser.alnaimi38@example.com', 117, 29850, '196 Avenue des Champs-Élysées'),
('AlSuwaidi', 'Hamad', '+97444796275', '1983-01-24', 'hamad.alsuwaidi46@example.com', 118, 29850, '115 Rue des Lilas'),
('Garcia', 'Alvaro', '+34658202970', '1963-02-08', 'alvaro.garcia83@example.com', 119, 29850, '12 Avenue de la Liberté'),
('AlKaabi', 'Aisha', '+97490927557', '2003-02-19', 'aisha.alkaabi18@example.com', 120, 29850, '195 Rue de la République'),
('Ait', 'Salma', '+212431027868', '1962-05-25', 'salma.ait34@example.com', 121, 29470, '197 Rue des Lilas'),
('Carvalho', 'Ana', '+351731217271', '1998-06-22', 'ana.carvalho45@example.com', 122, 29470, '181 Rue du Moulin'),
('Robin', 'Marion', '+33422583132', '1970-08-01', 'marion.robin47@example.com', 123, 29470, '70 Rue du Moulin'),
('Moulay', 'Lamia', '+212829114678', '1981-07-27', 'lamia.moulay74@example.com', 124, 29470, '89 Boulevard Voltaire'),
('Laurent', 'Luc', '+33177852892', '2004-03-14', 'luc.laurent65@example.com', 125, 29470, '58 Avenue de la Liberté'),
('Khelif', 'Yacine', '+213422535841', '1971-04-21', 'yacine.khelif71@example.com', 126, 29470, '92 Avenue des Champs-Élysées'),
('Mansour', 'Habib', '+21681829922', '1997-10-24', 'habib.mansour78@example.com', 127, 29470, '29 Avenue de la Liberté'),
('AlThani', 'Reem', '+97401094396', '1994-11-01', 'reem.althani64@example.com', 128, 29470, '120 Rue des Lilas'),
('ElHaddad', 'Nora', '+212364710276', '1985-08-07', 'nora.elhaddad44@example.com', 129, 29470, '10 Rue de la République'),
('Johnson', 'Charlotte', '+44562588153', '1984-02-09', 'charlotte.johnson58@example.com', 130, 29470, '104 Rue de la République'),
('Williams', 'Daniel', '+14696325953', '2003-03-16', 'daniel.williams66@example.com', 131, 29470, '76 Rue des Lilas'),
('Pereira', 'Marta', '+351016873395', '1958-01-10', 'marta.pereira64@example.com', 132, 29470, '113 Boulevard Voltaire'),
('Nunes', 'Miguel', '+351162456506', '1958-10-18', 'miguel.nunes25@example.com', 133, 29470, '54 Rue du Marché'),
('AlMohannadi', 'Omar', '+97468784991', '1963-02-13', 'omar.almohannadi48@example.com', 134, 29470, '11 Rue des Lilas'),
('AlObaidli', 'Omar', '+97423986800', '1957-03-23', 'omar.alobaidli43@example.com', 135, 29470, '121 Rue du Marché'),
('Medeiros', 'Carlos', '+351982595269', '2002-05-19', 'carlos.medeiros44@example.com', 136, 29470, '188 Rue de la Gare'),
('ElIdrissi', 'Kamal', '+212947055169', '1974-12-28', 'kamal.elidrissi89@example.com', 137, 29470, '80 Rue du Moulin'),
('Messaoud', 'Khaled', '+213993097289', '2004-07-05', 'khaled.messaoud88@example.com', 138, 29470, '16 Rue Victor Hugo'),
('Anderson', 'Michael', '+11307562636', '1987-10-16', 'michael.anderson95@example.com', 139, 29470, '176 Rue des Lilas'),
('Khelif', 'Karim', '+213857865278', '1976-09-12', 'karim.khelif87@example.com', 140, 29470, '192 Rue de la Gare'),
('Fakhfakh', 'Nour', '+21634843443', '1999-12-16', 'nour.fakhfakh41@example.com', 141, 29470, '61 Rue Victor Hugo'),
('Nunes', 'Beatriz', '+351441986652', '1973-01-10', 'beatriz.nunes92@example.com', 142, 29470, '22 Avenue des Champs-Élysées'),
('Rousseau', 'Claire', '+33473384842', '1961-10-24', 'claire.rousseau76@example.com', 143, 29470, '75 Avenue de la Liberté'),
('Johnson', 'Ashley', '+18330165712', '1955-09-06', 'ashley.johnson53@example.com', 144, 29470, '17 Boulevard Voltaire'),
('Santos', 'Marta', '+351454019380', '1966-07-27', 'marta.santos23@example.com', 145, 29470, '51 Rue de la République'),
('Messaoud', 'Sofiane', '+213400499154', '1984-11-18', 'sofiane.messaoud68@example.com', 146, 29470, '8 Boulevard Voltaire'),
('Nunes', 'Joao', '+351431527420', '2002-06-26', 'joao.nunes38@example.com', 147, 29470, '86 Rue Victor Hugo'),
('Anderson', 'Daniel', '+16685161227', '1975-04-01', 'daniel.anderson34@example.com', 148, 29470, '160 Rue du Marché'),
('Rodriguez', 'Lucia', '+34454990453', '1958-11-04', 'lucia.rodriguez60@example.com', 149, 29470, '61 Rue Pasteur'),
('Gharbi', 'Habib', '+21684145933', '1963-08-05', 'habib.gharbi59@example.com', 150, 29470, '106 Avenue des Champs-Élysées'),
('AlHajri', 'Faisal', '+97478339187', '1988-12-12', 'faisal.alhajri10@example.com', 151, 29470, '72 Rue Victor Hugo'),
('Robin', 'Paul', '+33839822587', '1962-11-07', 'paul.robin92@example.com', 152, 29470, '9 Rue de la République'),
('Nunes', 'Ines', '+351072867908', '1984-11-26', 'ines.nunes40@example.com', 153, 29470, '122 Avenue des Champs-Élysées'),
('Bensaid', 'Sofiane', '+213039106518', '1958-02-16', 'sofiane.bensaid5@example.com', 154, 29470, '26 Rue de la Gare'),
('BenSalah', 'Ibrahim', '+21626567661', '1998-11-28', 'ibrahim.bensalah70@example.com', 155, 29470, '194 Avenue de la Liberté'),
('Taylor', 'Charlotte', '+44868230047', '1998-12-18', 'charlotte.taylor55@example.com', 156, 29470, '41 Rue des Lilas'),
('Boukari', 'Sofiane', '+212752431069', '2004-01-08', 'sofiane.boukari27@example.com', 157, 29470, '27 Rue Pasteur'),
('Faure', 'Marie', '+33790306738', '1968-01-05', 'marie.faure65@example.com', 158, 29470, '133 Rue du Moulin'),
('Miled', 'Leila', '+21699534283', '1981-05-09', 'leila.miled8@example.com', 159, 29470, '83 Rue Pasteur'),
('Zouiten', 'Lamia', '+212687056856', '1981-03-10', 'lamia.zouiten49@example.com', 160, 29470, '173 Rue du Moulin'),
('Robinson', 'William', '+44342708668', '1988-03-13', 'william.robinson32@example.com', 161, 29470, '133 Rue du Marché'),
('Jaziri', 'Leila', '+21617518304', '1979-11-20', 'leila.jaziri78@example.com', 162, 29470, '159 Rue de la République'),
('Benkacem', 'Yacine', '+213983735403', '1967-12-04', 'yacine.benkacem96@example.com', 163, 29470, '32 Rue du Moulin'),
('Carvalho', 'Ana', '+351363854678', '1996-06-10', 'ana.carvalho34@example.com', 164, 29470, '173 Rue du Marché'),
('AlNaimi', 'Omar', '+97417535560', '1991-04-24', 'omar.alnaimi19@example.com', 165, 29470, '194 Rue de la République'),
('Khelif', 'Amel', '+213996423536', '1991-04-16', 'amel.khelif71@example.com', 166, 29470, '131 Rue du Marché'),
('AlNaimi', 'Khalid', '+97477252287', '1966-09-21', 'khalid.alnaimi8@example.com', 167, 29470, '135 Avenue des Champs-Élysées'),
('Ouarzazi', 'Rachid', '+212006231203', '1987-08-12', 'rachid.ouarzazi8@example.com', 168, 29470, '174 Rue Pasteur'),
('Costa', 'Marta', '+351886008484', '1956-09-27', 'marta.costa90@example.com', 169, 29470, '90 Rue du Moulin'),
('Martinez', 'Javier', '+34182339845', '1972-07-03', 'javier.martinez48@example.com', 170, 29470, '136 Rue de la République'),
('Moreno', 'Ana', '+34341016668', '1985-01-21', 'ana.moreno2@example.com', 171, 29470, '170 Boulevard Voltaire'),
('Robinson', 'Olivia', '+44659180339', '1985-05-02', 'olivia.robinson10@example.com', 172, 29470, '10 Rue Victor Hugo'),
('Miled', 'Meriem', '+21602503926', '1959-05-06', 'meriem.miled73@example.com', 173, 29470, '56 Rue de la République'),
('Wilson', 'Sarah', '+18562185016', '1969-02-11', 'sarah.wilson78@example.com', 174, 29470, '162 Rue Pasteur'),
('Garcia', 'Irene', '+34477358662', '1998-10-22', 'irene.garcia49@example.com', 175, 29470, '164 Rue de la République'),
('Moreau', 'Lucas', '+33311426265', '1978-02-03', 'lucas.moreau1@example.com', 176, 29470, '51 Rue de la Gare'),
('Jaziri', 'Karim', '+21641212678', '1990-09-14', 'karim.jaziri14@example.com', 177, 29470, '89 Rue Pasteur'),
('Nacer', 'Yacine', '+213199560466', '2004-02-24', 'yacine.nacer72@example.com', 178, 29470, '23 Rue du Moulin'),
('Taylor', 'Sarah', '+16224447212', '1982-05-14', 'sarah.taylor39@example.com', 179, 29470, '31 Avenue de la Liberté'),
('Oliveira', 'Ines', '+351379937124', '1955-07-11', 'ines.oliveira80@example.com', 180, 29470, '173 Avenue des Champs-Élysées'),
('Rodriguez', 'Irene', '+34692459375', '1966-07-11', 'irene.rodriguez38@example.com', 181, 29470, '4 Avenue des Champs-Élysées'),
('Santos', 'Sofia', '+351646519398', '1966-11-25', 'sofia.santos71@example.com', 182, 29470, '118 Rue des Lilas'),
('Benkacem', 'Youssef', '+213416724342', '2000-07-26', 'youssef.benkacem49@example.com', 183, 29470, '8 Rue de la République'),
('Faure', 'Camille', '+33968868058', '1993-11-03', 'camille.faure14@example.com', 184, 29470, '79 Rue Pasteur'),
('Jones', 'Emily', '+19096561014', '1969-09-24', 'emily.jones67@example.com', 185, 29470, '20 Avenue des Champs-Élysées'),
('Ouaziz', 'Lamia', '+212756798250', '1985-02-10', 'lamia.ouaziz54@example.com', 186, 29470, '75 Avenue de la Liberté'),
('Bernard', 'Marie', '+33457387571', '1983-12-23', 'marie.bernard58@example.com', 187, 29470, '45 Rue des Lilas'),
('AlMohannadi', 'Hamad', '+97410512382', '1990-03-11', 'hamad.almohannadi72@example.com', 188, 29470, '178 Avenue des Champs-Élysées'),
('Sanchez', 'Ana', '+34622660937', '1992-07-13', 'ana.sanchez1@example.com', 189, 29470, '170 Boulevard Voltaire'),
('Davis', 'Ashley', '+11918255371', '1971-11-28', 'ashley.davis63@example.com', 190, 29470, '17 Avenue de la Liberté'),
('Ouaziz', 'Salma', '+212969155792', '1998-12-26', 'salma.ouaziz39@example.com', 191, 29470, '192 Rue Victor Hugo'),
('Laurent', 'Luc', '+33341252866', '1993-03-19', 'luc.laurent50@example.com', 192, 29470, '96 Rue de la République'),
('Rodriguez', 'Javier', '+34828274225', '1983-10-02', 'javier.rodriguez46@example.com', 193, 29470, '85 Avenue des Champs-Élysées'),
('Boukhari', 'Youssef', '+213688767677', '1965-02-19', 'youssef.boukhari4@example.com', 194, 29470, '142 Boulevard Voltaire'),
('Johnson', 'Matthew', '+13842797881', '1991-02-09', 'matthew.johnson70@example.com', 195, 29470, '140 Rue de la République'),
('AlThani', 'Omar', '+97478361340', '1983-05-12', 'omar.althani12@example.com', 196, 29470, '174 Boulevard Voltaire'),
('Santos', 'Ines', '+351959629233', '1958-10-12', 'ines.santos69@example.com', 197, 29470, '41 Boulevard Voltaire'),
('Hassine', 'Nour', '+21654494812', '2003-07-02', 'nour.hassine36@example.com', 198, 29470, '13 Rue de la République'),
('Wilson', 'George', '+44536729466', '1983-02-21', 'george.wilson99@example.com', 199, 29470, '80 Rue Pasteur'),
('Robin', 'Antoine', '+33457759017', '1995-11-23', 'antoine.robin46@example.com', 200, 29470, '2 Rue de la République');

-- --------------------------------------------------------

--
-- Structure de la table `t_Reservation_res`
--

CREATE TABLE `t_Reservation_res` (
  `idt_Reservation_res` int(11) NOT NULL,
  `res_nom` varchar(50) NOT NULL,
  `res_date` date NOT NULL,
  `res_heur` datetime NOT NULL,
  `res_bilan` varchar(100) NOT NULL,
  `idt_Ressources_rcs` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Reservation_res`
--

INSERT INTO `t_Reservation_res` (`idt_Reservation_res`, `res_nom`, `res_date`, `res_heur`, `res_bilan`, `idt_Ressources_rcs`) VALUES
(1, 'Reservation_1', '2025-09-14', '2025-09-14 19:52:35', '', 6),
(2, 'Reservation_2', '2025-11-20', '2025-11-20 19:52:52', '', 3),
(3, 'Reservation_3', '2025-11-05', '2025-11-05 15:53:19', '', 1),
(4, 'Reservation_4', '2025-12-31', '2025-12-31 10:05:12', '', 2),
(5, 'Reservation_5', '0000-00-00', '0000-00-00 00:00:00', '', 1),
(6, 'Reservation_6', '0000-00-00', '0000-00-00 00:00:00', '', 5),
(7, 'Reservation_7', '0000-00-00', '0000-00-00 00:00:00', '', 4),
(8, 'Reservation_8', '0000-00-00', '0000-00-00 00:00:00', '', 1),
(9, 'Reservation_9', '0000-00-00', '0000-00-00 00:00:00', '', 1),
(10, 'Reservation_10', '0000-00-00', '0000-00-00 00:00:00', '', 1);

-- --------------------------------------------------------

--
-- Structure de la table `t_Ressources_rcs`
--

CREATE TABLE `t_Ressources_rcs` (
  `idt_Ressources_rcs` int(11) NOT NULL,
  `rcs_type` varchar(45) NOT NULL,
  `rcs_listeMateriels` varchar(45) NOT NULL,
  `rcs_jauge` int(11) NOT NULL,
  `rcs_photo` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Ressources_rcs`
--

INSERT INTO `t_Ressources_rcs` (`idt_Ressources_rcs`, `rcs_type`, `rcs_listeMateriels`, `rcs_jauge`, `rcs_photo`) VALUES
(1, 'Serre fraise 1', 'Serre chauffée', 30, 'b.png'),
(2, 'Serre fraise 2', 'Serre irrigation', 25, '0'),
(3, 'Labo1', 'Laboratoire sol', 10, '0'),
(4, 'Labo2', 'Laboratoire hydro', 8, '0'),
(5, 'Terrain jardinage', 'Parcelle communautaire', 50, '0'),
(6, 'Espace compost', 'Zone compostage', 5, '0');

-- --------------------------------------------------------

--
-- Structure de la table `t_Ressources_rese_has_t_Indisponibilite_dsp`
--

CREATE TABLE `t_Ressources_rese_has_t_Indisponibilite_dsp` (
  `idt_Ressources_rcs` int(11) NOT NULL,
  `idt_Indisponibilite_dsp` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Ressources_rese_has_t_Indisponibilite_dsp`
--

INSERT INTO `t_Ressources_rese_has_t_Indisponibilite_dsp` (`idt_Ressources_rcs`, `idt_Indisponibilite_dsp`) VALUES
(1, 1),
(2, 2);

-- --------------------------------------------------------

--
-- Structure de la table `t_Reunion_reu`
--

CREATE TABLE `t_Reunion_reu` (
  `idt_Reunion_reu` int(11) NOT NULL,
  `reu_sujet` varchar(45) NOT NULL,
  `reu_date` datetime NOT NULL,
  `reu_lieu` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_Reunion_reu`
--

INSERT INTO `t_Reunion_reu` (`idt_Reunion_reu`, `reu_sujet`, `reu_date`, `reu_lieu`) VALUES
(3, 'Journée portes ouvertes', '2025-11-10 10:00:00', 'Terrain jardinage'),
(4, 'Réunion des membres', '2025-10-20 10:00:00', 'Salle de conférence 3'),
(5, 'Réunion des membres', '2025-10-25 10:00:00', 'Salle de conférence 3');

--
-- Déclencheurs `t_Reunion_reu`
--
DELIMITER $$
CREATE TRIGGER `before_delete_reunion` BEFORE DELETE ON `t_Reunion_reu` FOR EACH ROW BEGIN
    -- Supprimer les participations associées à la réunion
    DELETE FROM t_Participe
    WHERE idt_Reunion_reu = OLD.idt_Reunion_reu;

    -- Supprimer le document PDF associé à la réunion
    DELETE FROM t_Doc_Pdf
    WHERE t_Reunion_reu = OLD.idt_Reunion_reu;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_ville_vil`
--

CREATE TABLE `t_ville_vil` (
  `idt_codepostale_vil` int(11) NOT NULL,
  `vil_nom` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_ville_vil`
--

INSERT INTO `t_ville_vil` (`idt_codepostale_vil`, `vil_nom`) VALUES
(29200, 'Brest'),
(29470, 'Plougastel-Daoulas'),
(29490, 'Guipavas'),
(29820, 'Guilers'),
(29850, 'Gouesnou');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `t_Actualite_act`
--
ALTER TABLE `t_Actualite_act`
  ADD PRIMARY KEY (`idt_Actualite_act`),
  ADD KEY `fk_t_Actualite_actu_t_compte_cpt1_idx` (`idt_compte_cpt`);

--
-- Index pour la table `t_compte_cpt`
--
ALTER TABLE `t_compte_cpt`
  ADD PRIMARY KEY (`idt_compte_cpt`),
  ADD UNIQUE KEY `cpt_user-name_UNIQUE` (`cpt_pseudo`);

--
-- Index pour la table `t_compte_cpt_has_t_Reservation_res`
--
ALTER TABLE `t_compte_cpt_has_t_Reservation_res`
  ADD PRIMARY KEY (`idt_compte_cpt`,`idt_Reservation_res`),
  ADD KEY `fk_t_compte_cpt_has_t_reservation_rese_t_reservation_rese1_idx` (`idt_Reservation_res`),
  ADD KEY `fk_t_compte_cpt_has_t_reservation_rese_t_compte_cpt1_idx` (`idt_compte_cpt`);

--
-- Index pour la table `t_Doc_Pdf`
--
ALTER TABLE `t_Doc_Pdf`
  ADD PRIMARY KEY (`idt_DocPDF`),
  ADD KEY `fk_t_Doc_Pdf_t_Reunion_reu1_idx` (`t_Reunion_reu`);

--
-- Index pour la table `t_Indisponibilite_dsp`
--
ALTER TABLE `t_Indisponibilite_dsp`
  ADD PRIMARY KEY (`idt_Indisponibilite_dsp`),
  ADD KEY `fk_t_Indisponibilite_dsp_t_Motif_mtf1_idx` (`idt_Motif_mtf`);

--
-- Index pour la table `t_Message_msg`
--
ALTER TABLE `t_Message_msg`
  ADD PRIMARY KEY (`idt_Message_msg`),
  ADD KEY `fk_t_Message_msg_t_compte_cpt1_idx` (`idt_compte_cpt`);

--
-- Index pour la table `t_Motif_mtf`
--
ALTER TABLE `t_Motif_mtf`
  ADD PRIMARY KEY (`idt_Motif_mtf`);

--
-- Index pour la table `t_Participe`
--
ALTER TABLE `t_Participe`
  ADD PRIMARY KEY (`idt_compte_cpt`,`idt_Reunion_reu`),
  ADD KEY `fk_t_compte_cpt_has_t_Reunion_reu_t_Reunion_reu1_idx` (`idt_Reunion_reu`),
  ADD KEY `fk_t_compte_cpt_has_t_Reunion_reu_t_compte_cpt1_idx` (`idt_compte_cpt`);

--
-- Index pour la table `t_profile_pfl`
--
ALTER TABLE `t_profile_pfl`
  ADD PRIMARY KEY (`idt_compte_cpt`),
  ADD KEY `fk_t_profile_pfl_t_compte_cpt1_idx` (`idt_compte_cpt`),
  ADD KEY `idx_codepostale_vil` (`idt_codepostale_vil`);

--
-- Index pour la table `t_Reservation_res`
--
ALTER TABLE `t_Reservation_res`
  ADD PRIMARY KEY (`idt_Reservation_res`),
  ADD KEY `fk_t_reservation_rese_t_Ressources_rese1_idx` (`idt_Ressources_rcs`);

--
-- Index pour la table `t_Ressources_rcs`
--
ALTER TABLE `t_Ressources_rcs`
  ADD PRIMARY KEY (`idt_Ressources_rcs`);

--
-- Index pour la table `t_Ressources_rese_has_t_Indisponibilite_dsp`
--
ALTER TABLE `t_Ressources_rese_has_t_Indisponibilite_dsp`
  ADD PRIMARY KEY (`idt_Ressources_rcs`,`idt_Indisponibilite_dsp`),
  ADD KEY `fk_t_Ressources_rese_has_t_Indisponibilite_dsp_t_Indisponib_idx` (`idt_Indisponibilite_dsp`),
  ADD KEY `fk_t_Ressources_rese_has_t_Indisponibilite_dsp_t_Ressources_idx` (`idt_Ressources_rcs`);

--
-- Index pour la table `t_Reunion_reu`
--
ALTER TABLE `t_Reunion_reu`
  ADD PRIMARY KEY (`idt_Reunion_reu`);

--
-- Index pour la table `t_ville_vil`
--
ALTER TABLE `t_ville_vil`
  ADD PRIMARY KEY (`idt_codepostale_vil`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `t_Actualite_act`
--
ALTER TABLE `t_Actualite_act`
  MODIFY `idt_Actualite_act` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `t_compte_cpt`
--
ALTER TABLE `t_compte_cpt`
  MODIFY `idt_compte_cpt` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=231;

--
-- AUTO_INCREMENT pour la table `t_Doc_Pdf`
--
ALTER TABLE `t_Doc_Pdf`
  MODIFY `idt_DocPDF` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `t_Indisponibilite_dsp`
--
ALTER TABLE `t_Indisponibilite_dsp`
  MODIFY `idt_Indisponibilite_dsp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `t_Message_msg`
--
ALTER TABLE `t_Message_msg`
  MODIFY `idt_Message_msg` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT pour la table `t_Reunion_reu`
--
ALTER TABLE `t_Reunion_reu`
  MODIFY `idt_Reunion_reu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `t_Actualite_act`
--
ALTER TABLE `t_Actualite_act`
  ADD CONSTRAINT `fk_t_Actualite_actu_t_compte_cpt1` FOREIGN KEY (`idt_compte_cpt`) REFERENCES `t_compte_cpt` (`idt_compte_cpt`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_compte_cpt_has_t_Reservation_res`
--
ALTER TABLE `t_compte_cpt_has_t_Reservation_res`
  ADD CONSTRAINT `fk_t_compte_cpt_has_t_reservation_rese_t_compte_cpt1` FOREIGN KEY (`idt_compte_cpt`) REFERENCES `t_compte_cpt` (`idt_compte_cpt`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_compte_cpt_has_t_reservation_rese_t_reservation_rese1` FOREIGN KEY (`idt_Reservation_res`) REFERENCES `t_Reservation_res` (`idt_Reservation_res`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_Doc_Pdf`
--
ALTER TABLE `t_Doc_Pdf`
  ADD CONSTRAINT `fk_t_Doc_Pdf_t_Reunion_reu1` FOREIGN KEY (`t_Reunion_reu`) REFERENCES `t_Reunion_reu` (`idt_Reunion_reu`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_Indisponibilite_dsp`
--
ALTER TABLE `t_Indisponibilite_dsp`
  ADD CONSTRAINT `fk_t_Indisponibilite_dsp_t_Motif_mtf1` FOREIGN KEY (`idt_Motif_mtf`) REFERENCES `t_Motif_mtf` (`idt_Motif_mtf`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_Message_msg`
--
ALTER TABLE `t_Message_msg`
  ADD CONSTRAINT `fk_t_Message_msg_t_compte_cpt1` FOREIGN KEY (`idt_compte_cpt`) REFERENCES `t_compte_cpt` (`idt_compte_cpt`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_Participe`
--
ALTER TABLE `t_Participe`
  ADD CONSTRAINT `fk_t_compte_cpt_has_t_Reunion_reu_t_Reunion_reu1` FOREIGN KEY (`idt_Reunion_reu`) REFERENCES `t_Reunion_reu` (`idt_Reunion_reu`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_compte_cpt_has_t_Reunion_reu_t_compte_cpt1` FOREIGN KEY (`idt_compte_cpt`) REFERENCES `t_compte_cpt` (`idt_compte_cpt`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_profile_pfl`
--
ALTER TABLE `t_profile_pfl`
  ADD CONSTRAINT `fk_profile_ville` FOREIGN KEY (`idt_codepostale_vil`) REFERENCES `t_ville_vil` (`idt_codepostale_vil`),
  ADD CONSTRAINT `fk_t_profile_pfl_t_compte_cpt1` FOREIGN KEY (`idt_compte_cpt`) REFERENCES `t_compte_cpt` (`idt_compte_cpt`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_Reservation_res`
--
ALTER TABLE `t_Reservation_res`
  ADD CONSTRAINT `fk_t_reservation_rese_t_Ressources_rese1` FOREIGN KEY (`idt_Ressources_rcs`) REFERENCES `t_Ressources_rcs` (`idt_Ressources_rcs`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_Ressources_rese_has_t_Indisponibilite_dsp`
--
ALTER TABLE `t_Ressources_rese_has_t_Indisponibilite_dsp`
  ADD CONSTRAINT `fk_t_Ressources_rese_has_t_Indisponibilite_dsp_t_Indisponibil1` FOREIGN KEY (`idt_Indisponibilite_dsp`) REFERENCES `t_Indisponibilite_dsp` (`idt_Indisponibilite_dsp`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_Ressources_rese_has_t_Indisponibilite_dsp_t_Ressources_r1` FOREIGN KEY (`idt_Ressources_rcs`) REFERENCES `t_Ressources_rcs` (`idt_Ressources_rcs`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
