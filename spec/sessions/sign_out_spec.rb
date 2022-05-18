require "rails_helper"

describe "Sign out", type: :request do
  let(:headers)         { { "ACCEPT" => "application/json" } }
  let!(:user)           { create(:user) }
  let!(:session)        { @session ||= sign_in(user) }

  describe "DELETE /auth" do
    let(:method)    { "delete" }
    let(:path)      { "/auth/sign_out" }
      
    before { do_request(method, 
                        path, 
                        params: params, 
                        headers: headers) 
           }

    context "with valid params" do
      let(:params) {{ 'uid'           => session['uid'], 
                      'client'        => session['client'], 
                      'access-token'  => session['access-token'] 
                   }}

      it "return successfull status" do
        expect(response).to be_successful
      end
    end

    context "with invalid params" do
      let(:params) {{ }}

      it "return unsuccessfull status" do
        expect(response).not_to be_successful
      end
    end
  end
end