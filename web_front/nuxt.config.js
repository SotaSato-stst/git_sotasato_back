const environment = process.env.NODE_ENV || 'development'
const envSet = require(`./environments/${environment}.ts`)

export default {
  // Target: https://go.nuxtjs.dev/config-target
  target: 'static',
  env: {NODE_ENV: process.env.NODE_ENV, ...envSet},
  ssr: false,

  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    titleTemplate: '%s | 補助金ドック',
    htmlAttrs: {
      lang: 'en',
    },
    meta: [
      {charset: 'utf-8'},
      {name: 'viewport', content: 'width=device-width, initial-scale=1'},
      {hid: 'description', name: 'description', content: ''},
      {name: 'format-detection', content: 'telephone=no'},
    ],
    link: [{rel: 'icon', type: 'image/x-icon', href: '/favicon.ico'}],
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [
    'element-ui/lib/theme-chalk/index.css',
    '@/assets/styles/_common.scss',
    '@/assets/styles/_font.css',
    '@/assets/styles/_variables.css',
    'normalize.css',
  ],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    '@/plugins/composition-api',
    '@/plugins/axios-accessor',
    '@/plugins/element-ui',
    '@/plugins/firebase',
    '@/plugins/firebase-auth',
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    '@nuxt/typescript-build',
    '@nuxtjs/composition-api/module',
    '@nuxtjs/device',
    '@nuxtjs/stylelint-module',
    '@nuxt/postcss8',
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    '@nuxtjs/dotenv',
  ],

  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    prefix: envSet.apiBaseUrl,
    proxy: true,
  },

  router: {
    middleware: ['middleware'],
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
    transpile: [/^element-ui/],
    postcss: {},
    extend(config) {
      config.node = {fs: 'empty'}
    },
  },

  storybook: {
    stories: ['@/stories/*.stories.ts'],
    port: 5555,
  },
}
