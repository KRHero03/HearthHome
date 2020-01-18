
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //Authentication Firebase Object

  String verificationIdS;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Create User object from FirebaseUser object
  FirebaseUser _getUser(FirebaseUser user) {
    return user == null
        ? null
        : user; //Function is used to instantiate User object from FirebaseUser instance.
  }

  //When Authentication is Done, Stream is used to notify wrapper.
  Stream<FirebaseUser> get user {
    
    return _auth.onAuthStateChanged.map(
        _getUser); //Maps FirebaseUser Instance to custom User instance using _getUser function.
    //It is the same process as Pipelining. The Auth instance provides a FirebaseUser Object
    //that is passed into _getUser which returns User object.
  }


  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  /*Future<FirebaseUser> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult result = await _auth.signInWithCredential(credential);

      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<FirebaseUser> signInWithFacebook() async {
    try {
      final facebookLogin = new FacebookLogin();
      final facebookLoginResult = await facebookLogin
          .logInWithReadPermissions(['email', 'public_profile']);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          break;

        case FacebookLoginStatus.cancelledByUser:
          break;

        case FacebookLoginStatus.loggedIn:
          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');
          var profile = json.decode(graphResponse.body);
          List<String> signInMethods =
              await _auth.fetchSignInMethodsForEmail(email: profile['email']);
          print(signInMethods);
          if (signInMethods.isEmpty) {
            AuthCredential credential = FacebookAuthProvider.getCredential(
                accessToken: facebookLoginResult.accessToken.token);
            final AuthResult result =
                await _auth.signInWithCredential(credential);
            FirebaseUser user = result.user;
            return user;
          } else {
            return null;
          }

      }

      return null;
    } catch (error) {
      return null;
    }
  }


  Future<FirebaseUser> signInWithPhoneCredential(AuthCredential credential) async{
   AuthResult result = await _auth.signInWithCredential(credential);
   return result.user;
  }
  signOut(BuildContext context) {
    try {
      _auth.signOut();
      Fluttertoast.showToast(
          msg: "You have successfully signed out!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Color(0xff4564e5),
          textColor: Color(0xfff3f5ff),
          fontSize: 16.0);
    } catch (error) {
      print(error);
    }
  }*/
}
