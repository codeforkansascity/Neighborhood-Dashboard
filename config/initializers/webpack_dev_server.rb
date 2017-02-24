puts 'Webpack Running'
puts ENV['WEBPACK_DEV_SERVER']
puts Rails.env

if ENV['WEBPACK_DEV_SERVER'] == 'true' && Rails.env.development?
  webpack_pid = spawn('npm run webpack-dev-server')
  Process.detach(webpack_pid)
end
