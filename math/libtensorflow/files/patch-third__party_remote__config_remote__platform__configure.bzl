--- third_party/remote_config/remote_platform_configure.bzl.orig	2021-09-19 02:13:34 UTC
+++ third_party/remote_config/remote_platform_configure.bzl
@@ -8,6 +8,8 @@ def _remote_platform_configure_impl(repository_ctx):
             platform = "windows"
         elif os.startswith("mac os"):
             platform = "osx"
+        elif os.startswith("freebsd"):
+            platform = "freebsd"
         else:
             platform = "linux"
 
