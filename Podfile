platform :ios, '9.0'
use_frameworks!

target 'whichever' do

#pod 'MapboxDirections.swift', :git => 'https://github.com/mapbox/MapboxDirections.swift.git', :tag => ‘v0.6.0'
pod 'MapboxDirections.swift', :git => 'https://github.com/mapbox/MapboxDirections.swift.git', :branch => 'swift3'
#pod 'HanekeSwift'
pod "HanekeSwift", :git => 'https://github.com/Haneke/HanekeSwift.git', :branch => 'feature/swift-3'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
