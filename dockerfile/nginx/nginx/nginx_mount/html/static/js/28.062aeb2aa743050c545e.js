webpackJsonp([28],{"4cfv":function(e,t,s){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var a=s("Dd8w"),i=s.n(a),r=s("CCVD"),n=s("QRZS"),o=s("C0NF"),l=s("9Vmw"),u=s("4aFc"),c=s("EqUB"),d=s("v2mk"),p=s("mT1R"),h=s("gyMJ"),_={beforeRouteEnter:function(e,t,s){s(function(e){"/"!==t.path&&"/home"!==t.path&&"/management"!==t.path||(e.selectedIndex=0,e._getDatalist())})},activated:function(){var e=this;d.a.$off("refresh"),d.a.$on("refresh",function(){e._getDatalist()})},data:function(){return{PLANE_ORDER:1,HOTEL_ORDER:2,INTL_PLANE_ORDER:6,INTL_HOTEL_ORDER:11,TRAIN_ORDER:10,tableViewOptions:{pullDownRefresh:{threshold:50},pullUpLoad:!1},selectedIndex:0,tabOptions:[this.$t("base.Pending"),this.$t("base.Approved")],datalist:[],currentPageIndex:1,currentPageSize:30,showAlert:!1,vettingObject:{ID:void 0,vettingContent:void 0,vettingMemo:"",BusinessType:void 0,InstanceID:void 0,TemplateNodeID:void 0},vettingMemo:""}},methods:{_selectTab:function(e){this.selectedIndex=e,this._getDatalist()},_getDatalist:function(){var e=this;this.currentPageIndex=1,this.tableViewOptions.pullUpLoad=!1;var t={StartDate:this.beTimeNumber(this.beTime((new Date).setMonth((new Date).getMonth()-6))),EndDate:this.beTimeNumber(this.beTime(new Date)),PageIndex:this.currentPageIndex,PageSize:this.currentPageSize,VettingStatus:this.selectedIndex+1,QuerySource:Number(this.$route.query.QuerySource)};Object(h._65)(t).then(function(t){e.datalist=t.ResultData.Schedules,t.ResultData.Schedules.length>=e.currentPageSize&&(e.tableViewOptions.pullUpLoad={threshold:50}),e.$refs.tableView&&e.$refs.tableView.forceUpdate()})},_getDatalistMore:function(){var e=this;this.currentPageIndex++;var t={StartDate:this.beTimeNumber(this.beTime((new Date).setMonth((new Date).getMonth()-6))),EndDate:this.beTimeNumber(this.beTime(new Date)),PageIndex:this.currentPageIndex,PageSize:this.currentPageSize,VettingStatus:this.selectedIndex+1,QuerySource:Number(this.$route.query.QuerySource)};Object(h._65)(t).then(function(t){e.datalist=e.datalist.concat(t.ResultData.Schedules),t.ResultData.Schedules.length<e.currentPageSize?e.tableViewOptions.pullUpLoad=!1:e.tableViewOptions.pullUpLoad={threshold:50},e.$refs.tableView&&e.$refs.tableView.forceUpdate()})},_gotoDetails:function(e){1===e.OrderBusinessType?this.$router.push({path:"/planeTicket/orderDetails",query:{Id:e.OrderID,isExamine:0===Number(this.$route.query.QuerySource),isOwner:1===Number(this.$route.query.QuerySource)}}):2===e.OrderBusinessType?this.$router.push({path:"/hotel/orderDetails",query:{OrderID:e.OrderID,isExamine:0===Number(this.$route.query.QuerySource),isOwner:1===Number(this.$route.query.QuerySource)}}):6===e.OrderBusinessType||(11===e.OrderBusinessType?this.$router.push({path:"/inter-hotel/orderDetails",query:{OrderID:e.OrderID,isExamine:0===Number(this.$route.query.QuerySource),isOwner:1===Number(this.$route.query.QuerySource)}}):10===e.OrderBusinessType&&this.$router.push({path:"/train/orderDetail",query:{Id:e.OrderID,isExamine:0===Number(this.$route.query.QuerySource),isOwner:1===Number(this.$route.query.QuerySource)}}))},_showVettingAlert:function(e,t){switch(this.vettingMemo="",this.showAlert=!0,this.vettingObject.ID=e.OrderID,this.vettingObject.vettingContent=t,this.vettingObject.InstanceID=e.InstanceId,this.vettingObject.TemplateNodeID=e.TemplateNodeId,e.OrderBusinessType){case 1:this.vettingObject.BusinessType=2;break;case 6:this.vettingObject.BusinessType=3;break;case 2:this.vettingObject.BusinessType=4;break;case 11:this.vettingObject.BusinessType=5;break;case 10:this.vettingObject.BusinessType=9;break;default:return!1}},_examineSubmit:function(){var e=this;this.vettingObject.vettingMemo=this.vettingMemo;var t=i()({},this.vettingObject);Object(h._66)(t).then(function(t){!0===t.ResultData&&(e.$toast(e.$t("TM.ApprovalSubmitted")),e._getDatalist())})}},components:{CHeader:r.a,HsTab:n.a,HsScroll:o.a,HsSection:l.a,HsCell1:u.a,HsNull:c.a,HsAlert:p.a}},v={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("div",{staticClass:"hs-container"},[s("c-header",{attrs:{title:0===Number(e.$route.query.QuerySource)?e.$t("base.MyApprovals"):e.$t("base.MyInitiations"),isBackNav:"",fixedBackPath:"/management"}}),e._v(" "),s("hs-tab",{attrs:{selectedIndex:e.selectedIndex,options:e.tabOptions},on:{select:e._selectTab}}),e._v(" "),s("hs-scroll",{ref:"tableView",staticClass:"table-view",attrs:{data:e.datalist,options:e.tableViewOptions},on:{"pulling-down":e._getDatalist,"pulling-up":e._getDatalistMore}},[e.noValue(JSON.stringify(e.datalist))?s("hs-null",{attrs:{title:e.$t("base.AllOrdersForRecentSixMonths")}}):s("ul",[e._l(e.datalist,function(t,a){return s("div",{key:a,staticClass:"custom-cell",on:{click:function(s){e._gotoDetails(t)}}},[0===a||a>0&&e.beTime(t.BookDate,"MM-dd")!==e.beTime(e.datalist[a-1].BookDate,"MM-dd")?s("div",{staticClass:"header"},[s("p",[e._v(e._s(e.$t("base.OrderDate"))+": "+e._s(e.beTime(t.BookDate,"MM-dd")))])]):e._e(),e._v(" "),s("div",{staticClass:"content"},[s("div",{staticClass:"information"},[s("div",{staticClass:"left"},[t.OrderBusinessType===e.PLANE_ORDER?s("div",{staticClass:"logo",style:{"background-image":"url('static/image/personal-center/plane.png')"}}):t.OrderBusinessType===e.INTL_PLANE_ORDER?s("div",{staticClass:"logo",style:{"background-image":"url('static/image/personal-center/InterPlane.png')"}}):t.OrderBusinessType===e.HOTEL_ORDER?s("div",{staticClass:"logo",style:{"background-image":"url('static/image/personal-center/hotel.png')"}}):t.OrderBusinessType===e.INTL_HOTEL_ORDER?s("div",{staticClass:"logo",style:{"background-image":"url('static/image/personal-center/InterHotel.png')"}}):t.OrderBusinessType===e.TRAIN_ORDER?s("div",{staticClass:"logo",style:{"background-image":"url('static/image/personal-center/train.png')"}}):e._e()]),e._v(" "),s("div",{staticClass:"details"},[t.OrderBusinessType===e.PLANE_ORDER||t.OrderBusinessType===e.INTL_PLANE_ORDER?e._l(t.Segments,function(a,i){return s("div",{key:i,staticClass:"blank"},[s("p",{staticClass:"title"},[e._v(e._s(a.DepartureCity)+" - "+e._s(a.ArrivalCity))]),e._v(" "),s("p",[e._v(e._s(e.beTime(a.DepartTime,"yyyy-MM-dd hh:mm")))]),e._v(" "),s("div",{staticClass:"row"},[s("div",{staticClass:"logo",style:{"background-image":"url('"+a.AirLineLogoUrl+"')"}}),e._v(" "),s("p",[e._v(e._s(a.AirLine))]),e._v(" "),a.Flight?s("p",[e._v(" | "+e._s(a.Flight))]):e._e()]),e._v(" "),s("p",{staticStyle:{"margin-bottom":"0px"}},[e._v(e._s(e.$t("base.FlightsPassenger"))+": "+e._s(t.Names))])])}):t.OrderBusinessType===e.HOTEL_ORDER||t.OrderBusinessType===e.INTL_HOTEL_ORDER?[s("div",{staticClass:"blank"},[s("p",{staticClass:"title"},[e._v(e._s(t.HotelOrderInfo.HotelName))]),e._v(" "),s("p",[e._v(e._s(t.HotelOrderInfo.RoomType))]),e._v(" "),s("p",[e._v(e._s(e.beTime(t.HotelOrderInfo.CheckInDate,"MM-dd"))+" 至 "+e._s(e.beTime(t.HotelOrderInfo.CheckOutDate,"MM-dd"))+"  "+e._s(t.HotelOrderInfo.NightAmount)+e._s(e.$t("base.QuantifierNight"))+"/"+e._s(t.HotelOrderInfo.RoomAmount)+e._s(e.$t("base.QuantifierHotel")))]),e._v(" "),s("p",{staticStyle:{"margin-bottom":"0px"}},[e._v(e._s(e.$t("base.Hoomer"))+": "+e._s(t.Names))])])]:t.OrderBusinessType===e.TRAIN_ORDER?e._l(t.Routes,function(a,i){return s("div",{key:i,staticClass:"blank"},[s("p",{staticClass:"title"},[e._v(e._s(a.DepartStationName)+" - "+e._s(a.ArrivalStationName))]),e._v(" "),s("p",[e._v(e._s(a.TrainCode)+"  "+e._s(e.beTime(a.DepartDate,"yyyy-MM-dd hh:mm")))]),e._v(" "),s("p",{staticStyle:{"margin-bottom":"0px"}},[e._v(e._s(e.$t("base.TrainPassenger"))+": "+e._s(t.Names))])])}):e._e()],2),e._v(" "),s("div",{staticClass:"right"},[s("p",{staticClass:"price"},[e._v("￥"+e._s(t.TotalPrice))]),e._v(" "),t.VettingStatus?s("p",{staticClass:"status"},[e._v(e._s(t.VettingStatusDesc))]):e._e()])]),e._v(" "),0===Number(e.$route.query.QuerySource)&&Number(1===t.VettingStatus)?s("div",{staticClass:"btns"},[s("p",{on:{click:function(s){s.stopPropagation(),e._showVettingAlert(t,1)}}},[e._v(e._s(e.$t("base.Pass")))]),e._v(" "),s("p",{on:{click:function(s){s.stopPropagation(),e._showVettingAlert(t,0)}}},[e._v(e._s(e.$t("base.Reject")))])]):e._e()])])}),e._v(" "),e.tableViewOptions.pullUpLoad?e._e():s("p",{staticClass:"allLoadedTxt"},[e._v(e._s(e.$t("base.AllOrdersForRecentSixMonths")))])],2)],1),e._v(" "),s("hs-alert",{attrs:{show:e.showAlert,title:1===e.vettingObject.vettingContent?e.$t("base.ApprovedPass"):e.$t("base.ApprovalRejection"),cancelBtn:"",maskClose:""},on:{"update:show":function(t){e.showAlert=t},confirm:e._examineSubmit}},[s("div",{staticClass:"hs-alert-content",attrs:{slot:"content"},slot:"content"},[s("input",{directives:[{name:"model",rawName:"v-model",value:e.vettingMemo,expression:"vettingMemo"}],attrs:{maxlength:"50",placeholder:e.$t("base.PleaseEnterAComment")},domProps:{value:e.vettingMemo},on:{input:function(t){t.target.composing||(e.vettingMemo=t.target.value)}}})])])],1)},staticRenderFns:[]};var g=s("VU/8")(_,v,!1,function(e){s("SaxF")},"data-v-a8a9f096",null);t.default=g.exports},SaxF:function(e,t){}});
//# sourceMappingURL=28.062aeb2aa743050c545e.js.map