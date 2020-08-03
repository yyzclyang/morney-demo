require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Records" do
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
    let(:record) { Record.create! amount: 100, category: 'outgoings' }
    let(:id) { record.id }
    example "删除账目记录" do
      sign_in
      do_request

      expect(status).to eq 200
    end
  end
end