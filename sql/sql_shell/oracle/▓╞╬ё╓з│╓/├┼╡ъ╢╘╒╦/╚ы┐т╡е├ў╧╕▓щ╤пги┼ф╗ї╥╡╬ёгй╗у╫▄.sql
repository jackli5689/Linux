<VERSION>4.1.0</VERSION>
<SQLQUERY>
<REMARK>
[标题]
  入库单明细查询汇总(门店视角)
[应用背景]
  可以用于以下场景:
   1)某个商品在某段时间被哪些配货及退货单据进行了引用,此配货单必须是影响了业务库存的单据
   2)某张单据的单据明细,主要包含商品,发生额,成本额

[结果列描述]
  
[必要的查询条件]
  支持
[实现方法]
[版本]
CREATED BY fengchunliang 2010-4-25 16:10:50

[其它]
</REMARK>
<BEFORERUN>
DECLARE
  VBDATE  DATE;
  VEDATE  DATE;
  VNUM    VARCHAR2(2000);
  VSTATNAME VARCHAR2(200);
  VFILTER1 VARCHAR2(1000);
  VCLS  VARCHAR2(14);
BEGIN

  VBDATE :=TO_DATE('\(1,1)','YYYY.MM.DD');
  VEDATE :=TO_DATE('\(2,1)','YYYY.MM.DD');
  VNUM :=TRIM('\(3,1)');
  VCLS := TRIM('\(4,1)');

  DELETE FROM H4RTMP_PHMX;
  COMMIT;
    ---插入统配出数据
  INSERT INTO H4RTMP_PHMX(NUM,CLS,GDCODE,GDNAME,GDCODE2,STNAME,QTY,QTYSTR,PRICE,TOTAL,TAX,CAMT,CTAX,RTOTAL,STATNAME,FILDATE,LINE,STCODE)
    SELECT STKOUT.NUM , STKOUT.CLS , GOODSH.CODE , GOODSH.NAME , GOODSH.CODE2 , 
      STORE.NAME , STKOUTDTL.QTY , STKOUTDTL.QTYSTR , 
      STKOUTDTL.PRICE , STKOUTDTL.TOTAL , STKOUTDTL.TAX , STKOUTDTL.SCAMT , 
      STKOUTDTL.SCTAX , STKOUTDTL.CRTOTAL , MODULESTAT.STATNAME,STKOUTLOG.TIME,STKOUTDTL.LINE,STORE.CODE
    FROM STKOUT STKOUT, STKOUTLOG STKOUTLOG, STKOUTDTL STKOUTDTL, GOODSH GOODSH, MODULESTAT MODULESTAT, STORE STORE
      WHERE ((STKOUT.NUM = STKOUTDTL.NUM)
       and  (STKOUT.CLS = STKOUTDTL.CLS)
       and  (STKOUT.NUM = STKOUTLOG.NUM)
       and  (STKOUT.CLS = STKOUTLOG.CLS)
       and  (STKOUT.STAT = MODULESTAT.NO)
       and  (STKOUTDTL.GDGID = GOODSH.GID)
       and  ((STKOUT.CLS = VCLS AND VCLS IS NOT NULL) OR (STKOUT.CLS ='统配出' AND VCLS IS NULL))
       and  (STKOUT.BILLTO = STORE.GID)
       and  (STKOUTLOG.STAT IN (700,720,740,320,340))
       and  (STKOUTLOG.TIME >= VBDATE OR VBDATE IS NULL)
       and  (STKOUTLOG.TIME < VEDATE OR VEDATE IS NULL)
       and  (STKOUT.NUM LIKE VNUM||'%' OR VNUM IS NULL));
  COMMIT;
    ---插入统配出退数据
  INSERT INTO H4RTMP_PHMX(NUM,CLS,GDCODE,GDNAME,GDCODE2,STNAME,QTY,QTYSTR,PRICE,TOTAL,TAX,CAMT,CTAX,RTOTAL,STATNAME,FILDATE,LINE,STCODE)
    SELECT STKOUT.NUM , STKOUT.CLS , GOODSH.CODE , GOODSH.NAME , GOODSH.CODE2 , 
      STORE.NAME , STKOUTDTL.QTY , STKOUTDTL.QTYSTR , 
      STKOUTDTL.PRICE , STKOUTDTL.TOTAL , STKOUTDTL.TAX , STKOUTDTL.SCAMT , 
      STKOUTDTL.SCTAX , STKOUTDTL.CRTOTAL , MODULESTAT.STATNAME,STKOUTLOG.TIME,STKOUTDTL.LINE,STORE.CODE
    FROM STKOUTBCK STKOUT, STKOUTBCKLOG STKOUTLOG, STKOUTBCKDTL STKOUTDTL, GOODSH GOODSH, MODULESTAT MODULESTAT, STORE STORE
      WHERE ((STKOUT.NUM = STKOUTDTL.NUM)
       and  (STKOUT.CLS = STKOUTDTL.CLS)
       and  (STKOUT.NUM = STKOUTLOG.NUM)
       and  (STKOUT.CLS = STKOUTLOG.CLS)
       and  (STKOUT.STAT = MODULESTAT.NO)
       and  (STKOUTDTL.GDGID = GOODSH.GID)
       and  ((STKOUT.CLS = VCLS AND VCLS IS NOT NULL) OR (STKOUT.CLS ='统配出退' AND VCLS IS NULL))
       and  (STKOUT.BILLTO = STORE.GID)
       and  (STKOUTLOG.STAT IN (1000,1020,1040,320,340) )
       and  (STKOUTLOG.TIME >= VBDATE OR VBDATE IS NULL)
       and  (STKOUTLOG.TIME < VEDATE OR VEDATE IS NULL)
       and  (STKOUT.NUM LIKE VNUM||'%' OR VNUM IS NULL));
  COMMIT;
       
    ---插入统配差异数据
  INSERT INTO H4RTMP_PHMX(NUM,CLS,GDCODE,GDNAME,GDCODE2,STNAME,QTY,QTYSTR,PRICE,TOTAL,TAX,CAMT,CTAX,RTOTAL,STATNAME,FILDATE,LINE,STCODE)
  SELECT ALC.NUM, ALC.CLS, GOODSH.CODE, GOODSH.NAME, GOODSH.CODE2, 
  STORE.NAME, DTL.QTY, DTL.QTY,
  DTL.PRICE, DTL.TOTAL, DTL.TAX, DTL.SCAMT,
  DTL.SCTAX, DTL.CRTOTAL, MODULESTAT.STATNAME, LOG.TIME, DTL.LINE, STORE.CODE
  FROM ALCDIFF ALC, ALCDIFFDTL DTL, ALCDIFFLOG LOG, GOODSH GOODSH, MODULESTAT MODULESTAT, STORE STORE
  WHERE ALC.NUM = DTL.NUM
  AND ALC.CLS = DTL.CLS
  AND ALC.NUM = LOG.NUM
  AND ALC.CLS = LOG.CLS
  AND ALC.CLS = '配货差异' 
  AND ALC.STAT = MODULESTAT.NO
  AND DTL.GDGID = GOODSH.GID
  AND ALC.BILLTO = STORE.GID
  AND ((ALC.CLS = VCLS AND VCLS IS NOT NULL) OR (ALC.CLS ='配货差异' AND VCLS IS NULL))  
  AND LOG.STAT IN (400,420,440,320,340)
  AND (LOG.TIME >= VBDATE OR VBDATE IS NULL)
  AND (LOG.TIME < VEDATE OR VEDATE IS NULL)
  AND (ALC.NUM LIKE VNUM||'%' OR VNUM IS NULL);

  COMMIT;

END;
</BEFORERUN>
<AFTERRUN>
</AFTERRUN>
<TABLELIST>
  <TABLEITEM>
    <TABLE>H4RTMP_PHMX</TABLE>
    <ALIAS>H4RTMP_PHMX</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD>123</INDEXMETHOD>
  </TABLEITEM>
</TABLELIST>
<JOINLIST>
</JOINLIST>
<COLUMNLIST>
  <FIXEDCOLUMNS>3</FIXEDCOLUMNS>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>STCODE</COLUMN>
    <TITLE>门店代码</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>STCODE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>stname</COLUMN>
    <TITLE>门店名称</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>stname</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>decode(cls,'统配出',1,'统配出退',-1,'直配出',1,'直配出退',-1,1)*total</COLUMN>
    <TITLE>配货含税金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>total</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>NUM</COLUMN>
    <TITLE>单号</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NUM</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>cls</COLUMN>
    <TITLE>单据类型</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>cls</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>fildate</COLUMN>
    <TITLE>收发货操作时间</TITLE>
    <FIELDTYPE>11</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>fildate</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>decode(cls,'统配出',1,'统配出退',-1,'直配出',1,'直配出退',-1,1)*qty</COLUMN>
    <TITLE>数量</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>qty</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>decode(cls,'统配出',1,'统配出退',-1,'直配出',1,'直配出退',-1,1)*tax</COLUMN>
    <TITLE>配货税额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>tax</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>decode(cls,'统配出',1,'统配出退',-1,'直配出',1,'直配出退',-1,1)*camt</COLUMN>
    <TITLE>配货去税成本额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>camt</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>decode(cls,'统配出',1,'统配出退',-1,'直配出',1,'直配出退',-1,1)*ctax</COLUMN>
    <TITLE>配货成本税额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>ctax</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>decode(cls,'统配出',1,'统配出退',-1,'直配出',1,'直配出退',-1,1)*rtotal</COLUMN>
    <TITLE>配货零售额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>rtotal</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>statname</COLUMN>
    <TITLE>单据状态</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>statname</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
</COLUMNLIST>
<COLUMNWIDTH>
  <COLUMNWIDTHITEM>56</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>128</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>103</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>107</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>74</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>122</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>97</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>88</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>110</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>101</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>95</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>99</COLUMNWIDTHITEM>
</COLUMNWIDTH>
<GROUPLIST>
  <GROUPITEM>
    <COLUMN>STCODE</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>stname</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>NUM</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>cls</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>fildate</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>statname</COLUMN>
  </GROUPITEM>
</GROUPLIST>
<ORDERLIST>
  <ORDERITEM>
    <COLUMN>门店代码</COLUMN>
    <ORDER>ASC</ORDER>
  </ORDERITEM>
</ORDERLIST>
<CRITERIALIST>
  <WIDTHLIST>
  </WIDTHLIST>
  <CRITERIAITEM>
    <LEFT>fildate</LEFT>
    <OPERATOR>>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2011.03.01</RIGHTITEM>
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
    <ISREQUIRED>TRUE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>fildate</LEFT>
    <OPERATOR><</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2011.03.05</RIGHTITEM>
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
    <DEFAULTVALUE>今天</DEFAULTVALUE>
    <ISREQUIRED>TRUE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>NUM</LEFT>
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
    <LEFT>cls</LEFT>
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
      <PICKNAMEITEM>统配出</PICKNAMEITEM>
      <PICKNAMEITEM>统配出退</PICKNAMEITEM>
      <PICKNAMEITEM>配货差异</PICKNAMEITEM>
    </PICKNAME>
    <PICKVALUE>
      <PICKVALUEITEM>统配出</PICKVALUEITEM>
      <PICKVALUEITEM>统配出退</PICKVALUEITEM>
      <PICKVALUEITEM>配货差异</PICKVALUEITEM>
    </PICKVALUE>
    <DEFAULTVALUE></DEFAULTVALUE>
    <ISREQUIRED>FALSE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>STCODE</LEFT>
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
    <LEFT>STCODE</LEFT>
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
</CRITERIALIST>
<CRITERIAWIDTH>
  <CRITERIAWIDTHITEM>151</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>122</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>170</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>153</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>99</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>124</CRITERIAWIDTHITEM>
</CRITERIAWIDTH>
<SG>
  <LINE>
  </LINE>
  <LINE>
    <SGLINEITEM>条件 1：</SGLINEITEM>
    <SGLINEITEM>2011.03.01</SGLINEITEM>
    <SGLINEITEM>2011.03.05</SGLINEITEM>
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
  <DXLOADMETHOD>TRUE</DXLOADMETHOD>
  <DXSHOWGROUP>TRUE</DXSHOWGROUP>
  <DXSHOWFOOTER>TRUE</DXSHOWFOOTER>
  <DXSHOWSUMMARY>TRUE</DXSHOWSUMMARY>
  <DXSHOWPREVIEW>FALSE</DXSHOWPREVIEW>
  <DXSHOWFILTER>TRUE</DXSHOWFILTER>
  <DXPREVIEWFIELD></DXPREVIEWFIELD>
  <DXCOLORODDROW>16777215</DXCOLORODDROW>
  <DXCOLOREVENROW>15921906</DXCOLOREVENROW>
  <DXFILTERNAME></DXFILTERNAME>
  <DXFILTERLIST>
  </DXFILTERLIST>
  <DXSHOWGRIDLINE>1</DXSHOWGRIDLINE>
</DXDBGRIDITEM>
</SQLQUERY>
<SQLREPORT>
<RPTTITLE>入库单明细查询（配货业务）汇总</RPTTITLE>
<RPTGROUPCOUNT>0</RPTGROUPCOUNT>
<RPTGROUPLIST>
</RPTGROUPLIST>
<RPTCOLUMNCOUNT>12</RPTCOLUMNCOUNT>
<RPTCOLUMNWIDTHLIST>
  <RPTCOLUMNWIDTHITEM>56</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>128</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>103</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>107</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>74</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>122</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>54</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>88</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>110</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>101</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>95</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>99</RPTCOLUMNWIDTHITEM>
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
入库单明细查询（配货业务）汇总
</RPTREPORTLIST>
</SQLREPORT>

