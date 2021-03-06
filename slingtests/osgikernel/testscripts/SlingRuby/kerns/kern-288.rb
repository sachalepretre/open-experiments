#!/usr/bin/env ruby

require 'sling/test'
require 'sling/search'
require 'sling/contacts'
require 'test/unit.rb'
require 'test/unit/ui/console/testrunner.rb'
include SlingContacts

class TC_Kern288Test < SlingTest

  def test_connection_details
    m = Time.now.to_i.to_s
    u1 = create_user("testuser#{m}")
    u2 = create_user("otheruser#{m}")
    cm = ContactManager.new(@s)
    @s.switch_user(u1)
    cm.invite_contact(u2.name, "follower")
    pending = cm.get_pending
    assert(pending["results"].size == 1, "Expected pending invitation")
    res = cm.cancel_invitation(u2.name)
    assert_equal("200", res.code, "Expected cancel to succeed")
    pending = cm.get_pending
    assert(pending["results"].size == 0, "Expected no pending invitation")
  end

end

Test::Unit::UI::Console::TestRunner.run(TC_Kern288Test)

