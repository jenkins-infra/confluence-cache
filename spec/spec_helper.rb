require 'serverspec'

PORT=8081
URL="http://localhost:#{PORT}"

BACKEND="http://localhost:8082"

set :backend, :exec
set :disable_sudo, true