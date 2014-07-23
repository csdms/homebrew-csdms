require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Esmf < Formula
  version "6.3.0"
  homepage "http://www.earthsystemmodeling.org"
  url "git://git.code.sf.net/p/esmf/esmf", :branch => 'ESMF_6_3_0rp1'
  sha1 "f459a65373fd5a7925ea935bc75b66283b27936b"

  option "with-check", "Run tests before installing"

  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on :fortran

  def install
    ENV.deparallelize  # if your formula fails when building in parallel
    ENV['ESMF_CXX'] = "#{ENV.cc}"
    ENV['ESMF_F90'] = "#{ENV.fc}"
    ENV['ESMF_COMM'] = "mpiuni"
    ENV['ESMF_DIR'] = buildpath
    ENV['ESMF_INSTALL_PREFIX'] = prefix
    ENV['ESMF_COMPILER'] = (File.basename("#{ENV.fc}") +
                            File.basename("#{ENV.cc}"))

    system "make"
    system "make check" if build.with? "check"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test esmf`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
