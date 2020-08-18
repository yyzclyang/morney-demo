require 'rails_helper'

RSpec.describe "Tags", type: :request do
  before :each do
    @user = create(:user)
  end
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
      tag = create(:tag, user: @user)
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
      tag = create(:tag, user: @user)
      delete "/tags/#{tag.id}"

      expect(response.status).to eq 200
    end
  end

  context 'index' do
    it '未登录前不能获取 tags' do
      get "/tags"

      expect(response.status).to eq 401
    end
    it '正常获取 tags' do
      sign_in
      get "/tags"

      expect(response.status).to eq 200
    end
    it '正常获取 tags 会分页，一页最多 10 个' do
      sign_in
      (1..11).each do
        create(:tag, user: @user)
      end
      get "/tags"

      response_body = JSON.parse response.body
      expect(response.status).to eq 200
      expect(response_body["resources"].length).to eq 10
    end
  end

  context 'show' do
    it '未登录前不能获取 tag' do
      tag = create(:tag, user: @user)
      get "/tags/#{tag.id}"

      expect(response.status).to eq 401
    end
    it '能获取 tag' do
      sign_in
      tag = create(:tag, user: @user)
      get "/tags/#{tag.id}"

      expect(response.status).to eq 200
    end
    it '不能获取不存在的 tag' do
      sign_in
      get "/tags/9999"

      expect(response.status).to eq 404
    end
  end

  context 'update' do
    it '未登录前不能更新 tag' do
      tag = create(:tag, user: @user)
      patch "/tags/#{tag.id}", params: {name: '交通'}

      expect(response.status).to eq 401
    end
    it '能更新 tag' do
      sign_in
      tag = create(:tag, user: @user)
      patch "/tags/#{tag.id}", params: {name: '交通'}

      response_body = JSON.parse response.body
      expect(response.status).to eq 200
      expect(response_body["resource"]["name"]).to eq '交通'
    end
  end
end
