<template>
  <svg
    id="gridSvg"
    :width="width"
    :height="height"
    preserveAspectRatio="xMidYMid meet"
    ref="gridSvg"
  >
    <rect
      v-for="(state, i) in states"
      :key="'staterect_' + i"
      :width="stateWidth"
      :height="stateHeight"
      :x="(state.col -minCol) * stateWidth"
      :y="(state.row - minRow) * stateHeight"
      stroke="grey"
      @click="stateClick(state, $event)"
      @mousemove="stateOver(state, $event)"
      @mouseout="stateOut"
    ></rect>
    <text
      v-for="(state, i) in states"
      :key="'statetext_' +i"
      :width="stateWidth"
      :height="stateHeight"
      :x="(state.col -minCol) * stateWidth + stateWidth/2"
      :y="(state.row - minRow) * stateHeight + stateHeight/2"
      fill="white"
      text-anchor="middle"
      style="pointer-events: none;"
    >{{state.code}}</text>
    <Treemap :data="fakeData" :x="treeX" :y="treeY" :width="treeWidth" :height="treeHeight"></Treemap>
  </svg>
</template>

<script>
import Treemap from "@/components/Treemap";
import { gridMap } from "@/components/mixins/gridMap.js";
import { select, attr } from "d3-selection";
import { transition } from "d3-transition";

export default {
  name: "gridsSvg",
  props: ["width", "height"],
  components: { Treemap },
  data: () => ({
    viewBoxes: [null],
    viewBoxIndex: 0,
    treeX: null,
    treeY: null,
    treeWidth: null,
    treeHeight: null,
    fakeData: [
      { area_title: "Pennsylvania", naics: "62", tot_emp: 1040850 },
      { area_title: "Pennsylvania", naics: "44-45", tot_emp: 619940 },
      { area_title: "Pennsylvania", naics: "31-33", tot_emp: 570490 },
      { area_title: "Pennsylvania", naics: "61", tot_emp: 503480 },
      { area_title: "Pennsylvania", naics: "72", tot_emp: 478000 },
      { area_title: "Pennsylvania", naics: "54", tot_emp: 354860 },
      { area_title: "Pennsylvania", naics: "99", tot_emp: 325440 },
      { area_title: "Pennsylvania", naics: "56", tot_emp: 323580 },
      { area_title: "Pennsylvania", naics: "48-49", tot_emp: 306900 },
      { area_title: "Pennsylvania", naics: "23", tot_emp: 263170 },
      { area_title: "Pennsylvania", naics: "52", tot_emp: 262180 },
      { area_title: "Pennsylvania", naics: "42", tot_emp: 216440 },
      { area_title: "Pennsylvania", naics: "81", tot_emp: 196980 },
      { area_title: "Pennsylvania", naics: "55", tot_emp: 135620 },
      { area_title: "Pennsylvania", naics: "71", tot_emp: 96540 },
      { area_title: "Pennsylvania", naics: "51", tot_emp: 86970 },
      { area_title: "Pennsylvania", naics: "53", tot_emp: 64200 },
      { area_title: "Pennsylvania", naics: "21", tot_emp: 28570 },
      { area_title: "Pennsylvania", naics: "22", tot_emp: 23440 },
      { area_title: "Pennsylvania", naics: "11", tot_emp: 3940 },
      { area_title: "", naics: "Pennsylvania" }
    ]
  }),
  mixins: [gridMap],
  computed: {
    stateWidth() {
      return this.width / (this.maxCol - this.minCol);
    },
    stateHeight() {
      return this.height / (this.maxRow - this.minRow);
    },
    baseViewBox() {
      return `0 0 ${this.width} ${this.height}`;
    }
  },
  watch: {
    baseViewBox(newVal) {
      select(this.$refs.gridSvg).attr("viewBox", null);
      this.viewBoxes[0] = newVal;
      select(this.$refs.gridSvg).attr("viewBox", this.viewBoxes[0]);
    }
  },
  methods: {
    stateClick(state, event) {
      this.treeX = event.target.x.baseVal.value;
      this.treeY = event.target.y.baseVal.value;
      this.treeWidth = event.target.width.baseVal.value;
      this.treeHeight = event.target.height.baseVal.value;

      this.viewBoxes[1] = `${this.treeX} ${this.treeY} ${this.treeWidth} ${
        this.treeHeight
      }`;
      this.viewBoxIndex = 1;

      select(this.$refs.gridSvg)
        .transition()
        .duration(750)
        .attr("viewBox", this.viewBoxes[this.viewBoxIndex]);

      this.$emit("stateClick", state);
    },
    stateOver(state, event) {
      let dta = { data: state, event: event, type: "state" };
      this.$emit("stateOver", dta);
    },
    stateOut() {
      this.$emit("stateOver", { data: null, event: null, type: null });
    }
  }
};
</script>
<style>
.treeZoom-enter-active,
.treeZoom-fade-leave-active {
  transition: opacity 0.25s ease-out;
}
.treeZoom-enter,
.treeZoom-leave-to {
  opacity: 0;
}
</style>

