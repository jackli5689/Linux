webpackJsonp([60],{NOFW:function(t,e){},veJa:function(t,e,a){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var s=a("CCVD"),i=a("QRZS"),r=a("C0NF"),n=a("9Vmw"),l=a("4aFc"),o=a("EqUB"),c=a("v2mk"),d=a("DC+l"),u=a("gyMJ"),h={beforeRouteEnter:function(t,e,a){a(function(t){"/"===e.path||"/personal/center"===e.path?(t.travelType=0,t.dataStatus=0,""===t.GuestName?t._getDatalist():t.GuestName=""):"/hotel/orderConfirm"===e.path||"/hotel/bookDetails"===e.path?(t.travelType=1===Number(t.$route.params.TravelType)?1:0,t._getDatalist()):t.datalist&&0!==t.datalist.length||t._getDatalist()})},activated:function(){1===Number(this.$route.params.TravelType)?this.travelType=1:0===Number(this.$route.params.TravelType)&&(this.travelType=0),c.a.$off("refresh"),c.a.$on("refresh",function(){this._getDatalist()}.bind(this))},watch:{travelType:function(){this._getDatalist()},GuestName:function(t){var e=this;this.timer&&clearTimeout(this.timer),this.timer=setTimeout(function(){e._getDatalist()},1e3)}},data:function(){return{tableViewOptions:{pullDownRefresh:{threshold:50},pullUpLoad:!1},datalist:[],dataStatus:0,currentPageIndex:1,currentPageSize:10,travelType:0,GuestName:""}},methods:{_getDatalist:function(){var t=this;this.datalist=[],this.currentPageIndex=1,this.tableViewOptions.pullUpLoad=!1;var e={StartDate:this.beTimeNumber(this.beTime((new Date).setMonth((new Date).getMonth()-6))),EndDate:this.beTimeNumber(this.beTime(new Date)),PageIndex:this.currentPageIndex,PageSize:this.currentPageSize,Status:this.dataStatus,TravelType:this.travelType,GuestName:this.GuestName};Object(u._10)(e).then(function(e){t.datalist=e.ResultData.Orders,e.ResultData.Orders.length>=t.currentPageSize&&(t.tableViewOptions.pullUpLoad={threshold:50}),t.$refs.tableView&&t.$refs.tableView.forceUpdate()})},_getDatalistMore:function(){var t=this;this.currentPageIndex++;var e={StartDate:this.beTimeNumber(this.beTime((new Date).setMonth((new Date).getMonth()-6))),EndDate:this.beTimeNumber(this.beTime(new Date)),PageIndex:this.currentPageIndex,PageSize:this.currentPageSize,Status:this.dataStatus,TravelType:this.travelType,GuestName:this.GuestName};Object(u._10)(e,!0).then(function(e){t.datalist=t.datalist.concat(e.ResultData.Orders),e.ResultData.Orders.length<t.currentPageSize?t.tableViewOptions.pullUpLoad=!1:t.tableViewOptions.pullUpLoad={threshold:50},t.$refs.tableView&&t.$refs.tableView.forceUpdate()})},_tabDelegate:function(t){this.dataStatus!==t&&(this.dataStatus=t,this._getDatalist())},_gotoDetails:function(t){this.$router.push({path:"/inter-hotel/orderDetails",query:{OrderID:t,isOwner:!0}})},_gotoPay:function(t){var e=this;this.$alert({content:this.$t("TM.AreYouSureToPayForThisOrder"),cancelTxt:this.$t("base.Cancel"),confirmFn:function(){e.$refs.Pay&&e.$refs.Pay.gotoPay({OrderBusinessType:11,OrderID:t.OrderID,PayWay:3,TravelType:Number(e.TravelType),CallbackPathName:"interHotelOrderList"})}})},_cancel:function(t){var e=this;this.$alert({content:this.$t("TM.AreYouSureToCancelTheOrder"),cancelTxt:this.$t("base.Cancel"),confirmFn:function(){var a={orderID:t.OrderID};Object(u._7)(a).then(function(t){!0===t.ResultData.IsSuccess?(e.$toast(e.$t("TM.OrderCancelled")),e._getDatalist()):e.$toast(e.$t("TM.OrderCancelFailed"))})}})}},components:{CHeader:s.a,HsTab:i.a,HsScroll:r.a,HsSection:n.a,HsCell1:l.a,HsNull:o.a,Pay:d.a}},p={render:function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",{staticClass:"hs-container"},[a("c-header",{attrs:{isBackNav:"",title:t.$t("base.InternationalHotelOrders"),fixedBackPath:"/personal/center"}},[a("div",{staticClass:"c-header-right",attrs:{slot:"right"},slot:"right"},[a("div",{staticClass:"travelTypeSwitch",on:{click:function(e){t.travelType=0===t.travelType?1:0}}},[a("div",{style:{transform:"translateX("+(0===t.travelType?"0px":"20px")+")"}},[a("p",[t._v(t._s(0===t.travelType?t.$t("base.B"):t.$t("base.P")))])])])])]),t._v(" "),a("div",{staticClass:"search-bar"},[a("div",{staticClass:"bar"},[a("input",{directives:[{name:"model",rawName:"v-model",value:t.GuestName,expression:"GuestName"}],attrs:{maxlength:"50",placeholder:t.$t("base.PleaseEnterTheNameOfThePersonToSearch")},domProps:{value:t.GuestName},on:{input:function(e){e.target.composing||(t.GuestName=e.target.value)}}}),t._v(" "),a("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/plane-ticket/book/search.png')"},on:{click:t._getDatalist}})])]),t._v(" "),a("hs-tab",{attrs:{options:[t.$t("base.All"),t.$t("base.PendForOperating"),t.$t("base.Operating"),t.$t("base.Finished"),t.$t("base.Closed")]},on:{select:t._tabDelegate}}),t._v(" "),a("hs-scroll",{ref:"tableView",staticClass:"table-view",attrs:{data:t.datalist,options:t.tableViewOptions},on:{"pulling-down":t._getDatalist,"pulling-up":t._getDatalistMore}},[t.noValue(JSON.stringify(t.datalist))?a("hs-null",{attrs:{title:t.$t("base.AllOrdersForRecentSixMonths")}}):a("ul",[t._l(t.datalist,function(e,s){return a("div",{key:s,staticClass:"custom-cell",on:{click:function(a){t._gotoDetails(e.OrderID)}}},[0===s||s>0&&t.beTime(e.BookDate,"MM-dd")!==t.beTime(t.datalist[s-1].BookDate,"MM-dd")?a("div",{staticClass:"header"},[a("p",[t._v("\n            "+t._s(t.$t("base.OrderDate"))+":\n            "+t._s(t.$t(t.beTime(e.BookDate),"date",t.beTime(e.BookDate,"yyyy")===t.beTime(new Date,"yyyy")?["MM-dd","MM dd"]:["yyyy-MM-dd","MM dd, yyyy"]))+"\n          ")])]):t._e(),t._v(" "),a("div",{staticClass:"content"},[a("div",{staticClass:"information"},[a("div",{staticClass:"left"},[a("div",{staticClass:"logo",style:{"background-image":"url('static/image/personal-center/InterHotel.png')"}})]),t._v(" "),a("div",{staticClass:"details"},[a("div",{staticClass:"blank"},[a("p",{staticClass:"title"},[t._v(t._s(e.HotelName))]),t._v(" "),a("p",[t._v(t._s(e.RoomType))]),t._v(" "),a("p",[t._v(t._s(t.beTime(e.CheckInDate,"MM-dd"))+" 至 "+t._s(t.beTime(e.CheckOutDate,"MM-dd"))+"  "+t._s(e.NightAmount)+t._s(t.$t("base.QuantifierNight"))+"/"+t._s(e.RoomAmount)+t._s(t.$t("base.QuantifierHotel")))]),t._v(" "),a("p",{staticStyle:{"margin-bottom":"0px"}},[t._v(t._s(t.$t("base.Roomer"))+": "+t._s(e.OrderPersonName))])])]),t._v(" "),a("div",{staticClass:"right"},[a("p",{staticClass:"price"},[t._v("￥"+t._s(e.TotalPrice))]),t._v(" "),a("p",{staticClass:"status"},[t._v(t._s(e.OrderStatusDesc))])])]),t._v(" "),a("div",{staticClass:"btns"},[e.PageBtnInfo.IsAllowPay?a("p",{on:{click:function(a){a.stopPropagation(),t._gotoPay(e)}}},[t._v(t._s(t.$t("base.Pay")))]):t._e(),t._v(" "),e.PageBtnInfo.IsAllowCancel?a("p",{on:{click:function(a){a.stopPropagation(),t._cancel(e)}}},[t._v(t._s(t.$t("base.Cancel")))]):t._e()])])])}),t._v(" "),t.tableViewOptions.pullUpLoad?t._e():a("p",{staticClass:"allLoadedTxt"},[t._v(t._s(t.$t("base.AllOrdersForRecentSixMonths")))])],2)],1),t._v(" "),a("pay",{ref:"Pay"})],1)},staticRenderFns:[]};var v=a("VU/8")(h,p,!1,function(t){a("NOFW")},"data-v-152295ee",null);e.default=v.exports}});
//# sourceMappingURL=60.bcfc96e035b82a20d0bd.js.map