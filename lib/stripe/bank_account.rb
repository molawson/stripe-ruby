module Stripe
  class BankAccount < APIResource
    include Stripe::APIOperations::Update
    include Stripe::APIOperations::Delete

    def verify(params={}, opts={})
      # TODO: Hopefully this special case will go away in future versions of the API.
      # For now, there is no `POST /customers/{customer_id}/sources/{source_id}/verify` endpoint,
      # only `POST /customers/{customer_id}/bank_accounts/{source_id}/verify`.
      verify_base = url.sub('/sources/', '/bank_accounts/')
      response, opts = request(:post, "#{verify_base}/verify", params, opts)
      refresh_from(response, opts)
    end

    # Helps unify the interface with Card
    def brand
      bank_name
    end

    def url
      if respond_to?(:customer)
        "#{Customer.url}/#{CGI.escape(customer)}/sources/#{CGI.escape(id)}"
      elsif respond_to?(:account)
        "#{Account.url}/#{CGI.escape(account)}/external_accounts/#{CGI.escape(id)}"
      end
    end

    def self.retrieve(id, opts=nil)
      raise NotImplementedError.new("Bank accounts cannot be retrieved without an account ID. Retrieve a bank account using account.external_accounts.retrieve('account_id')")
    end
  end
end
