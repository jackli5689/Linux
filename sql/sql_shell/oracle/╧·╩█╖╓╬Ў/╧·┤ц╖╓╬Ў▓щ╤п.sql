<VERSION>4.1.1</VERSION>
<SQLQUERY>
<REMARK>
[标题]

[应用背景]

[结果列描述]

[必要的查询条件]

[实现方法]

[其它]
</REMARK>
<BEFORERUN>
DECLARE
  GDGIDa     integer;
  STOREa     integer;
  FILLDATEa  date;
  OUTDATEa   date;
  INDATEa    date;
  SALEDATEa  date;
  cls        varchar2(40);
  begindate  date;
  vstorecode varchar2(200);
  adate      date;
  bdate      date;

  days      integer; ---补货天数
  goodscode varchar2(10);
  goodsName varchar2(20);
  /*统计时间段的商品的首配首销时间*/
  CURSOR CR1 IS
    select nvl(AA.GDGID, BB.GID) GDGID,
           nvl(AA.CLIENT, BB.STORE) STORE,
           AA.filtime,
           AA.outTime,
           AA.inTime,
           BB.saldate
      from (select STKOUTDTL.GDGID,
                   STKOUT.CLIENT,
                   min(STKOUTLOG.TIME) filtime,
                   min(STKOUTLOG2.TIME) outTime,
                   min(STKOUTLOG3.TIME) inTime
              from STKOUT
              left join STKOUTDTL
                on STKOUT.NUM = STKOUTDTL.Num
               and STKOUT.Cls = STKOUTDTL.Cls
              left join STKOUTLOG
                on STKOUT.NUM = STKOUTLOG.NUM
               and STKOUT.Cls = STKOUTLOG.Cls
               and STKOUTLOG.Stat = 100
              left join STKOUTLOG STKOUTLOG2
                on STKOUT.NUM = STKOUTLOG2.NUM
               and STKOUT.Cls = STKOUTLOG2.Cls
               and STKOUTLOG2.Stat = 700
              left join STKOUTLOG STKOUTLOG3
                on STKOUT.NUM = STKOUTLOG3.NUM
               and STKOUT.Cls = STKOUTLOG3.Cls
               and STKOUTLOG3.Stat = 1000
              left join GOODSOUTSALEDATESTORE
                on GOODSOUTSALEDATESTORE.GID = STKOUTDTL.GDGID
               and GOODSOUTSALEDATESTORE.STORE = STKOUT.CLIENT
             where STKOUT.Cls = '统配出'
               and STKOUTDTL.GDGID is not null
               and STKOUT.CLIENT is not null
               and GOODSOUTSALEDATESTORE.LASTMODIFYDATE is null
               and STKOUT.FILDATE > begindate
             group by STKOUTDTL.GDGID, STKOUT.CLIENT) AA
      full join (select GOODSOUTSALEDATESTORE.GID,
                        GOODSOUTSALEDATESTORE.STORE,
                        min(sdrpts.fildate) saldate
                   from GOODSOUTSALEDATESTORE, sdrpts
                  where GOODSOUTSALEDATESTORE.GID = sdrpts.gdgid
                    and GOODSOUTSALEDATESTORE.STORE = sdrpts.snd
                    and GOODSOUTSALEDATESTORE.SALEDATE is null
                    and cls = '零售'
                    and sdrpts.fildate between begindate and
                        to_char(sysdate - 1, 'yyyy-mm-dd')
                  group by GOODSOUTSALEDATESTORE.GID,
                           GOODSOUTSALEDATESTORE.STORE) BB
        on AA.GDGID = BB.GID
       and AA.CLIENT = BB.STORE;

begin
  goodscode  := trim('\(1,1)');
  goodsName  := trim('\(2,1)');
  vstorecode := trim('\(3,1)');
  adate      := to_date('\(4,1)', 'yyyy.mm.dd');
  bdate      := to_date('\(5,1)', 'yyyy.mm.dd');
  days       := trim('\(6,1)');
  /*  insert into tempagagm
  (SRCLINE)*/
  /*select bdate - adate + 1 into days from dual;
  commit;*/
  /*确认搜索开始时间为GOODSOUTSALEDATESTORE表的最大更新时间*/
  select nvl(max(LASTMODIFYDATE), '2014-01-01')
    into begindate
    from GOODSOUTSALEDATESTORE;

  loop
  
    insert into GOODSOUTSALEDATESTORE
      (gid, Store)
      select distinct STKOUTDTL.GDGID, STKOUT.CLIENT
        from STKOUT
        left join STKOUTDTL
          on STKOUT.NUM = STKOUTDTL.NUM
         and STKOUT.cls = STKOUTDTL.cls
        left join GOODSOUTSALEDATESTORE
          on STKOUT.CLIENT = GOODSOUTSALEDATESTORE.STORE
         and STKOUTDTL.GDGID = GOODSOUTSALEDATESTORE.GID
        left join STKOUTLOG
          on STKOUT.NUM = STKOUTLOG.NUM
         and STKOUT.cls = STKOUTLOG.cls
        left join goods
          on STKOUTDTL.GDGID = goods.gid
       where STKOUTDTL.GDGID is not null
         and goods.SORT not like '2%'
         and STKOUTLOG.TIME > begindate
         and GOODSOUTSALEDATESTORE.GID is null
         and rownum < 4000;
  
    exit when sql%notfound;
    commit;
  end loop;

  /*循环更新GOODSOUTSALEDATESTORE表中首配首销时间*/
  OPEN CR1;
  LOOP
    FETCH CR1
      INTO GDGIDa, STOREa, FILLDATEa, OUTDATEa, INDATEa, SALEDATEa;
    EXIT WHEN CR1%NOTFOUND;
  
    update GOODSOUTSALEDATESTORE
       set FILLDATE = nvl(FILLDATE, FILLDATEa),
           OUTDATE  = nvl(OUTDATE, OUTDATEa),
           INDATE   = nvl(INDATE, INDATEa),
           SALEDATE = nvl(SALEDATE, SALEDATEa)
     where gid = GDGIDa
       and STORE = STOREa;
  
  END LOOP;
  CLOSE CR1;

  /*更新最后更新时间，以后不再更新*/

  update GOODSOUTSALEDATESTORE
     set LASTMODIFYDATE = to_char(sysdate - 1, 'yyyy-mm-dd')
   where SALEDATE is not null;

  if sql%notfound then
    update GOODSOUTSALEDATESTORE
       set lastmodifydate = to_char(sysdate - 1, 'yyyy-mm-dd')
     where rownum = 1
       and lastmodifydate is not null;
  end if;

  commit;

  delete tmp_test2;
  commit;

  insert into tmp_test2
    (char1, ----品类
     char2, ----大类
     char3, ----小类1
     char4, ----小类2
     num1, ---零售价
     char5, ---季节
     char6, ---商品代码
     char7, ---商品名称
     date1, ---首配审核时间
     date2, ---首批发货时间
     date3, ---首批到店时间
     date4, ---首批销售时间
     char8, ----店铺代码
     char9, -------店铺名称
     int1, -----在店库存量
     num2, -----在店库存金额
     int2, ----销售数量
     num3, ----实际销售金额
     int3, ---已审核未配发量
     num4, ----已审核未配发金额
     num5, ---售馨率
     num6, ----可周转天数
     date5, ---门店记账日期
     int4, ---销售天数
     int5, ---运输天数
     num7, ----中包装箱规
     num8, ----整箱箱规
     int6, --- 总仓库存 
     int7  ---补货天数 
     )
  
    SELECT /*+ rule */
     SORT.NAME NAME, ----品类
     SORT__1.NAME NAME1, ----大类
     SORT__2.NAME NAME11, ----小类1
     SORT__3.NAME NAME111, ----小类2
     RPGGD.RTLPRC, ---零售价
     GOODS.C_FASEASON C_FASEASON, ---季节
     GOODS.CODE CODE, ---商品代码
     GOODS.NAME NAME1111, ---商品名称
     GOODSOUTSALEDATESTORE.FILLDATE FILLDATE, ---首配审核时间
     GOODSOUTSALEDATESTORE.OUTDATE OUTDATE, ---首批发货时间
     GOODSOUTSALEDATESTORE.INDATE INDATE, ---首批到店时间
     GOODSOUTSALEDATESTORE.SALEDATE SALEDATE, ---首批销售时间
     STORE.CODE CODE1, ---店铺代码
     STORE.NAME NAME11111, ---店铺名称
     SUM(BUSINV.QTY) QTY, ---在店库存量
     
     0 TOTAL, ----在店库存金额
     SUM(SDRPTS.QTY) QTY1, ---销售数量
     SUM(SDRPTS.AMT) AMT, ---实际销售金额
     SUM(nvl(noru.qty, 0)) INT3, ---已审核未配发量
     SUM(nvl(noru.TOTAL, 0)) NUM1, ---已审核未配发金额
     round(case
             when (SUM(nvl(BUSINV.QTY, 0)) + SUM(nvl(SDRPTS.QTY, 0)) +
                  SUM(nvl(noru.qty, 0))) = 0 then
              0
             else
              SUM(nvl(SDRPTS.QTY, 0)) /
              (SUM(nvl(BUSINV.QTY, 0)) + SUM(nvl(SDRPTS.QTY, 0)) +
               SUM(nvl(noru.qty, 0)))
           end,
           2) 售馨率, -----售馨率
     round(case
             when SUM(nvl(SDRPTS.QTY, 0)) = 0 then
              1000000
             else
              (SUM(nvl(BUSINV.QTY, 0)) + SUM(nvl(noru.qty, 0))) * (case
                when trunc(nvl(GOODSOUTSALEDATESTORE.OUTDATE, '2014 -01-01')) < adate then
                 bdate - adate + 1
                else
                 bdate - (trunc(nvl(GOODSOUTSALEDATESTORE.OUTDATE, '2014 -01-01')) + 1 +
                 nvl(STORE.receiverdays, 0))
              end) / SUM(nvl(SDRPTS.QTY, 0))
           end,
           0) 可周转天数, ------可周转天数
     adate, ---查询开始时间
     
     case
       when trunc(nvl(GOODSOUTSALEDATESTORE.OUTDATE, '2014 -01-01')) < adate then
        bdate - adate + 1
       else
        bdate - (trunc(nvl(GOODSOUTSALEDATESTORE.OUTDATE, '2014 -01-01')) + 1 +
        nvl(STORE.receiverdays, 0))
     end saldays, ---销售天数
     nvl(STORE.receiverdays, 0) receiverdays, --运输天数  
     max(GDQPC.QPC) QPC, ---中包装箱规
     max(GDQPC2.QPC) QPC2, ---整箱箱规
     max(BUSINVZ.QTY) QTYZ, -- 总仓库存    
     days          ---补货天数
      FROM GOODSOUTSALEDATESTORE GOODSOUTSALEDATESTORE
    
      full join BUSINV BUSINV
        on GOODSOUTSALEDATESTORE.GID = BUSINV.GDGID
       and GOODSOUTSALEDATESTORE.STORE = BUSINV.STORE
    
      left join STORE STORE
        on nvl(BUSINV.Store, GOODSOUTSALEDATESTORE.Store) = STORE.GID
      left join GOODS GOODS
        on nvl(BUSINV.GDGID, GOODSOUTSALEDATESTORE.GID) = GOODS.Gid
      left join SORT SORT
        on (substr(GOODS.SORT, 0, 2) = SORT.CODE)
      left join SORT SORT__1
        on (substr(GOODS.SORT, 0, 4) = SORT__1.CODE)
      left join SORT SORT__2
        on (substr(GOODS.SORT, 0, 6) = SORT__2.CODE)
      left join SORT SORT__3
        on (substr(GOODS.SORT, 0, 8) = SORT__3.CODE)
      left join (select sum(decode(SDRPTS.Cls, '零售', 1, '零售退', -1, 0) * QTY) qty,
                        sum(decode(SDRPTS.Cls, '零售', 1, '零售退', -1, 0) * (AMT + tax)) AMT,
                        SDRPTS.SND,
                        SDRPTS.GDGID
                   from SDRPTS
                  where SDRPTS.FILDATE >= adate
                    and SDRPTS.FILDATE <= bdate
                  group by SDRPTS.SND, SDRPTS.GDGID) SDRPTS
        on nvl(BUSINV.Store, GOODSOUTSALEDATESTORE.Store) = SDRPTS.SND
       and nvl(BUSINV.GDGID, GOODSOUTSALEDATESTORE.GID) = SDRPTS.GDGID
    
      left join (select STKOUT.CLIENT storeid,
                        STKOUTDTL.GDGID,
                        sum(STKOUTDTL.QTY) qty,
                        sum(STKOUTDTL.TOTAL) TOTAL
                   from STKOUT, STKOUTDTL, store
                  where STKOUt.Num = STKOUTDTL.Num
                    and STKOUt.cls = STKOUTDTL.cls
                    and STKOUT.CLIENT = store.gid
                    and store.code = vstorecode
                    and STKOUT.cls = '统配出'
                    and STKOUT.STAT = 100
                  group by STKOUT.CLIENT, STKOUTDTL.GDGID) noru
        on nvl(BUSINV.Store, GOODSOUTSALEDATESTORE.Store) = noru.storeid
       and nvl(BUSINV.GDGID, GOODSOUTSALEDATESTORE.GID) = noru.GDGID
      left join RPGGD RPGGD
        on (GOODS.GID = RPGGD.GDGID)
       and (GOODS.CODE = RPGGD.INPUTCODE)
      left join GDQPC
        on GDQPC.GID = GOODS.GID
       and GDQPC.Isdu = 2
      left join GDQPC GDQPC2
        on GDQPC2.GID = GOODS.GID
       and GDQPC2.Ispu = 2
      left join (select sum(qty) qty, GDGID
                   from BUSINV
                  where STORE = 1000000
                  group by GDGID) BUSINVZ
        on GOODSOUTSALEDATESTORE.GID = BUSINVZ.GDGID
    
     WHERE (STORE.CODE = vstorecode)
       and (goodscode is null or GOODS.CODE = goodscode)
       and (goodsName is null or GOODS.Name = goodsName)
    
     GROUP BY SORT.NAME, ----品类
              SORT__1.NAME, ----大类
              SORT__2.NAME, ----小类1
              SORT__3.NAME, ----小类2
              RPGGD.RTLPRC, ---零售价
              GOODS.C_FASEASON, ---季节
              GOODS.CODE, ---商品代码
              GOODS.NAME, ---商品名称
              GOODSOUTSALEDATESTORE.FILLDATE, ---首配审核时间
              GOODSOUTSALEDATESTORE.OUTDATE, ---首批发货时间
              GOODSOUTSALEDATESTORE.INDATE, ---首批到店时间
              GOODSOUTSALEDATESTORE.SALEDATE, ---首批销售时间
              STORE.CODE, ---店铺代码
              STORE.NAME, ---店铺名称;
              STORE.receiverdays; --店铺到货天数
  commit;

 update tmp_test2
     set char10 = (case
                    when num5 < 0.4 then
                     '滞销'
                    when num5 < 0.7 then
                     '平销'
                    else
                     '畅销'
                  end), -------ABC
         char11 = (case
                    when num6 < 25 then
                     '补货'
                    else
                     '充足'
                  end), -------补货判断
          num9 = (case
                  when int6 <=0 or int2<=0 or int4<=0  or num8 <= 0 or round(((int2 / int4) * days - int1 - int3) / num8, 0) < 0 then
                   0
                  when  int6 >= round(((int2 / int4) * days - int1 - int3) / num8, 0) * num8 then
                   round(((int2 / int4) * days - int1 - int3) / num8, 0) * num8
                  when  int6 < round(((int2 / int4) * days - int1 - int3) / num8, 0) * num8 then
                   round(int6 / num8, 0) * num8
                end); -------补货量

  commit;
  
  
  

end;
</BEFORERUN>
<AFTERRUN>
</AFTERRUN>
<TABLELIST>
  <TABLEITEM>
    <TABLE>tmp_test2</TABLE>
    <ALIAS>tmp_test2</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
</TABLELIST>
<JOINLIST>
</JOINLIST>
<COLUMNLIST>
  <FIXEDCOLUMNS>0</FIXEDCOLUMNS>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char1</COLUMN>
    <TITLE>品类</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char2</COLUMN>
    <TITLE>大类</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char2</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char3</COLUMN>
    <TITLE>小类1</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char3</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char4</COLUMN>
    <TITLE>小类2</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char4</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.num1</COLUMN>
    <TITLE>零售价</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>num1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char5</COLUMN>
    <TITLE>季节</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char5</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char6</COLUMN>
    <TITLE>商品代码</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char6</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char7</COLUMN>
    <TITLE>商品名称</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char7</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.date1</COLUMN>
    <TITLE>首配审核时间</TITLE>
    <FIELDTYPE>11</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>date1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>yyyy-MM-dd</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.date2</COLUMN>
    <TITLE>首批发货时间</TITLE>
    <FIELDTYPE>11</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>date2</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>yyyy-MM-dd</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.date3</COLUMN>
    <TITLE>首批到店时间</TITLE>
    <FIELDTYPE>11</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>date3</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>yyyy-MM-dd</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.date4</COLUMN>
    <TITLE>首批销售时间</TITLE>
    <FIELDTYPE>11</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>date4</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>yyyy-MM-dd</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char8</COLUMN>
    <TITLE>店铺代码</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char8</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char9</COLUMN>
    <TITLE>店铺名称</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char9</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.int1</COLUMN>
    <TITLE>在店库存量</TITLE>
    <FIELDTYPE>3</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>int1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.int1 * tmp_test2.num1</COLUMN>
    <TITLE>在店库存金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>num2</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.int2</COLUMN>
    <TITLE>销售数量</TITLE>
    <FIELDTYPE>3</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>int2</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.num3</COLUMN>
    <TITLE>实际销售金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>num3</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.00</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.int3</COLUMN>
    <TITLE>已审核未配发量</TITLE>
    <FIELDTYPE>3</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>int3</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.num4</COLUMN>
    <TITLE>已审核未配发金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>num4</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.num5</COLUMN>
    <TITLE>售馨率</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>num5</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.00</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.int4</COLUMN>
    <TITLE>销售天数</TITLE>
    <FIELDTYPE>3</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>int4</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>case when tmp_test2.num6= 1000000 then '无销售' else to_char(tmp_test2.num6) end </COLUMN>
    <TITLE>可周转天数</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>num6</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.00</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.date5</COLUMN>
    <TITLE>门店记账日期</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>date5</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.num7</COLUMN>
    <TITLE>中包装箱规</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>num7</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.num8</COLUMN>
    <TITLE>整箱箱规</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>num8</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.int6</COLUMN>
    <TITLE>总仓库存</TITLE>
    <FIELDTYPE>3</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>int6</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char10</COLUMN>
    <TITLE>ABC</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char10</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char11</COLUMN>
    <TITLE>补货判断</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char11</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.num9</COLUMN>
    <TITLE>补货量</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>num9</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.int7</COLUMN>
    <TITLE>补货天数</TITLE>
    <FIELDTYPE>3</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>int7</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
</COLUMNLIST>
<COLUMNWIDTH>
  <COLUMNWIDTHITEM>109</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>143</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>152</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>140</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>142</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>124</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>82</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>223</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>112</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>112</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>112</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>112</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>64</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>116</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>66</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>78</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>102</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>102</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>90</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>102</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>69</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>66</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>71</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>66</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>64</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>64</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>41</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>69</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>64</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>64</COLUMNWIDTHITEM>
</COLUMNWIDTH>
<GROUPLIST>
</GROUPLIST>
<ORDERLIST>
</ORDERLIST>
<CRITERIALIST>
  <WIDTHLIST>
  </WIDTHLIST>
  <CRITERIAITEM>
    <LEFT>tmp_test2.char6</LEFT>
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
    <LEFT>tmp_test2.char7</LEFT>
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
    <LEFT>tmp_test2.char8</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>10015</RIGHTITEM>
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
    <DEFAULTVALUE>40010</DEFAULTVALUE>
    <ISREQUIRED>TRUE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>tmp_test2.date5</LEFT>
    <OPERATOR>>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2015.06.11</RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
    </RIGHT>
    <ISHAVING>FALSE</ISHAVING>
    <ISQUOTED>2</ISQUOTED>
    <PICKNAME>
    </PICKNAME>
    <PICKVALUE>
    </PICKVALUE>
    <DEFAULTVALUE>前7天</DEFAULTVALUE>
    <ISREQUIRED>TRUE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>tmp_test2.date5</LEFT>
    <OPERATOR><=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2015.06.17</RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
    </RIGHT>
    <ISHAVING>FALSE</ISHAVING>
    <ISQUOTED>2</ISQUOTED>
    <PICKNAME>
    </PICKNAME>
    <PICKVALUE>
    </PICKVALUE>
    <DEFAULTVALUE>昨天</DEFAULTVALUE>
    <ISREQUIRED>TRUE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>tmp_test2.int7</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>20</RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
    </RIGHT>
    <ISHAVING>FALSE</ISHAVING>
    <ISQUOTED>1</ISQUOTED>
    <PICKNAME>
    </PICKNAME>
    <PICKVALUE>
    </PICKVALUE>
    <DEFAULTVALUE>20</DEFAULTVALUE>
    <ISREQUIRED>TRUE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
</CRITERIALIST>
<CRITERIAWIDTH>
  <CRITERIAWIDTHITEM>76</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>76</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>86</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>158</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>124</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>76</CRITERIAWIDTHITEM>
</CRITERIAWIDTH>
<SG>
  <LINE>
  </LINE>
  <LINE>
    <SGLINEITEM>条件 1：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM>10015</SGLINEITEM>
    <SGLINEITEM>2015.06.11</SGLINEITEM>
    <SGLINEITEM>2015.06.17</SGLINEITEM>
    <SGLINEITEM>20</SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 2：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 3：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 4：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
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
  <DXCOLORODDROW>-2147483643</DXCOLORODDROW>
  <DXCOLOREVENROW>-2147483643</DXCOLOREVENROW>
  <DXFILTERNAME></DXFILTERNAME>
  <DXFILTERTYPE></DXFILTERTYPE>
  <DXFILTERLIST>
  </DXFILTERLIST>
  <DXSHOWGRIDLINE>1</DXSHOWGRIDLINE>
</DXDBGRIDITEM>
</SQLQUERY>
<SQLREPORT>
<RPTTITLE></RPTTITLE>
<RPTGROUPCOUNT>0</RPTGROUPCOUNT>
<RPTGROUPLIST>
</RPTGROUPLIST>
<RPTCOLUMNCOUNT>0</RPTCOLUMNCOUNT>
<RPTCOLUMNWIDTHLIST>
</RPTCOLUMNWIDTHLIST>
<RPTLEFTMARGIN>20</RPTLEFTMARGIN>
<RPTORIENTATION>0</RPTORIENTATION>
<RPTCOLUMNS>1</RPTCOLUMNS>
<RPTHEADERLEVEL>0</RPTHEADERLEVEL>
<RPTPRINTCRITERIA>TRUE</RPTPRINTCRITERIA>
<RPTVERSION></RPTVERSION>
<RPTNOTE></RPTNOTE>
<RPTFONTSIZE>10</RPTFONTSIZE>
<RPTLINEHEIGHT>宋体</RPTLINEHEIGHT>
<RPTPAGEHEIGHT>66</RPTPAGEHEIGHT>
<RPTPAGEWIDTH>80</RPTPAGEWIDTH>
<RPTTITLETYPE>0</RPTTITLETYPE>
<RPTCURREPORT></RPTCURREPORT>
<RPTREPORTLIST>
</RPTREPORTLIST>
</SQLREPORT>

