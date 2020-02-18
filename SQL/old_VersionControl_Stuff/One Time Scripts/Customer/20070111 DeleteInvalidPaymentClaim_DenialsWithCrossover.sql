	-- gets EOB with both a Denial and CrossOver
	SELECT 
		pc.PaymentID,
		pc.ClaimID,
		eboXML.row.value('@type','varchar(50)') Type,
		eboXML.row.value('@amount','Money') Amount,
		eboXML.row.value('@category','varchar(50)') Category,
		eboXML.row.value('@description','varchar(250)') Description
	INTO #Crossover
	FROM 
		paymentClaim pc 
			cross apply eobXML.nodes('/eob/items/item') AS eboXML(row)
	where 
		(
				( EOBXml.exist('/eob/denial[(text()[1] cast as xs:string ?) = xs:string("true") ]') = 1 )
				OR ( EOBXml.exist('/eob/items/denial[(text()[1] cast as xs:string ?) = xs:string("true") ]') = 1 )
			)
		AND (
				( EOBXml.exist('/eob/items/item[(@type cast as xs:string ?) = xs:string("Crossover") ]') = 1 )
			)
		AND (
				( EOBXml.exist('/eob/items/item[(@type cast as xs:string ?) = xs:string("Denial") ]') = 1 )
			)

	-- gets valid claims where there are other item types
	select 	distinct 
		pc.PaymentID,
		pc.ClaimID,
		eboXML.row.value('@type','varchar(50)') Type
	INTO #ValidClaim
	FROM (select distinct PaymentID, ClaimID FROM #Crossover ) c 
		INNER JOIN 	paymentClaim pc ON pc.PaymentID = c.PaymentID AND pc.ClaimID = c.ClaimID
			cross apply eobXML.nodes('/eob/items/item') AS eboXML(row)
	WHERE eboXML.row.value('@type','varchar(50)') not in ('Denial', 'Crossover')
	
	CREATE TABLE #ValidCTsExist(PaymentID INT, ClaimID INT)
	INSERT INTO #ValidCTsExist(PaymentID, ClaimID)
	SELECT DISTINCT C.PaymentID, C.ClaimID
	FROM #Crossover C INNER JOIN ClaimTransaction CT
	ON C.PaymentID=CT.PaymentID AND C.ClaimID=CT.ClaimID AND CT.ClaimTransactionTypeCode='RES'

--	-- identifies and deletes the truely invalid claims
	delete paymentClaim
	FROM (
			select c.PaymentID, c.ClaimID
			from paymentCLaim p
			INNER JOIN (select distinct PaymentID, ClaimID FROM #Crossover ) c ON p.PaymentID = c.PaymentID AND p.ClaimID = c.ClaimID
			LEFT JOIN (select distinct  PaymentID, ClaimID FROM #ValidClaim ) v On v.PaymentID = c.PaymentID AND v.ClaimID = c.ClaimID
			LEFT JOIN (select PaymentID, ClaimID FROM #ValidCTsExist) cte ON p.PaymentID=cte.PaymentID AND p.ClaimID=cte.ClaimID
			where v.ClaimID IS NULL AND cte.ClaimID IS NULL
			) as invalid
	WHERE invalid.PaymentID = paymentClaim.PaymentID AND invalid.ClaimID = paymentClaim.ClaimID

drop table #Crossover, #ValidClaim, #ValidCTsExist

