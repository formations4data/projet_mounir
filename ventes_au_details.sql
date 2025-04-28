CREATE DATABASE bdd_projet_vente_detail;

USE bdd_projet_vente_detail; 

CREATE TABLE ventes_détaillants
( 
   id_transaction INT,
   date_vente DATE,
   temps_vente TIME,
   id_client INT,
   sexe VARCHAR(30),
   age INT,
   categorie VARCHAR(50), 
   quantite INT,
   prix_par_unite FLOAT,
   cout_marchandise_vendu FLOAT ,
   vente_total FLOAT
);

SELECT * FROM ventes_détaillants;


-- Netoyage de la bdd
SELECT * FROM ventes_détaillants
WHERE age is null or quantite is null or prix_par_unite is null
      or cout_marchandise_vendu is null or vente_total is null;
      
-- ANALYSE EXPLOIRATOIRE 
-- 1) Nombre d'enregistrement 

SELECT COUNT(*) FROM ventes_détaillants;

-- 2 ) Les categories uniques

SELECT DISTINCT categorie FROM ventes_détaillants;

-- 3) Le CA général par toutes les ventes 

SELECT SUM(vente_total) FROM ventes_détaillants;

-- 4) CA par categorie 

SELECT categorie, SUM(vente_total) AS CA 
FROM ventes_détaillants
GROUP BY categorie
;

-- ANALYSE COMMERCIALE 

SELECT * from ventes_détaillants
WHERE id_transaction = 100;

-- Q.1 Écrire une requête SQL pour récupérer toutes les colonnes des ventes réalisées le '2022-11-05'

SELECT *
FROM ventes_détaillants
WHERE date_vente = '2022-11-05';

SELECT * FROM ventes_détaillants
WHERE quantite > 3;


-- Q.2 Écrire une requête SQL pour récupérer toutes les transactions de catégorie « Vêtements » et dont la quantité vendue est supérieure à 4 articles au mois de novembre 2022

SELECT * 
FROM ventes_détaillants
WHERE 
    categorie = 'Vetements' 
    AND quantite >= 4 
    AND DATE_FORMAT(date_vente, '%Y-%m') = '2022-11';
    
-- Q.3 Écrire une requête SQL pour calculer le total des ventes pour chaque catégorie.

SELECT 
    categorie,
    SUM(vente_total) as vente_nette, 
    COUNT(*) as total_commandes
FROM ventes_détaillants
GROUP BY 1 ;

-- Q.4 
SELECT
    ROUND(AVG(age), 2) as moyenne_age
FROM ventes_détaillants
WHERE categorie = 'Beauté';

-- Q.5 Écrire une requête SQL pour connaître toutes les transactions dont la vente_total est supérieur à 1 000.

SELECT * FROM ventes_détaillants
WHERE vente_total > 1000;

-- Q.6 Écrire une requête SQL pour connaître le nombre total de transactions (transaction_id) effectuées par sexe dans chaque catégorie.

SELECT 
    categorie,
    sexe,
    COUNT(*) as total_trans
FROM ventes_détaillants
GROUP 
    BY 
    categorie,
    sexe
ORDER BY 1;



-- Q.7 Écrire une requête SQL pour calculer le chiffre d'affaires moyen pour chaque mois. Déterminer le mois le plus vendu de chaque année

SELECT 
       année,
       mois,
       vente_moyenne
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM date_vente) as année,
    EXTRACT(MONTH FROM date_vente) as mois,
    AVG(vente_total) as vente_moyenne,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM date_vente) ORDER BY AVG(vente_total) DESC) as rang
FROM ventes_détaillants
GROUP BY 1, 2
) as t1
WHERE rang = 1;

-- Q.8 Écrire une requête SQL pour trouver les 5 meilleurs clients en fonction du total des ventes le plus élevé

SELECT 
    id_client,
    SUM(vente_total) as vente_totals
FROM ventes_détaillants
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Écrire une requête SQL pour trouver le nombre de clients uniques ayant acheté des articles de chaque catégorie.


SELECT 
    categorie,    
    COUNT(DISTINCT id_client) as cnt_unique_client
FROM ventes_détaillants
GROUP BY categorie;


-- Q.10 Écrire une requête SQL pour créer chaque équipe et le nombre de commandes (exemple : matin <= 12, après-midi entre 12 et 17, soir > 17)

WITH heure_vente
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM temps_vente) < 12 THEN 'Matin'
        WHEN EXTRACT(HOUR FROM temps_vente) BETWEEN 12 AND 17 THEN 'Après-midi'
        ELSE 'Soir'
    END as shift
FROM ventes_détaillants
)
SELECT 
    shift,
    COUNT(*) as totales_commandes    
FROM heure_vente
GROUP BY shift;

