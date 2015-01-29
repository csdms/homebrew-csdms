require "formula"

class BmiC < Formula
  version "0.1"
  homepage "http://github.com/csdms/bmi-c.git"
  head "https://github.com/csdms/bmi-c.git"
  sha1 ""

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "make", "test"
  end
end
