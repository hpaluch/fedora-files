Early helper files to setup Koji Server.

Based on: https://forge.fedoraproject.org/koji/koji/src/branch/master/docs/source/server_howto.rst

Fully tested Host OS: Fedora 44

# Fedora 45 notes

1. if `semanage` is not installed have to install it with `dnf install policycoreutils-python-utils`
   (added to script `60-setup-koji-dirs.sh`)

2. `dnf` now enforces GPG checks causing `mock init` to fail...

Later is more serious
- theoretical solution is on https://forge.fedoraproject.org/koji/koji/issues/4544 and https://forge.fedoraproject.org/koji/koji/pulls/4635/files
- in my case it should be enough to call:
  ```shell
  koji edit-tag  dist-f44-build -x mock.package_manager=dnf5
  # or maybe?
  koji edit-tag  dist-f44-build --arches x86_64 -x mock.package_manager=dnf5
  ```
- but none of above commands does NOT work - there is some weird issue in kojihub.py that it improperly propagates
  inheritance of `extra` dictionary when assigned to Event...
- as desperate hotfix I did this:

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

- and restarted Apache with: `systemctl restart httpd`
- and that helped in my case
