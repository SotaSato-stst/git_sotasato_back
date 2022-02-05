<template>
  <div class="container">
    <el-card v-if="user">
      <div slot="header" class="form-header">
        <p>「{{ user.displayName }}」さんの情報</p>
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
            disabled
          />
          <div>E-mailはユーザー自身で更新可能です</div>
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
import {
  computed,
  defineComponent,
  onMounted,
  onUnmounted,
  useRoute,
  useRouter,
  reactive,
} from '@nuxtjs/composition-api'
import {Card, Form, FormItem, Input, Button} from 'element-ui'
import {usersModule} from '@/store'
import {useLoader} from '@/services/useLoader'
import {notifyError, notifySuccess} from '@/services/notify'
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
    const route = useRoute()
    const router = useRouter()
    const {loading, load} = useLoader()
    const pageId = Number(route.value.params.id)
    const user = computed(() => usersModule.user)
    const state: UpdateUserParams = reactive({
      displayName: '',
      accountRole: 'user',
    })

    const submit = () => {
      usersModule
        .putUser(state)
        .then(() => {
          notifySuccess(
            '内容を保存しました',
            `${usersModule.user?.displayName}さんの情報`,
          )
          router.push(routingService.AdminUsers())
        })
        .catch(error => notifyError('内容を保存しました', error.message))
    }

    onMounted(() => {
      load(loading, async () => {
        await usersModule.getUser(pageId)
        if (usersModule.user) {
          Object.assign(state, {
            displayName: usersModule.user.displayName,
            accountRole: usersModule.user.accountRole,
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
      state,
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
  width: 400px;
}
</style>
