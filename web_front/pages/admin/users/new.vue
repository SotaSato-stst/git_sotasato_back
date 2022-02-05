<template>
  <div class="container">
    <el-card>
      <div slot="header" class="form-header">
        <p>ユーザー新規作成</p>
        <el-button type="primary" class="submit-button" @click="submit">
          保存する
        </el-button>
      </div>
      <el-form class="form" :model="state" label-width="120px">
        <el-form-item label="氏名">
          <el-input
            v-model="state.displayName"
            class="input-text"
            placeholder="田中太郎"
          />
        </el-form-item>
        <el-form-item label="E-mail">
          <el-input
            v-model="state.email"
            class="input-text"
            placeholder="hojokin@example.com"
          />
        </el-form-item>
        <el-form-item label="アカウント種類">
          <el-select v-model="state.accountRole" placeholder="選択...">
            <el-option
              v-for="accountRole in accountRoleOptions()"
              :key="accountRole.key"
              :label="accountRole.name"
              :value="accountRole.key"
            />
          </el-select>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script lang="ts">
import {defineComponent, useRouter, reactive} from '@nuxtjs/composition-api'
import {Card, Form, FormItem, Input, Button} from 'element-ui'
import {notifyError, notifySuccess} from '@/services/notify'
import {NewUserParams} from '~/types/User'
import {accountRoleOptions} from '@/utils/enumKeyToName'
import {routingService} from '~/services/routingService'
import {usersModule} from '~/store'

export default defineComponent({
  name: 'NewUser',
  components: {
    [`${Card.name}`]: Card,
    [`${Form.name}`]: Form,
    [`${FormItem.name}`]: FormItem,
    [`${Input.name}`]: Input,
    [`${Button.name}`]: Button,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const state: NewUserParams = reactive({
      displayName: '',
      email: '',
      accountRole: 'user',
    })

    const submit = async () => {
      await usersModule
        .postUser(state)
        .then(() => handleSuccess())
        .catch(error => handleError(error))
    }

    const handleSuccess = () => {
      notifySuccess(
        'ユーザーを作成しました',
        `${state.displayName}さんのアカウント`,
      )
      router.push(routingService.AdminUsers())
    }

    const handleError = (error: any) => {
      switch (error.response.data.message) {
        case 'EMAIL_EXISTS':
          notifyError(
            'ユーザー作成に失敗しました',
            'すでにE-mailが使われています',
          )
          break
        default:
          notifyError('ユーザー作成に失敗しました', error.response.data.message)
          break
      }
    }

    return {
      state,
      accountRoleOptions,
      submit,
    }
  },
  head(): object {
    return {
      title: 'ユーザー作成',
    }
  },
})
</script>

<style lang="postcss" scoped>
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
  width: 400px;
}
</style>
