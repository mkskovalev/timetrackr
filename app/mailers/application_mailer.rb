class ApplicationMailer < ActionMailer::Base
  default from: 'TimeTrackr <box@timetrackr.dev>'
  layout "mailer"
end
