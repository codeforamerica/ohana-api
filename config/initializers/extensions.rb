# Hat tip to Brent Collier:
# http://intridea.com/blog/2009/3/12/temporarily-disable-activerecord-callbacks
# This method is used in setub_db.rake to disable the callbacks that
# update the Elasticsearch index. While importing data, those callbacks are not
# necessary, and they slow down the import process.
class ActiveRecord::Base
  def self.without_callback(callback)
    method = send(:instance_method, callback)
    send(:remove_method, callback)
    send(:define_method, callback) { true }
    yield
    send(:remove_method, callback)
    send(:define_method, callback, method)
  end
end
