Pod::Spec.new do |s|
s.name             = 'COFramework'
s.version          = '1.0'
s.summary          = 'Cenker Ozkurt framework'
s.homepage         = 'https://github.com/cozkurt/coframework.git'
s.license          = 'MIT'
s.author           = { 'Cenker Ozkurt' => 'cenker@yahoo.com' }
s.source           = { :git => 'https://github.com/cozkurt/coframework.git', :tag => s.version.to_s }
s.requires_arc     = true

s.resource_bundles = {'COFramework' => ['COFramework/Swift/**/*.xib']}
  
s.source_files     = 'COFramework/**/*.{h,m,swift}'
s.module_name      = 'COFramework'

s.swift_version = '5.0'
s.ios.deployment_target  = '13.0'

s.dependency 'ObjectMapper'

end
