require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Chasm < Formula
  version "1.4"
  homepage "http://chasm-interop.sourceforge.net/"
  url "http://sourceforge.net/projects/chasm-interop/files/chasm_1.4.RC3.tar.gz"
  sha1 "e592f6684d5f79c24e3751f2377fd0558f93fb42"

  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "gcc"
  depends_on "coreutils"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    system "./configure", "--with-F90=gfortran",
                          "--with-F90-vendor=GNU",
                          "--prefix=#{prefix}/"
                          #"--disable-debug",
                          #"--disable-dependency-tracking",
                          #"--disable-silent-rules",
    # system "cmake", ".", *std_cmake_args
    system "make", "all"
    system "make", "install-dirs"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test chasm_1.4.RC`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
