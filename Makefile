all: configure build

submodule:
	git submodule update --recursive --init --depth=1

iree/configure_bazel.py: submodule

iree.configure: iree/configure_bazel.py
	git -C iree checkout .
	git -C iree apply < iree.patch
	env $(if ${WITH_CLANG},CC=/usr/bin/clang CXX=/usr/bin/clang++,CC=/usr/bin/gcc CXX=/usr/bin/g++) python3 $^

iree.patch:
	git -C iree diff >$@

configure: iree.configure

BAZEL_CACHE_PERSISTENT=${CURDIR}/.cache/bazel
BAZEL_CACHE=${CURDIR}/.cache/bazel
BAZEL=set -eux;cd iree;bazel --output_base ${BAZEL_CACHE}
BAZEL_OPTS=$(if $(IDX_CHANNEL),,--repository_cache=${BAZEL_CACHE_PERSISTENT}-repo --disk_cache=${BAZEL_CACHE_PERSISTENT}-build)

TARGETS=\
 //tools:iree-compile\
 //tools:iree-opt\

BAZEL_BUILD_OPTS=${BAZEL_OPTS} --define use_stablehlo=true\
  $(if ${WITH_GDB} ,--compilation_mode dbg, --compilation_mode opt --strip=always)

fetch:
	${BAZEL} fetch ${BAZEL_OPTS} ${TARGETS}

build:
	${BAZEL} build ${BAZEL_BUILD_OPTS} ${TARGETS}

clean:
	${BAZEL} clean --expunge

.PHONY:\
 build\
 builder.build\
 clean\
 configure\
 fetch\
 iree.configure\
 iree.patch\
 log\
 patches\
 submodule\
