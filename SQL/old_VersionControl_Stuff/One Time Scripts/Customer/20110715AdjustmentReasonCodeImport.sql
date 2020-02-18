-- Adjustment Reasons import script
-- codes taken from here: http://www.wpc-edi.com/content/view/695/1

CREATE TABLE #adj (code VARCHAR(16), descr VARCHAR(max))

--INSERT INTO #adj (code, descr) VALUES ('', '')
INSERT INTO #adj (code, descr) VALUES ('205', 'Pharmacy discount card processing fee')
INSERT INTO #adj (code, descr) VALUES ('206', 'National Provider Identifier - missing.')
INSERT INTO #adj (code, descr) VALUES ('207', 'National Provider identifier - Invalid format')
INSERT INTO #adj (code, descr) VALUES ('208', 'National Provider Identifier - Not matched.')
INSERT INTO #adj (code, descr) VALUES ('209', 'Per regulatory or other agreement. The provider cannot collect this amount from the patient. However, this amount may be billed to subsequent payer. Refund to patient if collected. (Use Group code OA)')
INSERT INTO #adj (code, descr) VALUES ('210', 'Payment adjusted because pre-certification/authorization not received in a timely fashion')
INSERT INTO #adj (code, descr) VALUES ('211', 'National Drug Codes (NDC) not eligible for rebate, are not covered.')
INSERT INTO #adj (code, descr) VALUES ('212', 'Administrative surcharges are not covered')
INSERT INTO #adj (code, descr) VALUES ('213', 'Non-compliance with the physician self referral prohibition legislation or payer policy.')
INSERT INTO #adj (code, descr) VALUES ('214', 'Workers Compensation claim adjudicated as non-compensable. This Payer not liable for claim or service/treatment. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop 2100 Other Claim Related Information REF qualifier "IG") for the jurisdictional regulation. If adjustment is at the Line Level, the payer must send and the provider should refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment information REF). To be used for Workers Compensation only')
INSERT INTO #adj (code, descr) VALUES ('215', 'Based on subrogation of a third party settlement')
INSERT INTO #adj (code, descr) VALUES ('216', 'Based on the findings of a review organization')
INSERT INTO #adj (code, descr) VALUES ('217', 'Based on payer reasonable and customary fees. No maximum allowable defined by legislated fee arrangement. (Note: To be used for Workers Compensation only)')
INSERT INTO #adj (code, descr) VALUES ('218', 'Based on entitlement to benefits. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop 2100 Other Claim Related Information REF qualifier "IG") for the jurisdictional regulation. If adjustment is at the Line Level, the payer must send and the provider should refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment information REF). To be used for Workers Compensation only')
INSERT INTO #adj (code, descr) VALUES ('219', 'Based on extent of injury. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop 2100 Other Claim Related Information REF qualifier "IG") for the jurisdictional regulation. If adjustment is at the Line Level, the payer must send and the provider should refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment information REF).')
INSERT INTO #adj (code, descr) VALUES ('220', 'The applicable fee schedule does not contain the billed code. Please resubmit a bill with the appropriate fee schedule code(s) that best describe the service(s) provided and supporting documentation if required. (Note: To be used for Workers Compensation only)')
INSERT INTO #adj (code, descr) VALUES ('221', 'Workers Compensation claim is under investigation. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop 2100 Other Claim Related Information REF qualifier "IG") for the jurisdictional regulation. If adjustment is at the Line Level, the payer must send and the provider should refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment information REF).')
INSERT INTO #adj (code, descr) VALUES ('222', 'Exceeds the contracted maximum number of hours/days/units by this provider for this period. This is not patient specific. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.')
INSERT INTO #adj (code, descr) VALUES ('223', 'Adjustment code for mandated federal, state or local law/regulation that is not already covered by another code and is mandated before a new code can be created.')
INSERT INTO #adj (code, descr) VALUES ('224', 'Patient identification compromised by identity theft. Identity verification required for processing this and future claims.')
INSERT INTO #adj (code, descr) VALUES ('225', 'Penalty or Interest Payment by Payer (Only used for plan to plan encounter reporting within the 837)')
INSERT INTO #adj (code, descr) VALUES ('226', 'Information requested from the Billing/Rendering Provider was not provided or was insufficient/incomplete. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)')
INSERT INTO #adj (code, descr) VALUES ('227', 'Information requested from the patient/insured/responsible party was not provided or was insufficient/incomplete. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)')
INSERT INTO #adj (code, descr) VALUES ('228', 'Denied for failure of this provider, another provider or the subscriber to supply requested information to a previous payer for their adjudication')
INSERT INTO #adj (code, descr) VALUES ('229', 'Partial charge amount not considered by Medicare due to the initial claim Type of Bill being 12X. Note: This code can only be used in the 837 transaction to convey Coordination of Benefits information when the secondary payers cost avoidance policy allows providers to bypass claim submission to a prior payer. Use Group Code PR.')
INSERT INTO #adj (code, descr) VALUES ('230', 'No available or correlating CPT/HCPCS code to describe this service. Note: Used only by Property and Casualty.')
INSERT INTO #adj (code, descr) VALUES ('231', 'Mutually exclusive procedures cannot be done in the same day/setting. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.')
INSERT INTO #adj (code, descr) VALUES ('232', 'Institutional Transfer Amount. Note - Applies to institutional claims only and explains the DRG amount difference when the patient care crosses multiple institutions.')
INSERT INTO #adj (code, descr) VALUES ('233', 'Services/charges related to the treatment of a hospital-acquired condition or preventable medical error.')
INSERT INTO #adj (code, descr) VALUES ('234', 'This procedure is not paid separately. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)')
INSERT INTO #adj (code, descr) VALUES ('235', 'Sales Tax')
INSERT INTO #adj (code, descr) VALUES ('236', 'This procedure or procedure/modifier combination is not compatible with another procedure or procedure/modifier combination provided on the same day according to the National Correct Coding Initiative.')
INSERT INTO #adj (code, descr) VALUES ('237', 'Legislated/Regulatory Penalty. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)')

INSERT INTO #adj (code, descr) VALUES ('D22', 'Reimbursement was adjusted for the reasons to be provided in separate correspondence. (Note: To be used for Workers Compensation only) - Temporary code to be added for timeframe only until 01/01/2009. Another code to be established and/or for 06/2008 meeting for a revised code to replace or strategy to use another existing code')
INSERT INTO #adj (code, descr) VALUES ('D23', 'This dual eligible patient is covered by Medicare Part D per Medicare Retro-Eligibility. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)')

INSERT INTO #adj (code, descr) VALUES ('W2', 'Payment reduced or denied based on workers compensation jurisdictional regulations or payment policies, use only if no other code is applicable. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop 2100 Other Claim Related Information REF qualifier "IG") for the jurisdictional regulation. If adjustment is at the Line Level, the payer must send and the provider should refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment information REF). To be used for Workers Compensation only.')




INSERT INTO dbo.AdjustmentReason
        ( AdjustmentReasonCode ,
          [Description]
        )
        
SELECT   code , -- AdjustmentReasonCode - varchar(5)
		 LEFT(descr, 250) -- Description - varchar(250)
        
FROM #adj
WHERE #adj.code NOT IN (SELECT AdjustmentReasonCode FROM dbo.AdjustmentReason)
ORDER BY code

DROP TABLE #adj