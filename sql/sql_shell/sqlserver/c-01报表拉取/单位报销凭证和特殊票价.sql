--单位报销凭证和特殊票价
select distinct u.Cmpid,
(case when u.CertificateI=0 then '无' when u.CertificateI=1 then '行程单' when u.CertificateI=2 then '发票' else '' End) as 国际报销凭证,
(case when u.CertificateD=0 then '无' when u.CertificateD=1 then '行程单' when u.CertificateD=2 then '发票' else '' End) as 国内报销凭证,
(case when u.IsSepPrice=0 then '不可申请' when u.IsSepPrice=1 then '可以申请' else '' end) 是否有开通特殊票价
from Topway..tbcash  c
left join homsomDB..Trv_UnitCompanies u on u.Cmpid=c.cmpcode
where u.Cmpid in('016132',
'016886',
'017056',
'017649',
'017682',
'018156',
'018161',
'018232',
'018281',
'018308',
'018343',
'018369',
'018395',
'018420',
'018428',
'018448',
'018451',
'018522',
'018626',
'018781',
'018793',
'018892',
'018940',
'019049',
'019058',
'019106',
'019231',
'019273',
'019331',
'019332',
'019360',
'019486',
'019506',
'019591',
'019592',
'019792',
'020065',
'020094')