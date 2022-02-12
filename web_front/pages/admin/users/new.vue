<template>
  <div class="container">
    <el-card>
      <div slot="header" class="form-header">
        <p>ユーザー新規作成</p>
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
      >
        <el-form-item label="所属会社" prop="companyId">
          <el-select
            v-model="state.companyId"
            placeholder="選択..."
            :disabled="loading"
          >
            <el-option
              v-for="company in companies"
              :key="company.id"
              :label="company.name"
              :value="company.id"
            />
          </el-select>
        </el-form-item>
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
        <el-form-item label="アカウント" prop="accountRole">
          <el-select
            v-model="state.accountRole"
            placeholder="選択..."
            :disabled="loading"
          >
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
import {
  defineComponent,
  useRouter,
  reactive,
  computed,
  onMounted,
  ref,
} from '@nuxtjs/composition-api'
import {Card, Form, FormItem, Input, Button} from 'element-ui'
import {notifySuccess, showApiErrorMessage} from '@/services/notify'
import {NewUserParams} from '~/types/User'
import {accountRoleOptions} from '@/utils/enumKeyToName'
import {routingService} from '~/services/routingService'
import {usersModule, companiesModule} from '~/store'

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
    const form = ref<Form | null>(null)
    const {loading, load} = usersModule.loader
    const router = useRouter()
    const companies = computed(() => companiesModule.companies)
    const state: NewUserParams = reactive({
      displayName: '',
      email: '',
      accountRole: 'user',
      companyId: null,
    })
    const rules = usersModule.rules

    const submit = () => {
      load(loading, async () => {
        await form.value
          ?.validate()
          .then(() => usersModule.postUser(state))
          .then(handleSuccess)
          .catch(showApiErrorMessage)
      })
    }

    const handleSuccess = () => {
      notifySuccess(
        'ユーザーを作成しました',
        `${state.displayName}さんのアカウント`,
      )
      router.push(routingService.AdminUsers())
    }

    onMounted(() => {
      companiesModule.getCompanies()
    })

    return {
      form,
      loading,
      companies,
      state,
      accountRoleOptions,
      submit,
      rules,
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
