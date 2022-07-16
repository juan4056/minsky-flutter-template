import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:template_app/dashboard/dashboard.dart';
import 'package:template_app/l10n/l10n.dart';
import 'package:template_app/login/login.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => DashboardCubit(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LoginPage(title: 'Login'),
      ),
    );
  }
}
