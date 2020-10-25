Pod::Spec.new do |spec|

  spec.name         = "Networking"
  spec.version      = "0.1.0"
  spec.summary      = "Networking library is a small wrapper around URLSessionTask that makes working with it easier"
  spec.homepage     = "https://github.com/pavlovicgoran/Networking"


  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Goran Pavlovic" => "pavlovicgoran94@gmail.com" }

  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"

  spec.source       = { :git => "https://github.com/pavlovicgoran/Networking.git", :tag => "#{spec.version}" }

  spec.source_files  = "Networking/**/*.{swift}"

  spec.swift_version = "5.0"

end
