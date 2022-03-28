<template>
  <div class="container">
    <div class="title-header">
      <div class="title">未対応の新着情報 一覧</div>
    </div>
    <div class="table-action-group">
      <el-radio-group
        v-model="filter.completeFilter"
        size="mini"
        @change="selectCompleteFilter"
      >
        <el-radio-button label="all">すべて</el-radio-button>
        <el-radio-button label="completed">完了</el-radio-button>
        <el-radio-button label="notCompleted">未完了</el-radio-button>
      </el-radio-group>
      <el-select
        v-if="isAdmin"
        v-model="filter.assignFilter"
        size="mini"
        class="search-filter"
        @change="selectAssignFilter"
      >
        <el-option value="all" label="すべての担当者"></el-option>
        <el-option value="assignedMe" label="自分が担当"></el-option>
        <el-option value="noAssign" label="担当者なし"></el-option>
      </el-select>
      <el-select
        v-model="filter.benefitFilter"
        size="mini"
        class="search-filter"
        @change="selectBenefitFilter"
      >
        <el-option value="all" label="すべての対象"></el-option>
        <el-option value="notForBenefit" label="法人向け"></el-option>
        <el-option value="forBenefit" label="家庭向け"></el-option>
      </el-select>
      <el-input
        v-model="filter.keyword"
        placeholder="タイトル・URL"
        size="mini"
        class="search-input"
      />
      <el-button class="search-button" @click="search">検索</el-button>
      <div class="total-count">{{ pagination.itemsTotal }}件</div>
    </div>
    <div class="table-action-group">
      <el-button
        v-if="isAdmin"
        size="mini"
        :disabled="loading"
        @click="requestNewSubsidy()"
      >
        最新情報を取得
      </el-button>
      <el-button
        size="mini"
        :disabled="loading || selectedSubsidyDrafts.length === 0"
        @click="changeAllForBenefit(false)"
      >
        まとめて法人向けに変更
      </el-button>
      <el-button
        size="mini"
        :disabled="loading || selectedSubsidyDrafts.length === 0"
        @click="changeAllForBenefit(true)"
      >
        まとめて家庭向けに変更
      </el-button>
      <el-button
        type="danger"
        size="mini"
        :disabled="loading || selectedSubsidyDrafts.length === 0"
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
      <el-table-column label="仮判定" width="80">
        <template slot-scope="scope">
          <el-tag :type="scope.row.forBenefit ? 'success' : ''">
            {{ scope.row.forBenefit ? '家庭向け' : '法人向け' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="タイトル">
        <template slot-scope="scope">
          <a class="detail-link" @click="handleEdit(scope.row)">{{
            scope.row.title
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
      <el-table-column v-if="isAdmin" label="担当者" width="120">
        <template slot-scope="scope">
          {{ scope.row.assignee && scope.row.assignee.displayName }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="140">
        <template slot-scope="scope">
          <el-button
            v-if="!scope.row.archived"
            type="danger"
            size="mini"
            @click="archive(scope.row)"
          >
            アーカイブ
          </el-button>
          <el-button
            v-if="scope.row.subsidyId"
            type="success"
            size="mini"
            @click="segueSubsidy(scope.row.subsidyId)"
          >
            情報作成済み
          </el-button>
          <el-button
            v-if="scope.row.benefitId"
            type="success"
            size="mini"
            @click="segueBenefit(scope.row.benefitId)"
          >
            情報作成済み
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="更新日" width="165">
        <template slot-scope="scope">
          {{ convertToJpDateTime(scope.row.updatedAt) }}
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-if="subsidyDrafts.length > 0 && !loading"
      :pagination="pagination"
      :request-page="getPage"
    />
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  useRouter,
  useRoute,
  reactive,
} from '@nuxtjs/composition-api'
import {MessageBox} from 'element-ui'
import CardLoading from '@/components/CardLoading.vue'
import Pagination from '@/components/Pagination.vue'
import {subsidyDraftsModule, accountModule} from '@/store'
import {
  SubsidyDraft,
  SubsidyDraftIndexParams,
  FilterAssignType,
  FilterCompleteType,
  FilterBenefitType,
} from '@/types/SubsidyDraft'
import {routingService} from '@/services/routingService'
import {convertToJpDateTime} from '@/utils/dateFormatter'
import {removeEmpty} from '@/utils/objectUtil'
import {convertQueryNumber, convertQueryString} from '@/utils/urlQuery'
import {notifySuccess, showApiErrorMessage} from '@/services/notify'
import CookieStore from '@/services/cookieStore'

export default defineComponent({
  name: 'IndexPage',
  components: {
    Pagination,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const route = useRoute()
    const query = route.value.query
    const {loading, load} = subsidyDraftsModule.loader
    const defaultAssignFilter =
      CookieStore.getAccountRole() === 'admin' ? 'all' : 'assignedMe'
    const filter = reactive<SubsidyDraftIndexParams>({
      page: 1,
      assignFilter: defaultAssignFilter,
      completeFilter: 'notCompleted',
      benefitFilter: 'all',
      keyword: '',
    })
    const isAdmin = computed(() => accountModule.isAdmin)
    const subsidyDrafts = computed(() => subsidyDraftsModule.subsidyDrafts)
    const selectedSubsidyDrafts = computed(
      () => subsidyDraftsModule.selectedSubsidyDrafts,
    )
    const pagination = computed(() => subsidyDraftsModule.pagination)

    const getPage = (page: number) => {
      subsidyDraftsModule.setSubsidyDrafts([])
      handleSegue({page})
    }

    const selectAssignFilter = (assignFilter: FilterAssignType) => {
      handleSegue({assignFilter, page: 1})
    }

    const selectCompleteFilter = (completeFilter: FilterCompleteType) => {
      handleSegue({completeFilter, page: 1})
    }

    const selectBenefitFilter = (benefitFilter: FilterBenefitType) => {
      handleSegue({benefitFilter, page: 1})
    }

    const search = () => {
      handleSegue({keyword: filter.keyword, page: 1})
    }

    const handleSegue = (segueFilter: Partial<SubsidyDraftIndexParams>) => {
      Object.assign(filter, segueFilter)
      router.push({query: {...removeEmpty(filter)}})
      subsidyDraftsModule.getSubsidyDrafts(filter)
    }

    const handleEdit = (subsidyDraft: SubsidyDraft) => {
      if (subsidyDraft.forBenefit) {
        router.push(routingService.AdminNewBenefit(subsidyDraft.id))
      } else {
        router.push(routingService.AdminSubsidyDraftDetail(subsidyDraft.id))
      }
    }

    const handleSelectionChange = (selections: SubsidyDraft[]) => {
      subsidyDraftsModule.setSelectedSubsidyDrafts(selections)
    }

    const segueSubsidy = (subsidyId: number) => {
      router.push(routingService.AdminSubsidyDetail(subsidyId))
    }
    const segueBenefit = (benefitId: number) => {
      router.push(routingService.AdminBenefitDetail(benefitId))
    }

    const archive = (subsidyDraft: SubsidyDraft) => {
      confirmArchive(`「${subsidyDraft.title}」`)
        .then(() => {
          subsidyDraftsModule
            .updateSubsidyDraft({id: subsidyDraft.id, archive: true})
            .then(() => handleSuccess(subsidyDraft.title))
            .catch(showApiErrorMessage)
        })
        .catch(_ => {})
    }

    const confirmArchive = (text: string) => {
      return MessageBox.confirm(text, 'この情報をアーカイブしますか？', {
        customClass: 'confirm-dialog',
        dangerouslyUseHTMLString: true,
      })
    }

    const archiveAll = () => {
      const titles = subsidyDraftsModule.selectedSubsidyDrafts
        .map(d => `「${d.title}」`)
        .join('<br/>')
      confirmArchive(titles)
        .then(() =>
          subsidyDraftsModule
            .bulkArchive(
              subsidyDraftsModule.selectedSubsidyDrafts.map(d => d.id),
            )
            .catch(showApiErrorMessage),
        )
        .then(() =>
          handleSuccess(
            `${subsidyDraftsModule.selectedSubsidyDrafts.length}件`,
          ),
        )
        .catch(_ => {})
    }

    const handleSuccess = (message: string) => {
      notifySuccess('更新しました', message)
      handleSegue({})
    }

    const changeAllForBenefit = (forBenefit: boolean) => {
      const titles = subsidyDraftsModule.selectedSubsidyDrafts
        .map(d => `「${d.title}」`)
        .join('<br/>')
      const targetText = forBenefit ? '家庭' : '法人'
      MessageBox.confirm(
        titles,
        `この情報をまとめて「${targetText}向け」に変更しますか？`,
        {
          customClass: 'confirm-dialog',
          dangerouslyUseHTMLString: true,
        },
      )
        .then(() =>
          subsidyDraftsModule
            .bulkUpdateForBenefit({
              ids: subsidyDraftsModule.selectedSubsidyDrafts.map(d => d.id),
              forBenefit,
            })
            .catch(showApiErrorMessage),
        )
        .then(() =>
          handleSuccess(
            `${subsidyDraftsModule.selectedSubsidyDrafts.length}件`,
          ),
        )
        .catch(_ => {})
    }

    const requestNewSubsidy = () => {
      MessageBox.prompt(
        `
Slackに新着通知が来ているのに、この画面に表示されてない場合にだけ使ってください。
この場でスクレイピングが走るわけではなく、スクレイピング済みのデータをこの画面へ同期します。
`,
        '最新情報を取得しますか？',
        {inputType: 'date'},
      )
        .then(async (date: any) => {
          await subsidyDraftsModule.getNewSubsidy(date.value)
          Object.assign(filter, {page: 1})
          handleSegue({})
        })
        .catch(_ => {})
    }

    onMounted(() => {
      load(loading, () => {
        const page = convertQueryNumber(query.page) || 1
        const assignFilter =
          (convertQueryString(query.assignFilter) as FilterAssignType) ||
          defaultAssignFilter
        const completeFilter =
          (convertQueryString(query.completeFilter) as FilterCompleteType) ||
          'notCompleted'
        const benefitFilter =
          (convertQueryString(query.benefitFilter) as FilterBenefitType) ||
          'all'
        const keyword = convertQueryString(query.keyword) || ''
        handleSegue({
          page,
          assignFilter,
          completeFilter,
          benefitFilter,
          keyword,
        })
      })
    })

    return {
      loading,
      filter,
      selectAssignFilter,
      selectCompleteFilter,
      selectBenefitFilter,
      search,
      isAdmin,
      subsidyDrafts,
      selectedSubsidyDrafts,
      pagination,
      getPage,
      handleEdit,
      handleSelectionChange,
      segueSubsidy,
      segueBenefit,
      archive,
      archiveAll,
      changeAllForBenefit,
      requestNewSubsidy,
      convertToJpDateTime,
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
  cursor: pointer;
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

.table-action-group {
  display: flex;
  align-items: center;
}

.table-action-group > * {
  margin-right: var(--spacing-4);
}

.search-filter {
  width: 140px;
}

.search-input {
  width: 120px;
}

.search-button {
  height: 28px;
  padding: var(--spacing-1) var(--spacing-4);
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
