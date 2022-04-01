<template>
  <div class="sample-wrapper">
    <!-- eslint-disable vue/no-v-html -->
    <div v-for="(sample, idx) in samples" :key="idx">
      <div class="inline">
        <el-input
          v-model="samples[idx]"
          type="textarea"
          :rows="sample.split('\n').length"
        />
        <div
          class="subsidy-detail-markdown-content"
          v-html="parseMarkdown(sample)"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import {defineComponent, ref} from '@nuxtjs/composition-api'
import {marked} from 'marked'

export default defineComponent({
  name: 'MarkdownSample',
  setup(_props) {
    const parseMarkdown = marked.parse
    const samples = ref([
      '# h1\n## h2\n### h3\n#### h4',
      '**太字**\n通常テキスト',
      '- 箇条書き\n- 箇条書き\n- 箇条書き\n\n1. 箇条書き\n1. 箇条書き\n1. 箇条書き',
      '|表|列1|列2|\n|---|---|---|\n|行1|値1|値2|\n|行2|値3|値4|',
      '文字[リンク](https://www.google.com/)文字\n\n',
    ])

    return {parseMarkdown, samples}
  },
})
</script>

<style lang="postcss" scoped>
.sample-wrapper {
  padding: var(--spacing-4);
}

.sample-wrapper > * {
  margin-bottom: var(--spacing-8);
}

.inline {
  display: flex;
}

.inline > * {
  width: 50%;
  margin-right: var(--spacing-4);
}

.subsidy-detail-markdown-content {
  margin-top: 0;
  font-size: 16px;
}
</style>
