# The idea of a Payment as separate from a Charge appears to be a temporary
# construct. Since you currently can't do everything with Payments via the
# /v1/charges endpoints, we need this class to fill in the gaps until everything
# has been combined under Charges.
#
# TODO: Once ACH charges can be listed via GET /v1/charges, it should be safe to
# remove this class entirely.
module Stripe
  class Payment < APIResource
    include Stripe::APIOperations::List
    include Stripe::APIOperations::Update

    def self.retrieve(id, opts=nil)
      raise NotImplementedError.new("Payments are a temporary construct cannot be retrieved. Retrieve a payment as a charge using charges.retrieve('payment_id')")
    end
  end
end
