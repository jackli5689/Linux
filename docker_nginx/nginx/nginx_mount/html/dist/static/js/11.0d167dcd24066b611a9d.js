webpackJsonp([11],{Uz7n:function(e,t,s){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var a=s("mvHQ"),i=s.n(a),n=s("woOf"),l=s.n(n),o=s("Dd8w"),r=s.n(o),c=s("CCVD"),d=s("bJna"),u=s("C0NF"),h=s("9Vmw"),v=s("4aFc"),_=s("LrqJ"),g=s("6Qj3"),p=s("F+NM"),m=s("vgdM"),S=s("v2mk"),C=s("mT1R"),b=s("ifoU"),f=s.n(b),y=s("BO1k"),w=s.n(y),D=s("gyMJ"),$={props:{details:{type:Object,default:function(){return{}}}},data:function(){return{show:!1,planeMap:{},OrderID:"",SegmentID:"",ChooseSeats:[],ChoosingIndex:void 0}},computed:{seatSum:function(){var e=0;return this.planeMap.SeatMap.AirSeatRows.forEach(function(t){t.SeatDetails.forEach(function(t){" "!==t.SeatStatus&&"E"!==t.SeatStatus&&"="!==t.SeatStatus&&"I"!==t.SeatStatus&&e++})}),e}},methods:{close:function(){this.show=!1},open:function(e,t){this.ChooseSeats=[],this.OrderID=e,this.SegmentID=t,this._getSeatMap()},_setSeatBackgroundImage:function(e,t){var s=!0,a=!1,i=void 0;try{for(var n,l=w()(this.ChooseSeats);!(s=(n=l.next()).done);s=!0){var o=n.value;if(e.RowNumber===o.RowNumber&&t.SeatNumber===o.SeatNumber)return"selectSeat"}}catch(e){a=!0,i=e}finally{try{!s&&l.return&&l.return()}finally{if(a)throw i}}switch(t.SeatStatus){case"=":return"";case"E":return"exit";case" ":return"";case"I":return"exit";case"*":return"chooseSeat";default:return"ordinarySeat"}},_getSeatMap:function(){var e=this,t={OrderID:this.OrderID,SegmentID:this.SegmentID};Object(D.n)(t).then(function(t){e.planeMap=t.ResultData,e.show=!0,e.planeMap.Passengers=e.planeMap.Passengers.filter(function(e){return!1===e.IsChoosedSeat&&3!==e.PassengerType}),e.ChoosingIndex=0})},_getChoosingSeat:function(e){if(e>=0&&this.planeMap.Passengers[e]){var t=this.ChooseSeats.map(function(e){return e.PassengerID}).indexOf(this.planeMap.Passengers[e].ID);return t>=0?""+this.ChooseSeats[t].RowNumber+this.ChooseSeats[t].SeatNumber:this.$t("base.Unselected")}},_select:function(e,t){if("*"===t.SeatStatus){for(var s in this.ChooseSeats)if(e.RowNumber===this.ChooseSeats[s].RowNumber&&t.SeatNumber===this.ChooseSeats[s].SeatNumber){var a=this.planeMap.Passengers.map(function(e){return e.ID}).indexOf(this.ChooseSeats[s].PassengerID);return this.planeMap.Passengers[a].IsChoosedSeat=!1,void this.ChooseSeats.splice(s,1)}this.ChooseSeats.unshift({SegmentID:this.SegmentID,PassengerID:this.planeMap.Passengers[this.ChoosingIndex].ID,RowNumber:e.RowNumber,SeatNumber:t.SeatNumber,SeatPosition:t.SeatPosition,Name:this.planeMap.Passengers[this.ChoosingIndex].Name}),this.ChoosingIndex=(this.ChoosingIndex+1)%this.planeMap.Passengers.length;var i=new f.a;this.ChooseSeats=this.ChooseSeats.filter(function(e){return!i.has(e.PassengerID)&&i.set(e.PassengerID,1)})}},_delete:function(){var e=this.ChooseSeats.map(function(e){return e.PassengerID}).indexOf(this.planeMap.Passengers[this.ChoosingIndex].ID);e>=0&&this.ChooseSeats.splice(e,1)},_gotoSubmit:function(){var e=this,t={OrderID:this.OrderID,SegmentID:this.SegmentID,ChooseSeats:this.ChooseSeats};this.noValue(i()(this.ChooseSeats))?this.$toast(this.$t("TM.PleaseChooseASeat")):Object(D.B)(t).then(function(t){!0===t.ResultData?(e.$toast(e.$t("TM.SeatSelectionSucceed")),e.close(),e.$emit("delegate")):e.$toast(e.$t("TM.TheSystemIsBusyPleaseTryAgainLater"))})}},components:{CHeader:c.a,HsScroll:u.a,HsCell1:v.a,HsButton:m.a}},I={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("transition",{attrs:{name:"slide"}},[s("div",{directives:[{name:"show",rawName:"v-show",value:e.show,expression:"show"}],staticClass:"hs-container-child"},[s("c-header",{attrs:{title:"在线选座",leftIcon1:"return.png",leftFn1:e.close}}),e._v(" "),e.planeMap&&e.planeMap.SeatMap?s("div",{staticClass:"float-top"},[s("div",{staticClass:"item"},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/flight.png')"}}),e._v(" "),s("p",[e._v(e._s(e.planeMap.SeatMap.FlightNo))])]),e._v(" "),s("div",{staticClass:"item"},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/seatQuantity.png')"}}),e._v(" "),s("p",[e._v(e._s(e.seatSum))])]),e._v(" "),s("div",{staticClass:"item"},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/aircraft.png')"}}),e._v(" "),s("p",[e._v(e._s(e.planeMap.SeatMap.PlaneType)+e._s(e.planeMap.SeatMap.CabinCode))])])]):e._e(),e._v(" "),s("hs-scroll",{ref:"tableView",staticClass:"table-view",attrs:{data:[e.planeMap]}},[e.planeMap.SeatMap&&e.planeMap.SeatMap.AirSeatRows&&e.planeMap.SeatMap.AirSeatRows[0]?s("ul",[s("img",{staticClass:"plane-image",attrs:{src:"static/image/plane-ticket/online-select-seat/plane_top.png"}}),e._v(" "),s("div",{staticClass:"cabin",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/plane_middle.png')"},attrs:{id:"cabin"}},[s("div",{staticClass:"prompt"},[s("div",{staticClass:"item"},[s("div",{staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/chooseSeat.png')"}}),e._v(" "),s("p",[e._v(e._s(e.$t("base.Optional")))])]),e._v(" "),s("div",{staticClass:"item"},[s("div",{staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/selectSeat.png')"}}),e._v(" "),s("p",[e._v(e._s(e.$t("base.Selected")))])]),e._v(" "),s("div",{staticClass:"item"},[s("div",{staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/ordinarySeat.png')"}}),e._v(" "),s("p",[e._v(e._s(e.$t("base.Occupied")))])]),e._v(" "),s("div",{staticClass:"item"},[s("div",{staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/exit.png')"}}),e._v(" "),s("p",[e._v(e._s(e.$t("base.Exit")))])])]),e._v(" "),s("div",{staticClass:"item-row",staticStyle:{"margin-bottom":"3px"}},[s("div",{staticClass:"item"}),e._v(" "),e._l(e.planeMap.SeatMap.AirSeatRows[0].SeatDetails,function(t,a){return s("div",{key:a,staticClass:"item"},[s("p",{staticClass:"rowNumber"},[e._v(e._s(t.SeatNumber))])])}),e._v(" "),e.planeMap.SeatMap.AirSeatRows[0]&&e.planeMap.SeatMap.AirSeatRows[0].SeatDetails.length<9?s("div",{staticClass:"item"}):e._e()],2),e._v(" "),e._l(e.planeMap.SeatMap.AirSeatRows,function(t,a){return s("div",{key:a,staticClass:"item-row"},[s("div",{staticClass:"item",style:{width:"calc("+100/(t.SeatDetails.length+1)+"vw - "+50/(t.SeatDetails.length+1)+"px)",height:"calc("+100/(t.SeatDetails.length+1)+"vw - "+50/(t.SeatDetails.length+1)+"px)"}},[s("p",{staticClass:"rowNumber"},[e._v(e._s(t.RowNumber))])]),e._v(" "),e._l(t.SeatDetails,function(a,i){return s("div",{key:i,staticClass:"item",style:{width:"calc("+100/(t.SeatDetails.length+1)+"vw - "+50/(t.SeatDetails.length+1)+"px)",height:"calc("+100/(t.SeatDetails.length+1)+"vw - "+50/(t.SeatDetails.length+1)+"px)"},on:{click:function(s){e._select(t,a)}}},[s("div",{directives:[{name:"show",rawName:"v-show",value:"chooseSeat"===e._setSeatBackgroundImage(t,a),expression:"_setSeatBackgroundImage(item, itemChild) === 'chooseSeat'"}],staticClass:"backImg",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/chooseSeat.png')"}}),e._v(" "),s("div",{directives:[{name:"show",rawName:"v-show",value:"selectSeat"===e._setSeatBackgroundImage(t,a),expression:"_setSeatBackgroundImage(item, itemChild) === 'selectSeat'"}],staticClass:"backImg",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/selectSeat.png')"}}),e._v(" "),s("div",{directives:[{name:"show",rawName:"v-show",value:"ordinarySeat"===e._setSeatBackgroundImage(t,a),expression:"_setSeatBackgroundImage(item, itemChild) === 'ordinarySeat'"}],staticClass:"backImg",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/ordinarySeat.png')"}}),e._v(" "),s("div",{directives:[{name:"show",rawName:"v-show",value:"exit"===e._setSeatBackgroundImage(t,a),expression:"_setSeatBackgroundImage(item, itemChild) === 'exit'"}],staticClass:"backImg",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/exit.png')"}})])}),e._v(" "),e.planeMap.SeatMap.AirSeatRows[0]&&e.planeMap.SeatMap.AirSeatRows[0].SeatDetails.length<9?s("div",{staticClass:"item",style:{width:"calc("+100/(t.SeatDetails.length+1)+"vw - "+50/(t.SeatDetails.length+1)+"px)",height:"calc("+100/(t.SeatDetails.length+1)+"vw - "+50/(t.SeatDetails.length+1)+"px)"}},[s("p",{staticClass:"rowNumber"},[e._v(e._s(t.RowNumber))])]):e._e()],2)})],2),e._v(" "),s("img",{staticClass:"plane-image",attrs:{src:"static/image/plane-ticket/online-select-seat/plane_down.png"}})]):e._e()]),e._v(" "),e.planeMap.Passengers&&e.ChoosingIndex>=0?s("div",{staticClass:"footer"},[s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell-item"},[s("p",[e._v(e._s(e.planeMap.Passengers[e.ChoosingIndex].Name))]),e._v(" "),s("div",{staticClass:"seat"},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/seat.png')"}}),e._v(" "),s("p",[e._v(e._s(e._getChoosingSeat(e.ChoosingIndex)))]),e._v(" "),e._getChoosingSeat(e.ChoosingIndex)!==e.$t("base.Unselected")?s("div",{staticClass:"delete",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/delete.png')"},on:{click:e._delete}}):e._e()])])]),e._v(" "),s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell-bar"},[s("div",{staticClass:"list"},e._l(e.planeMap.Passengers,function(t,a){return s("div",{key:a,class:[{active:a===e.ChoosingIndex},{between:a%3==2}],on:{click:function(t){e.ChoosingIndex=a}}},[s("p",[e._v(e._s(t.Name))]),e._v(" "),s("p",[e._v(e._s(e._getChoosingSeat(a)))])])})),e._v(" "),s("hs-button",{attrs:{width:"50%"},on:{click:e._gotoSubmit}},[e._v(e._s(e.$t("base.Finish")))])],1)])],1):e._e()],1)])},staticRenderFns:[]};var P=s("VU/8")($,I,!1,function(e){s("eENr")},"data-v-4ee55ff8",null).exports,T=s("gSa9"),k={data:function(){return{details:{},Segments:[],show:!1}},methods:{open:function(e,t){this.details=e,this.Segments=t,this.details.ChooseSeats=this.details.ChooseSeats.map(function(e){var s=t.filter(function(t){return t.ID===e.SegmentID})[0];return e.Segment=s,e}),this.show=!0},close:function(){this.show=!1},_showSegmentTitle:function(e){var t=this.Segments.map(function(e){return e.ID}).indexOf(e),s=this.Segments&&!this.noValue(i()(this.Segments))?this.Segments.length:0;return 1===s?this.$t("base.OneWay"):2===s&&this.Segments[0].DepartCityName===this.Segments[1].ArrivalCityName?0===t?this.$t("base.Going"):this.$t("base.Return"):this.$t("base.NoXSegment","function",t+1)}},components:{CHeader:c.a,HsButton:m.a,HsScroll:u.a,HsSection:h.a,HsCell1:v.a}},x={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("transition",{attrs:{name:"slide"}},[s("div",{directives:[{name:"show",rawName:"v-show",value:e.show,expression:"show"}],staticClass:"hs-container-child"},[s("c-header",{attrs:{title:e.$t("base.SelectionResult"),leftIcon1:"return.png",leftFn1:e.close}}),e._v(" "),s("hs-scroll",{ref:"tableView",staticClass:"table-view",attrs:{data:[e.details]}},[s("ul",[s("hs-section",e._l(e.details.ChooseSeats,function(t,a){return s("hs-cell-1",{key:a,attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell-card"},[s("div",{staticClass:"card-title"},[s("div",{staticClass:"left"},[s("div",{staticClass:"mark"},[e._v(e._s(e._showSegmentTitle(t.Segment.ID)))]),e._v(" "),s("div",{staticClass:"logo",style:{"background-image":"url("+t.Segment.AirLineLogoUrl+")"}}),e._v(" "),s("p",[e._v(e._s(t.Segment.AirLineName)),[e._v(" "),e.noValue(t.Segment.ActualCarryFlightNo)?e._e():s("span",[e._v(e._s(e.$t("base.CodeShare")))])],e._v(" "+e._s(t.Segment.FlightNo)),e.noValue(t.Segment.Plane)?e._e():[e._v(" | "+e._s(t.Segment.Plane))],e.noValue(t.Segment.Meal)?e._e():[e._v(" | "+e._s(t.Segment.Meal))]],2)])]),e._v(" "),s("div",{staticClass:"trip"},[s("div",{staticClass:"item"},[s("p",[e._v(e._s(e.beTime(t.Segment.DepartDate,"MM-dd"))+" "+e._s(e.getWeeks(e.beTime(t.Segment.DepartDate))))]),e._v(" "),s("p",[e._v(e._s(e.beTime(t.Segment.DepartDate,"hh:mm")))]),e._v(" "),s("p",[e._v(e._s(t.Segment.DepartAirportName)+e._s(t.Segment.DepartTerminal))])]),e._v(" "),s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/plane.png')"}}),e._v(" "),s("div",{staticClass:"item"},[s("p",[e._v(e._s(e.beTime(t.Segment.ArrivalDate,"MM-dd"))+" "+e._s(e.getWeeks(e.beTime(t.Segment.ArrivalDate))))]),e._v(" "),s("p",[e._v(e._s(e.beTime(t.Segment.ArrivalDate,"hh:mm"))),t.Segment.AddDays>0?s("span",[e._v("+"+e._s(t.Segment.AddDays))]):e._e()]),e._v(" "),s("p",[e._v(e._s(t.Segment.ArrivalAirportName)+e._s(t.Segment.ArrivalTerminal))])])]),e._v(" "),s("div",{staticClass:"infors"},[s("div",{staticClass:"item"},[s("p",[e._v(e._s(e.$t("base.Name")))]),e._v(" "),s("p",[e._v(e._s(e.details.Name))])]),e._v(" "),s("div",{staticClass:"item"},[s("p",[e._v(e._s(e.$t("base.CabinLevel")))]),e._v(" "),s("p",[e._v(e._s(t.Segment.Cabin))])]),e._v(" "),s("div",{staticClass:"item"},[s("p",[e._v(e._s(e.$t("base.SeatNumber")))]),e._v(" "),s("p",[e._v(e._s(t.RowNumber)+e._s(t.SeatNumber))])])])])])})),e._v(" "),s("hs-section",[s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell-rules"},[s("div",{staticClass:"title"},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/plane-ticket/online-select-seat/warning.png')"}}),e._v(" "),s("p",[e._v(e._s(e.$t("base.Precautions")))])]),e._v(" "),s("p",[e._v(e._s(e.$t("base.ImportantThisSelectionIsNotAnOnlineCheckIn")))])])])],1)],1)])],1)])},staticRenderFns:[]};var N=s("VU/8")(k,x,!1,function(e){s("rsES")},"data-v-08d80467",null).exports,M=s("DC+l"),R=s("7+uW"),O=s("NYxO"),A={beforeRouteLeave:function(e,t,s){!0===this.showExamineProcess||this.$refs.onlineSelectSeat&&!0===this.$refs.onlineSelectSeat.show||this.$refs.onlineSelectSeatResult&&!0===this.$refs.onlineSelectSeatResult.show?(this.showExamineProcess=!1,this.$refs.onlineSelectSeat&&this.$refs.onlineSelectSeat.close(),this.$refs.onlineSelectSeatResult&&this.$refs.onlineSelectSeatResult.close(),s(!1)):(this.showAlert=!1,s())},created:function(){this.noValue(this.$route.query.Id)?this.$router.replace("/planeTicket/orderList"):this.noValue(this.$route.query.Id)||this._getOrderDetails()},computed:r()({},Object(O.c)(["isMiniprogram","flightRight"]),{insurances:function(){var e=[];return this.details.Passengers.forEach(function(t){t.Insurances&&t.Insurances.map(function(e){return e.TmpID=""+e.InsuranceCategory+e.SalePrice,e}).forEach(function(t){if(t.SalePrice>=0&&t.Count>0){var s=e.map(function(e){return e.TmpID}).indexOf(t.TmpID);s<0?e.push(l()(t,{number:t.Count})):e[s].number+=t.Count}})}),e},infoIndex:function(){return this.details.VettingRecordInfos?this.details.VettingRecordInfos.map(function(e){return e.TemplateNodeProcessStatusDesc}).indexOf("进行中"):-1}}),data:function(){return{tableViewOptions:{pullDownRefresh:{threshold:50}},details:{},showDetailsDialog:!1,showExplain:!1,returnExplainDetails:{},showExamineProcess:!1,showAlert:!1,vettingContent:1,vettingMemo:"",showTravelStandard:!1}},filters:{filterPayType:function(e){switch(e){case 1:return R.a.prototype.$t("base.CompanyPayment");case 2:return R.a.prototype.$t("base.PersonalPayment");case 3:return R.a.prototype.$t("base.CompanyPayment")+"("+R.a.prototype.$t("base.Prepayments")+")";default:return R.a.prototype.$t("base.Unknown")}}},methods:r()({},Object(O.b)(["dispatchFlightRight"]),{_getFlightCabinRule:function(e){this.showExplain=!0,this.returnExplainDetails={vhtml:e}},_getOrderDetails:function(){var e=this,t={ID:this.$route.query.Id,Type:this.$route.query.isOwner?0:1};Object(D.C)(t).then(function(t){e.details=t.ResultData,e.details.Segments.forEach(function(t,s){e.$set(e.details.Segments[s],"openLowestPrice",!1)})})},_showSegmentTitle:function(e){var t=this.details.Segments&&!this.noValue(i()(this.details.Segments))?this.details.Segments.length:0;return 1===t?this.$t("base.OneWay"):2===t&&this.details.Segments[0].DepartCityName===this.details.Segments[1].ArrivalCityName?0===e?this.$t("base.Going"):this.$t("base.Return"):this.$t("base.NoXSegment","function",e+1)},_switchDetailsDialog:function(){this.showDetailsDialog?this.$refs.detailsDialog.showDetails=!1:this.showDetailsDialog=!0},_submit:function(){var e=this;this.$alert({content:this.$t("TM.AreYouSureToSubmitYourOrder"),cancelTxt:this.$t("base.Cancel"),confirmFn:function(){var t={TravelID:e.$route.query.Id};Object(D.h)(t).then(function(t){!0===t.ResultData?(e.$toast(e.$t("TM.SubmitSucceed")),setTimeout(function(){S.a.$emit("refresh")},0),e.$router.replace({name:"planeTicketOrderList",params:{TravelType:Number(e.details.TravelType)}})):e.$toast(e.$t("TM.TheSubmissionFailedPleaseTryAgainLater"))})}})},_gotoSubmitAndPay:function(){var e=this;this.$alert({content:this.$t("TM.AreYouSureToSubmitAndPayForTheOrder"),cancelTxt:this.$t("base.Cancel"),confirmFn:function(){var t={TravelID:e.$route.query.Id};Object(D.h)(t).then(function(t){!0===t.ResultData?(e._getOrderDetails(),e._gotoPay()):e.$toast(e.$t("TM.TheSubmissionFailedPleaseTryAgainLater"))})}})},_cancel:function(){var e=this;this.$alert({content:this.$t("TM.AreYouSureToCancelTheOrder"),cancelTxt:this.$t("base.Cancel"),confirmFn:function(){var t={TravelID:e.$route.query.Id};Object(D.c)(t).then(function(t){!0===t.ResultData?(e.$toast(e.$t("TM.OrderCancelled")),setTimeout(function(){S.a.$emit("refresh")},0),e.$router.replace({name:"planeTicketOrderList",params:{TravelType:Number(e.details.TravelType)}})):e.$toast(e.$t("TM.OrderCancelFailed"))})}})},_examineSubmit:function(){var e=this,t={ID:this.$route.query.Id,InstanceID:this.details.VettingRecordInfos[this.infoIndex].InstanceID,TemplateNodeID:this.details.VettingRecordInfos[this.infoIndex].TemplateNodeID,VettingContent:this.vettingContent,VettingMemo:this.vettingMemo,BusinessType:2};Object(D._66)(t).then(function(t){!0===t.ResultData&&e.$toast(e.$t("TM.ApprovalSubmitted"),{complete:function(){setTimeout(function(){S.a.$emit("refresh")},0),e.$router.replace({path:"/message/examine",query:{QuerySource:0}})}})})},_gotoPay:function(){this.$refs.Pay&&this.$refs.Pay.gotoPay({OrderBusinessType:1,OrderID:this.$route.query.Id,PayWay:3,TravelType:Number(this.details.TravelType),CallbackPathName:"planeTicketOrderList"})},_gotoRefund:function(e){this.$router.push({path:"/planeTicket/toRefund",query:{ItktID:this.$route.query.Id,PnrID:e}})},_gotoReschedule:function(e){if(2===Number(this.details.PayType))return this.dialog=this.$createDialog({type:"alert",icon:"cubeic-alert",title:this.$t("base.Tips"),content:this.$t("base.TheOrderIsForIndividualPaymentOrders")}),void this.dialog.show();this.$router.push({name:"planeTicketToReschedule",query:{ItktID:this.$route.query.Id,PnrID:e,TravelType:Number(this.details.TravelType)}})},_getTravelStandard:function(){var e=this;this.dispatchFlightRight().then(function(t){e.showTravelStandard=!0})}}),components:{CHeader:c.a,HsDialog:d.a,HsScroll:u.a,HsSection:h.a,HsCell1:v.a,HsCellSmallTitle:_.a,CReturnExplain:g.a,CExamineProcess:p.a,HsButton:m.a,HsAlert:C.a,OnlineSelectSeat:P,CTravelStandard:T.a,OnlineSelectSeatResult:N,Pay:M.a}},F={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return this.noValue(JSON.stringify(e.details))?e._e():s("div",{staticClass:"hs-container"},[s("c-header",{attrs:{title:e.$t("base.OrderDetails"),isBackNav:""}}),e._v(" "),s("hs-scroll",{staticClass:"table-view",attrs:{data:[e.details],options:e.tableViewOptions},on:{"pulling-down":e._getOrderDetails}},[s("ul",[s("hs-section",[s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"state-details"},[s("div",{staticClass:"header",attrs:{type:e.language}},[s("p",[e._v(e._s(e.details.OrderStatusDesc))]),e._v(" "),s("p",[e._v(e._s(e.details.VettingStatusDesc))]),e._v(" "),s("p",[e._v(e._s(e.details.OrderStatusDesc))])]),e._v(" "),s("p",{staticClass:"infor"},[e._v(e._s(e.$t("base.OrderNumber"))+": "+e._s(e.details.TravelID))]),e._v(" "),s("p",{staticClass:"infor"},[e._v(e._s(e.$t("base.OrderDate"))+": "+e._s(e.$t(e.beTime(e.details.OrderDate),"date",["yyyy-MM-dd","MM dd, yyyy"]))+" "+e._s(e.beTime(e.details.OrderDate,"hh:mm")))]),e._v(" "),e.$route.query.isOwner?s("div",{staticClass:"buttons"},[e.details.PageBtnInfo.IsAllowPayAndSubmit?s("hs-button",{staticClass:"button",on:{click:e._gotoSubmitAndPay}},[e._v(e._s(e.$t("base.SubmitAndPay")))]):e._e(),e._v(" "),e.details.PageBtnInfo.IsAllowPay?s("hs-button",{staticClass:"button",on:{click:e._gotoPay}},[e._v(e._s(e.$t("base.Pay")))]):e._e(),e._v(" "),e.details.PageBtnInfo.IsAllowSubmit?s("hs-button",{staticClass:"button",on:{click:e._submit}},[e._v(e._s(e.$t("base.Submit")))]):e._e(),e._v(" "),e.details.PageBtnInfo.IsAllowCancel?s("hs-button",{staticClass:"button",attrs:{type:"common"},on:{click:e._cancel}},[e._v(e._s(e.$t("base.CancelOrder")))]):e._e()],1):e._e(),e._v(" "),e.infoIndex>=0&&e.$route.query.isExamine&&1===Number(e.details.VettingStatus)?s("div",{staticClass:"buttons"},[s("hs-button",{staticClass:"button",on:{click:function(t){e.vettingContent=1,e.showAlert=!0}}},[e._v(e._s(e.$t("base.Pass")))]),e._v(" "),s("hs-button",{staticClass:"button",attrs:{type:"common"},on:{click:function(t){e.vettingContent=0,e.showAlert=!0}}},[e._v(e._s(e.$t("base.Reject")))])],1):e._e()])])],1),e._v(" "),e._l(e.details.Segments,function(t,a){return e.details.Segments&&!e.noValue(JSON.stringify(e.details.Segments))?s("hs-section",{key:a},[s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"travel-details"},[s("div",{staticClass:"time"},[s("div",{staticClass:"mark",attrs:{type:e.language}},[e._v(e._s(e._showSegmentTitle(a)))]),e._v(" "),s("p",[e._v(e._s(e.$t(e.beTime(t.DepartDate),"date",["MM月dd日","MM dd"]))+" "+e._s(e.getWeeks(e.beTime(t.DepartDate)))+" "+e._s(t.DepartCityName)+" - "+e._s(t.ArrivalCityName))])]),e._v(" "),s("div",{staticClass:"plane"},[s("div",{staticClass:"logo",style:{"background-image":"url("+t.AirLineLogoUrl+")"}}),e._v(" "),s("div",{staticClass:"details"},[s("p",[e._v("\n                  "+e._s(t.AirLineName)+"\n                  "),[e.noValue(t.ActualCarryFlightNo)?e._e():s("span",[e._v(e._s(e.$t("base.CodeShare")))])],e._v("\n                  "+e._s(t.FlightNo)+"\n                  "),e.noValue(t.Plane)?e._e():[e._v("| "+e._s(t.Plane))],e._v(" "),e.noValue(t.Meal)?e._e():[e._v("| "+e._s(t.Meal))],e._v(" "),e.noValue(t.Cabin)?e._e():[e._v("| "+e._s(t.Cabin))]],2),e._v(" "),e.noValue(t.ActualCarryFlightNo)?e._e():s("p",[e._v(e._s(e.$t("base.OperatedBy"))+" "+e._s(t.ActualCarryFlightNo))])])]),e._v(" "),s("div",{staticClass:"details"},[s("div",{staticClass:"source"},[s("p",[e._v(e._s(e.beTime(t.DepartDate,"hh:mm")))]),e._v(" "),s("p",[e._v(e._s(t.DepartAirportName)+" "+e._s(t.DepartTerminal))])]),e._v(" "),s("div",{staticClass:"to"},[t.StopOver?s("div",{staticClass:"stopOver-logo"},[s("p",[e._v(e._s(e.$t("base.By")))])]):s("div",{staticClass:"logo"}),e._v(" "),s("div",{staticClass:"dashed"}),e._v(" "),t.StopOver?s("p",{staticClass:"stopOver"},[e._v(e._s(t.StopOver.StopCity))]):e._e()]),e._v(" "),s("div",{staticClass:"destination"},[s("p",[e._v("\n                  "+e._s(e.beTime(t.ArrivalDate,"hh:mm"))+"\n                  "),t.AddDays>0?s("span",["CN"===e.language?[e._v("+"+e._s(t.AddDays)+"天")]:[e._v("+"+e._s(t.AddDays))]],2):e._e()]),e._v(" "),s("p",[e._v(e._s(t.ArrivalAirportName)+" "+e._s(t.ArrivalTerminal))])])])])]),e._v(" "),t.LowestPrice?s("hs-cell-1",{attrs:{showLogo:!1,showSeparator:!t.openLowestPrice},nativeOn:{click:function(e){t.openLowestPrice=!t.openLowestPrice}}},[s("div",{staticClass:"min-price-details-header"},[s("p",[e._v(e._s(e.$t("base.LowestPriceDetails")))]),e._v(" "),s("div",{staticStyle:{"background-image":"url('static/image/base/cell/right_arrow_gray.png')"},style:{transform:"rotate("+(t.openLowestPrice?"90deg":"-90deg")+")"}})])]):e._e(),e._v(" "),t.LowestPrice&&t.openLowestPrice?s("div",{staticClass:"min-price-details"},[s("div",[s("p",[e._v(e._s(e.$t("base.XHoursBeforeAndAfterTheLowestPrice","function",t.LowestPrice.FloorTimeRange)))]),e._v(" "),s("p",{staticClass:"price"},[e._v("￥"+e._s(t.LowestPrice.LowestPrice))])]),e._v(" "),s("div",[s("p",[e._v(e._s(e.$t("base.CheapestFlight")))]),e._v(" "),s("p",[e._v(e._s(t.LowestPrice.FlightNo))])]),e._v(" "),s("div",[s("p",[e._v(e._s(e.$t("base.ReasonForNotSelectingTheCheapestFlight")))]),e._v(" "),s("p",[e._v(e._s(t.LowestPrice.UnChoosedReason))])])]):e._e(),e._v(" "),s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"cost-details",attrs:{type:e.language}},[s("div",[t.CanChange?s("div",{on:{click:function(s){e._gotoReschedule(t.PnrID)}}},[e._v(e._s(e.$t("base.Rescheduled")))]):e._e(),e._v(" "),t.CanRefund?s("div",{on:{click:function(s){e._gotoRefund(t.PnrID)}}},[e._v(e._s(e.$t("base.Refund")))]):e._e(),e._v(" "),t.CanChooseSeat?s("div",{on:{click:function(s){e.$refs.onlineSelectSeat.open(e.details.ID,t.ID)}}},[e._v(e._s(e.$t("base.Selection")))]):e._e()]),e._v(" "),s("p",{on:{click:function(s){e._getFlightCabinRule(t.Rule)}}},[e._v(e._s(e.$t("base.TicketRestrictions"))+" >")])])])],1):e._e()}),e._v(" "),s("hs-section",e._l(e.details.Passengers,function(t,a){return s("hs-cell-1",{key:a,attrs:{showLogo:!1,showSeparator:!1}},[s("div",{staticClass:"custom-cell-people"},[s("div",{staticClass:"left",style:{opacity:0===a?1:0}},[s("p",[e._v(e._s(e.$t("base.Passenger")))])]),e._v(" "),s("div",{staticClass:"right",style:{"border-bottom-width":a===e.details.Passengers.length-1?"0px":"1px"}},[s("div",{staticClass:"name"},[s("p",[e._v(e._s(t.Name))]),e._v(" "),e.noValue(JSON.stringify(t.ChooseSeats))?e._e():s("span",{on:{click:function(s){e.$refs.onlineSelectSeatResult.open(t,e.details.Segments)}}},[e._v(e._s(e.$t("base.SeatInfo"))+" >")])]),e._v(" "),s("div",{staticClass:"others"},[s("p",[e._v(e._s(t.Credential.CredentialName)+" "+e._s(t.Credential.CredentialNo))]),e._v(" "),e._l(t.Insurances,function(t,a){return t.Count>0?s("p",{key:a,staticClass:"insure"},[e._v("\n                  "+e._s(t.InsuranceCategory)+"\n                  "),e.details.Segments&&e.details.Segments.length>1?[e._v("("+e._s(1===t.Order?e.$t("base.Going"):e.$t("base.Return"))+")")]:e._e(),e._v("\n                  x "+e._s(t.Count)+e._s(e.$t("base.Copy"))+"\n                ")],2):e._e()})],2)])])])})),e._v(" "),s("hs-section",[e.details.CustomItem&&e.details.CustomItem.Name?s("hs-cell-small-title",{attrs:{title:e.details.CustomItemName,type:"bold",value:e.details.CustomItem.Name,showLogo:!1}}):e._e(),e._v(" "),e.details.Purpose?s("hs-cell-small-title",{attrs:{title:e.$t("base.TravelPurpose"),type:"bold",value:e.details.Purpose,showLogo:!1}}):e._e(),e._v(" "),e.details.AuthorizationCode?s("hs-cell-small-title",{attrs:{title:e.$t("base.AuthorizationCode"),type:"bold",showLogo:!1},model:{value:e.details.AuthorizationCode,callback:function(t){e.$set(e.details,"AuthorizationCode",t)},expression:"details.AuthorizationCode"}}):e._e(),e._v(" "),s("hs-cell-small-title",{attrs:{title:e.$t("base.BookingSource"),type:"bold",value:e.details.BookingSourceDesc,showLogo:!1}}),e._v(" "),"CN"===e.language?[e.details.VettingRecordInfos&&e.details.VettingRecordInfos.length>0?s("hs-cell-small-title",{attrs:{title:e.$t("base.ApprovalInformation"),type:"bold"},nativeOn:{click:function(t){e.showExamineProcess=!0}}}):e._e()]:[e.details.VettingRecordInfos&&e.details.VettingRecordInfos.length>0?s("hs-cell-small-title",{attrs:{title:e.$t("base.ApprovalInformation"),type:"bold",value:e.details.VettingStatusDesc},nativeOn:{click:function(t){e.showExamineProcess=!0}}}):e._e()],e._v(" "),0===Number(e.details.TravelType)?s("hs-cell-small-title",{attrs:{title:e.$t("base.PaymentWay"),type:"bold",value:e._f("filterPayType")(e.details.PayType),showLogo:!1}}):e._e(),e._v(" "),e.details.ReasonCode?s("hs-cell-small-title",{attrs:{title:e.$t("base.ViolationOfRank"),type:"bold",value:e.details.ReasonCode,warning:!1,showLogo:!1},on:{header:e._getTravelStandard}}):e._e()],2),e._v(" "),s("hs-section",e._l(e.details.Contacts,function(t,a){return s("hs-cell-1",{key:a,attrs:{showLogo:!1,showSeparator:!1}},[s("div",{staticClass:"custom-cell-people"},[s("div",{staticClass:"left",style:{opacity:0===a?1:0}},[s("p",[e._v(e._s(e.$t("base.ContactInformation")))])]),e._v(" "),s("div",{staticClass:"right",style:{"border-bottom-width":a===e.details.Contacts.length-1?"0px":"1px"}},[s("div",{staticClass:"name"},[s("p",[e._v(e._s(t.Name))])]),e._v(" "),s("div",{staticClass:"others"},[s("p",[e._v(e._s(e.$t("base.CellphoneNumber"))+" "+e._s(t.Mobile?t.Mobile:e.$t("base.Unfilled")))]),e._v(" "),s("p",[e._v(e._s(e.$t("base.Email"))+" "+e._s(t.Email?t.Email:e.$t("base.Unfilled")))])])])])])}))],2)]),e._v(" "),s("div",{staticClass:"footer",on:{click:e._switchDetailsDialog}},[s("div",{staticClass:"price"},[s("p",[e._v(e._s(e.$t("base.TotalAmount")))]),e._v(" "),e.details.OriginBookingID&&5!==e.details.OrderStatus?e._e():s("p",[e._v("￥"+e._s(e.details.TotalPrice))])]),e._v(" "),s("div",{staticClass:"details"},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/base/cell/right_arrow_gray.png')"},style:{transform:e.showDetailsDialog?"rotate(90deg)":"rotate(-90deg)"}})])]),e._v(" "),s("hs-dialog",{ref:"detailsDialog",attrs:{height:"calc(100% - 50px)"},model:{value:e.showDetailsDialog,callback:function(t){e.showDetailsDialog=t},expression:"showDetailsDialog"}},[s("hs-scroll",{staticClass:"detailsDialog",attrs:{data:[e.details]},nativeOn:{click:function(e){e.stopPropagation()}}},[s("ul",[e.details.FeeDetails[0].ChargeInfo?s("hs-section",[e.details.FeeDetails[0].ChargeInfo.SalePrice>=0?s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"detailsDialog-custom-cell"},[s("p",[e._v(e._s(e.$t("base.AirTickets")))]),e._v(" "),s("p",[s("span",[e._v("￥"+e._s(e.details.FeeDetails[0].ChargeInfo.SalePrice))]),s("span",[e._v("x "+e._s(e.details.Passengers.length)+e._s(e.$t("base.QuantifierPeople")))])])])]):e._e(),e._v(" "),e.details.FeeDetails[0].ChargeInfo.FuelOilTax>=0?s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"detailsDialog-custom-cell"},[s("p",[e._v(e._s(e.$t("base.FuelFee")))]),e._v(" "),s("p",[s("span",[e._v("￥"+e._s(e.details.FeeDetails[0].ChargeInfo.FuelOilTax))]),s("span",[e._v("x "+e._s(e.details.Passengers.length)+e._s(e.$t("base.QuantifierPeople")))])])])]):e._e(),e._v(" "),e.details.FeeDetails[0].ChargeInfo.AirportTax>=0?s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"detailsDialog-custom-cell"},[s("p",[e._v(e._s(e.$t("base.PlaneConstructionFee")))]),e._v(" "),s("p",[s("span",[e._v("￥"+e._s(e.details.FeeDetails[0].ChargeInfo.AirportTax))]),s("span",[e._v("x "+e._s(e.details.Passengers.length)+e._s(e.$t("base.QuantifierPeople")))])])])]):e._e(),e._v(" "),e.details.FeeDetails[0].ChargeInfo.ServiceCharge>=0?s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"detailsDialog-custom-cell"},[s("p",[e._v(e._s(e.$t("base.ServiceFee")))]),e._v(" "),s("p",[s("span",[e._v("￥"+e._s(e.details.FeeDetails[0].ChargeInfo.ServiceCharge))]),s("span",[e._v("x "+e._s(e.details.Passengers.length)+e._s(e.$t("base.QuantifierPeople")))])])])]):e._e(),e._v(" "),e.details.FeeDetails[0].ChargeInfo.Rebate>0?s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"detailsDialog-custom-cell"},[s("p",[e._v(e._s(e.$t("base.FrontReturn")))]),e._v(" "),s("p",[s("span",[e._v("-￥"+e._s(e.details.FeeDetails[0].ChargeInfo.Rebate))]),s("span",[e._v("x "+e._s(e.details.Passengers.length)+e._s(e.$t("base.QuantifierPeople")))])])])]):e._e(),e._v(" "),e._l(e.insurances,function(t,a){return s("hs-cell-1",{key:a,attrs:{showLogo:!1}},[s("div",{staticClass:"detailsDialog-custom-cell"},[s("p",[e._v(e._s(t.InsuranceCategory))]),e._v(" "),s("p",[s("span",[e._v("￥"+e._s(t.SalePrice))]),s("span",[e._v("x "+e._s(t.number)+e._s(e.$t("base.Copy")))])])])])})],2):e._e(),e._v(" "),e.details.OriginBookingID&&5!==e.details.OrderStatus?s("div",{staticClass:"detailsDialog-tips"},[s("p",[e._v(e._s(e.$t("base.TheReschedulingFeeIsSubjectToTheReviewOfTheAirline")))])]):e._e()],1)])],1),e._v(" "),s("c-return-explain",{attrs:{details:e.returnExplainDetails},model:{value:e.showExplain,callback:function(t){e.showExplain=t},expression:"showExplain"}}),e._v(" "),s("c-examine-process",{attrs:{businessName:e.$t("base.Passenger"),datalist:e.details.VettingRecordInfos,passengers:e.details.Passengers},model:{value:e.showExamineProcess,callback:function(t){e.showExamineProcess=t},expression:"showExamineProcess"}}),e._v(" "),s("hs-alert",{attrs:{show:e.showAlert,title:1===e.vettingContent?e.$t("base.ApprovedPass"):e.$t("base.ApprovalRejection"),cancelBtn:"",maskClose:""},on:{"update:show":function(t){e.showAlert=t},confirm:e._examineSubmit}},[s("div",{staticClass:"hs-alert-content",attrs:{slot:"content"},slot:"content"},[s("input",{directives:[{name:"model",rawName:"v-model",value:e.vettingMemo,expression:"vettingMemo"}],attrs:{maxlength:"50",placeholder:e.$t("base.PleaseEnterAComment")},domProps:{value:e.vettingMemo},on:{input:function(t){t.target.composing||(e.vettingMemo=t.target.value)}}})])]),e._v(" "),s("online-select-seat",{ref:"onlineSelectSeat",attrs:{details:e.details},on:{delegate:e._getOrderDetails}}),e._v(" "),s("c-travel-standard",{attrs:{details:e.flightRight.FlightRank,travelPolicy:e.flightRight.TravelPolicy},model:{value:e.showTravelStandard,callback:function(t){e.showTravelStandard=t},expression:"showTravelStandard"}}),e._v(" "),s("online-select-seat-result",{ref:"onlineSelectSeatResult"}),e._v(" "),s("pay",{ref:"Pay"})],1)},staticRenderFns:[]};var L=s("VU/8")(A,F,!1,function(e){s("qjWT")},"data-v-4820223e",null);t.default=L.exports},eENr:function(e,t){},qjWT:function(e,t){},rsES:function(e,t){}});
//# sourceMappingURL=11.0d167dcd24066b611a9d.js.map