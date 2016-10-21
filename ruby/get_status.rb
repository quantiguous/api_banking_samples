require 'liquid'
require 'securerandom'
require 'faraday'

URL = 'https://sky.yesbank.in:443/app/live/ssl/fundsTransferByCustomerService'

BASIC_AUTH_USERNAME = ENV['YBL_QG_USER']
BASIC_AUTH_PASSWORD = ENV['YBL_QG_PASSWORD']
DP_CLIENT_ID        = ENV['YBL_QG_CLIENTID']
DP_CLIENT_SECRET    = ENV['YBL_QG_CLIENTSECRET']
CUSTOMER_ID         = ENV['YBL_QG_CUSTOMER_ID']

def load_template(template_name)
  p 'loading template'
  return Liquid::Template.parse(File.read(template_name))
end

def connect_to_bank
  ssl_options = {
    client_cert: OpenSSL::X509::Certificate.new(File.read('sc.crt.new')),
    client_key:  OpenSSL::PKey::RSA.new(File.read('sc.key')),
    ca_file: './ybl/ybl.pem'
  }
  conn = Faraday.new(:url => URL, :ssl => ssl_options) do |c|
    c.use Faraday::Request::UrlEncoded
    c.use Faraday::Request::BasicAuthentication, BASIC_AUTH_USERNAME, BASIC_AUTH_PASSWORD
    c.use Faraday::Response::Logger
    c.use Faraday::Adapter::NetHttp
  end
  return conn
end

def send_request(conn, template)
  p "send_request"
  puts template

  response = conn.post do |req|
     req.headers['Content-Type'] = 'application/xml'
     req.headers["X-IBM-Client-Id"] = DP_CLIENT_ID
     req.headers["X-IBM-Client-Secret"] = DP_CLIENT_SECRET
     req.body = template
  end
  puts response.body
end

def run_get_status
  conn = connect_to_bank
  template = load_template('getstatus.template')
  send_request(conn, template.render('CUSTOMER_ID' => CUSTOMER_ID))
end

run_get_status

