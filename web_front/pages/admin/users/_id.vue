<template>
  <div class="container" :loading="loading">
    <el-card v-if="user">
      <div slot="header" class="form-header">
        <p>「{{ user.displayName }}」さんの情報</p>
        <el-button type="primary" class="submit-button" @click="submit">
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
            class="category-select"
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
          />
        </el-form-item>
        <el-form-item label="E-mail">
          <el-input
            v-model="user.email"
            class="input-text"
            placeholder="hojokin@example.com"
            disabled
          />
          <div>E-mailはユーザー自身で更新可能です</div>
        </el-form-item>
        <el-form-item label="アカウント" prop="accountRole">
          <el-select
            v-model="state.accountRole"
            placeholder="選択..."
            class="category-select"
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
  computed,
  defineComponent,
  onMounted,
  onUnmounted,
  useRoute,
  useRouter,
  reactive,
  ref,
} from '@nuxtjs/composition-api'
import {Card, Form, FormItem, Input, Button} from 'element-ui'
import {usersModule, companiesModule} from '@/store'
import {notifySuccess, showApiErrorMessage} from '@/services/notify'
import {UpdateUserParams} from '~/types/User'
import {accountRoleOptions} from '@/utils/enumKeyToName'
import {routingService} from '@/services/routingService'

export default defineComponent({
  name: 'UserDetail',
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
    const route = useRoute()
    const router = useRouter()
    const {loading, load} = usersModule.loader
    const pageId = Number(route.value.params.id)
    const user = computed(() => usersModule.user)
    const companies = computed(() => companiesModule.companies)
    const state: UpdateUserParams = reactive({
      displayName: '',
      accountRole: 'user',
      companyId: null,
    })
    const rules = usersModule.rules

    const submit = () => {
      form.value
        ?.validate()
        .then(() => usersModule.putUser(state))
        .then(handleSuccess)
        .catch(showApiErrorMessage)
    }

    const handleSuccess = () => {
      notifySuccess(
        '内容を保存しました',
        `${usersModule.user?.displayName}さんの情報`,
      )
      router.push(routingService.AdminUsers())
    }

    onMounted(() => {
      load(loading, async () => {
        await usersModule.getUser(pageId)
        const user = usersModule.user
        if (user) {
          Object.assign(state, {
            displayName: user.displayName,
            accountRole: user.accountRole,
            companyId: user.company.id,
          })
        }
        companiesModule.getCompanies()
      })
    })

    onUnmounted(() => {
      usersModule.setUser(null)
    })

    return {
      form,
      loading,
      user,
      companies,
      state,
      rules,
      accountRoleOptions,
      submit,
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
