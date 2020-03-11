import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  const channel = MethodChannel('de.aboutyou.mobile.app.sign_in_with_apple');

  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('performAuthorizationRequest -> Apple ID', () async {
    channel.setMockMethodCallHandler((methodCall) async {
      if (methodCall.method == 'performAuthorizationRequest') {
        return <dynamic, dynamic>{
          'type': 'appleid',
          'userIdentifier': 'some userIdentifier',
          'givenName': 'some givenName',
          'familyName': 'some familyName',
          'email': 'some@email.com',
          'identityToken': 'identityToken',
          'authorizationCode': 'authorizationCode',
        };
      }

      throw Exception('Unexpected method');
    });

    expect(
      await SignInWithApple.requestCredentials(),
      isA<AuthorizationCredentialAppleID>(),
    );
  });

  test('performAuthorizationRequest -> Username/Password', () async {
    channel.setMockMethodCallHandler((methodCall) async {
      if (methodCall.method == 'performAuthorizationRequest') {
        return <dynamic, dynamic>{
          'type': 'password',
          'username': 'user1',
          'password': 'admin',
        };
      }

      throw Exception('Unexpected method');
    });

    expect(
      await SignInWithApple.requestCredentials(),
      isA<AuthorizationCredentialPassword>(),
    );
  });
}
