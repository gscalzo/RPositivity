$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require "r_positivity"

describe "RPositivitySpec" do
  
  def nowIs(fakeNow)
    now = DateTime.parse(fakeNow)
    DateTime.stub!(:now).and_return(now)
  end

  def empty_gw
    RPositivity::RPositivity.new("1", "HZ4qjxXs5e")
  end

  it "should return test url as default" do
    empty_gw().url.should be_== "https://test.ipg-online.com/connect/gateway/processing"
  end

  it "should return well format date as parameter" do
    now = DateTime.parse('02-09-2010 11:30:44 AM')
    rpositivity = RPositivity::RPositivity.new("1", "HZ4qjxXs5e").for(10, now)
    rpositivity.params[:txndatetime].should be_== "2010:09:02-11:30:44"
  end

  it "should return well format date forn now as default" do
    nowIs('02-09-2010 11:30:44 AM')
    empty_gw().params[:txndatetime].should be_== "2010:09:02-11:30:44"
  end

  it "should return euro as default currency" do
    empty_gw().params[:currency].should be_==RPositivity::Currency::EURO
  end

  it "should return CET as default TimeZone" do
    empty_gw().params[:timezone].should be_=="CET"
  end

  it "should return sale as default txntype" do
    empty_gw().params[:txntype].should be_==RPositivity::TxnType::SALE
  end

  it "should be possible pass a different txntype" do
    gw = RPositivity::RPositivity.new("1", "HZ4qjxXs5e", :txntype => RPositivity::TxnType::PREAUTH)
    gw.params[:txntype].should be_==RPositivity::TxnType::PREAUTH
  end

  it "should have 0 as default chargetotal" do
    empty_gw.params[:chargetotal].should be_=="0.00"
  end

  it "should need storename as parameter" do
    gw = RPositivity::RPositivity.new("10012345678","HZ4qjxXs5e")
    gw.params[:storename].should be_=="10012345678"
  end
   
  it "should need sharesecret as parameter" do
    gw = RPositivity::RPositivity.new(10, "10012345678", "HZ4qjxXs5e")
  end

  it "should return payonly as default mode" do
    empty_gw.params[:mode].should be_==RPositivity::Mode::PAYONLY
  end

  it "should be possibile pass a different mode" do
    gw = RPositivity::RPositivity.new("10012345678", "HZ4qjxXs5e", :mode => RPositivity::Mode::PAYPLUS)
    gw.params[:mode].should be_==RPositivity::Mode::PAYPLUS
  end                                                                             

  it "should be possible pass a responseSuccessURL" do
    gw = RPositivity::RPositivity.new("10012345678", "HZ4qjxXs5e", :responseSuccessURL => "http://localhost")
    gw.params[:responseSuccessURL].should be_=="http://localhost"
  end                                                                             

  it "should be possible pass a responseFailURL" do
    gw = RPositivity::RPositivity.new("10012345678", "HZ4qjxXs5e", :responseFailURL => "http://localhost")
    gw.params[:responseFailURL].should be_=="http://localhost"
  end                                                                             


  it "should return correct hash" do
    nowIs('02-09-2010 02:55:30 PM')
    gw = RPositivity::RPositivity.new("10012345678", "HZ4qjxXs5e").for(10)
    gw.params[:hash].should be_=="bf478d3ad6f07e6d046897d2fd5c09176f8ea805"
  end                                                                             

  it "should be possible generate 2 different indipendent gateway" do
    common_gw = RPositivity::RPositivity.new("10012345678", "HZ4qjxXs5e", :responseFailURL => "http://localhost")

    nowIs('02-09-2010 10:30:44 AM')
    gw_for_100 = common_gw.for(100)

    nowIs('02-09-2010 11:30:44 AM')
    gw_for_123 = common_gw.for(123)

    gw_for_100.params[:chargetotal].should be_=="100.00"
    gw_for_100.params[:txndatetime].should be_== "2010:09:02-10:30:44"

    gw_for_123.params[:chargetotal].should be_=="123.00"
    gw_for_123.params[:txndatetime].should be_== "2010:09:02-11:30:44"
  end
end

