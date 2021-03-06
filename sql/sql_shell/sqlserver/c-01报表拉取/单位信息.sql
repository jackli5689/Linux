IF OBJECT_ID('tempdb.dbo.#cmp1') IS NOT NULL DROP TABLE #cmp1
select t1.cmpid as 单位编号,t1.cmpname as 单位名称
,(case CustomerType when 'A' then '差旅单位客户' when 'C' then '旅游单位客户' else '' end) as 单位类型
,(CASE hztype WHEN 0 THEN '我方终止合作' WHEN 1 THEN '正常合作正常月结' WHEN 2 THEN '正常合作仅限现结' WHEN 3 THEN '正常合作临时月结' WHEN 4 THEN '对方终止合作'  ELSE '' END) as 合作状态
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_UnitCompies_Sales t5 on t9.ID=t5.EmployeeID where t5.UnitCompayID=t4.id)  as 开发人
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_UnitCompanies_AccountManagers t6 on t9.ID=t6.EmployeeID where t6.UnitCompanyID=t4.id) as 售后主管
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_UnitCompanies_KEYAccountManagers t10 on t10.EmployeeID=t9.ID where t10.UnitCompanyID=t4.ID) as 维护人
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_TktUnitCompanies_TktTCs t8 on t9.id=t8.TktTCID where t8.TktUnitCompanyID=t4.ID) as 差旅业务顾问
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_TrvUnitCompanies_TrvTCs t7 on t9.id=t7.TrvTCID where t7.TrvUnitCompanyID=t4.ID) as 旅游业务顾问
,indate
into #cmp1
from tbCompanyM t1
left join homsomdb..Trv_UnitCompanies t4 on t1.cmpid=t4.Cmpid
--开发人
left join homsomDB..Trv_UnitCompies_Sales t5 on t4.ID=t5.UnitCompayID
--客户主管
left join homsomDB..Trv_UnitCompanies_AccountManagers t6 on t4.ID=t6.UnitCompanyID
--维护人
left join homsomDB..Trv_UnitCompanies_KEYAccountManagers t10 on t10.UnitCompanyID=t4.ID
--旅游业务顾问
left join homsomDB..Trv_TrvUnitCompanies_TrvTCs t7 on t7.TrvUnitCompanyID=t4.ID
--差旅业务顾问
left join homsomDB..Trv_TktUnitCompanies_TktTCs t8 on t8.TktUnitCompanyID=t4.ID
--人员信息
left join homsomDB..SSO_Users t9 on
t9.ID=t5.EmployeeID and t9.ID=t6.EmployeeID and t9.ID=t8.TktTCID and t9.ID=t7.TrvTCID 
group by t1.cmpid,t1.cmpname,CustomerType,hztype,t4.id,indate
order by t1.cmpid





--挖掘人
IF OBJECT_ID('tempdb.dbo.#yskj') IS NOT NULL DROP TABLE #yskj
select CmpId,MaintainName 
into #yskj
from  HM_ThePreservationOfHumanInformation tp where MaintainType=2 and IsDisplay=1
--运营经理
IF OBJECT_ID('tempdb.dbo.#yyjl') IS NOT NULL DROP TABLE #yyjl
select CmpId,MaintainName 
into #yyjl
from  HM_ThePreservationOfHumanInformation tp where MaintainType=9 and IsDisplay=1

IF OBJECT_ID('tempdb.dbo.#p3') IS NOT NULL DROP TABLE #p3
select cmp1.*,yskj.MaintainName as 应收会计,yyjl.MaintainName as 运营经理 
into #p3
from #cmp1 cmp1
left join #yskj yskj on yskj.cmpid=cmp1.单位编号
left join #yyjl yyjl on yyjl.cmpid=cmp1.单位编号

--IF OBJECT_ID('tempdb.dbo.#p3') IS NOT NULL DROP TABLE #p3
--select * 
--into #p3
--from #p2
--where 单位编号<>'' and 合作状态 not like ('%终止%')




--账单账期
--IF OBJECT_ID('tempdb.dbo.#p4') IS NOT NULL DROP TABLE #p4
--select CompanyCode,SettlementTypeAir 
--into #p4
--from AccountStatement where AccountPeriodAir1<=GETDATE() AND AccountPeriodAir2>=GETDATE()


------------更改如下
IF OBJECT_ID('tempdb.dbo.#p4') IS NOT NULL DROP TABLE #p4
SELECT     CmpId,SettleMentManner
into #p4
FROM         HM_SetCompanySettleMentManner
WHERE     SStartDate<=GETDATE() AND SEndDate>=GETDATE() and Type=0 and Status=1
-------------


IF OBJECT_ID('tempdb.dbo.#p5') IS NOT NULL DROP TABLE #p5
select CmpId,DuiZhang1,DuiZhang2
into #p5
from  HM_CompanyAccountInfo where PstartDate<=GETDATE() and PendDate>=GETDATE()

IF OBJECT_ID('tempdb.dbo.#p6') IS NOT NULL DROP TABLE #p6
select p3.*,p4.SettleMentManner,p5.duizhang1,p5.duizhang2 
into #p6
from #p3 p3
left join #p4 p4 on p4.cmpid=p3.单位编号
left join #p5 p5 on p5.cmpid=p3.单位编号

select 单位编号,单位名称,duizhang1 as 账单账期,duizhang2 as 结算账期,SettleMentManner as 结算方式,应收会计,差旅业务顾问,维护人,售后主管,运营经理,开发人,合作状态 
from #p6
where 单位编号<>''


