class Angie < Formula
  desc "Efficient web server forked from nginx with advanced features"
  homepage "https://angie.software/"
  url "https://github.com/webserver-llc/angie/archive/refs/tags/Angie-1.11.3.tar.gz"
  sha256 "c02e3ef6baa1bc8733b10c7a3654016edb5d4fcf7a17cbaa774d332cfa0a991f"
  license "BSD-2-Clause"
  head "https://github.com/webserver-llc/angie.git", branch: "master"

  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    openssl_prefix = Formula["openssl@3"].opt_prefix

    system "./configure",
           "--prefix=#{prefix}",
           "--with-http_ssl_module",
           "--with-http_v2_module",
           "--with-http_v3_module",
           "--with-http_acme_module",
           "--with-pcre-jit",
           "--with-cc-opt=-I#{openssl_prefix}/include",
           "--with-ld-opt=-L#{openssl_prefix}/lib"

    system "make"
    system "make", "install"
  end

  def post_install
    (var/"log/angie").mkpath
    (var/"run/angie").mkpath
  end

  def caveats
    <<~EOS
      Angie has been installed to:
        #{opt_prefix}

      Configuration file:
        #{prefix}/conf/angie.conf

      To start angie:
        #{opt_sbin}/angie

      To reload configuration:
        #{opt_sbin}/angie -s reload
    EOS
  end

  test do
    system "#{sbin}/angie", "-V"
  end
end
