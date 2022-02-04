module RequestHelper
  def json
    JSON.parse(response.body)
  end

  def sign_in_with(user)
    allow_any_instance_of(ApplicationController).to receive(:authenticate_or_request_with_http_token) do |&block|
      block.call(nil, nil)
    end
    verifier = instance_double(TokenVerifier)
    allow(TokenVerifier).to receive(:new).with(nil).and_return(verifier)
    allow(verifier).to receive(:execute).and_return(user.firebase_uid)
  end
end
