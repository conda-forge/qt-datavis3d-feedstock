#!/bin/sh

XVFB_RUN=""
if test `uname` = "Linux"
then
  cp -r /usr/include/xcb ${PREFIX}/include/qt
  XVFB_RUN="xvfb-run -s '-screen 0 640x480x24'"
fi

cd ${RECIPE_DIR}/hello
cmake -LAH -G "Ninja" ${CMAKE_ARGS} -DCMAKE_PREFIX_PATH=${PREFIX} -DCMAKE_FIND_FRAMEWORK=LAST .
cmake --build .

grep -nr defaultFramebufferObject ${SP_DIR}/PySide2 || echo "no defaultFramebufferObject in PySide2"
grep -nr defaultFramebufferObject ${PREFIX}/lib || echo "no defaultFramebufferObject in PREFIX/lib"
grep -nr defaultFramebufferObject ${PREFIX}/include || echo "no defaultFramebufferObject in PREFIX/include"

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  eval ${XVFB_RUN} ./hello

  ${PYTHON} -c "from PySide2.QtWidgets       import QOpenGLWidget; from PySide2.QtWidgets import QApplication; app = QApplication(); obj = QOpenGLWidget(); print('python.obj.defaultFramebufferObject', obj.defaultFramebufferObject())"
  # ${PYTHON} -c "from PySide6.QtOpenGLWidgets import QOpenGLWidget; from PySide6.QtWidgets import QApplication; app = QApplication(); obj = QOpenGLWidget(); print(obj.defaultFramebufferObject())"

fi

exit 0

if test "$CONDA_BUILD_CROSS_COMPILATION" = "1"
then
  CMAKE_ARGS="${CMAKE_ARGS} -DQT_HOST_PATH=${BUILD_PREFIX}"
fi

mkdir build && cd build
cmake -LAH -G "Ninja" ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_FIND_FRAMEWORK=LAST \
  -DCMAKE_INSTALL_RPATH:STRING=${PREFIX}/lib \
  -DINSTALL_BINDIR=lib/qt6/bin \
  -DINSTALL_PUBLICBINDIR=usr/bin \
  -DINSTALL_LIBEXECDIR=lib/qt6 \
  -DINSTALL_DOCDIR=share/doc/qt6 \
  -DINSTALL_ARCHDATADIR=lib/qt6 \
  -DINSTALL_DATADIR=share/qt6 \
  -DINSTALL_INCLUDEDIR=include/qt6 \
  -DINSTALL_MKSPECSDIR=lib/qt6/mkspecs \
  -DINSTALL_EXAMPLESDIR=share/doc/qt6/examples \
  ..
cmake --build . --target install

