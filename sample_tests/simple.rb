test(id: 1, title: 'My Sample Test') do
  step id: 1,
       action:   "Fill up the login form and click submit",
       response: "Were you logged in?" do

    # Content of test
    $simple_test_was = :run
  end
end
