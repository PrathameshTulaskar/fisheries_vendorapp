import 'facebookAuth.dart';
import 'googleAuth.dart';

class Credentials{
  String userId;
  String identifier;
  String contactNumber;
  GoogleAuthModel googleSignIn;
  FacebookAuthModel fbSignIn;
  Credentials({
    this.userId,
    this.fbSignIn,
    this.googleSignIn,
    this.identifier,
    this.contactNumber
  });
}