#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtDeclarative import QDeclarativeView

from math import floor, fmod
from time import time

from hashlib import sha1
from time import time
from base64 import b32decode
from struct import pack, unpack_from
import gconf
import hmac

class PasscodeGenerator(QObject):
	def __init__(self, secret=str()):
		QObject.__init__(self)
		self._fixed = len(secret) > 0
		if (self._fixed):
			self._secret = secret
		else:
			self._secret = gconf.client_get_default().get_string('/apps/ControlPanel/PyGAuth/Secret')
			self.secretChanged.connect(self.saveSecret)
		self._pin = 'No secret'
		self._timer = QTimer(self)
		self._timer.setSingleShot(True)
		self._timer.timeout.connect(self.pinExpired)
		self.secretChanged.connect(self.updatePin)
		self.validityUpdated.connect(self.updatePin)
		#self.connect(self._timer, SIGNAL("timeout()"), self.pinExpired)
		#self.connect(self, SIGNAL("on_new_secret()"), self.updatePin)
		#self.connect(self, SIGNAL("on_new_validity()"), self.updatePin)
		self.pinExpired()

	def _get_secret(self):
		return self._secret

	def _set_secret(self, secret):
		if (secret != self._secret):
			self._secret = secret
			self.secretChanged.emit()

	def _get_pin(self):
		return self._pin

	def _get_validity(self):
		return 30 - fmod(time(), 30)

	@Slot()
	def pinExpired(self):
		self.validityUpdated.emit()
		self._timer.setInterval(self._get_validity() * 1000)
		self._timer.start()

	@Slot()
	def updatePin(self):
		if (self._secret is None or len(self._secret) == 0):
			return

		# The secret is recorded in base32
		secret = b32decode(self._secret, True)

		# The timer is every 30 seconds
		now = time()
		now = int( floor( now / 30 ) )

		# The value is an 8-byte big endian (Java) interval number
		value = pack("!q", now)

		# The hashing algorithm is HMACSHA1
		hm = hmac.new(secret, value, sha1)

		# Get the resulting binary digest
		digest = hm.digest()

		# Truncate the hash
		offset = unpack_from("b", digest[-1])[0] & 0xf
		pin = (unpack_from("!i", digest, offset)[0] & 0x7FFFFFFF) % 10**6
		if (pin != self._pin):
			self._pin = str(pin).zfill(6)
			self.pinChanged.emit()

	@Slot()
	def saveSecret(self):
		gconf.client_get_default().set_string('/apps/ControlPanel/PyGAuth/Secret', self._secret)

	secretChanged = Signal()
	pinChanged = Signal()
	validityUpdated = Signal()

	secret = Property(str, _get_secret, _set_secret, notify=secretChanged)
	pin = Property(str, _get_pin, notify=pinChanged)
	validity = Property(float, _get_validity, notify=validityUpdated)

# Create Qt application and the QDeclarative view
app = QApplication(sys.argv)
secret = str()
if (len(app.arguments()) == 2):
	secret = app.arguments()[1]
view = QDeclarativeView()
# Create an URL to the QML file
url = QUrl('view.qml')
# Set the QML file and show
pcg = PasscodeGenerator(secret)
view.rootContext().setContextProperty('passcodeGenerator', pcg)
view.setSource(url)
view.showFullScreen()
# Enter Qt main loop
sys.exit(app.exec_())
