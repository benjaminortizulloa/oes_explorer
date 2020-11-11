<template>
  <v-container style="height: 100%;">
    <v-row class="text-center" style="height: 100%;">
      <v-spacer></v-spacer>
      <v-col cols="10" style="background: blue;">
        <GridSvg/>
      </v-col>
      <v-spacer></v-spacer>
    </v-row>
  </v-container>
</template>

<script>
import GridSvg from "@/components/GridSvg";
export default {
  name: "Home",
  components: { GridSvg },
  data: () => ({})
};
</script>
