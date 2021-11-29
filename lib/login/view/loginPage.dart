import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/login/cubit/loginCubit.dart';
import 'package:homg_long/utils/ui.dart';
import 'package:logging/logging.dart' as logging;

enum LoginState { LOGIN, UNLOGIN }

class LoginPage extends StatelessWidget {
  LogUtil logUtil = LogUtil();
  final log = logging.Logger('LoginPage');

  LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    log.info("build login page");
    // log.logger.d("build login page");
    Firebase.initializeApp();
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              //TODO: handle firebase init failed.
              child: Text("firebase load fail"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: AppTheme.LoginBackgroundColor,
              body: Center(
                child: BlocProvider(
                  create: (_) => LoginCubit(),
                  child: LoginForm(),
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}

class LoginForm extends StatelessWidget {
  LogUtil log = LogUtil();
  final _log = logging.Logger('LoginForm');

  LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _log.info("build login form");
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state == LoginState.LOGIN) {
          _log.info("LoginState=$state");
          Navigator.pushReplacementNamed(context, "/GPS");
        } else if (state == LoginState.UNLOGIN) {
          _log.info("LoginState=$state");
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // _MainIcon(),
                  headerTextBox("Welcome"),
                  headerTextBox("HomeBody"),
                  SizedBox(
                    height: 50.0,
                  ),
                  _facebookLogin(),
                  _googleLogin()
                ]),
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
          'images/house.png',
        ),
      ),
    );
  }
}

// class _kakaoLogin extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Container(
//       width: 270.0,
//       height: 60.0,
//       child: FlatButton(
//           // key: const Key('loginForm_createAccount_flatButton'),
//           // // color: Theme.of(context).accentColor,
//           disabledColor: Theme.of(context).accentColor,
//           splashColor: Colors.grey,
//           onPressed: () => context.read<LoginCubit>().kakaoLogin(),
//           child: Padding(
//             padding: const EdgeInsets.only(left: 0),
//             child: Image.asset(
//               'images/kakao_account_login_btn_medium_wide.png',
//             ),
//           )),
//     );
//   }
// }

class _facebookLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270.0,
      height: 60.0,
      child: TextButton(
          onPressed: () => context.read<LoginCubit>().facebookLogin(),
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Image.asset(
              'images/facebook_login_ori.png',
            ),
          )),
    );
  }
}

class _googleLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270.0,
      height: 60.0,
      child: TextButton(
          onPressed: () => context.read<LoginCubit>().googleLogin(),
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Image.asset(
              'images/google_login.png',
            ),
          )),
    );
  }
}
