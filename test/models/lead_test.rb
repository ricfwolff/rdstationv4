require 'test_helper'

class LeadTest < ActiveSupport::TestCase
  test "should not save lead without name" do
  	lead = Lead.new
  	assert_not lead.save, "Saved the lead without a name"
  end

  test "save lead" do
  	lead = Lead.new
  	lead.name = "Ricardo"
  	lead.last_name = "Wolff"
  	lead.email = "ricfwolff@gmail.com"
  	lead.company = "wolff"
  	lead.job_title = "developer"
  	lead.phone = "phone"
  	lead.website = "site"
  	assert lead.save, "Didn't save the lead"
  end
end
