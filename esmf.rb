require "formula"

class Esmf < Formula
  version "6.3.0"
  homepage "http://www.earthsystemmodeling.org"
  url "git://git.code.sf.net/p/esmf/esmf", :branch => 'ESMF_6_3_0rp1'
  sha1 "f459a65373fd5a7925ea935bc75b66283b27936b"

  option "with-check", "Run tests before installing"

  depends_on :fortran

  def install
    ENV.deparallelize

    ENV['ESMF_CXX'] = "#{ENV.cc}"
    ENV['ESMF_F90'] = "#{ENV.fc}"
    ENV['ESMF_COMM'] = "mpiuni"
    ENV['ESMF_DIR'] = buildpath
    ENV['ESMF_INSTALL_PREFIX'] = prefix
    ENV['ESMF_COMPILER'] = File.basename("#{ENV.fc}")
    ENV['ESMF_COMPILER'] += File.basename("#{ENV.cc}") if OS.mac?

    system "make"
    system "make check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "false"
  end
end
