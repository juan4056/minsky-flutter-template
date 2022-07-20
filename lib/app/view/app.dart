import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:template_app/authentication/authentication.dart';
import 'package:template_app/dashboard/dashboard.dart';
import 'package:template_app/l10n/l10n.dart';
import 'package:template_app/login/login.dart';
import 'package:template_app/repositories/auth_repository.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthenticationRepository(
        FirebaseAuth.instance,
        FirebaseFirestore.instance,
      ),
      child: BlocProvider(
        create: (context) => AuthenticationBloc(
            authenticationRepository: context.read<AuthenticationRepository>())
          ..add(AppStarted()),
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView({Key? key}) : super(key: key);

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Uninitialized) {
          return MyMaterialApp(
              context, const Center(child: CircularProgressIndicator()));
        }
        if (state is Unauthenticated) {
          return BlocProvider(
            create: ((context) => LoginCubit(
                authRepository: context.read<AuthenticationRepository>())),
            child: MyMaterialApp(context, const LoginPage(title: 'Login')),
          );
        }
        if (state is Authenticated) {
          return BlocProvider(
            create: ((context) => DashboardCubit(
                authRepository: context.read<AuthenticationRepository>())),
            child: MyMaterialApp(
              context,
              Dashboard(
                title: 'Login',
                username: state.displayName,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

Widget MyMaterialApp(BuildContext context, Widget widget) {
  return MaterialApp(
    theme: ThemeData(
      colorSchemeSeed: Colors.blue,
      useMaterial3: true,
    ),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: widget,
  );
}
