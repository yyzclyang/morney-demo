require 'rails_helper'

RSpec.describe "Records", type: :request do
  context 'create' do
    it '未登录前不可以创建 record' do
      post '/records', params: {amount: 10000, category: 'outgoings', notes: '吃饭'}
      expect(response.status).to eq 401
    end
    it '可以创建 record' do
      sign_in

      post '/records', params: {amount: 10000, category: 'outgoings', notes: '吃饭'}
      expect(response.status).to eq 200
      response_body = JSON.parse(response.body)
      expect(response_body["msg"]).to eq "success"
    end
    it '创建 record 时 amount 参数发生错误' do
      sign_in

      post '/records', params: {category: 'outgoings', notes: '吃饭'}
      expect(response.status).to eq 422
      response_body = JSON.parse(response.body)
      expect(response_body["errors"]["amount"].length).to be >= 1
    end
    it '创建 record 时 category 参数发生错误' do
      sign_in

      post '/records', params: {amount: 100, notes: '吃饭'}
      expect(response.status).to eq 422
      response_body = JSON.parse(response.body)
      expect(response_body["errors"]["category"].length).to be >= 1
    end
  end

  context 'destroy' do
    it '未登录前不能删除 record' do
      record = Record.create! amount: 1000, category: 'outgoings'
      delete "/records/#{record.id}"

      expect(response.status).to eq 401
    end
    it '未登录前不能删除' do
      sign_in
      record = Record.create! amount: 1000, category: 'outgoings'
      delete "/records/#{record.id}"

      expect(response.status).to eq 200
    end
  end

  context 'index' do
    it '未登录前不能获取 records' do
      get "/records"

      expect(response.status).to eq 401
    end
    it '正常获取 records' do
      sign_in
      get "/records"

      expect(response.status).to eq 200
    end
    it '正常获取 records 会分页，一页最多 10 个' do
      sign_in
      (1..11).each do
        Record.create! amount: 1000, category: 'outgoings'
      end
      get "/records"

      response_body = JSON.parse response.body
      expect(response.status).to eq 200
      expect(response_body["resources"].length).to eq 10
    end
  end

  context 'show' do
    it '未登录前不能获取 record' do
      record = Record.create! amount: 1000, category: 'outgoings'
      get "/records/#{record.id}"

      expect(response.status).to eq 401
    end
    it '能获取 record' do
      sign_in
      record = Record.create! amount: 1000, category: 'outgoings'
      get "/records/#{record.id}"

      expect(response.status).to eq 200
    end
    it '不能获取不存在的 record' do
      sign_in
      get "/records/9999"

      expect(response.status).to eq 404
    end
  end
end
