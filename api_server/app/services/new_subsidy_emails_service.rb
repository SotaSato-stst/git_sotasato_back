class NewSubsidyEmailsService
  EMAIL_CATEGORY = 'new_subsidies'.freeze

  def execute!
    date = Date.today
    users = User.email_subscribers
    sent_user_ids = UserEmailLog.where(email_category: EMAIL_CATEGORY, sent_date: date).pluck(:user_id)
    ids = Subsidy.new_arrived_for_email.ids
    sent_count = 0
    sent_logs = []
    users.each do |user|
      next if sent_user_ids.include?(user.id)

      subsidies = Subsidy.where(id: ids).index_loading.scope_by_user(user).order(id: :desc).limit(15)
      next if subsidies.blank?

      UserMailer.daily_new_subsidies(user, subsidies).deliver_now # TODO: task queue
      sent_count += 1
      sent_logs << {
        user_id: user.id,
        email_category: EMAIL_CATEGORY,
        sent_date: date,
        created_at: Time.now,
        updated_at: Time.now
      }
    end
    UserEmailLog.insert_all sent_logs if sent_logs.present?
    { sent_count: sent_count, target_count: users.size }
  end
end
