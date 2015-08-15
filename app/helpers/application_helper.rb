module ApplicationHelper
  def version
    @version ||= File.read('VERSION').chomp
  end
end
