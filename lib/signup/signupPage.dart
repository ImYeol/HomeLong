import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:homg_long/authentication/authentication.dart';
import 'package:homg_long/const/AppTheme.dart';

import 'bloc/signup_cubit.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
          child: BlocProvider(
        create: (_) => SignUpCubit(context.read<AuthenticationRepository>()),
        child: SignUpForm(),
      )),
    );
  }
}

class SignUpForm extends StatelessWidget {
  // final TextEditingController idTextInputController = TextEditingController();
  // final TextEditingController pwTextInputController = TextEditingController();

  SignUpForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
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
              "SIGN UP",
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
            _ConfirmedPassword(),
            SizedBox(
              height: 30.0,
            ),
            _SignUpButton()
          ],
        ));
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
          width: 300.0,
          height: 50.0,
          child: Expanded(
            child: TextField(
                key: const Key('signUpForm_emailInput_textField'),
                onChanged: (email) =>
                    context.read<SignUpCubit>().emailChanged(email),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Container(
          width: 300.0,
          height: 50.0,
          child: Expanded(
            child: TextField(
                key: const Key('signUpForm_passwordInput_textField'),
                onChanged: (password) =>
                    context.read<SignUpCubit>().passwordChanged(password),
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

class _ConfirmedPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return Container(
          width: 300.0,
          height: 50.0,
          child: Expanded(
            child: TextField(
                key: const Key('signUpForm_confirmedPasswordInput_textField'),
                onChanged: (password) => context
                    .read<SignUpCubit>()
                    .confirmedPasswordChanged(password),
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

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          width: 300.0,
          height: 60.0,
          child: state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : FlatButton(
                  key: const Key('signUpForm_createAccount_flatButton'),
                  color: Colors.brown[400],
                  disabledColor: Theme.of(context).disabledColor,
                  splashColor: Colors.grey,
                  onPressed: state.status.isValidated
                      ? () => context.read<SignUpCubit>().signUpFormSubmitted()
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
                        color: Colors.white,
                      ),
                    ),
                  )),
        );
      },
    );
  }
}
