update printingformdetails 
set svgdefinition = '<?xml version="1.0" standalone="yes"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" printerAffinity="hcfa" formId="CMS1500" pageId="CMS1500.1" width="8.5in" height="11in" topOffset="0.0in" leftOffset="0.0in" dpi="200">
  <defs>
    <style type="text/css"><![CDATA[
		
		g {
			font-family: Courier New;
			font-size: 10pt;
			font-style: normal;
			font-weight: bold;
			alignment-baseline: text-before-edge;
		}
		
		text
		{
			baseline-shift: -100%;
		}
		
		text.money
		{
			text-anchor: end;
		}
		
		text.smaller
		{
			font-size: 9pt;
		}
		
	    	]]></style>
  </defs>

  <g id="carrier">
    <text x="4.04in" y="0.28in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierName" />
    <text x="4.04in" y="0.44in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierStreet" />
    <text x="4.04in" y="0.6in" width="4.10in" height="0.1in" valueSource="CMS1500.1.CarrierCityStateZip" />
  </g>
  <g id="line1">
    <text x="0.31in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicare" />
    <text x="1in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Medicaid" />
    <text x="1.71in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champus" />
    <text x="2.59in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Champva" />
    <text x="3.28in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_GroupHealthPlan" />
    <text x="4.09in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Feca" />
    <text x="4.7in" y="1.39in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_Other" />
    <text x="5.19in" y="1.38in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_aIDNumber" />
  </g>
  <g id="line2">
    <text x="0.31in" y="1.71in" width="2.79in" height="0.1in" valueSource="CMS1500.1.2_PatientName" />
    <text x="3.27in" y="1.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_MM" />
    <text x="3.58in" y="1.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.3_DD" />
    <text x="3.86in" y="1.72in" width="0.6in" height="0.1in" valueSource="CMS1500.1.3_YY" />
    <text x="4.39in" y="1.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_M" />
    <text x="4.9in" y="1.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.3_F" />
    <text x="5.19in" y="1.72in" width="2.93in" height="0.1in" valueSource="CMS1500.1.4_InsuredName" />
  </g>
  <g id="line3">
    <text x="0.31in" y="2.04in" width="2.79in" height="0.1in" valueSource="CMS1500.1.5_PatientAddress" />
    <text x="3.48in" y="2.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Self" />
    <text x="3.99in" y="2.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Spouse" />
    <text x="4.39in" y="2.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Child" />
    <text x="4.9in" y="2.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.6_Other" />
    <text x="5.19in" y="2.04in" width="2.93in" height="0.1in" valueSource="CMS1500.1.7_InsuredAddress" />
  </g>
  <g id="line4">
    <text x="0.31in" y="2.38in" width="2.42in" height="0.1in" valueSource="CMS1500.1.5_City" />
    <text x="2.84in" y="2.38in" width="0.3in" height="0.1in" valueSource="CMS1500.1.5_State" />
    <text x="5.19in" y="2.38in" width="2.28in" height="0.1in" valueSource="CMS1500.1.7_City" />
    <text x="7.54in" y="2.38in" width="0.3in" height="0.1in" valueSource="CMS1500.1.7_State" />
  </g>
  <g id="box8">
    <text x="3.69in" y="2.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Single" />
    <text x="4.28in" y="2.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Married" />
    <text x="4.89in" y="2.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Other" />
    <text x="3.69in" y="2.68in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_Employed" />
    <text x="4.28in" y="2.68in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_FTStud" />
    <text x="4.89in" y="2.68in" width="0.09in" height="0.1in" valueSource="CMS1500.1.8_PTStud" />
  </g>
  <g id="line5">
    <text x="0.31in" y="2.7in" width="1.19in" height="0.1in" valueSource="CMS1500.1.5_Zip" />
    <text x="1.69in" y="2.7in" width="0.4in" height="0.1in" valueSource="CMS1500.1.5_Area" />
    <text x="2.08in" y="2.7in" width="1.1in" height="0.1in" valueSource="CMS1500.1.5_Phone" />
    <text x="5.19in" y="2.7in" width="1.23in" height="0.1in" valueSource="CMS1500.1.7_Zip" />
    <text x="6.67in" y="2.7in" width="0.4in" height="0.1in" valueSource="CMS1500.1.7_Area" />
    <text x="7.1in" y="2.7in" width="1.1in" height="0.1in" valueSource="CMS1500.1.7_Phone" />
  </g>
  <g id="line6">
    <text x="0.31in" y="3.03in" width="2.42in" height="0.1in" valueSource="CMS1500.1.9_OtherName" />
    <text x="5.19in" y="3.03in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1GroupNumber" />
  </g>
  <g id="box10">
    <text x="3.69in" y="3.36in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aYes" />
    <text x="4.29in" y="3.36in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0aNo" />
    <text x="3.69in" y="3.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bYes" />
    <text x="4.29in" y="3.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0bNo" />
    <text x="4.75in" y="3.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_0bState" />
    <text x="3.69in" y="4.03in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cYes" />
    <text x="4.29in" y="4.03in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_0cNo" />
  </g>
  <g id="line7">
    <text x="0.31in" y="3.38in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_aGrpNumber" />
    <text x="5.57in" y="3.38in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aMM" />
    <text x="5.88in" y="3.38in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_1aDD" />
    <text x="6.17in" y="3.38in" width="0.6in" height="0.1in" valueSource="CMS1500.1.1_1aYY" />
    <text x="6.98in" y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aM" />
    <text x="7.7in" y="3.38in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1aF" />
  </g>
  <g id="line8">
    <text x="0.39in" y="3.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bMM" />
    <text x="0.69in" y="3.72in" width="0.3in" height="0.1in" valueSource="CMS1500.1.9_bDD" />
    <text x="0.98in" y="3.72in" width="0.6in" height="0.1in" valueSource="CMS1500.1.9_bYYYY" />
    <text x="1.99in" y="3.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bM" />
    <text x="2.59in" y="3.72in" width="0.09in" height="0.1in" valueSource="CMS1500.1.9_bF" />
    <text x="5.19in" y="3.72in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1bEmployer" />
  </g>
  <g id="line9">
    <text x="0.31in" y="4.03in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_cEmployer" />
    <text x="5.19in" y="4.03in" width="2.93in" height="0.1in" valueSource="CMS1500.1.1_1cPlanName" />
  </g>
  <g id="line10">
    <text x="0.31in" y="4.37in" width="2.79in" height="0.1in" valueSource="CMS1500.1.9_dPlanName" />
    <text x="3.18in" y="4.37in" width="1.85in" height="0.1in" valueSource="CMS1500.1.1_0dLocal" />
    <text x="5.38in" y="4.37in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dYes" />
    <text x="5.88in" y="4.37in" width="0.09in" height="0.1in" valueSource="CMS1500.1.1_1dNo" />
  </g>
  <g id="line11">
    <text x="0.79in" y="5.03in" width="2.2in" height="0.1in" valueSource="CMS1500.1.1_2Signature" />
    <text x="3.79in" y="5.03in" width="1.3in" height="0.1in" valueSource="CMS1500.1.1_2Date" />
    <text x="5.84in" y="5.03in" width="2in" height="0.1in" valueSource="CMS1500.1.1_3Signature" />
  </g>
  <g id="line12">
    <text x="0.41in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4MM" />
    <text x="0.72in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4DD" />
    <text x="1.02in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_4YY" />
    <text x="3.92in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5MM" />
    <text x="4.23in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5DD" />
    <text x="4.5in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_5YY" />
    <text x="5.58in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartMM" />
    <text x="5.87in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartDD" />
    <text x="6.18in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6StartYY" />
    <text x="6.99in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndMM" />
    <text x="7.31in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndDD" />
    <text x="7.6in" y="5.39in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_6EndYY" />
  </g>
  <g id="line13">
    <text x="0.31in" y="5.7in" width="2.61in" height="0.1in" valueSource="CMS1500.1.1_7Referring" />
    <text x="3.17in" y="5.7in" width="1.92in" height="0.1in" valueSource="CMS1500.1.1_7aID" />
    <text x="5.58in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartMM" />
    <text x="5.87in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartDD" />
    <text x="6.19in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8StartYY" />
    <text x="6.99in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndMM" />
    <text x="7.31in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndDD" />
    <text x="7.6in" y="5.7in" width="0.3in" height="0.1in" valueSource="CMS1500.1.1_8EndYY" />
  </g>
  <g id="line14">
    <text x="0.31in" y="6.04in" width="4.78in" height="0.1in" valueSource="CMS1500.1.1_9Local" />
    <text x="5.37in" y="6.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0Yes" />
    <text x="5.88in" y="6.04in" width="0.09in" height="0.1in" valueSource="CMS1500.1.2_0No" />
    <text x="6.55in" y="6.04in" width="0.8in" height="0.1in" valueSource="CMS1500.1.2_0Dollars" class="money" />
    <text x="7.32in" y="6.04in" width="0.3in" height="0.1in" valueSource="CMS1500.1.2_0Cents" />
  </g>
  <g id="box21">
    <text x="0.49in" y="6.43in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag1" />
    <text x="0.49in" y="6.74in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag2" />
    <text x="3.23in" y="6.43in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag3" />
    <text x="3.23in" y="6.74in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_1Diag4" />
  </g>
  <g id="line15">
    <text x="5.19in" y="6.38in" width="1.1in" height="0.1in" valueSource="CMS1500.1.2_2Code" />
    <text x="6.31in" y="6.38in" width="1.86in" height="0.1in" valueSource="CMS1500.1.2_2Number" />
  </g>
  <g id="line16">
    <text x="5.19in" y="6.69in" width="2.93in" height="0.1in" valueSource="CMS1500.1.2_3PriorAuth" />
  </g>
  <g id="box24_1">
    <text x="0.31in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM1" />
    <text x="0.62in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD1" />
    <text x="0.94in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY1" />
    <text x="1.2in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM1" />
    <text x="1.5in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD1" />
    <text x="1.82in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY1" />
    <text x="2.11in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS1" />
    <text x="2.38in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS1" />
    <text x="2.74in" y="7.34in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT1" />
    <text x="3.4in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier1" />
    <text x="3.71in" y="7.34in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra1" />
    <text x="4.44in" y="7.34in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag1" />
    <text x="5.25in" y="7.34in" width="0.52in" height="0.1in" valueSource="CMS1500.1.fDollars1" class="money" />
    <text x="5.77in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents1" />
    <text x="6.07in" y="7.34in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits1" />
    <text x="6.41in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT1" />
    <text x="6.69in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG1" />
    <text x="6.99in" y="7.34in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB1" />
    <text x="7.27in" y="7.34in" width="1in" height="0.1in" valueSource="CMS1500.1.kLocal1" class="smaller" />
  </g>
  <g id="box24_2">
    <text x="0.31in" y="7.64in" width="0.3in" height="0.11in" valueSource="CMS1500.1.aStartMM2" />
    <text x="0.62in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD2" />
    <text x="0.94in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY2" />
    <text x="1.2in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM2" />
    <text x="1.5in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD2" />
    <text x="1.82in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY2" />
    <text x="2.11in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS2" />
    <text x="2.38in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS2" />
    <text x="2.74in" y="7.64in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT2" />
    <text x="3.4in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier2" />
    <text x="3.71in" y="7.64in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra2" />
    <text x="4.44in" y="7.64in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag2" />
    <text x="5.25in" y="7.64in" width="0.52in" height="0.1in" valueSource="CMS1500.1.fDollars2" class="money" />
    <text x="5.77in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents2" />
    <text x="6.07in" y="7.64in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits2" />
    <text x="6.41in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT2" />
    <text x="6.69in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG2" />
    <text x="6.99in" y="7.64in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB2" />
    <text x="7.27in" y="7.64in" width="1in" height="0.1in" valueSource="CMS1500.1.kLocal2" class="smaller" />
  </g>
  <g id="box24_3">
    <text x="0.31in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM3" />
    <text x="0.62in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD3" />
    <text x="0.94in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY3" />
    <text x="1.2in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM3" />
    <text x="1.5in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD3" />
    <text x="1.82in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY3" />
    <text x="2.11in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS3" />
    <text x="2.38in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS3" />
    <text x="2.74in" y="7.98in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT3" />
    <text x="3.4in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier3" />
    <text x="3.71in" y="7.98in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra3" />
    <text x="4.44in" y="7.98in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag3" />
    <text x="5.25in" y="7.98in" width="0.52in" height="0.1in" valueSource="CMS1500.1.fDollars3" class="money" />
    <text x="5.77in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents3" />
    <text x="6.07in" y="7.98in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits3" />
    <text x="6.41in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT3" />
    <text x="6.69in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG3" />
    <text x="6.99in" y="7.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB3" />
    <text x="7.27in" y="7.98in" width="1in" height="0.1in" valueSource="CMS1500.1.kLocal3" class="smaller" />
  </g>
  <g id="box24_4">
    <text x="0.31in" y="8.31in" width="0.3in" height="0.11in" valueSource="CMS1500.1.aStartMM4" />
    <text x="0.62in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD4" />
    <text x="0.94in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY4" />
    <text x="1.2in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM4" />
    <text x="1.5in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD4" />
    <text x="1.82in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY4" />
    <text x="2.11in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS4" />
    <text x="2.38in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS4" />
    <text x="2.74in" y="8.31in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT4" />
    <text x="3.4in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier4" />
    <text x="3.71in" y="8.31in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra4" />
    <text x="4.44in" y="8.31in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag4" />
    <text x="5.25in" y="8.31in" width="0.52in" height="0.1in" valueSource="CMS1500.1.fDollars4" class="money" />
    <text x="5.77in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents4" />
    <text x="6.07in" y="8.31in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits4" />
    <text x="6.41in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT4" />
    <text x="6.69in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG4" />
    <text x="6.99in" y="8.31in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB4" />
    <text x="7.27in" y="8.31in" width="1in" height="0.1in" valueSource="CMS1500.1.kLocal4" class="smaller" />
  </g>
  <g id="box24_5">
    <text x="0.31in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM5" />
    <text x="0.62in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD5" />
    <text x="0.94in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY5" />
    <text x="1.2in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM5" />
    <text x="1.5in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD5" />
    <text x="1.82in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY5" />
    <text x="2.11in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS5" />
    <text x="2.38in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS5" />
    <text x="2.74in" y="8.65in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT5" />
    <text x="3.4in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier5" />
    <text x="3.71in" y="8.65in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra5" />
    <text x="4.44in" y="8.65in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag5" />
    <text x="5.25in" y="8.65in" width="0.52in" height="0.1in" valueSource="CMS1500.1.fDollars5" class="money" />
    <text x="5.77in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents5" />
    <text x="6.07in" y="8.65in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits5" />
    <text x="6.41in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT5" />
    <text x="6.69in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG5" />
    <text x="6.99in" y="8.65in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB5" />
    <text x="7.27in" y="8.65in" width="1in" height="0.1in" valueSource="CMS1500.1.kLocal5" class="smaller"/>
  </g>
  <g id="box24_6">
    <text x="0.31in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartMM6" />
    <text x="0.62in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartDD6" />
    <text x="0.94in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aStartYY6" />
    <text x="1.2in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndMM6" />
    <text x="1.5in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndDD6" />
    <text x="1.82in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.aEndYY6" />
    <text x="2.11in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.bPOS6" />
    <text x="2.38in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.cTOS6" />
    <text x="2.74in" y="8.98in" width="0.7in" height="0.1in" valueSource="CMS1500.1.dCPT6" />
    <text x="3.4in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.dModifier6" />
    <text x="3.71in" y="8.98in" width="0.6in" height="0.1in" valueSource="CMS1500.1.dExtra6" />
    <text x="4.44in" y="8.98in" width="0.7in" height="0.1in" valueSource="CMS1500.1.eDiag6" />
    <text x="5.25in" y="8.98in" width="0.52in" height="0.1in" valueSource="CMS1500.1.fDollars6" class="money" />
    <text x="5.77in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.fCents6" />
    <text x="6.07in" y="8.98in" width="0.33in" height="0.1in" valueSource="CMS1500.1.gUnits6" />
    <text x="6.41in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.hEPSDT6" />
    <text x="6.69in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.iEMG6" />
    <text x="6.99in" y="8.98in" width="0.3in" height="0.1in" valueSource="CMS1500.1.jCOB6" />
    <text x="7.27in" y="8.98in" width="1in" height="0.1in" valueSource="CMS1500.1.kLocal6" class="smaller" />
  </g>
  <g id="line17">
    <text x="0.37in" y="9.37in" width="1.31in" height="0.1in" valueSource="CMS1500.1.2_5ID" />
    <text x="1.9in" y="9.37in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5SSN" />
    <text x="2.09in" y="9.37in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_5EIN" />
    <text x="2.45in" y="9.37in" width="1.41in" height="0.1in" valueSource="CMS1500.1.2_6Account" />
    <text x="3.97in" y="9.37in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7Yes" />
    <text x="4.47in" y="9.37in" width="0.1in" height="0.1in" valueSource="CMS1500.1.2_7No" />
    <text x="5.29in" y="9.37in" width="0.7in" height="0.1in" valueSource="CMS1500.1.2_8Dollars" class="money"/>
    <text x="5.98in" y="9.37in" width="0.33in" height="0.1in" valueSource="CMS1500.1.2_8Cents" />
    <text x="6.39in" y="9.37in" width="0.60in" height="0.1in" valueSource="CMS1500.1.2_9Dollars" class="money" />
    <text x="6.97in" y="9.37in" width="0.33in" height="0.1in" valueSource="CMS1500.1.2_9Cents" />
    <text x="7.34in" y="9.37in" width="0.58in" height="0.1in" valueSource="CMS1500.1.3_0Dollars" class="money" />
    <text x="7.9in" y="9.37in" width="0.33in" height="0.1in" valueSource="CMS1500.1.3_0Cents" />
  </g>
  <g id="box31">
    <text x="0.37in" y="9.95in" width="1.7in" height="0.1in" valueSource="CMS1500.1.3_1Signature" />
    <text x="0.37in" y="10.10in" width="1.7in" height="0.1in" valueSource="CMS1500.1.3_1ProviderName" />
    <text x="1.49in" y="10.23in" width="1.0in" height="0.1in" valueSource="CMS1500.1.3_1Date" class="smaller"/>
  </g>
  <g id="box32">
    <text x="2.46in" y="9.77in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Name" />
    <text x="2.46in" y="9.93in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2Street" />
    <text x="2.46in" y="10.09in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2CityStateZip" />
    <text x="2.46in" y="10.25in" width="2.68in" height="0.1in" valueSource="CMS1500.1.3_2FacilityInfo" />
  </g>
  <g id="box33">
    <text x="5.89in" y="9.65in" width="2.30in" height="0.1in" valueSource="CMS1500.1.3_3Name" />
    <text x="5.2in" y="9.77in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Street" />
    <text x="5.2in" y="9.93in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3CityStateZip" />
    <text x="5.2in" y="10.09in" width="2.98in" height="0.1in" valueSource="CMS1500.1.3_3Phone" />
    <text x="5.38in" y="10.25in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3PIN" />
    <text x="6.86in" y="10.25in" width="1.1in" height="0.1in" valueSource="CMS1500.1.3_3GRP" />
  </g>
</svg>' 
where printingformdetailsid = 1

-- Update the transform to support new box 31 for HCFA
UPDATE	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid"></data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
							</xsl:if>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
						<xsl:text>NONE</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local"> </data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No">X</data>
			<data id="CMS1500.1.2_0Dollars">      0</data>
			<data id="CMS1500.1.2_0Cents">.00</data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes">X</data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityInfo1'']" />
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>
			
			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>

			
			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
			</data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
			</data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
			</data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
			</data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
			</data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
			</data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	BillingFormID = 1

-- Update the transform to support new box 31 for HCFA (Medicaid of Ohio)
UPDATE	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM"></data>
			<data id="CMS1500.1.3_DD"></data>
			<data id="CMS1500.1.3_YY"></data>
			<data id="CMS1500.1.3_M"></data>
			<data id="CMS1500.1.3_F"></data>
			<data id="CMS1500.1.4_InsuredName"></data>
			<data id="CMS1500.1.5_PatientAddress"></data>
			<data id="CMS1500.1.5_City"></data>
			<data id="CMS1500.1.5_State"></data>
			<data id="CMS1500.1.5_Zip"></data>
			<data id="CMS1500.1.5_Area"></data>
			<data id="CMS1500.1.5_Phone"></data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress"></data>
			<data id="CMS1500.1.7_City"></data>
			<data id="CMS1500.1.7_State"></data>
			<data id="CMS1500.1.7_Zip"></data>
			<data id="CMS1500.1.7_Area"></data>
			<data id="CMS1500.1.7_Phone"></data>
			<data id="CMS1500.1.8_Single"></data>
			<data id="CMS1500.1.8_Married"></data>
			<data id="CMS1500.1.8_Other"></data>
			<data id="CMS1500.1.8_Employed"></data>
			<data id="CMS1500.1.8_FTStud"></data>
			<data id="CMS1500.1.8_PTStud"></data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"></data>
			<data id="CMS1500.1.1_1GroupNumber"></data>
			<data id="CMS1500.1.1_1aMM"></data>
			<data id="CMS1500.1.1_1aDD"></data>
			<data id="CMS1500.1.1_1aYY"></data>
			<data id="CMS1500.1.1_1aM"></data>
			<data id="CMS1500.1.1_1aF"></data>
			<data id="CMS1500.1.1_1bEmployer"></data>
			<data id="CMS1500.1.1_1cPlanName"></data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature"></data>
			<data id="CMS1500.1.1_2Date"></data>
			<data id="CMS1500.1.1_3Signature"></data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"></data>
			<data id="CMS1500.1.1_5DD"></data>
			<data id="CMS1500.1.1_5YY"></data>
			<data id="CMS1500.1.1_6StartMM"></data>
			<data id="CMS1500.1.1_6StartDD"></data>
			<data id="CMS1500.1.1_6StartYY"></data>
			<data id="CMS1500.1.1_6EndMM"></data>
			<data id="CMS1500.1.1_6EndDD"></data>
			<data id="CMS1500.1.1_6EndYY"></data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ReferringProviderIDNumber1'']) &lt; 1">
						<xsl:text>9111115</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_8StartMM"></data>
			<data id="CMS1500.1.1_8StartDD"></data>
			<data id="CMS1500.1.1_8StartYY"></data>
			<data id="CMS1500.1.1_8EndMM"></data>
			<data id="CMS1500.1.1_8EndDD"></data>
			<data id="CMS1500.1.1_8EndYY"></data>
			<data id="CMS1500.1.1_9Local"> </data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No"> </data>
			<data id="CMS1500.1.2_0Dollars">       </data>
			<data id="CMS1500.1.2_0Cents"> </data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID"></data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN"> </data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes"> </data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Address"></data>
			<data id="CMS1500.1.3_3Name">
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderPrefix1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderPrefix1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderMiddleName1'']) > 0">
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderMiddleName1'']" />
					<xsl:text xml:space="preserve"> </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text xml:space="preserve"> </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1"></data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1"></data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2"></data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2"></data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3"></data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3"></data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4"></data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4"></data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5"></data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5"></data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6"></data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6"></data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6"></data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	BillingFormID = 2

-- Update the transform to support new box 31 for HCFA (Medicaid of Michigan)
UPDATE	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid">X</data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
						<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
						</xsl:if>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
						<xsl:text xml:space="preserve"> </xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>SAME</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
						<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>SAME</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
								<xsl:text>-</xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="OtherSubscriberEmployerName" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="PatientEmployerName" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text xml:space="preserve"> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
						<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ReferringProviderIDNumber1'']) &lt; 1">
						<xsl:text>9111115</xsl:text>
					</xsl:when>
					<xsl:otherwise>		 
						<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderIDNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>			
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local"> </data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No"> </data>
			<data id="CMS1500.1.2_0Dollars"> </data>
			<data id="CMS1500.1.2_0Cents"> </data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes"> </data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text xml:space="preserve">  </xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text></xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityInfo1'']" />
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
			</data>
			<data id="CMS1500.1.aStartYY1">
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate1'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD1">
			</data>
			<data id="CMS1500.1.aEndYY1">
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1"> </data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
			</data>
			<data id="CMS1500.1.aStartYY2">
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate2'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD2">
			</data>
			<data id="CMS1500.1.aEndYY2">
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2"> </data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
			</data>
			<data id="CMS1500.1.aStartYY3">
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate3'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD3">
			</data>
			<data id="CMS1500.1.aEndYY3">
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3"> </data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
			</data>
			<data id="CMS1500.1.aStartYY4">
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate4'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD4">
			</data>
			<data id="CMS1500.1.aEndYY4">
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4"> </data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
			</data>
			<data id="CMS1500.1.aStartYY5">
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate5'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD5">
			</data>
			<data id="CMS1500.1.aEndYY5">
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5"> </data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
			</data>
			<data id="CMS1500.1.aStartYY6">
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.ServiceEndDate6'']) > 0">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.aEndDD6">
			</data>
			<data id="CMS1500.1.aEndYY6">
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
				</xsl:if>
				<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''  '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="translate(format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format''),''.0'','''')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6"> </data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	BillingFormID = 3

-- Update the transform to support new box 31 for HCFA (Medicaid of Florida)
UPDATE	BillingForm
SET	Transform = '<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" />
	<xsl:decimal-format name="default-format" NaN="0.00" />

	<xsl:template match="/formData/page">

		<formData formId="CMS1500"><page pageId="CMS1500.1">
			<BillID>
				<xsl:value-of select="data[@id=''CMS1500.1.BillID1'']" />
			</BillID>
			<data id="CMS1500.1.1_Medicare"></data>
			<data id="CMS1500.1.1_Medicaid"></data>
			<data id="CMS1500.1.1_Champus"></data>
			<data id="CMS1500.1.1_Champva"></data>
			<data id="CMS1500.1.1_GroupHealthPlan"></data>
			<data id="CMS1500.1.1_Feca"></data>
			<data id="CMS1500.1.1_Other"></data>
			<data id="CMS1500.1.1_aIDNumber">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PolicyNumber1'']) > 0">
						<xsl:value-of select="data[@id=''CMS1500.1.PolicyNumber1'']" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.DependentPolicyNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.2_PatientName">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
			</data>
			<data id="CMS1500.1.3_MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.3_DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.3_YY">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_M">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.3_F">
				<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>	
			</data>
			<data id="CMS1500.1.4_InsuredName">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberMiddleName1''], 1, 1)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
							<xsl:text xml:space="preserve"> </xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_PatientAddress">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.5_City">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />	
			</data>
			<data id="CMS1500.1.5_State">
				<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />	
			</data>
			<data id="CMS1500.1.5_Zip">
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.5_Area">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />	
			</data>
			<data id="CMS1500.1.5_Phone">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.6_Self">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Spouse">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''U''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Child">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''C''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.6_Other">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:if test="data[@id=''CMS1500.1.PatientRelationshipToSubscriber1''] = ''O''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_InsuredAddress">
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.SubscriberStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.SubscriberStreet21'']" />
							</xsl:if>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text>SAME</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet11'']" />
							<xsl:if test="string-length(data[@id=''CMS1500.1.PatientStreet21'']) > 0">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientStreet21'']" />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_City"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberCity1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientCity1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_State"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberState1'']" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientState1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Zip"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.SubscriberZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.SubscriberZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string-length(data[@id=''CMS1500.1.PatientZip1'']) = 9">
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 1, 5)" />
									<xsl:text>-</xsl:text>
									<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientZip1''], 6, 4)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientZip1'']" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Area"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 1, 3)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 1, 3)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.7_Phone"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberPhone1''], 7, 4)" />
						</xsl:when>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''0'' and data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M''">
							<xsl:text xml:space="preserve"> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 4, 3)" />
							<xsl:text>-</xsl:text>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientPhone1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.8_Single"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Married"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] = ''M''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Other"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''M'' and data[@id=''CMS1500.1.PatientMaritalStatus1''] != ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_Employed"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''E''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_FTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''S''">X</xsl:if>
			</data>
			<data id="CMS1500.1.8_PTStud"> 
				<xsl:if test="data[@id=''CMS1500.1.PatientEmploymentStatus1''] = ''T''">X</xsl:if>
			</data>
			<data id="CMS1500.1.9_OtherName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.OtherSubscriberSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.OtherSubscriberFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberMiddleName1''], 1, 1)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientLastName1'']" />
								<xsl:if test="string-length(data[@id=''CMS1500.1.PatientSuffix1'']) > 0">
									<xsl:text>, </xsl:text>
									<xsl:value-of select="data[@id=''CMS1500.1.PatientSuffix1'']" />
								</xsl:if>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="data[@id=''CMS1500.1.PatientFirstName1'']" />
								<xsl:text xml:space="preserve"> </xsl:text>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientMiddleName1''], 1, 1)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_aGrpNumber"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerPolicyNumber1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bMM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 1, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bDD"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 4, 2)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bYYYY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="substring(data[@id=''CMS1500.1.OtherSubscriberBirthDate1''], 7, 4)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''M''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_bF"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:if test="data[@id=''CMS1500.1.OtherSubscriberGender1''] = ''F''">X</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_cEmployer"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">
						<xsl:choose>
							<xsl:when test="data[@id=''CMS1500.1.OtherSubscriberDifferentFlag1''] = ''1''">
								<xsl:value-of select="OtherSubscriberEmployerName" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="PatientEmployerName" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.9_dPlanName"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="data[@id=''CMS1500.1.OtherPayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aYes"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0aNo"> 
				<xsl:if test="data[@id=''CMS1500.1.EmploymentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bYes"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bNo"> 
				<xsl:if test="data[@id=''CMS1500.1.AutoAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0bState">
				<xsl:value-of select="data[@id=''CMS1500.1.AutoAccidentRelatedState1'']" />
			</data>
			<data id="CMS1500.1.1_0cYes"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] = ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0cNo"> 
				<xsl:if test="data[@id=''CMS1500.1.OtherAccidentRelatedFlag1''] != ''1''">X</xsl:if>
			</data>
			<data id="CMS1500.1.1_0dLocal"> </data>
			<data id="CMS1500.1.1_1GroupNumber"> 
				<xsl:choose>
					<xsl:when test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1">
						<xsl:text>NONE</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.GroupNumber1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.1_1aMM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 1, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 1, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aDD"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 4, 2)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 4, 2)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aYY"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="substring(data[@id=''CMS1500.1.SubscriberBirthDate1''], 7, 4)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(data[@id=''CMS1500.1.PatientBirthDate1''], 7, 4)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aM"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''M''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''M''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1aF"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:if test="data[@id=''CMS1500.1.SubscriberGender1''] = ''F''">X</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="data[@id=''CMS1500.1.PatientGender1''] = ''F''">X</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1bEmployer"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:choose>
						<xsl:when test="data[@id=''CMS1500.1.SubscriberDifferentFlag1''] = ''1''">
							<xsl:value-of select="data[@id=''CMS1500.1.SubscriberEmployerName1'']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="data[@id=''CMS1500.1.PatientEmployerName1'']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1cPlanName"> 
				<xsl:if test="not(data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] = ''M'' and data[@id=''CMS1500.1.PayerPrecedence1''] = 1)">
					<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dYes"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] = ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_1dNo"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="data[@id=''CMS1500.1.OtherPayerFlag1''] != ''1''">X</xsl:if>
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_2Signature">Signature on File</data>
			<data id="CMS1500.1.1_2Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_3Signature">Signature on File</data>
			<data id="CMS1500.1.1_4MM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_4DD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_4YY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentIllnessDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_5MM"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 1, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5DD">
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 4, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_5YY"> 
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.SimilarIllnessDate1''], 9, 2)" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_6StartMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndMM">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndDD">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_6EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.DisabilityEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_7Referring">
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderMiddleName1'']) > 0">
					<xsl:value-of select="substring(data[@id=''CMS1500.1.ReferringProviderMiddleName1''],1,1)" />
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.ReferringProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.1_7aID"> 
				<xsl:value-of select="data[@id=''CMS1500.1.ReferringProviderOtherID'']" />
			</data>
			<data id="CMS1500.1.1_8StartMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8StartYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndMM"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndDD"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.1_8EndYY"> 
				<xsl:value-of select="substring(data[@id=''CMS1500.1.HospitalizationEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.1_9Local"> </data>
			<data id="CMS1500.1.2_0Yes"> </data>
			<data id="CMS1500.1.2_0No">X</data>
			<data id="CMS1500.1.2_0Dollars">      0</data>
			<data id="CMS1500.1.2_0Cents">.00</data>
			<data id="CMS1500.1.2_1Diag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode11'']" />
			</data>
			<data id="CMS1500.1.2_1Diag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode21'']" />
			</data>
			<data id="CMS1500.1.2_1Diag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode31'']" />
			</data>
			<data id="CMS1500.1.2_1Diag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisCode41'']" />
			</data>
			<data id="CMS1500.1.2_2Code"> </data>
			<data id="CMS1500.1.2_2Number"> </data>
			<data id="CMS1500.1.2_3PriorAuth">
				<xsl:value-of select="data[@id=''CMS1500.1.AuthorizationNumber1'']" />
			</data>
			<data id="CMS1500.1.2_5ID">
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeEIN1'']" />
			</data>
			<data id="CMS1500.1.2_5SSN"> </data>
			<data id="CMS1500.1.2_5EIN">X</data>
			<data id="CMS1500.1.2_6Account"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PatientID1'']" />
			</data>
			<data id="CMS1500.1.2_7Yes">X</data>
			<data id="CMS1500.1.2_7No"> </data>
			<data id="CMS1500.1.2_8Dollars">
				<xsl:variable name="charges-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($charges-dollars))" />
				<xsl:value-of select="$charges-dollars" />
			</data>
			<data id="CMS1500.1.2_8Cents"> 
				<xsl:variable name="charges-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$charges-cents" />
			</data>
			<data id="CMS1500.1.2_9Dollars"> 
				<xsl:variable name="paid-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''      '', 1, 6 - string-length($paid-dollars))" />
				<xsl:value-of select="$paid-dollars" />
			</data>
			<data id="CMS1500.1.2_9Cents"> 
				<xsl:variable name="paid-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalPaidAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$paid-cents" />
			</data>
			<data id="CMS1500.1.3_0Dollars"> 
				<xsl:variable name="balance-dollars" select="substring-before(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:value-of select="substring(''       '', 1, 7 - string-length($balance-dollars))" />
				<xsl:value-of select="$balance-dollars" />
			</data>
			<data id="CMS1500.1.3_0Cents"> 
				<xsl:variable name="balance-cents" select="substring-after(format-number(data[@id=''CMS1500.1.TotalBalanceAmount1''], ''#0.00'', ''default-format''), ''.'')" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$balance-cents" />
			</data>
			<data id="CMS1500.1.3_1Signature"> 
				<xsl:text xml:space="preserve">Signature on File </xsl:text>
			</data>
			<data id="CMS1500.1.3_1ProviderName">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderFirstName1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.RenderingProviderMiddleName1''], 1, 1)" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLastName1'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.RenderingProviderDegree1'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderDegree1'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_1Date">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 1, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 4, 2)" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.CurrentDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.3_2Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityName1'']" />
			</data>
			<data id="CMS1500.1.3_2Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.FacilityStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.FacilityStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_2CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.FacilityZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.FacilityZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.FacilityZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_2FacilityInfo"> 
				<xsl:value-of select="data[@id=''CMS1500.1.FacilityInfo1'']" />
			</data>
			<data id="CMS1500.1.3_3Name"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeName1'']" />
			</data>
			<data id="CMS1500.1.3_3Street"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PracticeStreet21'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PracticeStreet21'']" />
				</xsl:if>
			</data>
			<data id="CMS1500.1.3_3CityStateZip"> 
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PracticeState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PracticeZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticeZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PracticeZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>
			<data id="CMS1500.1.3_3Phone">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 1, 3)" />
				<xsl:text xml:space="preserve">) </xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 4, 3)" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="substring(data[@id=''CMS1500.1.PracticePhone1''], 7, 4)" />
			</data>
			<data id="CMS1500.1.3_3PIN">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderIndividualNumber1'']" />
			</data>
			<data id="CMS1500.1.3_3GRP">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderGroupNumber1'']" />
			</data>

			<data id="CMS1500.1.CarrierName">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerName1'']" />
			</data>

			<data id="CMS1500.1.CarrierStreet">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet11'']" />
				<xsl:if test="string-length(data[@id=''CMS1500.1.PayerStreet11'']) > 0">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="data[@id=''CMS1500.1.PayerStreet21'']" />
				</xsl:if>
			</data>

			<data id="CMS1500.1.CarrierCityStateZip">
				<xsl:value-of select="data[@id=''CMS1500.1.PayerCity1'']" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="data[@id=''CMS1500.1.PayerState1'']" />
				<xsl:text xml:space="preserve"> </xsl:text>
				<xsl:choose>
					<xsl:when test="string-length(data[@id=''CMS1500.1.PayerZip1'']) = 9">
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 1, 5)" />
						<xsl:text>-</xsl:text>
						<xsl:value-of select="substring(data[@id=''CMS1500.1.PayerZip1''], 6, 4)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="data[@id=''CMS1500.1.PayerZip1'']" />
					</xsl:otherwise>
				</xsl:choose>
			</data>


			<!-- Procedure 1 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID1'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY1">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate1''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.cTOS1">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode1'']" />
			</data>
			<data id="CMS1500.1.dCPT1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode1'']" />
			</data>
			<data id="CMS1500.1.dModifier1">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier11'']" />
			</data>
			<data id="CMS1500.1.dExtra1"> </data>
			<data id="CMS1500.1.eDiag1">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer11'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode1''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer21'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer21'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer31'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer31'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer41'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer41'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars1">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents1">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount1''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits1">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount1''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT1"> </data>
			<data id="CMS1500.1.iEMG1"> </data>
			<data id="CMS1500.1.jCOB1"> </data>
			<data id="CMS1500.1.kLocal1">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier1'']" />
			</data>

			<!-- Procedure 2 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID2'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY2">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate2''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.cTOS2">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode2'']" />
			</data>
			<data id="CMS1500.1.dCPT2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode2'']" />
			</data>
			<data id="CMS1500.1.dModifier2">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier12'']" />
			</data>
			<data id="CMS1500.1.dExtra2"> </data>
			<data id="CMS1500.1.eDiag2">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer12'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode2''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer22'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer22'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer32'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer32'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer42'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer42'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars2">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents2">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount2''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits2">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount2''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT2"> </data>
			<data id="CMS1500.1.iEMG2"> </data>
			<data id="CMS1500.1.jCOB2"> </data>
			<data id="CMS1500.1.kLocal2">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier2'']" />
			</data>

			<!-- Procedure 3 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID3'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY3">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate3''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.cTOS3">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode3'']" />
			</data>
			<data id="CMS1500.1.dCPT3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode3'']" />
			</data>
			<data id="CMS1500.1.dModifier3">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier13'']" />
			</data>
			<data id="CMS1500.1.dExtra3"> </data>
			<data id="CMS1500.1.eDiag3">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer13'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode3''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer23'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer23'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer33'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer33'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer43'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer43'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars3">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents3">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount3''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits3">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount3''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT3"> </data>
			<data id="CMS1500.1.iEMG3"> </data>
			<data id="CMS1500.1.jCOB3"> </data>
			<data id="CMS1500.1.kLocal3">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier3'']" />
			</data>

			<!-- Procedure 4 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID4'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY4">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate4''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.cTOS4">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode4'']" />
			</data>
			<data id="CMS1500.1.dCPT4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode4'']" />
			</data>
			<data id="CMS1500.1.dModifier4">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier14'']" />
			</data>
			<data id="CMS1500.1.dExtra4"> </data>
			<data id="CMS1500.1.eDiag4">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer14'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode4''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer24'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer24'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer34'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer34'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer44'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer44'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars4">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents4">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount4''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits4">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount4''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT4"> </data>
			<data id="CMS1500.1.iEMG4"> </data>
			<data id="CMS1500.1.jCOB4"> </data>
			<data id="CMS1500.1.kLocal4">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier4'']" />
			</data>

			<!-- Procedure 5 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID5'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY5">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate5''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.cTOS5">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode5'']" />
			</data>
			<data id="CMS1500.1.dCPT5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode5'']" />
			</data>
			<data id="CMS1500.1.dModifier5">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier15'']" />
			</data>
			<data id="CMS1500.1.dExtra5"> </data>
			<data id="CMS1500.1.eDiag5">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer15'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode5''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer25'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer25'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer35'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer35'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer45'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer45'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars5">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents5">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount5''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits5">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount5''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT5"> </data>
			<data id="CMS1500.1.iEMG5"> </data>
			<data id="CMS1500.1.jCOB5"> </data>
			<data id="CMS1500.1.kLocal5">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier5'']" />
			</data>

			<!-- Procedure 6 -->	
			<ClaimID>
				<xsl:value-of select="data[@id=''CMS1500.1.ClaimID6'']" />
			</ClaimID>
			<data id="CMS1500.1.aStartMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aStartDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aStartYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceBeginDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.aEndMM6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 1, 2)" />
			</data>
			<data id="CMS1500.1.aEndDD6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 4, 2)" />
			</data>
			<data id="CMS1500.1.aEndYY6">
				<xsl:value-of select="substring(data[@id=''CMS1500.1.ServiceEndDate6''], 9, 2)" />
			</data>
			<data id="CMS1500.1.bPOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.PlaceOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.cTOS6">
				<xsl:value-of select="data[@id=''CMS1500.1.TypeOfServiceCode6'']" />
			</data>
			<data id="CMS1500.1.dCPT6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureCode6'']" />
			</data>
			<data id="CMS1500.1.dModifier6">
				<xsl:value-of select="data[@id=''CMS1500.1.ProcedureModifier16'']" />
			</data>
			<data id="CMS1500.1.dExtra6"> </data>
			<data id="CMS1500.1.eDiag6">
				<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer16'']" />
				<xsl:if test="data[@id=''CMS1500.1.HCFASameAsInsuredFormatCode6''] != ''M''">
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer26'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer26'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer36'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer36'']" />
					</xsl:if>
					<xsl:if test="string-length(data[@id=''CMS1500.1.DiagnosisPointer46'']) &gt; 0">
						<xsl:text>,</xsl:text>
						<xsl:value-of select="data[@id=''CMS1500.1.DiagnosisPointer46'']" />
					</xsl:if>
				</xsl:if>
			</data>
			<xsl:if test="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'') > 0">
				<data id="CMS1500.1.fDollars6">
					<xsl:variable name="charge-dollars" select="concat(substring-before(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.''), ''. '')" />
					<xsl:value-of select="substring(''       '', 1, 7 - string-length($charge-dollars))" />
					<xsl:value-of select="$charge-dollars" />
				</data>
				<data id="CMS1500.1.fCents6">
					<xsl:variable name="charge-cents" select="substring-after(format-number(data[@id=''CMS1500.1.ChargeAmount6''], ''#0.00'', ''default-format''), ''.'')" />
					<xsl:value-of select="$charge-cents" />
				</data>
				<data id="CMS1500.1.gUnits6">
					<xsl:value-of select="format-number(data[@id=''CMS1500.1.ServiceUnitCount6''], ''0.0'', ''default-format'')" />
				</data>
			</xsl:if>
			<data id="CMS1500.1.hEPSDT6"> </data>
			<data id="CMS1500.1.iEMG6"> </data>
			<data id="CMS1500.1.jCOB6"> </data>
			<data id="CMS1500.1.kLocal6">
				<xsl:value-of select="data[@id=''CMS1500.1.RenderingProviderLocalIdentifier6'']" />
			</data>

			</page>
		</formData>
	</xsl:template>
</xsl:stylesheet>'
WHERE	BillingFormID = 4