require "formula"

class Hydrotrend < Formula
  version "3.1"
  homepage ""
  url "https://csdms.colorado.edu/svn/hydrotrend/trunk", :using => :svn
  sha1 ""

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "#{bin}/hydrotrend", "--version"
  end
end
