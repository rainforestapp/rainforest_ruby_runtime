# Rainforest Ruby Runtime

[![Build Status](https://travis-ci.org/rainforestapp/rainforest_ruby_runtime.svg)](https://travis-ci.org/rainforestapp/rainforest_ruby_runtime)

Gem to run Rainforest Automated Tests locally or on Sauce Labs.

## Installation

Add this line to your application's Gemfile:

    gem 'rainforest_ruby_runtime'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rainforest_ruby_runtime

## Usage

To run the tests on Sauce Labs, set the following environment variables:

- `CAPYBARA_DRIVER=sauce`
- `SAUCE_USERNAME=<your username>`
- `SAUCE_ACCESS_KEY=<your access key>`

You can then run the tests using the following command:
```
bundle exec rainforest_test <test-file.rb>
```

Rainforest Ruby Runtime supports test runs on Sauce Labs against Chrome, Firefox, IE, Edge, and Safari.

By default, your tests will run against Chrome. You can run one or more test scripts against multiple browsers with the following configuration:

```
bundle exec rainforest_test --browsers firefox,chrome,edge <test-file.rb>,<test-file1.rb>
```
## Validate failed test results on Rainforest

To run the associated Rainforest tests for any failed Selenium tests, follow these steps:

*Step 1:* Download your test scripts from Rainforest, then run your automated tests on Sauce labs per the instructions above

*Step 2:* Determine the number of results you need to return with the following calculation:

```
limit = number of scripts run * number of browsers selected
```

*Step 3:* Request the results from your last test run

You can find detailed instructions for making requests to Sauce Labs [here](https://wiki.saucelabs.com/display/DOCS/Job+Methods)

> NOTE: It's very important that no other users are executing tests concurrently. Your limit calculation may not include the proper results if other users are running tests at the same time.

Sample Response:

```ruby
[
   {
    "browser_short_version"=>"35",
    "video_url"=>"https://saucelabs.com/jobs/1234567890/video.flv",
    "creation_time"=>12345678890,
    "custom-data"=>nil,
    "browser_version"=>"35.0.1916.114.",
    "owner"=>"YOURUSERNAME",
    "id"=>"12a34e56i78o90u",
    "record_screenshots"=>true,
    "record_video"=>true,
    "build"=>nil,
    "passed"=>false,
    "public"=>"team",
    "end_time"=>12345678900,
    "status"=>"complete",
    "log_url"=>"https://saucelabs.com/jobs/1234567890/selenium-server.log",
    "start_time"=>1234567890,
    "proxied"=>true,
    "modification_time"=>12345678900,
    "tags"=>[],
    "name"=>"Rainforest [1]",
    "commands_not_successful"=>1,
    "consolidated_status"=>"failed",
    "assigned_tunnel_id"=>"tunn1234567890ellll",
    "error"=>nil,
    "os"=>"Windows 2008",
    "breakpointed"=>nil,
    "browser"=>"googlechrome"
    }
]
```

Filter your response array to include only failed results; `"passed" => false`.

*Step 4:* Extract required properties to re-run tests on Rainforest

The response for each result will include the browser, and the test ID, as the number within brackets in the `name` value.
Extract test information from the filtered results object:

Example results hash:
```
{"123"=>["ie11_1440_900", "windows10_edge"]}
```

*Step 5:* Run tests in Rainforest to verify the failed tests

Use Rainforest's CLI to Rainforest tests by ID against the failed broswers.

Example script to help you write yours:

```ruby
# Run your Rainforest scripts against Sauce Labs
bundle exec rainforest_test <test-file.rb>,<test-file1.rb>,<test-file2.rb> --browsers firefox,chrome,edge

# Calculate results limit, set environment info
limit = <automation script count> * <browser count> # replace placeholders with values for each run
username = ENV['SAUCE_USERNAME']
access_key = ENV['SAUCE_ACCESS_KEY']

# Make request to sauce labs
uri = URI("https://saucelabs.com/rest/v1/#{username}/jobs?limit=#{limit}&full=true")
resp = Net::HTTP.start(uri.host, uri.port, :use_ssl => 'https') do |http|
  req = Net::HTTP::Get.new uri
  req.basic_auth username, access_key
  http.request req
end

# Parse response
tests = JSON.parse(resp.body)
tests = example

# Filter for only failed tests
failed_tests = tests.select do |test|
  test['passed'] == false
end

# Mapping from Sauce browser name to Rainforest browser name
rf_browsers = {
  'googlechrome' => 'chrome_1440_900',
  'firefox' => 'firefox_1440_900',
  'iexplore' => 'ie11_1440_900',
  'microsoftedge' => 'windows10_edge',
  'safari' => 'safari_1440_900',
}

# Find Rainforest test id from name in format "Some Name [1234]"
results = {}
failed_tests.each do |test|
  name = test['name']
  id = name[/^Rainforest \[(\d+)\]/]
  next unless id

  results[id] ||= []
  results[id].push(rf_browsers[test['browser']])
end

# Execute rainforest cli once per test id
results.each do |test_id, browsers|
  system("rainforest run #{test_id} --browsers #{browsers.join(',')}")
end
```
## Contributing

1. Fork it ( https://github.com/rainforestapp/rainforest_ruby_runtime/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
