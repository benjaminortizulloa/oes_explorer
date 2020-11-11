<template>
  <v-card v-if="tooltip.type" :style="tooltipStyle" class="pa-2">
    <p>{{JSON.stringify(tooltip)}}</p>
  </v-card>
</template>

<script>
export default {
  name: "Tooltip",
  props: ["tooltip"],
  data: () => ({
    infoTxt: ""
  }),
  computed: {
    tooltipStyle() {
      let style = {
        width: "25%",
        backgroundColor: "lightgrey",
        left: this.tooltip.event.clientX + "px",
        position: "fixed"
      };

      if (this.tooltip.event.clientY > window.innerHeight / 2) {
        style.bottom = window.innerHeight - this.tooltip.event.clientY + "px";
      } else {
        style.top = this.tooltip.event.clientY + "px";
      }

      return style;
    }
  },
  methods: {}
};
</script>
