import 'package:flutter_learn_project/services/auth/auth_exception.dart';
import 'package:flutter_learn_project/services/auth/auth_provider.dart';
import 'package:flutter_learn_project/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Mock Authentication',
    () {
      final provider = MockAuthProvider();
      test('Should not be initialized to begin with', () {
        expect(provider.isInitialized, false);
      });

      test(
        'Cannot log out if not initialized',
        () {
          expect(
            provider.logOut(),
            throwsA(
              const TypeMatcher<NotInializedException>(),
            ),
          );
        },
      );
      test('Should be able to be initialized', () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      });
      test('User should be null after  initialization', () {
        expect(provider.currentUser, null);
      });

      test(
        'Should be able to initialize in less than 2 seconds',
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
        timeout: const Timeout(
          Duration(seconds: 2),
        ),
      );
      test(
        'Create user should delegate to logIn function',
        () async {
          final badEmailUser = provider.createUser(
              email: 'foobar@gmail.com', password: 'password');
          expect(
            badEmailUser,
            throwsA(
              const TypeMatcher<UserNotFoundAuthException>(),
            ),
          );

          final badPasswordUser =
              provider.createUser(email: 'email2', password: 'password2');
          expect(
            badEmailUser,
            throwsA(
              const TypeMatcher<UserNotFoundAuthException>(),
            ),
          );
          final user =
              await provider.createUser(email: 'email3', password: 'password3');
          expect(provider.currentUser, user);
          expect(user.isEmailVerify, false);
        },
      );
      test('Logged in user should be able to get verified', () {});
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerify, true);
      test(
        'Should be able to log out and lag in again',
        () async {
          await provider.logOut();
          await provider.logIn(
            email: 'email4',
            password: 'password4',
          );
          final user = provider.currentUser;
          expect(user, isNotNull);
        },
      );
    },
  );
}

class NotInializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user = null;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!_isInitialized) throw NotInializedException();
    if (email == 'bsr@gmail.com') throw UserNotFoundAuthException();
    if (password == '12345') throw WrongPasswordAuthException();
    throw UnimplementedError(); 
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
    {}
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() async {
    if (isInitialized) throw NotInializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerify: true);
    _user = newUser;
  }
}


//birim testleri görebilirsin
//