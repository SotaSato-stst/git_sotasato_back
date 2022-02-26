<template>
  <div class="assign-form-container">
    <el-input v-model="assignCount" size="mini" class="assign-count-input" />
    <el-button
      size="mini"
      type="success"
      class="assign-button"
      plain
      @click="addAssignCount"
    >
      + 増やす
    </el-button>
    <el-button
      size="mini"
      type="danger"
      class="assign-button"
      plain
      @click="reduceAssignCount"
    >
      - 減らす
    </el-button>
  </div>
</template>

<script lang="ts">
import {defineComponent, PropType, ref} from '@nuxtjs/composition-api'
import {subsidyDraftsModule} from '@/store'
import {SubsidyDraftAssignee} from '@/types/SubsidyDraft'
import {notifySuccess, showApiErrorMessage} from '~/services/notify'

export default defineComponent({
  name: 'AssignForm',
  props: {
    assignee: {
      type: Object as PropType<SubsidyDraftAssignee>,
      required: true,
    },
  },
  setup(props) {
    const {loading, load} = subsidyDraftsModule.loader
    const {assignee} = props
    const assignCount = ref(0)

    const addAssignCount = () => {
      load(loading, () => {
        subsidyDraftsModule
          .putAssignee({
            assigneeId: assignee.userId,
            assignCount: assignCount.value,
          })
          .then(handleSuccess)
          .catch(showApiErrorMessage)
      })
    }

    const reduceAssignCount = () => {
      load(loading, () => {
        subsidyDraftsModule
          .deleteAssignee({
            assigneeId: assignee.userId,
            assignCount: assignCount.value,
          })
          .then(handleSuccess)
          .catch(showApiErrorMessage)
      })
    }

    const handleSuccess = (count: number) => {
      notifySuccess('担当件数を更新しました', `${count}件`)
      subsidyDraftsModule.getAssignees()
    }

    return {loading, assignCount, addAssignCount, reduceAssignCount}
  },
  head(): object {
    return {
      title: '編集担当者管理',
    }
  },
})
</script>

<style lang="postcss" scoped>
.assign-form-container {
  display: flex;
}

.assign-form-container > * {
  margin-right: var(--spacing-4);
}

.assign-count-input {
  width: 120px;
}

.assign-button {
  height: fit-content;
}
</style>
