user1 = User.create(name: "user1", status:1)
user2 = User.create(name: "user2", status:2)
Comment.create(body: "あけまして", user_id: user1.id, created_at: Time.zone.parse("2019/1/1 00:00:00"))
Comment.create(body: "今日から", user_id: user1.id, created_at: Time.zone.parse("2019/1/2 00:00:00"))
Comment.create(body: "おめでとう", user_id: user2.id, created_at: Time.zone.parse("2019/1/1 00:00:00"))
Comment.create(body: "仕事", user_id: user2.id, created_at: Time.zone.parse("2019/1/2 00:00:00"))

#result = User.joins(:comments).select("users.name, comments.body").where(comments: {created_at: Time.zone.parse("2019/01/01 0:00:00")})
#
#result.each do |r|
#  puts "#{r.name}> #{r.body}"
#end
