<template>
  <v-card style="height: 100%; width: 100%; position: absolute;">
    <v-row style="top: 5%; left: 2%; height: 90%; width: 96%; position: absolute;">
      <v-col cols="9" style="border: solid black 3px;" fill-height>
        <GridSvg @stateClick="stateClick" @stateOver="stateOver"/>
      </v-col>
      <v-spacer></v-spacer>
      <v-col cols="3" style="border: solid black 3px;">
        <p>{{infoTxt}}</p>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import GridSvg from "@/components/GridSvg";
export default {
  name: "Home",
  components: { GridSvg },
  data: () => ({
    infoTxt: ""
  }),
  methods: {
    stateClick(state) {
      this.infoTxt = JSON.stringify(state);
    },
    stateOver(state) {
      this.$emit("stateOver", state);
    }
  }
};
</script>
