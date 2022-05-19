require "rails_helper"

describe "Sign up", type: :request do
  let(:headers)         { { "ACCEPT" => "application/json" } }
  let!(:user)           { build(:user) }

  describe "POST /auth" do
    let(:method)    { "post" }
    let(:path)      { "/api/v1/auth" }
      
    before { do_request(method, 
                        path, 
                        params: params, 
                        headers: headers) 
           }

    context "with valid params" do
      let(:params) {{ email: user.email, password: user.password, password_confirmation: user.password }}

      it "return successfull status" do
        expect(response).to be_successful
      end

      it "returns client and token" do
        expect(response.headers['uid']).to eq user.email
        %w[access-token client].each do |attr|
          expect(response.headers[attr]).not_to be_nil
        end
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