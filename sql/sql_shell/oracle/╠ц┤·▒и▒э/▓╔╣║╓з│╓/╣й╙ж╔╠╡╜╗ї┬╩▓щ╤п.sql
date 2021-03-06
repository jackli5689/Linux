<VERSION>4.1.0</VERSION>
<SQLQUERY>
<REMARK>
[标题]
     供应商到货率查询
[应用背景]
     查询供应商在规定时间内的到货率。
[结果列描述]
     显示定单数量、金额及到货数量、金额、到货率、缺货率
[必要的查询条件]
     填单日期
     若录入供应商代码可加快查询速度。
[实现方法]
     若想根据其他筛选条件筛选，可由“定义查询——>构造查询条件”增加自己想要的筛选条
件。
[其它]
CREATE OR REPLACE PROCEDURE h4rcalc_GETSORT_GDGID
 (
   piUsercode varchar2
 )
AS
  VCNT        INT ;
BEGIN
  DELETE FROM  H4RTMP_GDGID;
  DELETE FROM  H4RTMP_SORT30SUM ;
  COMMIT ;

  SELECT COUNT(1) INTO VCNT FROM DUAL
    WHERE EXISTS (SELECT 1 FROM PSSORTEMP A, EMPLOYEEH b
       WHERE B.GID = A.EMPGID AND UPPER(B.CODE) = UPPER
(piUsercode)) ;

  IF VCNT = 0 THEN
     INSERT INTO H4RTMP_GDGID(GDGID)
        SELECT C.GID FROM GOODSH C ;
  ELSE

      INSERT INTO H4RTMP_SORT30SUM(SORT)
       SELECT B.cscode FROM PSSORTEMP A , HDTMP_SORT B
       WHERE B.acode = '0000' AND B.ASCODE = A.SORTCODE
        AND EMPGID in (SELECT GID FROM EMPLOYEE WHERE UPPER
(CODE) = UPPER(piUsercode)) ;

      DELETE FROM H4RTMP_GDGID ;
       COMMIT;

      INSERT INTO H4RTMP_GDGID(GDGID)
       SELECT C.GID FROM H4RTMP_SORT30SUM B , GOODSH C
         WHERE B.SORT = C.SORT ;

   END IF;

   COMMIT;
END;


create or replace view hdtmp_sort as
select sortarch.acode acode , sortarch.aname aname , 
sortarch.applyto applyto ,
     a.scode ascode, a.sname asname ,
     b.scode bscode, b.sname bsname ,
     b.cscode cscode , b.csname csname ,
     b.dscode dscode , b.dsname dsname
  from sortarch ,
  --第1级
  (select * from sortname where lvl = 1 ) a , ---分类体系
   --第2级
  (
  select b.acode , b.scode , b.sname , c.cscode , c.csname , 
c.dscode , c.dsname
  from
   (select * from sortname where lvl = 2 ) b ,
   --第3级 和 第4级
   ( select c.acode , c.scode cscode , c.sname csname ,
     d.scode dscode , d.sname dsname from
         (select * from sortname where lvl = 3 ) c ,
         (select * from sortname where lvl = 4 ) d
      where c.acode = d.acode(+)
       and instr(d.scode(+) , c.scode) =1 ) c
   where b.acode = c.acode(+)
    and instr(c.cscode(+) , b.scode) =1
  ) b
 where sortarch.acode = a.acode
  and a.acode = b.acode(+)
  and instr(b.scode(+) , a.scode) =1;
</REMARK>
<BEFORERUN>
DECLARE
     VBGNDATE DATE;
     VENDDATE DATE;  
     vFlag    varchar2(24) ;
BEGIN
     VBGNDATE:=to_date('\(1,1)','yyyy.mm.dd');
     VENDDATE:=to_date('\(2,1)','yyyy.mm.dd')+1;
     vFlag := '\(3,1)' ;

  BEGIN
      h4rcalc_GETSORT_GDGID(piUsercode => '\(USERCODE)' );
  END ; 

     DELETE FROM H4RTMP_GYSDHL;
     COMMIT;
  IF vFlag = '按制单日期' THEN
			INSERT INTO H4RTMP_GYSDHL( NUM, CLS,FILDATE,SETTLENO,VENDOR,LINE,GDGID,ORDQTY,QTY,LACKQTY,TOTAL,LACKTOTAL
			,stat,ORDQPCQTY,QPCQTY,LACKQPCQTY)
			 Select a.num,a.cls,a.fildate,a.settleno,a.vendor,b.line,b.gdgid,b.qty,b.ACVQTY,
			   b.qty-b.acvqty,b.total,(b.qty-b.acvqty)*b.price/b.qpc,1,trunc(b.qty/b.qpc),trunc(b.ACVQTY/b.qpc),trunc((b.qty-b.acvqty)/b.qpc)
			    from ord a,orddtl b , ordlog c
			     where a.stat in (100, 200, 300)
                               and c.stat = 100
                               and c.cls = a.cls
                               and c.num = a.num
			       and a.num=b.num and a.cls=b.cls
			       and b.qty<>0
			       and c.time <= VENDDATE
			       and c.time >= VBGNDATE
			       order by a.num,b.line;
			  COMMIT;  
   ELSIF vFlag = '按验收/过期日期' THEN
			INSERT INTO H4RTMP_GYSDHL( NUM, CLS,FILDATE,SETTLENO,VENDOR,LINE,GDGID,ORDQTY,QTY,LACKQTY,TOTAL,LACKTOTAL
			,stat,ORDQPCQTY,QPCQTY,LACKQPCQTY)
			 Select a.num,a.cls,a.fildate,a.settleno,a.vendor,b.line,b.gdgid,b.qty,b.ACVQTY,
			   b.qty-b.acvqty,b.total,(b.qty-b.acvqty)*b.price/b.qpc,1,trunc(b.qty/b.qpc),trunc(b.ACVQTY/b.qpc),trunc((b.qty-b.acvqty)/b.qpc)
			    from ord a,orddtl b 
			     where stat=300 --已完结定单
			       and a.num=b.num and a.cls=b.cls
			       and b.qty<>0 --  
			       and a.lstupdtime<=VENDDATE
			       and a.lstupdtime>=VBGNDATE
			       order by a.num,b.line;
               /*
			INSERT INTO H4RTMP_GYSDHL( NUM, CLS,FILDATE,SETTLENO,VENDOR,LINE,GDGID,ORDQTY,QTY,LACKQTY,TOTAL,LACKTOTAL
			,stat,ORDQPCQTY,QPCQTY,LACKQPCQTY)
			 Select a.num,a.cls,a.fildate,a.settleno,a.vendor,b.line,b.gdgid,b.qty,b.ACVQTY,
			   b.qty-b.acvqty,b.total,(b.qty-b.acvqty)*b.price/b.qpc,1,trunc(b.qty/b.qpc),trunc(b.ACVQTY/b.qpc),trunc((b.qty-b.acvqty)/b.qpc)
			    from stkin a,stkindtl b , stkinlog c
			     where stat=300 --已完结定单
                               and c.stat = 1000 --进货单已收货
                               and c.cls = a.cls
                               and c.num = a.num
			       and a.num=b.num and a.cls=b.cls
			       and c.time<=VENDDATE
			       and c.time>=VBGNDATE
			       order by a.num,b.line;
              */
			  COMMIT;     
   END IF;

  DELETE FROM H4RTMP_GYSDHL WHERE NOT EXISTS (SELECT 1 FROM H4RTMP_GDGID WHERE GDGID = H4RTMP_GYSDHL.GDGID) ;
  COMMIT;

INSERT INTO H4RTMP_GYSDHL( VENDOR,FILDATE,RCOUNT,STAT)
 SELECT VENDOR,VBGNDATE,COUNT(GDGID),2
     FROM H4RTMP_GYSDHL
      where LACKQTY<>0
       and stat=1
       GROUP BY VENDOR;
INSERT INTO H4RTMP_GYSDHL( VENDOR,FILDATE,RCOUNT1,STAT)
 SELECT VENDOR,VBGNDATE,COUNT(GDGID),3
     FROM H4RTMP_GYSDHL
      where stat=1
       GROUP BY VENDOR;
INSERT INTO H4RTMP_GYSDHL(VENDOR,FILDATE,ORDQTY,QTY,LACKQTY,RCOUNT1,RCOUNT2,
RCOUNT,TOTAL,LACKTOTAL,STAT,ORDQPCQTY,QPCQTY,LACKQPCQTY)
 SELECT VENDOR,VBGNDATE,SUM(ORDQTY),SUM(QTY),SUM(LACKQTY)
   ,SUM(RCOUNT1),SUM(RCOUNT1)-SUM(RCOUNT),SUM(RCOUNT),SUM(TOTAL),SUM(LACKTOTAL),100,SUM(ORDQPCQTY),SUM(QPCQTY),SUM(LACKQPCQTY)
     FROM H4RTMP_GYSDHL
       WHERE STAT in(1,2,3)
       GROUP BY VENDOR;

  UPDATE H4RTMP_GYSDHL SET RATE=DECODE(ORDQTY,0,0,LACKQTY/ORDQTY)*100 , Flag = vFlag WHERE 
   STAT=100;       
 
 COMMIT;
END;
</BEFORERUN>
<AFTERRUN>
</AFTERRUN>
<TABLELIST>
  <TABLEITEM>
    <TABLE>H4RTMP_GYSDHL</TABLE>
    <ALIAS>H4RTMP_GYSDHL</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>VENDORH</TABLE>
    <ALIAS>VENDORH</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
</TABLELIST>
<JOINLIST>
  <JOINITEM>
    <LEFT>H4RTMP_GYSDHL.vendor</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>VENDORH.GID</RIGHT>
  </JOINITEM>
  <JOINITEM>
    <LEFT>H4RTMP_GYSDHL.STAT</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>100</RIGHT>
  </JOINITEM>
</JOINLIST>
<COLUMNLIST>
  <FIXEDCOLUMNS>2</FIXEDCOLUMNS>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>VENDORH.CODE</COLUMN>
    <TITLE>供应商代码</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
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
    <COLUMN>VENDORH.NAME</COLUMN>
    <TITLE>供应商名称</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
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
    <COLUMN>H4RTMP_GYSDHL.TOTAL</COLUMN>
    <TITLE>定货金额数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>TOTAL</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.TOTAL-H4RTMP_GYSDHL.LACKTOTAL</COLUMN>
    <TITLE>到货金额数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>ACVTOTAL</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>decode(H4RTMP_GYSDHL.TOTAL,0,0,1-H4RTMP_GYSDHL.LACKTOTAL/H4RTMP_GYSDHL.TOTAL)*100</COLUMN>
    <TITLE>金额到货率</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>AMTRATE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.LACKTOTAL</COLUMN>
    <TITLE>缺货金额数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>LACKTOTAL</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>decode(H4RTMP_GYSDHL.TOTAL,0,0,H4RTMP_GYSDHL.LACKTOTAL/H4RTMP_GYSDHL.TOTAL)*100</COLUMN>
    <TITLE>金额缺货率</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>LACKAMTRATE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.ORDQPCQTY</COLUMN>
    <TITLE>定单整件数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>ORDQPCQTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.ORDQTY</COLUMN>
    <TITLE>定单数量</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>ORDQTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.QPCQTY</COLUMN>
    <TITLE>到货整件数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>QPCQTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.QTY</COLUMN>
    <TITLE>到货数量</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>QTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.LACKQPCQTY</COLUMN>
    <TITLE>缺货整件数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>LACKQPCQTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.LACKQTY</COLUMN>
    <TITLE>缺货数量</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>LACKQTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>100-H4RTMP_GYSDHL.RATE</COLUMN>
    <TITLE>数量到货率%</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>RATE_1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.RATE</COLUMN>
    <TITLE>数量缺货率%</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>RATE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.RCOUNT1</COLUMN>
    <TITLE>定货品项数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>RCOUNT1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.RCOUNT2</COLUMN>
    <TITLE>到货品项数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>RCOUNT2</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.RCOUNT</COLUMN>
    <TITLE>缺货品项数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>RCOUNT</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>100-decode(H4RTMP_GYSDHL.RCOUNT1,0,0,H4RTMP_GYSDHL.RCOUNT/H4RTMP_GYSDHL.RCOUNT1)*100</COLUMN>
    <TITLE>品项到货率%</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>RATE1_1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>decode(H4RTMP_GYSDHL.RCOUNT1,0,0,H4RTMP_GYSDHL.RCOUNT/H4RTMP_GYSDHL.RCOUNT1)*100</COLUMN>
    <TITLE>品项缺货率%</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>RATE1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.FILDATE</COLUMN>
    <TITLE>日期</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>FILDATE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>VENDORH.MEMO</COLUMN>
    <TITLE>备注</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>MEMO</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_GYSDHL.FLAG</COLUMN>
    <TITLE>查询标志</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>FLAG</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>trunc(H4RTMP_GYSDHL.FILDATE)</COLUMN>
    <TITLE>日期.</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>truncFILDATE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
</COLUMNLIST>
<COLUMNWIDTH>
  <COLUMNWIDTHITEM>73</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>255</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>101</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>101</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>95</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>110</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>66</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>66</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>140</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>73</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>72</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>72</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>66</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>66</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>66</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>72</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>72</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>71</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>72</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>72</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>32</COLUMNWIDTHITEM>
</COLUMNWIDTH>
<GROUPLIST>
</GROUPLIST>
<ORDERLIST>
  <ORDERITEM>
    <COLUMN>金额到货率</COLUMN>
    <ORDER>DESC</ORDER>
  </ORDERITEM>
</ORDERLIST>
<CRITERIALIST>
  <WIDTHLIST>
  </WIDTHLIST>
  <CRITERIAITEM>
    <LEFT>trunc(H4RTMP_GYSDHL.FILDATE)</LEFT>
    <OPERATOR>>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2010.10.01</RIGHTITEM>
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
    <DEFAULTVALUE>月初</DEFAULTVALUE>
    <ISREQUIRED>FALSE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>trunc(H4RTMP_GYSDHL.FILDATE)</LEFT>
    <OPERATOR><=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2010.10.27</RIGHTITEM>
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
    <ISREQUIRED>FALSE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>H4RTMP_GYSDHL.FLAG</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>按制单日期</RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
      <RIGHTITEM></RIGHTITEM>
    </RIGHT>
    <ISHAVING>FALSE</ISHAVING>
    <ISQUOTED>0</ISQUOTED>
    <PICKNAME>
      <PICKNAMEITEM>按定单审核日期</PICKNAMEITEM>
      <PICKNAMEITEM>按验收/过期日期</PICKNAMEITEM>
    </PICKNAME>
    <PICKVALUE>
      <PICKVALUEITEM>按制单日期</PICKVALUEITEM>
      <PICKVALUEITEM>按验收/过期日期</PICKVALUEITEM>
    </PICKVALUE>
    <DEFAULTVALUE>按制单日期</DEFAULTVALUE>
    <ISREQUIRED>FALSE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>VENDORH.CODE</LEFT>
    <OPERATOR>IN</OPERATOR>
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
    <LEFT>decode(H4RTMP_GYSDHL.TOTAL,0,0,1-H4RTMP_GYSDHL.LACKTOTAL/H4RTMP_GYSDHL.TOTAL)*100</LEFT>
    <OPERATOR>>=</OPERATOR>
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
    <LEFT>decode(H4RTMP_GYSDHL.TOTAL,0,0,1-H4RTMP_GYSDHL.LACKTOTAL/H4RTMP_GYSDHL.TOTAL)*100</LEFT>
    <OPERATOR><</OPERATOR>
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
    <LEFT>100-H4RTMP_GYSDHL.RATE</LEFT>
    <OPERATOR>>=</OPERATOR>
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
    <LEFT>100-H4RTMP_GYSDHL.RATE</LEFT>
    <OPERATOR><</OPERATOR>
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
</CRITERIALIST>
<CRITERIAWIDTH>
  <CRITERIAWIDTHITEM>122</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>93</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>158</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>112</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>112</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>118</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>118</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>118</CRITERIAWIDTHITEM>
</CRITERIAWIDTH>
<SG>
  <LINE>
  </LINE>
  <LINE>
    <SGLINEITEM>条件 1：</SGLINEITEM>
    <SGLINEITEM>2010.10.01</SGLINEITEM>
    <SGLINEITEM>2010.10.27</SGLINEITEM>
    <SGLINEITEM>按制单日期</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 2：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
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
  <NUMOFNEXTQRY>1</NUMOFNEXTQRY>
  <NCRITERIALIST>
    <NEXTQUERY>订单执行情况查询.sql</NEXTQUERY>
    <NCRITERIAITEM>
      <LEFT>供应商代码类似于</LEFT>
      <RIGHT>供应商代码</RIGHT>
    </NCRITERIAITEM>
  </NCRITERIALIST>
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
  <DXCOLOREVENROW>12632256</DXCOLOREVENROW>
  <DXFILTERNAME></DXFILTERNAME>
  <DXFILTERLIST>
  </DXFILTERLIST>
  <DXSHOWGRIDLINE>1</DXSHOWGRIDLINE>
</DXDBGRIDITEM>
</SQLQUERY>
<SQLREPORT>
<RPTTITLE>供应商到货率查询</RPTTITLE>
<RPTGROUPCOUNT>0</RPTGROUPCOUNT>
<RPTGROUPLIST>
</RPTGROUPLIST>
<RPTCOLUMNCOUNT>18</RPTCOLUMNCOUNT>
<RPTCOLUMNWIDTHLIST>
  <RPTCOLUMNWIDTHITEM>46</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>197</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>78</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>91</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>57</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>110</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>66</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>66</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>82</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>60</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>72</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>72</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>66</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>66</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>66</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>72</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>72</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>71</RPTCOLUMNWIDTHITEM>
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

