class StaticPagesController < ApplicationController
  def new ; end

  def create
    email = params[:email]
    SendEmailJob.set(wait_until: Time.zone.now + 10.minutes).perform_later(email) #10分後に実行するジョブをキューに追加
    redirect_to new_static_page_path, notice: 'メールを送信のキューを追加しました'
  end
end
