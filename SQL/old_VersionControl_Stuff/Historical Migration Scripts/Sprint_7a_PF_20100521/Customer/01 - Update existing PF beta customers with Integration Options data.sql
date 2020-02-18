--------------------------------------------------------------------------------------------------------------
-- Set up the customers that are already linked through our beta program

if db_name() like 'superbill_1450_%'
begin
	-- RLP Medical Billing
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='bobpedersenprac', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=1450
end

if db_name() like 'superbill_1569_%'
begin
	-- James N. Luckett
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='jamesnluckettjr', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=1569
end

if db_name() like 'superbill_1575_%'
begin
	-- ATS Healthcare
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=10, 
			@PracticeFusionID='saintthomasclin', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=1575
end

if db_name() like 'superbill_1621_%'
begin
	-- Billing Advantage
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='panr838404', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=1621

	-- Billing Advantage
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=128, 
			@PracticeFusionID='fallsneuropsych', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=1621
end

if db_name() like 'superbill_2594_%'
begin
	-- Today Clinic
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='todayclinic', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=2594
end

if db_name() like 'superbill_2913_%'
begin
	-- MARYLAND URGENT CARE
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='marylandurgentc', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=2913
end

if db_name() like 'superbill_2917_%'
begin
	-- Physician Services Inc.
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=5, 
			@PracticeFusionID='jerrellemcopela', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=2917

	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=4, 
			@PracticeFusionID='olsonmedicalcli', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=2917
end

if db_name() like 'superbill_3041_%'
begin
	-- Alzheimers Disease Center
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=2, 
			@PracticeFusionID='gastroenterolog1', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=3041
end

if db_name() like 'superbill_3184_%'
begin
	-- Alzheimers Disease Center
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='anilnair16', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=3184
end

if db_name() like 'superbill_3190_%'
begin
	-- JMJ Psychological Services
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='maxinecampbellf', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=3190
end


if db_name() like 'superbill_3191_%'
begin
	-- Sangeetha Murthy Inc
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='sangeethamurthy7', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=3191
end

if db_name() like 'superbill_3196_%'
begin
	-- Dr. Doan
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='domdoanpractice', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=3196
end

if db_name() like 'superbill_3197_%'
begin
	-- Muir Integrative Health
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='muirintegrative', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=3197
end

if db_name() like 'superbill_3202_%'
begin
	-- Alla Kirsch MD
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='ALLAKIRSCHMDLLC', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=3202
end

if db_name() like 'superbill_3207_%'
begin
	-- Spinal Care Chiropractic
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='spinalcarechiro', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=3207
end

if db_name() like 'superbill_3215_%'
begin
	-- Family Practice * House Calls, P.A.
	EXEC PracticeDataProvider_UpdatePracticeIntegrationInfo 
			@PracticeID=1, 
			@PracticeFusionID='familypracticeh', 
			@PracticeFusionStatus='C', 
			@UserID=1, 
			@CustomerID=3215
end
