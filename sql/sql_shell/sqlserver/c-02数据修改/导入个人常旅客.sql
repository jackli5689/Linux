select custid,custname,* from tbCusholder where mobilephone='13000000000'

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




--删除
delete
--select * 
from [tbCusmem] where custid='D902892' and opername='杨军' and left(operdate,10)>GETDATE()-1





select * from [Topway].[dbo].[tbCusmem] where name='曾焕沙'