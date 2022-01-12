<template>
  <container><subsidy-card>Card</subsidy-card></container>
</template>

<script lang="ts">
import Vue from 'vue'
import {Container} from 'element-ui'
import SubsidyCard from './../components/SubsidyCard.vue'

export default Vue.extend({
  name: 'IndexPage',
  components: {SubsidyCard, Container},
})
</script>
