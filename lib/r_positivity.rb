require 'date'
require "digest/sha1"

module RPositivity
  module Currency
    EURO = "978"
  end

  module TxnType
    SALE = "sale"
    PREAUTH = "preauth"
    POSTAUTH = "postauth"
    VOID = "void"
  end

  module Mode
    PAYONLY = "payonly"
    PAYPLUS = "payplus"
    PAYFULL = "payfull"
  end

  class RPositivity
    TEST_URL = "https://test.ipg-online.com/connect/gateway/processing" 

    def initialize(storename, sharedSecret, args = {}, &block)
      @chargetotal = "0.00"
      @date = DateTime.now
      @currency = Currency::EURO
      @storename = storename
      @sharedSecret = sharedSecret
      @txntype = args[:txntype] || TxnType::SALE
      @mode = args[:mode] || Mode::PAYONLY
      @responseSuccessURL = args[:responseSuccessURL] || ""
      @responseFailURL = args[:responseFailURL] || ""
      instance_eval &block if block_given?
    end
  
    def url
      TEST_URL
    end

    def for(chargetotal, date = DateTime.now)
      RPositivity.new(@storename, @sharedSecret, 
                        :txntype => @txntype,
                        :mode => @mode,
                        :responseSuccessURL => @responseSuccessURL,
                        :responseFailURL => @responseFailURL) do
        @chargetotal = "%.2f" % chargetotal
        @date = date
      end
    end

    def params
      {
        :chargetotal => @chargetotal,
        :storename => @storename,
        :txndatetime => @date.strftime("%Y:%m:%d-%H:%M:%S"),
        :currency => @currency,
        :timezone => "CET",
        :txntype => @txntype,
        :mode => @mode,
        :responseSuccessURL => @responseSuccessURL,
        :responseFailURL => @responseFailURL,
        :hash => hash,
      }
    end

    private
    def hash
      string_to_hash = @storename + @date.strftime("%Y:%m:%d-%H:%M:%S") + @chargetotal + @currency + @sharedSecret
      ascii = string_to_hash.unpack("H*")
      Digest::SHA1.hexdigest(ascii.to_s)
    end

  end
end