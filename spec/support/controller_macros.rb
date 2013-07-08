module ControllerMacros
  def login_user
    before(:each) do
      [:role_1, :role_2].each do |v|
        FactoryGirl.create(v)
      end
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user)
    end
  end
end
