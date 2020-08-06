require 'rails_helper'

RSpec.describe "Tags", type: :request do
  context 'create' do
    it '未登录前不可以创建 tag' do
      post '/tags', params: {name: '娱乐'}
      expect(response.status).to eq 401
    end
    it '可以创建 tag' do
      sign_in

      post '/tags', params: {name: '娱乐'}
      expect(response.status).to eq 200
      response_body = JSON.parse(response.body)
      expect(response_body["msg"]).to eq "success"
    end
    it '创建 tag 时未传 name 会发生错误' do
      sign_in

      post '/tags'
      expect(response.status).to eq 422
      response_body = JSON.parse(response.body)
      expect(response_body["errors"]["name"].length).to be >= 1
    end
    it '创建 tag 时 name 参数发生错误' do
      sign_in

      post '/tags', params: {name: '12345678901234567890123'}
      expect(response.status).to eq 422
      response_body = JSON.parse(response.body)
      expect(response_body["errors"]["name"].length).to be >= 1
    end
  end

  context 'destroy' do
    it '未登录前不能删除 tag' do
      tag = Tag.create! name: '娱乐'
      delete "/tags/#{tag.id}"

      expect(response.status).to eq 401
    end
    it '不能删除一个不存在的 tag' do
      sign_in
      delete "/tags/99999"

      expect(response.status).to eq 400
    end
    it '正常删除 tag' do
      sign_in
      tag = Tag.create! name: '娱乐'
      delete "/tags/#{tag.id}"

      expect(response.status).to eq 200
    end
  end
end
