class SubscriptionsController < ApplicationController

	before_action :authenticate_user!
	
  def new
    @subscription = Subscription.new(email: current_user.email)
    @plan = Plan.first
  end
	
	def create
    @subscription = params[:subscription]
    
    if @subscription.valid?
      # TODO
      # - pagamento
      # - generazione della chiave
#        customer = Customer.create!(
#          email: current_user.email
#        )
      @subscription.gen_key_for!(current_user)
      @subscription.save!
      format.html { redirect_to new_contact_url, notice: 'Messaggio inviato!' }
    else
      format.html { render action: 'new' }
    end
		
	end
  
  def plan_detail
    plan = Plan.find(params[:plan_id])
      
    respond_to do |format|
      format.js { render :partial => 'plan_detail' }
    end
  end
  
end
