<template>
  <transition name="tree">
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
    </svg>
  </transition>
</template>

<script>
import { gridMap } from "@/components/mixins/gridMap.js";
import { select, attr } from "d3-selection";
import { transition } from "d3-transition";

export default {
  name: "gridsSvg",
  props: ["width", "height"],
  data: () => ({
    viewBoxes: [null],
    viewBoxIndex: 0
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
      this.viewBoxes[1] = `${event.target.x.baseVal.value} ${
        event.target.y.baseVal.value
      } ${event.target.width.baseVal.value} ${
        event.target.height.baseVal.value
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
  },
  mounted() {
    this.matchSvg();
  },
  created() {
    window.addEventListener("resize", this.matchSvg);
  },
  destroyed() {
    window.removeEventListener("resize", this.matchSvg);
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

