# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mdbtools
$(PKG)_WEBSITE  := https://github.com/mdbtools/mdbtools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.1
$(PKG)_CHECKSUM := ff9c425a88bc20bf9318a332eec50b17e77896eef65a0e69415ccb4e396d1812
$(PKG)_GH_CONF  := mdbtools/mdbtools/releases, v
$(PKG)_DEPS     := cc glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/mdbtools/mdbtools/tags' | \
    grep 'href="/mdbtools/mdbtools/archive/' | \
    $(SED) -n 's,.*href="/mdbtools/mdbtools/archive/refs/tags/v\([0-9][^"_]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -i -f
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --disable-man \
        --without-bash-completion-dir \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) CFLAGS+='-Wno-deprecated-declarations' -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA= || \
    $(MAKE) CFLAGS+='-Wno-deprecated-declarations' -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=
endef

$(PKG)_BUILD_SHARED =
