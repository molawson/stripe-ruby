require File.expand_path('../../test_helper', __FILE__)

module Stripe
  class CustomerBankAccountTest < Test::Unit::TestCase
    CUSTOMER_BANK_ACCOUNT_URL = '/v1/customers/test_customer/sources/test_bank_account'
    # Hopefully this special case will go away in future versions of the API
    CUSTOMER_VERIFY_BANK_ACCOUNT_BASE = '/v1/customers/test_customer/bank_accounts/test_bank_account'

    def customer
      @mock.expects(:get).once.returns(test_response(test_customer))
      Stripe::Customer.retrieve('test_customer')
    end

    should "customer bank accounts should be listable" do
      c = customer
      @mock.expects(:get).once.returns(test_response(test_bank_account_array(customer.id)))
      bank_accounts = c.bank_accounts.all.data
      assert bank_accounts.kind_of? Array
      assert bank_accounts[0].kind_of? Stripe::BankAccount
    end

    should "customer bank accounts should have the correct url" do
      c = customer
      @mock.expects(:get).once.returns(test_response(test_bank_account(
        :id => 'test_bank_account',
        :customer => 'test_customer'
      )))
      bank_account = c.bank_accounts.retrieve('bank_account')
      assert_equal CUSTOMER_BANK_ACCOUNT_URL, bank_account.url
    end

    should "customer bank accounts should be deletable" do
      c = customer
      @mock.expects(:get).once.returns(test_response(test_bank_account))
      @mock.expects(:delete).once.returns(test_response(test_bank_account(:deleted => true)))
      bank_account = c.bank_accounts.retrieve('bank_account')
      bank_account.delete
      assert bank_account.deleted
    end

    should "customer bank accounts should be updateable" do
      c = customer
      @mock.expects(:get).once.returns(test_response(test_bank_account(:metadata => {:foo => "bar"})))
      @mock.expects(:post).once.returns(test_response(test_bank_account(:metadata => {:foo => "baz"})))
      bank_account = c.bank_accounts.retrieve('bank_account')
      assert_equal "bar", bank_account.metadata.foo
      bank_account.metadata.foo = "baz"
      bank_account.save
      assert_equal "baz", bank_account.metadata.foo
    end

    should "create should return a new customer bank account" do
      c = customer
      @mock.expects(:post).once.returns(test_response(test_bank_account(:id => "test_bank_account")))
      bank_account = c.bank_accounts.create(:bank_account => "btok_41YJ05ijAaWaFS")
      assert_equal "test_bank_account", bank_account.id
    end

    should "customer bank accounts should be verifiable" do
      c = customer
      @mock.expects(:get).once.returns(test_response(test_bank_account(
        :id => 'test_bank_account',
        :customer => 'test_customer',
        :status => 'new'
      )))
      @mock.expects(:post).once.with do |url, api_key, params|
        url == "#{Stripe.api_base}#{CUSTOMER_VERIFY_BANK_ACCOUNT_BASE}/verify" && CGI.parse(params) == {"amounts[]" => ["14", "16"]}
      end.returns(test_response(test_bank_account(:status => "verified")))
      bank_account = c.bank_accounts.retrieve('bank_account')
      assert_equal "new", bank_account.status
      bank_account.verify(:amounts => [14, 16])
      assert_equal "verified", bank_account.status
    end
  end
end
