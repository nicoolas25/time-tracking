# Time-tracking

Un outils simple de gestion et d'analyse de son temps.

## Introduction

Le projet permet de créer plusieurs profils utilisateur et plusieurs type de tache.
Chaque profil va pouvoir imputer du temps sur des taches au travers d'assignations.

Un tableau de bord permet de voir les assignations en cours pour un profil et
un autre permet de voir les consomations par type de tache.

## Terminologie

Dans le code il s'agit de gâteaux, de mangeurs, de parts et de bouchées.
Dans l'interface il s'agit de projets, d'utilisateurs, de découpes et de temps passé.
La terminologie varie en fonction de l'utilisation.

## Captures d'écran

Des captures d'écran sont disponibles dans le dossier `doc/screenshots`.

## Développement

Ceci est un projet jouet destiné à éprouver l'utilité d'un ORM et l'influence de ce dernier dans le design des applications.
En conséquence, le code s'organise de manière un peu particulière. Des aspects sont regroupés indépendament de la logique métier.
Parmi ces aspects se trouve la persistance, la présentation et la création depuis l'interface web.
Chaque aspect se trouve dans un répertoire dédié.

### Models

L'aspect métier.

### Persistances

Les aspects liés à la base de donnée et à la conservation des objet d'une exécution à une autre.

### Interfaces

Les aspects liés à l'interfacage avec l'application Web.
