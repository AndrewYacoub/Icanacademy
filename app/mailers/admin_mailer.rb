class AdminMailer < ApplicationMailer
  default to: -> { AdminUser.pluck(:email) }

  def transfer_failed(payment)
    @payment = payment
    @teacher = payment.teacher
    @course = payment.course
    @error = payment.transfer_error
    @amount = payment.teacher_share

    mail(
      subject: "ALERT: Teacher Payment Transfer Failed - #{@course.title}"
    )
  end
end
