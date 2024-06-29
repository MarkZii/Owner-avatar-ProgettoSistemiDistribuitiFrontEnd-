import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

class AmplifyConfiguration {
  static const amplifyconfig = '''{
    "auth": {
      "plugins": {
        "awsCognitoAuthPlugin": {
          "UserAgent": "aws-amplify-cli/0.1.0",
          "Version": "0.1.0",
          "IdentityManager": {
            "Default": {}
          },
          "CognitoUserPool": {
            "Default": {
              "PoolId": "eu-north-1_sJvryjHoa",
              "AppClientId": "5tm94abk7017u4tfesuugnclp3",
              "Region": "eu-north-1"
            }
          },
          "Auth": {
            "Default": {
              "authenticationFlowType": "USER_SRP_AUTH"
            }
          }
        }
      }
    }
  }''';

  static Future<void> configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugins([auth]);
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print('An error occurred configuring Amplify: $e');
    }
  }
}