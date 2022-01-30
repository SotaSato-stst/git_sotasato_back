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
  </div>
</template>

<script lang="ts">
import {defineComponent, reactive, useRouter} from '@nuxtjs/composition-api'
import {Form, FormItem, Input, Button} from 'element-ui'
import {getAuth, signInWithEmailAndPassword} from 'firebase/auth'
import {notifyError} from '@/utils/notify'
import CookieStore from '@/utils/cookie-store'

export default defineComponent({
  name: 'SignInPage',
  components: {
    [`${Form.name}`]: Form,
    [`${FormItem.name}`]: FormItem,
    [`${Input.name}`]: Input,
    [`${Button.name}`]: Button,
  },
  layout: 'plain-layout',
  setup(_props) {
    const router = useRouter()
    const state = reactive({
      email: '',
      password: '',
    })

    const signIn = () => {
      const auth = getAuth()
      signInWithEmailAndPassword(auth, state.email, state.password)
        .then(userCredential => {
          const user = userCredential.user
          user.getIdTokenResult().then(res => {
            CookieStore.setAuth(res.token, res.expirationTime)
            router.replace('/')
          })
        })
        .catch(_ => {
          notifyError(
            'ログインに失敗しました',
            'emailとパスワードを確認してください',
          )
        })
    }

    return {state, signIn}
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
  width: 300px;
  text-align: center;
}
</style>
