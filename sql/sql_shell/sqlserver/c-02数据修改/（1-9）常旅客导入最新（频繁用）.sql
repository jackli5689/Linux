/*
0819_UC018900上海宜希加文化传播有限公司常旅客导入

*/



SELECT * FROM homsomDB..Trv_UnitCompanies WHERE Cmpid='018900'

IF OBJECT_ID('tempdb.dbo.#p') IS NOT NULL DROP TABLE #p
CREATE TABLE #P(
id INT IDENTITY(1,1)
,userName VARCHAR(100)
,name varchar(100)
,firstname varchar(100)
,middlename varchar(100)
,lastname varchar(100)
,sex varchar(100)
,mobilephone varchar(100)
,Email varchar(100)
,Telephone varchar(100)
,Birthday varchar(100)--add
,Nation VARCHAR(100)--add
,UPType varchar(100)-- edit  Identit
,Cmpid varchar(100)
,dep varchar(100)
,CostCenter varchar(100)
,BU varchar(100)
,SFZ varchar(100)
,HZ varchar(100)
,HZYXQ varchar(100)
,XSZ varchar(100)
,JRZ varchar(100)
,HXZ varchar(100)
,WGRYJJLZ varchar(100)
,GATXZ varchar(100)
,TWTXZ varchar(100)
,GJHYZ varchar(100)
,TBZ varchar(100)
,QT varchar(100)
,FlightVetting varchar(100)
,HotelVetting varchar(100)
,TrainVetting varchar(100)
,meno varchar(100)
,ZWJB VARCHAR(100)
,XTJS VARCHAR(100)
,YDLX VARCHAR(100)
,HotelBookRank VARCHAR(100)
,TrainBookRank VARCHAR(100)
,IDX NVARCHAR(100)
,EmployeeNo VARCHAR(100)
,FlightVetting2 varchar(100)
) 

INSERT INTO #P(userName,name,firstname,middlename,lastname,sex,mobilephone,Email,Telephone,Birthday,Nation,UPType,Cmpid,dep,CostCenter,BU,SFZ,HZ
,HZYXQ,XSZ,JRZ,HXZ,WGRYJJLZ,GATXZ,TWTXZ,GJHYZ,TBZ,QT,FlightVetting,HotelVetting,TrainVetting,meno,ZWJB,XTJS,YDLX,HotelBookRank,TrainBookRank,IDX,EmployeeNo,FlightVetting2)

--="UNION ALL SELECT '" &B2&"' AS userName,'" &C2&"' AS name,'"&D2&"' AS firstname,'"&E2&"' AS middlename,'"&F2&"' AS lastname,'"&G2&"' AS sex,'"&H2&"' AS mobilephone,'"&I2&"' AS Email,'"&J2&"' AS Telephone,'"&K2&"' AS Birthday,'"&L2&"' AS Nation,'"&M2&"' AS UPType,'"&N2&"' AS Cmpid,'"&O2&"' AS dep,'"&P2&"' AS CostCenter,'"&Q2&"' AS BU,'"&R2&"' AS SFZ,'"&S2&"' AS HZ,'"&T2&"' AS HZYXQ,'"&U2&"' AS XSZ,'"&V2&"' AS JRZ,'"&W2&"' AS HXZ,'"&X2&"' AS WGRYJJLZ,'"&Y2&"' AS GATXZ,'"&Z2&"' AS TWTXZ,'"&AA2&"' AS GJHYZ,'"&AB2&"' AS TBZ,'"&AC2&"' AS QT,'"&AD2&"' AS FlightVetting,'"&AE2&"' AS HotelVetting,'"&AF2&"' AS TrainVetting,'"&AG2&"' AS meno,'"&AH2&"' AS ZWJB,'"&AI2&"' AS XTJS,'"&AJ2&"' AS YDLX,'"&AK2&"' AS HotelBookRank,'"&AL2&"' AS TrainBookRank,'"&AM2&"' AS IDX,'"&AN2&"' AS EmployeeNo,'"&AO2&"' AS FlightVetting2"
SELECT '' AS userName,'' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'' AS mobilephone,'' AS Email,'' AS Telephone,'' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid,'' AS dep,'' AS CostCenter,'' AS BU,'' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank,'' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'XIE/MIN' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'13501993401' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'AJ434102' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'汪鑫' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'18817515007' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'510124199203080037' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'苏金龙' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'13918291764' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'42062119880917921X' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'郑龙' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'17502102134' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'310106199110270835' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'朱青青' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'15618657088' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'310115199401240026' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'陈婷婷' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'15800548064' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'310104198905012840' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'聂秋来' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'18817656670' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'15212619871001095X' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'沈奕宏' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'15601634616' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'07595168' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'应黎娜' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'18221140183' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'330283199010070088' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'张宇婕' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'15902114465' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'320804199303010308' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'兰征海' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'13072146158' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'310115197804081139' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'於晨钶' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'13661628314' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'339005199402183418' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2
UNION ALL SELECT '' AS userName,'华婷婷' AS name,'' AS firstname,'' AS middlename,'' AS lastname,'' AS sex,'18321373721' AS mobilephone,'' AS Email,'' AS Telephone,'1993-01-15' AS Birthday,'' AS Nation,'' AS UPType,'' AS Cmpid, '' AS dep,'' AS CostCenter,'' AS BU,'321027199409146643 ' AS SFZ,'' AS HZ,'' AS HZYXQ,'' AS XSZ,'' AS JRZ,'' AS HXZ,'' AS WGRYJJLZ,'' AS GATXZ,'' AS TWTXZ,'' AS GJHYZ,'' AS TBZ,'' AS QT,'' AS FlightVetting,'' AS HotelVetting,'' AS TrainVetting,'' AS meno,'' AS ZWJB,'' AS XTJS,'' AS YDLX,'' AS HotelBookRank, '' AS TrainBookRank,'' AS IDX,'' AS EmployeeNo,'' AS FlightVetting2

select * from  #p

---------------------------------------------------------------------------------------------------------
--检查出生日期不规范的
SELECT *
FROM #p 
WHERE REPLACE(Birthday,' ','')<>'' AND ISDATE(REPLACE(Birthday,' ',''))=0
--更新为空的出生日期为null
UPDATE #p SET Birthday = NULL WHERE REPLACE(Birthday,' ','')=''
--更新有效日期的为yyyy-MM-dd
UPDATE #P SET Birthday=CONVERT(VARCHAR(10),CAST(REPLACE(Birthday,' ','') AS DATETIME),120) WHERE ISDATE(REPLACE(Birthday,' ',''))=1
---------------------------------------------------------------------------------------------------------


USE  homsomDB

BEGIN TRAN

--声明变量
DECLARE @CmpGuid UNIQUEIDENTIFIER
DECLARE @cus nvarchar(225)  
SET @CmpGuid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
SET @cus = (select top 1 convert(int,SUBSTRING(CustID,2,6)) from Trv_UnitPersons where CustID not like 'D9%' and CustID not like 'D7%' order by CustID desc)  




--插入临时表
IF OBJECT_ID('tempdb.dbo.#Trv_Human') IS NOT NULL DROP TABLE #Trv_Human
SELECT NEWID() AS ID,GETDATE() AS ver,CASE sex WHEN '男'THEN 1 WHEN '女' THEN 0 ELSE NULL END AS Gender,
	Name,FirstName,MiddleName,LastName,mobilephone AS Mobile,Email,Telephone,Birthday AS Birthday,GETDATE() AS CreateDate,
	'herry' AS createBy,@CmpGuid AS companyid,UPType 
	,userName,dep AS CompanyDptId,CostCenter AS CostCenterID,FlightVetting AS VettingTemplateID,HotelVetting AS HotelVettingTemplateID,id AS ix,meno AS Remarks
INTO #Trv_Human
FROM #p

IF OBJECT_ID('tempdb.dbo.#Trv_BookingCollections') IS NOT NULL DROP TABLE #Trv_BookingCollections
SELECT id AS userGuid,NEWID() AS id,GETDATE()AS ver,'' AS ModifyBy,GETDATE() AS CreateDate,'herry' AS CreateBy,1 AS BookingType
INTO #Trv_BookingCollections
FROM #Trv_Human

IF OBJECT_ID('tempdb.dbo.#Trv_ReportCollections') IS NOT NULL DROP TABLE #Trv_ReportCollections
SELECT  id AS userGuid,NEWID()AS ID,GETDATE()AS Ver,'' AS ModifyBy,GETDATE() AS CreateDate,'herry' AS CreateBy
INTO #Trv_ReportCollections
FROM #Trv_Human

IF OBJECT_ID('tempdb.dbo.#Trv_UPSettings') IS NOT NULL DROP TABLE #Trv_UPSettings
SELECT NEWID()AS ID,GETDATE()AS Ver,'herry' AS CreateBy,'d848689b97b8d893734fb6abaacdfe5f8c6fdcd9' AS PASSWORD,
GETDATE() AS CreateDate,1 AS EnableVetting,t1.id AS BookingCollectionID,t2.id AS ReportCollectionID,t1.userGuid
INTO #Trv_UPSettings
FROM #Trv_BookingCollections t1
INNER JOIN #Trv_ReportCollections t2 ON t1.userGuid=t2.userGuid

IF OBJECT_ID('tempdb.dbo.#Trv_UnitPersons') IS NOT NULL DROP TABLE #Trv_UnitPersons
SELECT H.ID ,H.userName ,CAST('' AS VARCHAR(100)) AS CustID,H.UPType AS TYPE,'' AS Identit,Mobile AS Phone,GETDATE() AS RegDate ,
'' AS Sales,'' AS DevDate,'' AS PayType,'' AS SettleType,'' AS RecommendedBy,
'' AS EmployeeNo,S.ID AS UPSettingID,@CmpGuid AS CompanyID,H.CompanyDptId,H.CostCenterID,'' AS TCMemo,H.VettingTemplateID,H.HotelVettingTemplateID,NULL AS UPRoleID,NULL AS UPRankID,Remarks
,H.ix
INTO #Trv_UnitPersons
FROM #Trv_Human H
INNER JOIN #Trv_UPSettings S ON H.ID = S.userGuid

--更新临时的UP表
DECLARE @Ix int	
DECLARE @MaxIx INT
DECLARE @CustID INT
SELECT @Ix=MIN(ix),@MaxIx=MAX(ix) FROM #Trv_UnitPersons
--SELECT @CustID=MAX(convert(int,SUBSTRING(CustID,2,6)))  FROM Trv_UnitPersons where CustID not like 'D9%' and CustID not like 'D7%' 
SELECT @CustID=CAST(nnum AS INT) FROM Topway..tbcom WHERE cname='018900'
PRINT('初始的custID:')
PRINT(@CustID)
UPDATE Topway..tbcom  SET nnum=nnum+@MaxIx+1  WHERE cname='018900'
WHILE(@Ix<=@MaxIx)
BEGIN
	SET @CustID=@CustID+1
	
	UPDATE #Trv_UnitPersons SET CustID='D'+CAST(@CustID AS VARCHAR(10))
	WHERE ix=@Ix
	
	SET @Ix=@Ix+1
	
	IF @@ERROR<>0 GOTO EndOut
END



--插入实际表
insert into Trv_Human (ID,ver,Gender,Name,FirstName,MiddleName,LastName,Mobile,Email,Telephone,CreateDate,CreateBy,companyid,BirthDay)   
SELECT ID,ver,Gender,Name,FirstName,MiddleName,LastName,Mobile,Email,Telephone,CreateDate,CreateBy,companyid,BirthDay
FROM #Trv_Human

IF @@ERROR<>0 GOTO EndOut

insert into Trv_Traveler (ID,TicketName) 
SELECT id,ISNULL(Name,FirstName+'/'+LastName) AS NAME
FROM #Trv_Human

IF @@ERROR<>0 GOTO EndOut

insert into Trv_BookingCollections(ID,Ver,ModifyBy,CreateDate,CreateBy,BookingType) 
SELECT ID,Ver,ModifyBy,CreateDate,CreateBy,BookingType 
FROM #Trv_BookingCollections

IF @@ERROR<>0 GOTO EndOut

insert into Trv_ReportCollections(ID,Ver,ModifyBy,CreateDate,CreateBy) 
SELECT ID,Ver,ModifyBy,CreateDate,CreateBy
FROM #Trv_ReportCollections 

IF @@ERROR<>0 GOTO EndOut

insert into Trv_UPSettings(ID,Ver,CreateBy,Password,CreateDate,EnableVetting,BookingCollectionID,ReportCollectionID) 
SELECT ID,Ver,CreateBy,Password,CreateDate,EnableVetting,BookingCollectionID,ReportCollectionID
FROM #Trv_UPSettings

IF @@ERROR<>0 GOTO EndOut



insert into Trv_UnitPersons(ID,UserName,   
CustID, Type, Identit, Phone, RegDate,   
Sales, DevDate, Paytype, SettleType, RecommendedBy,   
EmployeeNo,UPSettingID,CompanyID,CompanyDptId,CostCenterID,TCMemo,VettingTemplateID,Remarks)--,UPRoleID,UPRankID)  
SELECT ID,UserName,   
CustID, Type, Identit, Phone, RegDate,   
Sales, DevDate, Paytype, SettleType, RecommendedBy,   
'' AS EmployeeNo
,CASE ISNULL(RTRIM(LTRIM(UPSettingID)),'') WHEN '' THEN NULL ELSE UPSettingID END AS UPSettingID
,CompanyID
,null AS CompanyDptId
,NULL AS CostCenterID
,TCMemo
, null AS VettingTemplateID
,Remarks
FROM #Trv_UnitPersons

IF @@ERROR<>0 GOTO EndOut




---插入证件号
insert into Trv_Credentials(ID,Ver,HumanID,CreateBy,CreateDate,Type,CredentialNo) 
SELECT NEWID() AS ID,GETDATE() AS Ver,H.ID AS HumanID,'herry' AS CreateBy,GETDATE() AS CreateDate,
idType.idType AS TYPE,idType.idNo AS CredentialNo
FROM #Trv_Human H 
INNER JOIN (
 SELECT p.ID,SFZ AS idNo,1 AS idType FROM #P P WHERE SFZ<>''
union all SELECT p.ID,HZ AS idNo,2 AS idType FROM #P P WHERE HZ<>''
union all SELECT p.ID,XSZ AS idNo,3 AS idType FROM #P P WHERE XSZ<>''
union all SELECT p.ID,JRZ AS idNo,4 AS idType FROM #P P WHERE JRZ<>''
union all SELECT p.ID,HXZ AS idNo,5 AS idType FROM #P P WHERE HXZ<>''
union all SELECT p.ID,WGRYJJLZ AS idNo,6 AS idType FROM #P P WHERE WGRYJJLZ<>''
union all SELECT p.ID,GATXZ AS idNo,7 AS idType FROM #P P WHERE GATXZ<>''
union all SELECT p.ID,TWTXZ AS idNo,8 AS idType FROM #P P WHERE TWTXZ<>''
union all SELECT p.ID,GJHYZ AS idNo,9 AS idType FROM #P P WHERE GJHYZ<>''
union all SELECT p.ID,TBZ AS idNo,10 AS idType FROM #P P WHERE TBZ<>''
union all SELECT p.ID,QT AS idNo,11 AS idType FROM #P P WHERE QT<>''
) idType ON H.ix=idType.id

IF @@ERROR<>0 GOTO EndOut



--更新原trv_hum
--UPDATE homsomDB..Trv_Human SET IsDisplay=0
--FROM homsomDB..Trv_Human H 	
--INNER JOIN homsomDB..Trv_UnitPersons UP ON H.id=UP.ID AND h.createDate<'2015-04-21 13:40:00' AND h.IsDisplay=1
--WHERE UP.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'--@CmpGuid
----AND H.Ver<DATEADD(MINUTE,-10,GETDATE())

--IF @@ERROR<>0 GOTO EndOut


EndOut:
if @@error<>0  
BEGIN  
SELECT @@ERROR
ROLLBACK TRANSACTION  
END  
ELSE  
COMMIT TRANSACTION  

--同步ERP
insert into topway..tbCusholderM(cmpid,custid,ccustid,custname,custtype1,male,username,phone,mobilephone,personemail,CardId,custtype,homeadd,joindate) 
select cmpid,CustID,CustID,h.Name,
CASE
WHEN u.Type='普通员工' THEN ''
WHEN u.Type='经办人' THEN '3'
WHEN u.Type='负责人' THEN '4'
WHEN u.Type='高管' THEN '5'
ELSE 2 end
,
CASE 
WHEN h.Gender=1 THEN '男'
WHEN h.Gender=0 THEN '女'
ELSE '男' end
,'',h.Telephone,h.Mobile,h.Email,'',u.CustomerType,'手工批量导入' ,h.CreateDate
FROM homsomDB..Trv_UnitPersons u
INNER JOIN homsomDB..Trv_Human h ON u.id =h.ID
INNER JOIN homsomDB..Trv_UnitCompanies c ON u.CompanyID=c.ID 
WHERE Cmpid in (SELECT cmpid FROM homsomDB..Trv_UnitCompanies WHERE id='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66') 
and CustID not in (Select CustID from topway..tbCusholderM )
AND h.IsDisplay=1 and CONVERT(varchar(8),h.CreateDate,112)=CONVERT(varchar(8),GETDATE(),112)





--以下不执行！！！！！


SELECT name,dep,depart.ID,depart.DepName 
FROM #p p
LEFT JOIN  homsomDB..Trv_CompanyStructure depart ON depart.DepName=p.dep
WHERE depart.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

UPDATE homsomDB..Trv_UnitPersons SET CompanyDptId=depart.ID
FROM homsomDB..Trv_UnitPersons up 
INNER JOIN homsomDB..Trv_Human h ON up.ID=h.ID AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' AND h.IsDisplay=1
INNER JOIN #p p ON h.Name=p.name AND h.Email=p.Email
INNER JOIN  homsomDB..Trv_CompanyStructure depart ON depart.DepName=p.dep AND depart.CompanyId = up.CompanyID

SELECT p.NAME,p.*--,depart.DepName,depart.id
FROM homsomDB..Trv_UnitPersons up 
INNER JOIN homsomDB..Trv_Human h ON up.ID=h.ID AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'AND h.IsDisplay=1 AND H.Name='测试'
INNER JOIN #p p ON h.Name=p.name AND h.Email=p.Email
LEFT JOIN  homsomDB..Trv_CompanyStructure depart ON depart.DepName=p.dep AND depart.CompanyId = up.CompanyID
WHERE depart.ID IS NULL

UPDATE #p SET Identit='高管级' WHERE Identit='审核人'
SELECT * FROM Trv_UPRanks WHERE CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

SELECT H.Email,H.Name,up.type AS [员工属性],up.UPRoleID
,dep.depName AS [部门]
,center.Name AS [成本中心]
,UP.Identit AS [员工身份]
,Ro.Name AS [系统角色]
,sett.BookingCollectionID
,CASE bookCo.BookingType WHEN 0 THEN '不可预订' WHEN 1 THEN '自身预订' WHEN 2 THEN '所有预订' ELSE '' END AS [预订类型]
,Ra.Name AS [职位级别]
,sett.SyncUpdatePassage
,CASE sett.SyncUpdatePassage WHEN 0 THEN '否' WHEN '1' THEN '是' ELSE '未知'END AS [同步更新乘机人]
,sett.VettingAidSMS
,sett.VettingAidEmail
,UP.ServiceRank AS [服务等级]
FROM homsomDB..Trv_Human H 	
INNER JOIN homsomDB..Trv_UnitPersons UP ON H.id=UP.ID AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
LEFT JOIN homsomDB..Trv_UPBookingRanks BookRank ON UP.UPBookingRankID=BookRank.ID
LEFT JOIN homsomDB..Trv_UPSettings sett ON sett.ID=UP.UPSettingID
LEFT JOIN dbo.Trv_UPRoles Ro ON UP.UPRoleID = Ro.ID
LEFT JOIN dbo.Trv_UPRanks Ra ON UP.UPRankID=Ra.ID
LEFT JOIN Trv_BookingCollections bookCo ON sett.BookingCollectionID=bookCo.ID
LEFT JOIN dbo.Trv_CostCenter center ON up.CostCenterID=center.ID
LEFT JOIN Trv_CompanyStructure dep ON up.CompanyDptId=dep.ID
WHERE H.IsDisplay=1


--更新系统角色
SELECT *
FROM Trv_UPRoles WHERE UnitCompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

UPDATE  dbo.Trv_UnitPersons SET UPRoleID='404DFAB7-10C8-4BCF-90DF-A4B300C236FB'--员工
--UPDATE  dbo.Trv_UnitPersons SET UPRoleID='738D1D04-8791-4D65-8C78-A99201167022'--审批人
--UPDATE  dbo.Trv_UnitPersons SET UPRoleID='93CD2859-ED23-4435-91E9-A9920116AF34'--管理员
--UPDATE  dbo.Trv_UnitPersons SET UPRoleID='DE043B36-0CD9-4E6D-9C33-A9A5010349F0'--预订人
--SELECT UPRoleID
FROM homsomDB..Trv_UnitPersons up
INNER JOIN homsomDB..Trv_Human h ON up.id=h.id AND h.IsDisplay=1 AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' 
INNER JOIN #p p ON h.Name=p.name AND h.FirstName=p.firstname
--AND p.XTJS='预订人'
--AND p.XTJS='管理员'
--AND p.XTJS='审批人'
AND p.XTJS='普通员工'



--[预订类型]
UPDATE Trv_BookingCollections SET BookingType=1
--SELECT bookCo.*
FROM homsomDB..Trv_UnitPersons UP 
INNER JOIN homsomDB..Trv_Human h ON up.id=h.ID AND h.IsDisplay=1 AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
INNER JOIN #p p ON h.Name=p.name and h.LastName=p.lastname
INNER JOIN homsomDB..Trv_UPSettings sett ON sett.ID=UP.UPSettingID  AND h.IsDisplay=1
INNER JOIN Trv_BookingCollections bookCo ON sett.BookingCollectionID=bookCo.ID
where bookco.Ver>=GETDATE()-1
and p.YDLX='自身预订'

--不可预订0
--自身预订1
--为他人预订2
--所有预订3

update Trv_BookingCollections SET BookingType=0
--select * 
FROM homsomDB..Trv_UnitPersons UP 
INNER JOIN homsomDB..Trv_Human h ON up.id=h.ID AND h.IsDisplay=1 AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
INNER JOIN homsomDB..Trv_UPSettings sett ON sett.ID=UP.UPSettingID  AND h.IsDisplay=1
INNER JOIN Trv_BookingCollections bookCo ON sett.BookingCollectionID=bookCo.ID 


--是否同步乘机人
UPDATE homsomDB..Trv_UPSettings SET SyncUpdatePassage=0
--SELECT sett.SyncUpdatePassage,sett.*
FROM homsomDB..Trv_UnitPersons UP 
INNER JOIN homsomDB..Trv_UPSettings sett ON sett.ID=UP.UPSettingID AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

--更新手机
UPDATE homsomDB..Trv_Human SET Mobile=p.mobilephone
FROM #p p INNER JOIN dbo.Trv_Human h ON p.NAME=h.Name AND h.IsDisplay=1
INNER JOIN  dbo.Trv_UnitPersons up ON h.id=up.id AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'



--部门
SELECT * FROM homsomDB..Trv_CompanyStructure WHERE CompanyId='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'


--(339 行受影响)
UPDATE homsomDB..Trv_UnitPersons SET CompanyDptId=dep.id
--SELECT h.name, dep.*
--
--SELECT *
--p.NAME,dep.id,COUNT(1) t
FROM homsomDB..Trv_Human H 	
INNER JOIN homsomDB..Trv_UnitPersons UP ON H.id=UP.ID AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' 
												AND h.IsDisplay=1 --AND h.CreateDate>'2017-7-16'
INNER JOIN #p p ON h.name=p.name AND h.FirstName=p.firstname
inner JOIN homsomDB..Trv_CompanyStructure dep ON p.dep=dep.DepName AND dep.CompanyId='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
--WHERE dep.ID IS NULL
--GROUP BY p.NAME,dep.ID
--ORDER BY T

--成本中心

SELECT DISTINCT Name,CompanyID,* FROM homsomDB..Trv_CostCenter WHERE CompanyId='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'


UPDATE homsomDB..Trv_UnitPersons  SET CostCenterID=center.id
--SELECT up.CostCenterID,*
FROM homsomDB..Trv_Human H 	
INNER JOIN homsomDB..Trv_UnitPersons UP ON H.id=UP.ID AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' 
												AND h.IsDisplay=1 --AND h.CreateDate>'2015-7-2'
INNER JOIN #p p ON h.name=p.name and h.FirstName=p.firstname
INNER JOIN homsomDB..Trv_CostCenter center ON p.costCenter=center.Name AND center.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

--员工编号
UPDATE homsomDB..Trv_UnitPersons SET EmployeeNo=p.IDX
--SELECT p.*,p.employeeNo,up.EmployeeNo
--SELECT up.EmployeeNo,h.*,up.*
FROM homsomDB..Trv_Human H 	
INNER JOIN homsomDB..Trv_UnitPersons UP ON H.id=UP.ID AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' 
												AND h.IsDisplay=1 --AND CreateDate>'2015-6-26' AND CreateBy='herry'
INNER JOIN #p p ON h.name=p.name and  h.Mobile=p.mobilephone

--ORDER BY h.name



--审批辅助工具
UPDATE homsomDB..Trv_UPSettings SET VettingAidEmail=1,VettingAidSMS=1 --默认0不启用，1启用
--SELECT sett.SyncUpdatePassage,sett.*
FROM homsomDB..Trv_UnitPersons UP 
inner join homsomDB..Trv_Human H on h.id=UP.ID and h.IsDisplay=1
INNER JOIN homsomDB..Trv_UPSettings sett ON sett.ID=UP.UPSettingID AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
--where h.Name in ('路萍','孙瑾')


--机票审批模板设置
IF OBJECT_ID('tempdb.dbo.#template') IS NOT NULL DROP TABLE #template
SELECT VettingTemplateID,TemplateName
INTO #template
FROM homsomDB..Trv_VettingTemplate_UnitCompany  t1
INNER JOIN homsomDB..Trv_VettingTemplates t2 ON t1.VettingTemplateID=t2.ID
WHERE UnitCompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

select * from #template



UPDATE #p SET FlightVetting=t.VettingTemplateID
--SELECT *,REPLACE(t.TemplateName,'审批一级模板-','')
FROM #p p
INNER JOIN #template t ON p.FlightVetting=REPLACE(t.TemplateName,'审批一级模板-','')

UPDATE #p SET FlightVetting=t.VettingTemplateID
--SELECT *,REPLACE(t.TemplateName,'审批1级模版-','')
FROM #p p
INNER JOIN #template t ON p.FlightVetting=REPLACE(t.TemplateName,'审批1级模版-','')
 
UPDATE #p SET FlightVetting=t.VettingTemplateID
--SELECT *,REPLACE(t.TemplateName,'审批二级模板-','')
FROM #p p
INNER JOIN #template t ON p.FlightVetting=REPLACE(t.TemplateName,'审批二级模板-','')

UPDATE #p SET FlightVetting=t.VettingTemplateID
--SELECT *,REPLACE(t.TemplateName,'审批2级模版-','')
FROM #p p
INNER JOIN #template t ON p.FlightVetting=REPLACE(t.TemplateName,'审批2级模版-','')


select * from #p


UPDATE Trv_UnitPersons SET VettingTemplateID=p.FlightVetting
--SELECT p.*
FROM Trv_UnitPersons up
INNER JOIN Trv_Human h ON up.id=h.ID AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' AND h.IsDisplay=1
INNER JOIN #p p ON h.Name=p.name and h.FirstName=p.firstname 
where FlightVetting<>'' --and FlightVetting2<>''

SELECT Name,COUNT(1)
FROM homsomDB..Trv_UnitPersons up
INNER JOIN homsomDB..Trv_Human h ON up.id=h.ID AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' AND h.IsDisplay=1
GROUP BY NAME HAVING COUNT(1)>1

--机票是否需要审批
update Trv_UPSettings set EnableVetting=1
--select * 
from Trv_UnitPersons up 
left join Trv_UPSettings sett on sett.ID=up.UPSettingID
left join Trv_Human h on h.ID=up.ID and h.IsDisplay=1 --and h.CreateDate>=GETDATE()-1
inner join #P p on p.name=h.Name and p.lastname=h.LastName and p.FlightVetting<>'' 
where up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'


--酒店审批模板设置
IF OBJECT_ID('tempdb.dbo.#template_hotel') IS NOT NULL DROP TABLE #template_hotel
SELECT VettingTemplateHotelID,TemplateName
INTO #template_hotel
FROM homsomDB..Trv_VettingTemplateHotel_UnitCompany  t1
INNER JOIN homsomDB..Trv_VettingTemplates_Hotel t2 ON t1.VettingTemplateHotelID=t2.ID
WHERE UnitCompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

select * from #template_hotel

UPDATE #p SET HotelVetting=t.VettingTemplateHotelID
--SELECT *,REPLACE(t.TemplateName,'审批一级模板-','')
FROM #p p
INNER JOIN #template_hotel t ON p.HotelVetting=REPLACE(t.TemplateName,'审批一级模板-','')



UPDATE #p SET HotelVetting=t.VettingTemplateHotelID
--SELECT *,REPLACE(t.TemplateName,'审批二级模板-','')
FROM #p p
INNER JOIN #template_hotel t ON p.HotelVetting=REPLACE(t.TemplateName,'审批二级模板-','')


select * from #p



UPDATE Trv_UnitPersons SET HotelVettingTemplateID=p.HotelVetting
--SELECT p.*
FROM Trv_UnitPersons up
INNER JOIN Trv_Human h ON up.id=h.ID AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' AND h.IsDisplay=1
INNER JOIN #p p ON h.Name=p.name and h.FirstName=p.firstname
where HotelVetting<>'' 

--酒店是否审批
update Trv_UPSettings set EnableHotelVetting=1
--select * 
from Trv_UnitPersons up 
left join Trv_UPSettings sett on sett.ID=up.UPSettingID
left join Trv_Human h on h.ID=up.ID and h.IsDisplay=1 --and h.CreateDate>=GETDATE()-1
inner join #P p on p.name=h.Name and p.firstname=h.FirstName and p.HotelVetting<>''
where up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'





--插入
INSERT INTO dbo.Trv_UPCollections_UnitPersons
        ( UPCollectionID, UnitPersonID )
--查询
  SELECT b.ID AS upcollectionid,u.ID AS unitpersonid FROM homsomDB..Trv_UnitPersons u 
  LEFT JOIN homsomDB..Trv_UnitCompanies c on u.CompanyID=c.ID
  LEFT JOIN homsomDB..Trv_UPSettings s ON u.UPSettingID=s.id
  LEFT JOIN homsomDB..Trv_BookingCollections b ON s.BookingCollectionID=b.ID
  inner join homsomDB..Trv_Human h on h.ID=u.ID
  WHERE c.Cmpid in (SELECT cmpid FROM homsomDB..Trv_UnitCompanies WHERE id='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66') and b.BookingType=1 and h.CreateDate>=GETDATE()-1

--火车票审批
select * from homsomDB..Trv_VettingTemplateTrain_UnitCompany

IF OBJECT_ID('tempdb.dbo.#template_train') IS NOT NULL DROP TABLE #template_train
SELECT VettingTemplateTrainID,TemplateName
INTO #template_train
FROM homsomDB..Trv_VettingTemplateTrain_UnitCompany  t1
INNER JOIN homsomDB..Trv_VettingTemplates_Train t2 ON t1.VettingTemplateTrainID=t2.ID
WHERE UnitCompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

select * from #template_train

UPDATE #p SET TrainVetting=t.VettingTemplatetrainID
--SELECT *,REPLACE(t.TemplateName,'审批一级模板-','')
FROM #p p
INNER JOIN #template_train t ON p.TrainVetting=REPLACE(t.TemplateName,'审批一级模板-','')

UPDATE #p SET TrainVetting=t.VettingTemplatetrainID
--SELECT *,REPLACE(t.TemplateName,'审批二级模板-','')
FROM #p p
INNER JOIN #template_train t ON p.TrainVetting=REPLACE(t.TemplateName,'审批二级模板-','')

UPDATE Trv_UnitPersons SET TrainVettingTemplateID=p.TrainVetting
--SELECT p.*
FROM Trv_UnitPersons up
INNER JOIN Trv_Human h ON up.id=h.ID AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' AND h.IsDisplay=1
INNER JOIN #p p ON h.Name=p.name and p.firstname=h.FirstName
where TrainVetting<>'' 

update Trv_UPSettings set EnableTrainVetting=1
--select * 
from Trv_UnitPersons up 
left join Trv_UPSettings sett on sett.ID=up.UPSettingID
left join Trv_Human h on h.ID=up.ID and h.IsDisplay=1 --and h.CreateDate>=GETDATE()-1
inner join #P p on p.name=h.Name and p.firstname=h.FirstName and p.TrainVetting<>''
where up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'



--更新职位级别(机票预订权限)
select * from Trv_UPRanks where CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

UPDATE homsomDB..Trv_UnitPersons SET UPRankID='ECBBDFF5-6F99-4AB5-BCC5-A9A5010553CD'
--select UPRankID,*
FROM homsomDB..Trv_Human H 	INNER JOIN homsomDB..Trv_UnitPersons UP ON H.id=UP.ID AND IsDisplay=1 AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
INNER JOIN #p p ON p.NAME=h.Name and p.ZWJB='全部舱位' AND h.FirstName=p.firstname 
where CreateDate>=GETDATE()-1






--更新酒店预订权限
SELECT * FROM homsomDB..Trv_UPbookingRanks WHERE CompanyID ='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' 

UPDATE homsomDB..Trv_UnitPersons SET UPBookingRankID = 'C1E02F50-F789-4227-A179-A9A50103C7D8'
--SELECT up.UPBookingRankID
FROM homsomDB..Trv_Human H 	
INNER JOIN homsomDB..Trv_UnitPersons UP ON H.id=UP.ID AND IsDisplay=1  AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
inner join #P p on p.name=h.Name and p.firstname=h.FirstName and p.HotelBookRank='酒店预订'
where h.CreateDate>=GETDATE()-1

--火车票预订权限
SELECT * FROM homsomDB..Trv_UPTrainRanks WHERE CompanyID ='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' 

UPDATE homsomDB..Trv_UnitPersons SET UPTrainRankID = '430650E9-A263-4BA8-AA0C-56F3438BBB50'
--SELECT up.UPTrainRankID
FROM homsomDB..Trv_Human H 	
INNER JOIN homsomDB..Trv_UnitPersons UP ON H.id=UP.ID AND IsDisplay=1  AND up.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
inner join #P p on p.name=h.Name and p.lastname=h.LastName and p.TrainBookRank='副总级别'
where h.CreateDate>=GETDATE()-1







--------------------------------------------------------------------------------------------------------------
--更新国籍
select * from homsomDB..Trv_Nationalities where Name like ('%美国%')

UPDATE homsomDB..Trv_Human SET  NationID='AC38682B-67F8-4FD3-9CCF-05FE34F195D2'
--select NationID,*  
FROM homsomDB..Trv_Human h
INNER JOIN homsomDB..Trv_UnitPersons up ON h.ID=up.ID AND h.IsDisplay=1 AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
INNER JOIN #p p ON h.Name=p.name and h.FirstName=p.firstname--此处条件视情况更改，保证能关联到#p的每条记录 
and p.Nation='美国'



---------------------------------------------------------------------------------------------------------------

--插入身份证
insert into Trv_Credentials(ID,Ver,HumanID,CreateBy,CreateDate,Type,CredentialNo) 
SELECT NEWID() AS ID,GETDATE() AS Ver,up.id AS HumanID,'herry' AS CreateBy,GETDATE() AS CreateDate,
1 AS TYPE,p2.SFZ AS CredentialNo

--select * 
from #P p2 
inner join (Select distinct h.Name,h.ID from Trv_UnitPersons p inner join Trv_Human h on h.ID=p.id and h.IsDisplay=1 where p.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66') up on p2.name=up.Name
where p2.name not in (select h.Name
from homsomDB..Trv_UnitPersons p
inner join Trv_Human h on h.ID=p.ID and IsDisplay=1 
inner join Trv_Credentials cr on cr.HumanID=h.ID 
inner join #P p2 on  h.name=p2.name
where p.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' )

--护照有效期
update Trv_Credentials set ExpirDate=HZYXQ
--select ExpirDate,* 
from Trv_Credentials cr 
left join Trv_Human h on h.ID=cr.HumanID and h.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' and h.IsDisplay=1
left join #p p on p.hz=cr.CredentialNo
where  type=2 and h.companyid='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' 


--BU
select * from #P

select * from homsomDB..Trv_CompanyUndercover
where CompanyId='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'



update #P set bu=bu.ID
--select * 
from #P p
left join homsomDB..Trv_CompanyUndercover bu on bu.UnderName=p.BU

update #P set name=h.ID
--select * 
from #P p
left join homsomDB..Trv_Human h on h.Name=p.name
left join homsomDB..Trv_UnitPersons up on up.ID=h.ID
where up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' 

update Trv_UnitPersons set CompanyUnderId=p.BU
--Select p.name,p.bu
from Trv_UnitPersons up
left join #P p on up.id=p.name
where up.CompanyId='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
and p.name is not null


select h.Name,bu.UnderName from Trv_UnitPersons up 
left join Trv_UnitCompanies uc on uc.ID=up.CompanyID
left join homsomDB..Trv_CompanyUndercover bu on bu.id=up.CompanyUnderId
left join Trv_Human h on h.ID=up.ID and IsDisplay=1 and h.Name is not null
where up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'


--原已导入过常旅客 需要附加的信息
--登录名
update Trv_UnitPersons set UserName=p.userName
--select up.username 
from Trv_UnitPersons up
inner join Trv_Human h on h.ID=up.ID and IsDisplay=1
inner join #P p on p.name=h.Name and p.firstname=h.FirstName
where up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

--邮箱
update Trv_Human set Email=p.Email
--select h.Email,*
from Trv_Human h
inner join Trv_UnitPersons up on h.ID=up.ID and IsDisplay=1
inner join #P p on p.name=h.Name and p.firstname=h.FirstName
where up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

--手机号
update Trv_Human set Mobile=p.mobilephone
--select p.mobilephone,*
from Trv_Human h
inner join Trv_UnitPersons up on h.ID=up.ID and IsDisplay=1
inner join #P p on p.name=h.Name and p.firstname=h.FirstName
where up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'


--生日

update Trv_Human set BirthDay=p.Birthday
--select * 
from Trv_Human h
inner join Trv_UnitPersons up on up.ID=h.ID and IsDisplay=1 and up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
inner join #P p on p.name=h.Name --and p.firstname=h.FirstName 
where up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'

--TMS删除
UPDATE dbo.Trv_Human SET IsDisplay=0,ModifyDate=GETDATE()
 --SELECT h.*,up.*
 FROM  dbo.Trv_Human (NOLOCK) h
 INNER JOIN dbo.Trv_UnitPersons(NOLOCK) up ON h.id=up.id AND up.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66'
	AND h.IsDisplay=1  
	--and CreateDate>=GETDATE()-1
	--and h.Name in (Select Name from #p)
	--and h.name  in ('余意')
	--and CreateDate>=GETDATE()-1
	
	
--ERP删除
delete
--select * 
from Topway..tbCusholderM where custid in 
(select CustID from Trv_UnitPersons p
inner join Trv_Human h on h.ID=p.ID
where p.CompanyID='0DECE3F0-ECA0-4022-8A51-A99D00A4EB66' and IsDisplay=0)
	
	
	

	
