Name: plenv
Summary: Plenv multiple perl build management of interpreter and modules.
Version: 2.1.1
Release: 1%{?dist}
License: GPLv1
Group: Development/Tools
BuildArch: noarch
URL: https://github.com/tokuhirom/plenv
Source0: https://github.com/tokuhirom/plenv/archive/%{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
Use plenv to pick a Perl version for your application and guarantee that your development environment matches production. Put plenv to work with Carton for painless Perl upgrades and bulletproof deployments.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}

mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_libexecdir}

install -p libexec/* %{buildroot}%{_libexecdir}/
ln -s %{_libexecdir}/plenv %{buildroot}%{_bindir}/plenv
install -p bin/plenv %{buildroot}%{_bindir}/plenv

mkdir -p %{buildroot}%{_docdir}/%{name}
mv LICENSE %{buildroot}%{_docdir}/%{name}
mv README.md %{buildroot}%{_docdir}/%{name}

mkdir -p %{buildroot}%{_sysconfdir}/bash_completion.d
mv completions/plenv.bash %{buildroot}%{_sysconfdir}/bash_completion.d/plenv.bash
mv completions/plenv.zsh %{buildroot}%{_sysconfdir}/bash_completion.d/plenv.zsh

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_bindir}/plenv
%{_libexecdir}/*
%{_docdir}/plenv
%{_sysconfdir}/bash_completion.d/plenv.bash
%{_sysconfdir}/bash_completion.d/plenv.zsh

%changelog
* Fri Jun 19 2015 Brendan Beveridge <brendan@nodeintegration.com.au> - 2.1.1-1
- Initial creation
