<VERSION>4.1.0</VERSION>
<SQLQUERY>
<REMARK>
[标题]

[应用背景]

[结果列描述]

[必要的查询条件]

[实现方法]

[其它]
modify on 2010.07.01 by ym
注释掉---      and (r.fildate = vdate or vdate is null)这个限制条件
</REMARK>
<BEFORERUN>
declare
vsort varchar2(200);
vgdcode varchar2(200);
vdate date;
vbegdate date;
venddate date;
vstorecode varchar2(200);
vareacode  varchar2(200);
begin
  vdate := to_date('\(1,1)','yyyy.mm.dd');
  vbegdate := to_date('\(2,1)','yyyy.mm.dd');
  venddate := to_date('\(3,1)','yyyy.mm.dd');
  vsort := trim('\(4,1)')||'%';
    
  delete from hdtmp_SalDrpt;
  commit;

  insert into hdtmp_SalDrpt(cls,orgkey,pdkey,vdrkey,brdkey,fildate,
                            saleqty,saleamt,saletax,salecamt,salectax,
                            saleqty7,saleamt7,saletax7,salecamt7,salectax7,
                            saleqty14,saleamt14,saletax14,salecamt14,salectax14,
                            saleqty30,saleamt30,saletax30,salecamt30,salectax30,
                            saleqty60,saleamt60,saletax60,salecamt60,salectax60,
                            saleqty90,saleamt90,saletax90,salecamt90,salectax90)
    select null,r.orgkey,r.pdkey,null,null,nvl(vdate,vbegdate),
           sum(r.saleqty),sum(r.saleamt),sum(r.saletax),sum(r.salecamt),sum(r.salectax),
           sum(r.saleqty7),sum(r.saleamt7),sum(r.saletax7),sum(r.salecamt7),sum(r.salectax7),
           sum(r.saleqty14),sum(r.saleamt14),sum(r.saletax14),sum(r.salecamt14),sum(r.salectax14),
           sum(r.saleqty30),sum(r.saleamt30),sum(r.saletax30),sum(r.salecamt30),sum(r.salectax30),
           sum(r.saleqty60),sum(r.saleamt60),sum(r.saletax60),sum(r.salecamt60),sum(r.salectax60),
           sum(r.saleqty90),sum(r.saleamt90),sum(r.saletax90),sum(r.salecamt90),sum(r.salectax90)
    from rpt_storesaldrpt r,goodsh g,store s
    where r.pdkey = g.gid 
      and r.orgkey = s.gid
      and r.cls in ('零售','成本调整')
      and (r.fildate = vdate or vdate is null)
      --and r.saleqty <> 0
      and (r.fildate < venddate or venddate is null)
      and (g.sort like vsort or vsort is null)
      and (r.fildate >= vbegdate or vbegdate is null)
    group by r.orgkey,r.pdkey,nvl(vdate,vbegdate);

   insert into hdtmp_SalDrpt(cls,orgkey,pdkey,vdrkey,brdkey,fildate,
                            saleqty,saleamt,saletax,salecamt,salectax)
     select null,r.snd,r.gdgid,null,null,nvl(r.fildate,vbegdate),
           sum(decode(r.cls,'零售',1,'批发',1,'成本差异',0,'成本调整',0,-1)*r.qty),sum(decode(r.cls,'零售',1,'批发',1,'成本差异',0,'成本调整',0,-1)*r.amt),
           sum(decode(r.cls,'零售',1,'批发',1,'成本差异',0,'成本调整',0,-1)*r.tax),
           sum(decode(r.cls,'零售',1,'批发',1,'成本差异',1,'成本调整',1,-1)*r.iamt),sum(decode(r.cls,'零售',1,'批发',1,'成本差异',1,'成本调整',1,-1)*r.itax)          
    from sdrpts r,goodsh g,store s
    where r.gdgid = g.gid 
      and r.snd = s.gid 
      and r.cls in ( '零售','零售退','批发','批发退','成本差异','成本调整')
      and (r.ocrdate >= trunc(sysdate))
      and (r.fildate = vdate or vdate is null)
      and (r.fildate < venddate or venddate is null)
      and (r.fildate >= vbegdate or vbegdate is null)
      and (g.sort like vsort or vsort is null)
    group by r.snd,r.gdgid,nvl(r.fildate,vbegdate); 
  
  
   commit;

end;
</BEFORERUN>
<AFTERRUN>
</AFTERRUN>
<TABLELIST>
  <TABLEITEM>
    <TABLE>STORE</TABLE>
    <ALIAS>STORE</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD>abc</INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>GOODSH</TABLE>
    <ALIAS>GOODSH</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
  <TABLEITEM>
    <TABLE>hdtmp_SalDrpt</TABLE>
    <ALIAS>hdtmp_SalDrpt</ALIAS>
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
    <TABLE>h4v_goodssort</TABLE>
    <ALIAS>h4v_goodssort</ALIAS>
    <INDEXNAME></INDEXNAME>
    <INDEXMETHOD></INDEXMETHOD>
  </TABLEITEM>
</TABLELIST>
<JOINLIST>
  <JOINITEM>
    <LEFT>hdtmp_SalDrpt.orgkey</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>STORE.GID</RIGHT>
  </JOINITEM>
  <JOINITEM>
    <LEFT>hdtmp_SalDrpt.pdkey</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>GOODSH.GID</RIGHT>
  </JOINITEM>
  <JOINITEM>
    <LEFT>AREA.CODE</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>STORE.AREA</RIGHT>
  </JOINITEM>
  <JOINITEM>
    <LEFT>hdtmp_SalDrpt.pdkey</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>h4v_goodssort.gid</RIGHT>
  </JOINITEM>
</JOINLIST>
<COLUMNLIST>
  <FIXEDCOLUMNS>0</FIXEDCOLUMNS>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>hdtmp_SalDrpt.FILDATE</COLUMN>
    <TITLE>记帐日期</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>FILDATE</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT>yyyy.mm.dd</CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>AREA.CODE</COLUMN>
    <TITLE>区域代码</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
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
    <COLUMN>AREA.NAME</COLUMN>
    <TITLE>区域名称</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>B</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>STORE.CODE</COLUMN>
    <TITLE>门店代码</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
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
    <COLUMN>STORE.NAME</COLUMN>
    <TITLE>门店名称</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>NAME</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>GOODSH.CODE</COLUMN>
    <TITLE>商品代码</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>F</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>GOODSH.NAME||'['|| GOODSH.SPEC ||']'</COLUMN>
    <TITLE>商品名称</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>G</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>'['||h4v_goodssort.ascode||']'||h4v_goodssort.asname</COLUMN>
    <TITLE>大类</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>asort</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>'['||h4v_goodssort.bscode||']'||h4v_goodssort.bsname </COLUMN>
    <TITLE>中类</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>bsort</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>'['||h4v_goodssort.cscode||']'||h4v_goodssort.csname</COLUMN>
    <TITLE>小类</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>csort</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>hdtmp_SalDrpt.saleqty</COLUMN>
    <TITLE>数量</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>I</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>hdtmp_SalDrpt.saleamt + hdtmp_SalDrpt.saletax</COLUMN>
    <TITLE>零售额</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>J</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>hdtmp_SalDrpt.salecamt + hdtmp_SalDrpt.salectax </COLUMN>
    <TITLE>成本额</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>K</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION>SUM</AGGREGATION>
    <COLUMN>(hdtmp_SalDrpt.saleamt + hdtmp_SalDrpt.saletax) - (hdtmp_SalDrpt.salecamt + hdtmp_SalDrpt.salectax)
    </COLUMN>
    <TITLE>毛利额</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION>SUM</GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>ml</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>decode((hdtmp_SalDrpt.saleamt + hdtmp_SalDrpt.saletax),0,0,((hdtmp_SalDrpt.saleamt + hdtmp_SalDrpt.saletax) - (hdtmp_SalDrpt.salecamt + hdtmp_SalDrpt.salectax))/(hdtmp_SalDrpt.saleamt + hdtmp_SalDrpt.saletax) * 100 )
    </COLUMN>
    <TITLE>毛利率</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>O</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>GOODSH.SORT</COLUMN>
    <TITLE>类别</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>FALSE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>FALSE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>L</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
  <COLUMNITEM>
    <AGGREGATION></AGGREGATION>
    <COLUMN>h4v_goodssort.bscode</COLUMN>
    <TITLE>中类代码</TITLE>
    <FIELDTYPE>0</FIELDTYPE>
    <VISIBLE>TRUE</VISIBLE>
    <GAGGREGATION></GAGGREGATION>
    <DISPLAYINNEXT>TRUE</DISPLAYINNEXT>
    <ISKEY>FALSE</ISKEY>
    <COLUMNNAME>bscode</COLUMNNAME>
    <CFILTER>FALSE</CFILTER>
    <CFONTCOLOR>0</CFONTCOLOR>
    <CDISFORMAT></CDISFORMAT>
    <CGROUPINDEX>-1</CGROUPINDEX>
  </COLUMNITEM>
</COLUMNLIST>
<COLUMNWIDTH>
  <COLUMNWIDTHITEM>122</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>130</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>88</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>142</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>119</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>124</COLUMNWIDTHITEM>
  <COLUMNWIDTHITEM>90</COLUMNWIDTHITEM>
</COLUMNWIDTH>
<GROUPLIST>
  <GROUPITEM>
    <COLUMN>'['||h4v_goodssort.ascode||']'||h4v_goodssort.asname</COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>'['||h4v_goodssort.bscode||']'||h4v_goodssort.bsname </COLUMN>
  </GROUPITEM>
  <GROUPITEM>
    <COLUMN>h4v_goodssort.bscode</COLUMN>
  </GROUPITEM>
</GROUPLIST>
<ORDERLIST>
  <ORDERITEM>
    <COLUMN>大类</COLUMN>
    <ORDER>ASC</ORDER>
  </ORDERITEM>
  <ORDERITEM>
    <COLUMN>中类</COLUMN>
    <ORDER>ASC</ORDER>
  </ORDERITEM>
</ORDERLIST>
<CRITERIALIST>
  <WIDTHLIST>
  </WIDTHLIST>
  <CRITERIAITEM>
    <LEFT>hdtmp_SalDrpt.FILDATE</LEFT>
    <OPERATOR>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2011.03.18</RIGHTITEM>
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
    <LEFT>hdtmp_SalDrpt.FILDATE</LEFT>
    <OPERATOR>>=</OPERATOR>
    <RIGHT>
      <RIGHTITEM>2011.03.18</RIGHTITEM>
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
    <LEFT>hdtmp_SalDrpt.FILDATE</LEFT>
    <OPERATOR><</OPERATOR>
    <RIGHT>
      <RIGHTITEM></RIGHTITEM>
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
    <DEFAULTVALUE></DEFAULTVALUE>
    <ISREQUIRED>FALSE</ISREQUIRED>
    <WIDTH>0</WIDTH>
  </CRITERIAITEM>
  <CRITERIAITEM>
    <LEFT>GOODSH.SORT</LEFT>
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
  <CRITERIAWIDTHITEM>122</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>124</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>103</CRITERIAWIDTHITEM>
  <CRITERIAWIDTHITEM>88</CRITERIAWIDTHITEM>
</CRITERIAWIDTH>
<SG>
  <LINE>
  </LINE>
  <LINE>
    <SGLINEITEM>条件 1：</SGLINEITEM>
    <SGLINEITEM>2011.03.18</SGLINEITEM>
    <SGLINEITEM>2011.03.18</SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
    <SGLINEITEM></SGLINEITEM>
  </LINE>
  <LINE>
    <SGLINEITEM>  或 2：</SGLINEITEM>
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
  </LINE>
  <LINE>
    <SGLINEITEM>  或 4：</SGLINEITEM>
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
  <NUMOFNEXTQRY>3</NUMOFNEXTQRY>
  <NCRITERIALIST>
    <NEXTQUERY>日期段商品销售明细.sql</NEXTQUERY>
    <NCRITERIAITEM>
      <LEFT>记帐日期等于</LEFT>
      <RIGHT>记帐日期等于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>记帐日期大于等于</LEFT>
      <RIGHT>记帐日期大于等于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>记帐日期小于</LEFT>
      <RIGHT>记帐日期小于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>类别类似于</LEFT>
      <RIGHT>中类代码</RIGHT>
    </NCRITERIAITEM>
  </NCRITERIALIST>
  <NCRITERIALIST>
    <NEXTQUERY>日期段类别销售汇总(小类).sql</NEXTQUERY>
    <NCRITERIAITEM>
      <LEFT>记帐日期等于</LEFT>
      <RIGHT>记帐日期等于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>记帐日期大于等于</LEFT>
      <RIGHT>记帐日期大于等于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>记帐日期小于</LEFT>
      <RIGHT>记帐日期小于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>类别类似于</LEFT>
      <RIGHT>中类代码</RIGHT>
    </NCRITERIAITEM>
  </NCRITERIALIST>
  <NCRITERIALIST>
    <NEXTQUERY>门店日期段类别销售汇总(中类).sql</NEXTQUERY>
    <NCRITERIAITEM>
      <LEFT>记帐日期等于</LEFT>
      <RIGHT>记帐日期等于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>记帐日期大于等于</LEFT>
      <RIGHT>记帐日期大于等于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>记帐日期小于</LEFT>
      <RIGHT>记帐日期小于</RIGHT>
    </NCRITERIAITEM>
    <NCRITERIAITEM>
      <LEFT>类别类似于</LEFT>
      <RIGHT>中类代码</RIGHT>
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
  <DXCOLOREVENROW>16777215</DXCOLOREVENROW>
  <DXFILTERNAME></DXFILTERNAME>
  <DXFILTERLIST>
  </DXFILTERLIST>
  <DXSHOWGRIDLINE>1</DXSHOWGRIDLINE>
</DXDBGRIDITEM>
</SQLQUERY>
<SQLREPORT>
<RPTTITLE>门店日期段类别销售汇总</RPTTITLE>
<RPTGROUPCOUNT>0</RPTGROUPCOUNT>
<RPTGROUPLIST>
</RPTGROUPLIST>
<RPTCOLUMNCOUNT>12</RPTCOLUMNCOUNT>
<RPTCOLUMNWIDTHLIST>
  <RPTCOLUMNWIDTHITEM>73</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>58</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>58</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>79</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>64</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>124</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>90</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>90</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>110</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>119</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>145</RPTCOLUMNWIDTHITEM>
  <RPTCOLUMNWIDTHITEM>58</RPTCOLUMNWIDTHITEM>
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

