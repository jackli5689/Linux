

IF OBJECT_ID('tempdb.dbo.#cmp1') IS NOT NULL DROP TABLE #cmp1
select t1.cmpid as 单位编号,t1.cmpname as 单位名称
,(case CustomerType when 'A' then '差旅单位客户' when 'C' then '旅游单位客户' else '' end) as 单位类型
,(CASE hztype WHEN 0 THEN '我方终止合作' WHEN 1 THEN '正常合作正常月结' WHEN 2 THEN '正常合作仅限现结' WHEN 3 THEN '正常合作临时月结' WHEN 4 THEN '对方终止合作'  ELSE '' END) as 合作状态
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_UnitCompies_Sales t5 on t9.ID=t5.EmployeeID where t5.UnitCompayID=t4.id)  as 开发人
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_UnitCompanies_AccountManagers t6 on t9.ID=t6.EmployeeID where t6.UnitCompanyID=t4.id) as 客户主管
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_UnitCompanies_KEYAccountManagers t10 on t10.EmployeeID=t9.ID where t10.UnitCompanyID=t4.ID) as 维护人
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_TktUnitCompanies_TktTCs t8 on t9.id=t8.TktTCID where t8.TktUnitCompanyID=t4.ID) as 差旅业务顾问
,(select top 1t9.name from homsomDB..SSO_Users t9 inner join homsomDB..Trv_TrvUnitCompanies_TrvTCs t7 on t9.id=t7.TrvTCID where t7.TrvUnitCompanyID=t4.ID) as 旅游业务顾问
--,indate
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


IF OBJECT_ID('tempdb.dbo.#cmp') IS NOT NULL DROP TABLE #cmp
select *
into #cmp
from #cmp1
where 单位编号<>''


--机票
IF OBJECT_ID('tempdb.dbo.#jipiao_gn') IS NOT NULL DROP TABLE #jipiao_gn
select t1.单位编号
,SUM(ISNULL(t3.totprice,0)-ISNULL(t2.totprice,0)) as tb1
,SUM(ISNULL(t3.profit,0)+ISNULL(t2.profit,0)) as tb2
into #jipiao_gn
from #cmp t1
left join tbcash t3 on t3.cmpcode=t1.单位编号
left join tbreti t2 on t3.reti=t2.reno and t2.status2<>4
where  (t3.datetime>='2017-01-01' and t3.datetime<'2018-01-01')
and 单位编号<>''
and t3.inf=0
group by t1.单位编号
order by t1.单位编号

IF OBJECT_ID('tempdb.dbo.#jipiao_gj') IS NOT NULL DROP TABLE #jipiao_gj
select t1.单位编号
,SUM(ISNULL(t3.totprice,0)-ISNULL(t2.totprice,0)) as tb3
,SUM(ISNULL(t3.profit,0)+ISNULL(t2.profit,0)) as tb4
into #jipiao_gj
from #cmp t1
left join tbcash t3 on t3.cmpcode=t1.单位编号
left join tbreti t2 on t3.reti=t2.reno and t2.status2<>4
where  (t3.datetime>='2017-01-01' and t3.datetime<'2018-01-01')
and 单位编号<>''
and t3.inf=1
group by t1.单位编号
order by t1.单位编号




--合作月份数
IF OBJECT_ID('tempdb.dbo.#hz') IS NOT NULL DROP TABLE #hz
select CompanyCode,COUNT(*) as hz
into #hz
from AccountStatement 
where AccountPeriodAir1>='2017-01-01' and AccountPeriodAir1<'2018-01-01'
group by CompanyCode


select cmp.*
,isnull(tb1,0)/hz as 国内机票销量,isnull(tb2,0)/hz as 国内机票利润
,isnull(tb3,0)/hz as 国际机票销量,isnull(tb4,0)/hz as 国际机票利润
,isnull(hz,0) as 合作月份数
from #cmp cmp
left join #jipiao_gn gn on gn.单位编号=Cmp.单位编号
left join #jipiao_gj gj on gj.单位编号=Cmp.单位编号
left join #hz hz on hz.CompanyCode=Cmp.单位编号
where cmp.单位编号 in (SELECT Cmpid FROM homsomDB..Trv_UnitCompanies WHERE CertificateD=1)
order by Cmp.单位编号
/*
select cmpcode from tbcash 
where (datetime>='2017-01-01' and datetime<'2018-01-01') and inf=0
and info3 in ('需打印行程单(不配送)','需打印行程单(配送)','需打印英文行程单','需打印中文行程单')

SELECT Cmpid FROM homsomDB..Trv_UnitCompanies WHERE CertificateD=1
*/