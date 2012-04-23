from distutils.core import setup
import os, sys, glob

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(name="pygauth",
      scripts=['pygauth'],
      version='0.1.0',
      maintainer="Joshua King",
      maintainer_email="jking_ok@yahoo.com.au",
      description="Authenticator for online services",
      long_description=read('pygauth.longdesc'),
      data_files=[('/opt/pygauth/bin', ['pygauth']),
                  ('share/applications',['pygauth_harmattan.desktop']),
                  ('share/icons/hicolor/64x64/apps', ['pygauth.png']),
                  ('share/icons/hicolor/80x80/apps', ['pygauth80.png']),
                  ('/opt/pygauth/qml', glob.glob('qml/*.qml')), ],)
