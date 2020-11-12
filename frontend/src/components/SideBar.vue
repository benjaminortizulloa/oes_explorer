<template>
  <div v-if="info.length" :style="divStyle">
    <div v-for="(dta, i) in info" :key="i" class="data">
      <p style="text-align:center;">{{dta.naics_title}}</p>
      <svg height="50px" :width="width">
        <line
          :x1="xLocation(dta[`${salaryType}_pct10`])"
          y1="25"
          :x2="xLocation(dta[`${salaryType}_pct90`])"
          y2="25"
          stroke-width="3"
          stroke="black"
        ></line>
        <line
          :x1="xLocation(dta[`${salaryType}_pct25`])"
          y1="25"
          :x2="xLocation(dta[`${salaryType}_pct75`])"
          y2="25"
          stroke-width="11"
          stroke="grey"
        ></line>
        <circle
          r="5"
          cy="25"
          :cx="xLocation(dta[`${salaryType}_mean`])"
          fill="blue"
          @mouseover="mouseOver(`Mean salary for ${dta.naics_title} is ${dta[salaryType + '_mean']}`, $event)"
          @mouseout="mouseOut"
        ></circle>
        <circle
          r="5"
          cy="25"
          :cx="xLocation(dta[`${salaryType}_median`])"
          fill="red"
          @mouseover="mouseOver(`Median salary for ${dta.naics_title} is ${dta[salaryType + '_median']}`, $event)"
          @mouseout="mouseOut"
        ></circle>
      </svg>
    </div>
  </div>
</template>

<script>
import { scaleLinear } from "d3-scale";

export default {
  name: "SideBar",
  props: ["info", "width", "height", "maxX", "isAnnual", "top"],
  data: () => ({
    divStyle: {
      position: "absolute",
      width: "100%",
      overflowY: "scroll",
      height: 500 + "px",
      top: 50 + "px"
    }
  }),
  computed: {
    salaryType() {
      if (this.isAnnual) return "a";
      return "h";
    }
  },
  watch: {
    height(newVal) {
      this.$set(this.divStyle, "height", newVal + "px");
    }
  },
  methods: {
    mouseOver(data, event) {
      let dta = { data: data, event: event, type: "message", message: data };

      this.$emit("setTooltip", dta);
    },
    mouseOut() {
      this.$emit("setTooltip", { data: null, event: null, type: null, message: null });
    },
    xLocation(d) {
      let that = this;
      let scaleX = scaleLinear()
        .domain([0, that.maxX[that.salaryType]])
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
