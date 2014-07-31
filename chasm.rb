require "formula"

class Chasm < Formula
  version "1.4"
  homepage "http://chasm-interop.sourceforge.net/"
  url "http://sourceforge.net/projects/chasm-interop/files/chasm_1.4.RC3.tar.gz"
  sha1 "e592f6684d5f79c24e3751f2377fd0558f93fb42"

  depends_on :fortran

  def install
    f90 = ENV['FC']
    f90_vendor = 'GNU'

    system "./configure", "--with-F90=#{f90}",
                          "--with-F90-vendor=#{f90_vendor}",
                          "--prefix=#{prefix}"

    system "make", "all"
    system "make", "install-dirs"
    system "make", "install"
  end

  test do
    system "#{bin}/chasm-config", "--version"
  end
end
