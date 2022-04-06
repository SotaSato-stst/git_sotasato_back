<template>
  <div class="container">
    <company-form
      v-if="!loading && company"
      :company-params="companyParams"
      @submit="submit"
    />
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  onUnmounted,
  useRoute,
  reactive,
} from '@nuxtjs/composition-api'
import CompanyForm from '@/components/companies/CompanyForm.vue'
import {companiesModule} from '@/store'
import {notifySuccess, showApiErrorMessage} from '@/services/notify'
import {CompanyParams} from '@/types/Company'

export default defineComponent({
  name: 'CompanyDetailPage',
  components: {
    CompanyForm,
  },
  layout: ctx => (ctx.$device.isMobile ? 'admin-mobile' : 'admin'),
  setup(_props) {
    const route = useRoute()
    const {loading, load} = companiesModule.loader
    const pageId = Number(route.value.params.id)
    const company = computed(() => companiesModule.company)
    const companyParams: CompanyParams = reactive({
      name: '',
      organizationType: '',
      adress: '',
      capital: null,
      totalEmployee: null,
      prefectureId: null,
      cityId: null,
      businessCategories: [],
      foundingDate: null,
      annualSales: null,
    })

    const submit = async () => {
      await companiesModule
        .putCompany(companyParams)
        .then(handleSuccess)
        .catch(showApiErrorMessage)
    }

    const handleSuccess = () => {
      notifySuccess(
        '内容を保存しました',
        `${companiesModule.company?.name}の会社情報`,
      )
    }

    onMounted(() => {
      load(loading, async () => {
        await companiesModule.getCompany(pageId)
        const company = companiesModule.company
        if (!company) {
          return
        }
        Object.assign(companyParams, company)
        Object.assign(companyParams, {
          prefectureId: company.prefecture.id,
          cityId: company.city.id,
          businessCategories: company.businessCategories.map(c => c.key),
        })
      })
    })

    onUnmounted(() => {
      companiesModule.setCompany(null)
    })

    return {
      loading,
      company,
      companyParams,
      submit,
    }
  },
  head(): object {
    return {
      title: this.company?.name,
    }
  },
})
</script>
