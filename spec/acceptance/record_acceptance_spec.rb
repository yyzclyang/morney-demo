require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Records" do
  let(:user) { User.create! email: '1234@qq.com', password: '123456', password_confirmation: '123456' }
  let(:record) { Record.create! amount: 100, category: 'outgoings', user: user }
  let(:id) { record.id }

  post "/records" do
    parameter :amount, '金额', type: :integer, required: true
    parameter :category, '类型: outgoings | income', type: :string, required: true
    parameter :notes, '备注', type: :string
    example "创建账目记录" do
      sign_in
      do_request(amount: 100, category: 'outgoings', notes: '吃饭')

      expect(status).to eq 200
    end
  end

  delete "/records/:id" do
    example "删除账目记录" do
      sign_in
      do_request

      expect(status).to eq 200
    end
  end

  get "/records" do
    parameter :page, '页码', type: :integer
    let(:page) { 1 }
    example "获取所有账目记录" do
      (1..11).each do
        Record.create! amount: 1000, category: 'outgoings', user: user
      end
      sign_in
      do_request

      expect(status).to eq 200
    end
  end

  get "/records/:id" do
    example "获取单个账目记录" do
      sign_in
      do_request

      expect(status).to eq 200
    end
  end

  patch "/records/:id" do
    parameter :amount, '金额', type: :integer
    parameter :category, '类型: outgoings | income', type: :string
    parameter :notes, '备注', type: :string
    example "更新单个账目记录" do
      sign_in
      do_request(amount: 9, category: "income", notes: "吃饭")

      expect(status).to eq 200
    end
  end
end