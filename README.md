harmattan-pygauth
=================

Python-Qt-QML hybrid implementation of Authenticator for Nokia N9

Description
-----------

This Authenticator generates tokens for use with
two-step verification with Google's online services.
Simply copy your Authenticator key into the phone's
Settings application or use the link/QR code provided
to set up the token. This application will then
constantly update with the current login code.
Please note that your phone's time must be correct
in order to generate valid codes.
No data is consumed by this application.

Installation
------------

Get it from the Nokia Store (coming soon) or
download from the Downloads tab on [GitHub][gh].

Either way should install the dependencies automatically.
If not, these are:

* Python
* PySide
* Python-GConf
* DBus

If you have access to the MeeGo Terminal, you can install
these using apt-get from the Nokia repositories.

Usage
-----

Simply run the app from the home screen. The main
page will appear. The first time the screen will
read "No secret". Tap the Settings cog in the tool bar.
Enter your Google secret (the key that you get
when activating two-step authentication) and a name for the token (optional). Return to the app
and your current PIN will continuously update.
Tap Copy in the tool bar to copy the current PIN
to the phone.

URI integration
---------------

You can also update your settings by URI. These
are embedded typically in QR codes.

Unfortunately the current version of MeeScan won't send such a code directly to GAuth. However the following will work:
1. Open MeeScan and scan the barcode.
2  Copy the text to the clipboard.
3. Open Web and paste the text and press Go.
4. GAuth should open and the new settings will be applied if they are understood.

[gh]: https://github.com/jkingok/harmattan-pygauth/
