<VERSION>4.1.0</VERSION>
<SQLQUERY>
<REMARK>
[标题]

[应用背景]
指定时间点前三个月内引进的新品情况.即搜索商品资料创建时间在指定点前三个月内的

[结果列描述]

新品引进率=新品总数/单品总数
新品库存占比=新品总库数量/单品总库存数量 （总库存：门店+配送）

新品销售占比=新品总销售额/单品总销售额

[必要的查询条件]

[实现方法]
create global temporary table H4RTMP_NEWGOODS
(
  SORTCODE  VARCHAR2(20) ,--类别代码
  SORTNAME  VARCHAR2(200) ,--类别名称
  GDGID     NUMBER(24),--商品GID
  GDCODE    VARCHAR2(50) ,--商品代码
  GDNAME    VARCHAR2(200),--商品名称
  CREATEDATE DATE,--商品创建日期
  IMPORTDATE INT,--商品引入天数
  MAXQTY    NUMBER(24,4),--限制商品总数
  ALLQTY    NUMBER(24,4),--类别总品项数
  NEWQTY    NUMBER(24,4),--新品品项数
  NEWRAT    NUMBER(24,4),--新品引进率
  ALLINV    NUMBER(24,4),--类别总库存数
  NEWINV    NUMBER(24,4),--新品总库存数
  ALLRTOTAL NUMBER(24,4),--类别销售总额
  NEWRTOTAL NUMBER(24,4)--新品销售总额
)
on commit preserve rows;

EXEC hdcreatesynonym('H4RTMP_NEWGOODS');
EXEC granttoqryrole('H4RTMP_NEWGOODS');

create global temporary table H4RTMP_NEWGOODS_1
(
  SORTCODE  VARCHAR2(20) ,
  SORTNAME  VARCHAR2(200) ,
  GDGID     NUMBER(24),
  GDCODE    VARCHAR2(50) ,
  GDNAME    VARCHAR2(200),
  CREATEDATE DATE,
  IMPORTDATE INT,
  MAXQTY    NUMBER(24,4) default 0 not null,
  ALLQTY    NUMBER(24,4) default 0 not null,
  NEWQTY    NUMBER(24,4) default 0 not null,
  NEWRAT    NUMBER(24,4) default 0 not null,
  ALLINV    NUMBER(24,4) default 0 not null,
  NEWINV    NUMBER(24,4) default 0 not null,
  ALLRTOTAL NUMBER(24,4) default 0 not null,
  NEWRTOTAL NUMBER(24,4) default 0 not null
)
on commit preserve rows;

EXEC hdcreatesynonym('H4RTMP_NEWGOODS_1');
EXEC granttoqryrole('H4RTMP_NEWGOODS_1');

create global temporary table H4RTMP_NEWGOODS_2
(
  SORTCODE  VARCHAR2(20) ,
  SORTNAME  VARCHAR2(200) ,
  GDGID     NUMBER(24),
  GDCODE    VARCHAR2(50) ,
  GDNAME    VARCHAR2(200),
  CREATEDATE DATE,
  IMPORTDATE INT,
  MAXQTY    NUMBER(24,4) default 0 not null,
  ALLQTY    NUMBER(24,4) default 0 not null,
  NEWQTY    NUMBER(24,4) default 0 not null,
  NEWRAT    NUMBER(24,4) default 0 not null,
  ALLINV    NUMBER(24,4) default 0 not null,
  NEWINV    NUMBER(24,4) default 0 not null,
  ALLRTOTAL NUMBER(24,4) default 0 not null,
  NEWRTOTAL NUMBER(24,4) default 0 not null
)
on commit preserve rows;

EXEC hdcreatesynonym('H4RTMP_NEWGOODS_2');
EXEC granttoqryrole('H4RTMP_NEWGOODS_2');


[其它]
</REMARK>
<BEFORERUN>
declare
  vDate date;
  vInDate int;
  vdiff int;
  vSortcode varchar2(100);
begin
  vDate :=TO_DATE('\(1,1)','YYYY.MM.DD');--sysdate;
  vSortcode := '\(2,1)';--null;

  --新品引进时间段定义，默认90天
  vdiff := 90;
  
  delete from H4RTMP_NEWGOODS_2;
  delete from H4RTMP_NEWGOODS_1;
  delete from H4RTMP_NEWGOODS;
  commit;
  
  --所有商品的库存情况
  insert into H4RTMP_NEWGOODS_2(GDGID,GDCODE,GDNAME,SORTCODE,CREATEDATE,IMPORTDATE,ALLINV,
                               NEWSINV ,NEWCINV )
  select g.gid,g.code,g.name,g.sort,g.createdate,vDate - trunc(g.createdate), sum(nvl(b.qty+b.dspqty+b.alcqty+b.bckqty+b.rsvqty+b.rsvalcqty,0)) Invqty,
         sum(decode(b.store,1000000,0,nvl(b.qty+b.dspqty+b.alcqty+b.bckqty+b.rsvqty+b.rsvalcqty,0))) SInvqty,
         sum(decode(b.store,1000000,nvl(b.qty+b.dspqty+b.alcqty+b.bckqty+b.rsvqty+b.rsvalcqty,0),0)) cInvqty
  from goods g,businvs b
  where g.gid = b.gdgid(+) and g.sort like vSortcode||'%'
  group by g.gid,g.code,g.name,g.sort,g.createdate;
  
  --新品销售情况
  insert into H4RTMP_NEWGOODS_2(GDGID,GDCODE,GDNAME,SORTCODE,CREATEDATE,IMPORTDATE,NEWRTOTAL,NEWSALQTY)
  select g.gid,g.code,g.name,g.sort,g.createdate,vDate - trunc(g.createdate),sum(nvl(r.saleamt90+r.saletax90,0)) Rtotal,
         sum(nvl(r.saleqty90,0)) SALQTY
  from goods g,(select * from RPT_SalDrpt where fildate = vDate)  r
  where g.gid = r.pdkey(+) and g.sort like vSortcode||'%'
    and g.createdate between vDate - vdiff and vDate+1 --商品资料的创建时间精确到时分秒 
    group by g.gid,g.code,g.name,g.sort,g.createdate;

  --大类(所有商品)库存和销售情况
  insert into H4RTMP_NEWGOODS_1(SORTCODE,SORTNAME,MAXQTY,ALLQTY,NEWQTY,ALLINV,NEWINV,ALLRTOTAL,NEWRTOTAL)
  select s.scode,s.sname,nvl(s.maxqty,0),sum(nvl(g.allqty,0)),0,sum(nvl(g.allinv,0)),0,sum(nvl(r.saletotal90,0)),0
  from sortname s,
        (select substr(sortcode,1,h4rcalc_basic.h4rcalc_sortALength) sortcode,count(distinct gdgid) allqty,sum(allinv) allinv 
          from H4RTMP_NEWGOODS_2 group by substr(sortcode,1,h4rcalc_basic.h4rcalc_sortALength)) g,
        (select substr(ctgkey,1,h4rcalc_basic.h4rcalc_sortALength) ctgkey,sum(nvl(saleamt90+saletax90,0)) saletotal90
           from rpt_ctgSalDrpt where fildate = vDate group by substr(ctgkey,1,h4rcalc_basic.h4rcalc_sortALength))  r
   where s.scode = g.sortcode(+)
   and s.scode =  r.ctgkey(+) --大类
   and length(s.scode) = h4rcalc_basic.h4rcalc_sortALength
   and s.acode = '0000' 
   group by s.scode,s.sname,nvl(s.maxqty,0) ;
   
  --小类(新商品)
  insert into H4RTMP_NEWGOODS_1(SORTCODE,SORTNAME,MAXQTY,ALLQTY,NEWQTY,ALLINV,NEWINV,ALLRTOTAL,NEWRTOTAL)
  select s.scode,s.sname,nvl(s.maxqty,0),0,count(distinct g.gdgid),0,sum(g.allinv),0,sum(g.newrtotal)
  from H4RTMP_NEWGOODS_2 g,sortname s
   where substr(g.sortcode,1,h4rcalc_basic.h4rcalc_sortALength) = s.scode --大类
   and s.acode = '0000'
   and g.createdate between vDate - vdiff and vDate+1 --商品资料的创建时间精确到时分秒 
   group by s.scode,s.sname,nvl(s.maxqty,0);   
   
  --汇总
  insert into H4RTMP_NEWGOODS(SORTCODE,SORTNAME,MAXQTY,ALLQTY,NEWQTY,ALLINV,NEWINV,ALLRTOTAL,NEWRTOTAL,CREATEDATE)   
  select SORTCODE,SORTNAME,MAXQTY,sum(ALLQTY),sum(NEWQTY),sum(ALLINV),sum(NEWINV),sum(ALLRTOTAL),sum(NEWRTOTAL),vDate
    from H4RTMP_NEWGOODS_1
    group by SORTCODE,SORTNAME,MAXQTY;
  
end;
</BEFORERUN>
<AFTERRUN>
</AFTERRUN>
<TABLELIST>
  <TABLEITEM>
    <TABLE>H4RTMP_NEWGOODS</TABLE>
    <ALIAS>H4RTMP_NEWGOODS</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
</TABLELIST>
<JOINLIST>
</JOINLIST>
<COLUMNLIST>
  <FIXEDCOLUMNS>2</FIXEDCOLUMNS>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.SORTCODE</COLUMN>
    <TITLE>类别代码</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>SORTCODE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.SORTNAME</COLUMN>
    <TITLE>类别名称</TITLE>
    <FIELDTYPE>1</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>SORTNAME</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.MAXQTY</COLUMN>
    <TITLE>限制品项数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>MAXQTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.ALLQTY</COLUMN>
    <TITLE>类别品项总数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>ALLQTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.NEWQTY</COLUMN>
    <TITLE>新品总数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NEWQTY</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>decode(H4RTMP_NEWGOODS.ALLQTY,0,0,round(H4RTMP_NEWGOODS.NEWQTY/H4RTMP_NEWGOODS.ALLQTY,4))*100</COLUMN>
    <TITLE>新品引进率(%)</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NEWRAT</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.ALLINV</COLUMN>
    <TITLE>类别总库存数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>ALLINV</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.NEWINV</COLUMN>
    <TITLE>新品总库存数</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NEWINV</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>decode(H4RTMP_NEWGOODS.ALLINV,0,0,round(H4RTMP_NEWGOODS.NEWINV/H4RTMP_NEWGOODS.ALLINV,4))*100</COLUMN>
    <TITLE>新品库存占比(%)</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NEWINVRAT</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.ALLRTOTAL</COLUMN>
    <TITLE>类别销售总额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>ALLRTOTAL</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.NEWRTOTAL</COLUMN>
    <TITLE>新品销售总额</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NEWRTOTAL</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>decode(H4RTMP_NEWGOODS.ALLRTOTAL,0,0,round(H4RTMP_NEWGOODS.NEWRTOTAL/H4RTMP_NEWGOODS.ALLRTOTAL,4))*100</COLUMN>
    <TITLE>新品销售占比(%)</TITLE>
    <FIELDTYPE>6</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NEWRTOTALRAT</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>H4RTMP_NEWGOODS.CREATEDATE</COLUMN>
    <TITLE>建档日期</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>CREATEDATE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
</COLUMNLIST>
<COLUMNWIDTH>
  <COLUMNWIDTHITEM>79</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>119</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>103</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>95</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>84</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>94</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>101</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>97</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>101</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>118</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>111</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>98</COLUMNWIDTHITEM>
</COLUMNWIDTH>
<GROUPLIST>
</GROUPLIST>
<ORDERLIST>
  <ORDERITEM>
    <COLUMN>类别代码</COLUMN>
    <ORDER>ASC</ORDER>
  </ORDERITEM>
</ORDERLIST>
<CRITERIALIST>
  <WIDTHLIST>
  </WIDTHLIST>
  <CRITERIAITEM>
    <LEFT>H4RTMP_NEWGOODS.CREATEDATE</LEFT>
    <OPERATOR><=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2010.05.20</RIGHTITEM>
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
    <LEFT>H4RTMP_NEWGOODS.SORTCODE</LEFT>
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
  <CRITERIAWIDTHITEM>138</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>171</CRITERIAWIDTHITEM>
</CRITERIAWIDTH>
<SG>
  <LINE>
  </LINE>
  <LINE>
    <SGLINEITEM>条件 1：</SGLINEITEM>
    <SGLINEITEM>2010.05.20</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 2：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 3：</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 4：</SGLINEITEM>
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
    <NEXTQUERY>新品引进查询_中类.sql</NEXTQUERY>
    <NCRITERIAITEM>
      <LEFT>建档日期小于等于</LEFT>
      <RIGHT>建档日期小于等于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>类别代码类似于</LEFT>
      <RIGHT>类别代码</RIGHT>
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
  <DXCOLORODDROW>16777215</DXCOLORODDROW>
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

