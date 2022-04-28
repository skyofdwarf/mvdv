# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'MVDV' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MVDV
  pod 'R.swift'
  pod 'SwiftGen', '~> 6.0'

end

plugin 'cocoapods-keys', {
  :project => "MVDB",
  :keys => [
    "apiKey",
    "apiAccessToken"
  ]
}

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
