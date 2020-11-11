<template>
  <g v-if="(leaves)" :transform="`translate(${x}, ${y})`">
    <rect :width="width" :height="height" fill-opacity="0"/>
    <rect
      v-for="(leaf, i) in leaves"
      :key="i"
      :x="leaf.x0"
      :y="leaf.y0"
      :width="leaf.x1 - leaf.x0"
      :height="leaf.y1 - leaf.y0"
      fill="grey"
      fill-opacity=".9"
      @mousemove="leafOver(leaf, $event)"
      @mouseout="leafOut"
    />
  </g>
</template>

<script>
import { gridMap } from "@/components/mixins/gridMap.js";
import { select, attr } from "d3-selection";
import { transition } from "d3-transition";
import { stratify, treemap } from "d3-hierarchy";

export default {
  name: "Treemap",
  props: ["data", "x", "y", "width", "height"],
  data: () => ({}),
  computed: {
    leaves() {
      if (!(!!this.x & !!this.y & !!this.width & !!this.height)) return null;
      let strat = stratify()
        .id(function(d) {
          return d.naics;
        })
        .parentId(function(d) {
          return d.area_title;
        });

      let root = strat(this.data);
      root.sum(function(d) {
        return +d.tot_emp;
      });

      let p;

      if (this.height < this.width) {
        p = this.height / 100;
      } else {
        p = this.width / 100;
      }
      let pTop = this.height / 10;
      treemap()
        .size([this.width, this.height])
        .padding(p)
        .paddingTop(pTop)(root);
      console.log("leaves", root.leaves());
      return root.leaves();
    }
  },
  methods: {
    leafOver(leaf, event) {
      let clone = Object.assign({}, leaf);
      delete clone.parent;
      let dta = { data: clone, event: event, type: "leaf" };
      console.log("leaf", leaf);
      console.log("clone", clone);
      this.$emit("leafOver", dta);
    },
    leafOut() {
      this.$emit("leafOver", { data: null, event: null, type: null });
    }
  }
};
</script>
<style>
</style>

