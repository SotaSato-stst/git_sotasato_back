<template>
  <div class="container">
    <el-card>
      <div slot="header" class="form-header">
        <p>ユーザー新規作成</p>
        <div class="button-group">
          <el-button type="primary" class="submit-button" @click="submit">
            保存する
          </el-button>
        </div>
      </div>
      <user-form
        v-if="!loading"
        :user-params="state"
        :new-user="true"
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
  onUnmounted,
  useRouter,
  reactive,
  ref,
} from '@nuxtjs/composition-api'
import {usersModule, companiesModule} from '@/store'
import {UserParams} from '@/types/User'
import {
  notifySuccess,
  showApiErrorMessage,
  notifyError,
} from '@/services/notify'
import {accountRoleOptions} from '@/utils/enumKeyToName'
import UserForm from '@/components/users/UserForm.vue'
import {routingService} from '@/services/routingService'

export default defineComponent({
  name: 'NewUser',
  components: {
    UserForm,
  },
  layout: 'admin',
  setup(_props) {
    const {loading, load} = usersModule.loader
    const router = useRouter()
    const user = computed(() => usersModule.user)
    const companies = computed(() => companiesModule.companies)
    const state: UserParams = reactive({
      lastName: '',
      firstName: '',
      email: '',
      accountRole: 'user',
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
          .postUser(state)
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
        'ユーザーを作成しました',
        `${state.lastName}${state.firstName}さんのアカウント`,
      )
      if (usersModule.user) {
        router.push(routingService.AdminUserDetail(usersModule.user.id))
      }
    }

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
    }
  },
  head(): object {
    return {
      title: 'ユーザー新規作成',
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
</style>
