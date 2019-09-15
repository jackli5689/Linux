SELECT PnrInfoID,* FROM homsomDB..Trv_DomesticTicketRecord WHERE RecordNumber=''
SELECT ItktBookingID,* FROM homsomDB..Trv_PnrInfos WHERE ID='Trv_DomesticTicketRecord.PnrInfoID'
SELECT TemplateID,* FROM   workflow..Homsom_WF_Instance WHERE BusinessID='ItktBookingID'
SELECT ProcessPerson,* FROM workflow..Homsom_WF_Template_Node WHERE TemplateID='TemplateID' AND NodeName='审批'
SELECT * FROM homsomDB..Trv_Human WHERE ID='ProcessPerson'


SELECT CoupNo,* FROM HotelOrderDB..HTL_Orders


--机票
select t1.RecordNumber,t5.Name from homsomDB..Trv_DomesticTicketRecord t1
left join homsomDB..Trv_PnrInfos t2 on t2.ID=t1.PnrInfoID
left join workflow..Homsom_WF_Instance t3 on t3.BusinessID=t2.ItktBookingID
left join workflow..Homsom_WF_Template_Node t4 on t4.TemplateID=t3.TemplateID and NodeName='审批'
left join homsomDB..Trv_Human t5 on t5.ID=t4.ProcessPerson
where t1.RecordNumber in 
('AS001941975','AS001941978','AS001942688','AS001942691','AS001943265','AS001943268','AS001943306','AS001943308','AS001943309','AS001944081','AS001944084','AS001944663','AS001944666','AS001944684','AS001944687','AS001945004','AS001945007','AS001946867','AS001946870','AS001946881','AS001946884','AS001948641','AS001948641','AS001948644','AS001948644','AS001949818','AS001949821','AS001950481','AS001950484','AS001951596','AS001951599','AS001951600','AS001951603','AS001951611','AS001951614','AS001952446','AS001952487','AS001953065','AS001953068','AS001953401','AS001953403','AS001953404','AS001954886','AS001954889','AS001955066','AS001955069','AS001958046','AS001958049','AS001958077','AS001958080','AS001958166','AS001958169','AS001958814','AS001958814','AS001958819','AS001958819','AS001958854','AS001958857','AS001958879','AS001958882','AS001959012','AS001959015','AS001962426','AS001962428','AS001962429','AS001964998','AS001965001','AS001968862','AS001968865','AS001968874','AS001968877','AS001969474','AS001969477','AS001969744','AS001969747','AS001970466','AS001970469','AS001971200','AS001971203','AS001972308','AS001972311','AS001978142','AS001978145','AS001978378','AS001978381','AS001978926','AS001978929','AS001980084','AS001980087','AS001980810','AS001980813','AS001982882','AS001982885','AS001986949','AS001986952','AS001987453','AS001987456','AS001987687','AS001987690','AS001988456','AS001988458','AS001988459','AS001990343','AS001990343','AS001990346','AS001990346','AS001991979','AS001991982','AS001992155','AS001992158','AS001993929','AS001994637','AS001994637','AS001994640','AS001994640','AS001995385','AS001995386','AS001995818','AS001995821','AS001996584','AS001996586','AS001996587','AS001997281','AS001997281','AS001997284','AS001997284','AS001997467','AS001997470','AS001997471','AS001997474','AS001997529','AS001997532','AS001997733','AS001997736','AS001998132','AS001998135','AS001998148','AS001998151','AS001999886','AS001999889','AS002001322','AS002001325','AS002002087','AS002002090','AS002003257','AS002003259','AS002003260','AS002006988','AS002006991','AS002008426','AS002008429','AS002008861','AS002008865','AS002010049','AS002010052','AS002010462','AS002010465','AS002010596','AS002010599','AS002011662','AS002011665','AS002011857','AS002011860','AS002011861','AS002011864','AS002012020','AS002012023','AS002013509','AS002013512')
and NodeType=110 and NodeID=110

--一级 NodeType=110 and NodeID=110
--二级 NodeType=110 and NodeID=111

--酒店
select t1.CoupNo,t5.Name from HotelOrderDB..HTL_Orders t1
left join workflow..Homsom_WF_Instance t3 on t3.BusinessID=t1.OrderID
left join workflow..Homsom_WF_Template_Node t4 on t4.TemplateID=t3.TemplateID and NodeName='审批'
left join homsomDB..Trv_Human t5 on t5.ID=t4.ProcessPerson
where t1.CoupNo in 
('PTW068553','PTW068522','PTW068564','-PTW068564','PTW068567','PTW068568','PTW068569','-PTW068568','-PTW068569','PTW068571','PTW068572','PTW068576','PTW068647','PTW068631','PTW068606','PTW068591','PTW068694','PTW068693','PTW068692','PTW068687','PTW068782','PTW068781','PTW068720','PTW068736','PTW068742','PTW068746','PTW068748','PTW068749','PTW068756','PTW068757','PTW068864','PTW068863','PTW068852','PTW068851','PTW068817','PTW068813','PTW068805','PTW068803','PTW068953','PTW068936','PTW068931','PTW069006','PTW068989','PTW069145','PTW069132','PTW069188','PTW069171','PTW069219','PTW069206','PTW069197','PTW069225','PTW069278','PTW069277','PTW069276','PTW069268','PTW069267','PTW069329','PTW069379','PTW069372','PTW069408','PTW069490','PTW069480','PTW069479','PTW069469','PTW069546','PTW069565','PTW069650','PTW069841')
and NodeType=110 and NodeID=111



