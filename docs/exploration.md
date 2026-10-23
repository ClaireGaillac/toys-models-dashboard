On peut voir qu'il y a actuellement 8 tables : customers, employees, offices, orderdetails, orders, payments, productlines, products.

## Table `customers` (13 colonnes, 122 lignes)
> **Rôle** : une ligne = un client (entreprise) ; reliée à son vendeur (employees).

### Structure
| **Colonne**            | **Type**      | **Nullable** | **Rôle**                                   |
|------------------------|---------------|--------------|--------------------------------------------|
| customerNumber         | int           | non          | **PK** de l'entreprise                     |
| customerName           | varchar(50)   | non          | Nom de l'entreprise                        |
| contactLastName        | varchar(50)   | non          | Nom du contact de l'entreprise             |
| contactFirstName       | varchar(50)   | non          | Prénom du contact de l'entreprise          |
| phone                  | varchar(50)   | non          | Numéro du contact de l'entreprise          |
| addressLine1           | varchar(50)   | non          | Adresse de l'entreprise                    |
| addressLine2           | varchar(50)   | **oui**      | Complément d'adresse de l'entreprise       |
| city                   | varchar(50)   | non          | Ville où se situe l'entreprise             |
| state                  | varchar(50)   | **oui**      | État où se situe l'entreprise              |
| postalCode             | varchar(15)   | **oui**      | Code postal de l'entreprise                |
| country                | varchar(50)   | non          | Pays où se situe l'entreprise              |
| salesRepEmployeeNumber | int           | **oui**      | **FK** vers `employees`                    |
| creditLimit            | decimal(10,2) | **oui**      | Limite de crédit qu'un client peut obtenir |

### Observations sur les données
- Certains clients ne sont pas encore affectés à un employé.
- Il y a 36 clients aux USA, suivis de l'Allemagne (13 clients) et de la France (12 clients).
- L'entreprise a des clients dans 27 pays.

### ⚠️ À creuser pour la modélisation
- Dans les 27 pays représentés, y a-t-il vraiment des ventes dans chacun, ou certains sont-ils de nouveaux marchés ?
- Où se situent les entreprises qui ne sont pas encore affectées ? Dans une ou plusieurs zones géographiques ? À quel vendeur les attribuer ?



## Table `employees` (8 colonnes, 23 lignes)
> **Rôle** : une ligne = un employé ; reliée à son responsable et à son bureau.

### Structure
| **Colonne**    | **Type**     | **Nullable** | **Rôle**                           |
|----------------|--------------|--------------|------------------------------------|
| employeeNumber | int          | non          | **PK** de l'employé                |
| lastName       | varchar(50)  | non          | Nom de l'employé                   |
| firstName      | varchar(50)  | non          | Prénom de l'employé                |
| extension      | varchar(10)  | non          | Extension du standard téléphonique |
| email          | varchar(100) | non          | E-mail de l'employé                |
| officeCode     | varchar(10)  | non          | **FK** vers `offices`              |
| reportsTo      | int          | **oui**      | **FK** vers `employees`            |
| jobTitle       | varchar(50)  | non          | Intitulé du poste occupé           |

### Observations sur les données
- Il y a 7 bureaux ; le bureau 1 compte le plus d'employés.
- Il y a 7 types de postes.
- 23 personnes travaillent dans cette société, dont 17 comme vendeurs.

### ⚠️ À creuser pour la modélisation
- Quel est le siège social ? Dans quelle ville se situe-t-il ? Y a-t-il une corrélation avec les ventes ?
- Corrélation entre le nombre d'employés et le volume des ventes ?
- Répartition des employés sur le territoire.



## Table `offices` (9 colonnes, 7 lignes)
> **Rôle** : une ligne = un bureau.

### Structure
| **Colonne**  | **Type**    | **Nullable** | **Rôle**                       |
|--------------|-------------|--------------|--------------------------------|
| officeCode   | varchar(10) | non          | **PK** du bureau               |
| city         | varchar(50) | non          | Ville du bureau                |
| phone        | varchar(50) | non          | Numéro de téléphone du bureau  |
| addressLine1 | varchar(50) | non          | Adresse du bureau              |
| addressLine2 | varchar(50) | **oui**      | Complément d'adresse du bureau |
| state        | varchar(50) | **oui**      | État du bureau                 |
| country      | varchar(50) | non          | Pays du bureau                 |
| postalCode   | varchar(15) | non          | Code postal du bureau          |
| territory    | varchar(10) | non          | Zone géographique du bureau    |

### Observations sur les données
- 3 bureaux se situent aux USA.
- Les ventes sont réparties en 4 grandes zones commerciales.
- Le Japon est une zone commerciale à lui tout seul.

### ⚠️ À creuser pour la modélisation
- Pourquoi le Japon est-il le seul pays à constituer une zone commerciale à lui tout seul ? Erreur ou gros marché ?
- La majorité des ventes se situe-t-elle aux USA ? Le siège social se situe-t-il aux USA ?



## Table `orderdetails` (5 colonnes, 2649 lignes)
> **Rôle** : une ligne = l'association d'une commande et d'un article.

### Structure
| **Colonne**     | **Type**      | **Nullable** | **Rôle**                             |
|-----------------|---------------|--------------|--------------------------------------|
| orderNumber     | int           | non          | **PK** du numéro de commande         |
| productCode     | varchar(15)   | non          | **PK** du code article (référence)   |
| quantityOrdered | int           | non          | Quantité commandée                   |
| priceEach       | decimal(10,2) | non          | Prix unitaire                        |
| orderLineNumber | smallint      | non          | Position du produit dans la commande |

### Observations sur les données
- Il y a 283 commandes dans l'historique des ventes.
- 92 048 articles ont été vendus.
- Une commande contient jusqu'à 18 articles différents.

### ⚠️ À creuser pour la modélisation
- Quels sont les articles les plus vendus ? Les moins vendus ?
- Quel est l'article le plus cher ? Le moins cher ? Quel est le prix moyen ?
- Montant de la commande la plus élevée ? La moins élevée ? Nombre d'articles dans ces commandes ?
- Panier moyen ? Nombre moyen d'articles ?
- Chiffre d'affaires par mois ? Par an ? Par vendeur (évolution) ? Par ville, pays ou zone géographique ?
- Nombre moyen de références par commande ?



## Table `orders` (7 colonnes, 283 lignes)
> **Rôle** : une ligne = un numéro de commande ; reliée à un client.

### Structure
| **Colonne**    | **Type**    | **Nullable** | **Rôle**                                     |
|----------------|-------------|--------------|----------------------------------------------|
| orderNumber    | int         | non          | **PK** du numéro de commande                 |
| orderDate      | date        | non          | Date du passage de la commande               |
| requiredDate   | date        | non          | Échéance de livraison demandée par le client |
| shippedDate    | date        | **oui**      | Date d'envoi de la commande                  |
| status         | varchar(15) | non          | État d'avancement de la commande             |
| comments       | text        | **oui**      | Commentaire                                  |
| customerNumber | int         | non          | **FK** vers `customers`                      |

### Observations sur les données
- Commandes passées du 21 janvier 2022 au 4 mars 2024.
- Il y a 4 statuts : Envoyée, Annulée, Résolue et En attente.

### ⚠️ À creuser pour la modélisation
- Y a-t-il des commandes non envoyées ? Avec quels commentaires ?
- Délai moyen entre le passage de la commande et la date de livraison demandée ?
- Les commandes sont-elles toujours envoyées avant la date requise ? Sinon, lesquelles ? Pourquoi ?
- Combien de temps avant la date requise les commandes sont-elles envoyées ?
- Que disent les commentaires ? S'agit-il uniquement de problèmes ?
- Combien de commandes annulées ? Pourquoi ?
- Combien de commandes en attente ? Pourquoi ?
- Combien de problèmes résolus ? Par qui ? Où ? Pourquoi ?
- Statistiques sur le statut des commandes par employé et par client : d'où vient le problème ?
- Combien de commandes ont une date d'envoi NULL ? Pourquoi ?



## Table `payments` (4 colonnes, 249 lignes)
> **Rôle** : une ligne = l'association d'un paiement et d'un client.

### Structure
| **Colonne**    | **Type**      | **Nullable** | **Rôle**                        |
|----------------|---------------|--------------|---------------------------------|
| customerNumber | int           | non          | **PK** de l'entreprise cliente  |
| checkNumber    | varchar(50)   | non          | **PK** du numéro de transaction |
| paymentDate    | date          | non          | Date du paiement                |
| amount         | decimal(10,2) | non          | Montant du paiement             |

### Observations sur les données
- Montant total des 249 paiements : 7 953 335,23 $.
- De 1 128,20 $ à 116 208,40 $ par paiement.

### ⚠️ À creuser pour la modélisation
- Combien de clients ont payé leurs commandes ?
- Qui n'a pas payé sa ou ses commandes ? Pour quel montant ?
- Montant total des commandes impayées ?
- Qui paie le plus vite ? Le plus lentement ?
- Corrélation entre le paiement et le statut de la commande ? À quel moment du cycle le client paie-t-il ?



## Table `productLines` (4 colonnes, 7 lignes)
> **Rôle** : une ligne = une catégorie.

### Structure
| **Colonne**     | **Type**      | **Nullable** | **Rôle**                    |
|-----------------|---------------|--------------|-----------------------------|
| productLine     | varchar(50)   | non          | **PK** de la catégorie      |
| textDescription | varchar(4000) | **oui**      | Description de la catégorie |
| htmlDescription | mediumtext    | **oui**      | Lien vers la description    |
| image           | mediumblob    | **oui**      | Lien vers l'image           |

### Observations sur les données
- Il y a 7 catégories.

### ⚠️ À creuser pour la modélisation
- Combien d'articles par catégorie ?
- À quelle catégorie appartiennent l'article le moins cher et le plus cher ?
- Prix moyen des articles par catégorie ?
- À quelle catégorie appartiennent l'article le moins vendu et le plus vendu ?
- Nombre moyen d'articles vendus par catégorie ?
- Les clients achètent-ils tous des références dans toutes les catégories ?



## Table `products` (9 colonnes, 110 lignes)
> **Rôle** : une ligne = un article ; reliée à une catégorie.

### Structure
| **Colonne**        | **Type**      | **Nullable** | **Rôle**                             |
|--------------------|---------------|--------------|--------------------------------------|
| productCode        | varchar(15)   | non          | **PK** de référence de l'article     |
| productName        | varchar(70)   | non          | Nom de l'article                     |
| productLine        | varchar(50)   | non          | **FK** vers `productLines`           |
| productScale       | varchar(10)   | non          | Échelle de réduction de la miniature |
| productVendor      | varchar(50)   | non          | Nom du fournisseur                   |
| productDescription | text          | non          | Description du produit               |
| quantityInStock    | smallint      | non          | Quantité d'articles en stock         |
| buyPrice           | decimal(10,2) | non          | Prix d'achat chez le fournisseur     |
| MSRP               | decimal(10,2) | non          | Prix de vente conseillé              |

### Observations sur les données
- Il y a 110 références d'articles.
- Les maquettes sont de 10 à 700 fois plus petites que l'original.
- Il y a 13 fournisseurs référencés.

### ⚠️ À creuser pour la modélisation
- Y a-t-il plusieurs fournisseurs par référence ? Combien en moyenne ? Vendent-ils au même prix ?
- Quel fournisseur vend le moins cher les articles de notre top des ventes ?
- Combien de marge gagne-t-on en passant d'un fournisseur à un autre ? Pour quels articles l'écart est-il le plus élevé ? Le plus faible ?
- Quelle est la marge par produit ? Par catégorie ?
- Quelle quantité en stock ? Quelle somme immobilisée cela représente-t-il ?
- Quels produits sont proches de la rupture de stock ?
- Comment déterminer le seuil de réapprovisionnement ?
- Réapprovisionne-t-on tous les articles ?
