<VERSION>4.1.0</VERSION>
<SQLQUERY>
<REMARK>
[标题]
 [应用背景] ：
 [结果列描述] ：
 [必要的查询条件] ：统计日期必填
 [实现方法] ：
7天出货金额（去税）=7天日平均出货金额（去税）*7
平均库存金额（去税）=平均7天日库存金额（去税）
周转天数=平均7天日库存金额（去税）/平均7天日出货金额（去税）
周转率=平均7天日出货金额（去税）*7/平均7天日库存金额（去税）
出货发生：批发、批发退、配货出、配货退
 [临时表结构]：
CREATE GLOBAL TEMPORARY TABLE h4rtmp_zbturnoverday
(
fildate date,
wrhcode varchar2(5),
wrhname varchar2(20),
sort varchar2(10),
outamt7 number(24,4),
invamt7 number(24,4),
turnoverday7 number(24,4),
turnoverrate7 number(24,4),
outamt15 number(24,4),
invamt15 number(24,4),
turnoverday15 number(24,4),
turnoverrate15 number(24,4),
outamt30 number(24,4),
invamt30 number(24,4),
turnoverday30 number(24,4),
turnoverrate30 number(24,4)
)
ON COMMIT PRESERVE ROWS;
EXEC HDCREATESYNONYM('h4rtmp_zbturnoverday')
EXEC GRANTTOQRYROLE('h4rtmp_zbturnoverday')
 [版本记录]： 20101003 + liukai
 [其它]：
</REMARK>
<BEFORERUN>
declare
  vfildate date;
  vwrh varchar2(5);
  vsort varchar2(10);
begin
  delete from h4rtmp_zbturnoverday;
  commit;
  vfildate := '\(1,1)';
  vwrh := '\(2,1)';
  vsort := '\(3,1)';
  insert into h4rtmp_zbturnoverday(fildate,wrhcode,wrhname,sort,
                                   outamt7,invamt7,turnoverday7,turnoverrate7,
                                   outamt15,invamt15,turnoverday15,turnoverrate15,
                                   outamt30,invamt30,turnoverday30,turnoverrate30)
    select fildate,w.code,w.name,substr(r.ctgkey,1,2),
           sum(r.avgoutamt7)*7,sum(r.avginvamt7),
           round(sum(r.avginvamt7)/decode(sum(r.avgoutamt7),0,9999999999,sum(r.avgoutamt7)),4),
           round(sum(r.avgoutamt7)*7/decode(sum(r.avginvamt7),0,9999999999,sum(r.avginvamt7)),4),
           sum(r.avgoutamt15)*15,sum(r.avginvamt15),
           round(sum(r.avginvamt15)/decode(sum(r.avgoutamt15),0,9999999999,sum(r.avgoutamt15)),4),
           round(sum(r.avgoutamt15)*15/decode(sum(r.avginvamt15),0,9999999999,sum(r.avginvamt15)),4),
           sum(r.avgoutamt30)*30,sum(r.avginvamt30),
           round(sum(r.avginvamt30)/decode(sum(r.avgoutamt30),0,9999999999,sum(r.avgoutamt30)),4),
           round(sum(r.avgoutamt30)*30/decode(sum(r.avginvamt30),0,9999999999,sum(r.avginvamt30)),4)
      from rpt_invturnoversrc r,warehouse w
        where r.wrhkey = w.gid and r.fildate = vfildate and w.code like vwrh||'%' and substr(r.ctgkey,1,2) like vsort||'%'
          group by fildate,w.code,w.name,substr(r.ctgkey,1,2)
            order by substr(r.ctgkey,1,2);
  commit;
end;
</BEFORERUN>
<AFTERRUN>
</AFTERRUN>
<TABLELIST>
  <TABLEITEM>
    <TABLE>h4rtmp_zbturnoverday</TABLE>
    <ALIAS>h4rtmp_zbturnoverday</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>SORT</TABLE>
    <ALIAS>SORT</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
</TABLELIST>
<JOINLIST>
  <JOINITEM>
    <LEFT>h4rtmp_zbturnoverday.sort</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>SORT.CODE</RIGHT>
  </JOINITEM>
</JOINLIST>
<COLUMNLIST>
  <FIXEDCOLUMNS>0</FIXEDCOLUMNS>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.fildate</COLUMN>
    <TITLE>统计日期</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>fildate</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.wrhcode</COLUMN>
    <TITLE>仓位</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>wrhcode</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.wrhname</COLUMN>
    <TITLE>仓位名称</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>wrhname</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.sort</COLUMN>
    <TITLE>大类</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>sort</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>'['||SORT.CODE||']'||SORT.NAME</COLUMN>
    <TITLE>商品类别</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>sort1</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.outamt7</COLUMN>
    <TITLE>7天出货金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>outamt7</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.invamt7</COLUMN>
    <TITLE>7天平均库存金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>invamt7</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.turnoverday7</COLUMN>
    <TITLE>7天周转天数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>turnoverday7</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.turnoverrate7</COLUMN>
    <TITLE>7天周转率</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>turnoverrate7</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.0000</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.outamt15</COLUMN>
    <TITLE>15天出货金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>outamt15</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.invamt15</COLUMN>
    <TITLE>15天平均库存金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>invamt15</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.turnoverday15</COLUMN>
    <TITLE>15天周转天数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>turnoverday15</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.turnoverrate15</COLUMN>
    <TITLE>15天周转率</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>turnoverrate15</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.0000</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.outamt30</COLUMN>
    <TITLE>30天出货金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>outamt30</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.invamt30</COLUMN>
    <TITLE>30天平均库存金额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>invamt30</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.turnoverday30</COLUMN>
    <TITLE>30天周转天数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>turnoverday30</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4rtmp_zbturnoverday.turnoverrate30</COLUMN>
    <TITLE>30天周转率</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>turnoverrate30</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>,0.0000</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
</COLUMNLIST>
<COLUMNWIDTH>
  <COLUMNWIDTHITEM>33</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>88</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>102</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>81</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>72</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>84</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>73</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>80</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>104</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>102</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>78</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>80</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>78</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>102</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>78</COLUMNWIDTHITEM>
</COLUMNWIDTH>
<GROUPLIST>
</GROUPLIST>
<ORDERLIST>
</ORDERLIST>
<CRITERIALIST>
  <WIDTHLIST>
  </WIDTHLIST>
  <CRITERIAITEM>
    <LEFT>h4rtmp_zbturnoverday.fildate</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2010.10.11</RIGHTITEM>
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
    <LEFT>h4rtmp_zbturnoverday.wrhcode</LEFT>
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
      <PICKNAMEITEM>#TABLE</PICKNAMEITEM>
      <PICKNAMEITEM>CODE||'-'||NAME</PICKNAMEITEM>
    </PICKNAME>
    <PICKVALUE>
      <PICKVALUEITEM>SELECT CODE,CODE||'-'||NAME FROM WAREHOUSE WHERE CODE <> '-' ORDER BY CODE</PICKVALUEITEM>
      <PICKVALUEITEM>CODE</PICKVALUEITEM>
    </PICKVALUE>
    <DEFAULTVALUE></DEFAULTVALUE>
    <ISREQUIRED>FALSE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>h4rtmp_zbturnoverday.sort</LEFT>
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
      <PICKNAMEITEM>#TABLE</PICKNAMEITEM>
      <PICKNAMEITEM>SCODE||'-'||SNAME</PICKNAMEITEM>
    </PICKNAME>
    <PICKVALUE>
      <PICKVALUEITEM>SELECT SCODE,SCODE||'-'||SNAME FROM SORTNAME WHERE ACODE = '0000' AND LENGTH(SCODE) = 2 ORDER BY SCODE</PICKVALUEITEM>
      <PICKVALUEITEM>SCODE</PICKVALUEITEM>
    </PICKVALUE>
    <DEFAULTVALUE></DEFAULTVALUE>
    <ISREQUIRED>FALSE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
</CRITERIALIST>
<CRITERIAWIDTH>
  <CRITERIAWIDTHITEM>76</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>64</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>64</CRITERIAWIDTHITEM>
</CRITERIAWIDTH>
<SG>
  <LINE>
  </LINE>
  <LINE>
    <SGLINEITEM>条件 1：</SGLINEITEM>
    <SGLINEITEM>2010.10.11</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
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
  <DXCOLORODDROW>12632256</DXCOLORODDROW>
  <DXCOLOREVENROW>15921906</DXCOLOREVENROW>
  <DXFILTERNAME></DXFILTERNAME>
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

