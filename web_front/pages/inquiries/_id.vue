<template>
  <div v-if="subsidy" class="subsidy-detail-container">
    <el-card>
      <div class="title">「{{ subsidy.title }}」のお問い合わせ</div>
      <div class="description">
        こちらのフォームよりお問い合わせください。
        <br />
        後日担当者からご案内の連絡をさせていただきます。
      </div>
      <div id="hubspot"></div>
    </el-card>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  onMounted,
  onUnmounted,
  computed,
  useRoute,
} from '@nuxtjs/composition-api'
import {subsidiesModule} from '@/store'
import {ShowHubspotInquiryForm} from '@/services/hubspot'

export default defineComponent({
  name: 'SubsidyInquiryPage',
  layout: ctx => (ctx.$device.isMobile ? 'mobile' : 'recent'),
  setup(_props) {
    const route = useRoute()
    const pageId = Number(route.value.params.id)
    const subsidy = computed(() => subsidiesModule.subsidy)

    onMounted(async () => {
      await subsidiesModule.getSubsidy(pageId)
      ShowHubspotInquiryForm('#hubspot')
    })

    onUnmounted(() => {
      subsidiesModule.setSubsidy(null)
    })

    return {subsidy}
  },
  head(): object {
    return {
      title: `${this.subsidy?.title}の問い合わせ`,
    }
  },
})
</script>

<style lang="postcss" scoped>
.subsidy-detail-container {
  padding: var(--spacing-5);
}

.title {
  font-size: var(--title-font-size);
  font-weight: bold;
}

.description {
  padding: var(--spacing-4);
  color: var(--text-font-color);
  font-size: 14px;
}

#hubspot {
  padding: var(--spacing-4);
}
</style>
