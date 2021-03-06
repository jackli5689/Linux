--（产品专用）保险结算价信息
select sprice1,totsprice,* from Topway..tbcash 
--update Topway..tbcash set sprice1='2.4',totsprice='2.4'
where coupno in('AS002167918','AS002175272','AS002178659','AS002180056','AS002183312','AS002187205','AS002187206','AS002196308','AS002197840','AS002201331')

select sprice1,totsprice,* from Topway..tbcash 
--update Topway..tbcash  set sprice1='3.6',totsprice='3.6'
where coupno in('AS002171346','AS002172383','AS002173147','AS002173186','AS002175552','AS002176814','AS002176815','AS002176847','AS002176881','AS002181809',
'AS002184583','AS002185517','AS002186196','AS002186197','AS002189922','AS002191852','AS002198159','AS002198160','AS002198170','AS002198169','AS002198168',
'AS002198167','AS002198166','AS002198165','AS002198164','AS002198163','AS002198162','AS002198161','AS002203016','AS002203029','AS002203065','AS002204593')

select sprice1,totsprice,* from Topway..tbcash 
--update Topway..tbcash  set sprice1='2',totsprice='2'
where coupno='AS002196526'

--行程单、特殊票价
select info3,* from Topway..tbcash 
--update Topway..tbcash set info3='需打印中文行程单'
where coupno='AS002173916' and ticketno=3421410165

--销售价信息
select xfprice,totprice,* from Topway..tbcash 
--update Topway..tbcash set xfprice='0',totprice='10799'
where coupno='AS002204573'

--财务酒店核销结算价
select totprice,owe,* from Topway..tbhtlyfchargeoff 
--update Topway..tbhtlyfchargeoff  totprice='-6698.00',owe='-6698.00'
where coupid in(select id from Topway..tbHtlcoupYf where CoupNo='-PTW071668')

--导入13000000000名单
select * from tbCusholder where mobilephone='13000000000'
select * from Topway..tbCusmem where mobile='13000000000'
INSERT INTO [Topway].[dbo].[tbCusmem](
      [custid]
      ,[name]
      ,[idno]
      ,[info]
      ,[mobile]
      ,[ntype]
      ,[ttype]
      ,[ptype]
      ,[ophis]
      ,[opername]
      ,[operdate]
      ,[showstatus]
      ,[idnotype]
      ,[type]
      ,[idnoexpiretime]
      ,[sex]
      ,[country]
      ,[city]
      ,[zipcode]
      ,[birthday]
      ,[IssuedTo]
      ,[PlayerType]
      ,[email]
      ,[docs]
      ,[customertype])
--="UNION ALL SELECT 'D902892' as custid,'" &B2&"' AS name,'" &C2&"' AS idno,'','" &D2&"' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''"
SELECT 'D902892' as custid,'周蓉' AS name,'420822198203295000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'谢迪' AS name,'430104198306245615' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'唐宏榜' AS name,'430581198405206536' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'龙成学' AS name,'430419197510097476' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'王姝婷' AS name,'430124199209100027' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'姚银' AS name,'430122198106134366' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'张超群' AS name,'431021198812164481' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''

UNION ALL SELECT 'D902892' as custid,'周蓉' AS name,'420822198203295000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'赵琴' AS name,'420281199104100000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'张惠' AS name,'420103197702200000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'邓玉' AS name,'420102198107281000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'庞旖' AS name,'421223199208020000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'张少元' AS name,'422123198005100000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'郑杰' AS name,'310109197912094000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'程凯' AS name,'420111197706054000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'詹悦' AS name,'362334199208090000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'张宇洁' AS name,'410302199508100000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'唐明凯' AS name,'422201199009270000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'蒋文权' AS name,'420902199005246000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''
UNION ALL SELECT 'D902892' as custid,'杨毅' AS name,'150204198606090000' AS idno,'','13000000000' AS mobile,0,0,0,'','SYS',GETDATE(),1,'身份证','','','','','','','','','','','',''

---酒店数据表格预付
select prdate as 预定时间,hotel as 酒店名称,CityName as 城市,d.dep+d.team as '所属部门(组)',opername1 as 业务顾问,od.ConfirmPerson as 产品支持人,yf.nights*pcs as 间夜数,price as 金额 
from tbHtlcoupYf yf
inner join HotelOrderDB..HTL_Orders od on od.CoupNo=yf.CoupNo
inner join HotelOrderDB..HTL_OrderHotels oh on oh.OrderID=od.OrderID
inner join Emppwd d on d.empname=opername1
where prdate>='2018-01-01' and prdate<'2019-01-01'
and yf.status<>'-2'
order by prdate

--酒店数据表格自付
select datetime as 预定时间,hotel as 酒店名称,CityName as 城市,d.dep+d.team as '所属部门(组)',opername1 as 业务顾问,od.ConfirmPerson as 产品支持人,coup.nights*pcs as 间夜数,price as 金额 
from tbHotelcoup coup
inner join HotelOrderDB..HTL_Orders od on od.CoupNo=coup.CoupNo
inner join HotelOrderDB..HTL_OrderHotels oh on oh.OrderID=od.OrderID
inner join Emppwd d on d.empname=opername1
where datetime>='2018-01-01' and datetime<'2019-01-01'
and coup.status<>'-2'
order by datetime

--修改UC号（机票）

select custid,* from Topway..tbCusholder where custname ='方宁' and mobilephone='15951117137'

select custid,* from topway..tbcash 
--update topway..tbcash set custid='D192373'
where coupno in ('AS002210296')

--财务已阅改未阅
select haschecked,* from topway..FinanceERP_ClientBankRealIncomeDetail 
--update topway..FinanceERP_ClientBankRealIncomeDetail  set haschecked='0'
where money='22621' and id='C4B8F8A9-D725-41A5-B993-ABC365BF08F3'

--账单撤销
SELECT TrainBillStatus,* FROM topway..AccountStatement 
--update topway..AccountStatement  set TrainBillStatus='1'
WHERE (CompanyCode = '018398') and BillNumber='018398_20181201'

--锁定单位客户的旅游会务介绍人为homsom
select distinct CmpId,* from Topway..HM_ThePreservationOfHumanInformation where Cmpid in('000126','006299','013184','013991','014412','015869','015918','016132','016266','016289','016358',
'016448','016457','016465','016490','016511','016531','016532','016564','016575','016618','016636','016676','016684','016795','016873','016876','016886','016973','017064','017111','017131',
'017186','017191','017275','017327','017329','017364','017426','017485','017505','017508','017509','017509','017525','017565','017583','017602','017643','017684','017706','017764','017800',
'017818','017828','017831','017831','017865','017882','017886','017907','017914','017931','017954','017977','017996','018004','018013','018080','018096','018125','018156','018156','018176',
'018193','018231','018266','018283','018294','018304','018309','018320','018343','018364','018383','018431','018515','018596','018615','018627','018642','018644','018662','018667','018667',
'018673','018675','018690','018700','018700','018707','018711','018714','018724','018741','018773','018798','018801','018808','018814','018931','018967','018986','019014','019041','019109',
'019140','019152','019166','019180','019188','019189',
'019226',
'019256',
'019260',
'019299',
'019310',
'019334',
'019352',
'019371',
'019376',
'019378',
'019432',
'019453',
'019467',
'019467',
'019468',
'019471',
'019500',
'019504',
'019515',
'019517',
'019519',
'019523',
'019524',
'019526',
'019531',
'019535',
'019547',
'019547',
'019558',
'019568',
'019569',
'019589',
'019607',
'019615',
'019629',
'019637',
'019653',
'019653',
'019660',
'019660',
'019661',
'019661',
'019669',
'019678',
'019689',
'019705',
'019705',
'019707',
'019708',
'019717',
'019732',
'019735',
'019738',
'019748',
'019751',
'019751',
'019764',
'019793',
'019807',
'019811',
'019812',
'019820',
'019824',
'019830',
'019839',
'019845',
'019846',
'019882',
'019885',
'019888',
'019892',
'019895',
'019908',
'019908',
'019910',
'019912',
'019918',
'019922',
'019923',
'019924',
'019928',
'019932',
'019937',
'019939',
'019940',
'019942',
'019944',
'019946',
'019949',
'019956',
'019970',
'019971',
'019985',
'019993',
'019995',
'020005',
'020012',
'020015',
'020016',
'020017',
'020027',
'020029',
'020033',
'020043',
'020046',
'020056',
'020056',
'020066',
'020074',
'020082',
'020083',
'020087',
'020091',
'020096',
'020097',
'020109',
'020121',
'020122',
'020130',
'020139',
'020140',
'020142',
'020145',
'020149',
'020155',
'020161',
'020163',
'020183',
'020201',
'020202',
'020205',
'020208',
'020213',
'020215',
'020216',
'020218',
'020222',
'020223',
'020226',
'020230',
'020240',
'020240',
'020252',
'020255',
'020255',
'020258',
'020259',
'020263',
'020264',
'020265',
'020268',
'020277',
'020281',
'020299',
'020300',
'020301',
'020307',
'020311',
'020313',
'020318',
'020318',
'020321',
'020322',
'020323',
'020325',
'020328',
'020331',
'020332',
'020335',
'020336',
'020339',
'020341',
'020343',
'020344',
'020347',
'020351',
'020352',
'020357',
'020358',
'020364',
'020364',
'020367',
'020370',
'020372',
'020373',
'020374',
'020374',
'020375',
'020381',
'020382',
'020386',
'020389',
'020390',
'020391',
'020392',
'020393',
'020398',
'020399',
'020400',
'020402',
'020404',
'020406',
'020409',
'020411',
'020412',
'020415',
'020417',
'020420',
'020424',
'020425',
'020429',
'020429',
'020435',
'020437',
'020439',
'020440',
'020443',
'020449',
'020452',
'020454',
'020456',
'020458',
'020465',
'020466',
'020469',
'020471',
'020473',
'020474',
'020479',
'020480',
'020484',
'020485',
'020486',
'020487',
'020489',
'020489',
'020492',
'020493',
'020494',
'020499',
'020501',
'020503',
'020509',
'020512',
'020515',
'020516',
'020520',
'020526',
'020527',
'020530',
'020534',
'020537',
'020539',
'020540',
'020549',
'020552',
'020553',
'020554',
'020557',
'020561',
'020562',
'020563',
'020571',
'020573',
'020574',
'020576',
'020577',
'020581',
'020584',
'020586',
'020587',
'020590',
'020593',
'020594',
'020595',
'020596',
'020599',
'020600',
'020601',
'020604',
'020605',
'020606',
'020607',
'020611',
'020612',
'020613',
'020615',
'020616',
'020619',
'020623',
'020624',
'020625',
'020627',
'020628',
'020632',
'020633',
'020642',
'020647',
'020648',
'020652',
'020653',
'020654',
'020658',
'020660',
'020661',
'020662',
'020665',
'020666',
'020668',
'020676',
'020678',
'020681',
'020682',
'020683')  and IsDisplay='1'  and MaintainType='6' and MaintainName<>'HOMSOM'