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
        @mock.expects(:get).once.returns(test_response(test_payment_array))
        c = Stripe::Payment.all.first
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

    should "not be retrievable" do
      assert_raises NotImplementedError do
        Stripe::Payment.retrieve("test_payment")
      end
    end

    should "not be creatable" do
      assert_raises NoMethodError do
        Stripe::Payment.create(
          :amount => 100,
          :bank_account => "test_bank_account_token",
          :currency => "usd"
        )
      end
    end
  end
end
