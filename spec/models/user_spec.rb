require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it '可以创建 user' do
    user = User.create email: '123@qq.com', password: '123456', password_confirmation: '123456'
    expect(user.password_digest).to_not eq '123456'
    expect(user.id).to be_a Numeric
  end
  it '可以删除 user' do
    user = User.create email: '123@qq.com', password: '123456', password_confirmation: '123456'
    expect {
      User.destroy_by id: user.id
    }.to change { User.count }.by(-1)
  end
  it '创建 user 必须有 email' do
    user = User.create password: '123456', password_confirmation: '123456'
    expect(user.errors.details[:email]).to include({:error => :blank})
  end
  it '创建 user 时 email 不能被占用' do
    User.create email: '123@qq.com', password: '123456', password_confirmation: '123456'
    user = User.create email: '123@qq.com', password: '123456', password_confirmation: '123456'
    expect(user.errors.details[:email]).to include({:error => :taken, :value => '123@qq.com'})
  end
  it '创建 user 时 email 的格式要对' do
    user = User.create email: '123qq.com', password: '123456', password_confirmation: '123456'
    expect(user.errors.details[:email]).to include({:error => :invalid, :value => '123qq.com'})
  end
  it '创建 user 时 password 必须存在' do
    user = User.create email: '123@qq.com', password_confirmation: '123456'
    expect(user.errors.details[:password]).to include({:error => :blank})
  end
  it '创建 user 时 password 必须大于 6 位' do
    user = User.create email: '123@qq.com', password: '12345', password_confirmation: '123456'
    expect(user.errors.details[:password]).to include({:count => 6, :error => :too_short})
  end
  it '创建 user 时 password_confirmation 必须存在' do
    user = User.create email: '123@qq.com', password: '123456'
    expect(user.errors.details[:password_confirmation]).to include({:error => :blank})
  end
  it '创建 user 时 password_confirmation 必须与 password 相同' do
    user = User.create email: '123@qq.com', password: '123456', password_confirmation: '123457'
    expect(user.errors.details[:password_confirmation]).to include({:attribute => "Password", :error => :confirmation})
  end
  it '创建 user 后发送邮件给用户' do
    mailer_spy = spy('mailer')
    allow(UserMailer).to receive(:welcome_email).and_return(mailer_spy)
    User.create! email: '123@qq.com', password: '123456', password_confirmation: '123456'
    expect(UserMailer).to have_received(:welcome_email)
    expect(mailer_spy).to have_received(:deliver_later)
  end
end
