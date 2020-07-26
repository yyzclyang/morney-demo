require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
  post "/users" do
    parameter :email, '注册邮箱', type: :string, required: true
    parameter :password, '注册密码', type: :string, required: true
    parameter :password_confirmation, '重复注册密码', type: :string, required: true
    example "创建用户（注册）" do
      do_request(email: '123@qq.com', password: '123456', password_confirmation: '123456')

      expect(status).to eq 200
    end
  end
end