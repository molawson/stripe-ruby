require File.expand_path('../../test_helper', __FILE__)

module Stripe
  class PaymentTest < Test::Unit::TestCase
    should "payments should be listable" do
      @mock.expects(:get).once.returns(test_response(test_payment_array))
      c = Stripe::Payment.all
      assert c.data.kind_of? Array
      c.each do |payment|
        assert payment.kind_of?(Stripe::Payment)
      end
    end

    should "payments should not be deletable" do
      assert_raises NoMethodError do
        @mock.expects(:get).once.returns(test_response(test_payment))
        c = Stripe::Payment.retrieve("test_payment")
        c.delete
      end
    end

    should "payments should be updateable" do
      @mock.expects(:get).once.returns(test_response(test_payment))
      @mock.expects(:post).once.returns(test_response(test_payment))
      c = Stripe::Payment.new("test_payment")
      c.refresh
      c.mnemonic = "New payment description"
      c.save
    end

    should "payments should have BankAccount objects associated with their payment_source property" do
      @mock.expects(:get).once.returns(test_response(test_payment))
      c = Stripe::Payment.retrieve("test_payment")
      assert c.payment_source.kind_of?(Stripe::StripeObject) && c.payment_source.object == 'bank_account'
    end
  end
end
