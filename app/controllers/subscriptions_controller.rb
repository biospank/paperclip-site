class SubscriptionsController < ApplicationController

	before_action :authenticate_user!
	before_action :find_subscription, only: [:confirm, :cancel, :recap]

  def new
    @subscription = Subscription.new(email: current_user.email, plan: Plan.first)
  end

	def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.valid?
			@subscription.user_id = current_user.id
			@subscription.expiry_date = @subscription.plan.expiry_date
			@subscription.amount = @subscription.plan.discounted_price
			@subscription.save
			payment = Paypal.new(
					action: :request,
					amount: @subscription.plan.discounted_price_decimal,
					confirm_url: subscription_confirm_url(@subscription),
					cancel_url: subscription_cancel_url(@subscription)
			)

			if payment.request
				@subscription.state = payment.state
				@subscription.paypal_payment_token = payment.id
				@subscription.gen_key_for(current_user)
	      @subscription.save
      	redirect_to payment.approval_url
			else
				@subscription.state = payment.state
				@subscription.error = payment.error
				@subscription.save
				flash.now['error'] = "Richiesta di autorizzazione fallita.<br />Se il problema persiste, contattare il <a href='#{new_contact_url}'>servizio assistenza</a>" #payment.error['message']
				render action: 'new'
			end
    else
      render action: 'new'
    end

	end

	def confirm
		if @subscription
			@subscription.paypal_customer_token = params["PayerID"]
			# payment = Paypal.new(
			# 	action: :execute,
			# 	payment_token: @subscription.paypal_payment_token
			# )
			payment = Paypal.find_payment(@subscription.paypal_payment_token)
			if payment.execute( :payer_id => @subscription.paypal_customer_token )
			# if payment.execute!(@subscription.paypal_customer_token)
				@subscription.state = payment.state
				@subscription.save
				SubscriptionMailer.confirm_subscription(@subscription).deliver
				redirect_to subscription_recap_url(@subscription)
			else
				@subscription.state = payment.state
				@subscription.error = payment.error
				@subscription.save
				flash.now['error'] = "Transazione fallita.<br />Se il problema persiste, contattare il <a href='#{new_contact_url}'>servizio assistenza</a>" #payment.error['message']
				render action: 'new'
			end
		else
			redirect_to root_url
		end
	end

	def cancel
		if @subscription
			@subscription.error = 'La sottoscrizione è stata annullata.'
			@subscription.save
		end

		redirect_to root_url
	end

	def recap

	end

  def plan_detail
    @plan = Plan.find(params[:subscription][:plan_id])

    respond_to do |format|
      format.js { render :partial => 'plan_detail' }
    end
  end

	private

		def find_subscription
			@subscription = Subscription.find(params[:subscription_id])
		end

    def subscription_params
      params.require(:subscription).permit(:plan_id, :email)
    end
end
