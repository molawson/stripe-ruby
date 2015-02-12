module Stripe
  class BankAccount < APIResource
    include Stripe::APIOperations::Update
    include Stripe::APIOperations::Delete
    include Stripe::APIOperations::List

    def verify(params={}, opts={})
      response, opts = request(:post, "#{url}/verify", params, opts)
      refresh_from(response, opts)
    end

    def url
      "#{Customer.url}/#{CGI.escape(customer)}/bank_accounts/#{CGI.escape(id)}"
    end

    def self.retrieve(id, api_key=nil)
      raise NotImplementedError.new("Bank accounts cannot be retrieved without a customer ID. Retrieve a bank account using customer.bank_accounts.retrieve('bank_account_id')")
    end
  end
end
