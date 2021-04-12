import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/login/cubit/kakaoCubit.dart';
import 'package:homg_long/repository/%20authRepository.dart';

//https://bloclibrary.dev/#/flutterfirebaselogintutorial
//https://github.com/bizz84/starter_architecture_flutter_firebase
//https://medium.com/@SebastianEngel/easy-push-notifications-with-flutter-and-firebase-cloud-messaging-d96084f5954f
//https://flutterawesome.com/smart-course-app-built-in-flutter/
class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
          child: BlocProvider(
        create: (_) =>
            KakaoLoginCubit(context.read<AuthenticationRepository>()),
        child: LoginForm(),
      )),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<KakaoLoginCubit, LoginState>(
        listener: (context, state) {
          if (state == LoginState.LOGIN) {
            print("LoginState=$state");
            Navigator.pushNamed(context, "/Wifi");
          }
          // } else if (state == LoginState.UNLOGIN) {
          //   print("LoginState=$state");
          // }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "LOGIN",
              style: TextStyle(
                  fontSize: AppTheme.header_font_size,
                  color: AppTheme.font_color,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 30.0,
            ),
            _KakaoLogin()
          ],
        ));
  }
}

class _KakaoLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 300.0,
      height: 60.0,
      child: FlatButton(
          key: const Key('loginForm_createAccount_flatButton'),
          // color: Theme.of(context).accentColor,
          disabledColor: Theme.of(context).accentColor,
          splashColor: Colors.grey,
          onPressed: () => context.read<KakaoLoginCubit>().login(),
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Image.asset(
              'images/kakao_account_login_btn_medium_wide.png',
            ),
          )),
    );
  }
}
