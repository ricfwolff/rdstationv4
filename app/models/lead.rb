class Lead < ActiveRecord::Base
	validates :name, presence: true
	validates :last_name, presence: true
	validates :email, presence: true
	validates :company, presence: true
	validates :job_title, presence: true
	validates :phone, presence: true
	validates :website, presence: true
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end
