class SlackService
  def initialize
    @client = Slack::Web::Client.new
  end

  def post_new_subsidy_draft(subsidy_draft)
    edit_page = "#{Settings.front_base_url}/admin/subsidy_drafts/#{subsidy_draft.id}"
    blocks = [
      {
        type: 'section',
        fields: [
          { type: 'mrkdwn', text: subsidy_draft.title },
          { type: 'mrkdwn', text: subsidy_draft.url }
        ]
      },
      {
        type: 'actions',
        elements: [{
          type: 'button',
          text: {
            type: 'plain_text',
            text: '補助金ドックで編集・公開する',
            emoji: true
          },
          url: edit_page,
          action_id: 'subsidy_draft_edit'
        }]
      }
    ]
    attachments = [{ color: '#3a86ff', blocks: blocks }]
    post('新着情報', attachments)
  end

  def post_new_subsidies_count
    edit_page = "#{Settings.front_base_url}/admin"
    blocks = [
      {
        type: 'section',
        text: {
          type: "mrkdwn",
          text: "対応が必要な新着情報が「#{SubsidyDraft.not_archived.count}件」あります。"
        },
        accessory: {
          type: 'button',
          text: {
            type: 'plain_text',
            text: '管理画面へ',
            emoji: true
          },
          url: edit_page,
          action_id: 'admin_top'
        }
      }
    ]
    attachments = [{ color: '#3a86ff', blocks: blocks }]
    post('対応が必要です', attachments)
  end

  private

  def post(text, attachments)
    return unless Rails.env.production?

    @client.chat_postMessage(channel: '#新着支援情報', text: text, attachments: attachments.to_json)
  end
end
