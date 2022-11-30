Pod::Spec.new do |s|

  s.name             = 'WZRoute'
  s.version          = '5.0.3'
  s.summary          = '我主良缘简单的路由'

  s.description      = <<-DESC
    我主良缘简单的路由.
                       DESC

  s.homepage         = 'https://github.com/WZLYiOS/WZRoute.git'
  s.license          = 'MIT'
  s.author           = { 'qiu qixiang'=> '739140860@qq.com' }
  s.source           = { :git => 'https://github.com/WZLYiOS/WZRoute.git', :tag => s.version.to_s }

  s.swift_version         = '5.3'
  s.ios.deployment_target = '11.0'
  s.default_subspec = 'Source'
  
#  s.user_target_xcconfig = {
#    'GENERATE_INFOPLIST_FILE' => 'YES'
#  }
#  s.pod_target_xcconfig = {
#    'GENERATE_INFOPLIST_FILE' => 'YES'
#  }

  s.subspec 'Source' do |ss|
    ss.source_files = 'WZRoute/Classes/*.swift'
  end


#  s.subspec 'Binary' do |ss|
#    ss.vendored_frameworks = "Carthage/Build/iOS/Static/WZRoute.framework"
#    ss.user_target_xcconfig = { 'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)' }
#  end
end


