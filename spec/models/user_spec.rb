require 'rails_helper'


RSpec.describe User, type: :model do
  let(:user1)  { User.create(name: "user1", status:1) }
  let(:user2)  { User.create(name: "user2", status:2) }
  let(:time)   { Time.zone.parse("2019/1/1 00:00:00") }
  let!(:c1)    { Comment.create(body: "あけまして", user_id: user1.id, created_at: time) }
  let!(:c2)    { Comment.create(body: "今日から",   user_id: user1.id, created_at: time) }
  let!(:c3)    { Comment.create(body: "おめでとう", user_id: user2.id, created_at: time) }
  let!(:c4)    { Comment.create(body: "仕事",       user_id: user2.id, created_at: time) }
  let(:bodies) { [c1.body,c2.body,c3.body,c4.body] }

  fit "テーブルの取得" do
    #ActiveRecord::Base.logger = Logger.new(STDOUT)

    p User.all.pluck(:name)
  end

  xit "書き方1" do
    result = User.joins(:comments).select("*").where(status:1).or(
          User.joins(:comments).select("*").merge(Comment.where(created_at: time))
        ).pluck(:body)

    expect(result).to match_array(bodies)
  end

  xit "書き方2" do
    r1 = User.joins(:comments).select("*").where(status:1)
    r2 = User.joins(:comments).select("*").merge(Comment.where(created_at: time))

    result = (r1.or(r2)).pluck(:body)

    expect(result).to match_array(bodies)
  end

  xit "N+1クエリ問題" do
    comments = Comment.limit(3)

    comments.each do |comment|
      puts comment.user.name
    end
  end

  xit "N+1クエリ問題回避法" do
    comments = Comment.includes(:user).limit(3)

    comments.each do |comment|
      puts comment.user.name
    end
  end
end
