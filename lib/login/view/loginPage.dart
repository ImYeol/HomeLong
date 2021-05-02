import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/login/cubit/loginCubit.dart';
import 'package:homg_long/repository/model/InAppUser.dart';
import 'package:homg_long/repository/authRepository.dart';
import 'package:homg_long/wifi/wifiSettingPage.dart';

enum LoginState { LOGIN, UNLOGIN }

class LoginPage extends StatelessWidget {

  LogUtil logUtil = LogUtil();

  LoginPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    logUtil.logger.d("build login page");
    // log.logger.d("build login page");
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
            image: AssetImage("images/login_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: BlocProvider(
            create: (_) => loginCubit(context.read<AuthenticationRepository>()),
            child: LoginForm(),
          ),
        ),
      )
    );
  }
}

class LoginForm extends StatelessWidget {
  LogUtil log = LogUtil();
  LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log.logger.d("build login form");
    return BlocListener<loginCubit, LoginState>(
      listener: (context, state) {
        if (state == LoginState.LOGIN) {
          log.logger.d("LoginState=$state");
          Navigator.pushNamed(context, "/Wifi");
        } else if (state == LoginState.UNLOGIN) {
          log.logger.d("LoginState=$state");
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
              children: [_facebookLogin()],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    context.read<loginCubit>().fakeLogin();
                  },
                  child: Text('Temp button next'),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    context.read<loginCubit>().dbInfoLogOut();
                  },
                  child: Text('Log out'),
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
          'images/house.png',
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
