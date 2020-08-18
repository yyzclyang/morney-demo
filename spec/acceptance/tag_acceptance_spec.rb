require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Tags" do
  let(:user) { create(:user) }
  let(:tag) { create(:tag, user: user) }

  post "/tags" do
    parameter :name, '标签名', type: :string, required: true
    example "创建标签" do
      sign_in
      do_request(name: '吃饭')

      expect(status).to eq 200
    end
  end

  delete "/tags/:id" do
    let(:id) { tag.id }
    example "删除标签" do
      sign_in
      do_request

      expect(status).to eq 200
    end
  end

  get "/tags" do
    parameter :page, '页码', type: :integer
    let(:page) { 1 }
    example "获取所有标签" do
      (1..11).each do
        create(:tag, user: user)
      end
      sign_in
      do_request

      expect(status).to eq 200
    end
  end

  get "/tags/:id" do
    let(:id) { tag.id }
    example "获取单个标签" do
      sign_in
      do_request

      expect(status).to eq 200
    end
  end

  patch "/tags/:id" do
    parameter :name, '标签名', type: :string
    let(:id) { tag.id }
    example "更新单个标签" do
      sign_in
      do_request(name: "交通")

      expect(status).to eq 200
    end
  end
end