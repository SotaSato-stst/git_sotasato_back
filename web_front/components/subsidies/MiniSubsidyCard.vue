<template>
  <el-card class="card">
    <a class="title" @click="clickSubsidy(subsidy.id)">
      {{ subsidy.title }}
    </a>
    <div class="body">
      <div class="label">募集期間</div>
      <div class="content">
        {{ convertToJpDate(subsidy.startFrom) }}
        ~
        {{ subsidy.endTo && convertToJpDate(subsidy.endTo, false) }}
      </div>
      <div>
        <span class="label">上限金額</span>
        <span class="content">{{ convertToShortJPY(subsidy.priceMax) }}円</span>
      </div>
    </div>
  </el-card>
</template>
<script lang="ts">
import {defineComponent, PropType, useRouter} from '@nuxtjs/composition-api'
import {Subsidy} from '@/types/Subsidy'
import {convertToJpDate} from '@/utils/dateFormatter'
import {convertToShortJPY} from '@/utils/numberFormatter'

export default defineComponent({
  props: {
    subsidy: {
      type: Object as PropType<Subsidy>,
      required: true,
    },
  },
  setup(_props) {
    const router = useRouter()
    const clickSubsidy = (subsidyId: number) => {
      router.push('/subsidies/' + subsidyId)
    }

    return {
      clickSubsidy,
      convertToShortJPY,
      convertToJpDate,
    }
  },
})
</script>
<style lang="postcss" scoped>
.card {
  overflow: hidden;
}

.title {
  font-size: 16px;
  font-weight: bold;
  text-decoration-line: underline;
  cursor: pointer;
}

.body {
  margin-top: var(--spacing-2);
}

.label {
  font-size: 12px;
  font-weight: bold;
}

.content {
  font-size: 12px;
}
</style>
