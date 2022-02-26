<template>
  <div class="container">
    <div class="title">パスワード再設定</div>
    <el-form ref="form" class="form" :model="state">
      <el-form-item label="登録済みのメールアドレス">
        <el-input
          v-model="state.email"
          placeholder="email@example.com"
        ></el-input>
      </el-form-item>
      <el-button @click="submit">送信</el-button>
    </el-form>
  </div>
</template>

<script lang="ts">
import {defineComponent, reactive, useRouter} from '@nuxtjs/composition-api'
import {getAuth, sendPasswordResetEmail} from 'firebase/auth'
import {notifyError, notifySuccess} from '@/services/notify'
import {routingService} from '@/services/routingService'

export default defineComponent({
  name: 'PasswordResetPage',
  layout: 'plain-layout',
  setup(_props) {
    const router = useRouter()
    const state = reactive({email: ''})

    const submit = () => {
      const auth = getAuth()
      sendPasswordResetEmail(auth, state.email)
        .then(handleSuccess)
        .catch(handleError)
    }

    const handleSuccess = () => {
      notifySuccess(
        'パスワード再設定のメールを送信しました',
        'メールの内容をご確認ください',
      )
      router.push(routingService.SignIn())
    }

    const handleError = (error: any) => {
      notifyError('送信に失敗しました', error.message || '内容をご確認ください')
    }

    return {state, submit}
  },
  head(): object {
    return {
      title: 'パスワード再設定',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.title {
  font-size: 24px;
  margin: 32px 0;
}

.form {
  width: 360px;
  text-align: center;
}
</style>
