class ApplicationMailer < ActionMailer::Base
  helper :mailers

  default from: 'TimeTrackr <box@timetrackr.dev>'
  
  layout "mailer"
end
