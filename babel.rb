require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Babel < Formula
  version "1.4.0"
  homepage "http://computation.llnl.gov/casc/components"
  url "http://computation.llnl.gov/casc/components/docs/babel-1.4.0.tar.gz"
  sha1 "7dea34ace76b61ae76bf40e526734b1f23a7b11a"

  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "libxml2"
  depends_on "chasm"
  depends_on "gcc"
  depends_on "homebrew/python/scipy"

  def install
    #ENV.deparallelize  # if your formula fails when building in parallel
    ENV['JNI_INCLUDES'] = "-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers"
    ENV['CC'] = "/usr/local/bin/gcc-4.8"
    ENV['CXX'] = "/usr/local/bin/g++-4.8"
    ENV['FC'] = "/usr/local/bin/gfortran"
    ENV['F77'] = "/usr/local/bin/gfortran"
    #ENV['CFLAGS'] = "-fPIC"

    # Remove unrecognized options if warned by configure
    system "./configure", "--prefix=#{prefix}"#, "--disable-python"

    # system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test babel`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
