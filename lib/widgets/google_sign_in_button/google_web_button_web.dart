import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

Widget buildGoogleWebSignInButton() {
  return web.renderButton(
    configuration: web.GSIButtonConfiguration(
      type: web.GSIButtonType.standard,
      theme: web.GSIButtonTheme.outline,
      size: web.GSIButtonSize.large,
      shape: web.GSIButtonShape.pill,
      text: web.GSIButtonText.signinWith,
      minimumWidth: 280,
    ),
  );
}
