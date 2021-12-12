import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/login/cubit/loginController.dart';
import 'package:homg_long/utils/ui.dart';
import 'package:logging/logging.dart' as logging;

class LoginPage extends StatelessWidget {
  LogUtil logUtil = LogUtil();
  final log = logging.Logger('LoginPage');

  LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    log.info("build login page : ${Get.size.width} : ${Get.size.height}");
    return Container(
        color: AppTheme.LoginBackgroundColor,
        padding: EdgeInsets.all(10),
        child: LoginForm());
  }
}

class LoginForm extends StatelessWidget {
  LogUtil log = LogUtil();
  final _log = logging.Logger('LoginForm');

  LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _log.info("build login form : ${Get.size.width} : ${Get.size.height}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // _MainIcon(),
        headerTextBox("Welcome"),
        headerTextBox("HomeBody"),
        SizedBox(
          height: 50.0,
        ),
        _facebookLogin(),
        _googleLogin()
      ],
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
          onPressed: () => Get.find<LoginController>().facebookLogin(),
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
          onPressed: () => Get.find<LoginController>().googleLogin(),
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Image.asset(
              'images/google_login.png',
            ),
          )),
    );
  }
}
