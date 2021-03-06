IF OBJECT_ID('tempdb.dbo.#cmp') IS NOT NULL DROP TABLE #cmp
SELECT cmpcode,ride,SUM(totprice) AS totprice 
INTO #cmp 
FROM tbcash  WITH (NOLOCK) WHERE --ride IN('MF') AND 
datetime>='2018-01-01' AND datetime<'2019-04-01' AND inf=0 AND tickettype='电子票' AND cmpcode<>''
AND cmpcode IN(
'020730',
'019956',
'015828',
'020165',
'000126',
'016696',
'016179',
'019392',
'017865',
'019089',
'018021',
'017887',
'017120',
'019409',
'019423',
'019654',
'019717',
'019948',
'020020',
'020158',
'020154',
'020220',
'020287',
'020310',
'020350',
'020370',
'018362',
'020774',
'020359',
'020017',
'019822',
'020297',
'020521',
'020506',
'020530',
'020592',
'019637',
'016751',
'020036',
'020758',
'020719',
'019483',
'020731',
'017193',
'020176',

'017275',
'017491',
'001787',
'019839',
'017506',
'017153',
'017969',
'018897',
'020504',

'019294',
'017670',
'019539',
'020039',
'016712',
'016564',
'019663',
'020511',
'018294',
'018677',
'019362',
'017273',
'017376',
'019404',
'019619',
'018642',
'019944',
'019925',
'018615',
'019978',
'017339',
'016556',
'019256',
'020541',
'020441',
'020262',
'016883',
'020640',
'017674',
'017125',
'017525',
'016991',
'020778',
'018156',
'018793',
'019591',
'019242',
'018397',
'019112',
'019325',
'019641',
'016602',
'017423',
'020614',
'020693',
'020717',
'020718',
'020659',
'018661',

'016465',
'014412',
'015717',
'016465',
'016477',
'016572',
'016655',
'016689',
'016777',
'017173',
'017642',
'017739',
'017745',
'017850',
'017988',
'018064',
'018108',
'018257',
'018309',
'018314',
'018443',
'018449',
'018574',
'018821',
'018827',
'018939',
'019143',
'019197',
'019226',
'019245',
'019259',
'019270',
'019349',
'019473',
'019505',
'019513',
'019550',
'019556',
'019651',
'019764',
'019796',
'019798',
'019897',
'019935',
'019975',
'019976',
'019996',
'020051',
'020348',
'020510',
'020588',
'020589',
'020677',
'020708',
'020711'
)
GROUP BY cmpcode,ride

IF OBJECT_ID('tempdb.dbo.#per') IS NOT NULL DROP TABLE #per
SELECT cmpcode,ride,pasname,idno,COUNT(pasname) AS num 
INTO #per 
FROM tbcash WITH (NOLOCK) WHERE --ride IN('MF') AND 
datetime>='2018-01-01' AND datetime<'2019-04-01' AND inf=0 AND tickettype='电子票' AND cmpcode<>''
AND cmpcode IN(
'020730',
'019956',
'015828',
'020165',
'000126',
'016696',
'016179',
'019392',
'017865',
'019089',
'018021',
'017887',
'017120',
'019409',
'019423',
'019654',
'019717',
'019948',
'020020',
'020158',
'020154',
'020220',
'020287',
'020310',
'020350',
'020370',
'018362',
'020774',
'020359',
'020017',
'019822',
'020297',
'020521',
'020506',
'020530',
'020592',
'019637',
'016751',
'020036',
'020758',
'020719',
'019483',
'020731',
'017193',
'020176',

'017275',
'017491',
'001787',
'019839',
'017506',
'017153',
'017969',
'018897',
'020504',

'019294',
'017670',
'019539',
'020039',
'016712',
'016564',
'019663',
'020511',
'018294',
'018677',
'019362',
'017273',
'017376',
'019404',
'019619',
'018642',
'019944',
'019925',
'018615',
'019978',
'017339',
'016556',
'019256',
'020541',
'020441',
'020262',
'016883',
'020640',
'017674',
'017125',
'017525',
'016991',
'020778',
'018156',
'018793',
'019591',
'019242',
'018397',
'019112',
'019325',
'019641',
'016602',
'017423',
'020614',
'020693',
'020717',
'020718',
'020659',
'018661',

'016465',
'014412',
'015717',
'016465',
'016477',
'016572',
'016655',
'016689',
'016777',
'017173',
'017642',
'017739',
'017745',
'017850',
'017988',
'018064',
'018108',
'018257',
'018309',
'018314',
'018443',
'018449',
'018574',
'018821',
'018827',
'018939',
'019143',
'019197',
'019226',
'019245',
'019259',
'019270',
'019349',
'019473',
'019505',
'019513',
'019550',
'019556',
'019651',
'019764',
'019796',
'019798',
'019897',
'019935',
'019975',
'019976',
'019996',
'020051',
'020348',
'020510',
'020588',
'020589',
'020677',
'020708',
'020711'
)
GROUP BY cmpcode,ride,pasname,idno


IF OBJECT_ID('tempdb.dbo.#hebing') IS NOT NULL DROP TABLE #hebing
SELECT c.*,p.pasname,p.idno,p.num INTO #hebing FROM #per p
LEFT JOIN #cmp c ON p.cmpcode=c.cmpcode AND p.ride=c.ride 
WHERE  p.num>=2
ORDER BY c.totprice,p.num DESC



IF OBJECT_ID('tempdb.dbo.#hebing1') IS NOT NULL DROP TABLE #hebing1
SELECT c.*,p.pasname,p.idno,p.num INTO #hebing1 FROM #per p
LEFT JOIN #cmp c ON p.cmpcode=c.cmpcode AND p.ride=c.ride 

ORDER BY c.totprice,p.num DESC


--SELECT * FROM #hebing1 WHERE cmpcode='020778'

SELECT h.cmpcode,h.pasname,h.idno,SUM(h.num) FROM #hebing h 
GROUP BY h.cmpcode,h.pasname,h.idno  HAVING(SUM(h.num)>=2)

SELECT h.cmpcode,h.pasname,h.idno,SUM(h.num) FROM #hebing1 h 
--WHERE h.ride='mf' 
GROUP BY h.cmpcode,h.pasname,h.idno   HAVING(SUM(h.num)<2)

--一年内出过票的名单数
SELECT DISTINCT cmpcode,pasname,idno 
into #cprs 
FROM #hebing1

select distinct cmpcode,COUNT(idno) from #cprs
group by cmpcode

--任意航空出行过2次人数

SELECT h.cmpcode,h.pasname,h.idno,SUM(h.num) 次数
into #cgcs
FROM #hebing h 
GROUP BY h.cmpcode,h.pasname,h.idno  HAVING(SUM(h.num)>=2)

select cmpcode,COUNT(idno) from #cgcs
group by cmpcode

--乘过南航的人数

SELECT  cmpcode,COUNT(idno)

FROM #hebing1
where ride='cz'
group by cmpcode



--乘过一次南航的人数
SELECT cmpcode,COUNT(idno)
FROM #hebing1
where ride='cz' and num<2
group by cmpcode