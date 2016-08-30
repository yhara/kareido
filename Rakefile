require 'bundler/setup'

file 'lib/kareido/parser.ry' => 'lib/kareido/parser.ry.erb' do
  sh "erb lib/kareido/parser.ry.erb > lib/kareido/parser.ry"
end

file 'lib/kareido/parser.rb' => 'lib/kareido/parser.ry' do
  # hint: add -g to debug parser (run `rake -B` for force rebuild)
  sh "racc -o lib/kareido/parser.rb lib/kareido/parser.ry"
end

task :default => 'lib/kareido/parser.rb' do
  sh "rspec"
end
