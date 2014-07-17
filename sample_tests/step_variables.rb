define_variable_scope :my_custom_scope do
   define_variable :uuid do
     SecureRandom.uuid
   end

   define_variable :time do
     "time is: #{Time.now}"
   end
end

define_variable_scope :my_other_scope do
   define_variable :constant do
     "1"
   end
end


test(id: 1, title: 'My Sample Test') do
  step id: 1, action: "", response: "" do
    $step_variable_1_was = my_custom_scope.uuid
    $step_variable_2_was = my_custom_scope.time
  end
  $step_variable_3_was = my_other_scope.constant
end

