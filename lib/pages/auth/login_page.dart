import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firezup/pages/auth/register_page.dart';
import 'package:firezup/utils/validation_utils.dart';
import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/services/auth_service.dart';
import 'package:firezup/widgets/custom_input.dart';
import 'package:firezup/services/navigation_service.dart';
import 'package:firezup/services/snackbar_service.dart';
import 'package:firezup/pages/home_page.dart';
import 'package:firezup/widgets/scaffold_loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = AuthService();

  final formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? const ScaffoldLoading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "FireZup",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Login to your account now",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //   Image.asset("assets/login.png"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: customInput.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        // check tha validation
                        validator: (val) {
                          return ValidationUtils().isEmail(val).getMessage();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: customInput.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        validator: (val) {
                          return ValidationUtils()
                              .isStrongPassword(val)
                              .getMessage();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4))),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                        text: "Don't have an account?",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: " Register here",
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  NavigationService(context)
                                      .replace(const RegisterPage());
                                }),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() => loading = true);

    Optional<AppUser> appUserOptional =
        await authService.login(email, password);

    setState(() => loading = false);

    if (!appUserOptional.exists()) {
      SnackBarService(context).error("Email or password is incorrect");
      return;
    }
    NavigationService(context).replace(const HomePage());
  }
}
