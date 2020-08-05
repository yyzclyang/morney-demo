require 'rails_helper'

RSpec.describe Tag, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it '可以创建 tag' do
    tag = Tag.create name: '娱乐'
    expect(tag.errors.empty?).to be true
    expect(tag.id).to be_a Numeric
  end
  it '创建 tag 必须有 name' do
    tag = Tag.create
    expect(tag.errors.details[:name]).to include({:error => :blank})
  end
  it '创建 tag 的 name 最大长度为 30' do
    tag = Tag.create name: '123456789012345678901234567890123'
    expect(tag.errors.details[:name]).to include({:count => 30, :error => :too_long})
  end
end
