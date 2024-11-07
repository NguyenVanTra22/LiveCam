# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'LiveCam' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'mobile-ffmpeg-https-gpl', '~> 4.4'
  pod 'RxSwift', '~> 5.1.1'
  pod 'RxCocoa', '~> 5.1.1'
  pod 'CocoaLumberjack/Swift'
  pod 'Alamofire', '~> 5.2.1'
  pod 'ReachabilitySwift', '~> 5.0.0'
  pod 'Zip', '~> 2.1'
  pod 'SwiftyUserDefaults', '~> 5.0.0'
  pod 'NVActivityIndicatorView', '~> 5.0.0'
  pod 'SwiftyJSON', '~> 5.0.0'
  pod 'SVProgressHUD', '~> 2.2.5'
  post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
#          config.build_settings['HEADER_SEARCH_PATHS'] ||= ['$(inherited)', '/opt/homebrew/opt/ffmpeg/include']
        end
    end
  end
end
#  use_frameworks!
#
#  # Pods for LiveCam
#
#  target 'LiveCamTests' do
#    inherit! :search_paths
#    # Pods for testing
#  end
#
#  target 'LiveCamUITests' do
#    # Pods for testing
#  end
#
#end
