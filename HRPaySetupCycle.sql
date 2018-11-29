select 
	DistrictID,
	rtrim(DistrictAbbrev) as DistrictAbbrev,
	DistrictTitle
from tblDistrict

select 
	(select DistrictID from tblDistrict) as OrgID,
	te.EmployeeID,
	CONVERT(VARCHAR(10), pcd.EffectiveDate, 110) as DateFrom,
	CONVERT(VARCHAR(10), pcd.InactiveDate, 110) as DateThru,
	siAtt.SiteCode as SiteIdPayCheck,
	siWork.SiteCode as SiteIdTimeSheet,
	null as OptPayArrear,
	null as OptPayAdvance,
	null as ProratePrds,
	null as AnnualizeBenefitOpt,
	te.SocSecNo,
	te.LName,
	te.FName,
	cl.ClassDescription,
	pcd.SlotNum,
	jt.JobTitle,
	cby.CalendarName,
	cby.MthWk,
	te.PayCycle,
	te.IsDeferredPay,
	siAtt.SiteName as WarrantSite,
	siAtt.SiteCode as WarrantSiteCode,
	siWork.SiteName as AttendanceSite,
	siWork.SiteCode as AttendanceSiteCode
from tblEmployee te
inner join 
	tblClassifications cl
	on cl.ClassificationID = te.ClassificationId
	and te.EmployeeID > 0
	and te.TerminateDate is null
left join
	tblPositionControlDetails pcd
	on pcd.EmployeeID = te.EmployeeID
	and pcd.InactiveDate is null
left join
	tblJobTitles jt
	on pcd.pcJobTitleID = jt.JobTitleID
left join
	tblSlotCalendarByYear cby
	on cby.SlotCalendarID = pcd.pcSlotCalendarID
	and cby.FiscalYear = 2018
left join
	tblSite siAtt
	on siAtt.SiteID = pcd.PayrollSiteID
left join
	tblSite siWork
	on siWork.SiteID = pcd.SiteID
order by te.Fullname asc
