--- third_party/llvm/workspace.bzl.orig	2021-09-27 00:12:22 UTC
+++ third_party/llvm/workspace.bzl
@@ -10,6 +10,7 @@ def repo(name):
     tf_http_archive(
         name = name,
         sha256 = LLVM_SHA256,
+        patch_file = "//third_party/llvm:llvm_BUILD.patch",
         strip_prefix = "llvm-project-{commit}".format(commit = LLVM_COMMIT),
         urls = [
             "https://storage.googleapis.com/mirror.tensorflow.org/github.com/llvm/llvm-project/archive/{commit}.tar.gz".format(commit = LLVM_COMMIT),
