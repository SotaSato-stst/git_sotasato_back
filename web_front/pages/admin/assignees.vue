<template>
  <div class="container">
    <div class="title-header">
      <div class="title">編集担当者管理</div>
    </div>
    <div class="no-assign-total">
      <el-table v-if="!loading" :data="[total]" stripe style="width: 100%">
        <el-table-column prop="subsidyDraftTotal" label="未対応件数" />
        <el-table-column prop="assignedTotal" label="振り分け済み" />
        <el-table-column prop="noAssignTotal" label="未振り分け" />
      </el-table>
    </div>
    <card-loading :loading="loading" />
    <el-table v-if="!loading" :data="assignees" stripe style="width: 100%">
      <el-table-column prop="userName" label="氏名" />
      <el-table-column prop="assignCount" label="担当件数" />
      <el-table-column prop="completedCount" label="完了数" />
      <el-table-column label="操作">
        <template slot-scope="scope">
          <assign-form :assignee="scope.row" />
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  ref,
} from '@nuxtjs/composition-api'
import {Table, TableColumn, Tag} from 'element-ui'
import CardLoading from '@/components/CardLoading.vue'
import AssignForm from '@/components/assignees/AssignForm.vue'
import {subsidyDraftsModule} from '@/store'

export default defineComponent({
  name: 'EditorsPage',
  components: {
    [`${Table.name}`]: Table,
    [`${TableColumn.name}`]: TableColumn,
    [`${Tag.name}`]: Tag,
    AssignForm,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const {loading, load} = subsidyDraftsModule.loader
    const assignees = computed(() => subsidyDraftsModule.assignees)
    const total = ref({
      subsidyDraftTotal: 0,
      assignedTotal: 0,
      noAssignTotal: 0,
    })

    onMounted(() => {
      load(loading, async () => {
        await subsidyDraftsModule.getAssignees()
        total.value = {
          subsidyDraftTotal: subsidyDraftsModule.subsidyDraftTotal,
          assignedTotal:
            subsidyDraftsModule.subsidyDraftTotal -
            subsidyDraftsModule.noAssignTotal,
          noAssignTotal: subsidyDraftsModule.noAssignTotal,
        }
      })
    })

    return {loading, assignees, total}
  },
  head(): object {
    return {
      title: '編集担当者管理',
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
  align-items: baseline;
}

.no-assign-total {
  margin: var(--spacing-4) 0;
}
</style>
