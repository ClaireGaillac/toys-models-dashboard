/*
  Vue : fact_payments
  Rôle : Recense tous les paiements
  Granularité : une ligne = un paiement
  Volume : Il y a 249 lignes
  */
  CREATE OR REPLACE VIEW fact_payments AS 
  
  SELECT p.checkNumber, p.customerNumber, c.salesRepEmployeeNumber AS employeeNumber, p.paymentDate, p.amount
  FROM payments AS p
  LEFT JOIN customers AS c ON p.customerNumber = c.customerNumber;
  