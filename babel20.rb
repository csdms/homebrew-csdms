require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Babel20 < Formula
  version "2.0.0"
  homepage "http://computation.llnl.gov/casc/components"
  url "http://computation.llnl.gov/casc/components/docs/babel-2.0.0.tar.gz"
  sha1 "e60d0ad140e8248d2c18dededbf33077bfdf6b2f"

  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "libxml2"
  depends_on "chasm"
  depends_on "gcc"
  depends_on "homebrew/python/scipy"

  def install
    #ENV.deparallelize  # if your formula fails when building in parallel
    ENV['JAVAPREFIX'] = "/Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home"
    ENV['CC'] = "gcc-4.8"
    ENV['CXX'] = "g++-4.8"
    ENV['FC'] = "gfortran"
    ENV['F77'] = "gfortran"

    system "./configure", "--prefix=#{prefix}", "--disable-documentation"

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
