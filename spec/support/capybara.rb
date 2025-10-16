Capybara.register_driver :remote_chrome do |app|
  chrome_options = Selenium::WebDriver::Options.chrome(
    args: %w[headless disable-gpu no-sandbox window-size=1400,1400]
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://localhost:4444/wd/hub",
    capabilities: chrome_options
  )
end

Capybara.javascript_driver = :remote_chrome

Capybara.server_host = '0.0.0.0'
Capybara.server_port = 3001
Capybara.app_host = "http://host.docker.internal:3001"

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
  end
end
