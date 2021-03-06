#!/usr/bin/env ruby


require 'sling/sling'
require 'sling/test'
require 'test/unit.rb'
require 'test/unit/ui/console/testrunner.rb'
include SlingInterface
include SlingUsers

class TC_RSSTest < SlingTest

  def test_valid_rss_file
    # Do a GET request to a valid RSS file.
    res = @s.execute_get(@s.url_for("var/proxy/rss.json"), {"rss" => "http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/front_page/rss.xml"})
    assert_equal(200, res.code.to_i, "This is a valid XML file, this should return 200.")
  end

  def test_regular_file
    # Do a GET request to a non XML file.
    res = @s.execute_get(@s.url_for("var/proxy/rss.json"), {"rss" => "http://www.google.com"})
    assert_equal(403, res.code.to_i, "This is not an XML file. Service should return 403.")
  end

  def test_invalid_xml_file
    # Do a GET request to a valid XML file but it is not an RSS file.
    res = @s.execute_get(@s.url_for("var/proxy/rss.json"), {"rss" => "http://www.w3schools.com/xml/note.xml"})
    assert_equal(403, res.code.to_i, "This is a plain XML (non-RSS) file. Service should return 403.")
  end


  def test_big_file
    # Do a GET request to a huge file.
    res = @s.execute_get(@s.url_for("var/proxy/rss.json"), {"rss" => "http://ftp.belnet.be/packages/apache/sling/org.apache.sling.launchpad.app-5-incubator-bin.tar.gz"})
    assert_equal(403, res.code.to_i, "This file is way to big. Service should return 403")
  end



end

Test::Unit::UI::Console::TestRunner.run(TC_RSSTest)