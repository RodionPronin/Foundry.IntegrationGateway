(:
	-----------------------------------
	Accellos8104030ToSPSInvoice	
	Version:	19	
	Modified:	05/29/2013
	-----------------------------------
	Accellos Conduit 1.0.0.x
	-----------------------------------
:)

declare default element namespace "http://www.spscommerce.com/RSX";

declare function local:repeat-string 
  ( $stringToRepeat as xs:string? ,
    $count as xs:integer )  as xs:string {
       
   string-join((for $i in 1 to $count return $stringToRepeat),
                        '')
 } ;

declare function local:pad-integer-to-length 
  ( $integerToPad as xs:anyAtomicType? ,
    $length as xs:integer )  as xs:string {
       
   if ($length < string-length(string($integerToPad)))
   then error(xs:QName('local:Integer_Longer_Than_Length'))
   else concat
         (local:repeat-string(
            '0',$length - string-length(string($integerToPad))),
          string($integerToPad))
 } ;

declare function local:fnEDITimeToSPSTime($inTime as xs:string) as xs:string
{
  let $hrs := substring($inTime,1,2)
  let $mins := substring($inTime,3,2)
  let $secs := local:pad-integer-to-length(substring($inTime,5,2),2)
  let $delim := ":"
  let $str := fn:concat($hrs,$delim,$mins,$delim,$secs)

  return $str
};

declare function local:fnEDIDateToSPSDate($inDate as xs:string) as xs:string
{
  let $year := substring($inDate,1,4)
  let $month := substring($inDate,5,2)
  let $day := substring($inDate,7,2)
  let $delim := "-"
  let $str := fn:concat($year,$delim,$month,$delim,$day)

  return $str
};

declare function local:fnITDToPaymentTerms($inElem as element()*) as element()*
{
		for $PaymTrms in $inElem
		return 
		<PaymentTerms>
			{
			if ($PaymTrms/*:TermsTypCd) then
			<TermsType>
				{
				$PaymTrms/*:TermsTypCd/text()
				}
			</TermsType>
			else()
			}
			{
			if ($PaymTrms/*:TermsBasisDateCode) then
			<TermsBasisDateCode>
				{
				$PaymTrms/*:TermsBasisDateCode/text()
				}
			</TermsBasisDateCode>
			else()
			}
			{
			if ($PaymTrms/*:TermsDiscPrct) then
			<TermsDiscountPercentage>
				{
				$PaymTrms/*:TermsDiscPrct/text()
				}
			</TermsDiscountPercentage>
			else()
			}
			{
			if ($PaymTrms/*:TermsDiscDueDate) then
			<TermsDiscountDate>
				{
				local:fnEDIDateToSPSDate($PaymTrms/*:TermsDiscDueDate/text())
				}
			</TermsDiscountDate>
			else()
			}
			{
			if ($PaymTrms/*:TermsDiscDaysDue) then
			<TermsDiscountDueDays>
				{
				$PaymTrms/*:TermsDiscDaysDue/text()
				}
			</TermsDiscountDueDays>
			else()
			}
			{
			if ($PaymTrms/*:TermsNetDueDate) then
			<TermsNetDueDate>
				{
				local:fnEDIDateToSPSDate($PaymTrms/*:TermsNetDueDate/text())
				}
			</TermsNetDueDate>
			else()
			}
			{
			if ($PaymTrms/*:TermsNetDays) then
			<TermsNetDueDays>
				{
				$PaymTrms/*:TermsNetDays/text()
				}
			</TermsNetDueDays>
			else()
			}
			{
			if ($PaymTrms/*:TermsDiscAmnt) then
			<TermsDiscountAmount>
				{
				$PaymTrms/*:TermsDiscAmnt/text()
				}
			</TermsDiscountAmount>
			else()
			}
			{
			if ($PaymTrms/*:TermsDeferredDueDate) then
			<TermsDeferredDueDate>
				{
				local:fnEDIDateToSPSDate($PaymTrms/*:TermsDeferredDueDate/text())
				}
			</TermsDeferredDueDate>
			else()
			}
			{
			if ($PaymTrms/*:DeferredAmountDue) then
			<TermsDeferredAmountDue>
				{
				$PaymTrms/*:DeferredAmountDue/text()
				}
			</TermsDeferredAmountDue>
			else()
			}
			{
			if ($PaymTrms/*:PrctOfInvPayable) then
			<PercentOfInvoicePayable>
				{
				$PaymTrms/*:PrctOfInvPayable/text()
				}
			</PercentOfInvoicePayable>
			else()
			}
			{
			if ($PaymTrms/*:Descr) then
			<TermsDescription>
				{
				$PaymTrms/*:Descr/text()
				}
			</TermsDescription>
			else()
			}
			{
			if ($PaymTrms/*:DayOfMonth) then
			<TermsDueDay>
				{
				$PaymTrms/*:DayOfMonth/text()
				}
			</TermsDueDay>
			else()
			}
			{
			if ($PaymTrms/*:PmntMthdCd) then
			<PaymentMethodCode>
				{
				$PaymTrms/*:PmntMthdCd/text()
				}
			</PaymentMethodCode>
			else()
			}
			{
			if ($PaymTrms/*:Prct) then
			<Percent>
				{
				$PaymTrms/*:Prct/text()
				}
			</Percent>
			else()
			}
		</PaymentTerms>
};

declare function local:fnDTMToDate($inElem as element()*) as element()*
{
		for $Date in $inElem
		return 
		<Date>
			{
			if ($Date/*:DateTimeQual) then
			<DateTimeQualifier1>
				{
				$Date/*:DateTimeQual/text()
				}
			</DateTimeQualifier1>
			else()
			}
			{
			if ($Date/*:Date) then
			<Date1>
				{
				local:fnEDIDateToSPSDate($Date/*:Date/text())
				}
			</Date1>
			else()
			}
			{
			if ($Date/*:Time) then
			<Time1>
				{
				local:fnEDITimeToSPSTime($Date/*:Time/text())
				}
			</Time1>
			else()
			}
			{
			if ($Date/*:TimeCode) then
			<TimeCode1>
				{
				$Date/*:TimeCode/text()
				}
			</TimeCode1>
			else()
			}
			{
			if ($Date/*:DtTmPrdFmtQual) then
			<DateTimeFormQualifier1>
				{
				$Date/*:DtTmPrdFmtQual/text()
				}
			</DateTimeFormQualifier1>
			else()
			}
			{
			if ($Date/*:DtTmPrd) then
			<DateTimePeriod>
				{
				$Date/*:DtTmPrd/text()
				}
			</DateTimePeriod>
			else()
			}
		</Date>
};

declare function local:fnPERToContact($inElem as element()*) as element()*
{
		for $Contact in $inElem
		return 
		<Contact>
			{
			if ($Contact/*:ContactFuncCd) then
			<ContactTypeCode>
				{
				$Contact/*:ContactFuncCd/text()
				}
			</ContactTypeCode>
			else()
			}
			{
			if ($Contact/*:Name) then
			<ContactName>
				{
				$Contact/*:Name/text()
				}
			</ContactName>
			else()
			}
			{
			if ($Contact/*:ComNumQual/text() eq 'TE' and $Contact/*:ComNum) then
			<ContactPhone>
			{
			$Contact/*:ComNum/text()
			}
			</ContactPhone>
			else if ($Contact/*:ComNumQual1/text() eq 'TE' and $Contact/*:ComNum1) then
			<ContactPhone>
			{
			$Contact/*:ComNum1/text()
			}
			</ContactPhone>
			else if ($Contact/*:ComNumQual2/text() eq 'TE' and $Contact/*:ComNum2) then
			<ContactPhone>
			{
			$Contact/*:ComNum2/text()
			}
			</ContactPhone>
			else()
			}
			{
			if ($Contact/*:ComNumQual/text() eq 'FX' and $Contact/*:ComNum) then
			<ContactFax>
			{
			$Contact/*:ComNum/text()
			}
			</ContactFax>
			else if ($Contact/*:ComNumQual1/text() eq 'FX' and $Contact/*:ComNum1) then
			<ContactFax>
			{
			$Contact/*:ComNum1/text()
			}
			</ContactFax>
			else if ($Contact/*:ComNumQual2/text() eq 'FX' and $Contact/*:ComNum2) then
			<ContactFax>
			{
			$Contact/*:ComNum2/text()
			}
			</ContactFax>
			else()
			}
			{
			if ($Contact/*:ComNumQual/text() eq 'EM' and $Contact/*:ComNum) then
			<ContactEmail>
			{
			$Contact/*:ComNum/text()
			}
			</ContactEmail>
			else if ($Contact/*:ComNumQual1/text() eq 'EM' and $Contact/*:ComNum1) then
			<ContactEmail>
			{
			$Contact/*:ComNum1/text()
			}
			</ContactEmail>
			else if ($Contact/*:ComNumQual2/text() eq 'EM' and $Contact/*:ComNum2) then
			<ContactEmail>
			{
			$Contact/*:ComNum2/text()
			}
			</ContactEmail>
			else()
			}
		</Contact>
};

declare function local:fnREFToReference($inElem as element()*) as element()*
{
	for $AddrRef in $inElem
	return 
	<Reference>
		{
		if ($AddrRef/*:RefIdnQual) then
		<ReferenceQual>
			{
			$AddrRef/*:RefIdnQual/text()
			}
		</ReferenceQual>
		else()
		}
		{
		if ($AddrRef/*:RefIdnQual/text() = 'SW') then
		<ReferenceID>
			{
			$AddrRef/*:RefIdn/substring(text(), 1, 10)
			}
		</ReferenceID>
		else()
		}
		{
		if ($AddrRef/*:RefIdn) then
		<ReferenceID>
			{
			$AddrRef/*:RefIdn/text()
			}
		</ReferenceID>
		else()
		}
		{
		if ($AddrRef/*:Descr) then
		<Description>
			{
			$AddrRef/*:Descr/text()
			}
		</Description>
		else()
		}
		{
		if ($AddrRef/*:RefIdr/*:RefIdnQual or $AddrRef/*:RefIdr/*:RefIdn) then
		<ReferenceIDs>
			{
				if ($AddrRef/*:RefIdr/*:RefIdnQual) then
				<ReferenceQual>
				{
				$AddrRef/*:RefIdr/*:RefIdnQual/text()
				}
				</ReferenceQual>
				else()
			}
			{
				if ($AddrRef/*:RefIdr/*:RefIdn) then
				<ReferenceID>
				{
				$AddrRef/*:RefIdr/*:RefIdn/text()
				}
				</ReferenceID>
				else()
			}
		</ReferenceIDs>
		else()
		}
		{
		if ($AddrRef/*:RefIdr/*:RefIdnQual1 or $AddrRef/*:RefIdr/*:RefIdn1) then
		<ReferenceIDs>
			{
				if ($AddrRef/*:RefIdr/*:RefIdnQual1) then
				<ReferenceQual>
				{
				$AddrRef/*:RefIdr/*:RefIdnQual1/text()
				}
				</ReferenceQual>
				else()
			}
			{
				if ($AddrRef/*:RefIdr/*:RefIdn1) then
				<ReferenceID>
				{
				$AddrRef/*:RefIdr/*:RefIdn1/text()
				}
				</ReferenceID>
				else()
			}
		</ReferenceIDs>
		else()
		}
		{
		if ($AddrRef/*:RefIdr/*:RefIdnQual2 or $AddrRef/*:RefIdr/*:RefIdn2) then
		<ReferenceIDs>
			{
				if ($AddrRef/*:RefIdr/*:RefIdnQual2) then
				<ReferenceQual>
				{
				$AddrRef/*:RefIdr/*:RefIdnQual2/text()
				}
				</ReferenceQual>
				else()
			}
			{
				if ($AddrRef/*:RefIdr/*:RefIdn2) then
				<ReferenceID>
				{
				$AddrRef/*:RefIdr/*:RefIdn2/text()
				}
				</ReferenceID>
				else()
			}
		</ReferenceIDs>
		else()
		}
	</Reference>
};

declare function local:fnPIDToProductDescription($inElem as element()*) as element()*
{
		for $ProdDesc in $inElem
		return 
		<ProductOrItemDescription>
			{
			if ($ProdDesc/*:ItmDescrTyp) then
			<ProductCharacteristicCode>
				{
				$ProdDesc/*:ItmDescrTyp/text()
				}
			</ProductCharacteristicCode>
			else()
			}
			{
			if ($ProdDesc/*:ProdProcChrstc) then
			<ItemDescriptionType>
				{
				$ProdDesc/*:ProdProcChrstc/text()
				}
			</ItemDescriptionType>
			else()
			}
			{
			if ($ProdDesc/*:AgncQualCode) then
			<AgencyQualifierCode>
				{
				$ProdDesc/*:AgncQualCode/text()
				}
			</AgencyQualifierCode>
			else()
			}
			{
			if ($ProdDesc/*:ProdDescrCd) then
			<ProductDescriptionCode>
				{
				$ProdDesc/*:ProdDescrCd/text()
				}
			</ProductDescriptionCode>
			else()
			}
			{
			if ($ProdDesc/*:Descr) then
			<ProductDescription>
				{
				$ProdDesc/*:Descr/text()
				}
			</ProductDescription>
			else()
			}
			{
			if ($ProdDesc/*:SrfcLyrPosnCd) then
			<SurfaceLayerPositionCode>
				{
				$ProdDesc/*:SrfcLyrPosnCd/text()
				}
			</SurfaceLayerPositionCode>
			else()
			}
			{
			if ($ProdDesc/*:SrcSubqual) then
			<SourceSubqualifier>
				{
				$ProdDesc/*:SrcSubqual/text()
				}
			</SourceSubqualifier>
			else()
			}
			{
			if ($ProdDesc/*:YorNCondResp) then
			<YesOrNoResponse>
				{
				$ProdDesc/*:YorNCondResp/text()
				}
			</YesOrNoResponse>
			else()
			}
			{
			if ($ProdDesc/*:LangCd) then
			<LanguageCode>
				{
				$ProdDesc/*:LangCd/text()
				}
			</LanguageCode>
			else()
			}
		</ProductOrItemDescription>
};

declare function local:fnMEAToMeasurements($inElem as element()*) as element()*
{
		for $Meas in $inElem
		return 
		<Measurements>
			{
			if ($Meas/*:MsmntRefIdCd) then
			<MeasurementRefIDCode>
				{
				$Meas/*:MsmntRefIdCd/text()
				}
			</MeasurementRefIDCode>
			else()
			}
			{
			if ($Meas/*:MsmntQual) then
			<MeasurementQualifier>
				{
				$Meas/*:MsmntQual/text()
				}
			</MeasurementQualifier>
			else()
			}
			{
			if ($Meas/*:MsmntVal) then
			<MeasurementValue>
				{
				$Meas/*:MsmntVal/text()
				}
			</MeasurementValue>
			else()
			}
			{
			if ($Meas/*:CompUofM[1]/*:UorBforM) then
			<CompositeUOM>
				{
				$Meas/*:CompUofM[1]/*:UorBforM/text()
				}
			</CompositeUOM>
			else()
			}
			{
			if ($Meas/*:RngMin) then
			<RangeMinimum>
				{
				$Meas/*:RngMin/text()
				}
			</RangeMinimum>
			else()
			}
			{
			if ($Meas/*:RngMax) then
			<RangeMaximum>
				{
				$Meas/*:RngMax/text()
				}
			</RangeMaximum>
			else()
			}
			{
			if ($Meas/*:MsmntSgnfgncCd) then
			<MeasurementSignificanceCode>
				{
				$Meas/*:MsmntSgnfgncCd/text()
				}
			</MeasurementSignificanceCode>
			else()
			}
			{
			if ($Meas/*:MsmntAttrCd) then
			<MeasurementAttributeCode>
				{
				$Meas/*:MsmntAttrCd/text()
				}
			</MeasurementAttributeCode>
			else()
			}
			{
			if ($Meas/*:SrfcLyrPosnCd) then
			<SurfaceLayerPositionCode>
				{
				$Meas/*:SrfcLyrPosnCd/text()
				}
			</SurfaceLayerPositionCode>
			else()
			}
		</Measurements>
};

declare function local:fnTXIToTax($inElem as element()*) as element()*
{
		for $TaxItem in $inElem
		return 
		<Tax>
			{
			if ($TaxItem/*:TaxTypeCode) then
			<TaxTypeCode>
				{
				$TaxItem/*:TaxTypeCode/text()
				}
			</TaxTypeCode>
			else()
			}
			{
			if ($TaxItem/*:MonetaryAmnt) then
			<TaxAmount>
				{
				$TaxItem/*:MonetaryAmnt/text()
				}
			</TaxAmount>
			else()
			}
			{
			if ($TaxItem/*:Prct) then
			<TaxPercent>
				{
				$TaxItem/*:Prct/text()
				}
			</TaxPercent>
			else()
			}
			{
			if ($TaxItem/*:TaxJurdctnCdQual) then
			<JurisdictionQual>
				{
				$TaxItem/*:TaxJurdctnCdQual/text()
				}
			</JurisdictionQual>
			else()
			}
			{
			if ($TaxItem/*:TaxJurdctnCd) then
			<JurisdictionCode>
				{
				$TaxItem/*:TaxJurdctnCd/text()
				}
			</JurisdictionCode>
			else()
			}
			{
			if ($TaxItem/*:TaxExemptCode) then
			<TaxExemptCode>
				{
				$TaxItem/*:TaxExemptCode/text()
				}
			</TaxExemptCode>
			else()
			}
			{
			if ($TaxItem/*:RltnshpCd) then
			<RelationshipCode>
				{
				$TaxItem/*:RltnshpCd/text()
				}
			</RelationshipCode>
			else()
			}
			{
			if ($TaxItem/*:DolBasisForPrct) then
			<PctDollarBasis>
				{
				$TaxItem/*:DolBasisForPrct/text()
				}
			</PctDollarBasis>
			else()
			}
			{
			if ($TaxItem/*:TaxIdnNbr) then
			<TaxID>
				{
				$TaxItem/*:TaxIdnNbr/text()
				}
			</TaxID>
			else()
			}
			{
			if ($TaxItem/*:AsgndIdn) then
			<AssignedID>
				{
				$TaxItem/*:AsgndIdn/text()
				}
			</AssignedID>
			else()
			}
		</Tax>
};

declare function local:fnNTEToNotes($inElem as element()*) as element()*
{
			for $LeadNotes in $inElem
			return 
			<Notes>
				{
				if ($LeadNotes/*:NoteRefCd) then
				<NoteCode>
					{
					$LeadNotes/*:NoteRefCd/text()
					}
				</NoteCode>
				else()
				}
				{
				if ($LeadNotes/*:Descr) then
				<NoteInformationField>
					{
					$LeadNotes/*:Descr/text()
					}
				</NoteInformationField>
				else()
				}
			</Notes>
};

declare function local:fnBaseSACToChargesAllowances($inElem as element()*) as element()*
{
		for $AllowChg in $inElem
		return 
		<ChargesAllowances>
		{
			if ($AllowChg/*:SAC/*:AllowOrChrgInd) then
			<AllowChrgIndicator>
				{
				$AllowChg/*:SAC/*:AllowOrChrgInd/text()
				}
			</AllowChrgIndicator>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:SrvcPromAllowOr) then
			<AllowChrgCode>
				{
				$AllowChg/*:SAC/*:SrvcPromAllowOr/text()
				}
			</AllowChrgCode>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:AgncQualCode) then
			<AllowChrgAgencyCode>
				{
				$AllowChg/*:SAC/*:AgncQualCode/text()
				}
			</AllowChrgAgencyCode>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:AgncSrvcProm) then
			<AllowChrgAgency>
				{
				$AllowChg/*:SAC/*:AgncSrvcProm/text()
				}
			</AllowChrgAgency>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:Amnt) then
			<AllowChrgAmt>
				{
				$AllowChg/*:SAC/*:Amnt/text()
				}
			</AllowChrgAmt>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:AllowChrgPrctQual) then
			<AllowChrgPercentBasis>
				{
				$AllowChg/*:SAC/*:AllowChrgPrctQual/text()
				}
			</AllowChrgPercentBasis>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:Prct) then
			<AllowChrgPercent>
				{
				$AllowChg/*:SAC/*:Prct/text()
				}
			</AllowChrgPercent>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:Rate) then
			<AllowChrgRate>
				{
				$AllowChg/*:SAC/*:Rate/text()
				}
			</AllowChrgRate>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:UorBforM) then
			<AllowChrgQtyUOM>
				{
				$AllowChg/*:SAC/*:UorBforM/text()
				}
			</AllowChrgQtyUOM>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:Qnty) then
			<AllowChrgQty>
				{
				$AllowChg/*:SAC/*:Qnty/text()
				}
			</AllowChrgQty>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:AllowOrChrgMthdOf) then
			<AllowChrgHandlingCode>
				{
				$AllowChg/*:SAC/*:AllowOrChrgMthdOf/text()
				}
			</AllowChrgHandlingCode>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:RefIdn) then
			<ReferenceIdentification>
				{
				$AllowChg/*:SAC/*:RefIdn/text()
				}
			</ReferenceIdentification>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:Descr) then
			<AllowChrgHandlingDescription>
				{
				$AllowChg/*:SAC/*:Descr/text()
				}
			</AllowChrgHandlingDescription>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:OptnNum) then
			<OptionNumber>
				{
				$AllowChg/*:SAC/*:OptnNum/text()
				}
			</OptionNumber>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:Qnty1) then
			<AllowChrgQty2>
				{
				$AllowChg/*:SAC/*:Qnty1/text()
				}
			</AllowChrgQty2>
			else()
		}
		{
			if ($AllowChg/*:SAC/*:LangCd) then
			<LanguageCode>
				{
				$AllowChg/*:SAC/*:LangCd/text()
				}
			</LanguageCode>
			else()
		}
		</ChargesAllowances>
};

declare function local:fnGetItemQualsFromBaseIT1($inElem as element()*) as element()*
{
let $It1 := $inElem/*:IT1
return
<LineInformation>
	{
	if ($It1/*:ProdSrvcIdQual or $It1/*:ProdSrvcId) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual1 or $It1/*:ProdSrvcId1) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual1) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual1/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId1) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId1/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual2 or $It1/*:ProdSrvcId2) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual2) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual2/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId2) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId2/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual3 or $It1/*:ProdSrvcId3) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual3) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual3/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId3) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId3/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual4 or $It1/*:ProdSrvcId4) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual4) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual4/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId4) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId4/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual5 or $It1/*:ProdSrvcId5) then
	<LineInfo>
	{
		if ($It1/*:ProdSrvcIdQual5) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual5/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId5) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId5/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual6 or $It1/*:ProdSrvcId6) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual6) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual6/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId6) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId6/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual7 or $It1/*:ProdSrvcId7) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual7) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual7/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId7) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId7/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual8 or $It1/*:ProdSrvcId8) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual8) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual8/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId8) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId8/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual9 or $It1/*:ProdSrvcId9) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual9) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual9/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId9) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId9/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	for $Ref in $inElem/*:REF
	where $Ref/*:RefIdnQual and $Ref/*:RefIdn and starts-with($Ref/*:RefIdnQual/text(), '!')
	return
	<LineInfo>
		<ProdSrvcIdQual>
		{
		substring-after($Ref/*:RefIdnQual/text(), '!')
		}
		</ProdSrvcIdQual>
		<ProdSrvcId>
		{
		$Ref/*:RefIdn/text()
		}
		</ProdSrvcId>
	</LineInfo>
	}
</LineInformation>
};

declare function local:fnGetItemQualsFromSLN($inElem as element()*) as element()*
{
let $It1 := $inElem/*:SLN
return
<LineInformation>
	{
	if ($It1/*:ProdSrvcIdQual or $It1/*:ProdSrvcId) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual1 or $It1/*:ProdSrvcId1) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual1) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual1/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId1) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId1/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual2 or $It1/*:ProdSrvcId2) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual2) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual2/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId2) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId2/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual3 or $It1/*:ProdSrvcId3) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual3) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual3/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId3) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId3/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual4 or $It1/*:ProdSrvcId4) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual4) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual4/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId4) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId4/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual5 or $It1/*:ProdSrvcId5) then
	<LineInfo>
	{
		if ($It1/*:ProdSrvcIdQual5) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual5/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId5) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId5/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual6 or $It1/*:ProdSrvcId6) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual6) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual6/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId6) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId6/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual7 or $It1/*:ProdSrvcId7) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual7) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual7/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId7) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId7/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual8 or $It1/*:ProdSrvcId8) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual8) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual8/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId8) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId8/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	if ($It1/*:ProdSrvcIdQual9 or $It1/*:ProdSrvcId9) then
	<LineInfo>
		{
		if ($It1/*:ProdSrvcIdQual9) then
		<ProdSrvcIdQual>
		{
		$It1/*:ProdSrvcIdQual9/text()
		}
		</ProdSrvcIdQual>
		else()
		}
		{
		if ($It1/*:ProdSrvcId9) then
		<ProdSrvcId>
		{
		$It1/*:ProdSrvcId9/text()
		}
		</ProdSrvcId>
		else()
		}
	</LineInfo>
	else()
	}
	{
	for $Ref in $inElem/*:REF
	where $Ref/*:RefIdnQual and $Ref/*:RefIdn and starts-with($Ref/*:RefIdnQual/text(), '!')
	return
	<LineInfo>
		<ProdSrvcIdQual>
		{
		substring-after($Ref/*:RefIdnQual/text(), '!')
		}
		</ProdSrvcIdQual>
		<ProdSrvcId>
		{
		$Ref/*:RefIdn/text()
		}
		</ProdSrvcId>
	</LineInfo>
	}
	</LineInformation>

};

declare function local:fnLineSACToChargesAllowances($inElem as element()*) as element()*
{
	for $LineAllowChg in $inElem
	return 
	<ChargesAllowances>
	{
		if ($LineAllowChg/*:SAC/*:AllowOrChrgInd) then
		<AllowChrgIndicator>
			{
			$LineAllowChg/*:SAC/*:AllowOrChrgInd/text()
			}
		</AllowChrgIndicator>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:SrvcPromAllowOr) then
		<AllowChrgCode>
			{
			$LineAllowChg/*:SAC/*:SrvcPromAllowOr/text()
			}
		</AllowChrgCode>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:AgncQualCode) then
		<AllowChrgAgencyCode>
			{
			$LineAllowChg/*:SAC/*:AgncQualCode/text()
			}
		</AllowChrgAgencyCode>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:AgncSrvcProm) then
		<AllowChrgAgency>
			{
			$LineAllowChg/*:SAC/*:AgncSrvcProm/text()
			}
		</AllowChrgAgency>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:Amnt) then
		<AllowChrgAmt>
			{
			$LineAllowChg/*:SAC/*:Amnt/text()
			}
		</AllowChrgAmt>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:AllowChrgPrctQual) then
		<AllowChrgPercentBasis>
			{
			$LineAllowChg/*:SAC/*:AllowChrgPrctQual/text()
			}
		</AllowChrgPercentBasis>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:Prct) then
		<AllowChrgPercent>
			{
			$LineAllowChg/*:SAC/*:Prct/text()
			}
		</AllowChrgPercent>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:Rate) then
		<AllowChrgRate>
			{
			$LineAllowChg/*:SAC/*:Rate/text()
			}
		</AllowChrgRate>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:UorBforM) then
		<AllowChrgQtyUOM>
			{
			$LineAllowChg/*:SAC/*:UorBforM/text()
			}
		</AllowChrgQtyUOM>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:Qnty) then
		<AllowChrgQty>
			{
			$LineAllowChg/*:SAC/*:Qnty/text()
			}
		</AllowChrgQty>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:AllowOrChrgMthdOf) then
		<AllowChrgHandlingCode>
			{
			$LineAllowChg/*:SAC/*:AllowOrChrgMthdOf/text()
			}
		</AllowChrgHandlingCode>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:RefIdn) then
		<ReferenceIdentification>
			{
			$LineAllowChg/*:SAC/*:RefIdn/text()
			}
		</ReferenceIdentification>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:Descr) then
		<AllowChrgHandlingDescription>
			{
			$LineAllowChg/*:SAC/*:Descr/text()
			}
		</AllowChrgHandlingDescription>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:OptnNum) then
		<OptionNumber>
			{
			$LineAllowChg/*:SAC/*:OptnNum/text()
			}
		</OptionNumber>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:Qnty1) then
		<AllowChrgQty2>
			{
			$LineAllowChg/*:SAC/*:Qnty1/text()
			}
		</AllowChrgQty2>
		else()
	}
	{
		if ($LineAllowChg/*:SAC/*:LangCd) then
		<LanguageCode>
			{
			$LineAllowChg/*:SAC/*:LangCd/text()
			}
		</LanguageCode>
		else()
	}
	</ChargesAllowances>

};



let $InvoiceDoc := /*:X12_810_4030Class/*:TS_810
return
<Invoices>
	<Invoice>
		<Header>
			<InvoiceHeader>
			{
			if ($InvoiceDoc/*:HDR/*:ClientCode) then
				<TradingPartnerId>
					{
						$InvoiceDoc/*:HDR/*:ClientCode/text()
					}
				</TradingPartnerId>
			else()
			}
			{
			if ($InvoiceDoc/*:BIG/*:InvoiceNumber) then
				<InvoiceNumber>
					{
						$InvoiceDoc/*:BIG/*:InvoiceNumber/text()
					}
				</InvoiceNumber>
			else()
			}
			{
			if ($InvoiceDoc/*:BIG/*:Date) then
				<InvoiceDate>
					{
						local:fnEDIDateToSPSDate($InvoiceDoc/*:BIG/*:Date/text())
					}
				</InvoiceDate>
			else()
			}
			{
			if ($InvoiceDoc/*:BIG/*:Date1) then
				<PurchaseOrderDate>
					{
						local:fnEDIDateToSPSDate($InvoiceDoc/*:BIG/*:Date1/text())
					}
				</PurchaseOrderDate>
			else()
			}
			{
			if ($InvoiceDoc/*:BIG/*:PurchaseOrderNumber) then
				<PurchaseOrderNumber>
					{
						$InvoiceDoc/*:BIG/*:PurchaseOrderNumber/text()
					}
				</PurchaseOrderNumber>
			else()
			}
			{
			if ($InvoiceDoc/*:BIG/*:ReleaseNumber) then
				<ReleaseNumber>
					{
						$InvoiceDoc/*:BIG/*:ReleaseNumber/text()
					}
				</ReleaseNumber>
			else()
			}
			{
			if ($InvoiceDoc/*:BIG/*:TransTypCd) then
				<InvoiceTypeCode>
					{
						$InvoiceDoc/*:BIG/*:TransTypCd/text()
					}
				</InvoiceTypeCode>
			else()
			}
			{
			if ($InvoiceDoc/*:BIG/*:TransSetPurpCd) then
				<TsetPurposeCode>
					{
						$InvoiceDoc/*:BIG/*:TransSetPurpCd/text()
					}
				</TsetPurposeCode>
			else()
			}
			{
			if ($InvoiceDoc/*:BIG/*:ActionCode) then
				<ActionCode>
					{
						$InvoiceDoc/*:BIG/*:ActionCode/text()
					}
				</ActionCode>
			else()
			}
			{
			if ($InvoiceDoc/*:CUR[*:EntityIdrCd='BY']/*:CurncCd) then
				<BuyersCurrency>
					{
						$InvoiceDoc/*:CUR[*:EntityIdrCd='BY']/*:CurncCd/text()
					}
				</BuyersCurrency>
			else()
			}
			{
			if ($InvoiceDoc/*:CUR[*:EntityIdrCd='SE']/*:CurncCd) then
				<SellersCurrency>
					{
						$InvoiceDoc/*:CUR[*:EntityIdrCd='SE']/*:CurncCd/text()
					}
				</SellersCurrency>
			else()
			}
			{
			if ($InvoiceDoc/*:CUR[*:EntityIdrCd='BY']/*:ExchRt) then
				<ExchangeRate>
					{
						$InvoiceDoc/*:CUR[*:EntityIdrCd='BY']/*:ExchRt/text()
					}
				</ExchangeRate>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='DP']/*:RefIdn) then
				<Department>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='DP']/*:RefIdn/text()
					}
				</Department>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='IA']/*:RefIdn) then
				<Vendor>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='IA']/*:RefIdn/text()
					}
				</Vendor>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='SW']/*:RefIdn) then
				<InternalOrderNumber>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='SW']/*:RefIdn/substring(text(), 1, 10)
					}
				</InternalOrderNumber>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='9R']/*:RefIdn) then
				<JobNumber>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='9R']/*:RefIdn/text()
					}
				</JobNumber>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='19']/*:RefIdn) then
				<Division>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='19']/*:RefIdn/text()
					}
				</Division>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='NB']/*:RefIdn) then
				<LetterOFCredit>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='NB']/*:RefIdn/text()
					}
				</LetterOFCredit>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='11']/*:RefIdn) then
				<CustomerAccountNumber>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='11']/*:RefIdn/text()
					}
				</CustomerAccountNumber>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='CO']/*:RefIdn) then
				<CustomerOrderNumber>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='CO']/*:RefIdn/text()
					}
				</CustomerOrderNumber>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='PD']/*:RefIdn) then
				<PromotionDealNumber>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='PD']/*:RefIdn/text()
					}
				</PromotionDealNumber>
			else()
			}
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='PD']/*:Descr) then
				<PromotionDealDescription>
					{
						$InvoiceDoc/*:REF[*:RefIdnQual='PD']/*:Descr/text()
					}
				</PromotionDealDescription>
			else()
			}			
			{
			if ($InvoiceDoc/*:FOB[1]/*:ShpmntMthdOfPmnt) then
				<FOBPayCode>
					{
						$InvoiceDoc/*:FOB[1]/*:ShpmntMthdOfPmnt/text()
					}
				</FOBPayCode>
			else()
			}
			{
			if ($InvoiceDoc/*:FOB[1]/*:LocQual) then
				<FOBLocationQualifier>
					{
						$InvoiceDoc/*:FOB[1]/*:LocQual/text()
					}
				</FOBLocationQualifier>
			else()
			}
			{
			if ($InvoiceDoc/*:FOB[1]/*:Descr) then
				<FOBLocationDescription>
					{
						$InvoiceDoc/*:FOB[1]/*:Descr/text()
					}
				</FOBLocationDescription>
			else()
			}
			{
			if ($InvoiceDoc/*:FOB[1]/*:LocQual1) then
				<FOBTitlePassageCode>
					{
						$InvoiceDoc/*:FOB[1]/*:LocQual1/text()
					}
				</FOBTitlePassageCode>
			else()
			}
			{
			if ($InvoiceDoc/*:FOB[1]/*:Descr1) then
				<FOBTitlePassageLocation>
					{
						$InvoiceDoc/*:FOB[1]/*:Descr1/text()
					}
				</FOBTitlePassageLocation>
			else()
			}	
			{
			if ($InvoiceDoc/*:CAD[1]/*:TransMthdTypCd) then
			<CarrierTransMethodCode>
				{
				$InvoiceDoc/*:CAD[1]/*:TransMthdTypCd/text()
				}
			</CarrierTransMethodCode>
			else()
			}
			{
			if ($InvoiceDoc/*:CAD[1]/*:EqpmntInitial) then
			<CarrierEquipmentInitial>
				{
				$InvoiceDoc/*:CAD[1]/*:EqpmntInitial/text()
				}
			</CarrierEquipmentInitial>
			else()
			}
			{
			if ($InvoiceDoc/*:CAD[1]/*:EqpmntNum) then
			<CarrierEquipmentNumber>
				{
				$InvoiceDoc/*:CAD[1]/*:EqpmntNum/text()
				}
			</CarrierEquipmentNumber>
			else()
			}
			{
			if ($InvoiceDoc/*:CAD[1]/*:StndrdCarrierAlphaCd) then
			<CarrierAlphaCode>
				{
				$InvoiceDoc/*:CAD[1]/*:StndrdCarrierAlphaCd/text()
				}
			</CarrierAlphaCode>
			else()
			}
			{
			if ($InvoiceDoc/*:CAD[1]/*:Routing) then
			<CarrierRouting>
				{
				$InvoiceDoc/*:CAD[1]/*:Routing/text()
				}
			</CarrierRouting>
			else()
			}
			{
			if ($InvoiceDoc/*:CAD[1]/*:ShpmntOrdrStatCd) then
			<ShipmentStatusCode>
				{
				$InvoiceDoc/*:CAD[1]/*:ShpmntOrdrStatCd/text()
				}
			</ShipmentStatusCode>
			else()
			}	
			{
			if ($InvoiceDoc/*:CAD[*:RefIdnQual='CN']/*:RefIdn) then
			<CarrierProNumber>
				{
				$InvoiceDoc/*:CAD[*:RefIdnQual='CN']/*:RefIdn/text()
				}
			</CarrierProNumber>
			else()
			}	
			{
			if ($InvoiceDoc/*:REF[*:RefIdnQual='BM']/*:RefIdn) then
			<BillOfLadingNumber>
				{
				$InvoiceDoc/*:REF[*:RefIdnQual='BM']/*:RefIdn/text()
				}
			</BillOfLadingNumber>
			else()
			}	
			{
			if ($InvoiceDoc/*:DTM[*:DateTimeQual='011']/*:Date) then
			<ShipDate>
				{
				local:fnEDIDateToSPSDate($InvoiceDoc/*:DTM[*:DateTimeQual='011']/*:Date/text())
				}
			</ShipDate>
			else()
			}
			{
			if ($InvoiceDoc/*:DTM[*:DateTimeQual='035']/*:Date) then
			<ShipDeliveryDate>
				{
				local:fnEDIDateToSPSDate($InvoiceDoc/*:DTM[*:DateTimeQual='035']/*:Date/text())
				}
			</ShipDeliveryDate>
			else()
			}
			{
			if ($InvoiceDoc/*:DTM[*:DateTimeQual='035']/*:Time) then
			<ShipDeliveryTime>
				{
				local:fnEDITimeToSPSTime($InvoiceDoc/*:DTM[*:DateTimeQual='035']/*:Time/text())
				}
			</ShipDeliveryTime>
			else()
			}
			
			</InvoiceHeader>
		{
		if ($InvoiceDoc/*:ITD) then
		local:fnITDToPaymentTerms($InvoiceDoc/*:ITD)
		else()
		}
		{
		if ($InvoiceDoc/*:DTM) then
		local:fnDTMToDate($InvoiceDoc/*:DTM)
		else()
		}
		{
		if ($InvoiceDoc/*:PER) then
		local:fnPERToContact($InvoiceDoc/*:PER)
		else()
		}
		{
		for $Address in $InvoiceDoc/*:BaseN1Grp
		return
		<Address>
			{
			if ($Address/*:N1/*:EntityIdrCd) then
			<AddressTypeCode>
			{
				$Address/*:N1/*:EntityIdrCd/text()
			}
			</AddressTypeCode>
			else()
			}
			{
			if ($Address/*:N1/*:IdnCdQual) then
			<LocationCodeQualifier>
				{
				$Address/*:N1/*:IdnCdQual/text()
				}
			</LocationCodeQualifier>
			else()
			}
			{
			if ($Address/*:N1/*:IdnCd) then
			<AddressLocationNumber>
				{
				$Address/*:N1/*:IdnCd/text()
				}
			</AddressLocationNumber>
			else()
			}
			{
			if ($Address/*:N1/*:Name) then
			<AddressName>
				{
				$Address/*:N1/*:Name/text()
				}
			</AddressName>
			else()
			}
			{
			if ($Address/*:N2/*:Name) then
			<AddressAlternateName>
				{
				$Address/*:N2/*:Name/text()
				}
			</AddressAlternateName>
			else()
			}
			{
			if ($Address/*:N3[1]/*:AddrInfo) then
			<Address1>
				{
				$Address/*:N3[1]/*:AddrInfo/text()
				}
			</Address1>
			else()
			}
			{
			if ($Address/*:N3[2]/*:AddrInfo) then
			<Address2>
				{
				$Address/*:N3[2]/*:AddrInfo/text()
				}
			</Address2>
			else()
			}
			{
			if ($Address/*:N3[3]/*:AddrInfo) then
			<Address3>
				{
				$Address/*:N3[3]/*:AddrInfo/text()
				}
			</Address3>
			else()
			}
			{
			if ($Address/*:N3[4]/*:AddrInfo) then
			<Address4>
				{
				$Address/*:N3[4]/*:AddrInfo/text()
				}
			</Address4>
			else()
			}
			{
			if ($Address/*:N4/*:CityName) then
			<City>
				{
				$Address/*:N4/*:CityName/text()
				}
			</City>
			else()
			}
			{
			if ($Address/*:N4/*:StateOrProvinceCode) then
			<State>
				{
				$Address/*:N4/*:StateOrProvinceCode/text()
				}
			</State>
			else()
			}
			{
			if ($Address/*:N4/*:PostalCode) then
			<PostalCode>
				{
				$Address/*:N4/*:PostalCode/text()
				}
			</PostalCode>
			else()
			}
			{
			if ($Address/*:N4/*:CountryCode) then
			<Country>
				{
				$Address/*:N4/*:CountryCode/text()
				}
			</Country>
			else()
			}
			{
			if ($Address/*:N4/*:LocQual and $Address/*:N4/*:LocIdr) then
			<LocQual>
			{
			$Address/*:N4/*:LocQual/text()
			}
			</LocQual>
			else()
			}
			{
			if ($Address/*:N4/*:LocQual and $Address/*:N4/*:LocIdr) then
			<LocationID>
			{
			$Address/*:N4/*:LocIdr/text()
			}
			</LocationID>
			else()
			}
			{
			if ($Address/*:N4/*:CountrySubdivisionCode) then
			<CountrySubDivision>
			{
			$Address/*:N4/*:CountrySubdivisionCode/text()
			}
			</CountrySubDivision>
			else()
			}
			{
			if ($Address/*:REF) then
			local:fnREFToReference($Address/*:REF)
			else()
			}
			{
			if ($Address/*:PER) then
			local:fnPERToContact($Address/*:PER)
			else()
			}
		</Address>
		}
		{
		for $AddrRef in $InvoiceDoc/*:REF
			where $AddrRef/*:RefIdnQual/text() != 'IA' and $AddrRef/*:RefIdnQual/text() != 'NB' and $AddrRef/*:RefIdnQual/text() != 'DP' and $AddrRef/*:RefIdnQual/text() != '9R' and $AddrRef/*:RefIdnQual/text() != '19' and $AddrRef/*:RefIdnQual/text() != '11' and $AddrRef/*:RefIdnQual/text() != 'CO' and $AddrRef/*:RefIdnQual/text() != 'PD'
		return 
		<Reference>
			{
			if ($AddrRef/*:RefIdnQual) then
			<ReferenceQual>
				{
				$AddrRef/*:RefIdnQual/text()
				}
			</ReferenceQual>
			else()
			}
			{
			if ($AddrRef/*:RefIdnQual/text() = 'SW') then
			<ReferenceID>
				{
				$AddrRef/*:RefIdn/substring(text(), 1, 10)
				}
			</ReferenceID>
			else
			<ReferenceID>
				{
				$AddrRef/*:RefIdn/text()
				}
			</ReferenceID>
			}
			{
			if ($AddrRef/*:Descr) then
			<Description>
				{
				$AddrRef/*:Descr/text()
				}
			</Description>
			else()
			}
			{
			if ($AddrRef/*:RefIdr/*:RefIdnQual or $AddrRef/*:RefIdr/*:RefIdn or $AddrRef/*:RefIdr/*:RefIdnQual1 or $AddrRef/*:RefIdr/*:RefIdn1 or $AddrRef/*:RefIdr/*:RefIdnQual2 or $AddrRef/*:RefIdr/*:RefIdn2) then
				<ReferenceIDs>
				{
					if ($AddrRef/*:RefIdr/*:RefIdnQual) then
					<ReferenceQual>
					{
					$AddrRef/*:RefIdr/*:RefIdnQual/text()
					}
					</ReferenceQual>
					else()
				}
				{
					if ($AddrRef/*:RefIdr/*:RefIdn) then
					<ReferenceID>
					{
					$AddrRef/*:RefIdr/*:RefIdn/text()
					}
					</ReferenceID>
					else()
				}
				{
					if ($AddrRef/*:RefIdr/*:RefIdnQual1) then
					<ReferenceQual>
					{
					$AddrRef/*:RefIdr/*:RefIdnQual1/text()
					}
					</ReferenceQual>
					else()
				}
				{
					if ($AddrRef/*:RefIdr/*:RefIdn1) then
					<ReferenceID>
					{
					$AddrRef/*:RefIdr/*:RefIdn1/text()
					}
					</ReferenceID>
					else()
				}
				{
					if ($AddrRef/*:RefIdr/*:RefIdnQual2) then
					<ReferenceQual>
					{
					$AddrRef/*:RefIdr/*:RefIdnQual2/text()
					}
					</ReferenceQual>
					else()
				}
				{
					if ($AddrRef/*:RefIdr/*:RefIdn2) then
					<ReferenceID>
					{
					$AddrRef/*:RefIdr/*:RefIdn2/text()
					}
					</ReferenceID>
					else()
				}
				</ReferenceIDs>
				else()
			}
		</Reference>
		}
		{
		if ($InvoiceDoc/*:NTE) then
		local:fnNTEToNotes($InvoiceDoc/*:NTE)
		else()
		}
		{
		if ($InvoiceDoc/*:BaseSACGrp) then
		local:fnBaseSACToChargesAllowances($InvoiceDoc/*:BaseSACGrp)
		else()
		}
		</Header>
		<LineItems>
		{
		for $LineItem in $InvoiceDoc/*:BaseIT1Grp
		let $itemInfo := local:fnGetItemQualsFromBaseIT1($LineItem)
		return
			<LineItem>
				<InvoiceLine>
				{
				if ($LineItem/*:IT1/*:AsgndIdn) then
				<LineSequenceNumber>
				{
				$LineItem/*:IT1/*:AsgndIdn/text()
				}
				</LineSequenceNumber>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UC']/*:ProdSrvcId) then
				<ApplicationID>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UC']/*:ProdSrvcId/text()
				}
				</ApplicationID>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'BP']/*:ProdSrvcId) then
				<BuyerPartNumber>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'BP']/*:ProdSrvcId/text()
				}
				</BuyerPartNumber>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'VN']/*:ProdSrvcId) then
				<VendorPartNumber>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'VN']/*:ProdSrvcId/text()
				}
				</VendorPartNumber>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UP']/*:ProdSrvcId) then
				<ConsumerPackageCode>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UP']/*:ProdSrvcId/text()
				}
				</ConsumerPackageCode>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'EN']/*:ProdSrvcId) then
				<EAN>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'EN']/*:ProdSrvcId/text()
				}
				</EAN>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UK']/*:ProdSrvcId) then
				<GTIN>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UK']/*:ProdSrvcId/text()
				}
				</GTIN>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UN']/*:ProdSrvcId) then
				<UPCCaseCode>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UN']/*:ProdSrvcId/text()
				}
				</UPCCaseCode>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'ND']/*:ProdSrvcId) then
				<NatlDrugCode>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'ND']/*:ProdSrvcId/text()
				}
				</NatlDrugCode>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'IB']/*:ProdSrvcId) then
				<InternationalStandardBookNumber>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'IB']/*:ProdSrvcId/text()
				}
				</InternationalStandardBookNumber>
				else()
				}
				{
				for $ProdNum in $itemInfo/*:LineInfo
				where fn:contains('IB,ND,UN,UK,EN,UP,VN,BP,UC,IZ,BO,FP,PR,C3,SC,CM,SM', $ProdNum/*:ProdSrvcIdQual/text()) = fn:false()
				return
				<ProductID>
					{
					if ($ProdNum/*:ProdSrvcIdQual) then
					<PartNumberQual>
						{
						$ProdNum/*:ProdSrvcIdQual/text()
						}
					</PartNumberQual>
					else()
					}
					{
					if ($ProdNum/*:ProdSrvcId) then
					<PartNumber>
						{
						$ProdNum/*:ProdSrvcId/text()
						}
					</PartNumber>
					else()
					}
				</ProductID>
				}

				{
				if ($LineItem/*:IT1/*:QntyInvoiced) then
				<OrderQty>
					{
					$LineItem/*:IT1/*:QntyInvoiced/text()
					}
				</OrderQty>
				else()
				}
				{
				if ($LineItem/*:IT1/*:UorBforM) then
				<OrderQtyUOM>
					{
					$LineItem/*:IT1/*:UorBforM/text()
					}
				</OrderQtyUOM>
				else()
				}
				{
				if ($LineItem/*:IT1/*:UnitPrc) then
				<UnitPrice>
					{
					$LineItem/*:IT1/*:UnitPrc/text()
					}
				</UnitPrice>
				else()
				}
				{
				if ($LineItem/*:IT1/*:BofUPrcCd) then
				<UnitPriceBasis>
					{
					$LineItem/*:IT1/*:BofUPrcCd/text()
					}
				</UnitPriceBasis>
				else()
				}
				{
				if ($LineItem/*:CTP[*:PrcIdrCd/text() = 'RTL']/*:UnitPrc) then
				<RetailUnitPrice>
					{
					$LineItem/*:CTP[*:PrcIdrCd/text() = 'RTL']/*:UnitPrc/text()
					}
				</RetailUnitPrice>
				else()
				}
				{
				if ($LineItem/*:CTP[*:PrcIdrCd/text() = 'MSR']/*:UnitPrc) then
				<MfgSuggestedRetailPrice>
					{
					$LineItem/*:CTP[*:PrcIdrCd/text() = 'MSR']/*:UnitPrc/text()
					}
				</MfgSuggestedRetailPrice>
				else()
				}
				{
				if ($LineItem/*:PO4/*:Pack) then
				<OuterPack>
					{
					$LineItem/*:PO4/*:Pack/text()
					}
				</OuterPack>
				else()
				}
				{
				if ($LineItem/*:PO4/*:Size) then
				<PackSize>
					{
					$LineItem/*:PO4/*:Size/text()
					}
				</PackSize>
				else()
				}
				{
				if ($LineItem/*:PO4/*:UorBforM) then
				<PackUOM>
					{
					$LineItem/*:PO4/*:UorBforM/text()
					}
				</PackUOM>
				else()
				}
				{
				if ($LineItem/*:PO4/*:PckgngCd) then
				<PackCode>
					{
					$LineItem/*:PO4/*:PckgngCd/text()
					}
				</PackCode>
				else()
				}
				{
				if ($LineItem/*:PO4/*:WghtQual) then
				<WeightQualifier>
					{
					$LineItem/*:PO4/*:WghtQual/text()
					}
				</WeightQualifier>
				else()
				}
				{
				if ($LineItem/*:PO4/*:GrsWghtPerPack) then
				<PackWeight>
					{
					$LineItem/*:PO4/*:GrsWghtPerPack/text()
					}
				</PackWeight>
				else()
				}
				{
				if ($LineItem/*:PO4/*:UorBforM1) then
				<PackWeightUOM>
					{
					$LineItem/*:PO4/*:UorBforM1/text()
					}
				</PackWeightUOM>
				else()
				}
				{
				if ($LineItem/*:PO4/*:GrsVolPerPack) then
				<PackVolume>
					{
					$LineItem/*:PO4/*:GrsVolPerPack/text()
					}
				</PackVolume>
				else()
				}
				{
				if ($LineItem/*:PO4/*:UorBforM2) then
				<PackVolumeUOM>
					{
					$LineItem/*:PO4/*:UorBforM2/text()
					}
				</PackVolumeUOM>
				else()
				}
				{
				if ($LineItem/*:PO4/*:Length) then
				<PackLength>
					{
					$LineItem/*:PO4/*:Length/text()
					}
				</PackLength>
				else()
				}
				{
				if ($LineItem/*:PO4/*:Width) then
				<PackWidth>
					{
					$LineItem/*:PO4/*:Width/text()
					}
				</PackWidth>
				else()
				}
				{
				if ($LineItem/*:PO4/*:Height) then
				<PackHeight>
					{
					$LineItem/*:PO4/*:Height/text()
					}
				</PackHeight>
				else()
				}
				{
				if ($LineItem/*:PO4/*:UorBforM3) then
				<PackDimensionUOM>
					{
					$LineItem/*:PO4/*:UorBforM3/text()
					}
				</PackDimensionUOM>
				else()
				}
				{
				if ($LineItem/*:PO4/*:InnerPack) then
				<InnerPack>
					{
					$LineItem/*:PO4/*:InnerPack/text()
					}
				</InnerPack>
				else()
				}
				{
				if ($LineItem/*:PO4/*:SrfcLyrPosnCd) then
				<SurfaceLayerPositionCode>
					{
					$LineItem/*:PO4/*:SrfcLyrPosnCd/text()
					}
				</SurfaceLayerPositionCode>
				else()
				}
				{
				if ($LineItem/*:PO4/*:AsgndIdn) then
				<AssignedID>
					{
					$LineItem/*:PO4/*:AsgndIdn/text()
					}
				</AssignedID>
				else()
				}				
				{
				if ($LineItem/*:IT3/*:NumOfUnitsShpd) then
				<ShipQty>
					{
					$LineItem/*:IT3/*:NumOfUnitsShpd/text()
					}
				</ShipQty>
				else()
				}
				{
				if ($LineItem/*:IT3/*:UorBforM) then
				<ShipQtyUOM>
					{
					$LineItem/*:IT3/*:UorBforM/text()
					}
				</ShipQtyUOM>
				else()
				}
				{
				if ($LineItem/*:DTM[*:DateTimeQual/text() = '011']/*:Date) then
				<ShipDate>
					{
					local:fnEDIDateToSPSDate($LineItem/*:DTM[*:DateTimeQual/text() = '011']/*:Date/text())
					}
				</ShipDate>
				else()
				}
				{
				if ($LineItem/*:IT3/*:QntyDifference) then
				<QtyLeftToReceive>
					{
					$LineItem/*:IT3/*:QntyDifference/text()
					}
				</QtyLeftToReceive>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'IZ']/*:ProdSrvcId) then
				<ProductSizeCode>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'IZ']/*:ProdSrvcId/text()
				}
				</ProductSizeCode>
				else()
				}
				{
				if ($LineItem/*:REF[*:RefIdnQual/text() = '#IZ']/*:RefIdn) then
				<ProductSizeDescription>
					{
					$LineItem/*:REF[*:RefIdnQual/text() = '#IZ']/*:RefIdn/text()
					}
				</ProductSizeDescription>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'BO']/*:ProdSrvcId) then
				<ProductColorCode>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'BO']/*:ProdSrvcId/text()
				}
				</ProductColorCode>
				else()
				}
				{
				if ($LineItem/*:REF[*:RefIdnQual/text() = '#BO']/*:RefIdn) then
				<ProductColorDescription>
					{
					$LineItem/*:REF[*:RefIdnQual/text() = '#BO']/*:RefIdn/text()
					}
				</ProductColorDescription>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'FP']/*:ProdSrvcId) then
				<ProductFabricCode>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'FP']/*:ProdSrvcId/text()
				}
				</ProductFabricCode>
				else()
				}
				{
				if ($LineItem/*:REF[*:RefIdnQual/text() = '#FP']/*:RefIdn) then
				<ProductFabricDescription>
					{
					$LineItem/*:REF[*:RefIdnQual/text() = '#FP']/*:RefIdn/text()
					}
				</ProductFabricDescription>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'PR']/*:ProdSrvcId) then
				<ProductProcessCode>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'PR']/*:ProdSrvcId/text()
				}
				</ProductProcessCode>
				else()
				}
				{
				if ($LineItem/*:REF[*:RefIdnQual/text() = '#PR']/*:RefIdn) then
				<ProductProcessDescription>
					{
					$LineItem/*:REF[*:RefIdnQual/text() = '#PR']/*:RefIdn/text()
					}
				</ProductProcessDescription>
				else()
				}
				{
				if ($LineItem/*:REF[*:RefIdnQual/text() = 'DP']/*:RefIdn) then
				<Department>
					{
					$LineItem/*:REF[*:RefIdnQual/text() = 'DP']/*:RefIdn/text()
					}
				</Department>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'C3']/*:ProdSrvcId) then
				<Class>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'C3']/*:ProdSrvcId/text()
				}
				</Class>
				else()
				}
				{
				if ($LineItem/*:REF[*:RefIdnQual/text() = '5E']/*:RefIdn) then
				<Gender>
					{
					$LineItem/*:REF[*:RefIdnQual/text() = '5E']/*:RefIdn/text()
					}
				</Gender>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'SC']/*:ProdSrvcId) then
				<SellerDateCode>
				{
				$itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'SC']/*:ProdSrvcId/text()
				}
				</SellerDateCode>
				else()
				}
				{
				if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual='SM']/*:ProdSrvcId or $itemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'CM']/*:ProdSrvcId) then
				<NRFStandardColorAndSize>
					{
					if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual='CM']/*:ProdSrvcId) then
					<NRFColorCode>
						{
						$itemInfo/*:LineInfo[*:ProdSrvcIdQual='CM']/*:ProdSrvcId/text()
						}
					</NRFColorCode>
					else()
					}
					{
					if ($itemInfo/*:LineInfo[*:ProdSrvcIdQual='SM']/*:ProdSrvcId) then
					<NRFSizeCode>
						{
						$itemInfo/*:LineInfo[*:ProdSrvcIdQual='SM']/*:ProdSrvcId/text()
						}
					</NRFSizeCode>
					else()
					}
				</NRFStandardColorAndSize>
				else()
				}
				</InvoiceLine>
				{
				if ($LineItem/*:MEA) then
				local:fnMEAToMeasurements($LineItem/*:MEA)
				else()
				}
				{
				for $ProdDesc in $LineItem/*:BaseIT1GrpPIDGrp
				return 
				<ProductOrItemDescription>
					{
					if ($ProdDesc/*:PID/*:ProdProcChrstc) then
					<ItemDescriptionType>
						{
						$ProdDesc/*:PID/*:ProdProcChrstc/text()
						}
					</ItemDescriptionType>
					else()
					}
					{
					if ($ProdDesc/*:PID/*:ItmDescrTyp) then
					<ProductCharacteristicCode>
						{
						$ProdDesc/*:PID/*:ItmDescrTyp/text()
						}
					</ProductCharacteristicCode>
					else()
					}
					{
					if ($ProdDesc/*:PID/*:AgncQualCode) then
					<AgencyQualifierCode>
						{
						$ProdDesc/*:PID/*:AgncQualCode/text()
						}
					</AgencyQualifierCode>
					else()
					}
					{
					if ($ProdDesc/*:PID/*:ProdDescrCd) then
					<ProductDescriptionCode>
						{
						$ProdDesc/*:PID/*:ProdDescrCd/text()
						}
					</ProductDescriptionCode>
					else()
					}
					{
					if ($ProdDesc/*:PID/*:Descr) then
					<ProductDescription>
						{
						$ProdDesc/*:PID/*:Descr/text()
						}
					</ProductDescription>
					else()
					}
					{
					if ($ProdDesc/*:PID/*:SrfcLyrPosnCd) then
					<SurfaceLayerPositionCode>
						{
						$ProdDesc/*:PID/*:SrfcLyrPosnCd/text()
						}
					</SurfaceLayerPositionCode>
					else()
					}
					{
					if ($ProdDesc/*:PID/*:SrcSubqual) then
					<SourceSubqualifier>
						{
						$ProdDesc/*:PID/*:SrcSubqual/text()
						}
					</SourceSubqualifier>
					else()
					}
					{
					if ($ProdDesc/*:PID/*:YorNCondResp) then
					<YesOrNoResponse>
						{
						$ProdDesc/*:PID/*:YorNCondResp/text()
						}
					</YesOrNoResponse>
					else()
					}
					{
					if ($ProdDesc/*:PID/*:LangCd) then
					<LanguageCode>
						{
						$ProdDesc/*:PID/*:LangCd/text()
						}
					</LanguageCode>
					else()
					}
				</ProductOrItemDescription>
				}
				{
				for $LineRef in $LineItem/*:REF
				where $LineRef/*:RefIdnQual/text() != '5E' and starts-with($LineRef/*:RefIdnQual/text(), '!') = false() and starts-with($LineRef/*:RefIdnQual/text(), '#') = false()
				return 
				<Reference>
					{
					if ($LineRef/*:RefIdnQual) then
					<ReferenceQual>
						{
						$LineRef/*:RefIdnQual/text()
						}
					</ReferenceQual>
					else()
					}
					{
					if ($LineRef/*:RefIdn) then
					<ReferenceID>
						{
						$LineRef/*:RefIdn/text()
						}
					</ReferenceID>
					else()
					}
					{
					if ($LineRef/*:Descr) then
					<Description>
						{
						$LineRef/*:Descr/text()
						}
					</Description>
					else()
					}
					{
					if ($LineRef/*:RefIdr/*:RefIdnQual or $LineRef/*:RefIdr/*:RefIdn) then
					<ReferenceIDs>
						{
							if ($LineRef/*:RefIdr/*:RefIdnQual) then
							<ReferenceQual>
							{
							$LineRef/*:RefIdr/*:RefIdnQual/text()
							}
							</ReferenceQual>
							else()
						}
						{
							if ($LineRef/*:RefIdr/*:RefIdn) then
							<ReferenceID>
							{
							$LineRef/*:RefIdr/*:RefIdn/text()
							}
							</ReferenceID>
							else()
						}
					</ReferenceIDs>
					else()
					}
					{
					if ($LineRef/*:RefIdr/*:RefIdnQual1 or $LineRef/*:RefIdr/*:RefIdn1) then
					<ReferenceIDs>
						{
							if ($LineRef/*:RefIdr/*:RefIdnQual1) then
							<ReferenceQual>
							{
							$LineRef/*:RefIdr/*:RefIdnQual1/text()
							}
							</ReferenceQual>
							else()
						}
						{
							if ($LineRef/*:RefIdr/*:RefIdn1) then
							<ReferenceID>
							{
							$LineRef/*:RefIdr/*:RefIdn1/text()
							}
							</ReferenceID>
							else()
						}
					</ReferenceIDs>
					else()
					}
					{
					if ($LineRef/*:RefIdr/*:RefIdnQual2 or $LineRef/*:RefIdr/*:RefIdn2) then
					<ReferenceIDs>
						{
							if ($LineRef/*:RefIdr/*:RefIdnQual2) then
							<ReferenceQual>
							{
							$LineRef/*:RefIdr/*:RefIdnQual2/text()
							}
							</ReferenceQual>
							else()
						}
						{
							if ($LineRef/*:RefIdr/*:RefIdn2) then
							<ReferenceID>
							{
							$LineRef/*:RefIdr/*:RefIdn2/text()
							}
							</ReferenceID>
							else()
						}
					</ReferenceIDs>
					else()
					}
				</Reference>
				}
				{
				for $Date in $LineItem/*:DTM
				where $Date/*:DateTimeQual/text() != '011'
				return 
				<Date>
					{
					if ($Date/*:DateTimeQual) then
					<DateTimeQualifier1>
						{
						$Date/*:DateTimeQual/text()
						}
					</DateTimeQualifier1>
					else()
					}
					{
					if ($Date/*:Date) then
					<Date1>
						{
						local:fnEDIDateToSPSDate($Date/*:Date/text())
						}
					</Date1>
					else()
					}
					{
					if ($Date/*:Time) then
					<Time1>
						{
						local:fnEDITimeToSPSTime($Date/*:Time/text())
						}
					</Time1>
					else()
					}
					{
					if ($Date/*:TimeCode) then
					<TimeCode1>
						{
						$Date/*:TimeCode/text()
						}
					</TimeCode1>
					else()
					}
					{
					if ($Date/*:DtTmPrdFmtQual) then
					<DateTimeFormQualifier1>
						{
						$Date/*:DtTmPrdFmtQual/text()
						}
					</DateTimeFormQualifier1>
					else()
					}
					{
					if ($Date/*:DtTmPrd) then
					<DateTimePeriod>
						{
						$Date/*:DtTmPrd/text()
						}
					</DateTimePeriod>
					else()
					}
				</Date>
				}
				{
				for $CarrierTD in $LineItem/*:CAD
				return 
				<CarrierTransportationDetail>
					{
					if ($CarrierTD/*:TransMthdTypCd) then
					<CarrierTransMethodCode>
						{
						$CarrierTD/*:TransMthdTypCd/text()
						}
					</CarrierTransMethodCode>
					else()
					}
					{
					if ($CarrierTD/*:EqpmntInitial) then
					<CarrierEquipmentInitial>
						{
						$CarrierTD/*:EqpmntInitial/text()
						}
					</CarrierEquipmentInitial>
					else()
					}
					{
					if ($CarrierTD/*:EqpmntNum) then
					<CarrierEquipmentNumber>
						{
						$CarrierTD/*:EqpmntNum/text()
						}
					</CarrierEquipmentNumber>
					else()
					}
					{
					if ($CarrierTD/*:StndrdCarrierAlphaCd) then
					<CarrierAlphaCode>
						{
						$CarrierTD/*:StndrdCarrierAlphaCd/text()
						}
					</CarrierAlphaCode>
					else()
					}
					{
					if ($CarrierTD/*:Routing) then
					<CarrierRouting>
						{
						$CarrierTD/*:Routing/text()
						}
					</CarrierRouting>
					else()
					}
					{
					if ($CarrierTD/*:ShpmntOrdrStatCd) then
					<ShipmentStatusCode>
						{
						$CarrierTD/*:ShpmntOrdrStatCd/text()
						}
					</ShipmentStatusCode>
					else()
					}
					{
					if ($CarrierTD[*:RefIdnQual='CN']/*:RefIdn) then
					<CarrierProNumber>
						{
						$CarrierTD/*:RefIdn/text()
						}
					</CarrierProNumber>
					else()
					}
					{
					if ($CarrierTD[*:RefIdnQual='BM']/*:RefIdn) then
					<BillOfLadingNumber>
						{
						$CarrierTD/*:RefIdn/text()
						}
					</BillOfLadingNumber>
					else()
					}
					{
					if ($CarrierTD/*:RefIdnQual) then
					<ReferenceQual>
						{
						$CarrierTD/*:RefIdnQual/text()
						}
					</ReferenceQual>
					else()
					}
					{
					if ($CarrierTD/*:RefIdn) then
					<ReferenceID>
						{
						$CarrierTD/*:RefIdn/text()
						}
					</ReferenceID>
					else()
					}
					{
					if ($CarrierTD/*:SrvcLvlCd) then
					<ServiceLevelCode>
						{
						$CarrierTD/*:SrvcLvlCd/text()
						}
					</ServiceLevelCode>
					else()
					}
				</CarrierTransportationDetail>
				}
				{
				if ($LineItem/*:PO1GrpSLNGrp) then
				<Sublines>
				{
				for $SubLine in $LineItem/*:PO1GrpSLNGrp
				let $subitemInfo := local:fnGetItemQualsFromSLN($SubLine)
				return
					<Subline>
						<SublineItemDetail>
						{
						if ($SubLine/*:SLN/*:AsgndIdn) then
						<LineSequenceNumber>
						{
						$SubLine/*:SLN/*:AsgndIdn/text()
						}
						</LineSequenceNumber>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UC']/*:ProdSrvcId) then
						<ApplicationID>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UC']/*:ProdSrvcId/text()
						}
						</ApplicationID>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'BP']/*:ProdSrvcId) then
						<BuyerPartNumber>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'BP']/*:ProdSrvcId/text()
						}
						</BuyerPartNumber>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'VN']/*:ProdSrvcId) then
						<VendorPartNumber>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'VN']/*:ProdSrvcId/text()
						}
						</VendorPartNumber>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UP']/*:ProdSrvcId) then
						<ConsumerPackageCode>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UP']/*:ProdSrvcId/text()
						}
						</ConsumerPackageCode>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'EN']/*:ProdSrvcId) then
						<EAN>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'EN']/*:ProdSrvcId/text()
						}
						</EAN>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UK']/*:ProdSrvcId) then
						<GTIN>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UK']/*:ProdSrvcId/text()
						}
						</GTIN>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UN']/*:ProdSrvcId) then
						<UPCCaseCode>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'UN']/*:ProdSrvcId/text()
						}
						</UPCCaseCode>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'ND']/*:ProdSrvcId) then
						<NatlDrugCode>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'ND']/*:ProdSrvcId/text()
						}
						</NatlDrugCode>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'IB']/*:ProdSrvcId) then
						<InternationalStandardBookNumber>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'IB']/*:ProdSrvcId/text()
						}
						</InternationalStandardBookNumber>
						else()
						}
						{
						for $ProdNum in $subitemInfo/*:LineInfo
						where fn:contains('IB,ND,UN,UK,EN,UP,VN,BP,UC,IZ,BO,FP,PR,C3,SC', $ProdNum/*:ProdSrvcIdQual/text()) = fn:false()
						return
						<ProductID>
							{
							if ($ProdNum/*:ProdSrvcIdQual) then
							<PartNumberQual>
								{
								$ProdNum/*:ProdSrvcIdQual/text()
								}
							</PartNumberQual>
							else()
							}
							{
							if ($ProdNum/*:ProdSrvcId) then
							<PartNumber>
								{
								$ProdNum/*:ProdSrvcId/text()
								}
							</PartNumber>
							else()
							}
						</ProductID>
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'IZ']/*:ProdSrvcId) then
						<ProductSizeCode>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'IZ']/*:ProdSrvcId/text()
						}
						</ProductSizeCode>
						else()
						}
						{
						if ($SubLine/*:REF[*:RefIdnQual/text() = '#IZ']/*:RefIdn) then
						<ProductSizeDescription>
							{
							$SubLine/*:REF[*:RefIdnQual/text() = '#IZ']/*:RefIdn/text()
							}
						</ProductSizeDescription>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'BO']/*:ProdSrvcId) then
						<ProductColorCode>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'BO']/*:ProdSrvcId/text()
						}
						</ProductColorCode>
						else()
						}
						{
						if ($SubLine/*:REF[*:RefIdnQual/text() = '#BO']/*:RefIdn) then
						<ProductColorDescription>
							{
							$SubLine/*:REF[*:RefIdnQual/text() = '#BO']/*:RefIdn/text()
							}
						</ProductColorDescription>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'FP']/*:ProdSrvcId) then
						<ProductFabricCode>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'FP']/*:ProdSrvcId/text()
						}
						</ProductFabricCode>
						else()
						}
						{
						if ($SubLine/*:REF[*:RefIdnQual/text() = '#FP']/*:RefIdn) then
						<ProductFabricDescription>
							{
							$SubLine/*:REF[*:RefIdnQual/text() = '#FP']/*:RefIdn/text()
							}
						</ProductFabricDescription>
						else()
						}
						{
						if ($subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'PR']/*:ProdSrvcId) then
						<ProductProcessCode>
						{
						$subitemInfo/*:LineInfo[*:ProdSrvcIdQual/text() = 'PR']/*:ProdSrvcId/text()
						}
						</ProductProcessCode>
						else()
						}
						{
						if ($SubLine/*:REF[*:RefIdnQual/text() = '#PR']/*:RefIdn) then
						<ProductProcessDescription>
							{
							$SubLine/*:REF[*:RefIdnQual/text() = '#PR']/*:RefIdn/text()
							}
						</ProductProcessDescription>
						else()
						}
						{
						if ($SubLine/*:SLN/*:Qnty) then
						<QtyPer>
							{
							$SubLine/*:SLN/*:Qnty/text()
							}
						</QtyPer>
						else()
						}
						{
						if ($SubLine/*:SLN/*:UorBforM) then
						<QtyPerUOM>
							{
							$SubLine/*:SLN/*:UorBforM/text()
							}
						</QtyPerUOM>
						else()
						}
						{
						if ($SubLine/*:SLN/*:UnitPrc) then
						<UnitPrice>
							{
							$SubLine/*:SLN/*:UnitPrc/text()
							}
						</UnitPrice>
						else()
						}
						{
						if ($SubLine/*:SLN/*:BofUPrcCd) then
						<UnitPriceBasis>
							{
							$SubLine/*:SLN/*:BofUPrcCd/text()
							}
						</UnitPriceBasis>
						else()
						}
						</SublineItemDetail>
						{
						if ($SubLine/*:PID) then
						local:fnPIDToProductDescription($SubLine/*:PID)
						else()
						}
					</Subline>
				}
				</Sublines>
				else()
				}
	
				{
				for $Address in $LineItem/*:BaseIT1GrpN1Grp
				return
				<Address>
					{
					if ($Address/*:N1/*:EntityIdrCd) then
					<AddressTypeCode>
					{
						$Address/*:N1/*:EntityIdrCd/text()
					}
					</AddressTypeCode>
					else()
					}
					{
					if ($Address/*:N1/*:IdnCdQual) then
					<LocationCodeQualifier>
						{
						$Address/*:N1/*:IdnCdQual/text()
						}
					</LocationCodeQualifier>
					else()
					}
					{
					if ($Address/*:N1/*:IdnCd) then
					<AddressLocationNumber>
						{
						$Address/*:N1/*:IdnCd/text()
						}
					</AddressLocationNumber>
					else()
					}
					{
					if ($Address/*:N1/*:Name) then
					<AddressName>
						{
						$Address/*:N1/*:Name/text()
						}
					</AddressName>
					else()
					}
					{
					if ($Address/*:N2/*:Name) then
					<AddressAlternateName>
						{
						$Address/*:N2/*:Name/text()
						}
					</AddressAlternateName>
					else()
					}
					{
					if ($Address/*:N3[1]/*:AddrInfo) then
					<Address1>
						{
						$Address/*:N3[1]/*:AddrInfo/text()
						}
					</Address1>
					else()
					}
					{
					if ($Address/*:N3[2]/*:AddrInfo) then
					<Address2>
						{
						$Address/*:N3[2]/*:AddrInfo/text()
						}
					</Address2>
					else()
					}
					{
					if ($Address/*:N3[3]/*:AddrInfo) then
					<Address3>
						{
						$Address/*:N3[3]/*:AddrInfo/text()
						}
					</Address3>
					else()
					}
					{
					if ($Address/*:N3[4]/*:AddrInfo) then
					<Address4>
						{
						$Address/*:N3[4]/*:AddrInfo/text()
						}
					</Address4>
					else()
					}
					{
					if ($Address/*:N4/*:CityName) then
					<City>
						{
						$Address/*:N4/*:CityName/text()
						}
					</City>
					else()
					}
					{
					if ($Address/*:N4/*:StateOrProvinceCode) then
					<State>
						{
						$Address/*:N4/*:StateOrProvinceCode/text()
						}
					</State>
					else()
					}
					{
					if ($Address/*:N4/*:PostalCode) then
					<PostalCode>
						{
						$Address/*:N4/*:PostalCode/text()
						}
					</PostalCode>
					else()
					}
					{
					if ($Address/*:N4/*:CountryCode) then
					<Country>
						{
						$Address/*:N4/*:CountryCode/text()
						}
					</Country>
					else()
					}
					{
					if ($Address/*:N4/*:LocQual and $Address/*:N4/*:LocIdr) then
					<LocationID>
					{
					$Address/*:N4/*:LocIdr/text()
					}
					</LocationID>
					else()
					}
					{
					if ($Address/*:N4/*:CountrySubdivisionCode) then
					<CountrySubDivision>
					{
					$Address/*:N4/*:CountrySubdivisionCode/text()
					}
					</CountrySubDivision>
					else()
					}
					{
					if ($Address/*:REF) then
					local:fnREFToReference($Address/*:REF)
					else()
					}
					{
					if ($Address/*:PER) then
					local:fnPERToContact($Address/*:PER)
					else()
					}
				</Address>
				}
				{
				for $LocQty in $LineItem/*:SDQ
				return 
				<LocationQuantities>
					{
					if ($LocQty/*:UorBforM) then
					<QtyUOM>
						{
						$LocQty/*:UorBforM/text()
						}
					</QtyUOM>
					else()
					}
					{
					if ($LocQty/*:IdnCdQual) then
					<IDQual>
						{
						$LocQty/*:IdnCdQual/text()
						}
					</IDQual>
					else()
					}
					{
					if ($LocQty/*:LocIdr) then
					<LocationID>
						{
						$LocQty/*:LocIdr/text()
						}
					</LocationID>
					else()
					}
					{
					if ($LocQty/*:IdnCd or $LocQty/*:Qnty) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd) then
						<Location>
						{
						$LocQty/*:IdnCd/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty) then
						<Qty>
						{
						$LocQty/*:Qnty/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
					{
					if ($LocQty/*:IdnCd1 or $LocQty/*:Qnty1) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd1) then
						<Location>
						{
						$LocQty/*:IdnCd1/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty1) then
						<Qty>
						{
						$LocQty/*:Qnty1/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
					{
					if ($LocQty/*:IdnCd2 or $LocQty/*:Qnty2) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd2) then
						<Location>
						{
						$LocQty/*:IdnCd2/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty2) then
						<Qty>
						{
						$LocQty/*:Qnty2/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
					{
					if ($LocQty/*:IdnCd3 or $LocQty/*:Qnty3) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd3) then
						<Location>
						{
						$LocQty/*:IdnCd3/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty3) then
						<Qty>
						{
						$LocQty/*:Qnty3/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
					{
					if ($LocQty/*:IdnCd4 or $LocQty/*:Qnty4) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd4) then
						<Location>
						{
						$LocQty/*:IdnCd4/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty4) then
						<Qty>
						{
						$LocQty/*:Qnty4/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
					{
					if ($LocQty/*:IdnCd5 or $LocQty/*:Qnty5) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd5) then
						<Location>
						{
						$LocQty/*:IdnCd5/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty5) then
						<Qty>
						{
						$LocQty/*:Qnty5/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
					{
					if ($LocQty/*:IdnCd6 or $LocQty/*:Qnty6) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd6) then
						<Location>
						{
						$LocQty/*:IdnCd6/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty6) then
						<Qty>
						{
						$LocQty/*:Qnty6/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
					{
					if ($LocQty/*:IdnCd7 or $LocQty/*:Qnty7) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd7) then
						<Location>
						{
						$LocQty/*:IdnCd7/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty7) then
						<Qty>
						{
						$LocQty/*:Qnty7/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
					{
					if ($LocQty/*:IdnCd8 or $LocQty/*:Qnty8) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd8) then
						<Location>
						{
						$LocQty/*:IdnCd8/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty8) then
						<Qty>
						{
						$LocQty/*:Qnty8/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
					{
					if ($LocQty/*:IdnCd9 or $LocQty/*:Qnty9) then
					<LocationQuantity>
						{
						if ($LocQty/*:IdnCd9) then
						<Location>
						{
						$LocQty/*:IdnCd9/text()
						}
						</Location>
						else()
						}
						{
						if ($LocQty/*:Qnty9) then
						<Qty>
						{
						$LocQty/*:Qnty9/text()
						}
						</Qty>
						else()
						}
					</LocationQuantity>
					else()
					}
				</LocationQuantities>
				}
				{
				if ($LineItem/*:TXI) then
				local:fnTXIToTax($LineItem/*:TXI)
				else()
				}
				{
				if ($LineItem/*:BaseIT1GrpSACGrp) then
				local:fnLineSACToChargesAllowances($LineItem/*:BaseIT1GrpSACGrp)
				else()
				}
			</LineItem>
		}
		</LineItems>
		<Summary>
			{
			if ($InvoiceDoc/*:TXI) then
			local:fnTXIToTax($InvoiceDoc/*:TXI)
			else()
			}
			<Totals>
				{
				if ($InvoiceDoc/*:AMT[*:AmntQualCode='5']/*:MonetaryAmnt) then
				<TotalAmount>
					{
					$InvoiceDoc/*:AMT[*:AmntQualCode='5']/*:MonetaryAmnt/text()
					}
				</TotalAmount>
				else if ($InvoiceDoc/*:TDS/*:Amnt) then
				<TotalAmount>
					{
					$InvoiceDoc/*:TDS/*:Amnt/text()
					}
				</TotalAmount>
				else()
				}
				{
				if ($InvoiceDoc/*:AMT[*:AmntQualCode='N']/*:MonetaryAmnt) then
				<TotalNetSalesAmount>
					{
					$InvoiceDoc/*:AMT[*:AmntQualCode='N']/*:MonetaryAmnt/text()
					}
				</TotalNetSalesAmount>
				else()
				}				
				{
				if ($InvoiceDoc/*:BaseSACGrp[1]/*:SAC[*:AllowOrChrgInd='C'][*:SrvcPromAllowOr='D240'][1]/*:Amnt) then
				<TotalFreightCharges>
					{
					$InvoiceDoc/*:BaseSACGrp[1]/*:SAC[*:AllowOrChrgInd='C'][*:SrvcPromAllowOr='D240'][1]/*:Amnt/text()
					}
				</TotalFreightCharges>
				else()
				}
				{
				if ($InvoiceDoc/*:BaseSACGrp[1]/*:SAC[*:AllowOrChrgInd='C'][*:SrvcPromAllowOr='F050'][1]/*:Amnt) then
				<TotalNonFreightCharges>
					{
					$InvoiceDoc/*:BaseSACGrp[1]/*:SAC[*:AllowOrChrgInd='C'][*:SrvcPromAllowOr='F050'][1]/*:Amnt/text()
					}
				</TotalNonFreightCharges>
				else()
				}
				{
				if ($InvoiceDoc/*:TXI[*:TaxTypeCode='TX'][1]/*:MonetaryAmnt) then
				<TotalSalesTaxAmount>
					{
					$InvoiceDoc/*:TXI[*:TaxTypeCode='TX'][1]/*:MonetaryAmnt/text()
					}
				</TotalSalesTaxAmount>
				else()
				}
				{
				if ($InvoiceDoc/*:TDS/*:Amnt3) then
				<TotalTermsDiscountAmount>
					{
					$InvoiceDoc/*:TDS/*:Amnt3/text()
					}
				</TotalTermsDiscountAmount>
				else()
				}
				{
				if ($InvoiceDoc/*:BaseSACGrp[1]/*:SAC[*:AllowOrChrgInd='A'][*:SrvcPromAllowOr='F050'][1]/*:Amnt) then
				<TotalAllowancesAmount>
					{
					$InvoiceDoc/*:BaseSACGrp[1]/*:SAC[*:AllowOrChrgInd='A'][*:SrvcPromAllowOr='F050'][1]/*:Amnt/text()
					}
				</TotalAllowancesAmount>
				else()
				}
				{
				if ($InvoiceDoc/*:CTT/*:HashTotal) then
				<TotalQtyInvoiced>
					{
					$InvoiceDoc/*:CTT/*:HashTotal/text()
					}
				</TotalQtyInvoiced>
				else()
				}
				{
				if ($InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:NumOfUnitsShpd) then
				<TotalCartonCount>
					{
					$InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:NumOfUnitsShpd/text()
					}
				</TotalCartonCount>
				else()
				}
				
				{
				if ($InvoiceDoc/*:CTT/*:Weight) then
					<TotalWeight>
						{
						$InvoiceDoc/*:CTT/*:Weight/text()
						}
					</TotalWeight>
				else if ($InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:Weight) then
					<TotalWeight>
						{
						$InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:Weight/text()
						}
					</TotalWeight>
				else()
				}
				{
				if ($InvoiceDoc/*:CTT/*:Volume) then
				<TotalVolume>
					{
					$InvoiceDoc/*:CTT/*:Volume/text()
					}
				</TotalVolume>
				else if ($InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:Volume) then
					<TotalVolume>
						{
						$InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:Volume/text()
						}
					</TotalVolume>
				else()
				}				
				{
				if ($InvoiceDoc/*:CTT/*:NumberOfLineItems) then
				<TotalLineItemNumber>
					{
					$InvoiceDoc/*:CTT/*:NumberOfLineItems/text()
					}
				</TotalLineItemNumber>
				else()
				}		
				{
				if ($InvoiceDoc/*:TDS/*:Amnt2) then
				<InvoiceAmtDueByTermsDate>
					{
					$InvoiceDoc/*:TDS/*:Amnt2/text()
					}
				</InvoiceAmtDueByTermsDate>
				else()
				}
				
				{
				if ($InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:UorBforM) then
				<TotalQtyInvoicedUOM>
					{
					$InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:UorBforM/text()
					}
				</TotalQtyInvoicedUOM>
				else()
				}
				{
				if ($InvoiceDoc/*:CTT/*:UorBforM) then
					<TotalWeightUOM>
						{
						$InvoiceDoc/*:CTT/*:UorBforM/text()
						}
					</TotalWeightUOM>
				else if ($InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:UorBforM1) then
					<TotalWeightUOM>
						{
						$InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:UorBforM1/text()
						}
					</TotalWeightUOM>
				else()
				}
				{
				if ($InvoiceDoc/*:CTT/*:UorBforM1) then
					<TotalVolumeUOM>
						{
						$InvoiceDoc/*:CTT/*:UorBforM1/text()
						}
					</TotalVolumeUOM>
				else if ($InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:UorBforM2) then
					<TotalVolumeUOM>
						{
						$InvoiceDoc/*:BaseISSGrp[1]/*:ISS/*:UorBforM2/text()
						}
					</TotalVolumeUOM>
				else()
				}				
				
			</Totals>
		</Summary>
	</Invoice>
</Invoices>
