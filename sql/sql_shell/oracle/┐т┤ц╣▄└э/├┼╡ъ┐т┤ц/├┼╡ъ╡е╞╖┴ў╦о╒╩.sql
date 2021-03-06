<VERSION>4.1.1</VERSION>
<SQLQUERY>
<REMARK>
[标题]
门店单品流水帐
[应用背景]

[结果列描述]
数量（+）：增加库存数
数量（-）：减少库存数
数量平衡：对应业务发生后库存数量
[必要的查询条件]
期号：必选
商品代码：必选
门店代码：必选

[实现方法]
1.期初的数量：输入期号的上一期数量。果期号为当前期，期初数量为上一期数量，期末可能不
是当前库
存。
2.销售数量：取值日报表，数量不精确到时分秒。不能完全作为快照数量的对比依据。
[临时表结构]
-- Create table
create global temporary table h4RTMP_STOREGDFLOW
(
  STORENO  VARCHAR2(10),
  GDCODE   VARCHAR2(13),
  SETTLENO NUMBER(38) default 0,
  NUM      VARCHAR2(14),
  FILDATE  DATE,
  CLS      VARCHAR2(20),
  INQTY    NUMBER(24,2) default 0,
  OUTQTY   NUMBER(24,2) default 0,
  BALQTY   NUMBER(24,2) default 0,
  TOTAL    NUMBER(24,2) default 0,
  GDNAME   VARCHAR2(100)
)
on commit preserve rows;
-- Grant/Revoke object privileges 
exec hdcreatesynonym('H4RTMP_STOREGDFLOW');
exec granttoqryrole('H4RTMP_STOREGDFLOW');
[版本记录]： 
20100613/YAOMING 
选择表，goodsh换成goods,goodsh.code不是主键，可能查出历史商品的信息。
20100816/YAOMING
注释盘入单的时间限制/*and ckdate >= FromDate*/
20101003/LINING  修改报表展示格式
20101015/LINING  调拨单同一单品数量进行合并，虎彩定制
20130129/fengxing 增加“领用”“领用返回”“领用出”“领用退”“成本转移入”“成本
转移出”科目，均取自日报
[其它]
</REMARK>
<BEFORERUN>
declare FromDate     Date;
        FromDirDate  date;
        aSettleno    NUMERIC(38) default 0;
        astore       int;
        Gd_Gid       int;
        t_InQty      NUMERIC(24,2) default 0;
        t_OutQty     NUMERIC(24,2) default 0;
        t_Date       Date;
        t_Cls        varchar2(20);
        t_BalQty     NUMERIC(24,2) default 0;
        vpreNo       int;
        vGCode     varchar2(13);
        vSCode     varchar2(8);
        cursor  c1 is
           select FilDate, Cls, InQty, OutQty from h4RTMP_STOREGDFLOW where cls <> '期初' order by FilDate , INQTY ,cls desc for update;
begin
        asettleno := \(1,1);
        vGCode := '\(2,1)';
        vSCode := '\(3,1)';
        delete from h4RTMP_STOREGDFLOW;commit;
        select max(no) into vpreno from monthsettle where no < asettleno;
        begin
          select Startdate into FromDate from monthsettledtl where no = asettleno and cls = '零售';
        exception
           when no_data_found then
              fromdate:=to_date('2009.09.01','yyyy.mm.dd');
        end;
        --select GID into Gd_Gid from Goods where Code = vGCode;
        select GID into Gd_Gid from gdinput where Code = vGCode;
        select gid into astore from Store where code = vSCode;

        insert into h4RTMP_STOREGDFLOW( StoreNo, Settleno, FilDate, Cls, GdCode, BalQty,total)
               select  vSCode, asettleno, FromDate, '期初', vGCode, qty, amt+tax 
                 from sinvmrpts where settleno = vpreno and store = astore and gdgid = gd_gid;
       
        insert into h4RTMP_STOREGDFLOW( StoreNO, Settleno, FilDate, Cls, Num, GdCode, inQty, total)
        (select vSCode, asettleno, l.time, '配货出货单', a.Num, vGCode, 
        sum(b.Qty),sum(b.total)
        from StkoutDtl b, stkoutlog l, StkOut a
        where a.Cls = b.Cls and a.Num = b.Num
        and a.cls = l.cls and a.num = l.num
        and l.Stat IN (700,320,340,720,740)
        and b.gdgid = Gd_Gid
        and a.billto = aStore
        and l.cls = '统配出'
        and l.time > fromdate
        group by l.time, a.CLS, a.NUM);

        insert into h4RTMP_STOREGDFLOW( StoreNO, Settleno, FilDate, Cls, Num, GdCode, inQty, total)
        (select vSCode, asettleno, c.time, '配货差异单', a.Num, vGCode, 
        sum(b.Qty),sum(b.total)
        from AlcDiffDtl b, AlcDiff a,alcdifflog c
        where a.Cls = b.Cls and a.Num = b.Num
        and a.num = c.num
        and a.cls=c.cls
        and c.Stat in(400,420,440)
        and b.gdgid = Gd_Gid
        and a.billto = aStore
        and a.cls = '配货差异'
        and c.time > fromdate
        group by c.time, a.NUM);

        insert into h4RTMP_STOREGDFLOW( StoreNO, Settleno, Fildate, Cls, Num, GdCode, OutQty,total)
        (select vSCode, asettleno, l.time, '配货出货退货单', 
        a.Num, vGCode, sum(b.Qty),sum(b.total)
        from StkoutBckDtl b, stkoutbcklog l, StkOutBck a
        where a.Cls = b.Cls and a.Num = b.Num 
        and a.cls = l.cls and a.num = l.num
        and l.Stat IN (1000,1020,1040,320,340)
        and b.gdgid = Gd_Gid
        and l.time > fromdate
        and a.billto = aStore
        and l.cls = '统配出退'
        group by l.time, a.CLS, a.NUM);
               
        --add by fq 2014.01.08  门店单品流水账增加天喔一家门店批发业务
        insert into h4RTMP_STOREGDFLOW( StoreNO, Settleno, FilDate, Cls, Num, GdCode, inQty, total)
        (select vSCode, asettleno, l.time, '批发单', a.Num, vGCode, 
        -sum(b.Qty),-sum(b.total)
        from StkoutDtl b, stkoutlog l, StkOut a
        where a.Cls = b.Cls and a.Num = b.Num
        and a.cls = l.cls and a.num = l.num
        and l.Stat IN (700,320,340,720,740)
        and b.gdgid = Gd_Gid
        and a.sender = aStore
        and l.cls = '批发'
        and l.time > fromdate
        group by l.time, a.CLS, a.NUM);
        
        /*insert into h4RTMP_STOREGDFLOW( StoreNO, Settleno, FilDate, Cls, Num, GdCode, inQty, total)
        (select vSCode, asettleno, c.time, '批发差异单', a.Num, vGCode, 
        sum(b.Qty),sum(b.total)
        from AlcDiffDtl b, AlcDiff a,alcdifflog c
        where a.Cls = b.Cls and a.Num = b.Num
        and a.num = c.num
        and a.cls=c.cls
        and c.Stat in(400,420,440)
        and b.gdgid = Gd_Gid
        and a.sender = aStore
        and a.cls = '批发差异'
        and c.time > fromdate
        group by c.time, a.NUM);*/
        
        insert into h4RTMP_STOREGDFLOW( StoreNO, Settleno, Fildate, Cls, Num, GdCode, OutQty,total)
        (select vSCode, asettleno, l.time, '批发退货单', 
        a.Num, vGCode, sum(b.Qty),sum(b.total)
        from StkoutBckDtl b, stkoutbcklog l, StkOutBck a
        where a.Cls = b.Cls and a.Num = b.Num 
        and a.cls = l.cls and a.num = l.num
        and l.Stat IN (1000,1020,1040,320,340)
        and b.gdgid = Gd_Gid
        and l.time > fromdate
        and a.receiver = aStore
        and l.cls = '批发退'
        group by l.time, a.CLS, a.NUM);
        
        insert into h4RTMP_STOREGDFLOW( storeNo, settleNo, FilDate, Cls, Num, GdCode, InQty,total)
        (select vSCode, asettleno , c.time, 
        '直配出货单',a.Num, vGCode, sum(b.Qty),sum(b.AlcAmt)
        from DirAlcDtl b, Diralc a,diralclog c
        where a.Cls = b.Cls and a.Num = b.Num
        and a.num = c.num and a.cls = c.cls
        and c.stat in(1000, 1020, 1040, 320 ,340)
        and b.gdgid = Gd_Gid
        and c.time > fromdate
        and a.receiver = astore
        and a.Cls = '直配出'
        group by c.time, a.CLS, a.NUM);

        insert into h4RTMP_STOREGDFLOW( storeNo, settleNo, FilDate, Cls, Num, GdCode, OutQty,total)
        (select vSCode, asettleno , c.time, 
        '直配出货退货单',a.Num, vGCode, sum(b.Qty),sum(b.AlcAmt)
        from DirAlcDtl b, Diralc a,diralclog c
        where a.Cls = b.Cls and a.Num = b.Num
        and a.num = c.num and a.cls=c.cls
        and c.Stat in(700,720,740,320,340)
        and b.gdgid = Gd_Gid
        and c.time > fromdate
        and a.receiver = astore
        and a.Cls = '直配出退'
        group by c.time, a.CLS, a.NUM);

        insert into h4RTMP_STOREGDFLOW( storeNo, Settleno, FilDate, Cls, Num, GdCode, InQty, OutQty,total)
        (select vSCode, asettleno, ckdata.cktime, '盘入单', ckdata.Num, vGCode,
         decode(sign(ckdata.QTY - ckdata.ACNTQTY),1, ckdata.Qty - ckdata.ACNTQTY, 0),
         decode(sign(ckdata.QTY - ckdata.ACNTQTY),-1, ckdata.ACNTQTY - ckdata.Qty , 0),
         (ckdata.camtbal+ckdata.ctaxbal)
         from CKdatas ckdata
         where exists (select 1 from ckdir where ckseq = ckdata.ckseq /*and ckdate >= FromDate*/ and storerange like '%'||vSCode||'%')
           and ckdata.Store = astore
           and ckdata.gdgid = Gd_Gid
           and ckdata.qty <> ckdata.acntqty
           and ckdata.stat = 3
           and ckdata.cktime > FromDate
           and ckdata.cktime is not null);

        insert into h4RTMP_STOREGDFLOW(Storeno, Settleno, fildate, cls, num, gdCode, inQty, OutQty, total)
        (select vSCode, aSettleno, l.time, '调入', a.num, vGCode, sum(b.qty), 0, sum(b.total)
         from invxfdtl b, invxflog l, invxf a
        where a.num = b.num
          and a.num = l.num
          and a.cls = b.cls
          and a.cls = l.cls
          and a.cls = '门店调拨'
          and l.time > fromdate
          and l.stat in (300,320,340)
          and a.toStore = aStore
          and b.gdgid = gd_gid
          group by  vSCode, aSettleno, l.time, '调入', a.num, vGCode);
          

        insert into h4RTMP_STOREGDFLOW(Storeno, Settleno, fildate, cls, num, gdCode, inQty, OutQty, total)
        (select vSCode, aSettleno, l.time, '调出', a.num, vGCode, 0, sum(b.qty), sum(b.total)
         from invxfdtl b, invxflog l, invxf a
        where a.num = b.num
          and a.num = l.num
          and a.cls = b.cls
          and a.cls = l.cls
          and a.cls = '门店调拨'
          and l.time > fromdate
          and l.stat in (300, 320,340)
          and a.fromStore = aStore
          and b.gdgid = gd_gid
          group by vSCode, aSettleno, l.time, '调出', a.num, vGCode);
          

        insert into h4RTMP_STOREGDFLOW(Storeno, Settleno, fildate, cls, num, gdCode, inQty, OutQty, total)
        (select vSCode, aSettleno, l.time, '溢余', a.num, vGCode, b.qty, 0, b.rtotal
         from invMODdtl b, invMODlog l, invMOD a
        where a.num = b.num
          and a.num = l.num
          and a.cls = b.cls
          and a.cls = l.cls
          and a.cls = '门店调整'
          and l.time > fromdate
          and l.stat in (300,320,340)
          and a.Store = aStore
          and b.gdgid = gd_gid
          AND B.QTY > 0);

        insert into h4RTMP_STOREGDFLOW(Storeno, Settleno, fildate, cls, num, gdCode, inQty, OutQty, total)
        (select vSCode, aSettleno, l.time, '损耗', a.num, vGCode, 0, -b.qty, -b.rtotal
         from invMODdtl b, invMODlog l, invMOD a
        where a.num = b.num
          and a.num = l.num
          and a.cls = b.cls
          and a.cls = l.cls
          and a.cls = '门店调整'
          and l.time > fromdate
          and l.stat in (300,320,340)
          and a.Store = aStore
          and b.gdgid = gd_gid
          AND B.QTY < 0);
      
          

        --if hdsysinfo.getsidbysgid(astore) = 0 then
        insert into h4RTMP_STOREGDFLOW(Storeno, Settleno, fildate, cls, num, gdCode, inQty, OutQty, total)
        (select vSCode, aSettleno, least(to_date(to_char(trunc(fildate),'yyyy.mm.dd')||'23:59:59','yyyy.mm.dd HH24:MI:SS'),sysdate-1/3600/24), cls, '1', vGCode, sum(decode(cls, '零售', 0, '零售退',qty)), sum(decode(cls, '零售', qty, '零售退',0)), sum(amt + tax)
         from sdrpts
        where gdgid = gd_gid
          and snd = astore
          and cls in ('零售','零售退')
          and fildate >= FromDate
          --and fildate < sysdate
          group by vSCode, aSettleno, fildate, cls, '1', vGCode);
          

	delete from h4RTMP_STOREGDFLOW where cls in ('零售','零售退') and inqty=0 and outqty=0 and total=0;




        insert into h4RTMP_STOREGDFLOW(Storeno, Settleno, fildate, cls, num, gdCode, inQty, OutQty, total)
        (select vSCode, aSettleno, least(to_date(to_char(trunc(fildate),'yyyy.mm.dd')||'23:59:59','yyyy.mm.dd HH24:MI:SS'),sysdate-1/3600/24), cls, '1', vGCode, sum(decode(cls, '领用出', 0, '领用出退',qty)), sum(decode(cls, '领用出', qty, '领用出退',0)), sum(amt + tax)
         from sdrpts
        where gdgid = gd_gid
          and snd = astore
          and cls in ('领用退','领用出')
          and fildate >= FromDate
          --and fildate < sysdate
          group by vSCode, aSettleno, fildate, cls, '1', vGCode);
          

	delete from h4RTMP_STOREGDFLOW where cls in ('领用退','领用出') and inqty=0 and outqty=0 and total=0;


        insert into h4RTMP_STOREGDFLOW(Storeno, Settleno, fildate, cls, num, gdCode, inQty, OutQty, total)
        (select vSCode, aSettleno, least(to_date(to_char(trunc(fildate),'yyyy.mm.dd')||'23:59:59','yyyy.mm.dd HH24:MI:SS'),sysdate-1/3600/24), cls, '1', vGCode, sum(decode(cls, '领用', 0, '领用退',qty)), sum(decode(cls, '领用', qty, '领用退',0)), sum(amt + tax)
         from sdrpts
        where gdgid = gd_gid
          and snd = astore
          and cls in ('领用返回','领用')
          and fildate >= FromDate
          --and fildate < sysdate
          group by vSCode, aSettleno, fildate, cls, '1', vGCode);
          

	delete from h4RTMP_STOREGDFLOW where cls in ('领用返回','领用') and inqty=0 and outqty=0 and total=0;
          
       insert into h4RTMP_STOREGDFLOW(Storeno, Settleno, fildate, cls, num, gdCode, inQty, OutQty, total)
        (select vSCode, aSettleno, least(to_date(to_char(trunc(fildate),'yyyy.mm.dd')||'23:59:59','yyyy.mm.dd HH24:MI:SS'),sysdate-1/3600/24), cls, '1', vGCode, sum(decode(cls, '成本转移出', 0, '成本转移入',qty)), sum(decode(cls, '成本转移出', qty, '成本转移入',0)), sum(amt + tax)
         from sdrpts
        where gdgid = gd_gid
          and snd = astore
          and cls in ('成本转移入','成本转移出')
          and fildate >= FromDate
          --and fildate < sysdate
          group by vSCode, aSettleno, fildate, cls, '1', vGCode);
          

         delete from h4RTMP_STOREGDFLOW where cls in ('成本转移入','成本转移出') and inqty=0 and outqty=0 and total=0;  
               
        --end if;

        begin
             select BalQty into t_BalQty from h4RTMP_STOREGDFLOW where Cls = '期初';
        exception
             WHEN OTHERS THEN
             t_BalQty := 0;
       	     insert into h4RTMP_STOREGDFLOW ( StoreNo, Settleno, FilDate, Cls, GdCode, BalQty,total)
               select  vSCode, asettleno, FromDate, '期初', vGCode , 0, 0 from Dual;
        end;
        for c_q1 in c1 loop  
         
            begin
                  t_BalQty := t_BalQty + c_q1.InQty - c_q1.OutQty;
                  update h4RTMP_STOREGDFLOW set h4RTMP_STOREGDFLOW.BalQty =  t_BalQty
                         where current of c1;
            end;
            
            
        End loop;

       	     insert into h4RTMP_STOREGDFLOW ( StoreNo, Settleno, FilDate, Cls, GdCode, BalQty,total)
               select  vSCode, asettleno, sysdate, '期末', vGCode, t_BalQty, 0 from Dual;

        commit;
end;


/*select * from h4RTMP_STOREGDFLOW*/
</BEFORERUN>
<AFTERRUN>
</AFTERRUN>
<TABLELIST>
  <TABLEITEM>
    <TABLE>h4RTMP_STOREGDFLOW</TABLE>
    <ALIAS>h4RTMP_STOREGDFLOW</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>GOODS</TABLE>
    <ALIAS>GOODS</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>STORE</TABLE>
    <ALIAS>STORE</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>GDINPUT</TABLE>
    <ALIAS>GDINPUT</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
</TABLELIST>
<JOINLIST>
  <JOINITEM>
    <LEFT>STORE.CODE</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>h4RTMP_STOREGDFLOW.storeno</RIGHT>
  </JOINITEM>
  <JOINITEM>
    <LEFT>GOODS.GID</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>GDINPUT.GID</RIGHT>
  </JOINITEM>
  <JOINITEM>
    <LEFT>GDINPUT.CODE</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>h4RTMP_STOREGDFLOW.GDCODE</RIGHT>
  </JOINITEM>
</JOINLIST>
<COLUMNLIST>
  <FIXEDCOLUMNS>0</FIXEDCOLUMNS>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.Settleno</COLUMN>
    <TITLE>期号</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>H</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>0.###</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.gdcode</COLUMN>
    <TITLE>输入码</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>I</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>GOODS.CODE</COLUMN>
    <TITLE>商品代码</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>CODE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>GOODS.NAME</COLUMN>
    <TITLE>商品名称</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NAME</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.Storeno</COLUMN>
    <TITLE>门店代码</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>J</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>STORE.NAME</COLUMN>
    <TITLE>门店名称</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NAME1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.FilDate</COLUMN>
    <TITLE>填单日期</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>A</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.Cls</COLUMN>
    <TITLE>操作类型</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>B</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.Num</COLUMN>
    <TITLE>单据号</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>C</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.InQty</COLUMN>
    <TITLE>数量（+）</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>D</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.OutQty</COLUMN>
    <TITLE>数量（-）</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>E</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.BalQty</COLUMN>
    <TITLE>数量平衡</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>F</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4RTMP_STOREGDFLOW.Total</COLUMN>
    <TITLE>发生额</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>G</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
</COLUMNLIST>
<COLUMNWIDTH>
  <COLUMNWIDTHITEM>44</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>56</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>158</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>56</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>107</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>148</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>103</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>93</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>72</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>80</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>91</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>118</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>64</COLUMNWIDTHITEM>
</COLUMNWIDTH>
<GROUPLIST>
</GROUPLIST>
<ORDERLIST>
  <ORDERITEM>
    <COLUMN>填单日期</COLUMN>
    <ORDER>ASC</ORDER>
  </ORDERITEM>
</ORDERLIST>
<CRITERIALIST>
  <WIDTHLIST>
  </WIDTHLIST>
  <CRITERIAITEM>
    <LEFT>h4RTMP_STOREGDFLOW.Settleno</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>201412</RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
    </RIGHT>
    <ISHAVING>FALSE</ISHAVING>
    <ISQUOTED>0</ISQUOTED>
    <PICKNAME>
    </PICKNAME>
    <PICKVALUE>
    </PICKVALUE>
    <DEFAULTVALUE>本期</DEFAULTVALUE>
    <ISREQUIRED>TRUE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>h4RTMP_STOREGDFLOW.gdcode</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
    </RIGHT>
    <ISHAVING>FALSE</ISHAVING>
    <ISQUOTED>0</ISQUOTED>
    <PICKNAME>
    </PICKNAME>
    <PICKVALUE>
    </PICKVALUE>
    <DEFAULTVALUE></DEFAULTVALUE>
    <ISREQUIRED>FALSE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>h4RTMP_STOREGDFLOW.Storeno</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>10001</RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
    </RIGHT>
    <ISHAVING>FALSE</ISHAVING>
    <ISQUOTED>0</ISQUOTED>
    <PICKNAME>
    </PICKNAME>
    <PICKVALUE>
    </PICKVALUE>
    <DEFAULTVALUE></DEFAULTVALUE>
    <ISREQUIRED>TRUE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
</CRITERIALIST>
<CRITERIAWIDTH>
  <CRITERIAWIDTHITEM>101</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>90</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>149</CRITERIAWIDTHITEM>
</CRITERIAWIDTH>
<SG>
  <LINE>
  </LINE>
  <LINE>
    <SGLINEITEM>条件 1：</SGLINEITEM>
    <SGLINEITEM>201412</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM>10001</SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 2：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 3：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 4：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
  </LINE>
</SG>
<CHECKLIST>
  <CAPTION>
  </CAPTION>
  <EXPRESSION>
  </EXPRESSION>
  <CHECKED>
  </CHECKED>
  <ANDOR> and </ANDOR>
</CHECKLIST>
<UNIONLIST>
</UNIONLIST>
<NCRITERIAS>
  <NUMOFNEXTQRY>0</NUMOFNEXTQRY>
</NCRITERIAS>
<MULTIQUERIES>
  <NUMOFMULTIQRY>0</NUMOFMULTIQRY>
</MULTIQUERIES>
<FUNCTIONLIST>
</FUNCTIONLIST>
<DXDBGRIDITEM>
  <DXLOADMETHOD>FALSE</DXLOADMETHOD>
  <DXSHOWGROUP>FALSE</DXSHOWGROUP>
  <DXSHOWFOOTER>TRUE</DXSHOWFOOTER>
  <DXSHOWSUMMARY>FALSE</DXSHOWSUMMARY>
  <DXSHOWPREVIEW>FALSE</DXSHOWPREVIEW>
  <DXSHOWFILTER>FALSE</DXSHOWFILTER>
  <DXPREVIEWFIELD></DXPREVIEWFIELD>
  <DXCOLORODDROW>15921906</DXCOLORODDROW>
  <DXCOLOREVENROW>16777215</DXCOLOREVENROW>
  <DXFILTERNAME></DXFILTERNAME>
  <DXFILTERTYPE></DXFILTERTYPE>
  <DXFILTERLIST>
  </DXFILTERLIST>
  <DXSHOWGRIDLINE>1</DXSHOWGRIDLINE>
</DXDBGRIDITEM>
</SQLQUERY>
<SQLREPORT>
<RPTTITLE>门店单品流水帐</RPTTITLE>
<RPTGROUPCOUNT>0</RPTGROUPCOUNT>
<RPTGROUPLIST>
</RPTGROUPLIST>
<RPTCOLUMNCOUNT>12</RPTCOLUMNCOUNT>
<RPTCOLUMNWIDTHLIST>
  <RPTCOLUMNWIDTHITEM>44</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>56</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>158</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>56</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>107</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>148</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>103</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>93</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>72</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>80</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>75</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>64</RPTCOLUMNWIDTHITEM>
</RPTCOLUMNWIDTHLIST>
<RPTLEFTMARGIN>40</RPTLEFTMARGIN>
<RPTORIENTATION>0</RPTORIENTATION>
<RPTCOLUMNS>1</RPTCOLUMNS>
<RPTHEADERLEVEL>0</RPTHEADERLEVEL>
<RPTPRINTCRITERIA>TRUE</RPTPRINTCRITERIA>
<RPTVERSION></RPTVERSION>
<RPTNOTE></RPTNOTE>
<RPTFONTSIZE>9</RPTFONTSIZE>
<RPTLINEHEIGHT>宋体</RPTLINEHEIGHT>
<RPTPAGEHEIGHT>66</RPTPAGEHEIGHT>
<RPTPAGEWIDTH>80</RPTPAGEWIDTH>
<RPTTITLETYPE>0</RPTTITLETYPE>
<RPTCURREPORT></RPTCURREPORT>
<RPTREPORTLIST>
</RPTREPORTLIST>
</SQLREPORT>

