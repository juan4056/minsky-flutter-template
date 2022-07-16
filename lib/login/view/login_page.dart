import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/dashboard/dashboard.dart';
import 'package:template_app/login/login.dart';

import '../cubit/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FocusNode usernameFocus;
  late FocusNode passwordFocus;
  late FocusNode loginBtnFocus;
  late TextEditingController userController;
  late TextEditingController passController;

  @override
  void initState() {
    super.initState();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();
    loginBtnFocus = FocusNode();
    userController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    loginBtnFocus.dispose();
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.error) {
            buildErrorLayout();
          } else if (state.status == LoginStatus.success) {
            clearTextData();
            Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(
                  title: 'Dashboard',
                  username: state.username,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == LoginStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextFormField(
              focusNode: usernameFocus,
              controller: userController,
              decoration: const InputDecoration(
                hintText: 'Username',
                prefixIcon: Icon(Icons.person, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              focusNode: passwordFocus,
              controller: passController,
              decoration: const InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                context
                    .read<LoginCubit>()
                    .login(userController.text, passController.text);
              },
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );

  ScaffoldFeatureController buildErrorLayout() =>
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter username/password!'),
        ),
      );

  clearTextData() {
    userController.clear();
    passController.clear();
  }
}
