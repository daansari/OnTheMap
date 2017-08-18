# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'OnTheMap' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for OnTheMap
  pod 'JVFloatLabeledTextField'
  pod 'MZFormSheetPresentationController'
  pod 'TSMessages', :git => 'https://github.com/KrauseFx/TSMessages.git'
  pod 'NSDate+TimeAgo'
  pod 'MBProgressHUD', '~> 1.0.0'
  pod 'SwiftyJSON'
  pod 'ChameleonFramework', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'TPKeyboardAvoiding'

  target 'OnTheMapTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OnTheMapUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
              # config.build_settings['SWIFT_LANGUAGE_VERSION'] = '3.2'
          end
      end
  end

end
