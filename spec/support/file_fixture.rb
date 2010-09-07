module FileFixture
  def file_fixture(*args)
    File.read(File.expand_path("../../file_fixtures/#{File.join(args)}", __FILE__))
  end
end
