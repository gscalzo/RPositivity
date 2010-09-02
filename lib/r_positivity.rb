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

    def initialize(chargetotal, storename, sharedSecret, args = {})
      @chargetotal = "%.2f" % chargetotal
      @currency = Currency::EURO
      @storename = storename
      @sharedSecret = sharedSecret
      @date = args[:date] || DateTime.now  
      @txntype = args[:txntype] || TxnType::SALE
      @mode = args[:mode] || Mode::PAYONLY
      @responseSuccessURL = args[:responseSuccessURL] || ""
      @responseFailURL = args[:responseFailURL] || ""
    end
  
    def url
      TEST_URL
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