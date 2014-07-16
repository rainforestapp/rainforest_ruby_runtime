# To execute this code, you require the rainforest_ruby_runtime. https://github.com/rainforestapp/rainforest_ruby_runtime
#
# The best way to get started is to have a look at our sample tests here:
# https://github.com/rainforestapp/sample-capybara-test
#
# Please only edit code within the `step` blocks.
#
# You can use any RSpec 3 assection and Capybare method
#
test(id: 3742, title: "Vagrant-KVM") do
  visit "https://github.com/adrahon/vagrant-kvm"
  step id: :ignored,
      action: "Locate the README section. ", 
      response: "Does the section contains the words \"Vagrant KVM\"?" do
    # Replace this comment with the code for this action an response here.
  end
  step id: :ignored,
      action: "Click on the \"lib\" directory.", 
      response: "Are you shown a file name \"vagrant-kvm.rb\"?" do
    # Replace this comment with the code for this action an response here.
  end
  step id: :ignored,
      action: "Click on the \"vagrant-kvm\" directory?", 
      response: "Do you see a file named \"version.rb\"?" do
    # Replace this comment with the code for this action an response here.
  end
  step id: :ignored,
      action: "Click on the \"version.rb\" file?", 
      response: "Does the file open where the file browser use to be?" do
    # Replace this comment with the code for this action an response here.
  end
  step id: :ignored,
      action: "Locate the version number.", 
      response: "Is the version specified 9000?" do
    # Replace this comment with the code for this action an response here.
  end
end
