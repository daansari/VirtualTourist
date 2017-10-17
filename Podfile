# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'VirtualTourist' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VirtualTourist
    pod 'TSMessages', :git => 'https://github.com/KrauseFx/TSMessages.git'
    pod 'MBProgressHUD', '~> 1.0.0'
    pod 'XCGLogger', '~> 5.0.1'
    pod 'FontAwesomeKit/IonIcons'
    pod 'FontAwesomeKit/FontAwesome'
    pod 'ChameleonFramework', :git => 'https://github.com/ViccAlexander/Chameleon.git'

  target 'VirtualTouristTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'VirtualTouristUITests' do
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
