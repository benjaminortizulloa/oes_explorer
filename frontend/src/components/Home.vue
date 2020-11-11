<template>
  <v-container style="height: 100%;">
    <v-row class="text-center" style="height: 100%;">
      <v-spacer></v-spacer>
      <v-col cols="10" style="background: blue;">
        <svg width="100%" height="100%"></svg>
      </v-col>
      <v-spacer></v-spacer>
    </v-row>
  </v-container>
</template>

<script>
import { gridMap } from "@/components/mixins/gridMap.js";

export default {
  name: "Home",
  data: () => ({}),
  mixins: [gridMap]
};
</script>
