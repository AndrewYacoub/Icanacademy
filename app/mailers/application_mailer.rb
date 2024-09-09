class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com", "Message-ID" => lambda {"<#{SecureRandom.uuid}@#{ActionMailer::Base.smtp_settings[:domain]}>"}
  layout "mailer"
end