require 'rails_helper'

RSpec.describe Tagging, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it '创建 tagging 必须有 record 和 tag' do
    tagging = Tagging.create

    expect(tagging.errors.details[:record]).to include({:error => :blank})
    expect(tagging.errors.details[:tag]).to include({:error => :blank})
  end
  it '可以创建 tagging' do
    tag = Tag.create name: '娱乐'
    record = Record.create amount: 100, category: 'outgoings', notes: '吃饭'
    tagging = Tagging.create tag: tag, record: record

    expect(tagging.errors.empty?).to be true
    expect(tagging.id).to be_a Numeric
    expect(tag.records.first.id).to eq record.id
    expect(record.tags.first.id).to eq tag.id
  end
  it '可以使用 tags 和 records 创建 tagging' do
    tag1 = Tag.create name: '娱乐'
    tag2 = Tag.create name: '娱乐'
    record1 = Record.create amount: 100, category: 'outgoings', notes: '吃饭'
    record2 = Record.create amount: 100, category: 'outgoings', notes: '吃饭'
    Tagging.create tag: tag1, record: record1
    Tagging.create tag: tag1, record: record2
    Tagging.create tag: tag2, record: record1
    Tagging.create tag: tag2, record: record2

    expect(tag1.records.count).to eq 2
    expect(tag2.records.count).to eq 2
    expect(record1.tags.count).to eq 2
    expect(record2.tags.count).to eq 2
  end
end
