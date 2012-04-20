from distutils.core import setup
import os, sys, glob

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(name="pygauth",
      scripts=['pygauth'],
      version='0.1.0',
      maintainer="user",
      maintainer_email="email@example.com",
      description="Authenticator for online services",
      long_description=read('pygauth.longdesc'),
      data_files=[('share/applications',['pygauth.desktop']),
                  ('share/icons/hicolor/64x64/apps', ['pygauth.png']),
                  ('share/pygauth/qml', glob.glob('qml/*.qml')), ],)
