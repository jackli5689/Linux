webpackJsonp([26],{"3pzJ":function(e,t){},"4DMv":function(e,t,s){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var a=s("mvHQ"),i=s.n(a),n=s("CCVD"),o=s("yyVE"),d=s("gyMJ"),r={created:function(){this._setCountDown()},computed:{details:function(){return JSON.parse(this.$route.query.details)}},data:function(){return{timeSecond:0,receivedCode:""}},methods:{_setCountDown:function(){var e=this;this.timeSecond=60;var t=setInterval(function(){--e.timeSecond<=0&&clearInterval(t)},1e3)},_sendMessage:function(){var e=this;this._setCountDown(),Object(d._55)(this.details).then(function(t){!0===t.ResultData&&e.$toast(e.$t("TM.SendSucceed"))})},_nextStep:function(){var e=this,t={Mobile:this.details.Mobile,Code:this.receivedCode};Object(d._48)(t).then(function(t){!0===t.ResultData&&(e.details.Code=e.receivedCode,e.$router.push({path:"/forgetPasswordStep3",query:{details:i()(e.details)}}))})}},components:{CHeader:n.a,HsGradientButton:o.a}},c={render:function(){var e=this,t=e.$createElement,s=e._self._c||t;return s("div",{staticClass:"hs-container"},[s("c-header",{attrs:{title:e.$t("base.ForgetPassword"),isBackNav:""}}),e._v(" "),s("div",{staticClass:"title"},[s("h1",[e._v(e._s(e.$t("base.SecondStep")))]),e._v(" "),s("p",[e._v(e._s(e.$t("base.WeHaveSent"))),e.details?s("span",[e._v(e._s(e.details.Mobile))]):e._e(),e._v(e._s(e.$t("base.AVerificationMessagePleaseEnterTheVerificationCodeYouReceived")))])]),e._v(" "),s("div",{staticClass:"information"},[s("input",{directives:[{name:"model",rawName:"v-model",value:e.receivedCode,expression:"receivedCode"}],attrs:{maxlength:"50",placeholder:e.$t("base.VerificationCode")},domProps:{value:e.receivedCode},on:{input:function(t){t.target.composing||(e.receivedCode=t.target.value)}}}),e._v(" "),e.timeSecond>0?s("div",{staticClass:"send send-disable"},[s("p",[e._v(e._s(e.$t("base.Resend")))]),s("p",[e._v("("+e._s(e.timeSecond)+"s)")])]):s("div",{staticClass:"send",on:{click:e._sendMessage}},[e._v(e._s(e.$t("base.Resend")))])]),e._v(" "),s("hs-gradient-button",{staticStyle:{"margin-top":"50px"},attrs:{title:e.$t("base.NextStep")},on:{click:e._nextStep}})],1)},staticRenderFns:[]};var l=s("VU/8")(r,c,!1,function(e){s("3pzJ")},"data-v-c042dbaa",null);t.default=l.exports}});
//# sourceMappingURL=26.3c5c86a58d9c8ca01666.js.map