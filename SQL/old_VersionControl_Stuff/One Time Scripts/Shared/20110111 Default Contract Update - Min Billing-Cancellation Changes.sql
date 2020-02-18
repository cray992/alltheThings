DECLARE @contract XML
SET @contract='<KareoContract>
  <Customer>
    <conditions>
      <condition>
        <matchGroup>
          <match type="E" criteriaReference="ProviderSummary" criteriaType="criteria" criteriaName="Empty" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="36" price="299.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="1" />
              <lineItem id="37" price="199.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="2" />
              <lineItem id="38" price="99.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="3" />
              <lineItem id="39" price="199.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="6" />
              <lineItem id="40" price="399.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="7" />
              <lineItem id="41" price="599.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="8" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="ProviderSummary" criteriaType="criteria" criteriaName="Empty" value="1" />
          <invoicing>
            <lineItems>
              <matchGroup>
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="Cancelled" value="0" />
                <lineItem id="36" price="299.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="1" />
                <lineItem id="37" price="199.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="2" />
                <lineItem id="38" price="99.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="3" />
                <lineItem id="39" price="199.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="6" />
                <lineItem id="40" price="399.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="7" />
                <lineItem id="41" price="599.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SupportTypeID" value="8" />
                <lineItem id="1" price="69.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SignupEditionTypeID" value="3" lineComment="Minimum subscription fee" />
                <lineItem id="42" price="149.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SignupEditionTypeID" value="2" lineComment="Minimum subscription fee" />
                <lineItem id="43" price="199.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SignupEditionTypeID" value="1" lineComment="Minimum subscription fee" />
                <lineItem id="44" price="299.00" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SignupEditionTypeID" value="7" lineComment="Minimum subscription fee" />
              </matchGroup>
              <lineItem id="1" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SignupEditionTypeID" value="3">
                <activityLineItem price="69.00" allowance="0" criteriaType="activity" criteriaName="ProRateMinimumBilling" lineComment="Minimum subscription fee" />
              </lineItem>
              <lineItem id="42" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SignupEditionTypeID" value="2">
                <activityLineItem price="149.00" allowance="0" criteriaType="activity" criteriaName="ProRateMinimumBilling" lineComment="Minimum subscription fee" />
              </lineItem>
              <lineItem id="43" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SignupEditionTypeID" value="1">
                <activityLineItem price="199.00" allowance="0" criteriaType="activity" criteriaName="ProRateMinimumBilling" lineComment="Minimum subscription fee" />
              </lineItem>
              <lineItem id="44" type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="SignupEditionTypeID" value="7">
                <activityLineItem price="299.00" allowance="0" criteriaType="activity" criteriaName="ProRateMinimumBilling" lineComment="Minimum subscription fee" />
              </lineItem>
            </lineItems>
          </invoicing>
        </matchGroup>
      </condition>
    </conditions>
  </Customer>
  <Practice>
    <conditions>
      <condition>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="O" />
          <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="EditionTypeID" value="1" />
          <invoicing>
            <lineItems>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="3" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms" />
                <activityLineItem id="6" price="0.25" criteriaReference="Practice" criteriaType="activity" criteriaName="era" />
              </matchGroup>
              <matchGroup>
                <match type="GT" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.69" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <matchGroup>
                <match type="LTE" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.59" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <activityLineItem id="9" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_additionalpage" />
              <activityLineItem id="7" price="0.30" criteriaReference="Practice" criteriaType="activity" criteriaName="eligibility" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="O" />
          <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="EditionTypeID" value="2" />
          <invoicing>
            <lineItems>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="3" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms" />
                <activityLineItem id="6" price="0.25" criteriaReference="Practice" criteriaType="activity" criteriaName="era" />
              </matchGroup>
              <matchGroup>
                <match type="GT" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.69" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <matchGroup>
                <match type="LTE" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.59" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <activityLineItem id="9" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_additionalpage" />
              <activityLineItem id="7" price="0.30" criteriaReference="Practice" criteriaType="activity" criteriaName="eligibility" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="O" />
          <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="EditionTypeID" value="3" />
          <invoicing>
            <lineItems>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="3" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms" />
                <activityLineItem id="6" price="0.25" criteriaReference="Practice" criteriaType="activity" criteriaName="era" />
              </matchGroup>
              <matchGroup>
                <match type="GT" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.69" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <matchGroup>
                <match type="LTE" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.59" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <activityLineItem id="9" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_additionalpage" />
              <activityLineItem id="7" price="0.30" criteriaReference="Practice" criteriaType="activity" criteriaName="eligibility" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="N" />
          <match type="I" criteriaReference="Practice" criteriaType="criteria" criteriaName="EditionTypeID" value="1,7" />
          <invoicing>
            <lineItems>
              <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
              </activityLineItem>
              <activityLineItem id="8" price="0.69" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              <activityLineItem id="9" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_additionalpage" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="O" />
          <match type="I" criteriaReference="Practice" criteriaType="criteria" criteriaName="EditionTypeID" value="1,7" />
          <invoicing>
            <lineItems>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="3" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms" />
                <activityLineItem id="6" price="0.25" criteriaReference="Practice" criteriaType="activity" criteriaName="era" />
              </matchGroup>
              <matchGroup>
                <match type="GT" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.69" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <matchGroup>
                <match type="LTE" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.59" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <activityLineItem id="9" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_additionalpage" />
              <activityLineItem id="7" price="0.30" criteriaReference="Practice" criteriaType="activity" criteriaName="eligibility" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="N" />
          <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="EditionTypeID" value="2" />
          <invoicing>
            <lineItems>
              <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
              </activityLineItem>
              <activityLineItem id="8" price="0.69" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              <activityLineItem id="9" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_additionalpage" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="O" />
          <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="EditionTypeID" value="2" />
          <invoicing>
            <lineItems>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="3" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms" />
                <activityLineItem id="6" price="0.25" criteriaReference="Practice" criteriaType="activity" criteriaName="era" />
              </matchGroup>
              <matchGroup>
                <match type="GT" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.69" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <matchGroup>
                <match type="LTE" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.59" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <activityLineItem id="9" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_additionalpage" />
              <activityLineItem id="7" price="0.30" criteriaReference="Practice" criteriaType="activity" criteriaName="eligibility" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="N" />
          <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="EditionTypeID" value="3" />
          <invoicing>
            <lineItems>
              <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms" />
              <activityLineItem id="8" price="0.69" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              <activityLineItem id="9" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_additionalpage" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="O" />
          <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="EditionTypeID" value="3" />
          <invoicing>
            <lineItems>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="1" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="200" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="50" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="2" />
                <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
                <activityLineItem id="6" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="era">
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                  <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
                </activityLineItem>
              </matchGroup>
              <matchGroup>
                <match type="E" criteriaReference="Practice" criteriaType="criteria" criteriaName="PriorEditionTypeID" value="3" />
                <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms" />
                <activityLineItem id="6" price="0.25" criteriaReference="Practice" criteriaType="activity" criteriaName="era" />
              </matchGroup>
              <matchGroup>
                <match type="GT" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.69" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <matchGroup>
                <match type="LTE" criteriaReference="Customer" criteriaType="criteria" criteriaName="FirstInvoiceDate" value="9-1-08" dataType="Date" />
                <activityLineItem id="8" price="0.59" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              </matchGroup>
              <activityLineItem id="9" price="0.12" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_additionalpage" />
              <activityLineItem id="7" price="0.30" criteriaReference="Practice" criteriaType="activity" criteriaName="eligibility" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="T" />
          <invoicing>
            <lineItems>
              <activityLineItem id="4" price="15.00" criteriaReference="Practice" criteriaType="activity" criteriaName="dms">
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_1" />
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_2" />
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_3" />
                <allowance allowanceQty="100" criteriaType="criteria" criteriaName="ProviderTypeIDCount_5" />
              </activityLineItem>
              <activityLineItem id="6" price="0.99" criteriaReference="Practice" criteriaType="activity" criteriaName="era" />
              <activityLineItem id="8" price="0.99" criteriaReference="Practice" criteriaType="activity" criteriaName="ps_firstpage" />
              <activityLineItem id="7" price="0.99" criteriaReference="Practice" criteriaType="activity" criteriaName="eligibility" />
            </lineItems>
          </invoicing>
        </matchGroup>
      </condition>
    </conditions>
  </Practice>
  <Provider>
    <conditions>
      <condition>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="3" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="1" price="69.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="1" price="34.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="1" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="69.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="1" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="34.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <activityLineItem id="5" price="0.25" criteriaReference="Provider" criteriaType="activity" criteriaName="eclaims" />
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="3" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="1" price="69.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="1" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="69.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <activityLineItem id="5" price="0.25" criteriaReference="Provider" criteriaType="activity" criteriaName="eclaims" />
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="2" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="2" price="129.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="2" price="64.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="2" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="129.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="2" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="64.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="5" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="0.12" allowance="400" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <lineItem id="5" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="0.12" allowance="200" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="2" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="2" price="129.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="2" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="129.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <lineItem id="5" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="0.12" allowance="400" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="1" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="3" price="199.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="3" price="99.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="3" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="199.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="3" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="99.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="5" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="0.12" allowance="600" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <lineItem id="5" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="0.12" allowance="300" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="1" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="3" price="199.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="3" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="199.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <lineItem id="5" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="0.12" allowance="600" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="N" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="3" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="1" price="69.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="1" price="34.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="1" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="69.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="1" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="34.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <activityLineItem id="5" price="0.49" criteriaReference="Provider" criteriaType="activity" criteriaName="eclaims" />
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="3" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="1" price="69.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="1" price="34.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="1" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="69.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="1" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="34.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <activityLineItem id="5" price="0.25" criteriaReference="Provider" criteriaType="activity" criteriaName="eclaims" />
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="N" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="3" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="1" price="69.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="1" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="69.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <activityLineItem id="5" price="0.49" criteriaReference="Provider" criteriaType="activity" criteriaName="eclaims" />
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="3" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="1" price="69.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="1" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="69.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <activityLineItem id="5" price="0.25" criteriaReference="Provider" criteriaType="activity" criteriaName="eclaims" />
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="N" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="2" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="42" price="149.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="42" price="74.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="42" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="149.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="42" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="74.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="2" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="42" price="149.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="42" price="74.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="42" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="149.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="42" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="74.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="5" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="0.12" allowance="400" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <lineItem id="5" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="0.12" allowance="200" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="N" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="2" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="42" price="149.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="42" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="149.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="2" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="42" price="149.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="42" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="149.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <lineItem id="5" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="0.12" allowance="400" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="N" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="1" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="43" price="199.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="43" price="99.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="43" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="199.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="43" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="99.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="1" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="43" price="199.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="43" price="99.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="43" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="199.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="43" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="99.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="5" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="0.12" allowance="600" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <lineItem id="5" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="0.12" allowance="300" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="N" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="1" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="43" price="199.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="43" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="199.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PriorPricingModel" value="O" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="1" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="43" price="199.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="43" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="199.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <lineItem id="5" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="0.12" allowance="600" criteriaType="activity" criteriaName="eclaims" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="7" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="0" />
          <invoicing>
            <lineItems>
              <lineItem id="44" price="299.00" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1" />
              <lineItem id="44" price="149.50" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" />
              <lineItem id="44" type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1">
                <activityLineItem price="299.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <lineItem id="44" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="149.50" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="N" />
          <match type="E" criteriaReference="Provider" criteriaType="criteria" criteriaName="EditionTypeID" value="7" />
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="IsSingleProviderMidCo" value="1" />
          <invoicing>
            <lineItems>
              <lineItem id="44" price="299.00" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3" lineComment="Pricing For Single Provider Account" />
              <lineItem id="44" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="2,3">
                <activityLineItem price="299.00" allowance="0" criteriaType="activity" criteriaName="ProRateEdition" lineComment="Pricing For Single Provider Account" />
              </lineItem>
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
            </lineItems>
          </invoicing>
        </matchGroup>
        <matchGroup>
          <match type="E" criteriaReference="Customer" criteriaType="criteria" criteriaName="PricingModel" value="T" />
          <invoicing>
            <lineItems>
              <activityLineItem id="5" price="0.99" criteriaReference="Provider" criteriaType="activity" criteriaName="eclaims" />
              <activityLineItem id="35" price="0.37" criteriaReference="Provider" criteriaType="activity" criteriaName="paperclaims" />
              <lineItem id="43" price="0" type="I" criteriaReference="Provider" criteriaType="criteria" criteriaName="ProviderTypeID" value="1,2,3" />
            </lineItems>
          </invoicing>
        </matchGroup>
      </condition>
    </conditions>
  </Provider>
</KareoContract>'

UPDATE KC
	SET KareoCustomerContract=@contract
FROM dbo.KareoCustomerContract KC
WHERE KareoCustomerContractID=1