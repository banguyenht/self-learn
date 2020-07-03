Hello mọi người, gần đây mình có làm một chức năng liên quan đến đọc email người dùng nên có một ít kinh nghiệm chia sẻ với mọi người về google oauth2 và google api qua quá trình làm việc, mong mọi người đọc và comment tích cực. 
#### OAuth2 và Google API
OAuth2 là một phương thức chứng thực, mà nhờ đó một web service hay một application bên thứ 3 có thể đại diện cho người dùng để truy cập vào tài nguyên người dùng nằm trên một dịch vụ nào đó. Ví dụ như một app hay một web nào đó có thể xem thông tin và tin nhắn của mình trên Facbook hay Google vậy. Còn Google API là 1 RESTful API cho Google cung cấp để  truy cập đến tài nguyên người dùng

#### Work flow của Google OAuth2
##### Step 1: Tạo request
Để tương tác với Google OAuth server đầu tiên ứng dụng của chúng ta cần phải tạo 1 requet với giao thức https ví dụ: [request example](https://accounts.google.com/signin/oauth/oauthchooseaccount?access_type=offline&client_id=193271024968-2dcvl591baoh326bkf0ddml1f9ai3n2f.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fgoogle_oauth2%2Fcallback&response_type=code&scope=email%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fgmail.readonly&state=6ff85a4bb459fce71b26065460f0d68bb18aa8f849375448&o2v=1&as=P0lxMkHnM4AXSm1jegJRSw&flowName=GeneralOAuthFlow)(Nhớ bật localhost trước). Ở đây chúng ta sẽ set các parameters, chúng ta sẽ tập phân tích các params chính  như sau:

- client_id: cilent id của google app mà chúng ta đã tạo ở mục trên

- redirect_uri: nơi sẽ xử lý response từ google server mà chúng ta đã thêm vào mục Authorized redirect URIs ở google app(`http://localhost:3000/auth/google_oauth2/callback` trong ví dụ này)

- response_type: Xác định kiểu dữ liệu mà google oauth server trả về, chúng ta sẽ sử dụng là code.

- scope: Các quyền mà ứng dụng cần người dùng cung cấp.
##### Step 2: Xử lý reponse trả về
Sau khi ứng dụng gửi request 1 popup sẽ hiển thị yêu cầu người dùng đăng nhập và cấp quyền truy cập tài nguyên cho ứng dụng. Nếu người dùng đồng ý thì google oauth sẽ trả về một url bao gồm một mã authorization code: `https://oauth2.example.com/auth?code=4/P7q7W91a-oMsCeLvIaQm6bTrgtp7`
Còn nếu người dùng từ chối thì google oauth sẽ trả về một url chứa message error: `https://oauth2.example.com/auth?error=access_denied
`
Sau đó ứng dụng sẽ dùng mã code này để gửi đến đến `https://oauth2.googleapis.com/token` endpoint để lấy được một json có dạng như sau:
```json
{
  "access_token": "1/fFAGRNJru1FTz70BzhT3Zg",
  "expires_in": 3920,
  "token_type": "Bearer",
  "scope": "https://www.googleapis.com/auth/drive.metadata.readonly",
  "refresh_token": "1//xEoDL4iW3cxlI7yDbSRFYNG01kVKM2C-259HOF2aQbI"
}
```
Khi đã có được `access_token` thì ứng dụng sẽ dùng nó để thay mặt người dùng truy cập đến tài nguyên mà người dùng cho phép, còn `refresh_token` dùng để sinh ra một `access_token` mới khi `access_token` hiện tạị bị hết hạn.
#### Sử dụng Google API và Google OAuth2 để đọc email người dùng sử dụng ruby on rails
##### Khởi tạo google project
1. [Open the API Libary](https://console.developers.google.com/apis/library)
2. Tìm Gmail và click Enable
3. Go to the [Console developer](https://console.developers.google.com/apis/dashboard).
4. Click Configure consent screen
5. Điền tên app và click save
6. Click Create credentials > OAuth client ID.
7. Chọn the Web application application type, điền vào ô name và add call back url vào trường Authorized redirect URIs nh: http://localhost:3000/auth/google_oauth2/callback
8. Click Save và lưu lại client id và secret id của ứng dụng vừa tạo.

##### Bây giờ chúng ta sẽ cùng làm 1 app demo nho nhỏ bằng ruby on rails nhé.
Step 1: Tạo 2 biến môi trường là GOOLGE_CLIENT_ID và GOOGLE_SECRET_ID với giá trị tương ứng là client id và secret id được lấy từ google app.

Step 2: thêm vào gemfile
```
gem 'omniauth-google-oauth2'
gem 'google-api-client'
```
Step 2: Tạo model Token: `rails g model Token access_token:string refresh_token:string expires_at:datetime uid:string`
Step 3: Thêm các dòng sau vào file routes.rb
```ruby
root 'google_accounts#show'
resource :google_account, only: :show
get "/auth/:provider/callback" => 'google_accounts#create'
```
Step 4: add to google_accounts_controller
```
def create
  auth = request.env['omniauth.auth']
    @google_token = Token.find_or_create_by(uid: auth['uid']) do |token|
    token.access_token = auth['credentials']['token']
    token.refresh_token = auth['credentials']['refresh_token']
    token.expires_at = Time.at(auth['credentials']['expires_at']).to_datetime
  end
end
```
Step 5: create view
  - views/google_accouts/show.html.erb: `<%= link_to "Authenticate with Google!", '/auth/google_oauth2' %>`

  - views/google_accouts/create.html.erb: `<%= @google_token.access_token %>`
		
Step 6: token.rb
```
  require 'net/http'
  require 'json'
  require 'google/apis/gmail_v1'

  class Token < ApplicationRecord
    def to_params
      {
        'refresh_token' => refresh_token,
        'client_id' => ENV['GOOGLE_CLIENT_ID'],
        'client_secret' => ENV['GOOGLE_CLIENT_SECRET'],
        'grant_type' => 'refresh_token'
      }
    end

    def request_token_from_google
      url = URI("https://accounts.google.com/o/oauth2/token")
      Net::HTTP.post_form(url, self.to_params)
    end

    def refresh
      response = request_token_from_google
      data = JSON.parse(response.body)
      update_attributes(
      access_token: data['access_token'],
      expires_at: Time.now + (data['expires_in'].to_i).seconds)
    end

    def expired?
      expires_at < Time.now
    end

    def fresh_token
      refresh if expired?

      access_token
    end
		  
    def list_user_messages
      service = Google::Apis::GmailV1::GmailService.new
      self.refresh if expired?

      service.authorization = self.access_token
      emails = service.list_user_messages(uid)
      return if emails.messages.blank?

      emails.messages
    end
  end
```
Step 7: tạo file config/initalizers/omniauth.rb
```
#config/initalizers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
  scope: ['email', 'gmail.readonly'], access_type: 'offline'}
  #ở đây là nơi chúng ta tạo các parameters cho oauth2 request bao gồm client id, secret id và các quyền ứng dụng cần
end
```
Step 8: Tạo token
Bây giờ hãy bật rails lên, vào localhost, và click `Authenticate with Google!`, đồng ý cấp quyền và click khi đó chúng ta sẽ tạo được một bản ghi của token.

Step 9: Dùng token để truy cập vào email

Mở rails c và nhập: `Token.last.list_user_messages`, khi đó ứng dụng của chúng ta đã truy cập vào email của người dùng và lấy thông tin của các email rồi.
#### Tổng kết
Trong bài viết này mình đã chia sẻ kinh nghiệm sử dụng Google OAuth2 và Google API để truy cập đến email người dùng. Cảm ơn mọi người đã quan tâm và mong nhận được nhiều commments từ mọi người.
