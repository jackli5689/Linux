select * from homsomDB..Trv_Human where CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 AND Name IN ('王军','李晨熹','陆元炯')

update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='赵伟')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='陈冲')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='徐健')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='李源安')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='周刚')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='张大林')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='王琳')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='吕炜洪')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='王天宁')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='樊秋燕')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='郑良')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='郑君')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海分公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='石泓泽')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='钱俊杰')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='李朝阳')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='张晓云')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='张庆鲁')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='陆元炯')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='孙颖')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='李晨熹')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='石少君')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='刘晓燕')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='包博')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='刘久毅')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='杨希')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='张娅')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='戚骜')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='刘怡')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='姚建东')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='周如伟')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='储鑫')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='袁毅超')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='李利君')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='黄小强')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='张丽娜')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='安小霞')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='曹瑜')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='归捷')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='陆华')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='寿岳峰')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='袁惠君')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='俞璟珺')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='胡乐骏')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='李文玲')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='张婷')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='陈扬')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='陆慧')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='王静')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='游博')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='吴展丞')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='柳晓菲')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='杨周')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='梁京凯')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='徐盛裔')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='王颖')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='陈涛')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='张蓓')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='单永梅')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='韩娟')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='王雪')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='郑韵')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='宋斌')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='张若曦')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='徐斌')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='费凤仙')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='孙丽')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='陈文静')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='陈岗')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='沈永彩')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='杨阳')
--成本中心
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='宋晓明')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='上海子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='刘凯')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='刘莉莉')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='裴雪平')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='周德静')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='许涛')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='黄海涛')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='何鹏')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='韩强')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='邹磊')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='龙俊成')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='冯睿')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='任伟')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='程鑫')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='徐长安')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='杨玉峰')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='王方浪')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='宋素敏')
update homsomDB..Trv_UnitPersons set CostCenterID=(Select ID from homsomDB..Trv_CostCenter  where Name='成都子公司' and CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1') where ID in(Select up.ID from homsomDB..Trv_UnitPersons up inner join homsomDB..Trv_Human hu on hu.ID=up.ID where up.CompanyID='0AB3E1BC-2B6A-4CF7-BC81-853CC2C701E1' and IsDisplay=1 and hu.Name='杨昌勇')
