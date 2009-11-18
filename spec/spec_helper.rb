$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'encoding-dot-com'
require 'spec'
require 'spec/autorun'
require 'nokogiri'
require 'encoding_dot_com/facade'

class EncodingXpathMatcher
  def initialize(xpath)
    @xpath = xpath
  end

  def ==(post_vars)
    ! Nokogiri::XML(post_vars[:xml]).xpath(@xpath).empty?
  end
end

module XpathMatchers
  class HaveXpath
    def initialize(xpath)
      @xpath = xpath
    end

    def matches?(xml)
      @xml = xml
      Nokogiri::XML(xml).xpath(@xpath).any?
    end

    def failure_message
      "expected #{@xml} to have xpath #{@xpath}"
    end

    def negative_failure_message
      "expected #{@xml} not to have xpath #{@xpath}"
    end
  end

  def have_xpath(xpath)
    HaveXpath.new(xpath)
  end
end

Spec::Runner.configure do |config|
  config.include(XpathMatchers)
end
