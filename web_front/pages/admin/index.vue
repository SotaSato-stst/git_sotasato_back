<template>
  <div class="container">
    <div class="title-header">
      <div class="title">未対応の新着情報 一覧</div>
      <el-button
        type="danger"
        size="mini"
        :disabled="selectedSubsidyDrafts.length === 0"
        @click="archiveAll()"
      >
        まとめてアーカイブする
      </el-button>
    </div>
    <card-loading :loading="loading" />
    <el-table
      v-if="!loading"
      :data="subsidyDrafts"
      stripe
      style="width: 100%"
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
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
          <a
            class="detail-link"
            :href="scope.row.url"
            target="_blank"
            style="word-break: keep-all"
            >{{ scope.row.url }}</a
          >
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
      v-if="subsidyDrafts.length > 0 && !loading"
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
import {Table, TableColumn, Pagination, MessageBox} from 'element-ui'
import CardLoading from '~/components/CardLoading.vue'
import {adminSubsidiesModule} from '@/store'
import {SubsidyDraft} from '~/types/SubsidyDraft'
import {routingService} from '@/services/routingService'
import {convertToJpDate} from '@/utils/dateFormatter'
import {notifySuccess, showApiErrorMessage} from '@/services/notify'

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
    const {loading, load} = adminSubsidiesModule.loader
    const subsidyDrafts = computed(() => adminSubsidiesModule.subsidyDrafts)
    const selectedSubsidyDrafts = computed(
      () => adminSubsidiesModule.selectedSubsidyDrafts,
    )
    const pagination = computed(
      () => adminSubsidiesModule.subsidyDraftPagination,
    )

    const getPage = (page: number) => {
      adminSubsidiesModule.setSubsidyDrafts([])
      adminSubsidiesModule.getSubsidyDrafts(page)
    }

    const detailPath = (id: number) => {
      return routingService.AdminSubsidyDraftDetail(id)
    }

    const handleEdit = (subsidyDraft: SubsidyDraft) => {
      router.push(detailPath(subsidyDraft.id))
    }

    const handleSelectionChange = (selections: SubsidyDraft[]) => {
      adminSubsidiesModule.setSelectedSubsidyDrafts(selections)
    }

    const confirmArchive = (text: string) => {
      return MessageBox.confirm(text, 'この情報をアーカイブしますか？', {
        customClass: 'confirm-dialog',
        dangerouslyUseHTMLString: true,
      })
    }

    const archiveAll = () => {
      const titles = adminSubsidiesModule.selectedSubsidyDrafts
        .map(d => `「${d.title}」`)
        .join('<br/>')
      confirmArchive(titles)
        .then(() => {
          adminSubsidiesModule.selectedSubsidyDrafts.forEach(d => {
            adminSubsidiesModule.deleteSubsidyDraft(d.id)
          })
          handleSuccess()
        })
        .catch(_ => {})
    }

    const archive = (subsidyDraft: SubsidyDraft) => {
      confirmArchive(`「${subsidyDraft.title}」`)
        .then(() => {
          adminSubsidiesModule
            .deleteSubsidyDraft(subsidyDraft.id)
            .then(handleSuccess)
            .catch(showApiErrorMessage)
        })
        .catch(_ => {})
    }

    const handleSuccess = () => {
      notifySuccess(
        'アーカイブしました',
        `${adminSubsidiesModule.subsidyDraft?.title || ''}`,
      )
      adminSubsidiesModule.getSubsidyDrafts()
    }

    onMounted(() => {
      load(loading, () => {
        adminSubsidiesModule.getSubsidyDrafts()
      })
    })

    return {
      loading,
      subsidyDrafts,
      selectedSubsidyDrafts,
      pagination,
      getPage,
      detailPath,
      handleEdit,
      handleSelectionChange,
      archive,
      archiveAll,
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

<style lang="postcss">
.confirm-dialog {
  width: 600px;
}

/* stylelint-disable-next-line selector-class-pattern */
.el-message-box__container {
  overflow: scroll;
  max-height: 600px;
}
</style>
