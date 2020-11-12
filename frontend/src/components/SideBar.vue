<template>
  <div v-if="info.length" style="position: absolute; height: 100%; width: 100%;">
    <div v-for="(dta, i) in info" :key="i" class="data">
      <p style="text-align:center;">{{dta.naics_title}}</p>
      <svg height="50px" :width="width">
        <line
          :x1="xLocation(dta.a_pct10)"
          y1="25"
          :x2="xLocation(dta.a_pct90)"
          y2="25"
          stroke-width="3"
          stroke="black"
        ></line>
        <line
          :x1="xLocation(dta.a_pct25)"
          y1="25"
          :x2="xLocation(dta.a_pct75)"
          y2="25"
          stroke-width="11"
          stroke="grey"
        ></line>
        <circle r="5" cy="25" :cx="xLocation(dta.a_mean)" fill="blue"></circle>
        <circle r="5" cy="25" :cx="xLocation(dta.a_median)" fill="red"></circle>
      </svg>
    </div>
  </div>
</template>

<script>
import { scaleLinear } from "d3-scale";

export default {
  name: "SideBar",
  props: ["info", "width", "height", "maxX"],
  data: () => ({}),
  computed: {},
  methods: {
    xLocation(d) {
      let that = this;
      let scaleX = scaleLinear()
        .domain([0, that.maxX])
        .range([10, that.width - 10]);

      return scaleX(d);
    }
  },
  mounted() {}
};
</script>
<style>
.data:nth-of-type(odd) {
  background: #e0e0e0;
}
</style>
