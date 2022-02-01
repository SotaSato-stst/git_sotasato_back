<template>
  <el-button
    type="warning"
    icon="el-icon-star-off"
    size="mini"
    class="favorite"
    plain
  >
    保存
  </el-button>
</template>

<script lang="ts">
import {defineComponent, PropType} from '@nuxtjs/composition-api'
import {Button} from 'element-ui'
import {Subsidy} from '@/types/Subsidy'
export default defineComponent({
  name: 'SupplierInformation',
  components: {
    [`${Button.name}`]: Button,
  },
  props: {
    subsidy: {
      type: Object as PropType<Subsidy>,
      required: true,
    },
  },
})
</script>

<style lang="postcss" scoped>
.favorite {
  float: right;
}
</style>
