class NewSubsidyEmailsService
  def execute!
    ids = Subsidy.new_arrived_for_email.ids
    users = User.email_subscribers
    sent_count = 0
    users.each do |user|
      subsidies = Subsidy.where(id: ids).index_loading.scope_by_user(user).order(id: :desc).limit(15)
      next if subsidies.blank?

      UserMailer.daily_new_subsidies(user, subsidies).deliver_now # TODO: task queue
      sent_count += 1
    end
    { sent_count: sent_count, target_count: users.size }
  end
end
