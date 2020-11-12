<template>
  <v-card style="height: 100%; width: 100%; position: absolute;">
    <div style="top: 5%; left: 2%; height: 90%; width: 96%; position: absolute;">
      <div
        style="position: absolute; border: solid black 3px; height: 100%; width: 65%"
        class="pa-0"
        ref="treeContainer"
      >
        <div class="pa-0 ma-0" style="height: 100%;">
          <GridSvg
            @stateClick="stateClick"
            @setTooltip="setTooltip"
            :width="treeWidth"
            :height="treeHeight"
          />
        </div>
      </div>
      <div
        style="position: absolute; border: solid black 3px; height: 100%; width: 30%; right: 0; overflow-y: scroll"
        ref="sideContainer"
      >
        <SideBar :info="info" :maxX="maxPct" :width="sideWidth" :height="sideHeight"/>
      </div>
    </div>
  </v-card>
</template>

<script>
import GridSvg from "@/components/GridSvg";
import SideBar from "@/components/SideBar";
export default {
  name: "Home",
  components: { GridSvg, SideBar },
  data: () => ({
    info: [],
    maxPct: 0,
    treeWidth: 0,
    treeHeight: 0,
    sideWidth: 0,
    sideHeight: 0
  }),
  methods: {
    stateClick(state) {
      this.info = state.data.data
        .filter(d => d.a_pct90)
        .sort((a, b) => b.a_pct90 - a.a_pct90);
      this.maxPct = Math.max(...this.info.map(d => d.a_pct90));
    },
    setTooltip(tooltip) {
      this.$emit("setTooltip", tooltip);
    },
    matchDiv() {
      this.treeWidth = this.$refs.treeContainer.clientWidth;
      this.treeHeight = this.$refs.treeContainer.clientHeight;
      this.sideWidth = this.$refs.sideContainer.clientWidth;
      this.sideHeight = this.$refs.sideContainer.clientHeight;
    }
  },
  mounted() {
    this.matchDiv();
  },
  created() {
    window.addEventListener("resize", this.matchDiv);
  },
  destroyed() {
    window.removeEventListener("resize", this.matchDiv);
  }
};
</script>
