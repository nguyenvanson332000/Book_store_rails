# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
env :PATH, ENV['PATH']
set :environment, "development"
set :output, "log/cron_error.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# every "1 * * * *" do

every "* 17 * * 5" do
  command "echo 'show_order_status_pending'"
  rake "order:show_order_status_pending"
end

every "* 20 * * *" do
  command "echo 'show_revenues'"
  rake "revenue:show_revenues"
end
