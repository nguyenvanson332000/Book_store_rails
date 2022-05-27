namespace :revenue do
  desc "use whenever send admin revenue notification every day"
  task show_revenues: :environment do
    Notification.create(recipient: User.first, actor: User.first,
                        title: I18n.t("notification.revenue"),
                        content: I18n.t("notification.content_revenue") +
                                 Order.find_sum_day_status_approve_a_day(Time.now.strftime("%Y-%m-%d")).to_s)
  end
end
