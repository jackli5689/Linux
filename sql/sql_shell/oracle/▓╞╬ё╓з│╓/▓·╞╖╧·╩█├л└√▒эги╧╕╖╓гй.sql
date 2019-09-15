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
declare
  Fbegdate date;
  
begin

  Fbegdate := to_date('\(1,1)', 'yyyy.mm.dd');
  
  delete from tmp_test2;
  commit;
  insert into tmp_test2
    (
     char2, ----月份
     char1, --品类
     char3, --品类
     char4, --品类
     char5, --品类
     int1, ----销售数量
     Num1, ---销售金额
     Num2,---销售成本
     --Num3 ---销售毛利
     date1 ----日期
     )
  
 select substr(trunc(a.fildate, 'MM'),0,7) fildate, --月份
       b.asname,--品类
       b.bsname,--大类
       b.csname,--品类
       b.dsname,--品类
       sum(decode(a.cls, '零售', 1, '零售退', -1) * a.qty) NWeekQty,--销售数量
       sum(decode(a.cls, '零售', 1, '零售退', -1) * (a.amt + a.tax)) AMT,--销售金额
       sum(decode(a.cls,'零售',1,'批发',1,'成本差异',1,'成本调整',1,-1)*(a.iamt+a.itax))  generaliamt, --销售成本   
       Fbegdate ---日期
  from sdrpts a
  left join h4v_goodssort b
    on a.gdgid = b.gid
 where a.cls in ( '零售','零售退','批发','批发退','成本差异','成本调整')
   and a.fildate >=Fbegdate 
   and a.fildate < add_months(Fbegdate,12) 
   and b.ascode in ('10' , '11' , '12' , '13' , '14', '15' , '16' , '17' , '18' , '19')
 group by b.asname,substr(trunc(a.fildate, 'MM'),0,7),b.bsname,
       b.csname,
       b.dsname
 order by b.asname;
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
  <JOINITEM>
    <LEFT>1</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>1</RIGHT>
  </JOINITEM>
</JOINLIST>
<COLUMNLIST>
  <FIXEDCOLUMNS>0</FIXEDCOLUMNS>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.char2</COLUMN>
    <TITLE>月份</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>char2</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>0</CGROUPINDEX>
  </COLUMNITEM>
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
    <COLUMN>tmp_test2.char3</COLUMN>
    <TITLE>大类</TITLE>
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
    <TITLE>小类1</TITLE>
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
    <COLUMN>tmp_test2.char5</COLUMN>
    <TITLE>小类2</TITLE>
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
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>tmp_test2.int1</COLUMN>
    <TITLE>销售数量</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>int1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.00</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>tmp_test2.Num1</COLUMN>
    <TITLE>销售金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>Num1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.00</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>tmp_test2.Num2</COLUMN>
    <TITLE>销售成本</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>Num2</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.00</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>tmp_test2.date1</COLUMN>
    <TITLE>日期</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>date1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>tmp_test2.Num1-tmp_test2.Num2</COLUMN>
    <TITLE>销售毛利</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>clm1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.00</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>case when tmp_test2.Num1=0 then 0
else
(tmp_test2.Num1-tmp_test2.Num2)/tmp_test2.Num1
end </COLUMN>
    <TITLE>销售毛利率</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>clm2</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.00</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
</COLUMNLIST>
<COLUMNWIDTH>
  <COLUMNWIDTHITEM>150</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>116</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>112</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>105</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>104</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>85</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>98</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>64</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>66</COLUMNWIDTHITEM>
</COLUMNWIDTH>
<GROUPLIST>
  <GROUPITEM>
    <COLUMN>tmp_test2.char2</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>tmp_test2.char1</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>tmp_test2.char3</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>tmp_test2.char4</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>tmp_test2.char5</COLUMN>
  </GROUPITEM>
</GROUPLIST>
<ORDERLIST>
  <ORDERITEM>
    <COLUMN>月份</COLUMN>
    <ORDER>ASC</ORDER>
  </ORDERITEM>
</ORDERLIST>
<CRITERIALIST>
  <WIDTHLIST>
  </WIDTHLIST>
  <CRITERIAITEM>
    <LEFT>tmp_test2.date1</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2016-1-1</RIGHTITEM>
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
    <DEFAULTVALUE>2016-1-1</DEFAULTVALUE>
    <ISREQUIRED>TRUE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
</CRITERIALIST>
<CRITERIAWIDTH>
  <CRITERIAWIDTHITEM>106</CRITERIAWIDTHITEM>
</CRITERIAWIDTH>
<SG>
  <LINE>
  </LINE>
  <LINE>
    <SGLINEITEM>条件 1：</SGLINEITEM>
    <SGLINEITEM>2016-1-1</SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 2：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 3：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 4：</SGLINEITEM>
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

