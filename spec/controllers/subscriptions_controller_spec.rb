describe SubscriptionsController do
  context "GET #index:" do
    describe "signed in user:" do
      before :each do
        #@request.env["devise.mapping"] = Devise.mappings[:user]
        @usr = create(:user)
        sign_in @usr
      end

      it "assigns all subscriptions that belongs to current_user" do

        subscription = create(:subscription, user: @usr, state: Paypal::PAYMENT::STATUS::PENDING)
        get :index
        @subscriptions = assigns(:subscriptions)
        expect(@subscriptions).to include(subscription)
        expect(@subscriptions.first.user).to be_eql(@usr)
      end

      it "render the :index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe "unsigned user:" do
      it "to redirect to login" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  context "GET #new:" do
    describe "unsigned user:" do
      it "to redirect to login" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "signed in user:" do
      before :each do
        @usr = create(:user)
        sign_in @usr
      end

      describe "new customer:" do
        it "has a plan associated with service selected by user" do
          create(:plan)
          get :new, service: 1
          @subscription = assigns(:subscription)
          expect(@subscription.plan).not_to be_nil
          expect(@subscription.plan.service.id).to be_eql(1)
        end
      end

      describe "returning customer:" do
        before :each do
          plan = create(:plan)
          customer = create(:customer, user: @usr)
          customer.services << plan.service
          get :new
          @customer = assigns(:customer)
        end

        it "has a customer object associated" do
          expect(@customer).not_to be_nil
        end

        it "has a subscription service associated" do
          expect(@customer.services).not_to be_empty
        end

        it "render the :new template" do
          expect(response).to render_template(:new)
        end
      end
    end
  end

  context "POST #save_customer_data" do
    describe "- signed in user" do
      before :each do
        @usr = create(:user)
        sign_in @usr
      end

      describe "- valid customer data" do

        it "render the :customer_data template with ok = true" do
          post :save_customer_data, format: :js, customer: attributes_for(:customer)
          expect(response).to render_template(:customer_data)
          expect(assigns(:customer)).to be_valid
        end
      end

      describe "invalid customer data" do
        it "render the :customer_data template with ok = true" do
          post :save_customer_data, format: :js, customer: attributes_for(:customer, cap: nil)
          expect(response).to render_template(:customer_data)
          expect(assigns(:customer)).not_to be_valid
        end
      end
    end
  end
end
