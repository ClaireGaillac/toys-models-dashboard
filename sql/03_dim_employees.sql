/*
  Vue : dim_employees
  Rôle : Recense tous les employés
  Granularité : une ligne = un employé
  Volume : Il y a 23 lignes
  Choix : - Tous les employés sont gardés, pas seulement les vendeurs : même si j'utiliserai surtout les statistiques des
            vendeurs, le volet RH serait incohérent avec une partie seulement des employés. J'ajoute donc `jobTitle`.
          - `state` retiré : il est vide pour la plupart des pays, et la ville suffit à situer les bureaux américains.
          - Pour `territory`, comme dans dim_customers : "Japan" remplacé par "APAC", car le vendeur du bureau de Tokyo
            suit aussi des clients d'autres pays d'Asie-Pacifique.
          - Pour ne pas confondre ces colonnes avec celles de dim_customers, j'ajoute le préfixe office : officeCity,
            officeCountry et officeTerritory.
*/
CREATE OR REPLACE VIEW dim_employees AS

SELECT  employeeNumber, jobTitle, CONCAT(lastName, ' ', firstName) AS fullName, e.officeCode, o.city AS officeCity, 
o.country AS officeCountry, 
	CASE
		WHEN o.territory = 'Japan' THEN 'APAC'
		ELSE o.territory
		END AS officeTerritory
FROM employees AS e 
LEFT JOIN offices AS o ON e.officeCode = o.officeCode;