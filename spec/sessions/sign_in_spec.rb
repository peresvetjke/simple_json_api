require "rails_helper"

describe "Sign in", type: :request do
  let(:headers)         { { "ACCEPT" => "application/json" } }
  let!(:user)           { create(:user) }

  describe "POST /auth/sign_in" do
    let(:method)    { "post" }
    let(:path)      { "/auth/sign_in" }
      
    before { do_request(method, 
                        path, 
                        params: params, 
                        headers: headers) 
           }

    context "with valid params" do
      let(:params) {{ email: user.email, password: user.password }}

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