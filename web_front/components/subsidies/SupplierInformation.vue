<template>
  <div class="supplier-container">
    <el-avatar
      :size="54"
      :src="logoUrl(subsidy.supplierType)"
      class="logo"
    ></el-avatar>
    <div class="supplier label">発行機関</div>
    <div v-if="subsidy.supplierType == 'city'" class="supplier">
      {{ subsidy.prefecture && subsidy.prefecture.name }}
    </div>
    <div class="supplier">
      {{ supplierName(subsidy.supplierType) }}
    </div>
  </div>
</template>

<script lang="ts">
import {defineComponent, PropType} from '@nuxtjs/composition-api'
import {Subsidy, SupplierType} from '@/types/Subsidy'

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

.supplier {
  font-size: 12px;
  margin-top: var(--spacing-2);
}

.label {
  font-weight: bold;
}
</style>
