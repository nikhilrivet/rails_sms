class Message < ApplicationRecord

  def self.to_csv
    wanted_columns = [:Message_id, :Source, :Destination, :Content, :Status, :Submit_time]
    CSV.generate do |csv|
      csv << wanted_columns
      all.each do |result|
        csv << [result.message_id, result.sender, result.phone, result.message, result.message_status, (result.created_at.strftime '%Y-%m-%d %H:%M:%S')]
      end
    end
  end
end
