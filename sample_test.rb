require 'rubygems'
require 'selenium-webdriver'
require 'testingbot'
require 'test-unit'

class SampleTest < Test::Unit::TestCase
    def setup
        caps = Selenium::WebDriver::Remote::Capabilities.new
        caps["browserName"] = "#{ENV['browserName']}"
        caps["version"] = "#{ENV['version']}"
        caps["platform"] = "#{ENV['platform']}"
        caps["name"] = @method_name

        url = "https://#{ENV['TB_KEY']}:#{ENV['TB_SECRET']}@hub.testingbot.com/wd/hub".strip
        @driver = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => caps)
    end

    def test_google
        @driver.navigate.to "http://www.google.com/ncr"
        element = @driver.find_element(:name, 'q')
        element.send_keys "TestingBot"
        element.submit
        sleep 2
        assert_equal(@driver.title, "TestingBot - Google Search")
    end

    def teardown
        sessionid = @driver.session_id
        @driver.quit

        api = TestingBot::Api.new(ENV['TB_KEY'], ENV['TB_SECRET'])
        if @_result.passed?
          api.update_test(sessionid, { :success => true })
        else
          api.update_test(sessionid, { :success => false })
        end
    end
end