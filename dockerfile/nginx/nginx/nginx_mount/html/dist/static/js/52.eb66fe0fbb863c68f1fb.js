webpackJsonp([52],{cgb3:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=i("Dd8w"),o=i.n(n),r=i("NYxO"),a=i("gyMJ"),s={mounted:function(){this._initWechatShare()},computed:o()({},Object(r.c)(["direction","isMiniprogram"])),data:function(){return{wimg:window.location.protocol+"//"+window.location.host+"/static/image/base/logo_70.png",wurl:window.location.protocol+"//"+window.location.host+"/#/wechatShare",wdesc:"全国服务热线: 4006-123-123",wtit:"恒顺旅行",version:window.localStorage.version}},methods:o()({},Object(r.d)(["SET_IS_MINIPROGRAM","SET_IS_WECHAT_BROWSER"]),{_initView:function(){window.WeixinJSBridge&&WeixinJSBridge.invoke?this._ready():document.addEventListener("WeixinJSBridgeReady",this._ready(),!1)},_ready:function(){this.SET_IS_MINIPROGRAM("miniprogram"===window.__wxjs_environment);var e=window.navigator.userAgent.toLowerCase();this.SET_IS_WECHAT_BROWSER(/micromessenger/.test(e))},_initWechatShare:function(){var e=this,t={AbsoluteUri:window.location.href.split("#")[0]};Object(a._68)(t).then(function(t){e._setWechatConfig(t.ResultData)})},_setWechatConfig:function(e){wx.config({debug:!1,appId:e.AppId,timestamp:e.Timestamp,nonceStr:e.NonceStr,signature:e.Signature,jsApiList:["onMenuShareTimeline","onMenuShareAppMessage"]}),this._shareMsg()},_shareMsg:function(){var e=this;wx.ready(function(){e._initView(),wx.onMenuShareTimeline({title:e.wtit,link:e.wurl,imgUrl:e.wimg},function(e){}),wx.onMenuShareAppMessage({title:e.wtit,desc:e.wdesc,link:e.wurl,imgUrl:e.wimg},function(e){})})}})},c={render:function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{staticClass:"hs-base-component"},[e.isMiniprogram?[i("keep-alive",[e.$route.meta.keepAlive?i("router-view",{staticClass:"router-view"}):e._e()],1),e._v(" "),e.$route.meta.keepAlive?e._e():i("router-view",{staticClass:"router-view"})]:[i("transition",{attrs:{name:"vux-pop-"+("forward"===e.direction?"in":"out")}},[i("keep-alive",[e.$route.meta.keepAlive?i("router-view",{staticClass:"router-view"}):e._e()],1)],1),e._v(" "),i("transition",{attrs:{name:"vux-pop-"+("forward"===e.direction?"in":"out")}},[e.$route.meta.keepAlive?e._e():i("router-view",{staticClass:"router-view"})],1)]],2)},staticRenderFns:[]};var u=i("VU/8")(s,c,!1,function(e){i("h9x5")},"data-v-3f3baadd",null);t.default=u.exports},h9x5:function(e,t){}});
//# sourceMappingURL=52.eb66fe0fbb863c68f1fb.js.map