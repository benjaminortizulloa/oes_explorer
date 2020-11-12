<template>
  <g v-if="(leaves)" :transform="`translate(${x}, ${y})`" :ref="`myTree${treeIndex}`">
    <rect :width="width" :height="height" fill-opacity="0"/>
    <circle
      :cx="paddingTop + paddingTop/10"
      :cy="paddingTop/2"
      :r="paddingTop/2 - paddingTop/10 * 2"
      :fill="fill"
      @click="exitClick"
    />
    <g v-for="(leaf, i) in leaves" :key="i" class="leaf">
      <rect
        :x="leaf.x0"
        :y="leaf.y0"
        :width="leaf.x1 - leaf.x0"
        :height="leaf.y1 - leaf.y0"
        :fill="fill"
        fill-opacity=".9"
        @mousemove="leafOver(leaf, $event)"
        @mouseout="leafOut(leaf, $event)"
        @click="leafClick(leaf, $event, treeIndex)"
      />
      <text
        style="pointer-events: none"
        :x="leaf.x0"
        :y="leaf.y0 + (leaf.y1 - leaf.y0)/2"
      >{{leaf.data.naics_title}}</text>
    </g>
  </g>
</template>

<script>
import { gridMap } from "@/components/mixins/gridMap.js";
import { select, selectAll, attr } from "d3-selection";
import { transition } from "d3-transition";
import { stratify, treemap } from "d3-hierarchy";

export default {
  name: "Treemap",
  props: [
    "data",
    "x",
    "y",
    "width",
    "height",
    "leafOver",
    "leafOut",
    "fill",
    "treeIndex",
    "leafChild",
    "leafParent"
  ],
  data: () => ({}),
  computed: {
    paddingTop() {
      return this.height / 10;
    },
    leaves() {
      if (
        !(
          (!!this.x | (this.x == 0)) &
          (!!this.y | (this.y == 0)) &
          !!this.width &
          !!this.height
        )
      ) {
        return null;
      }

      if (!this.data) {
        return null;
      }
      let that = this;
      let strat = stratify()
        .id(function(d) {
          return d[that.leafChild];
        })
        .parentId(function(d) {
          return d[that.leafParent];
        });

      let root = strat(this.data.data);
      root.sum(function(d) {
        return +d.tot_emp;
      });

      let p;

      if (this.height < this.width) {
        p = this.height / 100;
      } else {
        p = this.width / 100;
      }
      let pTop = this.paddingTop;
      treemap()
        .size([this.width, this.height])
        .padding(p)
        .paddingTop(pTop)(root);

      return root.leaves();
    }
  },
  methods: {
    exitClick() {
      this.$emit("exitClick");
    },
    leafClick(leaf, event, treeIndex) {
      if (leaf.data.hasChildren) {
        this.$emit("leafClick", {
          leaf: leaf,
          event: event,
          treeIndex: treeIndex + 1,
          type: this.data.type
        });
      }
    }
  },
  created() {
    this.$nextTick(function() {
      let myRef = `myTree${this.treeIndex}`;
      select(this.$refs[myRef])
        .selectAll("text")
        .attr("font-size", null);
      select(this.$refs[myRef])
        .selectAll(".leaf")
        .select("text")
        .attr("font-size", function(d) {
          let txtBBox = this.getBBox();
          let rectBbox = select(this.parentNode)
            .select("rect")
            .node()
            .getBBox();
          let widthTransform = rectBbox.width / txtBBox.width;
          let heightTransform = rectBbox.height / txtBBox.height;
          let value =
            widthTransform < heightTransform ? widthTransform : heightTransform;

          return `${value}em`;
          // return `matrix(${value}, 0, 0, ${value}, 0,0)`;
        });
    });
  }
};
</script>
<style>
</style>

