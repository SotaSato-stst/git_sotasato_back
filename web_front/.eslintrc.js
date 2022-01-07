module.exports = {
  env: {
    browser: true,
    node: true,
  },
  root: true,
  plugins: ['@typescript-eslint'],
  extends: [
    '@nuxtjs/eslint-config-typescript',
    'prettier',
    'plugin:prettier/recommended',
    'plugin:nuxt/recommended',
  ],
  rules: {
    indent: ['error', 2, {SwitchCase: 1}],
    'comma-dangle': ['error', 'always-multiline'],
    quotes: ['error', 'single', {avoidEscape: true}],
    'no-unused-vars': 'off',
    '@typescript-eslint/no-unused-vars': ['error', {argsIgnorePattern: '^_'}],
    '@typescript-eslint/no-explicit-any': 'off',
    '@typescript-eslint/ban-ts-comment': 'off',
    'prettier/prettier': 'error',
    'vue/multi-word-component-names': [
      'error',
      {
        ignores: ['default'],
      },
    ],
  },
}
