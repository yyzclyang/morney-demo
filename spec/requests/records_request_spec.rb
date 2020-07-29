require 'rails_helper'

RSpec.describe "Records", type: :request do
  it '可以创建 record' do
    post '/records', params: {amount: 10000, category: 'outgoings', notes: '吃饭'}
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body)
    expect(response_body["msg"]).to eq "success"
  end
  it '创建 record amount 参数发生错误' do
    post '/records', params: {category: 'outgoings', notes: '吃饭'}
    expect(response.status).to eq 422
    response_body = JSON.parse(response.body)
    expect(response_body["errors"]["amount"].length).to be >= 1
  end
  it '创建 record category 参数发生错误' do
    post '/records', params: {amount: 100, notes: '吃饭'}
    expect(response.status).to eq 422
    response_body = JSON.parse(response.body)
    expect(response_body["errors"]["category"].length).to be >= 1
  end
end
