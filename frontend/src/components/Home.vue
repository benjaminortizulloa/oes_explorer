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
            :width="width"
            :height="height"
          />
        </div>
      </div>

      <div
        cols="3"
        style="position: absolute; border: solid black 3px; height: 100%; width: 30%; right: 0;"
      >
        <p>{{infoTxt}}</p>
      </div>
    </div>
  </v-card>
</template>

<script>
import GridSvg from "@/components/GridSvg";
export default {
  name: "Home",
  components: { GridSvg },
  data: () => ({
    infoTxt: "",
    width: 0,
    height: 0
  }),
  methods: {
    stateClick(state) {
      this.infoTxt = JSON.stringify(state);
    },
    setTooltip(tooltip) {
      this.$emit("setTooltip", tooltip);
    },
    matchDiv() {
      console.log(this.$refs.treeContainer);
      this.width = this.$refs.treeContainer.clientWidth;
      this.height = this.$refs.treeContainer.clientHeight;
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
