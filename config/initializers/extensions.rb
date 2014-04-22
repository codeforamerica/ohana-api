# Hat tip to Brent Collier:
# http://intridea.com/blog/2009/3/12/temporarily-disable-activerecord-callbacks

class ActiveRecord::Base
  def self.without_callback(callback, &block)
    method = self.send(:instance_method, callback)
    self.send(:remove_method, callback)
    self.send(:define_method, callback) { true }
    yield
    self.send(:remove_method, callback)
    self.send(:define_method, callback, method)
  end
end