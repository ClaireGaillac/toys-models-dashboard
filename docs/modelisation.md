# Modélisation : schéma en étoile (OLAP)

## Principe
L'OLTP est conçu pour garantir l'intégrité des données, mais aussi pour éviter les redondances d'informations afin d'optimiser l'espace de stockage.

L'OLAP, lui, est conçu pour faciliter l'analyse de ces données : il demande moins de jointures, les analyses sont donc plus rapides. Ici, les redondances sont assumées.

On transforme l'OLTP en OLAP au moyen de vues.


## Vue d'ensemble
Le schéma du modèle sera une capture d'écran du diagramme Power BI.


## Tables de faits

### `fact_orders`
- **Granularité** : une ligne = une référence article d'une commande ; reliée à un client, à un employé, à un bureau et à un produit
- **Rôle** : Recenser toutes les ventes d'articles
- **Colonnes** :
   Colonne         | Origine (table.colonne)                                     | Rôle                    |
 | ----------------|-------------------------------------------------------------|-------------------------|
 | orderNumber     | `orders.orderNumber`                                        | Numéro de commande      |
 | customerNumber  | `customers.customerNumber`                                  | Clé vers `dim_customers`|
 | employeeNumber  | `customers.salesRepEmployeeNumber` → `orders.customerNumber`| Clé vers `dim_employees`|
 | productCode     | `products.productCode`                                      | Clé vers `dim_products` |
 | quantityOrdered | `orderdetails.quantityOrdered`                              | Quantité commandée      |
 | priceEach       | `orderdetails.priceEach`                                    | Prix unitaire           |
 | orderDate       | `orders.orderDate`                                          | Date de la commande     |
 | requiredDate    | `orders.requiredDate`                                       | Échéance de livraison   |
 | shippedDate     | `orders.shippedDate`                                        | Date d'envoi            |
 | status          | `orders.status`                                             | État d'avancement       |
 | comments        | `orders.comments`                                           | Commentaire             |

### `fact_payments`
- **Granularité** : une ligne = un paiement ; reliée à un client, à un employé et à un bureau
- **Rôle** : Recenser tous les paiements des clients
- **Colonnes** :
   Colonne        | Origine (table.colonne)                                       | Rôle                    |
 | ---------------|---------------------------------------------------------------|-------------------------|
 | checkNumber    | `payments.checkNumber`                                        | Identifiant du paiement |
 | customerNumber | `payments.customerNumber`                                     | Clé vers `dim_customers`|
 | employeeNumber | `payments.customerNumber` → `customers.salesRepEmployeeNumber`| Clé vers `dim_employees`|
 | paymentDate    | `payments.paymentDate`                                        | Date du paiement        |
 | amount         | `payments.amount`                                             | Montant du paiement     |



## Tables de dimensions

### `dim_customers`
- **Rôle** : Recense tous les clients
- **Colonnes** :
   Colonne               | Origine (table.colonne)                  | Rôle                              |
 | ----------------------|------------------------------------------|-----------------------------------|
 | customerNumber        | `customers.customerNumber`               | Clé                               |
 | customerName          | `customers.customerName`                 | Nom du commerce du client         |
 | city                  | `customers.city`                         | Ville                             |
 | state                 | `customers.state`                        | État                              |
 | country               | `customers.country`                      | Pays                              |
 | creditLimit           | `customers.creditLimit`                  | Limite de crédit                  |

### `dim_employees`
- **Rôle** : Recense tous les employés
- **Colonnes** :
   Colonne               | Origine (table.colonne)                         | Rôle                       |
 | ----------------------|-------------------------------------------------|----------------------------|
 | employeeNumber        | `employees` → `customers.salesRepEmployeeNumber`| Clé                        |
 | fullName              | `employees.lastName + employees.firstName`      | Nom complet de l'employé   |
 | officeCode            | `employees.officeCode`                          | Clé vers `offices`         |
 | city                  | `offices.city`                                  | Ville du bureau            |
 | state                 | `offices.state`                                 | État du bureau             |
 | country               | `offices.country`                               | Pays du bureau             |
 | territory             | `offices.territory`                             | Territoire du bureau       |

### `dim_products`
- **Rôle** : Recense toutes les références produits
- **Colonnes** :
   Colonne               | Origine (table.colonne)                  | Rôle                              |
 | ----------------------|------------------------------------------|-----------------------------------|
 | productCode           | `products.productCode`                   | Clé                               |
 | productName           | `products.productName`                   | Nom du produit                    |
 | productLine           | `products.productLine`                   | Nom de la catégorie               |
 | productVendor         | `products.productVendor`                 | Nom du fournisseur                |
 | quantityInStock       | `products.quantityInStock`               | Quantité présente en stock        |
 | buyPrice              | `products.buyPrice`                      | Prix d'achat chez le fournisseur  |
 | MSRP                  | `products.MSRP`                          | Prix de vente conseillé           |

### `dim_date`
- **Rôle** : Recense toutes les dates, de la première commande à la dernière
- **Colonnes** :
   Colonne         | Origine (table.colonne)            | Rôle                |
 | ----------------|------------------------------------|---------------------|
 | date            | générée (première - dernière vente)| Jour                |
 | year            | `YEAR(date)`                       | Année               |
 | quarter         | `QUARTER(date)`                    | Trimestre           |
 | month           | `MONTH(date)`                      | Mois                |
 | month_name      | `DATE_FORMAT(date, '%M')`          | Nom du mois         |
 | day_of_month    | `DAY(date)`                        | Jour dans le mois   |
 | day_name        | `DAYNAME(date)`                    | Jour de la semaine  |



## Relations
 | De              | Vers            | Cardinalité | Pourquoi                             |
 |-----------------|-----------------|-------------|--------------------------------------|
 | `fact_orders`   | `dim_customers` | 1 à N       | Un client passe des commandes        |
 | `fact_orders`   | `dim_employees` | 1 à N       | Un employé est lié à des commandes   |
 | `fact_orders`   | `dim_products`  | 1 à N       | Une commande contient des produits   |
 | `fact_orders`   | `dim_date`      | 1 à N       | Une date reçoit des commandes        |
 | `fact_payments` | `dim_customers` | 1 à N       | Un client réalise des paiements      |
 | `fact_payments` | `dim_employees` | 1 à N       | Les paiements sont liés à un employé |
 | `fact_payments` | `dim_date`      | 1 à N       | Une date reçoit des paiements        |

## Décisions de modélisation
J'ai décidé de fusionner les tables `employees` et `offices` en une seule et même table de dimension. Les analyses par bureau ou par territoire passeront donc par la dimension employés, et non par une dimension bureau dédiée.

Je fais le choix d'utiliser `salesRepEmployeeNumber` plutôt que `employeeNumber`, car `salesRepEmployeeNumber` correspond à l'`employeeNumber` des vendeurs. Ici, seuls les vendeurs m'intéressent pour mon analyse.

J'ai fait le choix de concaténer le prénom et le nom des employés, car ils serviront uniquement à l'affichage. Le nom ou le prénom seul ne serait pas fiable (trop de risques de doublons).

Je mets `status` dans `fact_orders`, ce qui permet notamment de distinguer les montants des commandes annulées pour ne pas les compter dans le CA.
