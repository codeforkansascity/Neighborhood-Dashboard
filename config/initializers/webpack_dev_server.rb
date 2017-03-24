if ENV['WEBPACK_DEV_SERVER'] == 'true' && Rails.env.development?
  webpack_pid = spawn('npm run webpack-dev-server')
  Process.detach(webpack_pid)
end
