# 📊 Toys and Models — Tableau de bord de pilotage

Contexte : le directeur d'un fabricant de miniatures de collection veut consulter chaque matin les indicateurs clés de son activité (ventes, finances, logistique, ressources humaines) pour piloter l'entreprise.

## 🎯 Objectif
Construire la chaîne complète : requêtage SQL → modélisation analytique (schéma en étoile) → dashboard interactif Power BI, actualisable chaque matin.

## 🗺️ Plan du projet
- [x] Exploration de la base transactionnelle (OLTP)
- [x] Conception du schéma en étoile (tables de faits + dimensions)
- [ ] Création des vues SQL (modèle analytique)
- [ ] Import dans Power BI et relations (OLAP)
- [ ] Mesures DAX (KPI ventes, finances, logistique, RH)
- [ ] Dashboard interactif avec filtres
- [ ] Documentation des choix de modélisation

## 🔧 Stack
`SQL (MySQL)` `Power BI` `DAX` `Data modeling (schéma en étoile)`

## 📂 Données
La base de données (`data/script_bdd.sql`) est fournie dans le cadre de la formation Data Analyst (Wild Code School), projet "Toys and Models". Il s'agit de la base d'exemple "Classic Models", adaptée pour l'exercice.

Couche analytique construite en vues SQL au-dessus de la base transactionnelle, sans modification de la source.

---
🚧 Projet en cours de construction — documentation détaillée à venir.
