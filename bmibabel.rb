require "formula"

class Bmibabel < Formula
  #version "0.1"
  homepage "https://github.com/bmi-forum/bmi-babel"
  head "https://github.com/bmi-forum/bmi-babel", :using => :git
  sha1 ""

  option "with-python=", "Path to a python binary"

  depends_on :python unless OS.linux?

  def install
    ENV.prepend_path 'PATH', File.dirname(which_python)

    site_packages_suffix = "lib/#{python_version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec + site_packages_suffix
    ENV.prepend_create_path "PYTHONPATH", prefix + site_packages_suffix

    install_args = ["setup.py", "install", "--prefix=#{libexec}"]

    system which_python, "setup.py", "install", "--prefix=#{prefix}"

    ENV.prepend_path 'PATH', "#{libexec}/bin"
  end

  test do
    system "python", "-c", "import bmibabel"
  end

  def which_python
    python = ARGV.value('with-python') || which('python').to_s
    raise "#{python} not found" unless File.exist? python
    return python
  end

  def python_prefix
    `#{which_python} -c 'import sys; print(sys.prefix)'`.strip
  end

  def python_version
    "python" + `python -c 'import sys; print(sys.version[:3])'`.strip
  end
end
