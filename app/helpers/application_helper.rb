module ApplicationHelper
  def version
    @version ||= File.read('VERSION')
  end
end
