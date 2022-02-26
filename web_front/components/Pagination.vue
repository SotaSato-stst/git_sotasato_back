<template>
  <el-pagination
    background
    layout="prev, pager, next"
    :page-count="pagination.totalPages"
    :total="pagination.itemsTotal"
    :page-size="pagination.itemsPerPage"
    :current-page="pagination.currentPage"
    @current-change="getPage"
  />
</template>

<script lang="ts">
import {defineComponent, useRouter, PropType} from '@nuxtjs/composition-api'
import {Pagination} from 'types/Pagination'

type RequestPage = (page: number) => void

export default defineComponent({
  name: 'PaginationComponent',
  props: {
    pagination: {
      type: Object as PropType<Pagination>,
      required: true,
    },
    requestPage: {
      type: Function as PropType<RequestPage>,
      required: true,
    },
  },
  setup(props) {
    const router = useRouter()

    const getPage = (page: number) => {
      router.push({query: {page: page.toString()}})
      props.requestPage(page)
    }

    return {getPage}
  },
})
</script>
