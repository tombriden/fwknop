# fwknop - Single Packet Authorization

## Introduction
fwknop implements an authorization scheme known as Single Packet Authorization
(SPA) for strong service concealment. SPA requires only a single packet which
is encrypted, non-replayable, and authenticated via an HMAC in order to
communicate desired access to a service that is hidden behind a firewall in a
default-drop filtering stance. The main application of SPA is to use a firewall
to drop all attempts to connect to services such as SSH in order to make the
exploitation of vulnerabilities (both 0-day and unpatched code) more difficult.
Because there are no open ports, any service that is concealed by SPA naturally
cannot be scanned for with Nmap. The fwknop project supports four different
firewalls: firewalld and iptables on Linux systems, pf on OpenBSD, and ipfw on
FreeBSD and Mac OS X.

SPA is essentially next generation Port Knocking (PK), but solves many of the
limitations exhibited by PK while retaining its core benefits. PK limitations
include a general difficulty in protecting against replay attacks, asymmetric
ciphers and HMAC schemes are not usually possible to reliably support, and it
is trivially easy to mount a DoS attack against a PK server just by spoofing an
additional packet into a PK sequence as it traverses the network (thereby
convincing the PK server that the client doesn't know the proper sequence). All
of these limitation are solved by SPA. At the same time, SPA hides services
behind a default-drop firewall policy, acquires SPA data passively (usually via
libpcap or other means), and implements standard cryptographic operations for
SPA packet authentication and encryption/decryption.

SPA packets generated by fwknop leverage HMAC for authenticated encryption in
the encrypt-then-authenticate model. Although the usage of an HMAC is currently
optional (enabled via the `--use-hmac` command line switch), it is highly
recommended for three reasons:

   1. Without an HMAC, cryptographically strong authentication is not possible
with fwknop unless GnuPG is used, but even then an HMAC should still be
applied.
   2. An HMAC applied after encryption protects against cryptanalytic CBC-mode
padding oracle attacks such as the Vaudenay attack and related trickery (like
the more recent "Lucky 13" attack against SSL).
   3. The code required by the fwknopd daemon to verify an HMAC is much more
simplistic than the code required to decrypt an SPA packet, so an SPA packet
without a proper HMAC isn't even sent through the decryption routines.

The final reason above is why an HMAC should still be used even when SPA
packets are encrypted with GnuPG due to the fact that SPA data is not sent
through libgpgme functions unless the HMAC checks out first. GnuPG and libgpgme
are relatively complex bodies of code, and therefore limiting the ability of a
potential attacker to interact with this code through an HMAC operation helps
to maintain a stronger security stance. Generating an HMAC for SPA
communications requires a dedicated key in addition to the normal encryption
key, and both can be generated with the `--key-gen` option.

fwknop encrypts SPA packets either with the Rijndael block cipher or via GnuPG
and associated asymmetric cipher. If the symmetric encryption method is chosen,
then as usual the encryption key is shared between the client and server (see
the `/etc/fwknop/access.conf` file for details). The actual encryption key used
for Rijndael encryption is generated via the standard PBKDF1 key derivation
algorithm, and CBC mode is set. If the GnuPG method is chosen, then the
encryption keys are derived from GnuPG key rings.

## Tutorial

A comprehensive tutorial on fwknop can be found here:

[http://www.cipherdyne.org/fwknop/docs/fwknop-tutorial.html](http://www.cipherdyne.org/fwknop/docs/fwknop-tutorial.html)


## License
The fwknop project is released as open source software under the terms of
the **GNU General Public License (GPL v2)**. The latest release can be found
at [http://www.cipherdyne.org/fwknop/](http://www.cipherdyne.org/fwknop/)


## Current State
This README file describes the present state of the fwknop project as of the
2.5 release made in July, 2013. At present, we have an implementation of the
Firewall Knock Operator library; `libfko`, as well as the fwknop client and
server applications. The library provides the API and back-end functionality
for managing the Single Packet Authorization (SPA) data that the other fwknop
components employ. It also can be used by other programs that need SPA
functionality (see the `perl` directory for the FKO perl module as an example,
and there are python bindings as well in the `python` directory).


## Upgrading
If you are upgrading from an older version of fwknop (and this includes the
original perl implementation as well), then you will want to read the
following link to ensure a smooth transition to fwknop-2.5:

[http://www.cipherdyne.org/fwknop/docs/fwknop-tutorial.html#backwards-compatibility](http://www.cipherdyne.org/fwknop/docs/fwknop-tutorial.html#backwards-compatibility)


## Building fwknop
This distribution uses GNU autoconf for setting up the build. Please see
the `INSTALL` file for the general basics on using autoconf.

There are some "configure" options that are specific to fwknop. They are
(extracted from *./configure --help*):

      --disable-client        Do not build the fwknop client component. The
                              default is to build the client.
      --disable-server        Do not build the fwknop server component. The
                              default is to build the server.
      --with-gpgme            support for gpg encryption using libgpgme
                              [default=check]
      --with-gpgme-prefix=PFX prefix where GPGME is installed (optional)
      --with-gpg=/path/to/gpg Specify path to the gpg executable that gpgme will
                              use [default=check path]
      --with-firewalld=/path/to/firewalld
                              Specify path to the firewalld executable
                              [default=check path]
      --with-iptables=/path/to/iptables
                              Specify path to the iptables executable
                              [default=check path]
      --with-ipfw=/path/to/ipfw
                              Specify path to the ipfw executable [default=check
                              path]
      --with-pf=/path/to/pfctl
                              Specify path to the pf executable [default=check
                              path]
      --with-ipf=/path/to/ipf Specify path to the ipf executable [default=check
                              path]

    Examples:

    ./configure --disable-client --with-firewalld=/bin/firewall-cmd
    ./configure --disable-client --with-iptables=/sbin/iptables --with-firewalld=no

## Notes
### Migrating from the Perl version of fwknop
For those of you who are currently using the Perl version and plan to
migrate to this version, there are some things to be aware of:

 * Not all of the features and functionality of the Perl-based
 fwknop were ported to this implementation. We felt it important
 to keep the C version as lean and lightweight as possible. Most
 of the omitted feature/functions (like email alerts) can be
 accomplished through other means (i.e. use an external script
 to monitor log files and alert based on appropriate log messages).

 * There are some differences in the fwknop configuration and access
 file directives and values. Some of these are fairly subtle. You
 should pay careful attention to the documentation and comments in
 those files.


## For fwknop developers
If you are pulling this distribution from git, you should run the
`autogen.sh` script to generate the autoconf files. If you get errors about
missing directories or files, try running `autogen.sh` again. After that
you can run the `autoreconf -i` when you want to regenerate the configuration.
If, for some reason, autoreconf does not work for you, the `autogen.sh`
script should suffice.

The fwknop and fwknopd man page nroff sources are included in their
respective directories (client and server). These nroff files are derived
from the asciidoc sources in the 'docs' directory. See the README in docs
for details.
