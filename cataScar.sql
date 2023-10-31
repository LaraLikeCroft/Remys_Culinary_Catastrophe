USE culinaryCatastrophe
DROP TABLE IF EXISTS #cataScar

SELECT

    r.recipeName,
	r.recipeType,
    r.recipeStars,
    r.costMultiplier,
	ROUND(
		COALESCE((r.costMultiplier*i1.SellPrice),0) + 
		COALESCE((r.costMultiplier*i2.SellPrice),0) + 
		COALESCE((r.costMultiplier*i3.SellPrice),0) + 
		COALESCE((r.costMultiplier*i4.SellPrice),0) + 
		COALESCE((r.costMultiplier*i5.SellPrice),0)
		, 0) AS recipeSellPrice,



		ISNULL(i1.Sources, '') AS i1S, 
		ISNULL(i2.Sources, '') AS i2S, 
		ISNULL(i3.Sources, '') AS i3S, 
		ISNULL(i4.Sources, '') AS i4S, 
		ISNULL(i5.Sources, '') AS i5S
    
INTO #cataScar
 
FROM dbo.recipes r

    LEFT JOIN dbo.ingredients i1 ON i1.Name = r.recipeIng1
    LEFT JOIN dbo.ingredients i2 ON i2.Name = r.recipeIng2
    LEFT JOIN dbo.ingredients i3 ON i3.Name = r.recipeIng3
    LEFT JOIN dbo.ingredients i4 ON i4.Name = r.recipeIng4
    LEFT JOIN dbo.ingredients i5 ON i5.Name = r.recipeIng5
    
WHERE	ISNULL(i1.SunlitPlateau,'') = 0 AND
		ISNULL(i2.SunlitPlateau,'') = 0 AND
		ISNULL(i3.SunlitPlateau,'') = 0 AND
		ISNULL(i4.SunlitPlateau,'') = 0 AND
		ISNULL(i5.SunlitPlateau,'') = 0 AND
		ISNULL(i1.ForgottenLands,'') = 0 AND
		ISNULL(i2.ForgottenLands,'') = 0 AND
		ISNULL(i3.ForgottenLands,'') = 0 AND
		ISNULL(i4.ForgottenLands,'') = 0 AND
		ISNULL(i5.ForgottenLands,'') = 0  


SELECT a.recipeName, a.recipeType, a.recipeSellPrice
FROM #cataScar a
	
INNER JOIN(
			SELECT recipeType, MAX(recipeSellPrice) recipeSellPrice
			FROM #cataScar
			GROUP BY recipeType
			) b ON a.recipeType = b.recipeType AND a.recipeSellPrice = b.recipeSellPrice

ORDER BY CASE
	WHEN a.recipeType = 'Appetizers' THEN 1
	WHEN a.recipeType = 'Entr�es' THEN 2
	WHEN a.recipeType = 'Desserts' THEN 3
END ASC