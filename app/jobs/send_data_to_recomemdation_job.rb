require "uri"
require "net/http"

class SendDataToRecomemdationJob < ApplicationJob
  queue_as :default

  def perform(orders, current_user)
    orders.order_details.each do |order|
      uri = URI("https://book-recomm.herokuapp.com/book-buys")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.read_timeout = 5
      req = Net::HTTP::Post.new(uri.path, "Content-Type" => "application/json")
      req.body = { user_id: current_user.id, book_id: order.product.id }.to_json
      res = http.request(req)
    end
  end
end
