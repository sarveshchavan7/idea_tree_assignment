import 'package:idea_tree_assignment/bloc/bloc_provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginBloc implements BlocBase {
  final LocalAuthentication _auth = LocalAuthentication();

  // Check if device supports finger print scanner
  Future<bool> _isFingerPrintBiometricAvailable() async {
    List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.fingerprint);
  }

  // Authenticate using finger print
  Future<bool> authenticate() async {
    try {
      if (await _isFingerPrintBiometricAvailable()) {
        return await _auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Fingerprint biometric unavailable on your device.',
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
      return false;
    }
  }

  // Authenticate using facebook
  Future<bool> faceBookLogin() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        Fluttertoast.showToast(
          msg: 'Login Successfull',
        );
        return true;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
    return false;
  }

  @override
  void dispose() {}
}
