require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Taggings" do
  let(:record) { Record.create! amount: 100, category: 'outgoings', notes: '吃饭' }
  let(:tag) { Tag.create! name: '吃饭' }
  let(:tagging) { Tagging.create! record: record, tag: tag }
  let(:id) { tagging.id }

  post "/taggings" do
    parameter :record_id, '账目记录ID', type: :number, required: true
    parameter :tag_id, '标签ID', type: :number, required: true
    example "创建标记" do
      sign_in
      do_request(record_id: record.id, tag_id: tag.id)

      expect(status).to eq 200
    end
  end

  delete "/taggings/:id" do
    example "删除标记" do
      sign_in
      do_request

      expect(status).to eq 200
    end
  end

  get "/taggings" do
    parameter :page, '页码', type: :integer
    let(:page) { 1 }
    (1..11).each do
      record = Record.create! amount: 100, category: 'outgoings', notes: '吃饭'
      tag = Tag.create! name: '娱乐'
      Tagging.create! record: record, tag: tag
    end
    example "获取所有标记" do
      sign_in
      do_request

      expect(status).to eq 200
    end
  end

  get "/taggings/:id" do
    example "获取单个标记" do
      sign_in
      do_request

      expect(status).to eq 200
    end
  end
end