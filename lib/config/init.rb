%w{ classes }.each do |dir|
  Dir[[Dir[File.expand_path('../..', __FILE__)], dir, '*.rb'].join('/')].each { |f| require f }
end
