<template>
  <div class="container">
    <div class="title-header">
      <div class="title">編集担当者管理</div>
    </div>
    <div class="no-assign-total">
      <el-table v-if="!loading" :data="[assignStat]" stripe style="width: 100%">
        <el-table-column prop="subsidyDraftTotal" label="未対応件数" />
        <el-table-column prop="assignedTotal" label="振り分け済み" />
        <el-table-column prop="noAssignTotal" label="未振り分け" />
        <el-table-column
          prop="assignedCompletedTotal"
          label="完了件数(振り分け済)"
        />
        <el-table-column
          prop="noAssignCompletedTotal"
          label="完了件数(振り分けなし)"
        />
      </el-table>
    </div>
    <card-loading :loading="loading" />
    <el-table v-if="!loading" :data="assignees" stripe style="width: 100%">
      <el-table-column prop="userName" label="氏名" />
      <el-table-column prop="assignCount" label="担当件数" />
      <el-table-column prop="completedCount" label="完了数" />
      <el-table-column label="操作" width="300">
        <template slot-scope="scope">
          <assign-form :assignee="scope.row" />
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@nuxtjs/composition-api'
import CardLoading from '@/components/CardLoading.vue'
import AssignForm from '@/components/assignees/AssignForm.vue'
import {subsidyDraftsModule} from '@/store'

export default defineComponent({
  name: 'EditorsPage',
  components: {
    AssignForm,
    CardLoading,
  },
  layout: ctx => (ctx.$device.isMobile ? 'admin-mobile' : 'admin'),
  setup(_props) {
    const {loading, load} = subsidyDraftsModule.loader
    const assignees = computed(() => subsidyDraftsModule.assignees)
    const assignStat = computed(() => subsidyDraftsModule.assignStat)

    onMounted(() => {
      load(loading, async () => {
        await subsidyDraftsModule.getAssignees()
      })
    })

    return {loading, assignees, assignStat}
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
