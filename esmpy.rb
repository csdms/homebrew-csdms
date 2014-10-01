require "formula"

class Esmpy < Formula
  version "6.3.0"
  homepage "http://www.earthsystemmodeling.org"
  url "git://git.code.sf.net/p/esmf/esmf", :branch => 'ESMF_6_3_0rp1'
  sha1 "f459a65373fd5a7925ea935bc75b66283b27936b"

  option "with-check", "Run tests before installing"
  option "with-python=", "Path to a python binary" if OS.linux?

  depends_on "esmf"

  def install
    ENV.prepend_path 'PATH', File.dirname(which_python)

    cd "src/addon/ESMPy" do
      system "python", "setup.py", "build", "--ESMFMKFILE=" + which_esmf_mk,
        "install", "--prefix=#{prefix}"

      system "python", "setup.py", "test_all" if build.with? "check"
    end
  end

  def which_python
    python = ARGV.value('with-python') || which('python').to_s
    raise "#{python} not found" unless File.exist? python
    return python
  end

  def which_esmf_mk
    compiler = File.basename("#{ENV.fc}")
    compiler += File.basename("#{ENV.cc}") if OS.mac?

    arch = if OS.mac? then "Darwin" else "Linux" end

    path_to_file = Formula["esmf"].lib + "libO/#{arch}.#{compiler}.64.mpiuni.default/esmf.mk"
    raise "#{path_to_file} not found" unless File.exist? path_to_file
    return path_to_file
  end

  test do
    Language::Python.each_python(build) do |python, version|
      system python, "-c", "import ESMF"
    end
  end
end
