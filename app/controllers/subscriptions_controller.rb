class SubscriptionsController < ApplicationController

	protect_from_forgery with: :exception, except: [:confirm]

	before_action :authenticate_user!, except: [:confirm]
	before_action :find_subscription, only: [:execute, :cancel]

  def new
    @subscription = Subscription.new(email: current_user.email, plan: Plan.first)
  end

	def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.valid?

			begin

				@subscription.user_id = current_user.id
				@subscription.expiry_date = @subscription.plan.expiry_date
				@subscription.amount = @subscription.plan.discounted_price
				@subscription.save
				payment = Paypal.new(
						action: :request,
						plan: @subscription.plan.name,
						amount: @subscription.plan.discounted_price_decimal,
						confirm_url: subscription_execute_url(@subscription),
						cancel_url: subscription_cancel_url(@subscription)
				)

				if payment.request
					@subscription.state = payment.state
					@subscription.info = "Richiesta autorizzazione."
					@subscription.paypal_payment_token = payment.id
					@subscription.gen_key_for(current_user)
	      	redirect_to payment.approval_url
				else
					@subscription.state = payment.state
					@subscription.info = "Richiesta autorizzazione fallita."
					PaymentNotification.create!(
						:subscription => @subscription,
						:detail => payment.error
					)
					flash.now['error'] = "Richiesta di autorizzazione fallita.<br />Se il problema persiste, contattare il <a href='#{new_contact_url}'>servizio assistenza</a>" #payment.error['message']
					render action: 'new'
				end

			ensure
				@subscription.save
			end

    else
      render action: 'new'
    end

	end

	def execute
		if @subscription
			begin

				@subscription.paypal_customer_token = params["PayerID"]
				# payment = Paypal.new(
				# 	action: :execute,
				# 	payment_token: @subscription.paypal_payment_token
				# )
				payment = Paypal.find_payment(@subscription.paypal_payment_token)
				if payment.execute( :payer_id => @subscription.paypal_customer_token )
				# if payment.execute!(@subscription.paypal_customer_token)
					@subscription.state = payment.state
					@subscription.info = "Transazione approvata."
					redirect_to subscription_recap_url(@subscription)
				else
					@subscription.state = payment.state
					@subscription.info = "Transazione fallita."
					PaymentNotification.create!(
						:subscription => @subscription,
						:detail => payment.error
					)
					flash.now['error'] = "Transazione fallita.<br />Se il problema persiste, contattare il <a href='#{new_contact_url}'>servizio assistenza</a>" #payment.error['message']
					render action: 'new'
				end

			ensure
				@subscription.save
			end

		else
			redirect_to root_url
		end
	end

	def confirm
		ipn = Paypal::IPN::Notification.new(params)

		if ipn.send_ack_response(params)
			if @subscription = Subscription.find_by_paypal_customer_token(ipn.payer_id)
				if ipn.verify!(@subscription)
					SubscriptionMailer.confirm_subscription(@subscription).deliver
				end
			end
		end

		render :nothing => true
	end

	def cancel
		if @subscription
			PaymentNotification.create!(
				:subscription => @subscription,
				:detail => {:message => "Sottoscrizione annullata."}
			)
			@subscription.save
		end

		redirect_to root_url
	end

	def recap
		@subscription = policy_scope(Subscription).find(params[:subscription_id])
		authorize @subscription
	rescue ActiveRecord::RecordNotFound
		redirect_to root_url
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
		authorize @subscription
	end

  def subscription_params
    params.require(:subscription).permit(:plan_id, :email)
  end

end
