Early helper files to setup Koji Server.

Based on: https://forge.fedoraproject.org/koji/koji/src/branch/master/docs/source/server_howto.rst

Fully tested Host OS: Fedora 44  and Fedora 45 (pre-release as of 2026-10-30)

How to use:
- copy `etc/pki/koji/*` to your `/etc/pki/koji` folder
- become root
- run sequentially all scripts (starting with numbers) there as root (few scripts need to run
  as your original non-privileged users - they will tell you)
- last script `98-koji-build-clockres-f44.sh` will attempt to build my tiny tool `clockres`
  for Fedora 44 target using installed Koji - verifying that our Koji really works

# Fedora 45 notes

In F45 `dnf` now enforces GPG checks causing `mock init` to fail...
- therefore I modified script [etc/pki/koji/97-koji-add-f44-repo.sh](etc/pki/koji/97-koji-add-f44-repo.sh)
  to add:
  ```shell
  koji edit-tag  dist-f44-build -x mock.package_manager=dnf5
  ```
- as recommended on: https://forge.fedoraproject.org/koji/koji/issues/4544 and https://forge.fedoraproject.org/koji/koji/pulls/4635/files

WARNING! It was observed that above `edit-tag` is effective only when run
//before 1st build//! It will not work when you set it after failed build (it
will not appear in `mock-config` output)! In such case I applied horrible hack
below to enforce it temporarily:

```diff
--- usr/lib/python3.15/site-packages/kojihub/kojihub.py.orig	2026-10-28 21:45:51.375000000 +0100
+++ usr/lib/python3.15/site-packages/kojihub/kojihub.py	2026-10-28 22:31:31.178000000 +0100
@@ -14100,6 +14100,7 @@
                 del taginfo['extra'][k]
             else:
                 taginfo['extra'][k] = v[1]
+        taginfo['extra']['mock.package_manager']='dnf5'
         return taginfo
 
     getRepo = staticmethod(repos.old_get_repo)
```
And restarted Apache with: `systemctl restart httpd`
