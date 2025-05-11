class PaymentProcessorService
  def initialize(payment)
    @payment = payment
  end

  def process
    return false unless @payment.valid?

    begin
      create_stripe_payment
      update_payment_status('completed')
      transfer_teacher_share
      true
    rescue Stripe::StripeError => e
      handle_stripe_error(e)
      false
    rescue StandardError => e
      handle_standard_error(e)
      false
    end
  end

  private

  def create_stripe_payment
    intent = Stripe::PaymentIntent.create(
      amount: (@payment.amount * 100).to_i, # Convert to cents
      currency: 'usd',
      metadata: {
        payment_id: @payment.id,
        course_id: @payment.course_id,
        student_id: @payment.student_id,
        teacher_id: @payment.teacher_id
      },
      automatic_payment_methods: {
        enabled: true
      }
    )

    @payment.update!(stripe_payment_id: intent.id)
    intent
  end

  def transfer_teacher_share
    return unless @payment.completed?

    transfer = Stripe::Transfer.create(
      amount: (@payment.teacher_share * 100).to_i,
      currency: 'usd',
      destination: @payment.teacher.stripe_account_id,
      transfer_group: "Payment_#{@payment.id}",
      metadata: {
        payment_id: @payment.id,
        course_id: @payment.course_id
      }
    )

    @payment.update!(stripe_transfer_id: transfer.id)
  end

  def update_payment_status(status)
    @payment.update!(status: status)
  end

  def handle_stripe_error(error)
    error_message = case error
    when Stripe::CardError
      "Card was declined: #{error.message}"
    when Stripe::InvalidRequestError
      "Invalid payment request: #{error.message}"
    else
      "Payment processing error: #{error.message}"
    end

    @payment.update!(
      status: 'failed',
      error_message: error_message
    )
  end

  def handle_standard_error(error)
    @payment.update!(
      status: 'failed',
      error_message: "An unexpected error occurred: #{error.message}"
    )
    Rails.logger.error("Payment processing error: #{error.message}")
  end
end
