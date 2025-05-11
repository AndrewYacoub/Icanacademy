class TeacherMailer < ApplicationMailer
  def new_payment(payment)
    @payment = payment
    @teacher = payment.teacher
    @student = payment.student
    @course = payment.course

    mail(
      to: @teacher.email,
      subject: "New Payment Received - #{@course.title}"
    )
  end

  def transfer_success(payment)
    @payment = payment
    @teacher = payment.teacher
    @course = payment.course
    @amount = payment.teacher_share

    mail(
      to: @teacher.email,
      subject: "Payment Transfer Successful - #{@course.title}"
    )
  end

  def transfer_failed(payment)
    @payment = payment
    @teacher = payment.teacher
    @course = payment.course
    @error = payment.transfer_error

    mail(
      to: @teacher.email,
      subject: "Payment Transfer Failed - #{@course.title}"
    )
  end
end
