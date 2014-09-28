require "formula"

class Ccaffeine < Formula
  homepage "http://www.cca-forum.org"
  url "http://www.cca-forum.org/download/cca-tools/cca-tools-latest/ccaffeine-0.8.8.tar.gz"
  sha1 "8138a8dded7b0d8cb528e3a92171f63af4f30a54"

  resource 'boost' do
    url 'http://www.cca-forum.org/download/cca-tools/dependencies/boost_1_34_0.tar.gz'
    sha1 'abf85c8541fd30d16cf1647e0673ee1a89a57eab'
  end

  depends_on "libxml2"
  depends_on "cca-spec-babel"
  depends_on "babel"

  patch :DATA

  def install
    ENV.deparallelize

    resource("boost").stage do
      mkdir_p libexec/'include'
      mv "boost", "#{libexec}/include/"
    end

    system "./configure", "--without-mpi",
      "--with-boost=#{libexec}/include",
      "--with-cca-babel=#{HOMEBREW_PREFIX}",
      "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ccafe-config", "--version"
  end
end

__END__
diff --git a/cxx/drivers/Makefile.in b/cxx/drivers/Makefile.in
index 36aaa32..a627122 100644
--- a/cxx/drivers/Makefile.in
+++ b/cxx/drivers/Makefile.in
@@ -30,7 +30,7 @@ $(INCLUDES) \
 $(CFLAGS) 
 
 LOCAL_CXXFLAGS= \
--Dlint=lint \
+-Dlint=lint -LHOMEBREW_PREFIX/lib -lsidlstub_cxx \
 $(CXXFLAGS) \
 $(CCAFE_PTHREADS_FLAGS)
 
