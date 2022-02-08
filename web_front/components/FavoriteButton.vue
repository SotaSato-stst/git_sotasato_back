<template>
  <el-button
    type="warning"
    icon="el-icon-star-off"
    size="mini"
    class="favorite"
    :plain="!favorite"
    @click="clickButton(subsidy)"
  >
    保存
  </el-button>
</template>

<script lang="ts">
import {defineComponent, PropType, ref} from '@nuxtjs/composition-api'
import {Button} from 'element-ui'
import {Subsidy} from '@/types/Subsidy'
import {subsidiesModule} from '@/store'
export default defineComponent({
  name: 'FavoriteButton',
  components: {
    [`${Button.name}`]: Button,
  },
  props: {
    subsidy: {
      type: Object as PropType<Subsidy>,
      required: true,
    },
  },
  setup(props) {
    const favorite = ref(props.subsidy.favorite)
    const clickButton = (subsidy: Subsidy) => {
      if (favorite.value) {
        subsidiesModule.destroyUserFavoriteSubsidy(subsidy.id)
      } else {
        subsidiesModule.postUserFavoriteSubsidy(subsidy.id)
      }
      favorite.value = !favorite.value
    }

    return {
      clickButton,
      favorite,
    }
  },
})
</script>

<style lang="postcss" scoped>
.favorite {
  float: right;
}
</style>
