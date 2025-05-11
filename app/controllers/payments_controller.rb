class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: [:new, :create]
  before_action :ensure_student!, only: [:new, :create]
  before_action :set_payment, only: [:show]

  def index
    @payments = if current_user.teacher?
      current_user.received_payments.order(created_at: :desc)
    else
      current_user.payments.order(created_at: :desc)
    end
  end

  def new
    @payment = Payment.new(course: @course)
    @stripe_publishable_key = Rails.application.credentials.dig(:stripe, :publishable_key)
  end

  def create
    @payment = current_user.payments.build(payment_params)
    @payment.teacher = @course.teacher

    begin
      payment_intent = Stripe::PaymentIntent.create(
        amount: (@payment.amount * 100).to_i,
        currency: 'usd',
        metadata: {
          course_id: @course.id,
          student_id: current_user.id,
          teacher_id: @course.teacher.id
        },
        automatic_payment_methods: {
          enabled: true
        }
      )

      @payment.stripe_payment_id = payment_intent.id
      
      if @payment.save
        render json: {
          clientSecret: payment_intent.client_secret,
          payment_id: @payment.id
        }
      else
        render json: { error: @payment.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def show
    @payment = Payment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Payment not found"
    redirect_to payments_path
  end

  def receipt
    @payment = Payment.find(params[:id])
    authorize @payment
    @copy = params[:copy].present?

    respond_to do |format|
      format.pdf do
        render pdf: "receipt_#{@payment.id}",
               template: "payments/receipt",
               layout: "pdf",
               page_size: "A4",
               margin: { top: 0, bottom: 20, left: 0, right: 0 },
               footer: {
                 font_size: 8,
                 left: "Generated on #{Time.current.strftime('%B %d, %Y at %I:%M %p')}",
                 right: 'Page [page] of [topage]',
                 spacing: 5
               },
               show_as_html: params[:debug].present?
      end
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Course not found"
    redirect_to courses_path
  end

  def payment_params
    params.require(:payment).permit(:amount, :course_id)
  end

  def ensure_student!
    unless current_user.student?
      flash[:alert] = "Only students can make payments"
      redirect_to root_path
    end
  end

  def set_payment
    @payment = if current_user.teacher?
      current_user.received_payments.find(params[:id])
    else
      current_user.payments.find(params[:id])
    end
  end
end
