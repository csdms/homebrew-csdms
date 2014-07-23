require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Esmpy < Formula
  version "6.3.0"
  homepage "http://www.earthsystemmodeling.org"
  url "git://git.code.sf.net/p/esmf/esmf", :branch => 'ESMF_6_3_0rp1'
  sha1 "f459a65373fd5a7925ea935bc75b66283b27936b"

  option "with-check", "Run tests before installing"

  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "esmf"

  def install
    #ENV.deparallelize  # if your formula fails when building in parallel
    compiler = File.basename("#{ENV.fc}") + File.basename("#{ENV.cc}")

    cd "src/addon/ESMPy" do
      path_to_esmf_mk = "#{HOMEBREW_PREFIX}/lib" +
        "/libO/Darwin." + compiler + ".64.mpiuni.default/esmf.mk"

      system "python", "setup.py", "build", "--ESMFMKFILE=" + path_to_esmf_mk,
        "install", "--prefix=#{prefix}"

      system "python", "setup.py", "test_all" if build.with? "check"
    end
  end

  test do
    Language::Python.each_python(build) do |python, version|
      system python, "-c", "import ESMF"
    end
  end
end
