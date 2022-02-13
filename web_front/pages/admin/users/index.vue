<template>
  <div class="container">
    <div class="title-header">
      <div class="title">ユーザー 一覧</div>
      <el-button type="primary" @click="newUserPage()">
        新規ユーザー追加
      </el-button>
    </div>
    <card-loading :loading="loading" />
    <el-table v-if="!loading" :data="users" stripe style="width: 100%">
      <el-table-column prop="displayName" label="氏名" />
      <el-table-column prop="companyName" label="会社名">
        <template slot-scope="scope">
          {{ scope.row.company.name }}
        </template>
      </el-table-column>
      <el-table-column prop="email" label="メールアドレス" />
      <el-table-column prop="accountRole" label="アカウント種類">
        <template slot-scope="scope">
          {{ accountRoleLabel(scope.row.accountRole) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100">
        <template slot-scope="scope">
          <el-button size="mini" @click="handleEdit(scope.row)">編集</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      v-if="users.length > 0 && !loading"
      background
      layout="prev, pager, next"
      :page-count="pagination.totalPages"
      :total="pagination.itemsTotal"
      :page-size="pagination.itemsPerPage"
      :current-page="pagination.currentPage"
      @current-change="getPage"
    />
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  useRouter,
} from '@nuxtjs/composition-api'
import {Table, TableColumn, Pagination} from 'element-ui'
import CardLoading from '@/components/CardLoading.vue'
import {usersModule} from '@/store'
import {routingService} from '@/services/routingService'
import {User} from '@/types/User'
import {accountRoleLabel} from '@/utils/enumKeyToName'

export default defineComponent({
  name: 'UserIndex',
  components: {
    [`${Table.name}`]: Table,
    [`${TableColumn.name}`]: TableColumn,
    [`${Pagination.name}`]: Pagination,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const {loading, load} = usersModule.loader
    const users = computed(() => usersModule.users)
    const pagination = computed(() => usersModule.pagination)
    const getPage = (page: number) => {
      usersModule.setUsers([])
      usersModule.getUsers(page)
    }
    const handleEdit = (user: User) => {
      router.push(routingService.AdminUserDetail(user.id))
    }
    const newUserPage = () => {
      router.push(routingService.AdminNewUser())
    }

    onMounted(() => {
      load(loading, () => {
        usersModule.getUsers()
      })
    })

    return {
      loading,
      users,
      pagination,
      getPage,
      handleEdit,
      accountRoleLabel,
      newUserPage,
    }
  },
  head(): object {
    return {
      title: 'ユーザー管理',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}

.title {
  font-size: 16px;
  font-weight: bold;
}

.title-header {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}
</style>
