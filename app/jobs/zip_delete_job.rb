class ZipDeleteJob
  include SuckerPunch::Job

  def perform(file)
    File.delete(file)
  end

  def later(sec, file)
    after(sec) { perform(file) }
  end
end
