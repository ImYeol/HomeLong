import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:homg_long/authentication/authentication.dart';
import 'package:homg_long/const/AppTheme.dart';
import 'package:homg_long/signup/signupPage.dart';

import 'bloc/login_cubit.dart';

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
        create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
        child: LoginForm(),
      )),
    );
  }
}

class LoginForm extends StatelessWidget {
  // final TextEditingController idTextInputController = TextEditingController();
  // final TextEditingController pwTextInputController = TextEditingController();

  LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == FormzStatus.submissionFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Authentication Failure')),
              );
          }
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
            _EmailInput(),
            SizedBox(
              height: 10.0,
            ),
            _PasswordInput(),
            SizedBox(
              height: 30.0,
            ),
            //getGoogleSignInButton()
            _LoginButton(),
            SizedBox(
              height: 10.0,
            ),
            _SignUpButton()
          ],
        ));
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
          width: 300.0,
          height: 50.0,
          child: Expanded(
            child: TextField(
                key: const Key('loginForm_emailInput_textField'),
                onChanged: (email) =>
                    context.read<LoginCubit>().emailChanged(email),
                textAlign: TextAlign.start,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20, color: Colors.white),
                decoration: InputDecoration(
                    hintText: "EMAIL",
                    hintStyle: TextStyle(fontSize: 20, color: Colors.white30),
                    helperText: '',
                    errorText: state.email.invalid ? 'Invalid Email' : null,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)))),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Container(
          width: 300.0,
          height: 50.0,
          child: Expanded(
            child: TextField(
                key: const Key('loginForm_passwordInput_textField'),
                onChanged: (password) =>
                    context.read<LoginCubit>().passwordChanged(password),
                textAlign: TextAlign.start,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20, color: Colors.white),
                decoration: InputDecoration(
                    hintText: "PASSWORD",
                    hintStyle: TextStyle(fontSize: 20, color: Colors.white30),
                    helperText: '',
                    errorText:
                        state.password.invalid ? 'Invalid Password' : null,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)))),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Container(
                width: 300.0,
                height: 60.0,
                child: FlatButton(
                    key: const Key('loginForm_continue_flatButton'),
                    disabledColor: Theme.of(context).disabledColor,
                    splashColor: Colors.black,
                    color: Colors.brown[400],
                    onPressed: state.status.isValidated
                        ? () =>
                            context.read<LoginCubit>().logInWithCredentials()
                        : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    // highlightElevation: 0,
                    // borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'ENTER',
                        style: TextStyle(
                          fontSize: 30,
                          color: AppTheme.font_color,
                        ),
                      ),
                    )),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RaisedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      color: theme.accentColor,
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 300.0,
      height: 60.0,
      child: FlatButton(
          key: const Key('loginForm_createAccount_flatButton'),
          color: Theme.of(context).accentColor,
          disabledColor: Theme.of(context).accentColor,
          splashColor: Colors.grey,
          onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          // highlightElevation: 0,
          // borderSide: BorderSide(color: Colors.grey),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'SIGN UP',
              style: TextStyle(
                fontSize: 30,
                color: AppTheme.font_color,
              ),
            ),
          )),
    );
  }
}

Widget getGoogleSignInButton() {
  return FlatButton(
    color: Colors.white,
    splashColor: Colors.grey,
    onPressed: () {},
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    // highlightElevation: 0,
    // borderSide: BorderSide(color: Colors.grey),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("images/google_logo.jpg"), height: 35.0),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
