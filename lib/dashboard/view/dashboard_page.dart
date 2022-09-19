import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/authentication/authentication.dart';
import 'package:template_app/dashboard/cubit/dashboard_cubit.dart';
import 'package:template_app/dashboard/form/form.dart';
import 'package:template_app/models/product.dart';
import 'package:template_app/repositories/auth_repository.dart';
import 'package:template_app/repositories/data_repository.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        authRepository: context.read<AuthenticationRepository>(),
        dataRepository: context.read<DataRepository>(),
      ),
      child: _DashboardView(
        username: username,
      ),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<DashboardCubit>().getProducts();
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  context.read<DashboardCubit>().logout().then((value) =>
                      context.read<AuthenticationBloc>().add(LoggedOut()));
                },
                icon: const Icon(Icons.logout),
                tooltip: 'Log Out',
              ),
            ],
          ),
          body: initialLayout(context, state.products),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 50.0),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(context: context, builder: addWidget);
            },
            tooltip: 'Increment Counter',
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget initialLayout(BuildContext context, List<Product> products) =>
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                "Hi ${widget.username}!",
              ),
            ),
            const SizedBox(height: 10),
            for (var product in products) ...[
              ListTile(
                title: Text(product.name ?? ''),
                subtitle: Text('${product.quantity}'),
              ),
            ]
          ],
        ),
      );

  Widget addWidget(BuildContext context) {
    return const AlertDialog(
      title: Text('Add Product'),
      content: ProductFormView(),
    );
  }
}
