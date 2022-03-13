<template>
  <el-button
    class="inquiry-button"
    type="success"
    size="mini"
    icon="el-icon-user"
    @click="clickedAskButton()"
  >
    この補助金の申請を相談する
  </el-button>
</template>

<script lang="ts">
import {defineComponent, PropType, useRouter} from '@nuxtjs/composition-api'
import {getAnalytics, logEvent} from 'firebase/analytics'
import {Subsidy} from '@/types/Subsidy'
import {routingService} from '@/services/routingService'
import {accountModule} from '@/store'

export default defineComponent({
  name: 'InquiryButton',
  props: {
    subsidy: {
      type: Object as PropType<Subsidy>,
      required: true,
    },
  },
  setup(props) {
    const subsidy = props.subsidy
    const router = useRouter()
    const analytics = getAnalytics()
    const clickedAskButton = () => {
      logEvent(analytics, 'click_ask_button', {
        content_type: 'subsidy',
        content_id: subsidy.id,
        subsidy_title: subsidy.title,
      })
      // https://knowledge.hubspot.com/jp/forms/can-i-auto-populate-form-fields-through-a-query-string
      const query = {
        company: accountModule.currentCompany?.name,
        email: accountModule.currentUser?.email,
        lastname: accountModule.currentUser?.lastName,
        firstname: accountModule.currentUser?.firstName,
        subsidy_title: subsidy.title,
        hojokin_dock_url: `https://app.hojokin-dock.com/subsidies/${subsidy.id}`,
      }
      router.push({path: routingService.InquirySubsidy(subsidy.id), query})
    }

    return {clickedAskButton}
  },
})
</script>

<style lang="postcss" scoped>
.inquiry-button {
  background-color: #358f80;
  border-color: #358f80;
}
</style>
