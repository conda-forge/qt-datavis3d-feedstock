#!/bin/sh

grep -nr defaultFramebufferObject ${SP_DIR}/PySide2
${PYTHON} -c "from PySide2.QtWidgets       import QOpenGLWidget; from PySide2.QtWidgets import QApplication; app = QApplication(); obj = QOpenGLWidget(); print(obj.defaultFramebufferObject())"
# ${PYTHON} -c "from PySide6.QtOpenGLWidgets import QOpenGLWidget; from PySide6.QtWidgets import QApplication; app = QApplication(); obj = QOpenGLWidget(); print(obj.defaultFramebufferObject())"

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

