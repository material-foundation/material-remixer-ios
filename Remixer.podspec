Pod::Spec.new do |s|
  s.name         = 'Remixer'
  s.version      = '1.0.0'
  s.author       = 'Google Inc.'
  s.summary      = 'Remixer is a set of libraries and protocols to allow live adjustment of apps and prototypes during the development process.'
  s.homepage     = 'https://github.com/material-remixer/material-remixer-ios'
  s.license      = 'Apache 2.0'
  s.source       = { :git => 'https://github.com/material-foundation/material-remixer-ios', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files = 'framework/src/core/**/*.{h,m}'
    ss.resource_bundles = {
      'Remixer' => [ 'framework/src/core/resources/Remixer.bundle/*' ]
    }
  end

  s.subspec 'Firebase' do |ss|
    ss.source_files = 'framework/src/firebase/*.{h,m}'
    ss.dependency 'Remixer/Core'
    ss.dependency 'Firebase'
    ss.dependency 'Firebase/Database'
    ss.dependency 'Firebase/Auth'
    ss.dependency 'Firebase/Storage'
    ss.resource = 'framework/src/firebase/GoogleService-Info.plist'
    ss.xcconfig = {
      'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/Firebase/Headers',
      'GCC_PREPROCESSOR_DEFINITIONS' => 'REMIXER_HOST_FIREBASE=1'
    }
  end

  s.subspec 'Subnet' do |ss|
    ss.source_files = 'framework/src/subnet/*.{h,m}'
    ss.dependency 'Remixer/Core'
    ss.dependency 'GCDWebServer', '~> 3.0'
    ss.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'REMIXER_HOST_SUBNET=1'
    }
  end

end
