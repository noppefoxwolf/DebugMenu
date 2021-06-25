Pod::Spec.new do |s|
  s.name             = 'DebugMenu'
  s.version          = '1.9.2'
  s.summary          = 'DebugMenu.'
  s.description      = <<-DESC
DebugMenu.
                       DESC
  s.homepage         = 'https://github.com/noppefoxwolf/DebugMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tomoya Hirano' => 'noppelabs@gmail.com' }
  s.source           = { :git => 'https://github.com/noppefoxwolf/DebugMenu.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/noppefoxwolf'
  s.ios.deployment_target = '14.0'
  s.swift_versions = '5.2'
  
  s.source_files = 'Sources/DebugMenu/**/*.{swift,metal}'
end