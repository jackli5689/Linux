webpackJsonp([37],{IfGJ:function(e,r,t){"use strict";Object.defineProperty(r,"__esModule",{value:!0});var a={created:function(){var e=this.$route.query.productId,r=this.$route.query.OrderType;if(e)switch(Number(r)){case 1:this.$router.replace({path:"/planeTicket/orderDetails",query:{Id:e,isOwner:!0}});break;case 2:this.$router.replace({path:"/hotel/orderDetails",query:{Id:e,isOwner:!0}});break;case 11:this.$router.replace({path:"/inter-hotel/orderDetails",query:{Id:e,isOwner:!0}});break;case 10:this.$router.replace({path:"/train/orderDetail",query:{Id:e,isOwner:!0}})}else this.$router.replace("/home")}},i={render:function(){var e=this.$createElement;return(this._self._c||e)("div")},staticRenderFns:[]};var s=t("VU/8")(a,i,!1,function(e){t("R9e8")},"data-v-7b7577ba",null);r.default=s.exports},R9e8:function(e,r){}});
//# sourceMappingURL=37.abb1513a423fe6afdc58.js.map