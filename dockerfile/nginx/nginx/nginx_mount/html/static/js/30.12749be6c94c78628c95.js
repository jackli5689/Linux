webpackJsonp([30],{bCf5:function(t,e){},oT6K:function(t,e,s){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var a=s("CCVD"),i=s("yyVE"),l=s("4aFc"),n=s("gyMJ"),o={data:function(){return{details:{CmpId:"",UserName:"",Email:""}}},methods:{_nextStep:function(){var t=this;this.noValue(this.details.CmpId)?this.$toast(this.$t("TM.PleaseEnter","function",this.$t("base.UnitNumberOrUnitName"))):this.noValue(this.details.UserName)?this.$toast(this.$t("TM.PleaseEnter","function",this.$t("base.Username"))):this.noValue(this.details.Email)?this.$toast(this.$t("TM.PleaseEnter","function",this.$t("base.Email"))):this.isEmail(this.details.Email)?Object(n._61)(this.details).then(function(e){e.IsSuccess&&t.$alert({content:t.$t("TM.SendMailSuccessfullyPleaseCheckTheMailboxToResetThePassword")})}):this.$toast(this.$t("TM.XFormatIsIncorrect","function",this.$t("base.Email")))}},components:{CHeader:a.a,HsGradientButton:i.a,HsCell1:l.a}},r={render:function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{staticClass:"hs-container"},[s("c-header",{attrs:{title:t.$t("base.ForgetPassword"),isBackNav:""}}),t._v(" "),s("div",{staticClass:"title"},[s("h1",[t._v(t._s(t.$t("base.FillInYourBoundEmailAddress")))])]),t._v(" "),s("div",{staticClass:"information"},[s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell"},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/login/company-.png')"}}),t._v(" "),s("input",{directives:[{name:"model",rawName:"v-model",value:t.details.CmpId,expression:"details.CmpId"}],attrs:{maxlength:"50",placeholder:t.$t("base.UnitNumberOrUnitName")},domProps:{value:t.details.CmpId},on:{input:function(e){e.target.composing||t.$set(t.details,"CmpId",e.target.value)}}})])]),t._v(" "),s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell"},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/login/user-.png')"}}),t._v(" "),s("input",{directives:[{name:"model",rawName:"v-model",value:t.details.UserName,expression:"details.UserName"}],attrs:{maxlength:"50",placeholder:t.$t("base.Username")},domProps:{value:t.details.UserName},on:{input:function(e){e.target.composing||t.$set(t.details,"UserName",e.target.value)}}})])]),t._v(" "),s("hs-cell-1",{attrs:{showLogo:!1}},[s("div",{staticClass:"custom-cell"},[s("div",{staticClass:"logo",staticStyle:{"background-image":"url('static/image/login/forget-password/email.png')"}}),t._v(" "),s("input",{directives:[{name:"model",rawName:"v-model",value:t.details.Email,expression:"details.Email"}],attrs:{maxlength:"50",placeholder:t.$t("base.Email")},domProps:{value:t.details.Email},on:{input:function(e){e.target.composing||t.$set(t.details,"Email",e.target.value)}}})])])],1),t._v(" "),s("hs-gradient-button",{staticStyle:{"margin-top":"50px"},attrs:{title:t.$t("base.NextStep")},on:{click:t._nextStep}})],1)},staticRenderFns:[]};var c=s("VU/8")(o,r,!1,function(t){s("bCf5")},"data-v-92291304",null);e.default=c.exports}});
//# sourceMappingURL=30.12749be6c94c78628c95.js.map