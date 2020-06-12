require 'net/http'
require 'openssl'
require 'json'

url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_'
key = 'key=jwW2RykNrevmb9HjNeYzR2rnxkB0DL0yQIRDczc5'

def request(url,key)
    uri = URI(url+key)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(request)
    JSON.parse(response.read_body)
end

def build_web_page(data)
    html = "<html>\n<head>\n</head>\n<body>\n<ul>\n"
    data['photos'].size.times do |i|
        data['photos'][i]['img_src']
        html += "\t<li><img src=\"#{data['photos'][i]['img_src']}\"></li>\n"
    end
    html += "<ul>\n</body>\n</html>"
    File.write('./index.html',html)
end

def photos_count(data)
    cam = {}
    data['photos'].size.times do |i|
            camera = data['photos'][i]['camera']['name']
            photos = data['photos'][i]['rover']['total_photos']
            cam[camera] = photos
    end
    puts cam
end

data = request(url,key)
build_web_page(data)
photos_count(data)





