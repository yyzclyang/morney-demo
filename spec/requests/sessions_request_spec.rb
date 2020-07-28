require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  it '正常登录响应的状态码为 200' do
    sign_up '123@qq.com', '123456', '123456'

    post '/sessions', params: {email: '123@qq.com', password: '123456'}
    expect(response).to have_http_status 200
    response_body = JSON.parse(response.body)
    expect(response_body["msg"]).to eq "success"
  end

  it '错误响应时状态码为 422，且返回错误信息' do
    sign_up '123@qq.com', '123456', '123456'

    post '/sessions', params: {email: '1234@qq.com', password: '123456'}
    expect(response.status).to eq 422
    response_body = JSON.parse(response.body)
    expect(response_body["errors"]["email"].length).to be >= 1

    post '/sessions', params: {email: '123@qq.com', password: '1234567'}
    expect(response.status).to eq 422
    response2_body = JSON.parse(response.body)
    expect(response2_body["errors"]["password"].length).to be >= 1
  end

  it '能正常注销已登录的账号' do
    sign_up '123@qq.com', '123456', '123456'
    sign_in '123@qq.com', '123456'

    delete '/sessions'
    expect(response).to have_http_status 200
    response_body = JSON.parse(response.body)
    expect(response_body["msg"]).to eq "success"
  end
end
