webpackJsonp([71],{UgQm:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s=n("7+uW"),a=n("CCVD"),r=n("C0NF"),i=n("9Vmw"),l=n("4aFc"),c={components:{CHeader:a.a,HsScroll:r.a,HsSection:i.a,HsCell1:l.a},props:{value:{type:Boolean,default:!1},details:{type:Object,default:function(){return{}}},passengerWarning:{type:String,default:s.a.prototype.$t("base.FrequentTraveler")}},computed:{currentValue:{get:function(){return this.value},set:function(e){return this.$emit("input",e)}}},data:function(){return{}}},o={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("transition",{attrs:{name:"slide"}},[e.currentValue?n("div",{staticClass:"hs-container-child"},[n("c-header",{attrs:{title:e.$t("base.ApprovalInformation"),leftIcon1:"return.png",leftFn1:function(){return e.currentValue=!1}}}),e._v(" "),n("hs-scroll",{staticClass:"table-view"},[n("ul",e._l(e.details.VettingProcessList,function(t,s){return n("hs-section",{key:s},[n("hs-cell-1",{attrs:{showLogo:!1}},[n("div",{staticClass:"custom-cell"},[n("div",{staticClass:"header"},[n("p",[e._v(e._s(e.passengerWarning)+":")]),e._v(" "),e._l(t.Passengers,function(t,s){return n("p",{key:s},[e._v(e._s(t.Name))])})],2),e._v(" "),n("div",{staticClass:"details"},e._l(t.ProcessNodes,function(t,s){return n("div",{key:s,staticClass:"item"},[n("p",[e._v(e._s(e.$t("base.LevelXAapproval","function",t.VettingLevel)))]),e._v(" "),n("p",[e._v(e._s(t.ProcessPersonName))])])}))])])],1)}))])],1):e._e()])},staticRenderFns:[]};var u=n("VU/8")(c,o,!1,function(e){n("WOBd")},"data-v-e71bb0ac",null);t.default=u.exports},WOBd:function(e,t){}});
//# sourceMappingURL=71.4b8424dff3bdbf8ac8ed.js.map