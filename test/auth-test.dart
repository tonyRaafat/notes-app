import 'package:expense_tracker/views/services/auth/auth_exceptions.dart';
import 'package:expense_tracker/views/services/auth/auth_provider.dart';
import 'package:expense_tracker/views/services/auth/auth_user.dart';
import 'package:test/test.dart';

main() {
  group('mock authentication test', () {
    final provider = mockAuthProvider();
    
    test('should not be initialized at first', () {
      expect(provider._isInitialized, false);
    });

    test('should not logout if not initialized', () {
      expect(provider.logout(),
      throwsA(const TypeMatcher<NotInitializedExeption>()));
    });

     test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logout();
      await provider.login(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });

}

class NotInitializedExeption implements Exception {}

class mockAuthProvider implements AuthProvider {
  bool _isInitialized = false;
  AuthUser? _user;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!_isInitialized) {
      throw NotInitializedExeption();
    }
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!_isInitialized) throw NotInitializedExeption();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    var user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(_user);
  }

  @override
  Future<void> logout() async {
    if (!_isInitialized) throw NotInitializedExeption();
    if (_user == null) {
      throw UserNotFoundAuthException();
    }
    await Future.delayed(const Duration(seconds: 1));

    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if(!_isInitialized) throw NotInitializedExeption();
    var user = _user;
    if(user == null) throw UserNotFoundAuthException();
    var newuser = AuthUser(isEmailVerified: true);
    _user = newuser;
  }
}
