/*
HRPaySetupCycle

	The HRPaySetupCycle table defines the employee pay cycle, arrears/advance 
	option, time sheet and pay check locations.
*/

select 
	DistrictID,
	rtrim(DistrictAbbrev) as DistrictAbbrev,
	DistrictTitle
from tblDistrict

select 
	(select DistrictID from tblDistrict) as OrgId,
	te.EmployeeID as  EmpId,
	CONVERT(VARCHAR(10), scby.StartDate, 110) as DateFrom,
	CONVERT(VARCHAR(10), scby.EndDate, 110) as DateThru,
	paysite.SiteCode as SiteIdPayCheck,
	attsite.SiteCode as SiteIdTimeSheet,
	null as OptPayArrear,
	null as OptPayAdvance,
	(case when isnull(te.PayCycle,0) = 0 then scby.MthWk else te.PayCycle end) as PaycycleID,
	null as ProratePrds,
	null as AnnualizeBenefitOpt,
	scby.CalendarName
from tblEmployee te
inner join
	tblCompDetails cd
	on cd.EmployeeID = te.EmployeeID
	and te.TerminateDate is null
	and cd.FiscalYear = 2018
	and cd.InactiveDate is null
inner join
	tblPositionControlDetails pcd
	on cd.cdPositionControlID = pcd.PositionControlID
	and pcd.InactiveDate is null
inner join
	tblSlotCalendarByYear scby
	on scby.SlotCalendarID = pcd.pcSlotCalendarID
	and scby.FiscalYear = 2018
inner join
	tblSite paysite
	on te.WarrantSiteID = paysite.SiteID
inner join
	tblSite attsite
	on pcd.PayrollSiteID = attsite.SiteID

