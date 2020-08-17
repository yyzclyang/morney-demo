require 'rails_helper'

RSpec.describe Record, type: :model do
  before :each do
    @user = User.create email: '1234@qq.com', password: '123456', password_confirmation: '123456'
  end
  it '可以创建 record' do
    record = Record.create amount: 100, category: 'outgoings', notes: '吃饭', user: @user
    expect(record.errors.empty?).to be true
    expect(record.id).to be_a Numeric
  end
  it '创建 record 必须有 amount' do
    record = Record.create category: 'outgoings', notes: '吃饭', user: @user
    expect(record.errors.details[:amount]).to include({:error => :blank})
  end
  it '创建 record 时 amount 必须为整数' do
    record = Record.create amount: 123.1, category: 'outgoings', notes: '吃饭', user: @user
    expect(record.errors.details[:amount]).to include({:error => :not_an_integer, :value => 123.1})
  end
  it '创建 record 必须有 category' do
    record = Record.create amount: 100, notes: '吃饭', user: @user
    expect(record.errors.details[:category]).to include({:error => :blank})
  end
  it '创建 record 时 category 必须为指定的值' do
    expect {
      Record.create amount: 100, category: 'xx', notes: '吃饭', user: @user
    }.to raise_error(ArgumentError)
  end
  it '创建 record 可以忽略 notes' do
    record = Record.create amount: 100, category: 'outgoings', user: @user
    expect(record.errors.empty?).to be true
  end
end
