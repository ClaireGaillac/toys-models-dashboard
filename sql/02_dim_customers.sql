/*
  Vue : dim_customers
  Rôle : Recense tous les clients
  Granularité : une ligne = un client
  Volume : Il y a 122 lignes.
  Choix : - `state` retiré : il est vide pour la plupart des pays, et la ville suffit à situer les clients américains.
          - `territory` ajouté : c'est le territoire du bureau du vendeur attitré du client.
          - "Japan" remplacé par "APAC" : le vendeur du bureau de Tokyo suit aussi des clients d'autres pays d'Asie-Pacifique.
          - Les clients sans vendeur, qui n'ont passé aucune commande, ont le territoire "Unassigned". Les classer à la main
            aurait été nécessaire, car certains sont dans des pays où il n'y a encore aucun client actif. Ce libellé permet
            aussi de distinguer les prospects des clients.
*/
CREATE OR REPLACE VIEW dim_customers AS

SELECT c.customerNumber, c.customerName, c.city, c.country, c.creditLimit, CASE
		WHEN o.territory = 'Japan' THEN 'APAC'
        WHEN o.territory IS NULL THEN 'Unassigned'
		ELSE o.territory
		END AS territory
FROM customers AS c
LEFT JOIN employees AS e ON c.salesRepEmployeeNumber = e.employeeNumber
LEFT JOIN offices AS o ON e.officeCode = o.officeCode;
