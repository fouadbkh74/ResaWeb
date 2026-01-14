# ResaWeb

## Introduction du projet
Le projet **ResaWeb** est une application web développée en **PHP** avec le framework  
**CodeIgniter**.  
Son objectif est de fournir un **système de réservation complet** 

<img width="889" height="371" alt="Screenshot 2026-01-14 185917" src="https://github.com/user-attachments/assets/4f8a5b2a-641f-4d51-988f-0fc151918652" />


tout en appliquant les bonnes pratiques de :

- Modélisation UML
- Conception et gestion de bases de données
- Développement PHP avec le framework CodeIgniter et l’architecture MVC
- Déploiement serveur

---

## Modélisation du projet

### Diagramme de classes UML
La modélisation a été réalisée à l’aide de l’outil **UMLet**.  
Elle permet de définir :
- Les entités
- Les attributs
- Les relations entre entités
- La structure générale de la base de données

---

## Base de données

### Schéma relationnel
Le schéma relationnel respecte les règles de normalisation **(1FN à 3FN)** :
- Définition des clés primaires
- Définition des clés étrangères
- Contraintes d’intégrité
- Relations entre les tables  

La modélisation a été réalisée avec **MySQL Workbench**.

### Création via phpMyAdmin
Le schéma exporté depuis MySQL Workbench a été importé dans **phpMyAdmin**.  
Des jeux de données ont été ajoutés afin de tester les opérations **CRUD**.

---

## Manipulation des données – CRUD
Les opérations **CRUD** représentent les actions essentielles sur les données :
- **Create** : création
- **Retrieve** : lecture
- **Update** : mise à jour
- **Delete** : suppression
<img width="953" height="410" alt="Screenshot 2026-01-14 185445" src="https://github.com/user-attachments/assets/3640f787-ec85-4091-8e0a-e5770873d183" />
---

## Sécurité : Hashage des mots de passe
Le hashage permet de stocker une empreinte non réversible des mots de passe.  
Exemple :
sql SHA2(CONCAT(sel, motdepasse), 256)

##Annex : DashBoard
<img width="949" height="303" alt="Screenshot 2026-01-14 185507" src="https://github.com/user-attachments/assets/64d1b483-aa99-4b34-aaf2-4b46d1046513" />




