
#include <QOpenGLWidget>
#include <QApplication>
#include <iostream>

int main(int argc, char *argv[])
{
  QApplication app(argc, argv);
  QOpenGLWidget oglw;
  std::cout << "defaultFramebufferObject=" << oglw.defaultFramebufferObject() << std::endl;
  return 0;
}
