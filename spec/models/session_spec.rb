require 'rails_helper'

RSpec.describe Session, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before :each do
    create(:user)
  end
  it '可以创建 session' do
    session = Session.new email: '1234@qq.com', password: '123456'
    session.validate
    expect(session.errors.empty?).to be true
  end

  it '创建 session 时必须要有 email' do
    session = Session.new password: '123456'
    session.validate
    expect(session.errors.details[:email]).to include({:error => :blank})
  end

  it '创建 session 时 email 格式必须对' do
    session = Session.new email: '123qq.com', password: '123456'
    session.validate
    expect(session.errors.details[:email]).to include({:error => :invalid, :value => "123qq.com"})
  end

  it '创建 session 时 email 必须已注册' do
    session = Session.new email: '12345@qq.com', password: '123456'
    session.validate
    expect(session.errors.details[:email]).to include({:error => :not_found})
  end

  it '创建 session 时 password 必须存在' do
    session = Session.new email: '1234@qq.com'
    session.validate
    expect(session.errors.details[:password]).to include({:error => :blank})
  end

  it '创建 session 时 password 必须大于 6 位' do
    session = Session.new email: '1234@qq.com', password: '123'
    session.validate
    expect(session.errors.details[:password]).to include({:count => 6, :error => :too_short})
  end

  it '创建 session 时 email 和 password 必须匹配' do
    session = Session.new email: '1234@qq.com', password: '1234567'
    session.validate
    expect(session.errors.details[:password]).to include({:error => :mismatch})
  end
end
