webpackJsonp([5],{BvZg:function(e,t){},GTDf:function(e,t,s){"use strict";var a=s("7+uW"),i=s("yyVE"),o={props:{title:{type:String,default:a.a.prototype.$t("base.TheNetworkSignalIsPoor")}},computed:{noData:function(){return!a.a.prototype.$loading.isLoading()}},components:{HsGradientButton:i.a}},r={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("div",{staticClass:"hs-net"},[e.noData?[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/base/null/no-net.png')"}}),e._v(" "),s("p",[e._v(e._s(e.title))]),e._v(" "),s("hs-gradient-button",{staticStyle:{"margin-top":"20px"},attrs:{type:"common",title:e.$t("base.TryAgain")},on:{click:function(t){e.$emit("delegate")}}})]:e._e()],2)},staticRenderFns:[]};var l=s("VU/8")(o,r,!1,function(e){s("b4ad")},"data-v-2f73ae70",null);t.a=l.exports},Jlqw:function(e,t){},b4ad:function(e,t){},zkBw:function(e,t,s){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var a=s("BO1k"),i=s.n(a),o=s("ifoU"),r=s.n(o),l=s("woOf"),n=s.n(l),h=s("mvHQ"),c=s.n(h),d=s("Dd8w"),u=s.n(d),p=s("w8HC"),m=s("FZO4"),v=s("5Xkm"),_=s("CCVD"),f=s("SKRv"),O=s("vgdM"),C=s("4aFc"),g=s("LrqJ"),T=s("bJna"),D=s("yyVE"),b=s("GTDf"),y=s("C0NF"),R=s("9Vmw"),$=s("2lc2"),k=s("NYxO"),P={props:{show:{type:Boolean,default:!1},details:{type:Object,default:function(){return{}}}},watch:{otherReason:function(e){!this.noValue(e)&&(this.selectedIndex=void 0)}},computed:u()({},Object(k.c)(["hotelOrder"])),data:function(){return{selectedIndex:0,otherReason:""}},methods:u()({},Object(k.d)(["SET_HOTEL_ORDER"]),{_close:function(){this.$emit("update:show",!1)},_nextStep:function(){if(this.noValue(this.otherReason.trim())&&void 0===this.selectedIndex)this.$toast(this.$t("TM.PleaseSelectOrFillInTheReasonForViolatingTheTravelRank"));else if(this.otherReason.length>50)this.$toast(this.$t("TM.TheLengthOfTheViolationOfTheTravelRankCannotExceedXWords"));else{var e=JSON.parse(c()(this.hotelOrder)),t="";this.details.GuestNames&&(t=this.details.GuestNames.map(function(e){return e.Name}).join("、")),e.ViolationRankName=t,e.ViolationRankReason=void 0===this.selectedIndex?""+this.$t("base.Other")+this.otherReason:this.details.ReasonCodes[this.selectedIndex].ReasonDescription,this.SET_HOTEL_ORDER(e),this._close(),this.$emit("delegate")}}}),components:{CHeader:_.a,HsScroll:y.a,HsSection:R.a,HsCell1:C.a,HsButton:O.a}},I={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("transition",{attrs:{name:"slide"}},[e.show?s("div",{staticClass:"hs-container-child"},[s("c-header",{attrs:{title:e.$t("base.ViolationOfTravelRank"),isBackNav:""}}),e._v(" "),s("hs-scroll",{staticClass:"table-view"},[s("ul",[s("hs-section",[s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell-header"},[s("p",[e._v(e._s(e.$t("base.ThePeopleOfViolatedTravelRank"))+": "),e._l(e.details.GuestNames,function(t,a){return s("span",{key:a},[e._v(e._s(t.Name)),e.details.GuestNames&&e.details.GuestNames.length>1?[e._v("、")]:e._e()],2)})],2),e._v(" "),s("p",[e._v(e._s(e.$t("base.PleaseChooseTheReason"))+":")])])])],1),e._v(" "),s("hs-section",[e._l(e.details.ReasonCodes,function(t,a){return s("hs-cell-1",{key:a,attrs:{value:t.ReasonDescription,logoName:"select.png",showLogo:e.selectedIndex===a},nativeOn:{click:function(t){e.selectedIndex=a}}})}),e._v(" "),e.details.IsDisplayOtherItem||!e.details.ReasonCodes||0===e.details.ReasonCodes.length?s("hs-cell-1",{attrs:{logoName:"select.png",showLogo:void 0===e.selectedIndex},nativeOn:{click:function(t){e.selectedIndex=void 0}}},[s("div",{staticClass:"other-reason",style:{width:void 0===e.selectedIndex?"calc(100% - 30px)":"100%"}},[s("textarea",{directives:[{name:"model",rawName:"v-model",value:e.otherReason,expression:"otherReason"}],attrs:{placeholder:e.$t("base.OtherReasons")},domProps:{value:e.otherReason},on:{input:function(t){t.target.composing||(e.otherReason=t.target.value)}}})])]):e._e()],2)],1)]),e._v(" "),s("div",{staticClass:"footer"},[s("hs-button",{attrs:{width:"80%",height:"40px"},on:{click:e._nextStep}},[e._v(e._s(e.$t("base.NextStep")))])],1)],1):e._e()])},staticRenderFns:[]};var N=s("VU/8")(P,I,!1,function(e){s("BvZg")},"data-v-732028be",null).exports,S=s("7+uW"),w=s("gyMJ"),E={text:S.a.prototype.$t("base.CompanyPayment"),value:1},A={text:S.a.prototype.$t("base.PersonalPayment"),value:2},H={text:S.a.prototype.$t("base.CompanyPayment")+"("+S.a.prototype.$t("base.Prepayments")+")",value:3},x={beforeRouteEnter:function(e,t,s){s(function(e){"/hotel/inforDetails"!==t.path?s(!1):s()})},beforeRouteLeave:function(e,t,s){this.$refs.CPassenger&&this.$refs.CPassenger.show?(this.$refs.CPassenger.close(),s(!1)):this.$refs.PassengerDetails&&this.$refs.PassengerDetails.show?(this.$refs.PassengerDetails.close(),s(!1)):(this.showViolationRank=!1,this.showCCustomItem=!1,this.showCContacts=!1,s())},created:function(){this.noValue(this.hotelOrder.TravelType)?this.$router.replace("/home"):(this._resetContentInTheHotelOrder(),this._getDetails(),this._initArrivalTimeItems())},computed:u()({},Object(k.c)(["hotelOrder"]),{hotel:function(){return this.$route.params.hotel},room:function(){return this.$route.params.room},ratePlan:function(){return this.$route.params.ratePlan},purpose:{get:function(){return this.hotelOrder.Purpose},set:function(e){var t=JSON.parse(c()(this.hotelOrder));t.Purpose=e,this.SET_HOTEL_ORDER(t)}},authorizationCode:{get:function(){return this.hotelOrder.AuthorizationCode},set:function(e){var t=JSON.parse(c()(this.hotelOrder));t.AuthorizationCode=e,this.SET_HOTEL_ORDER(t)}},specificRequirements:{get:function(){return this.hotelOrder.SpecificRequirements},set:function(e){var t=JSON.parse(c()(this.hotelOrder));t.SpecificRequirements=e,this.SET_HOTEL_ORDER(t)}}}),watch:{showArrivalTimeDialog:function(e){e&&this._initArrivalTimeItems()}},filters:{filterPayType:function(e){switch(e){case 1:return S.a.prototype.$t("base.CompanyPayment");case 2:return S.a.prototype.$t("base.PersonalPayment");case 3:return S.a.prototype.$t("base.CompanyPayment")+"("+S.a.prototype.$t("base.Prepayments")+")";default:return S.a.prototype.$t("base.Unknown")}}},data:function(){return{details:{},showDetailsDialog:!1,showRoomAmount:!0,showArrivalTimeDialog:!1,arrivalTimeItems:[],showCCustomItem:!1,showCContacts:!1,contactDetails:{},showViolationRank:!1,violationRankDetails:{},editingPassenger:{}}},methods:u()({},Object(k.d)(["SET_HOTEL_ORDER"]),{_getDetails:function(){var e=this,t={HotelID:this.hotelOrder.HotelID,CheckInDate:this.beTimeNumber(this.hotelOrder.CheckInDate),CheckOutDate:this.beTimeNumber(this.hotelOrder.CheckOutDate),RoomID:this.hotelOrder.RoomID,RatePlanID:this.hotelOrder.RatePlanID,TravelType:this.hotelOrder.TravelType,OrderType:this.hotelOrder.OrderType};Object(w.O)(t).then(function(t){if(e.details=t.ResultData,!e.noValue(c()(e.details.DefaultContacts))){var s=JSON.parse(c()(e.hotelOrder));s.Contacts=[n()(e.details.DefaultContact,{openDelete:!1})],e.SET_HOTEL_ORDER(s)}e._creatPayTypePicker(e.details.PayTypes),e._creatApproversPicker(e.details.Approvers),e._setRoomAmount(e.hotelOrder.RoomAmount)})},_initArrivalTimeItems:function(){var e=this.beTime(new Date),t=this.beTime(new Date,"hh:mm"),s=e===this.hotelOrder.CheckInDate,a=["14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","23:59",""+this.$t("base.Tomorrow","function",1),""+this.$t("base.Tomorrow","function",2),""+this.$t("base.Tomorrow","function",3),""+this.$t("base.Tomorrow","function",4),""+this.$t("base.Tomorrow","function",5),""+this.$t("base.Tomorrow","function",6)];s&&(a=a.filter(function(e){return t<e})),this.arrivalTimeItems=a,a[0]>this.hotelOrder.ArrivalTime&&this._selectArrivalTimeItem(a[0])},_creatApproversPicker:function(e){var t=[];e&&e.forEach(function(e){t.push({text:e.Name,value:e.ID})}),this.picker=this.$createPicker({title:this.$t("base.SelectApprover"),data:[t],cancelTxt:this.$t("base.Cancel"),confirmTxt:this.$t("base.Confirm"),onSelect:this._selectApproversPickerHandle})},_selectApproversPickerHandle:function(e,t,s){var a=JSON.parse(c()(this.hotelOrder));a.AppointVettingPersonID=e[0],a.AppointVettingPersonName=s[0],this.SET_HOTEL_ORDER(a)},_creatPayTypePicker:function(e){var t=[];1===Number(this.hotelOrder.TravelType)?t=[A]:e&&e.forEach(function(e){1===e?t.push(E):2===e?t.push(A):3===e&&t.push(H)});var s=JSON.parse(c()(this.hotelOrder));s.PayType=t[0]?t[0].value:null,this.SET_HOTEL_ORDER(s),this.payTypePicker=this.$createPicker({title:this.$t("base.PaymentWay"),data:[t],cancelTxt:this.$t("base.Cancel"),confirmTxt:this.$t("base.Confirm"),onSelect:this._payTypePickerSelectHandle})},_payTypePickerSelectHandle:function(e,t,s){var a=JSON.parse(c()(this.hotelOrder));a.PayType=e[0],this.SET_HOTEL_ORDER(a)},_switchDetailsDialog:function(){var e=this;this.showDetailsDialog?this.$refs.detailsDialog.showDetails=!1:(this.showDetailsDialog=!0,setTimeout(function(){var t=e.$refs.detailsDialog.$children[0].scroll;t.wrapperHeight<t.scrollerHeight?e.$refs["show-more"].style.opacity=1:e.$refs["show-more"].style.opacity=0},400))},_setRoomAmount:function(e){var t=this,s=JSON.parse(c()(this.hotelOrder));s.RoomAmount=e,this.SET_HOTEL_ORDER(s);var a={HotelID:this.hotelOrder.HotelID,CheckInDate:this.beTimeNumber(this.hotelOrder.CheckInDate),CheckOutDate:this.beTimeNumber(this.hotelOrder.CheckOutDate),RoomID:this.hotelOrder.RoomID,RatePlanID:this.hotelOrder.RatePlanID,RoomAmount:this.hotelOrder.RoomAmount,TravelType:this.hotelOrder.TravelType,OrderType:this.hotelOrder.OrderType};Object(w.Z)(a).then(function(e){t.details.ChargeInfo=e.ResultData})},_delegateWithConfirm:function(e){var t=JSON.parse(c()(this.hotelOrder));t.Guests=e,this.SET_HOTEL_ORDER(t)},_setPassengerOpenDelete:function(e,t){var s=JSON.parse(c()(this.hotelOrder));s.Guests[t].openDelete=e,this.SET_HOTEL_ORDER(s)},_gotoPassengerDetails:function(e){this.hotelOrder.Guests[e].openDelete?this._setPassengerOpenDelete(!1,e):(this.editingPassenger=JSON.parse(c()(this.hotelOrder.Guests[e])),this.$set(this.editingPassenger,"index",e),this.$refs.PassengerDetails.open())},_deletePassenger:function(e){var t=JSON.parse(c()(this.hotelOrder));t.Guests.splice(e,1),this.SET_HOTEL_ORDER(t)},_delegateWithPassengerDetails:function(e){var t=JSON.parse(c()(this.hotelOrder));t.Guests.splice(e.index,1,e),this.SET_HOTEL_ORDER(t)},_selectArrivalTimeItem:function(e){var t=JSON.parse(c()(this.hotelOrder));t.ArrivalTime=e,this.SET_HOTEL_ORDER(t)},_delegateWithCustomItem:function(e){var t=JSON.parse(c()(this.hotelOrder));t.CustomItem=e,this.SET_HOTEL_ORDER(t)},_delegateWithContacts:function(e){var t=JSON.parse(c()(this.hotelOrder));t.Contacts.splice(e.index,1,n()(e,{openDelete:!1})),this.SET_HOTEL_ORDER(t)},_setContactsOpenDelete:function(e,t){var s=JSON.parse(c()(this.hotelOrder));s.Contacts[t].openDelete=e,this.SET_HOTEL_ORDER(s)},_gotoContactsDetails:function(e){this.hotelOrder.Contacts[e].openDelete?this._setContactsOpenDelete(!1,e):(this.contactDetails=n()(JSON.parse(c()(this.hotelOrder.Contacts[e])),{index:e}),this.showCContacts=!0)},_deleteContact:function(e){var t=JSON.parse(c()(this.hotelOrder));t.Contacts.splice(e,1),this.SET_HOTEL_ORDER(t)},_delegateWithFrequentContacts:function(e){var t=JSON.parse(c()(this.hotelOrder));t.Contacts=e,this.SET_HOTEL_ORDER(t)},_scrollStart:function(){this.$refs["show-more"].style.opacity=0},_gotoConfirm:function(){if(this.noValue(c()(this.details)))return this.$toast(this.$t("TM.TheSysteIsBusyPleaseReOperate")),void this.$router.replace("/home");if(0!==this.hotelOrder.Guests.length)if(this.hotelOrder.Guests.length<this.hotelOrder.RoomAmount)this.$toast(this.$t("TM.ChooseAtLeastXPeople","function",this.hotelOrder.RoomAmount));else if(this.details.IsRequiredCustomItem&&this.noValue(c()(this.hotelOrder.CustomItem)))this.$toast(this.$t("TM.PleaseSelect","function",this.details.CustomItemName));else if(0!==this.hotelOrder.Contacts.length)if(this.details.IsRequiredPurpose&&this.noValue(this.hotelOrder.Purpose))this.$toast(this.$t("TM.PleaseFill","function",this.$t("base.Purpose")));else if(3===this.details.VettingType&&this.details.EnableVetting&&this.noValue(this.hotelOrder.AppointVettingPersonName))this.$toast(this.$t("TM.PleaseSelect","function",this.$t("base.Approver")));else if(this.details.IsRequiredAuthorizationCode&&this.noValue(this.hotelOrder.AuthorizationCode))this.$toast(this.$t("TM.PleaseFill","function",this.$t("base.AuthorizationCode")));else if(this.noValue(this.hotelOrder.PayType))this.$toast(this.$t("TM.PleaseSelect","function",this.$t("base.PaymentWay")));else{var e=!0,t=!1,s=void 0;try{for(var a,o=i()(this.hotelOrder.Contacts);!(e=(a=o.next()).done);e=!0){var l=a.value;if(this.noValue(l.Mobile))return void this.$toast(this.$t("TM.PleaseFillX","function",{name:l.Name,thing:this.$t("base.CellphoneNumber")}));if(this.noValue(l.Email)&&(l.IsSendBookEmail||l.IsSendIssuedEmail||l.IsSendConfirmEmail))return void this.$toast(this.$t("TM.PleaseFillX","function",{name:l.Name,thing:this.$t("base.Email")}))}}catch(e){t=!0,s=e}finally{try{!e&&o.return&&o.return()}finally{if(t)throw s}}var n=new r.a;if(this.hotelOrder.Contacts.filter(function(e){return!n.has(e.Mobile)&&n.set(e.Mobile,1)}).length<this.hotelOrder.Contacts.length)this.$toast(this.$t("TM.ThereMustBeNoContactWithTheSamePhoneNumber"));else{var h=JSON.parse(c()(this.hotelOrder));h.Guests.forEach(function(e,t){h.Guests[t].Name=0===e.DefaultNameType?e.ChName:e.LastName+" "+e.FirstName}),this.SET_HOTEL_ORDER(h),0===Number(this.hotelOrder.TravelType)?this._checkVetting():this._nextStep()}}else this.$toast(this.$t("TM.PleaseSelect","function",this.$t("base.Contacts")));else this.$toast(this.$t("TM.PleaseSelect","function",this.$t("base.Roomer")))},_checkVetting:function(){var e=this,t={HotelID:this.hotelOrder.HotelID,CheckInDate:this.beTimeNumber(this.hotelOrder.CheckInDate),CheckOutDate:this.beTimeNumber(this.hotelOrder.CheckOutDate),RoomID:this.hotelOrder.RoomID,RatePlanID:this.hotelOrder.RatePlanID,CheckGuests:this.hotelOrder.Guests,CustomItem:this.hotelOrder.CustomItem,AppointVettingPersonID:this.hotelOrder.AppointVettingPersonID,AppointVettingPersonName:this.hotelOrder.AppointVettingPersonName,PayType:this.hotelOrder.PayType,TravelType:Number(this.hotelOrder.TravelType)};Object(w.N)(t).then(function(t){if(!0===t.ResultData.IsNeedVetting&&!1===t.ResultData.IsSameVetting)e.$alert({content:e.$t("base.IfTheApproverIsInconsistent")});else{if(!0===t.ResultData.IsNeedVetting){var s=JSON.parse(c()(e.hotelOrder));s.VettingProcessList=t.ResultData.VettingProcessList,e.SET_HOTEL_ORDER(s)}e._checkReason()}})},_checkReason:function(){var e=this,t=JSON.parse(c()(this.hotelOrder));t.CheckGuests=this.hotelOrder.Guests,t.CheckInDate=this.beTimeNumber(this.hotelOrder.CheckInDate),t.CheckOutDate=this.beTimeNumber(this.hotelOrder.CheckOutDate),Object(w.M)(t).then(function(t){if(!0===t.ResultData.IsViolate){var s="";t.ResultData.GuestNames&&t.ResultData.GuestNames.forEach(function(e){2===e.ViolateRankResult&&(s+=e.Name+"、")}),e.noValue(s)?(e.showViolationRank=!0,e.violationRankDetails=t.ResultData):(s=s.substring(0,s.length-1),e.$toast(e.$t("TM.XIsNotAllowedToBook","function",s)))}else e._checkOrderRepeat()})},_checkOrderRepeat:function(){var e=this,t={CheckInDate:this.beTimeNumber(this.hotelOrder.CheckInDate),CheckOutDate:this.beTimeNumber(this.hotelOrder.CheckOutDate),Guests:this.hotelOrder.Guests};Object(w.L)(t).then(function(t){t.ResultData.IsRepeat?e.$alert({content:t.ResultData.Message,cancelTxt:e.$t("base.Cancel"),confirmTxt:e.$t("base.Continue"),confirmFn:function(){e._nextStep()}}):e._nextStep()})},_nextStep:function(){this.$router.push({name:"hotelOrderConfirm",params:n()(this.$route.params,{hotelOrderInit:this.details})})},_resetContentInTheHotelOrder:function(){var e=JSON.parse(c()(this.hotelOrder));e.ViolationRankName="",e.ViolationRankReason="",e.Guests=[],this.SET_HOTEL_ORDER(e)}}),components:{CContacts:p.a,CCustomItem:m.a,CFrequentContacts:v.a,CHeader:_.a,CPassenger:f.a,HsButton:O.a,HsCell1:C.a,HsCellSmallTitle:g.a,HsDialog:T.a,HsGradientButton:D.a,HsNet:b.a,HsScroll:y.a,HsSection:R.a,PassengerDetails:$.a,ViolationRank:N}},V={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("div",{staticClass:"hs-container"},[s("c-header",{staticClass:"c-header",attrs:{title:e.$t("base.HotelBooking")+"-"+(0===Number(e.hotelOrder.TravelType)?e.$t("base.Business"):e.$t("base.Personal")),isBackNav:""}}),e._v(" "),e.noValue(JSON.stringify(e.details))?s("hs-net",{on:{delegate:e._getDetails}}):[e.noValue(JSON.stringify(e.hotel))?e._e():s("hs-scroll",{staticClass:"table-view"},[s("ul",[s("hs-section",[s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell-hotel"},[s("p",{staticClass:"title"},[e._v(e._s(e.hotel.HotelName))]),e._v(" "),s("p",{staticClass:"little-title"},[e._v(e._s(e.ratePlan.RatePlanName))]),e._v(" "),s("p",[e._v(e._s(e.room.BedType)+" | "+e._s(e.$t("base.CanAccommodateXPeople","function",e.room.Capcity))+" | "+e._s(e.ratePlan.BreakFast))]),e._v(" "),s("p",[e._v(e._s(e.$t("base.CheckInDate"))+" "+e._s(e.$t(e.hotelOrder.CheckInDate,"date",["yyyy-MM-dd","MM dd, yyyy"])))]),e._v(" "),s("p",[e._v(e._s(e.$t("base.CheckOutDate"))+" "+e._s(e.$t(e.hotelOrder.CheckOutDate,"date",["yyyy-MM-dd","MM dd, yyyy"]))+" "+e._s(e.$t("base.TotalNights","function",e.getApartDayCount(e.hotelOrder.CheckInDate,e.hotelOrder.CheckOutDate))))])])]),e._v(" "),s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell-cancel"},[s("div",{staticStyle:{"background-image":"url('static/image/hotel/irreversible.png')"}}),e._v(" "),s("div",[s("p",[e._v(e._s(e.ratePlan.CancelRuleDesc))])])])])],1),e._v(" "),s("hs-section",[s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell-room"},[s("div",{on:{click:function(t){e.showRoomAmount=!e.showRoomAmount}}},[s("div",{attrs:{type:e.language}},[s("p",[e._v(e._s(e.$t("base.NumberOfRooms")))]),e._v(" "),s("p",[e._v(e._s(e.hotelOrder.RoomAmount)+e._s(e.$t("base.QuantifierHotel"))),s("span",[e._v(e._s(e.$t("base.CanAccommodateUpToXPeople","function",e.room.Capcity)))])])]),e._v(" "),s("div",{staticClass:"arrow",staticStyle:{"background-image":"url('static/image/base/cell/right_arrow_gray.png')"},style:{transform:"rotate("+(e.showRoomAmount?"90deg":"-90deg")+")"}})]),e._v(" "),e.showRoomAmount?s("div",e._l(4,function(t){return s("p",{key:t,class:{active:e.hotelOrder.RoomAmount===t},on:{click:function(s){e._setRoomAmount(t)}}},[e._v(e._s(t))])})):e._e()])]),e._v(" "),s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell-people"},[s("p",[e._v(e._s(e.$t("base.Roomer")))]),e._v(" "),s("div",[s("p",[e._v(e._s(e.$t("base.EachRoomNeedsToFillIn","function",e.room.Capcity>1?"1~"+e.room.Capcity:"1")))]),e._v(" "),s("hs-button",{attrs:{type:"common",fontSize:"0.8rem"},on:{click:function(t){e.$refs.CPassenger.open()}}},[e._v(e._s(e.$t("base.Add"))+" +")])],1)])]),e._v(" "),e._l(e.hotelOrder.Guests,function(t,a){return s("hs-cell-1",{key:a},[s("div",{staticClass:"people-infor",style:{transform:"translateX("+(e.hotelOrder.Guests[a].openDelete?"-65px":"0px")+")"}},[s("div",{staticClass:"left",on:{click:function(t){e._setPassengerOpenDelete(!0,a)}}},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/plane-ticket/book/delete.png')"}})]),e._v(" "),s("div",{staticClass:"right",on:{click:function(t){e._gotoPassengerDetails(a)}}},[s("div",{staticClass:"item"},[0===t.DefaultNameType?s("p",{staticClass:"name"},[e._v(e._s(t.ChName))]):s("p",{staticClass:"name"},[e._v(e._s(t.LastName)+" "+e._s(t.FirstName))])]),e._v(" "),s("div",{staticClass:"item"},[s("p",{staticClass:"other-title"},[e._v(e._s(e.$t("base.CellphoneNumber")))]),e._v(" "),s("p",{staticClass:"other-value"},[e._v(e._s(""+(t.Mobile?t.Mobile:e.$t("base.Unfilled"))))])]),e._v(" "),s("div",{staticClass:"delete",on:{click:function(t){t.stopPropagation(),e._deletePassenger(a)}}},[e._v(e._s(e.$t("base.Delete")))])])])])}),e._v(" "),e.details.ChargeInfo?s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"service-fee"},[s("p",[e._v(e._s(e.$t("base.ServiceFee")))]),e._v(" "),s("p",[e._v("￥"+e._s(e.details.ChargeInfo.ServiceCharge))])])]):e._e()],2),e._v(" "),s("hs-section",[s("hs-cell-small-title",{attrs:{title:e.$t("base.ArrivalHotelTime"),type:"disabled-input",value:e.hotelOrder.ArrivalTime,placeholder:"("+e.$t("base.NotNecessaryChoose")+") "+e.$t("base.PleaseChoose")},nativeOn:{click:function(t){e.showArrivalTimeDialog=!0}}}),e._v(" "),s("hs-cell-small-title",{attrs:{title:e.$t("base.SpecificRequirements"),type:"input",placeholder:"("+e.$t("base.NotNecessaryFill")+") "+e.$t("base.PleaseFill"),showLogo:!1},model:{value:e.specificRequirements,callback:function(t){e.specificRequirements=t},expression:"specificRequirements"}}),e._v(" "),e.details.IsDisplayCustomItem?s("hs-cell-small-title",{attrs:{title:e.details.CustomItemName,type:"disabled-input",value:e.hotelOrder.CustomItem?e.hotelOrder.CustomItem.Name:"",placeholder:"("+(e.details.IsRequiredCustomItem?e.$t("base.RequiredChoose"):e.$t("base.NotNecessaryChoose"))+") "+e.$t("base.PleaseChoose")},nativeOn:{click:function(t){e.showCCustomItem=!0}}}):e._e(),e._v(" "),e.details.IsDisplayPurpose?s("hs-cell-small-title",{attrs:{title:e.$t("base.Purpose"),type:"input",placeholder:"("+(e.details.IsRequiredPurpose?e.$t("base.RequiredFill"):e.$t("base.NotNecessaryFill"))+") "+e.$t("base.PleaseFill"),showLogo:!1},model:{value:e.purpose,callback:function(t){e.purpose=t},expression:"purpose"}}):e._e(),e._v(" "),3===e.details.VettingType&&e.details.EnableVetting?s("hs-cell-small-title",{attrs:{title:e.$t("base.Approver"),type:"disabled-input",value:e.hotelOrder.AppointVettingPersonName,placeholder:"("+e.$t("base.RequiredChoose")+") "+e.$t("base.PleaseChoose")},nativeOn:{click:function(t){e.picker.show()}}}):e._e(),e._v(" "),0===Number(e.hotelOrder.TravelType)?s("hs-cell-small-title",{attrs:{title:e.$t("base.PaymentWay"),type:"disabled-input",value:e._f("filterPayType")(e.hotelOrder.PayType),placeholder:"("+e.$t("base.RequiredChoose")+") "+e.$t("base.PleaseChoose")},nativeOn:{click:function(t){e.payTypePicker.show()}}}):e._e()],1),e._v(" "),s("hs-section",[s("hs-cell-1",{attrs:{value:e.$t("base.ContactInformation"),logoName:"add.png"},nativeOn:{click:function(t){e.$refs.CFrequentContacts.open()}}}),e._v(" "),e._l(e.hotelOrder.Contacts,function(t,a){return s("hs-cell-1",{key:a},[s("div",{staticClass:"people-infor",style:{transform:"translateX("+(e.hotelOrder.Contacts[a].openDelete?"-65px":"0px")+")"}},[s("div",{staticClass:"left",on:{click:function(t){e._setContactsOpenDelete(!0,a)}}},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/plane-ticket/book/delete.png')"}})]),e._v(" "),s("div",{staticClass:"right",on:{click:function(t){e._gotoContactsDetails(a)}}},[s("div",{staticClass:"item"},[s("p",{staticClass:"name"},[e._v(e._s(t.Name))])]),e._v(" "),s("div",{staticClass:"item"},[s("p",{staticClass:"other-title"},[e._v(e._s(e.$t("base.CellphoneNumber")))]),e._v(" "),s("p",{staticClass:"other-value"},[e._v(e._s(t.Mobile?t.Mobile:e.$t("base.Unfilled")))])]),e._v(" "),s("div",{staticClass:"item"},[s("p",{staticClass:"other-title"},[e._v(e._s(e.$t("base.Email")))]),e._v(" "),s("p",{staticClass:"other-value"},[e._v(e._s(t.Email?t.Email:e.$t("base.Unfilled")))])]),e._v(" "),s("div",{staticClass:"delete",on:{click:function(t){t.stopPropagation(),e._deleteContact(a)}}},[e._v(e._s(e.$t("base.Delete")))])])])])})],2)],1)]),e._v(" "),s("div",{staticClass:"footer",on:{click:e._switchDetailsDialog}},[s("div",{staticClass:"price"},[e.details.ChargeInfo?s("p",[e._v("￥"+e._s(e.details.ChargeInfo.TotalPrice))]):e._e(),e._v(" "),s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/base/cell/right_arrow_gray.png')"},style:{transform:e.showDetailsDialog?"rotate(90deg)":"rotate(-90deg)"}})]),e._v(" "),s("div",{staticClass:"details"},[s("hs-gradient-button",{attrs:{type:"common",width:"auto",title:e.$t("base.NextStep")},on:{click:e._gotoConfirm}})],1)])],e._v(" "),s("hs-dialog",{ref:"detailsDialog",attrs:{height:"calc(100% - 50px)"},model:{value:e.showDetailsDialog,callback:function(t){e.showDetailsDialog=t},expression:"showDetailsDialog"}},[e.details.ChargeInfo?s("hs-scroll",{staticClass:"detailsDialog",attrs:{data:[e.hotelOrder],isListenScroll:!0},on:{scrollStart:e._scrollStart},nativeOn:{click:function(e){e.stopPropagation()}}},[s("ul",[s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"detailsDialog-custom-cell"},[s("p",[e._v(e._s(e.$t("base.PriceHotel")))]),e._v(" "),s("p",[s("span",[e._v("￥"+e._s(e.details.ChargeInfo.AverageRate*e.getApartDayCount(e.hotelOrder.CheckInDate,e.hotelOrder.CheckOutDate)))]),e._v(" "),s("span",[e._v("x "+e._s(e.getApartDayCount(e.hotelOrder.CheckInDate,e.hotelOrder.CheckOutDate))+e._s(e.$t("base.QuantifierNight")))]),e._v(" "),s("span",[e._v("x "+e._s(e.hotelOrder.RoomAmount)+e._s(e.$t("base.QuantifierHotel")))])])])]),e._v(" "),s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"detailsDialog-custom-cell"},[s("p",[e._v(e._s(e.$t("base.ServiceFee")))]),e._v(" "),s("p",[s("span",[e._v("￥"+e._s(e.details.ChargeInfo.ServiceCharge))])])])])],1)]):e._e(),e._v(" "),s("div",{ref:"show-more",staticClass:"show-more"},[e._v(e._s(e.$t("base.SlideUpToSeeMore")))])],1),e._v(" "),s("hs-dialog",{model:{value:e.showArrivalTimeDialog,callback:function(t){e.showArrivalTimeDialog=t},expression:"showArrivalTimeDialog"}},[s("hs-scroll",{ref:"arrivalTimeDialog",staticClass:"arrivalTimeDialog",attrs:{data:e.arrivalTimeItems}},[s("ul",[s("div",{staticClass:"item-header"},[e._v(e._s(e.$t("base.ETA")))]),e._v(" "),s("div",{staticClass:"item-header-little"},[e._v(e._s(e.$t("base.TheRoomIsReservedAllNight")))]),e._v(" "),s("div",{staticClass:"items"},e._l(e.arrivalTimeItems,function(t,a){return s("p",{key:a,class:{actived:e.hotelOrder.ArrivalTime===t},style:{"margin-right":a%3==2?"0px":"","margin-bottom":a%3==0?"20px":""},on:{click:function(s){e._selectArrivalTimeItem(t)}}},[e._v(e._s(t))])}))])])],1),e._v(" "),e.room.Capcity?[s("c-passenger",{ref:"CPassenger",attrs:{XOrder:e.hotelOrder,BookInit:e.details,OrderBusinessType:2,MaxLength:e.hotelOrder.RoomAmount*e.room.Capcity},on:{delegateWithConfirm:e._delegateWithConfirm}})]:e._e(),e._v(" "),s("passenger-details",{ref:"PassengerDetails",attrs:{details:e.editingPassenger,BookInit:e.details,OrderBusinessType:2},on:{delegate:e._delegateWithPassengerDetails}}),e._v(" "),s("c-custom-item",{attrs:{show:e.showCCustomItem,orderInit:e.details},on:{"update:show":function(t){e.showCCustomItem=t},"update:orderInit":function(t){e.details=t},delegate:e._delegateWithCustomItem}}),e._v(" "),s("c-contacts",{attrs:{show:e.showCContacts,datalist:e.hotelOrder.Contacts,OrderBusinessType:2},on:{"update:show":function(t){e.showCContacts=t},delegate:e._delegateWithContacts},model:{value:e.contactDetails,callback:function(t){e.contactDetails=t},expression:"contactDetails"}}),e._v(" "),s("c-frequent-contacts",{ref:"CFrequentContacts",attrs:{orderInit:e.details,datalist:e.hotelOrder.Contacts,OrderBusinessType:2},on:{"update:orderInit":function(t){e.details=t},delegate:e._delegateWithFrequentContacts}}),e._v(" "),s("violation-rank",{attrs:{show:e.showViolationRank,details:e.violationRankDetails},on:{"update:show":function(t){e.showViolationRank=t},delegate:e._nextStep}})],2)},staticRenderFns:[]};var L=s("VU/8")(x,V,!1,function(e){s("Jlqw")},"data-v-61fddb04",null);t.default=L.exports}});
//# sourceMappingURL=5.8001c7f419236059139b.js.map