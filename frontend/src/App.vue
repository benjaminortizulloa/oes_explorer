<template>
  <v-app>
    <v-app-bar app color="primary" dark>
      <v-spacer></v-spacer>
      <h1>OES Explorer [2019]</h1>
      <v-spacer></v-spacer>
    </v-app-bar>

    <v-main>
      <Home/>
    </v-main>
  </v-app>
</template>

<script>
import Home from "./components/Home";

export default {
  name: "App",

  components: {
    Home
  },

  data: () => ({
    //
  })
};
</script>
