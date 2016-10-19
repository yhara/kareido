require 'bundler/setup'

file 'lib/kareido/parser.ry' => 'lib/kareido/parser.ry.erb' do
  sh "erb lib/kareido/parser.ry.erb > lib/kareido/parser.ry"
end

file 'lib/kareido/parser.rb' => 'lib/kareido/parser.ry' do
  cmd = "racc -o lib/kareido/parser.rb lib/kareido/parser.ry"
  cmd.sub!("racc", "racc --debug") if ENV["DEBUG"]
  sh cmd
end

desc "run test"
task :test => 'lib/kareido/parser.rb' do
  sh "rspec"
end

task :default => :test
