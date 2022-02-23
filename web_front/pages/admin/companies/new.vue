<template>
  <div class="container">
    <company-form
      v-if="companyParams"
      :company-params="companyParams"
      @submit="submit"
    />
  </div>
</template>

<script lang="ts">
import {defineComponent, reactive, useRouter} from '@nuxtjs/composition-api'
import CompanyForm from '@/components/companies/CompanyForm.vue'
import {companiesModule} from '@/store'
import {notifySuccess, showApiErrorMessage} from '@/services/notify'
import {CompanyParams} from '@/types/Company'
import {routingService} from '@/services/routingService'

export default defineComponent({
  name: 'NewCompanyPage',
  components: {
    CompanyForm,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const {loading} = companiesModule.loader
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

    const submit = () => {
      companiesModule
        .postCompany(companyParams)
        .then(handleSuccess)
        .catch(showApiErrorMessage)
    }

    const handleSuccess = () => {
      notifySuccess('内容を保存しました', `${companyParams.name}の会社情報`)
      router.push(routingService.AdminCompanies())
    }

    return {
      loading,
      companyParams,
      submit,
    }
  },
  head(): object {
    return {
      title: '新規会社登録',
    }
  },
})
</script>
