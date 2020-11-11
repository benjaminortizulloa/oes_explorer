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
      { parent: "a", child: "b", wt: 1 },
      { parent: "a", child: "c", wt: 2 },
      { parent: "a", child: "d", wt: 3 },
      { parent: "", child: "a" }
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

