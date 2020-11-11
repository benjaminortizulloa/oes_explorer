<template>
  <svg id="gridSvg" width="100%" height="100%" ref="gridSvg">
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
</template>

<script>
import { gridMap } from "@/components/mixins/gridMap.js";

export default {
  name: "gridsSvg",
  data: () => ({
    width: 100,
    height: 100
  }),
  mixins: [gridMap],
  computed: {
    stateWidth() {
      return this.width / (this.maxCol - this.minCol);
    },
    stateHeight() {
      return this.height / (this.maxRow - this.minRow);
    }
  },
  methods: {
    matchSvg() {
      this.width = this.$refs.gridSvg.clientWidth;
      this.height = this.$refs.gridSvg.clientHeight;
    },
    stateClick(state, event) {
      console.log(event);
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
