require 'rails_helper'

RSpec.describe "Taggings", type: :request do
  before :each do
    @user = create(:user)
    @record = create(:record, user: @user)
    @tag = Tag.create! name: '娱乐'
    @tagging = Tagging.create! record: @record, tag: @tag
  end

  context 'create' do
    it '未登录前不可以创建 tagging' do
      post '/taggings'

      expect(response.status).to eq 401
    end
    it '可以创建 tagging' do
      sign_in
      post '/taggings', params: {record_id: @record.id, tag_id: @tag.id}

      expect(response.status).to eq 200
      response_body = JSON.parse(response.body)
      expect(response_body["msg"]).to eq "success"
    end
    it '创建 taggings 时传参错误会报错' do
      sign_in
      post '/taggings'

      expect(response.status).to eq 422
      response_body = JSON.parse(response.body)
      expect(response_body["errors"]["record"].length).to be >= 1
      expect(response_body["errors"]["tag"].length).to be >= 1
    end
  end

  context 'destroy' do
    it '未登录前不能删除 tagging' do
      delete "/taggings/#{@tagging.id}"

      expect(response.status).to eq 401
    end
    it '不能删除一个不存在的 tagging' do
      sign_in
      delete "/taggings/99999"

      expect(response.status).to eq 400
    end
    it '正常删除 tagging' do
      sign_in
      delete "/taggings/#{@tagging.id}"

      expect(response.status).to eq 200
    end
  end

  context 'index' do
    it '未登录前不能获取 taggings' do
      get "/taggings"

      expect(response.status).to eq 401
    end
    it '正常获取 taggings' do
      sign_in
      get "/taggings"

      expect(response.status).to eq 200
    end
    it '正常获取 taggings 会分页，一页最多 10 个' do
      sign_in
      (1..11).each do
        record = create(:record, user: @user)
        tag = Tag.create! name: '娱乐'
        Tagging.create! record: record, tag: tag
      end
      get "/taggings"

      response_body = JSON.parse response.body
      expect(response.status).to eq 200
      expect(response_body["resources"].length).to eq 10
    end
  end

  context 'show' do
    it '未登录前不能获取 tagging' do
      get "/taggings/#{@tagging.id}"

      expect(response.status).to eq 401
    end
    it '能获取 tagging' do
      sign_in
      get "/taggings/#{@tagging.id}"

      expect(response.status).to eq 200
    end
    it '不能获取不存在的 tagging' do
      sign_in
      get "/taggings/9999"

      expect(response.status).to eq 404
    end
  end
end
