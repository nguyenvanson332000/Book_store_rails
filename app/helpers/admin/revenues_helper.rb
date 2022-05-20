module Admin::RevenuesHelper
  def val_date
    Date.current.to_formatted_s(:iso8601)
  end
end
