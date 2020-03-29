FactoryBot.define do
  factory :image do
    url { "https://cdn.24h.com.vn/upload/4-2019/images/2019-11-27/1574839331-951-nhung-kieu-toc-dep-danh-cho-nang-deo-kinh-0-1574070854-width500height620.jpg" }
    product { Product.last }
  end
end
