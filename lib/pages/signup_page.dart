import 'package:fb_auth_provider/models/custom_error.dart';
import 'package:fb_auth_provider/pages/signin_page.dart';

import 'package:fb_auth_provider/providers/signup/signup_provider.dart';
import 'package:fb_auth_provider/providers/signup/signup_state.dart';
import 'package:fb_auth_provider/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  static const String routeName = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password, _name;
  final _passwordController = TextEditingController();

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();
    print('name: $_name, email: $_email, password: $_password');
    try {
      await context
          .read<SignupProvider>()
          .signup(name: _name!, email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupState = context.read<SignupProvider>().state;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: [
                  Image.asset(
                    'assets/images/flutter_logo.png',
                    height: 250,
                    width: 250,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.account_box_rounded),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name required';
                      }

                      if (value.trim().length < 2) {
                        return 'Name must be atleast 2 characters long';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email required';
                      }
                      if (!isEmail(value.trim())) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a password.';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (String? value) {
                      if (_passwordController.text != value) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed:
                        signupState.signupStatus == SignupStatus.submitting
                            ? null
                            : _submit,
                    child: Text(
                        signupState.signupStatus == SignupStatus.submitting
                            ? 'Loading'
                            : 'Sign Up'),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () =>
                        signupState.signupStatus == SignupStatus.submitting
                            ? null
                            : Navigator.pop(context),
                    child: Text('Already a member? Sign In!'),
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                          fontSize: 20.0, decoration: TextDecoration.underline),
                    ),
                  )
                ].reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
