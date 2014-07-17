test(id: 1, title: 'My Sample Test') do
  visit "http://simonmathieu.com"
  step id: 1,
       action:   "Fill up the login form and click submit",
       response: "Were you logged in?" do
  end
end

