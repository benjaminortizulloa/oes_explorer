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
      @click="stateClick(state)"
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
    stateClick(state) {
      this.$emit("stateClick", state);
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
