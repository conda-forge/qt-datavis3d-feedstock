

cd %RECIPE_DIR%\hello
cmake -LAH -G "Ninja" -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" -DCMAKE_BUILD_TYPE=Release .
cmake --build . --config Release
.\hello.exe

%PYTHON% -c "from PySide2.QtWidgets import QOpenGLWidget; from PySide2.QtWidgets import QApplication; app = QApplication(); obj = QOpenGLWidget(); print(obj.defaultFramebufferObject())"
rem  %PYTHON% -c "from PySide6.QtOpenGLWidgets import QOpenGLWidget; from PySide6.QtWidgets import QApplication; app = QApplication(); obj = QOpenGLWidget(); print(obj.defaultFramebufferObject())"
exit 0

mkdir build && cd build
cmake -LAH -G "Ninja" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DINSTALL_BINDIR=lib/qt6/bin ^
    -DINSTALL_PUBLICBINDIR=bin ^
    -DINSTALL_LIBEXECDIR=lib/qt6 ^
    -DINSTALL_DOCDIR=share/doc/qt6 ^
    -DINSTALL_ARCHDATADIR=lib/qt6 ^
    -DINSTALL_DATADIR=share/qt6 ^
    -DINSTALL_INCLUDEDIR=include/qt6 ^
    -DINSTALL_MKSPECSDIR=lib/qt6/mkspecs ^
    -DINSTALL_EXAMPLESDIR=share/doc/qt6/examples ^
    -DINSTALL_DATADIR=share/qt6 ^
    ..
if errorlevel 1 exit 1

cmake --build . --target install --config Release
if errorlevel 1 exit 1

:: we set INSTALL_BINDIR != /bin to avoid clobbering qt5 exes but still dlls in /bin
xcopy /y /s %LIBRARY_PREFIX%\lib\qt6\bin\*.dll %LIBRARY_PREFIX%\bin
if errorlevel 1 exit 1
