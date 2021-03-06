--修改成旅游单位客户
select CustomerType,* from Topway..tbCompanyM 
--update Topway..tbCompanyM  set CustomerType='C'
where cmpid='020697'
select Type,* from homsomDB..Trv_UnitCompanies 
--update  homsomDB..Trv_UnitCompanies  set Type='C'
where Cmpid='020697'

--UC020459 陈嘉妍 出票日期2018.7--12月的所有机票数据
select h.Name,* from homsomDB..Trv_UnitPersons u
left join homsomDB..Trv_Human h on h.ID=u.ID
where u.CompanyID=(Select  ID  from homsomDB..Trv_UnitCompanies where Cmpid='020459')
and h.Name='陈嘉妍'

select distinct datetime 出票日期,begdate 起飞日期,coupno 销售单号,'陈嘉妍' 预订人,pasname 乘机人,route 线路,ride+flightno 航班号,tcode+ticketno 票号,priceinfo 全价,
(CASE WHEN ISNULL(priceinfo,0)=0 THEN 0 ELSE	price/priceinfo END) 折扣率,price 销售单价,tax 税收,fuprice 服务费,totprice 销售价,reti 退票单号,Department 部门,nclass 舱位代码
from Topway..V_TicketInfo
where cmpcode='020459'
and custid='D618538'
and datetime>='2018-07-01'
and datetime<'2019-01-01'

select price,priceinfo,* from Topway..tbcash where coupno='AS002019037'






DECLARE @CMPCODE VARCHAR(20)='020459'
DECLARE @CUSTID VARCHAR(20)=''
DECLARE @STARTMONTH VARCHAR(10)='2018-07'
DECLARE @ENDMONTH VARCHAR(10)='2018-12'

IF OBJECT_ID('TEMPDB..#TTMP') IS NOT NULL
DROP TABLE #TTMP
CREATE TABLE #TTMP (
	MONTHDATE VARCHAR(10),
	GNSALESAMOUNT DECIMAL(18,2),
	GNTAX DECIMAL(18,2),
	GNTPAMOUNT DECIMAL(18,2),
	GNGQAMOUNT DECIMAL(18,2),
	GJSALESAMOUNT DECIMAL(18,2),
	GJTAX DECIMAL(18,2),
	GJTPAMOUNT DECIMAL(18,2),
	GJGQAMOUNT DECIMAL(18,2),
	BXAMOUNT DECIMAL(18,2),
	GNCOUNT INT,
	GJCOUNT INT
)

--国内机票销量
INSERT INTO #TTMP(MONTHDATE,GNSALESAMOUNT)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,SUM(totprice-tax) 国内机票销量 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=0
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--国内机票税收
INSERT INTO #TTMP(MONTHDATE,GNTAX)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,SUM(tax) 国内机票税收 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=0
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--国内机票退票总金额
INSERT INTO #TTMP(MONTHDATE,GNTPAMOUNT)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,SUM(-T1.totprice) 国内机票退票总金额 FROM Topway..tbReti T1 WITH (NOLOCK)
INNER JOIN Topway..tbcash T2 WITH (NOLOCK) ON T1.reno=T2.reti 
WHERE T1.cmpcode = @CMPCODE
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND T2.inf=0
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--国内机票改期升舱销量
INSERT INTO #TTMP(MONTHDATE,GNGQAMOUNT)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,SUM(totprice) 国内机票改期升舱销量 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=0
AND T1.tickettype IN ('改期费', '升舱费','改期升舱')
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--国际机票销量
INSERT INTO #TTMP(MONTHDATE,GJSALESAMOUNT)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,SUM(totprice-tax) 国际机票销量 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=1
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND T1.route NOT LIKE '%改期%' 
AND T1.route NOT LIKE '%升舱%'
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--国际机票税收
INSERT INTO #TTMP(MONTHDATE,GJTAX)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,SUM(tax) 国际机票税收 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=1
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND T1.route NOT LIKE '%改期%' 
AND T1.route NOT LIKE '%升舱%'
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--国际机票退票总金额
INSERT INTO #TTMP(MONTHDATE,GJTPAMOUNT)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,SUM(-T1.totprice) 国际机票退票总金额 FROM Topway..tbReti T1 WITH (NOLOCK)
INNER JOIN Topway..tbcash T2 WITH (NOLOCK) ON T1.reno=T2.reti 
WHERE T1.cmpcode = @CMPCODE
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND T2.inf=1
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--国际机票改期升舱销量
INSERT INTO #TTMP(MONTHDATE,GJGQAMOUNT)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,SUM(totprice) 国际机票改期升舱销量 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=1
AND (T1.tickettype IN ('改期费', '升舱费','改期升舱') OR T1.route  LIKE '%改期%' OR T1.route LIKE '%升舱%')
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--保险销量
INSERT INTO #TTMP(MONTHDATE,BXAMOUNT)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,SUM(totprice) 保险销量 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=-1
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--国内机票张数
INSERT INTO #TTMP(MONTHDATE,GNCOUNT)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份, COUNT(ID) 国内机票张数 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=0
AND T1.tickettype IN ('电子票','改期费', '升舱费','改期升舱')
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND ISNULL(T1.reti,'')='' 
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--国际机票张数
INSERT INTO #TTMP(MONTHDATE,GJCOUNT)
SELECT SUBSTRING(T1.ModifyBillNumber,8,6) 月份,COUNT(ID) 国际机票张数 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=1
AND (T1.tickettype IN ('电子票','改期费', '升舱费','改期升舱') OR T1.route  LIKE '%改期%' OR T1.route LIKE '%升舱%')
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND ISNULL(T1.reti,'')='' 
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.ModifyBillNumber

--第一张SHEET
SELECT MONTHDATE 月份,
	SUM(ISNULL(GNSALESAMOUNT,0)) 国内机票销量,--国内机票销量
	SUM(ISNULL(GNTAX,0)) 国内机票税收,--国内机票税收
	SUM(ISNULL(GNTPAMOUNT,0)) 国内机票退票总金额,--国内机票退票总金额
	SUM(ISNULL(GNGQAMOUNT,0)) 国内机票改期升舱销量,--国内机票改期升舱销量
	SUM(ISNULL(GNSALESAMOUNT,0))+SUM(ISNULL(GNTAX,0))+SUM(ISNULL(GNTPAMOUNT,0))+SUM(ISNULL(GNGQAMOUNT,0)) 国内机票合计,--国内机票合计
	SUM(ISNULL(GJSALESAMOUNT,0)) 国际机票销量,--国际机票销量
	SUM(ISNULL(GJTAX,0)) 国际机票税收,--国际机票税收
	SUM(ISNULL(GJTPAMOUNT,0)) 国际机票退票总金额,--国际机票退票总金额
	SUM(ISNULL(GJGQAMOUNT,0)) 国际机票改期升舱销量,--国际机票改期升舱销量
	SUM(ISNULL(GJSALESAMOUNT,0)) +SUM(ISNULL(GJTAX,0)) +SUM(ISNULL(GJTPAMOUNT,0)) +	SUM(ISNULL(GJGQAMOUNT,0)) 国际机票合计,--国际机票合计
	SUM(ISNULL(BXAMOUNT,0)) 保险销量,--保险销量
	---TOTALAMOUNT START
	SUM(ISNULL(GNSALESAMOUNT,0))+SUM(ISNULL(GNTAX,0))+SUM(ISNULL(GNTPAMOUNT,0))+SUM(ISNULL(GNGQAMOUNT,0)) 
	+SUM(ISNULL(GJSALESAMOUNT,0)) +SUM(ISNULL(GJTAX,0)) +SUM(ISNULL(GJTPAMOUNT,0)) +	SUM(ISNULL(GJGQAMOUNT,0)) 
	+SUM(ISNULL(BXAMOUNT,0)) 总销量,--总销量
	---TOTALAMOUNT END
	SUM(ISNULL(GNCOUNT,0)) 国内机票张数,--国内机票张数
	SUM(ISNULL(GJCOUNT,0)) 国际机票张数,--国际机票张数
	SUM(ISNULL(GNCOUNT,0)) + SUM(ISNULL(GJCOUNT,0)) 机票总张数--机票总张数
FROM #TTMP
GROUP BY MONTHDATE

--第二张SHEET
SELECT  T1.[route] 行程,SUM(totprice) 国内机票销量,COUNT(ID) 国内机票张数 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=0
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.[route] ORDER BY 国内机票销量 DESC

SELECT TOP 15 T1.[route] 行程,SUM(totprice) 国际机票销量,COUNT(ID) 国际机票张数 FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=1
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND T1.route NOT LIKE '%改期%' 
AND T1.route NOT LIKE '%升舱%'
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T1.[route] ORDER BY 国际机票销量 DESC

--第三张SHEET
IF OBJECT_ID('TEMPDB..#TTTHIRD') IS NOT NULL
DROP TABLE #TTTHIRD
SELECT DAYSFLAG,SUM(totprice) 合计销量,COUNT(1) 合计张数,SUM(price)/SUM(CAST(priceinfo AS DECIMAL)) 经济舱平均折扣率 INTO #TTTHIRD  FROM (
SELECT --T1.coupno,
CASE WHEN DATEDIFF(DD,T1.[datetime],T1.begdate) BETWEEN 0 AND 2 THEN 1
	WHEN DATEDIFF(DD,T1.[datetime],T1.begdate) BETWEEN 3 AND 4 THEN 2
	WHEN DATEDIFF(DD,T1.[datetime],T1.begdate) BETWEEN 5 AND 6 THEN 3
	WHEN DATEDIFF(DD,T1.[datetime],T1.begdate) BETWEEN 7 AND 8 THEN 4
	WHEN DATEDIFF(DD,T1.[datetime],T1.begdate) BETWEEN 9 AND 10 THEN 5
	WHEN DATEDIFF(DD,T1.[datetime],T1.begdate) BETWEEN 11 AND 12 THEN 6
	WHEN DATEDIFF(DD,T1.[datetime],T1.begdate) BETWEEN 13 AND 14 THEN 7
	WHEN DATEDIFF(DD,T1.[datetime],T1.begdate) >14 THEN 8 END DAYSFLAG,
totprice,price,priceinfo 
FROM Topway..tbcash T1 WITH (NOLOCK)
INNER JOIN ehomsom..tbInfCabincode T2 WITH (NOLOCK) ON T1.ride=T2.code2 AND T1.nclass=T2.cabin
WHERE T1.cmpcode = @CMPCODE
AND T2.begdate<=T1.[datetime] AND T2.enddate>=T1.[datetime]
AND ((T2.flightbegdate<=T1.begdate AND T2.flightenddate>=T1.begdate) OR
(T2.flightbegdate2<=T1.begdate AND T2.flightenddate2>=T1.begdate) OR
(T2.flightbegdate3<=T1.begdate AND T2.flightenddate3>=T1.begdate) OR
(T2.flightbegdate4<=T1.begdate AND T2.flightenddate4>=T1.begdate))
AND T2.cabintype like '%经济舱%'
AND T1.inf=0
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
) T
GROUP BY DAYSFLAG

DECLARE @TOTALTHIRDAMOUNT DECIMAL(18,2) 
DECLARE @TOTALTHIRDCOUNT DECIMAL(18,2)  
SELECT @TOTALTHIRDAMOUNT=SUM(合计销量) FROM #TTTHIRD
SELECT @TOTALTHIRDCOUNT=SUM(合计张数) FROM #TTTHIRD

SELECT @TOTALTHIRDAMOUNT 总销量,@TOTALTHIRDCOUNT 总张数,DAYSFLAG, 
合计销量,合计销量/@TOTALTHIRDAMOUNT 销量比例,合计张数,合计张数/@TOTALTHIRDCOUNT 张数比例, 经济舱平均折扣率 FROM #TTTHIRD


--第四张SHEET
IF OBJECT_ID('TEMPDB..#TTFOURTH') IS NOT NULL
DROP TABLE #TTFOURTH
SELECT T2.airname,T1.ride,SUM(totprice) 合计销量,COUNT(1) 合计张数 INTO #TTFOURTH FROM Topway..tbcash T1 WITH (NOLOCK)
INNER JOIN ehomsom..tbInfAirCompany T2 WITH (NOLOCK) ON T1.ride=T2.code2
WHERE T1.cmpcode = @CMPCODE
AND T1.inf<>-1
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND T1.route NOT LIKE '%改期%' 
AND T1.route NOT LIKE '%升舱%'
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T2.airname,T1.ride

DECLARE @TOTALFOURTHAMOUNT DECIMAL(18,2) 
DECLARE @TOTALFOURTHCOUNT DECIMAL(18,2)  
SELECT @TOTALFOURTHAMOUNT=SUM(合计销量) FROM #TTFOURTH
SELECT @TOTALFOURTHCOUNT=SUM(合计张数) FROM #TTFOURTH

SELECT @TOTALFOURTHAMOUNT 总销量,@TOTALFOURTHCOUNT 总张数,airname 航司名称,ride 航司二字码,
合计销量,合计销量/@TOTALFOURTHAMOUNT 销量比例,合计张数,合计张数/@TOTALFOURTHCOUNT 张数比例 FROM #TTFOURTH
ORDER BY 合计销量 DESC



--第五张SHEET
IF OBJECT_ID('TEMPDB..#TTFIFTH') IS NOT NULL
DROP TABLE #TTFIFTH
SELECT T2.airname,T1.ride,SUM(totprice) 合计销量,COUNT(1) 合计张数 INTO #TTFIFTH FROM Topway..tbcash T1 WITH (NOLOCK)
INNER JOIN ehomsom..tbInfAirCompany T2 WITH (NOLOCK) ON T1.ride=T2.code2
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=0
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND T1.route NOT LIKE '%改期%' 
AND T1.route NOT LIKE '%升舱%'
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T2.airname,T1.ride

DECLARE @TOTALFIFTHAMOUNT DECIMAL(18,2) 
DECLARE @TOTALFIFTHCOUNT DECIMAL(18,2)  
SELECT @TOTALFIFTHAMOUNT=SUM(合计销量) FROM #TTFIFTH
SELECT @TOTALFIFTHCOUNT=SUM(合计张数) FROM #TTFIFTH

SELECT @TOTALFIFTHAMOUNT 总销量,@TOTALFIFTHCOUNT 总张数,airname 航司名称,ride 航司二字码,
合计销量,合计销量/@TOTALFIFTHAMOUNT 销量比例,合计张数,合计张数/@TOTALFIFTHCOUNT 张数比例 FROM #TTFIFTH
ORDER BY 合计销量 DESC

--第六张SHEET
IF OBJECT_ID('TEMPDB..#TTSIXTH') IS NOT NULL
DROP TABLE #TTSIXTH
SELECT T2.airname,T1.ride,SUM(totprice) 合计销量,COUNT(1) 合计张数 INTO #TTSIXTH FROM Topway..tbcash T1 WITH (NOLOCK)
INNER JOIN ehomsom..tbInfAirCompany T2 WITH (NOLOCK) ON T1.ride=T2.code2
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=1
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND T1.route NOT LIKE '%改期%' 
AND T1.route NOT LIKE '%升舱%'
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
GROUP BY T2.airname,T1.ride

DECLARE @TOTALSIXTHAMOUNT DECIMAL(18,2) 
DECLARE @TOTALSIXTHCOUNT DECIMAL(18,2)  
SELECT @TOTALSIXTHAMOUNT=SUM(合计销量) FROM #TTSIXTH
SELECT @TOTALSIXTHCOUNT=SUM(合计张数) FROM #TTSIXTH

SELECT @TOTALSIXTHAMOUNT 总销量,@TOTALSIXTHCOUNT 总张数,airname 航司名称,ride 航司二字码,
合计销量,合计销量/@TOTALSIXTHAMOUNT 销量比例,合计张数,合计张数/@TOTALSIXTHCOUNT 张数比例 FROM #TTSIXTH
ORDER BY 合计销量 DESC


--第七张SHEET
IF OBJECT_ID('TEMPDB..#TTSEVENTH') IS NOT NULL
DROP TABLE #TTSEVENTH
SELECT CABINFLAG,SUM(price) 合计销量不含税,SUM(CAST(priceinfo AS DECIMAL)) 合计全价不含税,COUNT(1) 合计张数 INTO #TTSEVENTH  FROM (
SELECT --T1.coupno,
CASE WHEN price/CAST(priceinfo AS DECIMAL) >1 THEN 1
	WHEN price/CAST(priceinfo AS DECIMAL) =1 THEN 2
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.95 AND price/CAST(priceinfo AS DECIMAL) <1 THEN 3
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.90 AND price/CAST(priceinfo AS DECIMAL) <0.95 THEN 4
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.85 AND price/CAST(priceinfo AS DECIMAL) <0.90 THEN 5
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.80 AND price/CAST(priceinfo AS DECIMAL) <0.85 THEN 6
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.75 AND price/CAST(priceinfo AS DECIMAL) <0.80 THEN 7
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.70 AND price/CAST(priceinfo AS DECIMAL) <0.75 THEN 8
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.65 AND price/CAST(priceinfo AS DECIMAL) <0.70 THEN 9
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.60 AND price/CAST(priceinfo AS DECIMAL) <0.65 THEN 10
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.55 AND price/CAST(priceinfo AS DECIMAL) <0.60 THEN 11
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.50 AND price/CAST(priceinfo AS DECIMAL) <0.55 THEN 12
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.45 AND price/CAST(priceinfo AS DECIMAL) <0.50 THEN 13
	WHEN price/CAST(priceinfo AS DECIMAL) >=0.40 AND price/CAST(priceinfo AS DECIMAL) <0.45 THEN 14
	WHEN price/CAST(priceinfo AS DECIMAL) <0.40 THEN 15 END CABINFLAG,
totprice,price,priceinfo 
FROM Topway..tbcash T1 WITH (NOLOCK)
WHERE T1.cmpcode = @CMPCODE
AND T1.inf=0
AND T1.tickettype NOT IN ('改期费', '升舱费','改期升舱')
AND ISNULL(T1.ModifyBillNumber,'') <> ''
AND (@CUSTID ='' OR @CUSTID IS NULL OR @CUSTID=T1.custid)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)>=CAST(@STARTMONTH+'-01' AS DATETIME)
AND CAST(SUBSTRING(T1.ModifyBillNumber,8,6)+'01' AS DATETIME)<=CAST(@ENDMONTH+'-01' AS DATETIME)
) T
GROUP BY CABINFLAG

DECLARE @TOTALSEVENTHAMOUNT DECIMAL(18,2) 
DECLARE @TOTALSEVENTHCOUNT DECIMAL(18,2)  
DECLARE @TOTALSEVENTHFULLAMOUNT DECIMAL(18,2)  
SELECT @TOTALSEVENTHAMOUNT=SUM(合计销量不含税) FROM #TTSEVENTH
SELECT @TOTALSEVENTHCOUNT=SUM(合计张数) FROM #TTSEVENTH
SELECT @TOTALSEVENTHFULLAMOUNT=SUM(合计全价不含税) FROM #TTSEVENTH

SELECT @TOTALSEVENTHAMOUNT/@TOTALSEVENTHFULLAMOUNT 平均折扣率,@TOTALSEVENTHAMOUNT 总销量,@TOTALSEVENTHCOUNT 总张数,CABINFLAG, 
合计销量不含税,合计销量不含税/@TOTALSEVENTHAMOUNT 销量比例,合计张数,合计张数/@TOTALSEVENTHCOUNT 张数比例 FROM #TTSEVENTH


--机票业务顾问信息
select sales,SpareTC,* from Topway..tbcash 
--update Topway..tbcash set sales='何洁',SpareTC='何洁'
where coupno='AS002339560'

--会务结算单作废
update topway..tbConventionSettleApp set SettleStatus='3' where Id='结算单号'
update topway..tbConventionJS set Jstatus='0',Settleno='0',Pstatus='0',Pdatetime='1900-1-1' where Settleno='结算单号'