# Project Manager — Plateforme Collaborative

Une application web collaborative de gestion de projets conçue pour le suivi en temps réel de tâches et l'analyse de performance d'équipe. Ce projet repose sur une architecture robuste respectant le design pattern MVC pour une séparation claire des responsabilités.

## 🚀 Fonctionnalités Clés

* **Espace Collaboratif :** Système d'authentification sécurisé et gestion des accès aux projets via codes sécurisés.
* **Gestion de Tâches :** CRUD complet avec priorisation et calcul dynamique de l'avancement global du projet (0-100%).
* **Dashboard BI (Business Intelligence) :** Interface administrateur avancée affichant 8 KPIs métiers essentiels, incluant le suivi de la charge de travail et le taux de complétion.
* **Visualisation Interactive :** Intégration de graphiques statistiques via Chart.js pour une aide à la décision rapide.

## 🛠️ Stack Technique

* **Backend :** Java EE, Servlets, JSP
* **Architecture :** Design Pattern MVC & DAO (Data Access Object)
* **Base de données :** MySQL (requêtes préparées pour la sécurité)
* **Frontend :** HTML5, CSS3 (Responsive), JavaScript
* **Data Viz :** Chart.js
* **Persistence :** JDBC

## 📂 Architecture Logicielle

Le projet est structuré pour garantir la maintenabilité et la sécurité :
1. **Model (DAO) :** Gestion de la persistance des données et des interactions SQL.
2. **View (JSP) :** Interfaces dynamiques et responsives.
3. **Controller (Servlets) :** Routage des requêtes et logique métier.



## ⚙️ Installation et Configuration

### 1. Prérequis
* JDK 11+
* Serveur d'application (Tomcat)
* MySQL Server

### 2. Base de données
* Créez une base de données nommée `project_manager_db`.
* Importez le schéma SQL fourni dans le dossier `/db/schema.sql`.

### 3. Lancement
1. Clonez le dépôt : `git clone [URL_DU_REPO]`
2. Importez le projet dans votre IDE (Eclipse/IntelliJ).
3. Configurez le fichier de connexion JDBC dans vos classes DAO.
4. Déployez le WAR sur votre serveur Tomcat et accédez à `http://localhost:8080/project-manager`.

## 📈 Dashboard & BI
Le Dashboard Administrateur permet de visualiser en temps réel :
* Taux de complétion des projets.
* Charge moyenne par collaborateur.
* Évolution de la vélocité des équipes.
