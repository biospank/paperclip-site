describe SubscriptionsController do
  context "GET #index:" do
    describe "signed_in user:" do
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
end
