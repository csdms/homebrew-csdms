require "formula"

class Sedflux < Formula
  homepage "https://github.com/mcflugen/sedflux"
  head "https://github.com/mcflugen/sedflux.git"
  sha1 ""

  depends_on "cmake" => :build
  depends_on "glib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sedflux", "--version"
  end
end
