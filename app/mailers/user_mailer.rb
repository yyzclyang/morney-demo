class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url = 'http://morney.yyzcl.cn'
    mail(to: @user.email, subject: 'Welcome to Morney!')
  end
end
