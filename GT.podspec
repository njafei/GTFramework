Pod::Spec.new do |s|
  s.name         = "GT"
  s.version      = "2.3.3"
  s.summary      = "A short description of GT."
  s.description  = "GT framework ,since GT don't provider a pod , I build this"
  s.homepage     = "http://gt.tencent.com/"
  s.license      = "MIT"
  s.author       = { "njafei" => "njafei@163.com" }
  s.platform     = :ios, "7.0"
  s.frameworks = 'SystemConfiguration', 'AudioToolbox', 'CoreTelephony'
  s.libraries = 'sqlite3', 'z'

  #  When using multiple platforms
  s.ios.deployment_target = "7.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

    s.source       = { :git => "https://github.com/njafei/GTFramework.git", :tag => s.version }

    # GT
    s.subspec 'GT' do |gt|
        gt.vendored_frameworks = 'GT.embeddedframework/GT.framework'
        gt.resources = 'GT.embeddedframework/Resources/GT.bundle'
    end



    s.requires_arc = true

    # !!!
    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-all_load' }

end
