# SPEC file overview:
# https://docs.fedoraproject.org/en-US/quick-docs/creating-rpm-packages/#con_rpm-spec-file-overview
# Fedora packaging guidelines:
# https://docs.fedoraproject.org/en-US/packaging-guidelines/

%define rpmrelease %{nil}
%define bindir  /usr/bin 
%define mandir  /usr/share/man

Name: alert
Version: 1.0
Release: 1%{?rpmrelease}%{?dist}
Summary: Send messages to MS Teams work-flows

License: GPLv3
URL: https://sourcecode.jnj.com/projects/SRV-001803/repos/alert
Source0: %{name}-%{version}.tar.gz

BuildRequires: gcc
BuildRequires: make
BuildRequires: libcurl-devel
#Requires: libcurl-devel


%if 0%{?rhel} == 8
BuildRequires: rubygem-ronn
%endif

%if 0%{?rhel} >= 9
BuildRequires: rubygem-ronn-ng
%endif

BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

%description
The command alert send messages to MS Teams work-flows. 
The configuration file /etc/alert.conf is not part of this package.
Read man page: man alert

%prep
%setup -q


%build
%{__rm} -rf %{buildroot}
mkdir -vp %{buildroot}%{bindir}
mkdir -vp %{buildroot}%{mandir}
make build

%install
%{__make} install DESTDIR="%{buildroot}"


%files
%license COPYING
%defattr(-, root, root, 0755)
%{bindir}/%{name}
%doc %{_mandir}/man8/%{name}.8*



%changelog
* Tue  Sep 23 2025 ( gdhaese1 at its.jnj.com ) - 1.0-1
- initial release
