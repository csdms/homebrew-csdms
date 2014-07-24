require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class CcaSpecBabel < Formula
  homepage "http://www.cca-forum.org"
  url "http://www.cca-forum.org/download/cca-tools/cca-tools-latest/cca-spec-babel-0.8.6.tar.gz"
  sha1 "a149b96bd9945b2813d32467cafc9e7fe59d4248"

  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "libxml2"
  depends_on "csdms/csdms/babel"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV['CC'] = "#{HOMEBREW_PREFIX}/bin/gcc-4.8"
    ENV['CXX'] = "#{HOMEBREW_PREFIX}/bin/g++-4.8"
    ENV['FC'] = "#{HOMEBREW_PREFIX}/bin/gfortran"
    ENV['F77'] = "#{HOMEBREW_PREFIX}/bin/gfortran"

    system "./configure", "--disable-contrib",
      "--with-babel-config=#{HOMEBREW_PREFIX}/bin/babel-config",
      "--prefix=#{prefix}"

    system "make", "all"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test cca-spec-babel`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
