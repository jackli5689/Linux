webpackJsonp([31],{b5JP:function(t,e){},jKEJ:function(t,e,i){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var a=i("mvHQ"),s=i.n(a),n=i("fZjL"),l=i.n(n),r=i("BO1k"),o=i.n(r),c=i("Dd8w"),h=i.n(c),u=i("C0NF"),d=i("CCVD"),_=i("kyCV"),v=i("NtKv"),y=i("QRZS"),D=i("62cB"),f=i("RxQk"),m=i("yyVE"),C=i("lA9+"),g=i("gSa9"),b=i("+naC"),p=i("NYxO"),T=i("gyMJ"),k={created:function(){this.noValue(this.$route.query.TravelType)?this.$router.replace("/home"):(this._getMenuPermissions(),this._getHotelRight(),this._getIntlHotelRight())},computed:h()({},Object(p.c)(["hotelOrder","interHotelOrder"]),{canBookHotel:function(){return this.MenuPermissions.indexOf(2)>=0},canBookIntlHotel:function(){return this.MenuPermissions.indexOf(4)>=0}}),data:function(){return{banners:["/static/image/hotel/query/banner_001.jpeg"],tabActivedIndex:0,showTravelStandard:!1,details:{},intlDetails:{},showWhere:!1,showFilterHotel:!1,showInterFilterHotel:!1,filterDetails:{},interFilterDetails:{},filterDetailsText:"",interFilterDetailsText:"",QueryText:"",intlRoomAmount:1,intlAdultAmount:2,showNation:!1,nationalityName:"中国",nationalityCode:"CN",showDatePicker:!1,checkInDate:this.beTime(new Date),checkOutDate:this.beTime((new Date).setDate((new Date).getDate()+1)),MenuPermissions:[]}},methods:h()({},Object(p.d)(["SET_HOTEL_ORDER","SET_INTER_HOTEL_ORDER"]),{_getMenuPermissions:function(){var t=this;Object(T.I)().then(function(e){t.MenuPermissions=e.ResultData.MenuPermissions,!t.canBookHotel&&t.canBookIntlHotel?t._selectTab(1):t.canBookHotel||t.canBookIntlHotel?t._selectTab(0):t.$router.replace("/home")})},_getHotelRight:function(){var t=this;Object(T.T)().then(function(e){t.details=e.ResultData})},_getIntlHotelRight:function(){var t=this;Object(T.X)().then(function(e){t.intlDetails=e.ResultData})},_selectTab:function(t){this.tabActivedIndex=t,this._readlocalStorageWithQuery()},_getLocation:function(){this.$refs.hsAddressPicker.getLocation()},_setCity:function(t){if(0===this.tabActivedIndex){var e=h()({},this.hotelOrder);e.City=t,e.CityName=t["CityName_"+this.language],e.CityID=t.CityCode,this.SET_HOTEL_ORDER(e)}else{var i=h()({},this.interHotelOrder);i.City=t,i.CityName=t["CityName_"+this.language],i.CityID=t.CityCode,this.SET_INTER_HOTEL_ORDER(i)}this._getFilterCondition()},_getFilterCondition:function(){var t=this;0===this.tabActivedIndex?Object(T.S)({cityID:this.hotelOrder.CityID}).then(function(e){t.filterDetails=e.ResultData;var i=function(e){t.filterDetails[e].forEach(function(i,a){t.$set(t.filterDetails[e][a],"selected",!1)})},a=!0,s=!1,n=void 0;try{for(var r,c=o()(l()(t.filterDetails));!(a=(r=c.next()).done);a=!0){i(r.value)}}catch(t){s=!0,n=t}finally{try{!a&&c.return&&c.return()}finally{if(s)throw n}}}):Object(T.W)({cityID:this.interHotelOrder.CityID}).then(function(e){t.interFilterDetails.FacilitieInfoList=e.ResultData.Facilities;var i=function(e){t.interFilterDetails[e].forEach(function(i,a){t.$set(t.interFilterDetails[e][a],"selected",!1)})},a=!0,s=!1,n=void 0;try{for(var r,c=o()(l()(t.interFilterDetails));!(a=(r=c.next()).done);a=!0){i(r.value)}}catch(t){s=!0,n=t}finally{try{!a&&c.return&&c.return()}finally{if(s)throw n}}})},_delegateWithUpdateFilterDetails:function(t){this.filterDetails=t;var e=[],i=!0,a=!1,s=void 0;try{for(var n,r=o()(l()(this.filterDetails));!(i=(n=r.next()).done);i=!0){var c=n.value;this.filterDetails[c].forEach(function(t,i){t.selected&&e.push(t.Name)})}}catch(t){a=!0,s=t}finally{try{!i&&r.return&&r.return()}finally{if(a)throw s}}this.filterDetailsText=e.join("、")},_delegateWithUpdateInterFilterDetails:function(t){this.interFilterDetails=t;var e=[],i=!0,a=!1,s=void 0;try{for(var n,r=o()(l()(this.interFilterDetails));!(i=(n=r.next()).done);i=!0){var c=n.value;this.interFilterDetails[c].forEach(function(t,i){t.selected&&e.push(t.NameChn)})}}catch(t){a=!0,s=t}finally{try{!i&&r.return&&r.return()}finally{if(a)throw s}}this.interFilterDetailsText=e.join("、")},_resetFilterDetails:function(){var t=this,e=function(e){t.filterDetails[e].forEach(function(i,a){t.$set(t.filterDetails[e][a],"selected",!1)})},i=!0,a=!1,s=void 0;try{for(var n,r=o()(l()(this.filterDetails));!(i=(n=r.next()).done);i=!0){e(n.value)}}catch(t){a=!0,s=t}finally{try{!i&&r.return&&r.return()}finally{if(a)throw s}}this.filterDetailsText="";var c=function(e){t.interFilterDetails[e].forEach(function(i,a){t.$set(t.interFilterDetails[e][a],"selected",!1)})},h=!0,u=!1,d=void 0;try{for(var _,v=o()(l()(this.interFilterDetails));!(h=(_=v.next()).done);h=!0){c(_.value)}}catch(t){u=!0,d=t}finally{try{!h&&v.return&&v.return()}finally{if(u)throw d}}this.interFilterDetailsText=""},_openFilterHotel:function(){(0===this.tabActivedIndex?this.noValue(s()(this.filterDetails)):this.noValue(s()(this.interFilterDetails)))?this.$toast(this.$t("TM.PleaseSelectADestination")):0===this.tabActivedIndex?this.showFilterHotel=!0:this.showInterFilterHotel=!0},_updateFromDate:function(t){t&&t<this.beTime(new Date)?this.checkInDate=this.beTime(new Date):this.checkInDate=t},_updateToDate:function(t){t&&t<=this.checkInDate?this.checkOutDate=this.getNewDate(this.checkInDate,0,0,1):this.checkOutDate=t},_calculateRoomAmount:function(t){-1===t&&(this.intlRoomAmount=this.intlRoomAmount>1?this.intlRoomAmount-1:this.intlRoomAmount),1===t&&(this.intlRoomAmount=this.intlRoomAmount<5?this.intlRoomAmount+1:this.intlRoomAmount)},_calculateAdultAmount:function(t){-1===t&&(this.intlAdultAmount=this.intlAdultAmount>1?this.intlAdultAmount-1:this.intlAdultAmount),1===t&&(this.intlAdultAmount=this.intlAdultAmount<5?this.intlAdultAmount+1:this.intlAdultAmount)},_selectNation:function(t){this.nationalityName=t["NationName_"+this.language],this.nationalityCode=t.NationCode},_gotoQuery:function(){if(0===this.tabActivedIndex){var t=h()({},this.hotelOrder);if(t.TravelType=this.$route.query.TravelType,t.CheckInDate=this.checkInDate,t.CheckOutDate=this.checkOutDate,this.SET_HOTEL_ORDER(t),this.noValue(this.hotelOrder.CityID))return void this.$toast(this.$t("TM.PleaseSelectADestination"));this.$router.push({name:"hotelInforList",query:{QueryText:this.QueryText},params:{filterDetails:this.filterDetails}})}else{var e=h()({},this.interHotelOrder);if(e.TravelType=this.$route.query.TravelType,e.CheckInDate=this.checkInDate,e.CheckOutDate=this.checkOutDate,e.RoomAmount=this.intlRoomAmount,e.AdultAmount=this.intlAdultAmount,e.NationalityName=this.nationalityName,e.NationalityCode=this.nationalityCode,this.SET_INTER_HOTEL_ORDER(e),this.noValue(this.interHotelOrder.CityID))return void this.$toast(this.$t("TM.PleaseSelectADestination"));this.$router.push({name:"interHotelInforList",query:{QueryText:this.QueryText},params:{filterDetails:this.interFilterDetails}})}this._savelocalStorageWithQuery()},_savelocalStorageWithQuery:function(){0===this.tabActivedIndex?window.localStorage.HISTORY_QUERY_DOMESTIC_HOTEL=s()({City:this.hotelOrder.City,CheckInDate:this.checkInDate,CheckOutDate:this.checkOutDate}):window.localStorage.HISTORY_QUERY_INTL_HOTEL=s()({City:this.interHotelOrder.City,CheckInDate:this.checkInDate,CheckOutDate:this.checkOutDate})},_readlocalStorageWithQuery:function(){if(0===this.tabActivedIndex&&window.localStorage.HISTORY_QUERY_DOMESTIC_HOTEL){var t=JSON.parse(window.localStorage.HISTORY_QUERY_DOMESTIC_HOTEL),e=h()({},this.hotelOrder);e.City=t.City,e.CityName=t.City["CityName_"+this.language],e.CityID=t.City.CityCode,this.SET_HOTEL_ORDER(e),this._updateFromDate(t.CheckInDate),this._updateToDate(t.CheckOutDate)}if(1===this.tabActivedIndex&&window.localStorage.HISTORY_QUERY_INTL_HOTEL){var i=JSON.parse(window.localStorage.HISTORY_QUERY_INTL_HOTEL),a=h()({},this.interHotelOrder);a.City=i.City,a.CityName=i.City["CityName_"+this.language],a.CityID=i.City.CityCode,this.SET_INTER_HOTEL_ORDER(a),this._updateFromDate(i.CheckInDate),this._updateToDate(i.CheckOutDate)}}}),components:{HsScroll:u.a,CHeader:d.a,HsSwiper:_.a,HsInput:v.a,HsTab:y.a,HsDatePicker2:D.a,HsAddressPicker:f.a,HsGradientButton:m.a,CTravelStandard:g.a,HsNation:C.a,HsFilterHotel:b.a}},I={render:function(){var t=this,e=t.$createElement,i=t._self._c||e;return i("div",{staticClass:"hs-container"},[i("c-header",{attrs:{isBackNav:"",title:0===Number(t.$route.query.TravelType)?t.$t("base.BusinessTrip"):t.$t("base.PersonalTrip"),fixedBackPath:"/home"}},[0===Number(t.$route.query.TravelType)?i("p",{staticClass:"c-header-right",attrs:{slot:"right"},on:{click:function(e){t.showTravelStandard=!0}},slot:"right"},[t._v(t._s(t.$t("base.Policy")))]):t._e()]),t._v(" "),i("hs-scroll",{ref:"tableView",staticClass:"tableView",attrs:{data:[t.details]}},[i("ul",[i("div",{staticClass:"slider-box"},[i("hs-swiper",{attrs:{maxType:"Width",images:t.banners}})],1),t._v(" "),i("div",{staticClass:"section"},[t.canBookHotel&&t.canBookIntlHotel?i("hs-tab",{attrs:{selectedIndex:t.tabActivedIndex,options:[t.$t("base.China_2"),t.$t("base.InternationalRegion_2")]},on:{"update:selectedIndex":function(e){t.tabActivedIndex=e},select:t._selectTab}}):t._e(),t._v(" "),i("div",{staticClass:"address",on:{click:function(e){t.showWhere=!0}}},[i("div",{staticClass:"destination"},[i("p",[t._v(t._s(0===t.tabActivedIndex?t.$t("base.China_2"):t.$t("base.InternationalRegion_2"))+t._s(t.$t("base.Destination")))]),t._v(" "),i("p",{directives:[{name:"show",rawName:"v-show",value:0===t.tabActivedIndex,expression:"tabActivedIndex === 0"}]},[t._v(t._s(t.hotelOrder.City&&t.hotelOrder.City["CityName_"+t.language]?t.hotelOrder.City["CityName_"+t.language]:t.$t("base.PleaseChoose")))]),t._v(" "),i("p",{directives:[{name:"show",rawName:"v-show",value:1===t.tabActivedIndex,expression:"tabActivedIndex === 1"}]},[t._v(t._s(t.interHotelOrder.City&&t.interHotelOrder.City["CityName_"+t.language]?t.interHotelOrder.City["CityName_"+t.language]:t.$t("base.PleaseChoose")))])]),t._v(" "),i("div",{staticClass:"location",style:{visibility:1===t.tabActivedIndex?"hidden":""},on:{click:function(e){return e.stopPropagation(),t._getLocation(e)}}},[i("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/hotel/location_2.png')"}}),t._v(" "),i("p",[t._v(t._s(t.$t("base.Location")))])])]),t._v(" "),i("div",{staticClass:"item-date",on:{click:function(e){t.showDatePicker=!0}}},[i("div",{staticClass:"left"},[i("p",[t._v(t._s(t.$t("base.Date")))]),t._v(" "),i("div",[i("p",[t._v(t._s(t.$t(t.beTime(new Date(t.checkInDate)),"date",["MM月dd日","MM dd"])))]),t._v(" "),i("span",[t._v(t._s(t.getWeeks(t.checkInDate))+t._s(t.$t("base.CheckIn")))])]),t._v(" "),i("div",[i("p",[t._v(t._s(t.$t(t.beTime(new Date(t.checkOutDate)),"date",["MM月dd日","MM dd"])))]),t._v(" "),i("span",[t._v(t._s(t.getWeeks(t.checkOutDate))+t._s(t.$t("base.CheckOut")))]),t._v(" "),i("span",[t._v(t._s(t.$t("base.TotalNights","function",t.getApartDayCount(t.checkInDate,t.checkOutDate))))])])]),t._v(" "),i("div",{staticClass:"arrow",staticStyle:{"background-image":"url('static/image/base/cell/right_arrow_gray.png')"}})]),t._v(" "),1===t.tabActivedIndex?i("div",{staticClass:"item-number-picker"},[i("div",{staticClass:"number-picker",attrs:{type:t.language}},[i("p",[t._v(t._s(t.$t("base.NumberOfRoomsBooked")))]),t._v(" "),i("div",{staticClass:"picker"},[i("div",{staticClass:"decrease",staticStyle:{"background-image":"url('static/image/hotel/query/decrease.png')"},on:{click:function(e){t._calculateRoomAmount(-1)}}}),t._v(" "),i("p",{staticClass:"number"},[t._v(t._s(t.intlRoomAmount))]),t._v(" "),i("div",{staticClass:"increase",staticStyle:{"background-image":"url('static/image/hotel/query/increase.png')"},on:{click:function(e){t._calculateRoomAmount(1)}}})])]),t._v(" "),i("div",{staticClass:"number-picker",attrs:{type:t.language}},[i("p",[t._v(t._s(t.$t("base.NumberOfGuestsPerRoom")))]),t._v(" "),i("div",{staticClass:"picker"},[i("div",{staticClass:"decrease",staticStyle:{"background-image":"url('static/image/hotel/query/decrease.png')"},on:{click:function(e){t._calculateAdultAmount(-1)}}}),t._v(" "),i("p",{staticClass:"number"},[t._v(t._s(t.intlAdultAmount))]),t._v(" "),i("div",{staticClass:"increase",staticStyle:{"background-image":"url('static/image/hotel/query/increase.png')"},on:{click:function(e){t._calculateAdultAmount(1)}}})])])]):t._e(),t._v(" "),1===t.tabActivedIndex?i("div",{staticClass:"item-nation",on:{click:function(e){t.showNation=!0}}},[i("div",{staticClass:"left"},[i("p",[t._v(t._s(t.$t("base.NationalityOfThePerson")))]),t._v(" "),i("p",[t._v(t._s(t.nationalityName))])]),t._v(" "),i("div",{staticClass:"arrow",staticStyle:{"background-image":"url('static/image/base/cell/right_arrow_gray.png')"}})]):t._e(),t._v(" "),i("div",{staticClass:"item-input"},[i("hs-input",{attrs:{placeholder:t.$t("base.KeywordSearch")},model:{value:t.QueryText,callback:function(e){t.QueryText=e},expression:"QueryText"}})],1),t._v(" "),0===t.tabActivedIndex?i("div",{staticClass:"item-input",on:{click:t._openFilterHotel}},[i("hs-input",{staticClass:"disabled",attrs:{width:"calc(100% - 25px)",placeholder:t.$t("base.BusinessDistrictInfrastructureBrandEtc")},model:{value:t.filterDetailsText,callback:function(e){t.filterDetailsText=e},expression:"filterDetailsText"}}),t._v(" "),i("div",{staticClass:"arrow",staticStyle:{"background-image":"url('static/image/base/cell/right_arrow_gray.png')"}})],1):t._e(),t._v(" "),1===t.tabActivedIndex?i("div",{staticClass:"item-input",on:{click:t._openFilterHotel}},[i("hs-input",{staticClass:"disabled",attrs:{width:"calc(100% - 25px)",placeholder:t.$t("base.Infrastructure")},model:{value:t.interFilterDetailsText,callback:function(e){t.interFilterDetailsText=e},expression:"interFilterDetailsText"}}),t._v(" "),i("div",{staticClass:"arrow",staticStyle:{"background-image":"url('static/image/base/cell/right_arrow_gray.png')"}})],1):t._e(),t._v(" "),i("hs-gradient-button",{staticStyle:{margin:"20px 0"},attrs:{title:t.$t("base.Search")},on:{click:t._gotoQuery}})],1),t._v(" "),i("div",{staticStyle:{width:"100%",height:"10px"}})])]),t._v(" "),i("hs-address-picker",{ref:"hsAddressPicker",attrs:{switchList:[t.$t("base.China_2"),t.$t("base.InternationalRegion_2")],activeIndex:t.tabActivedIndex,title:t.$t("base.SelectCity")},on:{"update:activeIndex":function(e){t.tabActivedIndex=e},select:t._setCity},model:{value:t.showWhere,callback:function(e){t.showWhere=e},expression:"showWhere"}}),t._v(" "),i("hs-date-picker-2",{attrs:{show:t.showDatePicker,fromDate:t.checkInDate,toDate:t.checkOutDate},on:{"update:show":function(e){t.showDatePicker=e},"update:fromDate":t._updateFromDate,"update:toDate":t._updateToDate}}),t._v(" "),i("c-travel-standard",{attrs:{type:2,details:0===t.tabActivedIndex?t.details.HotelRank:t.intlDetails.HotelRank,travelPolicy:0===t.tabActivedIndex?t.details.TravelPolicy:t.intlDetails.TravelPolicy},model:{value:t.showTravelStandard,callback:function(e){t.showTravelStandard=e},expression:"showTravelStandard"}}),t._v(" "),i("hs-nation",{on:{select:t._selectNation},model:{value:t.showNation,callback:function(e){t.showNation=e},expression:"showNation"}}),t._v(" "),i("hs-filter-hotel",{attrs:{show:t.showFilterHotel,details:t.filterDetails},on:{"update:show":function(e){t.showFilterHotel=e},delegate:t._delegateWithUpdateFilterDetails}}),t._v(" "),i("hs-filter-hotel",{attrs:{initSelectedKey:"FacilitieInfoList",show:t.showInterFilterHotel,details:t.interFilterDetails},on:{"update:show":function(e){t.showInterFilterHotel=e},delegate:t._delegateWithUpdateInterFilterDetails}})],1)},staticRenderFns:[]};var O=i("VU/8")(k,I,!1,function(t){i("b5JP")},"data-v-8fb1e790",null);e.default=O.exports}});
//# sourceMappingURL=31.f87990a40018fb75ba95.js.map