<template>
  <div class="container">
    <div class="title">ログインフォーム</div>
    <el-form ref="form" class="form" :model="state" label-width="120px">
      <el-form-item label="メールアドレス">
        <el-input
          v-model="state.email"
          placeholder="email@example.com"
        ></el-input>
      </el-form-item>
      <el-form-item label="パスワード">
        <el-input v-model="state.password" show-password></el-input>
      </el-form-item>
      <el-button @click="signIn">ログイン</el-button>
    </el-form>
    <a class="password-reset" @click="goToPasswordReset()">
      パスワードをお忘れの方はこちら
    </a>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  reactive,
  useRouter,
  useRoute,
  onMounted,
} from '@nuxtjs/composition-api'
import {
  getAuth,
  signInWithEmailAndPassword,
  UserCredential,
} from 'firebase/auth'
import {notifyError} from '@/services/notify'
import CookieStore from '@/services/cookieStore'
import {routingService} from '@/services/routingService'

export default defineComponent({
  name: 'SignInPage',
  layout: 'plain-layout',
  setup(_props) {
    const router = useRouter()
    const route = useRoute()
    const state = reactive({
      email: '',
      password: '',
    })

    const signIn = () => {
      const auth = getAuth()
      signInWithEmailAndPassword(auth, state.email, state.password)
        .then(handleSuccess)
        .catch(handleError)
    }

    const handleSuccess = (userCredential: UserCredential) => {
      const user = userCredential.user
      user.getIdTokenResult().then(res => {
        CookieStore.setAuth(res.token, res.expirationTime)
        handleRedirect()
      })
    }

    const handleRedirect = () => {
      const redirection = route.value.query.redirection
      switch (redirection) {
        case 'account':
          router.replace(routingService.Account())
          break
        default:
          router.replace(routingService.Top())
          break
      }
    }

    const handleError = () => {
      notifyError(
        'ログインに失敗しました',
        'emailとパスワードを確認してください',
      )
    }

    onMounted(() => {
      CookieStore.clear()
    })

    const goToPasswordReset = () => {
      router.push(routingService.PasswordReset())
    }

    return {state, signIn, goToPasswordReset}
  },
  head(): object {
    return {
      title: 'サインイン',
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

.password-reset {
  margin-top: var(--spacing-6);
  color: var(--text-color);
  font-size: 12px;
  cursor: pointer;
  text-decoration-line: underline;
}
</style>
