const environment = process.env.NODE_ENV || 'development'
const envSet = require(`./../environments/${environment}.ts`)

const HubspotFormScript = 'https://js.hsforms.net/forms/shell.js'

const HubspotInquiryFormProps = {
  region: 'na1',
  portalId: envSet.hubspotPortalId,
  formId: envSet.hubspotInquiryFormId,
}

// https://knowledge.hubspot.com/jp/forms/how-can-i-share-a-hubspot-form-if-im-using-an-external-site
export const ShowHubspotInquiryForm = (target: string) => {
  if (environment !== 'production') {
    return
  }
  const script = document.createElement('script')
  script.src = HubspotFormScript
  document.body.appendChild(script)
  script.addEventListener('load', () => {
    // @ts-ignore
    if (window.hbspt) {
      // @ts-ignore
      window.hbspt.forms.create(
        Object.assign({target}, HubspotInquiryFormProps),
      )
    }
  })
}
