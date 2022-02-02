import {ref, Ref} from '@nuxtjs/composition-api'

export class Loader {
  loading = ref(false)

  load = (loading: Ref<boolean>, waitingFor: () => void) => {
    loading.value = true
    waitingFor()
    setTimeout(() => {
      loading.value = false
    }, 500) // チラチラするよりちょっと遅延した方がよい
  }
}

export const useLoader = () => {
  const loader = new Loader()
  return loader
}
