import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/home/homePage.dart';
import 'package:homg_long/login/cubit/loginCubit.dart';
import 'package:homg_long/repository/authRepository.dart';
import 'package:homg_long/wifi/wifiSettingPage.dart';

//https://bloclibrary.dev/#/flutterfirebaselogintutorial
//https://github.com/bizz84/starter_architecture_flutter_firebase
//https://medium.com/@SebastianEngel/easy-push-notifications-with-flutter-and-firebase-cloud-messaging-d96084f5954f
//https://flutterawesome.com/smart-course-app-built-in-flutter/

enum LoginState { LOGIN, UNLOGIN }

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
          create: (_) => loginCubit(context.read<AuthenticationRepository>()),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<loginCubit, LoginState>(
      listener: (context, state) {
        if (state == LoginState.LOGIN) {
          print("LoginState=$state");
          Navigator.pushNamed(context, "/Wifi");
        }
        // } else if (state == LoginState.UNLOGIN) {
        //   print("LoginState=$state");
        // }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  _MainIcon(),
                  Text(
                    "HomeBody",
                    style: TextStyle(
                        fontSize: AppTheme.header_font_size,
                        color: AppTheme.font_color,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                _kakaoLogin()
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _facebookLogin()
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => WifiSettingPage())
                    );
                  },
                  child: Text('Temp button next'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _MainIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 500.0,
      height: 80.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Image.asset(
          'images/lover.png',
        ),
      ),
    );
  }
}

class _kakaoLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 300.0,
      height: 60.0,
      child: FlatButton(
          // key: const Key('loginForm_createAccount_flatButton'),
          // // color: Theme.of(context).accentColor,
          disabledColor: Theme.of(context).accentColor,
          splashColor: Colors.grey,
          onPressed: () => context.read<loginCubit>().kakaoLogin(),
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Image.asset(
              'images/kakao_account_login_btn_medium_wide.png',
            ),
          )),
    );
  }
}


class _facebookLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 300.0,
      height: 60.0,
      child: FlatButton(
          // key: const Key('loginForm_createAccount_flatButton'),
          // color: Theme.of(context).accentColor,
          disabledColor: Theme.of(context).accentColor,
          splashColor: Colors.grey,
          onPressed: () => context.read<loginCubit>().facebookLogin(),
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Image.asset(
              'images/facebook_account_login.png',
            ),
          )),
    );
  }
}

