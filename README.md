⚠️ BACKEND OFF ⚠️

# Projet AzurLoc - Documentation

## Objectif

Le projet AzurLoc vise à développer une application mobile permettant aux utilisateurs de découvrir et de s'inscrire à des activités de groupe. Le développement suit la philosophie du MVP (Minimum Viable Product), en appliquant les méthodologies agiles et la rédaction de User Stories pour définir les fonctionnalités clés.

## Plateforme de Test

- Émulateur Android


## Identifiants de Connexion
- **Utilisateur**
    - **Username**: user
    - **Password**: 123456789
- **Admin**
    - **Username**: user_admin
    - **Password**: 123456789


### MVP

1. **Interface de Login**:
   - Connexion à l'application avec vérification en base de données.
   - Champs de saisie pour login et mot de passe, avec obfuscation pour ce dernier.
   
2. **Liste des Activités**:
   - Affichage des activités disponibles après connexion.
   - Informations affichées par activité: image, titre, lieu, et prix.
   - Navigation via une BottomNavigationBar incluant Activités, Panier, et Profil.
   
3. **Détail d’une Activité**:
   - Affichage détaillé d'une activité avec possibilité d'ajout au panier.
   - Informations affichées: image, titre, catégorie, lieu, nombre minimum de personnes, et prix.
   
4. **Le Panier**:
   - Visualisation du panier de l'utilisateur avec liste des activités ajoutées.
   - Affichage du total général et possibilité de retirer des activités.
   
5. **Profil Utilisateur**:
   - Accès et modification des informations du profil utilisateur.
   - Informations modifiables: Nom, prénom, adresse, code postal, et ville.
   - Option de déconnexion.
   
6. **Gestion admin**:
   - Interface admin permettant de gérer les activités et catégories

### Fonctionnalités Supplémentaires

- **Historique de Commandes**:
  - Les utilisateurs peuvent consulter l'historique de leurs commandes et activités achetées.
  
- **Systeme JWT**
    - Implémentation d'un système d'authentification basé sur JWT pour sécuriser les échanges.

- **Rôles Utilisateurs (Admin)**
    - Les utilisateurs avec le rôle d'admin ont la possibilité d'ajouter, modifier, et supprimer des activités et des catégories.
  
- **Création de compte**
    - Tout personnes ayant l'application peut se créer une compte utilisateur
