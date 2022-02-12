<template>
  <el-container>
    <el-aside class="side-menu" width="var(--header-width)">
      <account-menu />
    </el-aside>
    <el-container class="center-container">
      <el-main>
        <el-card>
          <div slot="header" class="form-header">
            <p>アカウント設定</p>
            <el-button
              type="primary"
              class="submit-button"
              :disabled="loading"
              @click="submit"
            >
              保存する
            </el-button>
          </div>
          <el-form
            ref="form"
            class="form"
            :model="state"
            label-width="120px"
            :rules="rules"
            :loading="loading"
          >
            <el-form-item label="氏名" prop="displayName">
              <el-input
                v-model="state.displayName"
                class="input-text"
                placeholder="田中太郎"
                :disabled="loading"
              />
            </el-form-item>
            <el-form-item label="E-mail" prop="email">
              <el-input
                v-model="state.email"
                class="input-text"
                placeholder="hojokin@example.com"
                :disabled="loading"
              />
            </el-form-item>
          </el-form>
        </el-card>
      </el-main>
    </el-container>
  </el-container>
</template>

<script lang="ts">
import {
  defineComponent,
  onMounted,
  reactive,
  ref,
} from '@nuxtjs/composition-api'
import {Container, Aside, Card, Form, FormItem, Input, Button} from 'element-ui'
import {updateEmail} from 'firebase/auth'
import {accountModule} from '@/store'
import {notifySuccess, showApiErrorMessage} from '@/services/notify'
import {UpdateCurrentUserParams} from '~/types/User'
import AccountMenu from '~/components/layouts/AccountMenu.vue'
import {getUser} from '~/services/authService'

export default defineComponent({
  name: 'AccountPage',
  components: {
    [`${Container.name}`]: Container,
    [`${Aside.name}`]: Aside,
    [`${Card.name}`]: Card,
    [`${Form.name}`]: Form,
    [`${FormItem.name}`]: FormItem,
    [`${Input.name}`]: Input,
    [`${Button.name}`]: Button,
    AccountMenu,
  },
  setup(_props) {
    const form = ref<Form | null>(null)
    const {loading, load} = accountModule.loader
    const state: UpdateCurrentUserParams = reactive({
      displayName: '',
      email: '',
    })
    const rules = {
      displayName: [
        {
          required: true,
          message: '氏名は必須です',
          trigger: 'change',
        },
      ],
      email: [
        {
          required: true,
          message: 'E-mailは必須です',
          trigger: 'change',
        },
      ],
    }

    const submit = () => {
      load(loading, async () => {
        await form.value
          ?.validate()
          .then(() => getUser())
          .then(user => updateEmail(user!, state.email))
          .then(() => accountModule.putCurrentUser(state))
          .then(handleSuccess)
          .catch(showApiErrorMessage)
      })
    }

    const handleSuccess = () => {
      notifySuccess('内容を保存しました', '')
    }

    onMounted(() => {
      load(loading, async () => {
        await accountModule.getCurrentUser()
        const user = accountModule.currentUser
        if (user) {
          Object.assign(state, {
            displayName: user.displayName,
            email: user.email,
          })
        }
      })
    })

    return {
      form,
      loading,
      state,
      rules,
      submit,
    }
  },
  head(): object {
    return {
      title: 'アカウント設定',
    }
  },
})
</script>

<style lang="postcss" scoped>
.side-menu {
  height: 100vh;
}

.form-header {
  display: flex;
  justify-content: space-between;
}

.input-text {
  width: 400px;
}

.input-number {
  width: 240px;
}

.category-select {
  width: 240px;
}
</style>
