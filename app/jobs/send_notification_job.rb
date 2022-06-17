class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(current_user, name)
    Notification.create(recipient: User.first, actor: current_user,
      title: name + I18n.t("notification.title_ad"),
      content: I18n.t("notification.content_ad"))
  end
end
