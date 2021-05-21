Pod::Spec.new do |s|
s.name             = 'coframework-alpha'
s.version          = '3.0'
s.summary          = 'Cenker Ozkurt framework'
s.homepage         = 'https://github.com/cozkurt/coframework-alpha.git'
s.license          = 'MIT'
s.author           = { 'Cenker Ozkurt' => 'cenker@yahoo.com' }
s.source           = { :git => 'https://github.com/cozkurt/coframework-alpha.git', :tag => s.version }
s.platform         = :ios, '13.0'
s.requires_arc     = true

s.source_files     = 'COFramework/**/*.{h,m,swift}'
s.module_name      = 'COFramework'

s.swift_version       = "5.0"
s.ios.deployment_target  = '13.0'

s.dependency 'Alamofire'
s.dependency 'ObjectMapper'
end

