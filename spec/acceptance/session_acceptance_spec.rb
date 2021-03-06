require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Sessions" do
  post "/sessions" do
    parameter :email, '登录邮箱', type: :string, required: true
    parameter :password, '登录密码', type: :string, required: true
    example "用户登录" do
      create(:user, email: '1234@qq.com')
      do_request(email: '1234@qq.com', password: '123456')

      expect(status).to eq 200
    end
  end

  delete "/sessions" do
    example "用户注销" do
      do_request

      expect(status).to eq 200
    end
  end
end