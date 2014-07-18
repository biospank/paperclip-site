class SubscriptionsController < ApplicationController

	protect_from_forgery with: :exception, except: [:confirm]

	before_action :authenticate_user!, except: [:confirm]
	before_action :find_subscription, only: [:show, :execute, :cancel, :invoice_download, :thank_you]

	def index
		@subscriptions = policy_scope(Subscription).includes(:plan).order(created_at: :desc).limit(5).all
	end

	def show

	end

  def new
		flash.clear
		@customer = Customer.find_or_initialize_by(user: current_user)
		if @customer.services.empty?
			@service = Service.find(params[:service])
  		@subscription = Subscription.new(email: current_user.email, plan: Plan.first)
		else
			@service = @customer.services.first
			@subscription = Subscription.new(email: current_user.email, plan: Plan.where(service: @service).first)
		end
  end

	def save_customer_data
		@customer = Customer.find_or_initialize_by(user: current_user)
		@customer.attributes = customer_params
		#binding.pry
		#@plan = Plan.find(params[:subscription][:plan_id])

		respond_to do |format|
			if @customer.valid?
				@customer.save
				format.js { render 'customer_data', locals: { ok: true } }
			else
				flash.now['error'] = @customer.error_message
				format.js { render 'customer_data', locals: { ok: false } }
			end
		end

	end

	def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.valid?

			begin

				@subscription.user_id = current_user.id
				@subscription.expiry_date = @subscription.plan.expiry_date
				@subscription.amount = @subscription.plan.grand_total
				@subscription.save
				payment = Paypal.new(
						action: :request,
						service: @subscription.plan.service.name,
						plan: @subscription.plan.name,
						amount: @subscription.plan.grand_total_string,
						confirm_url: subscription_execute_url(@subscription),
						cancel_url: subscription_cancel_url(@subscription)
				)

				if payment.request
					@subscription.state = payment.state
					@subscription.info = "Richiesta autorizzazione."
					@subscription.paypal_payment_token = payment.id
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
					# to delete
					# @subscription.create_invoice_for(Customer.find_by_user_id(current_user))
					# end
					redirect_to subscription_thank_you_url(@subscription)
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

	def invoice_download
		# if pdf_file = @subscription.invoice.pdf_exist?
		# 	send_file pdf_file
		# else
			send_file @subscription.invoice.generate_pdf(view_context)
		# end
	end

	def reload
		@service = Service.find(params[:service])
		@subscription = Subscription.new(email: current_user.email, plan: Plan.where(service: @service).first)

		respond_to do |format|
			format.js { render 'reload' }
		end
	end

  def plan_detail
    @plan = Plan.find(params[:subscription][:plan_id])

    respond_to do |format|
      format.js { render 'plan_detail' }
    end
  end

	private

	def find_subscription
		@subscription = Subscription.find(params[:subscription_id] || params[:id])
		authorize @subscription
	end

  def subscription_params
    params.require(:subscription).permit(:plan_id, :email)
  end

	def customer_params
		params.require(:customer).permit(:name, :tax_code, :address, :cap, :city, :terms_of_service, :service_ids)
	end

end
