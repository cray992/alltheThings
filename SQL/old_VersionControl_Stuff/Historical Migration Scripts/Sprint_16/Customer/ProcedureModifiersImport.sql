-- modiifiers import script
-- codes taken from here: https://www.cahabagba.com/part_b/education_and_outreach/general_billing_info/modifers.htm
-- and some AMA Book
CREATE TABLE #mod (code VARCHAR(16), descr VARCHAR(max))

INSERT INTO #mod (code, descr) VALUES ('D', 'Diagnostic or therapeutic site other than "P" or "H" when these are used as origin codes')
INSERT INTO #mod (code, descr) VALUES ('E', 'Residential, domiciliary, custodial facility (other than an 1819 facility)')
INSERT INTO #mod (code, descr) VALUES ('G', 'Hospital based dialysis facility (hospital or hospital related)')
INSERT INTO #mod (code, descr) VALUES ('H', 'Hospital')
INSERT INTO #mod (code, descr) VALUES ('I', 'Site of transfer (e.g., airport or helicopter pad) between modes of ambulance transport')
INSERT INTO #mod (code, descr) VALUES ('J', 'Non-hospital based dialysis facility')
INSERT INTO #mod (code, descr) VALUES ('N', 'Skilled nursing facility (SNF) (1819 facility)')
INSERT INTO #mod (code, descr) VALUES ('P', 'Physician''s office (includes HMO non-hospital facility, clinic, etc.)')
INSERT INTO #mod (code, descr) VALUES ('R', 'Residence')
INSERT INTO #mod (code, descr) VALUES ('S', 'Scene of accident or acute event')
INSERT INTO #mod (code, descr) VALUES ('X', '(Destination code only) Intermediate stop at physician''s office in route to the hospital (includes HMO non-hospital facility, clinic, etc.)')
INSERT INTO #mod (code, descr) VALUES ('GM', 'Multiple patients on one ambulance trip')
INSERT INTO #mod (code, descr) VALUES ('QL', 'Patient pronounced dead after ambulance called')
INSERT INTO #mod (code, descr) VALUES ('QM', 'Ambulance service provided under arrangement by a provider of services')
INSERT INTO #mod (code, descr) VALUES ('QN', 'Ambulance service furnished directly by a provider of services')

INSERT INTO #mod (code, descr) VALUES ('AA', 'Anesthesia services personally performed by anesthesiologist - Distinct fee schedule amount. Affects payment.')
INSERT INTO #mod (code, descr) VALUES ('AD', 'Medical supervision by a physician: More than 4 concurrent anesthesia procedures -. Distinct fee schedule amount. Affects payment.')
INSERT INTO #mod (code, descr) VALUES ('G8', 'Monitored anesthesia care (MAC) for deep complex, complicated, or markedly invasive surgical procedure')
INSERT INTO #mod (code, descr) VALUES ('G9', 'Monitored anesthesia care (MAC) for deep complex, complicated, or markedly invasive surgical procedure')
INSERT INTO #mod (code, descr) VALUES ('QK', 'Medical direction of 2, 3 or 4 concurrent anesthesia procedures involving qualified individuals - 1999 services limits the payment to 50% of the amount that would have been allowed if personally performed by a physician or non-supervised CRNA.')
INSERT INTO #mod (code, descr) VALUES ('QS', 'Monitored anesthesia care- No effect on payment. For informational purposes only. Must be used in conjunction with a pricing anesthesia modifier.')
INSERT INTO #mod (code, descr) VALUES ('QX', 'CRNA service with medical direction by physician- 1999 services limits the payment to 50% of the amount that would have been allowed if personally performed by physician or non-supervised CRNA.')
INSERT INTO #mod (code, descr) VALUES ('QY', 'Medical direction of one certified registered nurse anesthetist (CRNA) by an anesthesiologist.')
INSERT INTO #mod (code, descr) VALUES ('QZ', 'CRNA service without medical direction by a physician - No effect on payment. Payment is equal to the amount that would have been allowed if personally performed by a physician.')
INSERT INTO #mod (code, descr) VALUES ('23', 'Unusual anesthesia - Used to report a procedure which usually requires either no anesthesia or local anesthesia; however, because of unusual circumstances must be done under general anesthesia. Coverage /payment will be determined on a "by-report" basis.')
INSERT INTO #mod (code, descr) VALUES ('47', 'Anesthesia by surgeon - Used to report regional or general anesthesia provided by the surgeon (Not covered by Medicare).')

INSERT INTO #mod (code, descr) VALUES ('Q0', 'Investigational clinical service provided in a clinical research study that is in an approved clinical research study')
INSERT INTO #mod (code, descr) VALUES ('Q1', 'Routine clinical service provided in a clinical research study that is in an approved clinical research study')

INSERT INTO #mod (code, descr) VALUES ('LC', 'Left circumflex coronary artery')
INSERT INTO #mod (code, descr) VALUES ('LD', 'Left anterior descending coronary artery')
INSERT INTO #mod (code, descr) VALUES ('RC', 'Right coronary artery')

INSERT INTO #mod (code, descr) VALUES ('GG','Diagnostic Mammography - Performance and payment of a screening mammography and diagnostic mammography on same patient, same day. (Moved from other section/alpha order)')
INSERT INTO #mod (code, descr) VALUES ('LR', 'Laboratory Round Trip - No effect on payment')
INSERT INTO #mod (code, descr) VALUES ('QP', 'Panel test - Documentation is on file showing that the laboratory test(s) was ordered individually or ordered as a CPT-recognized panel other than automated profile codes 80002-80019, G0058, G0059, and G0060. No effect on payment- but may assist with medical necessity determinations.')
INSERT INTO #mod (code, descr) VALUES ('QW', 'CLIA Waived Test - Effective October 1, 1996, all new waived tests are being assigned a CPT code (in lieu of a temporary five-digit G- or Q-code). The CPT code should be billed with a modifier QW by entities holding a Certificate of Waiver.')
INSERT INTO #mod (code, descr) VALUES ('TC', 'Technical component only - Use to indicate that the technical or professional component is reported separately (from the professional component) for the diagnostic procedure performed. The fee schedule contains different payment amounts for technical components. Affects payment.')
INSERT INTO #mod (code, descr) VALUES ('UN', 'Portable X-ray Modifiers; two patients')
INSERT INTO #mod (code, descr) VALUES ('UP', 'Portable X-ray Modifiers; three patients')
INSERT INTO #mod (code, descr) VALUES ('UQ', 'Portable X-ray Modifiers; four patients')
INSERT INTO #mod (code, descr) VALUES ('UR', 'Portable X-ray Modifiers; five patients')
INSERT INTO #mod (code, descr) VALUES ('US', 'Portable X-ray Modifiers; six patients')
INSERT INTO #mod (code, descr) VALUES ('26', 'Professional component only - Use to indicate that the physician component is reported separately (from the technical component) for the diagnostic procedure performed. The fee schedule contains different payment amounts for professional components. Affects payment.')
INSERT INTO #mod (code, descr) VALUES ('90', 'Reference lab - Used to indicate a lab test sent to a referral (outside) lab, e.g., lab procedure performed by a party other than the treating or reporting laboratory. Note: Referral lab name, address and/or PIN must be included with the claim. No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('91', 'Repeat clinical diagnostic laboratory test - in the course of treatment of the patient, it may be necessary to repeat the same laboratory test on the same day to obtain subsequent (multiple) test results. Under these circumstances, the laboratory test performed can be identified by its usual procedure number and the addition of the modifier -''91''. Note: This modifier may not be used when test are rerun to confirm initial results; due to testing problems with specimens or equipment; or for any other reason when a normal, one-time, reportable result is all that is required. This modifier may not be used when other code(s) describe a series of test results (e.g., glucose tolerance test, evocative/suppression testing). This modifier may only be used for laboratory test(s) performed more than once on the same day on the same patient.')

INSERT INTO #mod (code, descr) VALUES ('AX', 'Item furnished in conjunction with dialysis services.')
INSERT INTO #mod (code, descr) VALUES ('CB', 'Services ordered by a dialysis facility physician as part of the ESRD beneficiary''s dialysis benefit.')
INSERT INTO #mod (code, descr) VALUES ('CD', 'AMCC test has been ordered by an ESRD facility or MCP physician that is part of the composite rate and is not separately billable')
INSERT INTO #mod (code, descr) VALUES ('CE', 'AMCC test has been ordered by an ESRD facility or MCP physician that is a composite rate test but is beyond the normal frequency covered under the rate and is separately reimbursable based on medical necessity')
INSERT INTO #mod (code, descr) VALUES ('CF', 'AMCC test has been ordered by an ESRD facility or MCP physician that is not part of the composite rate and is separately billable')
INSERT INTO #mod (code, descr) VALUES ('EJ', 'Subsequent claims for a defined course of therapy, e.g., EPO, sodium hyaluronate, infliximab')
INSERT INTO #mod (code, descr) VALUES ('EM', 'Emergency reserve supply (for ESRD benefit only) - No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('G1', 'Most recent URR reading of less than 60')
INSERT INTO #mod (code, descr) VALUES ('G2', 'Most recent URR reading of 60 to 64.9')
INSERT INTO #mod (code, descr) VALUES ('G3', 'Most recent URR reading of 65 to 69.9')
INSERT INTO #mod (code, descr) VALUES ('G4', 'Most recent URR reading of 70 to 74.9')
INSERT INTO #mod (code, descr) VALUES ('G5', 'Most recent URR reading of 75 or greater')
INSERT INTO #mod (code, descr) VALUES ('G6', 'ESRD patient for whom less than seven dialysis sessions have been provided in a month')

INSERT INTO #mod (code, descr) VALUES ('AI', 'Principal Physician of Record. Used by the admitting or attending physician who oversees the patient''s care, as distinct from other physicians who may be furnishing specialty care')
INSERT INTO #mod (code, descr) VALUES ('24', 'Unrelated E/M service during a post op period - Use with E/M codes only to indicate that the E/M service was performed during a postoperative period for a reason(s) unrelated to the original procedure. Modifier 24 applies to unrelated E/M services for either MAJOR or MINOR surgical procedure. Failure to use this modifier when appropriate may result in denial of the E/M service.')
INSERT INTO #mod (code, descr) VALUES ('25', 'Significant, separately identifiable - Evaluation and Management service by the same physician on the same day as the procedure or other service. The physician may need to indicate that on the day a procedure or service was performed, the patient''s condition required a significant, separately identifiable E&M service above and beyond the other service provided or beyond the usual preoperative and postoperative care associated with the procedure that was performed. The E&M service may be prompted by the symptom or condition for which the procedure and/or service was provided. As such, different diagnoses are not required for reporting of the E&M services on the same date. This circumstance may be reported by adding the modifier -25 to the appropriate level of E&M service.')
INSERT INTO #mod (code, descr) VALUES ('57', 'Decision for surgery - Use with E/M codes billed by the surgeon to indicate that the E/M service resulted in the decision for surgery (E/M visit was NOT usual preoperative care).For E/M visits prior to MAJOR surgery (90-day post op period) only. Failure to use this modifier when appropriate may result in denial of the E/M service.')


INSERT INTO #mod (code, descr) VALUES ('Q7', 'One CLASS A finding')
INSERT INTO #mod (code, descr) VALUES ('Q8', 'Two CLASS B findings')
INSERT INTO #mod (code, descr) VALUES ('Q9', 'One CLASS B and two CLASS C findings')

INSERT INTO #mod (code, descr) VALUES ('AS', 'Physician Assistant, Nurse Practitioner, or Clinical Nurse Specialist services for assistant-at-surgery, non-team member. Reimburses at the Non Physician practitioner rate of 85% of the Medicare Physician Fee Schedule, then Assistant at surgery rate of 16% of the calculated non physician practitioner rate')

INSERT INTO #mod (code, descr) VALUES ('GO', 'Services delivered under an outpatient occupational therapy plan of care')

INSERT INTO #mod (code, descr) VALUES ('AP', 'Determination of refractive state was not performed in the course of diagnostic ophthalmological examination. No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('AQ', 'Physician providing a service in an unlisted health professional shortage area (HPSA). For dates of service on or after January 1, 2006.')
INSERT INTO #mod (code, descr) VALUES ('AT', 'Acute treatment (chiropractic claims) - This modifier should be used when reporting CPT codes 98940, 98941, 98942 or 98943 for acute treatment. No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('CC', 'Procedure code change- CARRIER USE ONLY - Used by carrier to indicate that the procedure code submitted was changed either for administrative reasons or because an incorrect code was filed. No effect on payment. Payment determination will be based on the "new" code used by the carrier.')
INSERT INTO #mod (code, descr) VALUES ('CR', 'Catastrophe/disaster related. It is required when an item or service is impacted by an emergency or disaster and Medicare payment for such item or service is conditioned on the presence of a “formal waiver”.')
INSERT INTO #mod (code, descr) VALUES ('EA', 'Erythropoetic stimulating agent (ESA) administered to treat anemia due to anti-cancer chemotherapy')
INSERT INTO #mod (code, descr) VALUES ('EB', 'Erythropoetic stimulating agent (ESA) administered to treat anemia due to anti-cancer radiotherapy')
INSERT INTO #mod (code, descr) VALUES ('EC', 'Erythropoetic stimulating agent (ESA) administered to treat anemia not due to anti-cancer radiotherapy or anti-cancer chemotherapy')
INSERT INTO #mod (code, descr) VALUES ('ET', 'Emergency treatment - Use to designate a dental procedure performed in an emergency situation. No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('FB', 'Item provided without cost to provider, supplier or practitioner, or credit received for replaced device (examples, but not limited to covered under warranty, replaced due to defect, free samples)')
INSERT INTO #mod (code, descr) VALUES ('GA', 'Waiver of liability statement on file - Use to indicate that the physician''s office has a signed advance notice retained in the patient''s medical record. The notice is for services that may be denied by Medicare. No effect on payment; however, potential liability determinations are based in part on the use of modifier. Updated description effective April 1, 2010: Waiver of Liability Statement Issued, as Required by Payer Policy. This modifier should be used to report when a required ABN was issued for a service.')
INSERT INTO #mod (code, descr) VALUES ('GJ', 'Opted Out physician or practitioner - Use to indicate services performed in an emergency or urgent service.')
INSERT INTO #mod (code, descr) VALUES ('GS', 'Dosage of EPO or Darbepoietin Alfa has been reduced and maintained in response to hematocrit or hemoglobin level.')
INSERT INTO #mod (code, descr) VALUES ('GV', 'Attending physician not employed or paid under agreement by the patient''s hospice provider.')
INSERT INTO #mod (code, descr) VALUES ('GW', 'Service not related to the hospice patient''s terminal condition.')
INSERT INTO #mod (code, descr) VALUES ('GX', 'Notice of Liability Issued, Voluntary Under Payer Policy. This modifier should be used to report when a voluntary ABN was issued for a service.')
INSERT INTO #mod (code, descr) VALUES ('GY', 'Use to indicate when an item or service statutorily excluded or does not meet the definition of any Medicare benefit.')
INSERT INTO #mod (code, descr) VALUES ('GZ', 'Use to indicate when an item or service expected to be denied as not reasonable and necessary. Used when no Advanced Beneficiary Notice (ABN) signed by the beneficiary.')
INSERT INTO #mod (code, descr) VALUES ('G7', 'Pregnancy resulted from rape or incest or pregnancy certified by physician as life threatening')
INSERT INTO #mod (code, descr) VALUES ('JA', 'Administered intravenously')
INSERT INTO #mod (code, descr) VALUES ('JB', 'Administered subcutaneously')
INSERT INTO #mod (code, descr) VALUES ('KB', 'Beneficiary requested upgrade for ABN, more than 4 modifiers identified on claim')
INSERT INTO #mod (code, descr) VALUES ('KD', 'Drug or biological infused through DME.')
INSERT INTO #mod (code, descr) VALUES ('KX', 'Updated description effective April 1, 2010: Requirements specified in the medical policy have been met. May be used when a therapy exception is appropriate or should be billed with any procedure code(s) that are gender specific for the affected beneficiaries.')
INSERT INTO #mod (code, descr) VALUES ('KM', 'Replacement of facial prosthesis - including new impression/moulage')
INSERT INTO #mod (code, descr) VALUES ('KN', 'Replacement of facial prosthesis - Using previous master model')
INSERT INTO #mod (code, descr) VALUES ('KZ', 'New Coverage not implemented by managed care')
INSERT INTO #mod (code, descr) VALUES ('M2', 'Medicare Secondary Payer')
INSERT INTO #mod (code, descr) VALUES ('QC', 'Single channel monitoring - No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('QD', 'Recording and storage in solid state memory by a digital recorder - No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('QJ', 'Services/items provided to a prisoner or patient in state or local custody, however the State or Local government, as applicable, meets the requirements in 42 CFR 411.4(B)')
INSERT INTO #mod (code, descr) VALUES ('QT', 'Recording and storage on tape by an analog tape recorder - No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('Q3', 'Liver Kidney Donor Surgery and Related Services - No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('Q4', 'Service for ordering/referring physician qualifies as a service exemption - No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('Q5', 'Service furnished by a substitute physician under a reciprocal billing arrangement - No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('Q6', 'Service furnished by a locum tenens physician - No effect on payment.')
INSERT INTO #mod (code, descr) VALUES ('SK', 'Member of high risk population (Use only with codes for immunization)')
INSERT INTO #mod (code, descr) VALUES ('32', 'Mandated services - Services related to mandated consultations and/or related services (e.g., PRO, third party payer, governmental, legislative or regulatory requirement) may be identified by adding the modifier ''-32'' to the base procedure.')
INSERT INTO #mod (code, descr) VALUES ('59', 'Distinct Procedural Service - Under certain circumstances, the physician may need to indicate that a procedure or service was distinct or independent from other services performed on the same day. Modifier ''-59'' is used to identify procedures/services that are not normally reported together, but are appropriate under the circumstances. This may represent a different session or patient encounter, different procedure or surgery, different site or organ system, separate incision/excision, separate lesion, or separate injury (or area of injury in extensive injuries) not ordinarily encountered or performed on the same day by the same physician. However, when another already established modifier is appropriate it should be used rather than modifier ''-59'' only if no more descriptive modifier is available, and the use of modifier ''-59'' best explains the circumstances, should modifier ''-59'' be used.')
INSERT INTO #mod (code, descr) VALUES ('99', 'Multiple modifiers- Use only when more than four modifiers are needed to describe a service. The additional modifiers should be included with the claim (item 19 on paper submissions, or appropriate message or freeform area on electronic submissions).No effect on payment; however, the individual modifiers listed will apply, including any potential effect they may on payment.')


INSERT INTO #mod (code, descr) VALUES ('73', 'Discontinued out-patient hospital or ambulatory surgical center (ASC) procedure prior to the administration of anesthesia - Due to extenuating circumstances or those that threaten the well being of the patient, the physician may cancel a surgical or diagnostic procedure subsequent to the patient''s surgical preparation (including sedation when provided, and being taken to the room where the procedure is to be performed), but prior to the administration of anesthesia (local, regional block(s), or general). Under these circumstances, the intended service that is prepared for but canceled can be reported by its usual procedure number and the addition of the modifier -73 or by use of the separate five digit modifier code 09973. Note: the elective cancellation of a service prior to the administration of anesthesia and/or surgical preparation of the patient should not be reported. For physician reporting of a discontinued procedure, see modifier -53.')
INSERT INTO #mod (code, descr) VALUES ('SG', 'Ambulatory Surgical Center (ASC) modifier - This modifier identifies those services performed in the ASC facility that will generate a facility fee allowance. This modifier is NOT used by the performing physician/surgeon. Beginning January 1, 2008, ASCs no longer are required to include the SG modifier on facility claims to Medicare.')
INSERT INTO #mod (code, descr) VALUES ('74', 'Discontinued out-patient hospital/ambulatory surgery center (ASC) procedure after administration of anesthesia - Due to extenuating circumstances or those that threaten the well being of the patient, the physician may terminate a surgical or diagnostic procedure after the administration of anesthesia (local, regional block(s), general) or after the procedure was started (incision made, intubation started, scope inserted, etc). Under these circumstances, the procedure started but terminated can be reported by its usual procedure number and the addition of the modifier -74 or by use of the separate five-digit modifier code 09974.Note: the elective cancellation of a service prior to the administration of anesthesia and/or surgical preparation of the patient should not be reported for physician reporting of a discontinued procedure, see modifier -53')
INSERT INTO #mod (code, descr) VALUES ('GP', 'Services delivered under an outpatient physical therapy plan of care')

INSERT INTO #mod (code, descr) VALUES ('1P', 'Performance Measure Exclusion Modifier due to Medical Reasons: Includes: Not Indicated (absence of organ/limb, already received/performed, other); Contraindicated (patient allergic history, potential adverse drug interaction, other')
INSERT INTO #mod (code, descr) VALUES ('2P', 'Performance Measure Exclusion Modifier due to Patient Reasons: Includes: patient declined; economic, social, or religious reasons; other patient reasons')
INSERT INTO #mod (code, descr) VALUES ('3P', 'Performance Measure Exclusion Modifier due to System Reasons includes: Resources to perform the services not available; insurance coverage/payor-related limitations; other reasons attributable to health care delivery system.')
INSERT INTO #mod (code, descr) VALUES ('8P', 'Performance Measure Reporting Modifier- Action not performed, reason not otherwise specified')

INSERT INTO #mod (code, descr) VALUES ('PI', 'Positron Emission Tomography (PET) or PET/Computed Tomography (CT) to inform the initial treatment strategy of tumors that are biopsy proven or strongly suspected of being cancerous based on other diagnostic testing.')
INSERT INTO #mod (code, descr) VALUES ('PS', 'Positron Emission Tomography (PET) or PET/Computed Tomography (CT) to inform the subsequent treatment strategy of cancerous tumors when the beneficiary''s treating physician determines that the PET study is needed to inform subsequent anti-tumor strategy.')

INSERT INTO #mod (code, descr) VALUES ('GN', 'Services delivered under an outpatient speech language pathology plan of care')


INSERT INTO #mod (code, descr) VALUES ('E1', 'Upper left, eyelid')
INSERT INTO #mod (code, descr) VALUES ('E3', 'Upper right, eyelid')
INSERT INTO #mod (code, descr) VALUES ('E2', 'Lower left, eyelid')
INSERT INTO #mod (code, descr) VALUES ('E4', 'Lower right, eyelid')

INSERT INTO #mod (code, descr) VALUES ('FA', 'Left hand, thumb')
INSERT INTO #mod (code, descr) VALUES ('F5', 'Right hand, thumb')
INSERT INTO #mod (code, descr) VALUES ('F1', 'Left hand, second digit')
INSERT INTO #mod (code, descr) VALUES ('F6', 'Right hand, second digit')
INSERT INTO #mod (code, descr) VALUES ('F2', 'Left hand, third digit')
INSERT INTO #mod (code, descr) VALUES ('F7', 'Right hand, third digit')
INSERT INTO #mod (code, descr) VALUES ('F3', 'Left hand, fourth digit')
INSERT INTO #mod (code, descr) VALUES ('F8', 'Right hand, fourth digit')
INSERT INTO #mod (code, descr) VALUES ('F4', 'Left hand, fifth digit')
INSERT INTO #mod (code, descr) VALUES ('F9', 'Right hand, fifth digit')

INSERT INTO #mod (code, descr) VALUES ('TA', 'Left foot, great toe')
INSERT INTO #mod (code, descr) VALUES ('T5', 'Right foot, great toe')
INSERT INTO #mod (code, descr) VALUES ('T1', 'Left foot, second digit')
INSERT INTO #mod (code, descr) VALUES ('T6', 'Right foot, second digit')
INSERT INTO #mod (code, descr) VALUES ('T2', 'Left foot, third digit')
INSERT INTO #mod (code, descr) VALUES ('T7', 'Right foot, third digit')
INSERT INTO #mod (code, descr) VALUES ('T3', 'Left foot, fourth digit')
INSERT INTO #mod (code, descr) VALUES ('T8', 'Right foot, fourth digit')
INSERT INTO #mod (code, descr) VALUES ('T4', 'Left foot, fifth digit')
INSERT INTO #mod (code, descr) VALUES ('T9', 'Right foot, fifth digit')

INSERT INTO #mod (code, descr) VALUES ('LT', 'Left Side - Used to identify procedures performed on the left side of the body. No effect on payment; however, failure to use when appropriate could result in delay or denial (or partial denial) of the claim.')
INSERT INTO #mod (code, descr) VALUES ('PA', 'Surgical or other invasive procedure on wrong body part')
INSERT INTO #mod (code, descr) VALUES ('PB', 'Surgical or other invasive procedure on wrong patient')
INSERT INTO #mod (code, descr) VALUES ('PC', 'Wrong surgery or other invasive procedure on patient')
INSERT INTO #mod (code, descr) VALUES ('RT', 'Right Side - Used to identify procedures performed on the right side of the body. No effect on payment; however, failure to use when appropriate could result in delay or denial (or partial denial) of the claim.')
INSERT INTO #mod (code, descr) VALUES ('22', 'Unusual procedural services - Used on surgery codes. An operative note should be submitted with the claim. May result in increased payment. DOCUMENTATION must be submitted.')
INSERT INTO #mod (code, descr) VALUES ('50', 'Bilateral procedure - Unless otherwise identified in the listings, bilateral procedures that are performed at the same operative session should be identified by adding the modifier -50 to the appropriate five digit code.')
INSERT INTO #mod (code, descr) VALUES ('51', 'Multiple procedures - When multiple procedures, other than evaluation and management services, are performed on the same day or at the same session by the same provider, the primary procedure or service may be reported as listed. The additional procedure(s) or service(s) may be identified by adding modifier ''-51'' to the additional procedure or service code(s). MODIFIER 51 IS NOT REQUIRED FOR BILLING PURPOSES: The carrier will assign the multiple procedure modifier if appropriate based on the services billed.')

INSERT INTO #mod (code, descr) VALUES ('52', 'Reduced services - Under certain circumstances a service or procedure is partially reduced or eliminated at the physician''s discretion. Under these circumstances the service provided can be identified by its usual procedure number and the addition of the modifier -52, signifying that the service is reduced. This provides a means of reporting reduced services without disturbing the identification of the basic service. Note: For hospital out-patient reporting of a previously scheduled procedure or service that is partially reduced or canceled as a result of extenuating circumstances or those that threaten the well-being of a patient prior to or after administration of anesthesia, see modifiers -73 and -74 (these modifiers are approved for ASC hospital out-patient USE')
INSERT INTO #mod (code, descr) VALUES ('53', 'Discontinued procedure - Under certain circumstances, the physician may elect to terminate a surgical or diagnostic procedure. Due to extenuating circumstances or those that threaten the well being of the patient, it may be necessary to indicate that a surgical or diagnostic procedure was started but discontinued. This circumstance may be reported by adding the modifier ''-53'' to the code reported by the physician for the discontinued procedure. Note: This modifier is not used to report the elective cancellation of a procedure prior to the patient''s anesthesia induction and/or surgical preparation in the operating suite. For outpatient hospital/ambulatory surgery center (ASC) reporting of a previously scheduled procedure/service that is partially reduced or canceled as a result of extenuating circumstances or those that threaten the well-being of the patient prior to or after administration of anesthesia, see modifiers -73 and -74 (modifiers approved for ASC and hospital out-patient use')
INSERT INTO #mod (code, descr) VALUES ('54', 'Surgical care only- Use with surgical codes when only the surgical service was performed. Payment will be limited to the amount allotted to the preoperative and intraoperative services only.')
INSERT INTO #mod (code, descr) VALUES ('55', 'Postoperative care only - Use with surgical codes only to indicate that only the postoperative care was performed (another physician performed the surgery). Payment will be limited to the amount allotted for postoperative services only.')
INSERT INTO #mod (code, descr) VALUES ('58', 'Staged or related procedure or service during the postoperative period- This modifier should be used to permit payment for a surgical procedure during the postoperative period of another surgical procedure when (1) the subsequent procedure was planned prospectively at the time of the original procedure, (2) a less extensive procedure fails and a more extensive procedure is required or (3) a therapeutic surgical procedure follows a diagnostic procedure e.g., a mastectomy follows a breast biopsy. Failure to use modifier when appropriate may result in denial of the subsequent surgery.')
INSERT INTO #mod (code, descr) VALUES ('62', 'Two surgeons - When two surgeons work together as primary surgeons performing distinct part(s) of a single reportable procedure, each surgeon should report his/her distinct operative work by adding the modifier -62 to the single distinct procedure code. Each surgeon should report the co-surgery once using the same procedure code. If additional procedure(s) (including add-on procedures) are performed during the same surgical session, separate codes may be reported without the modifier -62 added. Note: If a co-surgeon acts as an assistant in the performance of additional procedure(s) during the same surgical session, those services may be reported using separate procedure code(s), with modifier -80 or modifier -81 added, as appropriate.')
INSERT INTO #mod (code, descr) VALUES ('66', 'Surgical team - The modifier should be used by each participating surgeon to report his services. When team surgery is medically necessary, the carrier will determine the appropriate allowances(s) "by report.')
INSERT INTO #mod (code, descr) VALUES ('76', 'Repeat procedure by same physician - The physician may need to indicate that a procedure or service was repeated subsequent to the original procedure or service. This circumstance may be reported by adding modifier -76 to the repeated procedure or service.')
INSERT INTO #mod (code, descr) VALUES ('77', 'Repeat procedure by another physician - The physician may need to indicate that a basic procedure or service performed by another physician had to be repeated. This situation may be reported by adding modifier -77 to the repeated procedure or service.')
INSERT INTO #mod (code, descr) VALUES ('78', 'Return to OR for related surgery during postop period - Use on surgical codes only to indicate that another procedure was performed during the postoperative period of the initial procedure, was related to the first, and required the use of the operating room. Payment is limited to the amount allotted for intraoperative services only. Failure to use this modifier when appropriate may result in denial of the subsequent surgery.')
INSERT INTO #mod (code, descr) VALUES ('79', 'Unrelated surgery during postop period - Use on surgical codes only to indicate that the performance of a procedure during the postoperative period of another surgery was unrelated to the original procedure. Failure to use this modifier when appropriate may result in denial of the subsequent surgery.')
INSERT INTO #mod (code, descr) VALUES ('80', 'Assistant surgeon - Reimburses the assistant surgeon at 16% of the Medicare Physician Fee Schedule Data Base allowance for the surgical procedure.')
INSERT INTO #mod (code, descr) VALUES ('GC', 'This service has been performed in part by a resident under the direction of a teaching physician.')
INSERT INTO #mod (code, descr) VALUES ('GE', 'This service has been performed by a resident without the presence of a teaching physician under the primary care exception.')

INSERT INTO #mod (code, descr) VALUES ('GQ', 'Via asynchronous telecommunications system')
INSERT INTO #mod (code, descr) VALUES ('GT', 'Via interactive audio and video telecommunication systems')

INSERT INTO #mod (code, descr) VALUES ('56', 'Preoperative management only')
INSERT INTO #mod (code, descr) VALUES ('63', 'Procedure performed on infants less then 4 kgs')
INSERT INTO #mod (code, descr) VALUES ('81', 'Minimum assistant surgeon')
INSERT INTO #mod (code, descr) VALUES ('82', 'Assistant surgeon (when qualified resident surgeon not available')
INSERT INTO #mod (code, descr) VALUES ('P1', 'A normal healthy patient')
INSERT INTO #mod (code, descr) VALUES ('P2', 'A patient with mild systemic disease')
INSERT INTO #mod (code, descr) VALUES ('P3', 'A patient with severe systemic disease')
INSERT INTO #mod (code, descr) VALUES ('P4', 'A patient with severe systemic disease that is constant threat to life')
INSERT INTO #mod (code, descr) VALUES ('P5', 'A moribund patient who is not expected to survive without the operation')
INSERT INTO #mod (code, descr) VALUES ('P6', 'A declared brain-dead patient whose organs are being removed for donor purposes')
INSERT INTO #mod (code, descr) VALUES ('A1', 'Principal Physician of Record')
INSERT INTO #mod (code, descr) VALUES ('CA', 'Procedure payable only in the patient setting when performed emergently on an outpatient who expires prior to admission')
INSERT INTO #mod (code, descr) VALUES ('FC', 'Partial credit received for replaced service')
INSERT INTO #mod (code, descr) VALUES ('GH', 'Diagnostic mammogram converted from screening mammogram on same day')

INSERT INTO dbo.ProcedureModifier
        ( ProcedureModifierCode ,
          ModifierName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          KareoProcedureModifierCode ,
          KareoLastModifiedDate
        )        
SELECT   code , 
          LEFT(descr, 250) ,
          '2011-07-08' ,
          0 , -- CreatedUserID - int
          '2011-07-08' , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          NULL , -- KareoProcedureModifierCode - varchar(16)
          '2011-07-08'  -- KareoLastModifiedDate - datetime
FROM #mod
WHERE #mod.code NOT IN (SELECT ProcedureModifierCode FROM dbo.ProcedureModifier)
ORDER BY code

DROP TABLE #mod
