# rubocop:disable Rails/HttpPositionalArguments

# I do no like how params: is a required keyword argument
def gt(action, params = {})
  get url_for(action), extract_request_params(params)
end

def pst(action, params = {})
  post url_for(action), extract_request_params(params)
end

def ptch(action, params = {})
  patch url_for(action), extract_request_params(params)
end

def del(action, params = {})
  delete url_for(action), extract_request_params(params)
end

def extract_request_params(sweetened)
  headers = authorization_header

  if sweetened.key?(:format)
    headers['HTTP_ACCEPT'] = 'application/json' if sweetened[:format] == :json
    sweetened.delete :format
  end

  return { params: sweetened, headers: headers }
end
