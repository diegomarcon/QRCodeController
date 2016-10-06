Pod::Spec.new do |s|
  s.name             = 'QRCodeController'
  s.version          = '0.2.0'
  s.summary          = 'Simple QRCode Reader view controller written in Swift.'

  s.description      = <<-DESC
Simple QR Code Reader view controller written in Swift.
                       DESC

  s.homepage         = 'https://github.com/diegomarcon/QRCodeController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Diego Marcon' => 'dm.marcon@gmail.com' }
  s.source           = { :git => 'https://github.com/diegomarcon/QRCodeController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'QRCodeController/Classes/**/*'
  # s.frameworks = 'AudioToolbox'
end
