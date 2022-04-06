<template>
  <div class="container" :loading="loading">
    <el-card v-if="user">
      <div slot="header" class="form-header">
        <p>「{{ user.displayName }}」さんの情報</p>
        <div class="button-group">
          <el-button class="submit-button" @click="passwordReset">
            パスワード設定のメールを送信
          </el-button>
          <el-button type="primary" class="submit-button" @click="submit">
            保存する
          </el-button>
        </div>
      </div>
      <el-alert v-if="state.disabled" type="error">
        このアカウントは停止中です
      </el-alert>
      <user-form
        v-if="!loading && user"
        :user-params="state"
        :new-user="false"
        :submited="submited"
        @validHandler="validHandler"
        @invalidHandler="invalidHandler"
      />
    </el-card>
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  onUnmounted,
  useRoute,
  reactive,
  ref,
} from '@nuxtjs/composition-api'
import {MessageBox} from 'element-ui'
import {getAuth, sendPasswordResetEmail} from 'firebase/auth'
import {usersModule, companiesModule} from '@/store'
import {UserParams} from '@/types/User'
import {
  notifyError,
  notifySuccess,
  showApiErrorMessage,
} from '@/services/notify'
import {accountRoleOptions} from '@/utils/enumKeyToName'
import UserForm from '@/components/users/UserForm.vue'

export default defineComponent({
  name: 'UserDetail',
  components: {
    UserForm,
  },
  layout: ctx => (ctx.$device.isMobile ? 'admin-mobile' : 'admin'),
  setup(_props) {
    const route = useRoute()
    const {loading, load} = usersModule.loader
    const pageId = Number(route.value.params.id)
    const user = computed(() => usersModule.user)
    const companies = computed(() => companiesModule.companies)
    const state: UserParams = reactive({
      lastName: '',
      firstName: '',
      accountRole: 'user',
      email: '',
      companyId: null,
      disabled: false,
    })
    const submited = ref(false)

    const submit = () => {
      submited.value = true
    }

    const validHandler = () => {
      load(loading, () => {
        usersModule
          .putUser(state)
          .then(handleSuccess)
          .catch(showApiErrorMessage)
      })
      submited.value = false
    }

    const invalidHandler = () => {
      notifyError('更新に失敗しました', '入力内容を確認してください')
      submited.value = false
    }

    const handleSuccess = () => {
      notifySuccess(
        '内容を保存しました',
        `${usersModule.user?.displayName}さんの情報`,
      )
    }

    const passwordReset = () => {
      MessageBox.confirm(
        `
<p>お客様へパスワード設定のメールをご案内しますか？</p>
<p>メール文面</p>
<p>==========================================</p>
<p>平素より補助金ドックをご利用いただき誠にありがとうございます。</p><br/>
<p>以下のリンクより、アカウントのパスワード設定をお願いいたします。</p><br/>
<p>link</p><br/>
<p>※初めてご利用されるお客様は、担当の者からご利用方法のご案内を差し上げます。</p>
<p>サービスにログインする際に必要となりますので、上記のURLからパスワードの設定をお願いいたします。</p><br/>
<p>※このメールに心当たりがない場合は、メールを削除してくださいますようお願いいたします。</p><br/>
<p>補助金ドック</p>`,
        'メール送信',
        {dangerouslyUseHTMLString: true},
      )
        .then(sendEmail)
        .catch(_ => {})
    }

    const sendEmail = () => {
      const auth = getAuth()
      sendPasswordResetEmail(auth, usersModule.user!.email)
        .then(() =>
          notifySuccess('メールを送信しました', usersModule.user!.email),
        )
        .catch(error => notifyError('送信に失敗しました', error.message))
    }

    onMounted(() => {
      load(loading, async () => {
        await usersModule.getUser(pageId)
        const user = usersModule.user
        if (user) {
          Object.assign(state, {
            lastName: user.lastName,
            firstName: user.firstName,
            email: user.email,
            accountRole: user.accountRole,
            disabled: user.disabled,
            companyId: user.company.id,
          })
        }
      })
    })

    onUnmounted(() => {
      usersModule.setUser(null)
    })

    return {
      loading,
      user,
      companies,
      state,
      accountRoleOptions,
      submit,
      submited,
      validHandler,
      invalidHandler,
      passwordReset,
    }
  },
  head(): object {
    return {
      title: this.user?.displayName,
    }
  },
})
</script>

<style lang="postcss" scoped>
.form-header {
  display: flex;
  justify-content: space-between;
}

.button-group {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.submit-button {
  height: fit-content;
}

@media screen and (max-width: 1200px) {
  .form-header {
    flex-direction: column;
    overflow: scroll;
  }
}
</style>
