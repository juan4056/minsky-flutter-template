import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/dashboard/cubit/dashboard_cubit.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key, required this.title, required this.username})
      : super(key: key);

  final String title;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return initialLayout(context);
        },
      ),
    );
  }

  Widget initialLayout(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Hi $username!",
              style: const TextStyle(fontSize: 50.00),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
}
