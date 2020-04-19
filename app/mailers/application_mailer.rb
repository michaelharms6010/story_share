class ApplicationMailer < ActionMailer::Base
  require 'mail'

  address = Mail::Address.new("noreply@br80.io")
  address.display_name = "Story Friends"  # Appears as the sendee's name
  default from: address.format

  layout 'mailer'
end
