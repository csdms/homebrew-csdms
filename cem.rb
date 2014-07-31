require "formula"

class Cem < Formula
  version "1.0"
  homepage ""
  url "https://csdms.colorado.edu/svn/cem/trunk", :using => :svn
  sha1 ""

  depends_on "glib"
  depends_on "cmake" => :build
  depends_on "pkgconfig" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV.append_to_cflags %x[pkg-config --cflags glib-2.0].chomp

    # Remove unrecognized options if warned by configure
    #system "./configure", "--disable-debug",
    #                      "--disable-dependency-tracking",
    #                      "--disable-silent-rules",
    #                      "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test cem`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
