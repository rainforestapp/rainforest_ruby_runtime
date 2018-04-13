# 0.1.1 - 2018-04-13

- Monkey patch `Process::RLIMIT_NOFILE` and `Process.getrlimit` on Windows
- Fixed SauceConnect executable path on Windows
- Don't start local server when running from a Rails repo

# 0.1.0 - 2018-04-12

- Support multiple browsers with `--browsers` param
- Change default browser to `chrome` (used to be `firefox`)
- Support running multiple scripts at once
- Use RSpec for running scripts and displaying results
- Remove support for BrowserStack and TestingBot
- Remove support for IE 8, 9, and 10 on SauceLabs
- Update browser versions on SauceLabs, add Microsoft Edge
- Add changelog
