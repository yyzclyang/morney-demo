require 'rails_helper'

RSpec.describe Tagging, type: :model do
  before :each do
    @user = create(:user)
  end
  it '创建 tagging 必须有 record 和 tag' do
    tagging = Tagging.create user: @user

    expect(tagging.errors.details[:record]).to include({:error => :blank})
    expect(tagging.errors.details[:tag]).to include({:error => :blank})
  end
  it '可以创建 tagging' do
    tag = create(:tag, user: @user)
    record = create(:record, user: @user)
    tagging = Tagging.create tag: tag, record: record, user: @user

    expect(tagging.errors.empty?).to be true
    expect(tagging.id).to be_a Numeric
    expect(tag.records.first.id).to eq record.id
    expect(record.tags.first.id).to eq tag.id
  end
  it '可以使用 tags 和 records 创建 tagging' do
    tag1 = create(:tag, user: @user)
    tag2 = create(:tag, user: @user)
    record1 = create(:record, user: @user)
    record2 = create(:record, user: @user)
    Tagging.create tag: tag1, record: record1, user: @user
    Tagging.create tag: tag1, record: record2, user: @user
    Tagging.create tag: tag2, record: record1, user: @user
    Tagging.create tag: tag2, record: record2, user: @user

    expect(tag1.records.count).to eq 2
    expect(tag2.records.count).to eq 2
    expect(record1.tags.count).to eq 2
    expect(record2.tags.count).to eq 2
  end
end
