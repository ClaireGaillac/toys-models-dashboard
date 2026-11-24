/*
  Vue : fact_orders
  Rôle : Recense toutes les références commandées
  Granularité : une ligne = une référence article d'une commande
  Volume : Il y a 2649 lignes
  Choix : - Ajout de `salesAmount` (quantityOrdered × priceEach) : le montant de la ligne.
          - Ajout de `grossMargin` ((priceEach − buyPrice) × quantityOrdered) : la marge brute de la ligne, au prix
            réellement payé.
          - Les deux montants incluent toutes les commandes : le CA et la marge ne retiennent que les statuts
            Shipped et Resolved, filtrés dans les mesures DAX grâce à `status`.
          - Ajout de `processingDays` (DATEDIFF(shippedDate, orderDate)) : le délai de traitement en jours. Il vaut NULL
            pour les commandes non expédiées, ce qui les exclut automatiquement des moyennes. Le délai est identique
            sur toutes les lignes d'une commande : la moyenne se calcule par commande en DAX, pas par ligne.
  Limite : `buyPrice` est le prix d'achat actuel, pas celui en vigueur au moment de chaque vente : la marge des
           ventes anciennes est approximative si les prix fournisseurs ont changé.
  */
  CREATE OR REPLACE VIEW fact_orders AS 
  
  SELECT od.orderNumber, o.customerNumber, c.salesRepEmployeeNumber AS employeeNumber, od.productCode, od.quantityOrdered, 
  od.priceEach, o.orderDate, o.requiredDate, o.shippedDate, o.status, o.comments, 
  (od.priceEach - p.buyPrice) * od.quantityOrdered AS grossMargin, (od.quantityOrdered * od.priceEach) AS salesAmount, 
  DATEDIFF(o.shippedDate, o.orderDate) AS processingDays
  FROM orderdetails AS od
  LEFT JOIN orders AS o ON od.orderNumber = o.orderNumber
  LEFT JOIN customers AS c ON o.customerNumber = c.customerNumber
  LEFT JOIN products AS p ON od.productCode = p.productCode;