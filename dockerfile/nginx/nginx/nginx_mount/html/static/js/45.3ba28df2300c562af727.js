webpackJsonp([45],{I90D:function(t,e){},bWN6:function(t,e,i){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n={mounted:function(){this._initDetails()},data:function(){return{map:void 0,details:{Latitude:null,Longitude:null,Content:null}}},methods:{_initDetails:function(){this.details.Latitude=this.$route.query.Latitude,this.details.Longitude=this.$route.query.Longitude,this.details.Content=this.$route.query.Content,this._initMap()},_initMap:function(){var t={center:{lat:Number(this.details.Latitude),lng:Number(this.details.Longitude)},zoom:15,scrollwheel:!0,disableDefaultUI:!0};this.map=new window.google.maps.Map(document.getElementById("map"),t);var e=new window.google.maps.Marker({position:t.center});e.setMap(this.map);var i=new window.google.maps.InfoWindow({content:this.details.Content});e.addListener("click",function(){i.open(this.map,e)}),i.open(this.map,e)}}},a={render:function(){this.$createElement;this._self._c;return this._m(0)},staticRenderFns:[function(){var t=this.$createElement,e=this._self._c||t;return e("div",{staticClass:"hs-container"},[e("div",{staticStyle:{width:"100%",height:"100%"},attrs:{id:"map"}})])}]};var s=i("VU/8")(n,a,!1,function(t){i("I90D")},"data-v-665fbbce",null);e.default=s.exports}});
//# sourceMappingURL=45.3ba28df2300c562af727.js.map