<template>
  <div class="container">
    <card-loading :loading="loading" />
    <el-table v-if="!loading" :data="subsidyDrafts" stripe style="width: 100%">
      <el-table-column label="対応" width="100">
        <template slot-scope="scope">
          <el-button size="mini" @click="handleEdit(scope.row)">
            対応する
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="タイトル">
        <template slot-scope="scope">
          <a class="detail-link" :href="detailPath(scope.row.id)">{{
            scope.row.title
          }}</a>
        </template>
      </el-table-column>
      <el-table-column label="URL">
        <template slot-scope="scope">
          <a class="detail-link" :href="scope.row.url" target="_blank">{{
            scope.row.url
          }}</a>
        </template>
      </el-table-column>
      <el-table-column label="発行機関" width="110">
        <template slot-scope="scope">
          <span v-if="scope.row.ministry">{{ scope.row.ministry.name }}</span>
          <span v-if="scope.row.prefecture">{{
            scope.row.prefecture.name
          }}</span>
          <span v-if="scope.row.city">{{ scope.row.city.name }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="120">
        <template slot-scope="scope">
          <el-button type="danger" size="mini" @click="archive(scope.row)">
            アーカイブ
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="更新日" width="120">
        <template slot-scope="scope">
          {{ convertToJpDate(scope.row.createdAt) }}
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      background
      layout="prev, pager, next"
      :page-count="pagination.totalPages"
      :total="pagination.itemsTotal"
      :page-size="pagination.itemsPerPage"
      :current-page="pagination.currentPage"
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
import {Table, TableColumn, Pagination, MessageBox} from 'element-ui'
import CardLoading from '~/components/CardLoading.vue'
import {subsidyDraftModule} from '@/store'
import {SubsidyDraft} from '~/types/SubsidyDraft'
import {routingService} from '@/services/routingService'
import {convertToJpDate} from '@/utils/dateFormatter'
import {notifySuccess, notifyError} from '@/services/notify'

export default defineComponent({
  name: 'IndexPage',
  components: {
    [`${Table.name}`]: Table,
    [`${TableColumn.name}`]: TableColumn,
    [`${Pagination.name}`]: Pagination,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const {loading, load} = subsidyDraftModule.loader
    const subsidyDrafts = computed(() => subsidyDraftModule.subsidyDrafts)
    const pagination = computed(() => subsidyDraftModule.pagination)

    const detailPath = (id: number) => {
      return routingService.AdminSubsidyDraftDetail(id)
    }

    const handleEdit = (subsidyDraft: SubsidyDraft) => {
      router.push(detailPath(subsidyDraft.id))
    }

    const archive = (subsidyDraft: SubsidyDraft) => {
      MessageBox.confirm(subsidyDraft.title, 'この情報をアーカイブしますか？')
        .then(() => {
          subsidyDraftModule
            .deleteSubsidyDraft(subsidyDraft.id)
            .then(() => {
              notifySuccess(
                'アーカイブしました',
                `${subsidyDraftModule.subsidyDraft?.title}`,
              )
              subsidyDraftModule.getSubsidyDrafts()
            })
            .catch(error =>
              notifyError(
                'アーカイブに失敗しました',
                error.response.data.message,
              ),
            )
        })
        .catch(_ => {})
    }

    onMounted(() => {
      load(loading, () => {
        subsidyDraftModule.getSubsidyDrafts()
      })
    })

    return {
      loading,
      subsidyDrafts,
      pagination,
      detailPath,
      handleEdit,
      archive,
      convertToJpDate,
    }
  },
  head(): object {
    return {
      title: '管理画面',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}

.detail-link {
  color: var(--primary-color);
}
</style>
