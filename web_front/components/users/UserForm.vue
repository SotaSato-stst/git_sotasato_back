<template>
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
    <el-form-item label="氏名" required>
      <div class="inline">
        <el-form-item prop="lastName">
          <el-input
            v-model="state.lastName"
            placeholder="田中"
            class="input-name"
            :disabled="loading"
          />
        </el-form-item>
        <el-form-item prop="firstName">
          <el-input
            v-model="state.firstName"
            placeholder="太郎"
            class="input-name"
            :disabled="loading"
          />
        </el-form-item>
      </div>
    </el-form-item>
    <el-form-item label="メールアドレス" prop="email">
      <el-input
        v-model="state.email"
        class="input-text"
        placeholder="hojokin@example.com"
        :disabled="loading || !newUser"
      />
      <div v-if="!newUser">メールアドレスはユーザー自身で更新可能です</div>
    </el-form-item>
    <el-form-item label="アカウント" prop="accountRole">
      <el-select
        v-model="state.accountRole"
        placeholder="選択..."
        :disabled="loading"
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
    <el-form-item label="利用停止" prop="disabled">
      <el-checkbox v-model="state.disabled" />
    </el-form-item>
  </el-form>
</template>

<script lang="ts">
import {
  defineComponent,
  reactive,
  computed,
  onMounted,
  ref,
  PropType,
  watch,
} from '@nuxtjs/composition-api'
import {Form} from 'element-ui'
import {UserParams} from '@/types/User'
import {accountRoleOptions} from '@/utils/enumKeyToName'
import {companiesModule} from '@/store'

export default defineComponent({
  name: 'UserForm',
  props: {
    userParams: {
      type: Object as PropType<UserParams>,
      required: true,
    },
    submited: {
      type: Boolean as PropType<boolean>,
      required: true,
    },
    newUser: {
      type: Boolean as PropType<boolean>,
      required: true,
    },
  },
  setup(props, context) {
    const form = ref<Form | null>(null)
    const {loading, load} = companiesModule.loader
    const companies = computed(() => companiesModule.companies)
    const state: UserParams = reactive(props.userParams)
    const rules = {
      companyId: [
        {
          required: true,
          message: '所属は必須です',
          trigger: 'change',
        },
      ],
      lastName: [
        {
          required: true,
          message: '氏名は必須です',
          trigger: 'change',
        },
      ],
      firstName: [
        {
          required: true,
          message: '氏名は必須です',
          trigger: 'change',
        },
      ],
      email: [
        {
          type: 'email',
          required: true,
          message: 'メールアドレスを入力してください',
          trigger: 'change',
        },
      ],
      accountRole: [
        {
          required: true,
          message: 'アカウント種類は必須です',
          trigger: 'change',
        },
      ],
    }

    watch(
      () => props.submited,
      (submited, prev) => {
        if (submited && !prev) {
          load(loading, async () => {
            await form.value
              ?.validate()
              .then(() => context.emit('valid'))
              .catch(() => context.emit('invalid'))
          })
        }
      },
    )

    onMounted(() => {
      load(loading, () => {
        companiesModule.getCompanies()
      })
    })

    return {
      form,
      loading,
      companies,
      state,
      accountRoleOptions,
      rules,
    }
  },
})
</script>

<style lang="postcss" scoped>
.input-text {
  width: 400px;
}

.input-name {
  width: 190px;
  margin-right: 20px;
}

.input-number {
  width: 240px;
}

.category-select {
  width: 400px;
}

.submit-button {
  height: fit-content;
}

.inline {
  display: flex;
}
</style>
