--酒店REASON CODE，预订人，差旅目的

select  h.CoupNo as 销售单号,Purpose as 差旅目的,t.pasname,ReasonDescription   FROM [HotelOrderDB].[dbo].[HTL_Orders] h
left join Topway..tbHtlcoupYf t on t.CoupNo=h.CoupNo
where h.CoupNo in ('-PTW072220',
'PTW077175',
'PTW077169',
'PTW077411',
'PTW077459',
'PTW077455',
'PTW077536',
'PTW077603',
'PTW077630',
'PTW077629',
'PTW077656',
'PTW077716',
'PTW077816',
'PTW077931',
'PTW077939',
'PTW077926',
'PTW077944',
'PTW077961',
'PTW078235',
'PTW078224',
'PTW078223',
'PTW078268',
'PTW078352',
'PTW078356',
'PTW078407',
'PTW078418',
'PTW078417',
'PTW078449',
'PTW078447',
'PTW078485',
'PTW078511',
'PTW078510',
'PTW078493',
'PTW078566',
'PTW078565',
'PTW078674',
'PTW078657',
'PTW078656',
'PTW078685',
'PTW078710',
'PTW078759',
'PTW078758',
'PTW078765',
'PTW078760',
'PTW078886')