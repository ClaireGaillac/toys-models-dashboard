Analyse de faisabilité des différents KPI, ceux exigés et ceux que je propose. Ils sont classés par ordre d'importance : d'abord les indispensables pour le client, puis les complémentaires, les optionnels et, pour finir, mes propositions.

## KPI obligatoires
### RH
**KPI** : Calculer le chiffre d’affaires généré par vendeur.
**Source** : `employees` (`lastName`,`employees.firstName`) → `customers.salesRepEmployeeNumber` → `orders.customerNumber` → `orderdetails` (`quantityOrdered`, `priceEach`)
**Calcul** : `SUM(quantityOrdered * priceEach)` par vendeur
**Remarque** : Il n'y a pas de lien direct entre `employees` et `orderdetails` : il faudra donc créer une relation.

### Ventes
**KPI** : Chiffre d’affaires par mois et par région
**Source** : `orderdetails` (`quantityOrdered`, `priceEach`) → `orders` (`orderDate` , `customerNumber`) → `customers.city`
**Calcul** : `SUM(quantityOrdered * priceEach)` par mois et par zone
**Remarque** : Il n'y a pas de colonne région. Je crée donc une hiérarchie (ville → état → pays → territoire) dans Power BI (drill-down), qui laisse le directeur choisir son niveau de lecture.

**KPI** : Taux d’évolution mensuel : suivre les revenus générés par région et par mois pour identifier les tendances géographiques.
**Source** : `orderdetails` (`quantityOrdered`, `priceEach`) → `orders` (`orderDate` , `customerNumber`) → `customers.city`
**Calcul** : `(SUM(quantityOrdered * priceEach) du mois - SUM(quantityOrdered * priceEach) du mois -1an) / (SUM(quantityOrdered * priceEach) du mois -1an) * 100`
**Remarque** : Je compare sur une période équivalente de l’année précédente : par exemple, si le mois est en cours et que l'on est le 17, je compare avec le même mois de l'année précédente, du 1er au 17. Je mets n.d. quand il n'y a pas de valeur précédente.

**KPI** : Produits les plus/moins vendus par catégorie.
**Source** : `orderdetails` (`quantityOrdered`, `productCode`) → `products.productLine`
**Calcul** : ORDER BY `SUM(quantityOrdered)` ASC et DESC par catégorie

### Finances
**KPI** : Clients générant le plus/moins de revenus.
**Source** : `orderdetails` (`quantityOrdered`, `priceEach`, `orderNumber`) → `orders.customerNumber` → `customers.customerName`
**Calcul** : `SUM(quantityOrdered * priceEach)` par client

### Logistique
**KPI** : Identifier les produits dont le stock est faible pour éviter les ruptures.
**Source** : `products` (`quantityInStock`, `productName`)
**Calcul** : ORDER BY `quantityInStock` ASC
**Remarque** : Observer d'abord les quantités en stock et la quantité moyenne commandée par produit, puis déterminer un seuil.


## KPI complémentaires
### RH
**KPI** : Identifier les écarts entre les commandes passées et les paiements reçus pour chaque représentant.
**Source** : `employees` (`lastName`,`employees.firstName`) → `customers.salesRepEmployeeNumber` → `orders.customerNumber` → `orderdetails` (`quantityOrdered`, `priceEach`) et `payments` (`customerNumber`, `amount`)
**Calcul** : (`SUM(quantityOrdered * priceEach)` par client - `SUM(amount)` par client) par vendeur
**Remarque** : Création de 2 vues, reliées entre elles par l'identifiant client.

**KPI** : Mesurer le chiffre d’affaires généré par bureau.
**Source** : `offices` (`officeCode`, `city`) → `employees` (`officeCode`, `employeeNumber`) → `customers.salesRepEmployeeNumber` → `orders.customerNumber` → `orderdetails` (`quantityOrdered`, `priceEach`)
**Calcul** : `SUM(quantityOrdered * priceEach)` par bureau
**Remarque** : Il n'y a pas de lien direct : on est obligé de passer par `employees` et par `customers` pour atteindre les ventes.

### Ventes
**KPI** : Marge brute par produit et par catégorie, pour en déduire les produits et catégories les plus/moins rentables.
**Source** : `products` (`productCode`, `productName`, `productLine`, `buyPrice`) → `orderdetails` (`priceEach`)
**Calcul** : marge unitaire = `orderdetails.priceEach` - `products.buyPrice` ; marge totale = `SUM((priceEach - buyPrice) × quantityOrdered)`
**Remarque** : `priceEach` est le prix réellement payé et `MSRP` le prix conseillé : je choisis donc le prix réel plutôt que le prix théorique.

### Finances
**KPI** : Taux de recouvrement des créances par client : identifier les clients ayant un montant élevé de commandes non payées.
**Source** : `customers.salesRepEmployeeNumber` → `orders.customerNumber` → `orderdetails` (`quantityOrdered`, `priceEach`) et `payments` (`customerNumber`, `amount`)
**Calcul** : `SUM(quantityOrdered * priceEach)` par client - `SUM(amount)` par client
**Remarque** : Création de 2 vues, puis comparaison de celles-ci.

### Logistique
**KPI** : Durée moyenne de traitement des commandes, et commandes dont le délai dépasse cette moyenne
**Source** : `orders` (`orderNumber`, `orderDate`, `shippedDate`)
**Calcul** : AVG(`shippedDate`-`orderDate`)


## KPI optionnels

### Ventes
**KPI** : Taux d’évolution mensuel des ventes par catégorie : mesurer la performance de chaque catégorie de produits dans le temps.
**Source** : `orders` (`orderNumber`, `orderDate`) → `orderdetails` (`quantityOrdered`, `priceEach`, `productCode`) → `products` (`productCode`, `productLine`)
**Calcul** : `(SUM(quantityOrdered * priceEach) du mois - SUM(quantityOrdered * priceEach) du mois -1an) / (SUM(quantityOrdered * priceEach) du mois -1an) * 100` par catégorie, par date (mois, année)

**KPI** : Panier moyen : mesurer le montant moyen des commandes.
**Source** : `orderdetails` (`quantityOrdered`, `priceEach`, `orderNumber`)
**Calcul** : `SUM(quantityOrdered * priceEach) / COUNT(DISTINCT orderNumber)` 

**KPI** : Taux de retour des clients : mesurer la fidélité des clients en identifiant ceux qui passent plusieurs commandes.
**Source** : `orders` (`orderNumber`, `customerNumber`)
**Calcul** : `COUNT(orderNumber)` par client ORDER BY DESC

### Finances
**KPI** : Croissance des ventes par trimestre : identifier les tendances saisonnières ou les opportunités de croissance.
**Source** : `orders` (`orderNumber`, `orderDate`) → `orderdetails` (`quantityOrdered`, `priceEach`)
**Calcul** : `SUM(quantityOrdered * priceEach)` par trimestre
**Remarque** : Création d'une colonne trimestre.

**KPI** : Montant moyen des paiements, et clients en dessous de la moyenne
**Source** : `payments` (`customerNumber`, `amount`) → `customers` (`customerName`)
**Calcul** : `AVG(amount)`

**KPI** : Taux de paiement par délai : identifier combien de temps les clients mettent pour payer après une commande.
**Source** : `orders` (`customerNumber`, `orderDate`) → `payments` (`customerNumber`, `paymentDate`)
**Calcul** : `payments.paymentDate` - `orders.orderDate`
**Remarque** : Les paiements ne sont pas associés à un numéro de commande : le délai par commande est donc incalculable. Il faut définir une alternative au niveau du client, par exemple le délai entre la première commande et le premier paiement, ou une comparaison entre le total des commandes et le total des paiements à un instant T.

### Logistique
**KPI** : Taux d’écoulement des stocks : mesurer la rapidité avec laquelle les stocks sont vendus pour chaque produit.
**Source** : `orders` (`orderNumber`, `orderDate`) → `orderdetails` (`quantityOrdered`, `productCode`)
**Calcul** :
**Remarque** :

**KPI** : Taux de commandes livrées en retard : identifier les problèmes logistiques et améliorer les délais de livraison.
**Source** : `orders` (`orderNumber`, `requiredDate`, `shippedDate`, `comments`)
**Calcul** : `shippedDate - requiredDate` 



## KPI supplémentaires proposés
### RH
**KPI** : Le volume des ventes dépend-il du nombre de vendeurs ?
**Source** : `offices` (`officeCode`, `city`) → `employees` (`officeCode`, `employeeNumber`) → `customers.salesRepEmployeeNumber` → `orders.customerNumber` → `orderdetails` (`quantityOrdered`, `priceEach`)
**Calcul** : `SUM(quantityOrdered * priceEach)` par bureau et `COUNT (salesRepEmployeeNumber)` par bureau

**KPI** : Statistiques sur le statut des commandes par employé et par client
**Source** : `employees` (`lastName`, `firstName`,`employeeNumber`) → `customers` (`salesRepEmployeeNumber`, `customerName`) → `orders` (`orderNumber`, `status`, `comments`, `customerNumber`)
**Calcul** : COUNT DISTINCT (status) par employé et par client

### Ventes
**KPI** : Nombre moyen de références par commande ?
**Source** : `orderdetails` (`orderNumber`, `productCode`)
**Calcul** : COUNT(`productCode`) par commande

**KPI** : Nombre moyen d'articles par commande ?
**Source** : `orderdetails` (`orderNumber`, `quantityOrdered`)
**Calcul** : SUM(`quantityOrdered`) par commande

### Logistique
**KPI** : Délai moyen entre le passage de la commande et la date de livraison demandée ?
**Source** : `orders` (`orderNumber`, `requiredDate`, `orderDate`)
**Calcul** : `requiredDate - orderDate`

**KPI** : Quelle est la valeur du stock immobilisé ?
**Source** : `products` (`productName`, `productLine`, `quantityInStock`, `buyPrice`)
**Calcul** : `SUM(quantityInStock * buyPrice)` par article, par catégorie, au total
