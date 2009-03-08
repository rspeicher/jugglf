begin
  require 'vlad'
  Vlad.load :app => 'passenger', :scm => 'git'
rescue LoadError
  # do nothing
end