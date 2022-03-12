<template>
  <div class="container">
    <el-card>
      <div slot="header" class="form-header">
        <p>メール設定</p>
      </div>
      <el-form>
        <div
          v-for="emailSubscribe in emailSubscribes"
          :key="emailSubscribe.emailCategory"
        >
          <el-form-item :label="emailSubscribe.name">
            <el-radio-group
              size="mini"
              :value="emailSubscribe.subscribed ? 'subscribe' : 'unsubscribe'"
            >
              <el-radio
                label="subscribe"
                @change="selectedSubscribe(emailSubscribe.emailCategory)"
              >
                購読
              </el-radio>
              <el-radio
                label="unsubscribe"
                @change="selectedUnsubscribe(emailSubscribe.emailCategory)"
              >
                購読停止
              </el-radio>
            </el-radio-group>
          </el-form-item>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@nuxtjs/composition-api'
import {accountModule} from '@/store'
import {EmailCategory} from '@/types/Email'
import {notifySuccess, showApiErrorMessage} from '@/services/notify'

export default defineComponent({
  name: 'EmailSetting',
  layout: ctx => (ctx.$device.isMobile ? 'mobile' : 'account'),
  setup(_props) {
    const {loading, load} = accountModule.loader
    const emailSubscribes = computed(() => accountModule.emailSubscribes)

    const selectedSubscribe = (emailCategory: EmailCategory) => {
      load(loading, () => {
        accountModule
          .subscribeEmail(emailCategory)
          .then(handleSuccess)
          .catch(showApiErrorMessage)
      })
    }

    const selectedUnsubscribe = (emailCategory: EmailCategory) => {
      load(loading, () => {
        accountModule
          .unsubscribeEmail(emailCategory)
          .then(handleSuccess)
          .catch(showApiErrorMessage)
      })
    }

    const handleSuccess = () => {
      notifySuccess('内容を保存しました', '')
      accountModule.getUnsubscribes()
    }

    onMounted(() => {
      load(loading, async () => {
        await accountModule.getUnsubscribes()
      })
    })

    return {loading, emailSubscribes, selectedSubscribe, selectedUnsubscribe}
  },
  head(): object {
    return {
      title: 'メール配信設定',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container {
  padding: var(--spacing-5);
}
</style>
