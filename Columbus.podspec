Pod::Spec.new do |s|
    s.name              = 'Columbus'
    s.version           = '1.6.0'
    s.license           = { :type => 'MIT', :file => 'LICENSE' }
    s.summary           = 'A country picker for iOS, tvOS and watchOS.'
    s.description       = <<-DESC
    A country picker for iOS, tvOS and watchOS with features you will only find distributed in many different country-picker implementations.
    DESC
    s.homepage          = 'https://github.com/blackjacx/Columbus'
    s.social_media_url  = 'https://twitter.com/Blackjacxxx'
    s.author            = { 'Stefan Herold' => 'stefan.herold@gmail.com' }
    s.source            = { :git => 'https://github.com/blackjacx/Columbus.git', :tag => s.version.to_s }
    s.source_files = 'Source/Classes/**/*'
    s.swift_versions = ['5.4']

    s.ios.deployment_target = '11.0'
    s.tvos.deployment_target = '11.0'

    s.resource_bundles  = {
      'Resources' => ['Source/Resources/*.{json,xcassets}']
    }

    s.frameworks = 'UIKit'
end

