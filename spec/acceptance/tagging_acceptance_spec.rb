require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Taggings" do
  let(:user) { create(:user) }
  let(:record) { create(:record, user: user) }
  let(:tag) { create(:tag, user: user) }
  let(:tagging) { create(:tagging, tag: tag, record: record, user: user) }
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
    example "获取所有标记" do
      (1..11).each do
        record = create(:record, user: user)
        tag = create(:tag, user: user)
        create(:tagging, tag: tag, record: record, user: user)
      end
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