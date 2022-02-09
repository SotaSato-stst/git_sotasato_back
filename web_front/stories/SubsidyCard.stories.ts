import SubsidyCard from '~/components/subsidies/SubsidyCard.vue'

export default {
  title: 'SubsidyCard',
  component: SubsidyCard,
}

const Template = () => ({
  components: {SubsidyCard},
  template: '<SubsidyCard>Content</SubsidyCard>',
})

export const Primary = Template.bind({})
