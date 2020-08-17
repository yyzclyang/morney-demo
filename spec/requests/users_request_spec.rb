require 'rails_helper'

RSpec.describe "Users", type: :request do
  it '创建 user 时参数不对响应状态码为 422，且返回错误信息' do
    post '/users', params: {email: ''}
    expect(response.status).to eq 422
    response_body = JSON.parse(response.body)
    expect(response_body["errors"]["email"].length).to be >= 1
    expect(response_body["errors"]["password"].length).to be >= 1
    expect(response_body["errors"]["password_confirmation"].length).to be >= 1
  end
  it '正常创建 user 响应的状态码为 200' do
    post '/users', params: {email: '1234@qq.com', password: '123456', password_confirmation: '123456'}
    expect(response).to have_http_status 200
    response_body = JSON.parse(response.body)
    expect(response_body["msg"]).to eq "success"
  end
end
