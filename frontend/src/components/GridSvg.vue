<template>
  <svg
    id="gridSvg"
    :width="width"
    :height="height"
    preserveAspectRatio="xMidYMid meet"
    ref="gridSvg"
  >
    <g>
      <rect
        v-for="(state, i) in states"
        :key="'staterect_' + i"
        :width="stateWidth"
        :height="stateHeight"
        :x="(state.col -minCol) * stateWidth"
        :y="(state.row - minRow) * stateHeight"
        stroke="grey"
        stroke-width="1"
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
    </g>
    <Treemap
      v-for="(d,i) in treeData"
      :key="`tree_${i}`"
      :data="treeData[i]"
      :leafParent="leafParent[i]"
      :leafChild="leafChild[i]"
      :treeIndex="i"
      :x="treeX[i]"
      :y="treeY[i]"
      :width="treeWidth[i]"
      :height="treeHeight[i]"
      @leafClick="leafClick"
      :leafOver="leafOver"
      :leafOut="leafOut"
      @exitClick="exitClick(i)"
      :fill="fillColors[i]"
    ></Treemap>
  </svg>
</template>

<script>
import Treemap from "@/components/Treemap";
import { gridMap } from "@/components/mixins/gridMap.js";
import { select, attr } from "d3-selection";
import { transition } from "d3-transition";
import axios from "axios";

export default {
  name: "gridsSvg",
  props: ["width", "height"],
  components: { Treemap },
  data: () => ({
    viewBoxes: [null],
    viewBoxIndex: 0,
    treeData: [null],
    treeX: [null],
    treeY: [null],
    treeWidth: [null],
    treeHeight: [null],
    leafParent: [null],
    leafChild: [null],
    fillColors: [null, "#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e"],
    currentState: null,
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
    },
    currentState(newVal) {
      this.treeData.splice(1, this.treeData.length - (1 + 1));

      newVal.data = newVal.data.concat([
        { area_title: "", naics: newVal.data[0].area_title }
      ]);

      this.leafChild.splice(1, 1, "naics");
      this.leafParent.splice(1, 1, "area_title");

      this.treeData.splice(1, 1, newVal);
    }
  },
  methods: {
    zoomIn(event, index) {
      this.treeX.splice(
        index,
        1,
        this.treeX[index - 1]
          ? this.treeX[index - 1] + event.target.x.baseVal.value
          : event.target.x.baseVal.value
      );

      if (this.treeX.length > index + 1) {
        this.treeX.splice(index + 1, this.treeX.length - index - 1);
      }

      this.treeY.splice(
        index,
        1,
        this.treeY[index - 1]
          ? this.treeY[index - 1] + event.target.y.baseVal.value
          : event.target.y.baseVal.value
      );

      if (this.treeY.length > index + 1) {
        this.treeY.splice(index + 1, this.treeY.length - index - 1);
      }

      this.treeWidth.splice(index, 1, event.target.width.baseVal.value);

      if (this.treeWidth.length > index + 1) {
        this.treeWidth.splice(index + 1, this.treeWidth.length - index - 1);
      }
      this.treeHeight.splice(index, 1, event.target.height.baseVal.value);

      if (this.treeHeight.length > index + 1) {
        this.treeHeight.splice(index + 1, this.treeHeight.length - index - 1);
      }

      this.viewBoxes[index] = `${this.treeX[index]} ${this.treeY[index]} ${
        this.treeWidth[index]
      } ${this.treeHeight[index]}`;
      this.viewBoxIndex = index;

      select(this.$refs.gridSvg)
        .transition()
        .duration(750)
        .attr("viewBox", this.viewBoxes[this.viewBoxIndex]);
    },
    stateClick(state, event) {
      let that = this;

      axios
        .get(`${process.env.VUE_APP_API}/state?state=${state.state}`)
        .then(function(d) {
          that.currentState = d.data;
          that.zoomIn(event, 1);
        })
        .then(function(d) {
          that.$emit("stateClick", state);
        })
        .catch(err => {
          console.log(err);
        });
    },
    leafOver(leaf, event) {
      let clone = Object.assign({}, leaf);
      delete clone.parent;
      let dta = { data: clone, event: event, type: "leaf" };

      this.$emit("setTooltip", dta);
    },
    leafOut() {
      this.$emit("setTooltip", { data: null, event: null, type: null });
    },
    stateOver(state, event) {
      let dta = { data: state, event: event, type: "state" };
      this.$emit("setTooltip", dta);
    },
    stateOut() {
      this.$emit("setTooltip", { data: null, event: null, type: null });
    },
    leafClick(data) {
      console.log("leafClick", data);

      this.leafFunctions(data.type, data);
      if (data.type) this.zoomIn(data.event, data.treeIndex);
    },
    exitClick(index) {
      this.viewBoxIndex = index - 1;
      this.treeX.splice(index, 1, null);
      this.treeY.splice(index, 1, null);
      this.treeWidth.splice(index, 1, null);
      this.treeHeight.splice(index, 1, null);
      this.treeData.splice(index, 1);

      select(this.$refs.gridSvg)
        .transition()
        .duration(750)
        .attr("viewBox", this.viewBoxes[this.viewBoxIndex]);
    },
    leafFunctions(type, dta) {
      let that = this;
      let parent = dta.leaf.id;
      that.treeData.splice(dta.treeIndex);

      if ((type == "state") | (type == "naics")) {
        console.log("stateleaffunction", dta);
        let qry = `${process.env.VUE_APP_API}/naics?state=${
          dta.leaf.data.area_title
        }&naicsCode=${dta.leaf.data.naics}&industry=${dta.treeIndex + 1}`;

        axios
          .get(qry)
          .then(function(res) {
            let resData = res.data;
            resData.data = resData.data
              .map(function(d) {
                d.parent = parent;
                return d;
              })
              .concat({ parent: "", naics: parent });

            that.leafParent.splice(dta.treeIndex, 1, "parent");
            that.leafChild.splice(dta.treeIndex, 1, "naics");

            that.treeData.splice(dta.treeIndex, 1, resData);
            that.zoomIn(dta.event, dta.treeIndex);
          })
          .catch(err => {
            console.log(err);
          });
      }

      if (type == "naics") {
      }
    }
  },
  mounted() {
    select(this.$refs.gridSvg).attr("viewBox", null);
    this.viewBoxes[0] = this.baseViewBox;
    select(this.$refs.gridSvg).attr("viewBox", this.viewBoxes[0]);
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

