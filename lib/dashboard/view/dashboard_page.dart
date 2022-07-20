import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/authentication/authentication.dart';
import 'package:template_app/dashboard/cubit/dashboard_cubit.dart';
import 'package:template_app/models/user.dart';
import 'package:template_app/repositories/auth_repository.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title, required this.username})
      : super(key: key);

  final String title;
  final String username;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
            title: Text(widget.title),
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
                title: Text(product.name),
                subtitle: Text('${product.length}'),
              ),
            ]
          ],
        ),
      );

  Widget addWidget(BuildContext context) {
    return const AlertDialog(
      title: Text('Add Product'),
      content: _NewProductForm(),
    );
  }
}

class _NewProductForm extends StatefulWidget {
  const _NewProductForm({Key? key}) : super(key: key);

  @override
  _NewProductFormState createState() => _NewProductFormState();
}

class _NewProductFormState extends State<_NewProductForm> {
  final nameController = TextEditingController();
  final lengthController = TextEditingController();
  bool isActive = false;

  @override
  void initState() {
    nameController.addListener(() {
      setState(() => isActive =
          nameController.text.isNotEmpty && lengthController.text.isNotEmpty);
    });
    lengthController.addListener(() {
      setState(() => isActive =
          nameController.text.isNotEmpty && lengthController.text.isNotEmpty);
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: lengthController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Length',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: (isActive)
                  ? () {
                      context.read<DashboardCubit>().addProduct(
                          nameController.text,
                          int.parse(lengthController.text));
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
