require 'rails_helper'

RSpec.describe Tag, type: :model do
  before :each do
    @user = create(:user)
  end

  it '可以创建 tag' do
    tag = Tag.create name: '娱乐', user: @user
    expect(tag.errors.empty?).to be true
    expect(tag.id).to be_a Numeric
  end
  it '创建 tag 必须有 name' do
    tag = Tag.create user: @user
    expect(tag.errors.details[:name]).to include({:error => :blank})
  end
  it '创建 tag 的 name 最大长度为 20' do
    tag = Tag.create name: '12345678901234567890123', user: @user
    expect(tag.errors.details[:name]).to include({:count => 20, :error => :too_long})
  end
end
