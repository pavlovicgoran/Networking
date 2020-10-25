Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "PGNetworking"
s.summary = "PGNetworking helps you send url requests in style"
s.requires_arc = true

s.version = "0.1.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Goran Pavlovic" => "pavlovicgoran94@gmail.com" }

s.homepage = "https://github.com/pavlovicgoran/Networking"

s.source = { :git => "https://github.com/pavlovicgoran/Networking.git",
             :tag => "#{s.version}" }

s.source_files = "Networking/**/*.{swift}"
s.exclude_files = "Networking/NetworkingTests/**/*.{swift,h,m}"

s.swift_version = "5"

end
