module Webhooks
  class StripeController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :verify_stripe_webhook

    def create
      case stripe_event.type
      when 'payment_intent.succeeded'
        handle_payment_success(stripe_event.data.object)
      when 'payment_intent.payment_failed'
        handle_payment_failure(stripe_event.data.object)
      when 'transfer.created'
        handle_transfer_success(stripe_event.data.object)
      when 'transfer.failed'
        handle_transfer_failure(stripe_event.data.object)
      end

      head :ok
    rescue JSON::ParserError => e
      head :bad_request
    rescue Stripe::SignatureVerificationError => e
      head :bad_request
    end

    private

    def verify_stripe_webhook
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      
      begin
        @stripe_event = Stripe::Webhook.construct_event(
          payload, sig_header, stripe_webhook_secret
        )
      rescue JSON::ParserError => e
        status 400
        return
      rescue Stripe::SignatureVerificationError => e
        status 400
        return
      end
    end

    def stripe_event
      @stripe_event
    end

    def stripe_webhook_secret
      Rails.application.credentials.dig(:stripe, :webhook_secret)
    end

    def handle_payment_success(payment_intent)
      payment = Payment.find_by(stripe_payment_id: payment_intent.id)
      return unless payment

      payment.update!(status: 'completed')
      
      # Notify users
      notify_payment_success(payment)
    end

    def handle_payment_failure(payment_intent)
      payment = Payment.find_by(stripe_payment_id: payment_intent.id)
      return unless payment

      payment.update!(
        status: 'failed',
        error_message: payment_intent.last_payment_error&.message
      )

      # Notify users
      notify_payment_failure(payment)
    end

    def handle_transfer_success(transfer)
      payment = Payment.find_by(stripe_transfer_id: transfer.id)
      return unless payment

      payment.update!(transfer_status: 'completed')
      
      # Notify teacher
      notify_transfer_success(payment)
    end

    def handle_transfer_failure(transfer)
      payment = Payment.find_by(stripe_transfer_id: transfer.id)
      return unless payment

      payment.update!(
        transfer_status: 'failed',
        transfer_error: transfer.failure_message
      )

      # Notify admin and teacher
      notify_transfer_failure(payment)
    end

    def notify_payment_success(payment)
      # Send email notifications
      StudentMailer.payment_success(payment).deliver_later
      TeacherMailer.new_payment(payment).deliver_later
    end

    def notify_payment_failure(payment)
      # Send email notifications
      StudentMailer.payment_failed(payment).deliver_later
    end

    def notify_transfer_success(payment)
      # Send email notification to teacher
      TeacherMailer.transfer_success(payment).deliver_later
    end

    def notify_transfer_failure(payment)
      # Send email notifications
      TeacherMailer.transfer_failed(payment).deliver_later
      AdminMailer.transfer_failed(payment).deliver_later
    end
  end
end
