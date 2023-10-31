USE culinaryCatastrophe
DROP TABLE IF EXISTS #cataVan

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
    
INTO #cataVan
 
FROM dbo.recipes r

    LEFT JOIN dbo.ingredients i1 ON i1.Name = r.recipeIng1
    LEFT JOIN dbo.ingredients i2 ON i2.Name = r.recipeIng2
    LEFT JOIN dbo.ingredients i3 ON i3.Name = r.recipeIng3
    LEFT JOIN dbo.ingredients i4 ON i4.Name = r.recipeIng4
    LEFT JOIN dbo.ingredients i5 ON i5.Name = r.recipeIng5
    
WHERE	i1.CookingCategory = 'Sweets' OR
		i2.CookingCategory = 'Sweets' OR
		i3.CookingCategory = 'Sweets' OR
		i4.CookingCategory = 'Sweets' OR
		i5.CookingCategory = 'Sweets'


SELECT a.recipeName, a.recipeType, a.recipeSellPrice
FROM #cataVan a
	
INNER JOIN(
			SELECT recipeType, MAX(recipeSellPrice) recipeSellPrice
			FROM #cataVan
			GROUP BY recipeType
			) b ON a.recipeType = b.recipeType AND a.recipeSellPrice = b.recipeSellPrice

ORDER BY CASE
	WHEN a.recipeType = 'Appetizers' THEN 1
	WHEN a.recipeType = 'Entrées' THEN 2
	WHEN a.recipeType = 'Desserts' THEN 3
END ASC