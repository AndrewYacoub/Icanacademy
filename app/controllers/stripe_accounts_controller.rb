class StripeAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_teacher!

  def new
    if current_user.stripe_account_id.present?
      redirect_to stripe_account_status_path, notice: 'You already have a Stripe account connected.'
      return
    end

    account_id = current_user.setup_stripe_express_account
    
    if account_id
      account_link = current_user.stripe_account_link(
        refresh_url: stripe_account_refresh_url,
        return_url: stripe_account_return_url
      )
      
      if account_link
        redirect_to account_link.url, allow_other_host: true
      else
        redirect_to teacher_dashboard_path, alert: 'Failed to create Stripe account link. Please try again.'
      end
    else
      redirect_to teacher_dashboard_path, alert: 'Failed to create Stripe account. Please try again.'
    end
  end

  def refresh
    if current_user.stripe_account_id.present?
      account_link = current_user.stripe_account_link(
        refresh_url: stripe_account_refresh_url,
        return_url: stripe_account_return_url
      )
      
      if account_link
        redirect_to account_link.url, allow_other_host: true
      else
        redirect_to teacher_dashboard_path, alert: 'Failed to refresh Stripe account link. Please try again.'
      end
    else
      redirect_to new_stripe_account_path
    end
  end

  def return
    status = current_user.stripe_account_status

    if status && status[:details_submitted]
      if status[:charges_enabled] && status[:payouts_enabled]
        current_user.update(payout_enabled: true)
        redirect_to teacher_dashboard_path, notice: 'Your Stripe account has been successfully connected!'
      else
        redirect_to teacher_dashboard_path, alert: 'Your account is connected but not yet ready to receive payments. Please complete all requirements in your Stripe dashboard.'
      end
    else
      redirect_to teacher_dashboard_path, alert: 'Please complete your Stripe account setup to receive payments.'
    end
  end

  def status
    @status = current_user.stripe_account_status

    unless @status
      redirect_to teacher_dashboard_path, alert: 'Unable to retrieve Stripe account status.'
      return
    end

    respond_to do |format|
      format.html
      format.json { render json: @status }
    end
  end

  private

  def ensure_teacher!
    unless current_user.teacher?
      redirect_to root_path, alert: 'Access denied. Teachers only.'
    end
  end
end
