import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class MarketPlaceFirebaseUser {
  MarketPlaceFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

MarketPlaceFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<MarketPlaceFirebaseUser> marketPlaceFirebaseUserStream() => FirebaseAuth
    .instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<MarketPlaceFirebaseUser>(
        (user) => currentUser = MarketPlaceFirebaseUser(user));
