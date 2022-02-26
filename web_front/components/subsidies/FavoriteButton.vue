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
import {getAnalytics, logEvent} from 'firebase/analytics'
import {Subsidy} from '@/types/Subsidy'
import {favoriteSubsidiesModule} from '@/store'
export default defineComponent({
  name: 'FavoriteButton',
  props: {
    subsidy: {
      type: Object as PropType<Subsidy>,
      required: true,
    },
  },
  setup(props) {
    const favorite = ref(props.subsidy.favorite)
    const analytics = getAnalytics()

    const clickButton = (subsidy: Subsidy) => {
      if (favorite.value) {
        favoriteSubsidiesModule.destroyUserFavoriteSubsidy(subsidy.id)
      } else {
        favoriteSubsidiesModule.postUserFavoriteSubsidy(subsidy.id)
        logEvent(analytics, 'add_favorite', {
          content_type: 'subsidy',
          content_id: subsidy.id,
          subsidy_title: subsidy.title,
        })
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

.favorite.is-plain:hover,
.favorite.is-plain:focus {
  color: #e6a23c;
  background: #fdf6ec;
  border-color: #f5dab1;
}
</style>
