require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Coupling < Formula
  version "0.1"
  homepage "https://github.com/csdms/coupling"
  url "https://github.com/csdms/coupling", :using => :git
  sha1 ""

  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on :python
  depends_on "scipy" => :python
  depends_on "netcdf"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    #ENV['PYTHONPATH'] = "#{prefix}/lib/python2.7/site-packages"
    ENV["PYTHONPATH"] = lib + "python2.7/site-packages"
    mkdir_p(lib + "python2.7/site-packages")

    system "pip", "install", "-r", "requirements.txt"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test coupling`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
