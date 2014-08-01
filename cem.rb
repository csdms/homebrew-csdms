require "formula"

class Cem < Formula
  homepage "http://csdms.colorado.edu/wiki/Model:CEM"
  head "https://csdms.colorado.edu/svn/cem/trunk", :using => :svn

  depends_on "glib"
  depends_on "cmake" => :build
  depends_on "pkgconfig" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/deltas", "--version"
    system "#{bin}/waves", "--version"
  end
end
