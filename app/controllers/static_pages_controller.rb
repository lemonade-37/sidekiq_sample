class StaticPagesController < ApplicationController
  def new ; end

  def create
    email = params[:email]
    SampleEmailMailer.sample_email(email).deliver_now #すぐにメールが送信される
    redirect_to new_static_page_path, notice: 'メールを送信しました'
  end
end
