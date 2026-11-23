/*
  Vue : dim_date
  Rôle : Sert de calendrier de référence pour analyser les commandes et les paiements par jour, mois, trimestre et année.
  Granularité : une ligne = une date
  Volume : Il y a 1 096 lignes actuellement, du 01/01/2022 au 31/12/2024.
  Choix : Les fonctions temporelles de Power BI nécessitant des années complètes, je génère donc les dates du 1er janvier
		de l'année la plus ancienne au 31 décembre de l'année la plus récente.
          `dayOfWeek` est calculé avec WEEKDAY() + 1 pour que la semaine commence le lundi (lundi = 1, dimanche = 7),
          et non avec DAYOFWEEK(), qui commence le dimanche. Il sert à trier `dayName` dans Power BI.
          `isPastDate` vaut 1 si la date est antérieure ou égale à la dernière commande, 0 sinon. Il sert à comparer
          des périodes équivalentes dans la mesure CA_n-1 (un mois en cours est comparé aux mêmes jours de l'année
          précédente) et à masquer les mois futurs.
  Prérequis : MySQL a une protection pour ne pas faire plus de 1000 tours de boucle avec un WITH RECURSIVE, ce réglage 
			permet de l'augmenter. Il faut le lancer une seule fois avant la création de la vue, et relancer ensuite la 
            connexion, sinon la session reste sur l'ancien réglage.
			SET PERSIST cte_max_recursion_depth = 10000;
*/

CREATE OR REPLACE VIEW dim_date AS

WITH RECURSIVE allDates AS (
	SELECT orderDate AS eventDate FROM orders
	UNION ALL 
	SELECT paymentDate FROM payments ),

dateBounds AS (SELECT MAKEDATE(YEAR(MIN(eventDate)), 1) AS startDate, MAKEDATE(YEAR(MAX(eventDate)) +1, 1) - INTERVAL 1 DAY AS endDate 
	FROM allDates),
    
calendar AS (
    SELECT startDate AS calendarDate                        -- point de départ
    FROM dateBounds

    UNION ALL

    SELECT calendarDate + INTERVAL 1 DAY                    -- répétition : la ligne précédente + 1 jour
    FROM calendar                                           -- l'étape s'appelle elle-même
    WHERE calendarDate < (SELECT endDate FROM dateBounds)   -- condition d'arrêt
)
SELECT calendarDate, YEAR(calendarDate) AS year, QUARTER(calendarDate) AS quarter, MONTH(calendarDate) AS month, 
MONTHNAME(calendarDate) AS monthName, DAY(calendarDate) AS dayOfMonth, DAYNAME(calendarDate) AS dayName, 
WEEKDAY(calendarDate) + 1 AS dayOfWeek, calendarDate <= (SELECT MAX(orderDate) FROM orders) AS isPastDate
FROM calendar;