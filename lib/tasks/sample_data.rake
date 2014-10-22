namespace :db do
  desc "Fill database with sample data"
  task :populate => [:environment] do
    require 'faker'
    
    
    puts_wrapper User, :make_users
    puts_wrapper Micropost, :make_microposts
    puts_wrapper Relationship, :make_relationships
    # make_microposts
    # make_relationships    
  end

  def make_users
    admin = User.create!(name: "Example User",
      email: "example@railstutorial.org",
      password: 'password',
      password_confirmation: 'password', 
      admin: true)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(name: name,
        email: email,
        password: password,
        password_confirmation: password)
    end
  end
  def make_microposts
    users = User.limit(6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content)}
    end
  end
  def make_relationships
    users = User.all
    user = users.first
    followed_users = users[2..50]
    followers = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each { |follower| follower.follow!(user)  }
  end

  def puts_wrapper(current_class, meth)
    puts "making #{current_class.to_s.pluralize}"
    self.send(meth)
    puts "created #{current_class.count} #{current_class.to_s.pluralize(current_class.count)}"
  end
end