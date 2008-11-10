desc 'Run unit test suite'
task :test => :ruby_env do
  sh %{ruby #{Dir['test/*_test.rb'].collect.join(' ')}}
end
