import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firezup/pages/home_page.dart';
import 'package:firezup/services/auth_service.dart';
import 'package:firezup/widgets/scaffold_loading.dart';
import 'package:firezup/widgets/custom_input.dart';
import 'package:firezup/data/app_user.dart';
import 'package:firezup/data/optional.dart';
import 'package:firezup/services/navigation_service.dart';
import 'package:firezup/services/snackbar_service.dart';
import 'package:firezup/utils/validation_utils.dart';
import 'package:firezup/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthService authService = AuthService();

  final formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = "";
  String username = "";
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
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
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
                            "Create your account to start chatting",
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
                              labelText: "Username",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onChanged: (val) {
                              setState(() => username = val);
                            },
                            // check tha validation
                            validator: (val) {
                              return ValidationUtils()
                                  .hasSpecialCharacters(val, "username")
                                  .getMessage();
                            },
                          ),
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
                              return ValidationUtils()
                                  .isEmail(val)
                                  .getMessage();
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
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4))),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                register();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text.rich(TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " Login now",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      NavigationService(context)
                                          .replace(const LoginPage());
                                    }),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() => loading = true);

    Optional<AppUser> appUserOptional =
        await authService.register(username, email, password);

    setState(() => loading = false);

    if (!appUserOptional.exists()) {
      SnackBarService(context).error("Something went wrong");
      return;
    }

    if (mounted) {
      NavigationService(context).replace(const HomePage());
    }
  }
}
