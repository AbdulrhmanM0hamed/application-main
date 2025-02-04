import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme.dart';
import '../../widgets/snackbar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 250.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                        child: TextField(
                          focusNode: focusNodeEmail,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontFamily: 'WorkSansSemiBold',
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(FontAwesomeIcons.envelope, color: Colors.black, size: 22.0),
                            hintText: 'Email Address',
                            hintStyle: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                          ),
                          onSubmitted: (_) => focusNodePassword.requestFocus(),
                        ),
                      ),
                      const Divider(height: 1.0, color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                        child: TextField(
                          focusNode: focusNodePassword,
                          controller: loginPasswordController,
                          obscureText: _obscureTextPassword,
                          style: const TextStyle(
                            fontFamily: 'WorkSansSemiBold',
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: const Icon(FontAwesomeIcons.lock, size: 22.0, color: Colors.black),
                            hintText: 'Password',
                            hintStyle: const TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _toggleSignInButton(),
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 230.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomTheme.loginGradientStart,
                      offset: const Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CustomTheme.loginGradientEnd,
                      offset: const Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: const LinearGradient(
                    colors: [CustomTheme.loginGradientEnd, CustomTheme.loginGradientStart],
                    begin: FractionalOffset(0.2, 0.2),
                    end: FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: 'WorkSansBold',
                      ),
                    ),
                  ),
                  onPressed: _toggleSignInButton,
                ),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'WorkSansMedium',
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Divider(
                  color: Colors.white10,
                  thickness: 1.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Or',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: 'WorkSansMedium',
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  color: Colors.white,
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: GestureDetector(
                  onTap: () => CustomSnackBar(context, const Text('Facebook button pressed')),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.facebookF,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => CustomSnackBar(context, const Text('Google button pressed')),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.google,
                    color: Color(0xFF0084ff),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleSignInButton() {
    CustomSnackBar(context, const Text('Login button pressed'));
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}