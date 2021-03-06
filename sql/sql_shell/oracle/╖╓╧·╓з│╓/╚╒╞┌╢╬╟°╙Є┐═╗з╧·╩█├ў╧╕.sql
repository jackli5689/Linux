<VERSION>4.1.1</VERSION>
<SQLQUERY>
<REMARK>
[标题]

[应用背景]

[结果列描述]

[必要的查询条件]

[实现方法]
CREATE GLOBAL TEMPORARY TABLE H4TMP_SALDRPT_FX
( 
  ORGKEY     VARCHAR2(38),--发生单位
  CLIENTKEY  VARCHAR2(38),--客户
  PDKEY      VARCHAR2(38),--商品
  SCODE     VARCHAR2(38),--类别代码
  SNAME     VARCHAR2(50),--类别名称
  FILDATE    DATE,--发生日期
  ALLSALEQTY    NUMBER(24,4) DEFAULT 0 NOT NULL,--批发发生数量
  ALLSALETOTAL  NUMBER(24,4) DEFAULT 0 NOT NULL,--批发含税发生金额
  ALLSALEAMT    NUMBER(24,4) DEFAULT 0 NOT NULL,--批发去税发生金额
  ALLSALETAX    NUMBER(24,4) DEFAULT 0 NOT NULL,--批发发生税额
  ALLSALECTOTAL NUMBER(24,4) DEFAULT 0 NOT NULL,--批发含税成本金额
  ALLSALECAMT   NUMBER(24,4) DEFAULT 0 NOT NULL,--批发去税成本金额
  ALLSALECTAX   NUMBER(24,4) DEFAULT 0 NOT NULL,--批发成本税额
  ALLSALEMLTOTAL      NUMBER(24,4) DEFAULT 0 NOT NULL,--批发含税毛利额
  ALLSALEMLTOTALRATE  NUMBER(24,4) DEFAULT 0 NOT NULL,--批发含税毛利率
  ALLSALEMLAMT    NUMBER(24,4) DEFAULT 0 NOT NULL,--批发去税毛利额
  ALLSALEMLAMTRATE    NUMBER(24,4) DEFAULT 0 NOT NULL,--批发去税毛利率
  SALEQTY    NUMBER(24,4) DEFAULT 0 NOT NULL,--发生数量(已剔除退货)
  SALETOTAL  NUMBER(24,4) DEFAULT 0 NOT NULL,--含税发生金额(已剔除退货)
  SALEAMT    NUMBER(24,4) DEFAULT 0 NOT NULL,--去税发生金额(已剔除退货)
  SALETAX    NUMBER(24,4) DEFAULT 0 NOT NULL,--发生税额(已剔除退货)
  SALECTOTAL NUMBER(24,4) DEFAULT 0 NOT NULL,--含税成本金额(已剔除退货)
  SALECAMT   NUMBER(24,4) DEFAULT 0 NOT NULL,--去税成本金额(已剔除退货)
  SALECTAX   NUMBER(24,4) DEFAULT 0 NOT NULL,--成本税额(已剔除退货)
  SALEMLTOTAL      NUMBER(24,4) DEFAULT 0 NOT NULL,--含税毛利额
  SALEMLTOTALRATE  NUMBER(24,4) DEFAULT 0 NOT NULL,--含税毛利率
  SALEMLAMT    NUMBER(24,4) DEFAULT 0 NOT NULL,--去税毛利额
  SALEMLAMTRATE    NUMBER(24,4) DEFAULT 0 NOT NULL,--去税毛利率
  PROPORTION    NUMBER(24,4) DEFAULT 0 NOT NULL,  --去税销售额占比
  SALEBCKQTY    NUMBER(24,4) DEFAULT 0 NOT NULL,--批发退发生数量
  SALEBCKTOTAL  NUMBER(24,4) DEFAULT 0 NOT NULL,--批发退含税发生金额
  SALEBCKAMT    NUMBER(24,4) DEFAULT 0 NOT NULL,--批发退去税发生金额
  SALEBCKTAX    NUMBER(24,4) DEFAULT 0 NOT NULL,--批发退发生税额
  SALEBCKCTOTAL NUMBER(24,4) DEFAULT 0 NOT NULL,--批发退含税成本金额
  SALEBCKCAMT   NUMBER(24,4) DEFAULT 0 NOT NULL,--批发退去税成本金额
  SALEBCKCTAX   NUMBER(24,4) DEFAULT 0 NOT NULL --批发退成本税额
)ON COMMIT PRESERVE ROWS;
EXEC HDCREATESYNONYM('H4TMP_SALDRPT_FX');
EXEC GRANTTOQRYROLE('H4TMP_SALDRPT_FX');
[其它]
2010-10-31/新增/邹勇
</REMARK>
<BEFORERUN>
DECLARE
VBEGDATE DATE;
VENDDATE DATE;
VSALEAMT NUMBER(24,4);
BEGIN
  VBEGDATE := TO_DATE('\(1,1)','YYYY.MM.DD');
  VENDDATE := TO_DATE('\(2,1)','YYYY.MM.DD');
  
  DELETE FROM H4TMP_SALDRPT_FX;
  COMMIT;

  INSERT INTO H4TMP_SALDRPT_FX(CLIENTKEY,PDKEY,FILDATE,
  ALLSALEQTY,ALLSALETOTAL,ALLSALEAMT,ALLSALETAX,ALLSALECTOTAL,ALLSALECAMT,ALLSALECTAX,
  SALEQTY,
  SALETOTAL,
  SALEAMT,
  SALETAX,
  SALECTOTAL,
  SALECAMT,
  SALECTAX,
  SALEBCKQTY,SALEBCKTOTAL,SALEBCKAMT,SALEBCKTAX,SALEBCKCTOTAL,SALEBCKCAMT,SALEBCKCTAX)
  SELECT CLIENTKEY,PDKEY,VBEGDATE,
  SUM(SALEQTY),SUM(SALEAMT)+SUM(SALETAX),SUM(SALEAMT),SUM(SALETAX),
  SUM(SALECAMT)+SUM(SALECTAX),SUM(SALECAMT),SUM(SALECTAX),
  SUM(SALEQTY)-SUM(SALEBCKQTY),
  (SUM(SALEAMT)+SUM(SALETAX))-(SUM(SALEBCKAMT)+SUM(SALEBCKTAX)),
  SUM(SALEAMT)-SUM(SALEBCKAMT),
  SUM(SALETAX)-SUM(SALEBCKTAX),
  (SUM(SALECAMT)+SUM(SALECTAX))-(SUM(SALEBCKCAMT)+SUM(SALEBCKCTAX)),
  SUM(SALECAMT)-SUM(SALEBCKCAMT),
  SUM(SALECTAX)-SUM(SALEBCKCTAX),
  SUM(SALEBCKQTY),SUM(SALEBCKAMT)+SUM(SALEBCKTAX),SUM(SALEBCKAMT),SUM(SALEBCKTAX),
  SUM(SALEBCKCAMT)+SUM(SALEBCKCTAX),SUM(SALEBCKCAMT),SUM(SALEBCKCTAX)
  FROM RPT_SALDRPT_FX
  WHERE (FILDATE <= VENDDATE OR VENDDATE IS NULL)
  AND (FILDATE >= VBEGDATE OR VBEGDATE IS NULL)
  GROUP BY CLIENTKEY,PDKEY,VBEGDATE;
  COMMIT;
  
  SELECT SUM(SALEAMT) INTO VSALEAMT FROM H4TMP_SALDRPT_FX;
  IF VSALEAMT=0 THEN 
    VSALEAMT:=1;
  END IF;
  
  UPDATE H4TMP_SALDRPT_FX
  SET PROPORTION=ROUND(SALEAMT/VSALEAMT,4)*100,
  SALEMLTOTAL=SALETOTAL-SALECTOTAL,
  SALEMLTOTALRATE=ROUND((SALETOTAL-SALECTOTAL)/DECODE(SALETOTAL,0,1,SALETOTAL),4)*100,
  SALEMLAMT=SALEAMT-SALECAMT,
  SALEMLAMTRATE=ROUND((SALEAMT-SALECAMT)/DECODE(SALEAMT,0,1,SALEAMT),4)*100;
  COMMIT;
END;
</BEFORERUN>
<AFTERRUN>
</AFTERRUN>
<TABLELIST>
  <TABLEITEM>
    <TABLE>H4TMP_SALDRPT_FX</TABLE>
    <ALIAS>H4TMP_SALDRPT_FX</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>CLIENT</TABLE>
    <ALIAS>CLIENT</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>AREA</TABLE>
    <ALIAS>AREA</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>EMPLOYEEH</TABLE>
    <ALIAS>EMPLOYEEH</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>GOODSH</TABLE>
    <ALIAS>GOODSH</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
</TABLELIST>
<JOINLIST>
  <JOINITEM>
    <LEFT>AREA.CODE</LEFT>
    <OPERATOR>=*</OPERATOR>
    <RIGHT>CLIENT.AREA</RIGHT>
  </JOINITEM>
  <JOINITEM>
    <LEFT>H4TMP_SALDRPT_FX.CLIENTKEY</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>CLIENT.GID</RIGHT>
  </JOINITEM>
  <JOINITEM>
    <LEFT>EMPLOYEEH.GID</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>CLIENT.SELLER</RIGHT>
  </JOINITEM>
  <JOINITEM>
    <LEFT>GOODSH.GID</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>H4TMP_SALDRPT_FX.PDKEY</RIGHT>
  </JOINITEM>
</JOINLIST>
<COLUMNLIST>
  <FIXEDCOLUMNS>0</FIXEDCOLUMNS>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>CLIENT.CODE</COLUMN>
    <TITLE>客户代码</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>代码</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>CLIENT.NAME</COLUMN>
    <TITLE>客户名称</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>名称</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>decode(CLIENT.BUSTYPE,0,'普通客户',1,'分销客户')</COLUMN>
    <TITLE>客户业务类型</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>客户业务类型</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>AREA.CODE</COLUMN>
    <TITLE>区域代码</TITLE>
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
    <COLUMN>AREA.NAME</COLUMN>
    <TITLE>区域名称</TITLE>
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
    <COLUMN>EMPLOYEEH.NAME</COLUMN>
    <TITLE>销售员</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
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
    <COLUMN>GOODSH.CODE</COLUMN>
    <TITLE>商品代码</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>CODE1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>GOODSH.CODE2</COLUMN>
    <TITLE>商品第二代码</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>CODE2</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>GOODSH.NAME</COLUMN>
    <TITLE>商品名称</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NAME11</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4TMP_SALDRPT_FX.FILDATE</COLUMN>
    <TITLE>发生日期</TITLE>
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
    <COLUMN>H4TMP_SALDRPT_FX.SALEQTY</COLUMN>
    <TITLE>销售数量</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>SALEQTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4TMP_SALDRPT_FX.SALETOTAL</COLUMN>
    <TITLE>含税销售额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>SALETOTAL</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4TMP_SALDRPT_FX.SALECTOTAL</COLUMN>
    <TITLE>含税销售成本</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>SALECTOTAL</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>SALEMLTOTAL</COLUMN>
    <TITLE>含税毛利额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>A</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>16711680</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>SALEMLTOTALRATE</COLUMN>
    <TITLE>含税毛利率</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>B</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>16711680</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4TMP_SALDRPT_FX.SALEAMT</COLUMN>
    <TITLE>去税销售额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>SALEAMT</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4TMP_SALDRPT_FX.SALECAMT</COLUMN>
    <TITLE>去税销售成本</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>SALECAMT</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>SALEMLAMT</COLUMN>
    <TITLE>去税毛利额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>C</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>255</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>SALEMLAMTRATE</COLUMN>
    <TITLE>去税毛利率</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>D</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>255</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>H4TMP_SALDRPT_FX.PROPORTION</COLUMN>
    <TITLE>销售占比</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>PROPORTION</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
</COLUMNLIST>
<COLUMNWIDTH>
  <COLUMNWIDTHITEM>56</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>188</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>80</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>56</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>56</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>44</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>56</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>80</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>164</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>80</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>68</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>80</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>68</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>68</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>68</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>80</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>68</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>68</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>64</COLUMNWIDTHITEM>
</COLUMNWIDTH>
<GROUPLIST>
  <GROUPITEM>
    <COLUMN>CLIENT.CODE</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>CLIENT.NAME</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>decode(CLIENT.BUSTYPE,0,'普通客户',1,'分销客户')</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>AREA.CODE</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>AREA.NAME</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>EMPLOYEEH.NAME</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>GOODSH.CODE</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>GOODSH.CODE2</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>GOODSH.NAME</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>H4TMP_SALDRPT_FX.SALEQTY</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>H4TMP_SALDRPT_FX.SALETOTAL</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>H4TMP_SALDRPT_FX.SALECTOTAL</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>SALEMLTOTAL</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>SALEMLTOTALRATE</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>H4TMP_SALDRPT_FX.SALEAMT</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>H4TMP_SALDRPT_FX.SALECAMT</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>SALEMLAMT</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>SALEMLAMTRATE</COLUMN>
  </GROUPITEM>
</GROUPLIST>
<ORDERLIST>
  <ORDERITEM>
    <COLUMN>客户代码</COLUMN>
    <ORDER>ASC</ORDER>
  </ORDERITEM>
</ORDERLIST>
<CRITERIALIST>
  <WIDTHLIST>
  </WIDTHLIST>
  <CRITERIAITEM>
    <LEFT>H4TMP_SALDRPT_FX.FILDATE</LEFT>
    <OPERATOR>>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2013.04.01</RIGHTITEM>
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
    <LEFT>H4TMP_SALDRPT_FX.FILDATE</LEFT>
    <OPERATOR><=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2013.04.23</RIGHTITEM>
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
    <LEFT>CLIENT.CODE</LEFT>
    <OPERATOR>BETWEEN</OPERATOR>
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
    <LEFT>CLIENT.NAME</LEFT>
    <OPERATOR>LIKE</OPERATOR>
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
    <LEFT>AREA.CODE</LEFT>
    <OPERATOR>BETWEEN</OPERATOR>
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
    <LEFT>AREA.NAME</LEFT>
    <OPERATOR>LIKE</OPERATOR>
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
    <LEFT>EMPLOYEEH.NAME</LEFT>
    <OPERATOR>LIKE</OPERATOR>
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
    <LEFT>GOODSH.CODE</LEFT>
    <OPERATOR>BETWEEN</OPERATOR>
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
    <LEFT>GOODSH.CODE2</LEFT>
    <OPERATOR>BETWEEN</OPERATOR>
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
    <LEFT>GOODSH.NAME</LEFT>
    <OPERATOR>LIKE</OPERATOR>
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
  <CRITERIAWIDTHITEM>100</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>100</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>130</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>88</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>88</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>88</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>88</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>88</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>76</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>88</CRITERIAWIDTHITEM>
</CRITERIAWIDTH>
<SG>
  <LINE>
  </LINE>
  <LINE>
    <SGLINEITEM>条件 1：</SGLINEITEM>
    <SGLINEITEM>2013.04.01</SGLINEITEM>
    <SGLINEITEM>2013.04.23</SGLINEITEM>
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
    <SGLINEITEM>  或 2：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
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
  <DXCOLOREVENROW>14277081</DXCOLOREVENROW>
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

