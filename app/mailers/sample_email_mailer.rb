class SampleEmailMailer < ApplicationMailer
  def sample_email(email)
    mail(to: email, subject: 'サンプルメール')
  end
end
