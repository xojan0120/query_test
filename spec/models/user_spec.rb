require 'rails_helper'


RSpec.describe User, type: :model do
  let(:user1)  { FactoryBot.create(:user, name: "user1", status:1) }
  let(:user2)  { FactoryBot.create(:user, name: "user2", status:2) }
  let(:time)   { Time.zone.parse("2019/1/1 00:00:00") }
  let!(:c1)    { FactoryBot.create(:comment, body: "あけまして", user_id: user1.id, created_at: time) }
  let!(:c2)    { FactoryBot.create(:comment, body: "今日から",   user_id: user1.id, created_at: time) }
  let!(:c3)    { FactoryBot.create(:comment, body: "おめでとう", user_id: user2.id, created_at: time) }
  let!(:c4)    { FactoryBot.create(:comment, body: "仕事",       user_id: user2.id, created_at: time) }
  let(:bodies) { [c1.body,c2.body,c3.body,c4.body] }

  it "テーブルの取得" do
    p User.all.pluck(:name)
  end

  it "書き方1" do
    result = User.joins(:comments).select("*").where(status:1).or(
          User.joins(:comments).select("*").merge(Comment.where(created_at: time))
        ).pluck(:body)

    expect(result).to match_array(bodies)
  end

  it "書き方2" do
    r1 = User.joins(:comments).select("*").where(status:1)
    r2 = User.joins(:comments).select("*").merge(Comment.where(created_at: time))

    result = (r1.or(r2)).pluck(:body)

    expect(result).to match_array(bodies)
  end

  ActiveRecord::Base.logger = Logger.new(STDOUT)
  fit "N+1クエリ問題" do
    comments = Comment.limit(3)

    comments.each do |comment|
      puts comment.user.name
    end
  end

  fit "N+1クエリ問題回避法" do
    comments = Comment.includes(:user).limit(3)

    comments.each do |comment|
      puts comment.user.name
    end
  end
end
