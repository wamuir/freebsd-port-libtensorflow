PORTNAME=	libtensorflow
DISTVERSIONPREFIX=	v
DISTVERSION=	2.7.0
DISTVERSIONSUFFIX=	-rc1
CATEGORIES=	math

MAINTAINER=	wamuir@gmail.com
COMMENT=	C API for TensorFlow, an open source platform for machine learning

LICENSE=	APACHE20 THIRD_PARTY_TF_C_LICENSES
LICENSE_COMB=	multi
LICENSE_NAME_THIRD_PARTY_TF_C_LICENSES=	Third-Party TensorFlow C Licenses
LICENSE_FILE_APACHE20=	${WRKSRC}/LICENSE
LICENSE_FILE_THIRD_PARTY_TF_C_LICENSES=	${WRKDIR}/THIRD_PARTY_TF_C_LICENSES
LICENSE_PERMS_THIRD_PARTY_TF_C_LICENSES=	dist-mirror dist-sell pkg-mirror pkg-sell auto-accept

ONLY_FOR_ARCHS=	amd64

BUILD_DEPENDS=	bash:shells/bash \
		bazel>=4.0.0:devel/bazel \
		git:devel/git \
		${PYNUMPY}

USES=	python:3.8,build
BINARY_ALIAS=	python3=${PYTHON_CMD}
BINARY_ALIAS+=	python=${PYTHON_CMD}

USE_GITHUB=	yes
GH_ACCOUNT=	tensorflow
GH_PROJECT=	tensorflow

USE_LDCONFIG=	yes

BAZEL_OPTS=	--output_user_root=${WRKDIR}/bazel_out
CC?=	clang

post-extract:
	# THIRD_PARTY_TF_C_LICENSES is generated as a Bazel build target (see
	# //tensorflow/tools/lib_package:clicenses) and the empty file written
	# here will be overwritten. Creation of this file is to satisfy checks.
	@${TOUCH} ${WRKDIR}/THIRD_PARTY_TF_C_LICENSES

do-configure:
	@cd ${WRKSRC} && ${SETENV} \
		CC_OPT_FLAGS="-I${LOCALBASE}/include" \
		PREFIX="${LOCALBASE}" \
		PYTHON_BIN_PATH=${PYTHON_CMD} \
		PYTHON_LIB_PATH="${PYTHON_SITELIBDIR}" \
		TF_CONFIGURE_IOS=0 \
		TF_DOWNLOAD_CLANG=0 \
		TF_ENABLE_XLA=0 \
		TF_IGNORE_MAX_BAZEL_VERSION=0 \
		TF_NEED_CUDA=0 \
		TF_NEED_ROCM=0 \
		TF_NEED_TENSORRT=0 \
		TF_SET_ANDROID_WORKSPACE=0 \
		${LOCALBASE}/bin/bash ./configure

do-build:
	@cd ${WRKSRC} && ${LOCALBASE}/bin/bazel ${BAZEL_OPTS} build -s \
		${BAZEL_ARGS} \
		--action_env=PATH=${PATH} \
		--config=release_cpu_freebsd \
		--verbose_failures \
		//tensorflow/tools/lib_package:clicenses_generate \
		//tensorflow/tools/lib_package:libtensorflow.tar.gz

do-test:
	@cd ${WRKSRC} && ${LOCALBASE}/bin/bazel ${BAZEL_OPTS} test -s \
		${BAZEL_ARGS} \
		--action_env=PATH=${PATH} \
		--config=release_cpu_freebsd \
		--test_env=CC=${CC} \
		--verbose_failures \
		//tensorflow/tools/lib_package:libtensorflow_test

pre-install:
	@${CP} ${WRKSRC}/bazel-bin/tensorflow/tools/lib_package/THIRD_PARTY_TF_C_LICENSES ${WRKDIR}/THIRD_PARTY_TF_C_LICENSES
	@${MKDIR} ${WRKDIR}/lib_package
	@tar xz -C ${WRKDIR}/lib_package -f ${WRKSRC}/bazel-bin/tensorflow/tools/lib_package/libtensorflow.tar.gz
	${MKDIR} ${STAGEDIR}${PREFIX}/include/tensorflow
	${MKDIR} ${STAGEDIR}${PREFIX}/include/tensorflow/c
	${MKDIR} ${STAGEDIR}${PREFIX}/include/tensorflow/c/eager
	${MKDIR} ${STAGEDIR}${PREFIX}/include/tensorflow/core
	${MKDIR} ${STAGEDIR}${PREFIX}/include/tensorflow/core/platform

do-install:
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/c_api.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/c_api.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/c_api_experimental.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/c_api_experimental.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/c_api_macros.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/c_api_macros.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/tensor_interface.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/tensor_interface.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/tf_attrtype.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/tf_attrtype.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/tf_datatype.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/tf_datatype.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/tf_file_statistics.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/tf_file_statistics.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/tf_status.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/tf_status.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/tf_tensor.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/tf_tensor.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/tf_tstring.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/tf_tstring.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/core/platform/ctstring.h ${STAGEDIR}${PREFIX}/include/tensorflow/core/platform/ctstring.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/core/platform/ctstring_internal.h ${STAGEDIR}${PREFIX}/include/tensorflow/core/platform/ctstring_internal.h
	${INSTALL_PROGRAM} ${WRKDIR}/lib_package/lib/libtensorflow.so.${DISTVERSION} ${STAGEDIR}${PREFIX}/lib/libtensorflow.so.${DISTVERSION}
	@${RLN} ${STAGEDIR}${PREFIX}/lib/libtensorflow.so.${DISTVERSION} ${STAGEDIR}${PREFIX}/lib/libtensorflow.so.2
	@${RLN} ${STAGEDIR}${PREFIX}/lib/libtensorflow.so.2 ${STAGEDIR}${PREFIX}/lib/libtensorflow.so
	${INSTALL_PROGRAM} ${WRKDIR}/lib_package/lib/libtensorflow_framework.so.${DISTVERSION} ${STAGEDIR}${PREFIX}/lib/libtensorflow_framework.so.${DISTVERSION}
	@${RLN} ${STAGEDIR}${PREFIX}/lib/libtensorflow_framework.so.${DISTVERSION} ${STAGEDIR}${PREFIX}/lib/libtensorflow_framework.so.2
	@${RLN} ${STAGEDIR}${PREFIX}/lib/libtensorflow_framework.so.2 ${STAGEDIR}${PREFIX}/lib/libtensorflow_framework.so
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/eager/c_api.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/eager/c_api.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/eager/c_api_experimental.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/eager/c_api_experimental.h
	${INSTALL_DATA} ${WRKDIR}/lib_package/include/tensorflow/c/eager/dlpack.h ${STAGEDIR}${PREFIX}/include/tensorflow/c/eager/dlpack.h

.include <bsd.port.mk>
