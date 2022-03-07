<template>
  <div class="supplier-container">
    <el-avatar
      :size="54"
      :src="logoUrl(subsidy.supplierType)"
      class="logo"
    ></el-avatar>
    <div class="text-content label">発行機関</div>
    <div v-if="subsidy.supplierType == 'city'" class="text-content">
      {{ subsidy.prefecture && subsidy.prefecture.name }}
    </div>
    <div class="text-content">
      {{ supplierName(subsidy.supplierType) }}
    </div>
    <div class="text-content label">種別</div>
    <div class="text-content">
      {{ subsidyCategoryLabel(subsidy.subsidyCategory) }}
    </div>
  </div>
</template>

<script lang="ts">
import {defineComponent, PropType} from '@nuxtjs/composition-api'
import {Subsidy, SupplierType} from '@/types/Subsidy'
import {subsidyCategoryLabel} from '@/utils/enumKeyToName'

export default defineComponent({
  name: 'SupplierInformation',
  props: {
    subsidy: {
      type: Object as PropType<Subsidy>,
      required: true,
    },
  },
  setup(props) {
    const supplierName = (supplierType: SupplierType) => {
      switch (supplierType) {
        case 'ministry':
          return props.subsidy.ministry?.name
        case 'prefecture':
          return props.subsidy.prefecture?.name
        case 'city':
          return props.subsidy.city?.name
      }
    }
    const logoUrl = (supplierType: SupplierType) => {
      switch (supplierType) {
        case 'ministry':
          return props.subsidy.ministry?.logoUrl
        case 'prefecture':
          return props.subsidy.prefecture?.logoUrl
        case 'city':
          return props.subsidy.city?.logoUrl
      }
    }
    return {
      supplierName,
      logoUrl,
      subsidyCategoryLabel,
    }
  },
})
</script>

<style lang="postcss" scoped>
.supplier-container {
  text-align: center;
}

.logo {
  background-color: white;
  border: solid 1px var(--border-grey-color);
}

.text-content {
  font-size: 12px;
  margin-top: var(--spacing-2);
}

.label {
  font-weight: bold;
}
</style>
