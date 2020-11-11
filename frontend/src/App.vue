<template>
  <v-app>
    <v-app-bar app style="background-color: purple;" dark>
      <v-spacer></v-spacer>
      <h1>OES Explorer [2019]</h1>
      <v-spacer></v-spacer>
    </v-app-bar>

    <v-main>
      <Home @stateOver="setTooltip"/>
      <Tooltip :tooltip="tooltip"/>
    </v-main>
  </v-app>
</template>

<script>
import Home from "./components/Home";
import Tooltip from "./components/Tooltip";
export default {
  name: "App",

  components: {
    Home,
    Tooltip
  },
  data: () => ({
    tooltip: { data: null, event: null, type: null }
  }),
  methods: {
    setTooltip(data) {
      this.tooltip = data;
    }
  }
};
</script>
