/*
  Vue : fact_orders
  Rôle : Recense toutes les références commandées
  Granularité : une ligne = une référence article d'une commande
  Volume : Il y a 2649 lignes
  Choix : - Ajout de `salesAmount` (quantityOrdered × priceEach) : le montant de la ligne.
  */
  CREATE OR REPLACE VIEW fact_orders AS 
  
  SELECT od.orderNumber, o.customerNumber, c.salesRepEmployeeNumber AS employeeNumber, od.productCode, od.quantityOrdered, 
  od.priceEach, o.orderDate, o.requiredDate, o.shippedDate, o.status, o.comments, 
  (od.quantityOrdered * od.priceEach) AS salesAmount
  FROM orderdetails AS od
  LEFT JOIN orders AS o ON od.orderNumber = o.orderNumber
  LEFT JOIN customers AS c ON o.customerNumber = c.customerNumber;
  