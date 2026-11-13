/*
  Vue : dim_products
  Rôle : Recense tous les articles
  Granularité : une ligne = une référence article
  Volume : Il y a 110 lignes
  Choix : - `productScale` (échelle des miniatures) non retenu : aucune analyse n'est prévue par échelle.
          - `MSRP` gardé tel quel : c'est un sigle connu (prix de vente conseillé) et le nom d'origine de la colonne,
            ce qui facilite la traçabilité. Il sera renommé à l'affichage dans Power BI.
  Limite : Le stock n'est associé à aucune date : c'est une photo du stock actuel, sans historique. Impossible de savoir ni 
		   quand les produits ont été réapprovisionnés, ni à quel moment ils ont été en rupture.
           Faute de mieux, je reconstitue un stock théorique à une date passée : stock actuel + quantités vendues
           depuis cette date. Cette reconstitution suppose qu'il n'y a eu aucun réapprovisionnement sur la période :
           elle sert d'estimation, pas de valeur exacte.
*/
CREATE OR REPLACE VIEW dim_products AS 

SELECT productCode, productName, productLine, productVendor, quantityInStock, buyPrice, MSRP
FROM products;