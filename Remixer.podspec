Pod::Spec.new do |s|
  s.name         = 'Remixer'
  s.version      = '0.9.0'
  s.author       = 'Google Inc.'
  s.summary      = 'Remixer is a set of libraries and protocols to allow live adjustment of apps and prototypes during the development process.'
  s.homepage     = 'https://github.com/material-foundation/material-remixer-ios'
  s.license      = 'Apache 2.0'
  s.source       = { :git => 'https://github.com/material-foundation/material-remixer-ios.git', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files = 'src/core/**/*.{h,m}'
    ss.resource_bundles = {
      'Remixer' => [ 'src/core/resources/Remixer.bundle/*' ]
    }
  end

  s.subspec 'Firebase' do |ss|
    ss.dependency 'Remixer/Core'
    ss.dependency 'Firebase/Core', '~> 3.8'
    ss.dependency 'Firebase/Database', '~> 3.1'
    ss.xcconfig = {
      'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/FirebaseCore/Frameworks/frameworks" "$(PODS_ROOT)/FirebaseAnalytics/Frameworks/frameworks" "$(PODS_ROOT)/FirebaseDatabase/Frameworks" "$(PODS_ROOT)/GoogleInterchangeUtilities/Frameworks/frameworks" "$(PODS_ROOT)/GoogleSymbolUtilities/Frameworks/frameworks"',
      'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/Firebase/Core/Sources',
      'GCC_PREPROCESSOR_DEFINITIONS' => 'REMIXER_CLOUD_FIREBASE=1'
    }
    ss.frameworks = ['FirebaseCore', 'FirebaseAnalytics', 'FirebaseDatabase', 'GoogleInterchangeUtilities', 'GoogleSymbolUtilities']
  end
end
