class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(email)
    SampleEmailMailer.sample_email(email).deliver_now
  end
end
