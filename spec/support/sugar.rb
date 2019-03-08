# rubocop:disable Rails/HttpPositionalArguments

# TODO I think this sugar thing was added to facilitate HTTP Authentication
# for tests. In which case, it is no longer necessary and can probably
# be removed.

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
  return { params: sweetened }
end
