class StudentMailer < ApplicationMailer
  def payment_success(payment)
    @payment = payment
    @student = payment.student
    @course = payment.course
    @teacher = payment.teacher

    mail(
      to: @student.email,
      subject: "Payment Confirmation - #{@course.title}"
    )
  end

  def payment_failed(payment)
    @payment = payment
    @student = payment.student
    @course = payment.course

    mail(
      to: @student.email,
      subject: "Payment Failed - #{@course.title}"
    )
  end
end
