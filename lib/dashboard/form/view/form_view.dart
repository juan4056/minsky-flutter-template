import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:template_app/dashboard/form/form.dart';
import 'package:template_app/form/date_field.dart';
import 'package:template_app/form/multiselect_field.dart';
import 'package:template_app/form/number_field.dart';
import 'package:template_app/form/select_field.dart';
import 'package:template_app/form/select_number.dart';
import 'package:template_app/form/text_field.dart';
import 'package:template_app/repositories/data_repository.dart';

class ProductFormView extends StatelessWidget {
  const ProductFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductFormCubit(
        dataRepository: context.read<DataRepository>(),
      ),
      child: const _NewProductForm(),
    );
  }
}

class _NewProductForm extends StatefulWidget {
  const _NewProductForm({Key? key}) : super(key: key);

  @override
  _NewProductFormState createState() => _NewProductFormState();
}

class _NewProductFormState extends State<_NewProductForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {
        final cubit = context.read<ProductFormCubit>();
        return SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInput(
                  label: 'Nombre del Producto',
                  initialValue: state.name,
                  onChange: cubit.nameChanged,
                ),
                NumberInput(
                  label: 'Precio del Producto',
                  initialValue: state.price,
                  onChange: cubit.priceChanged,
                ),
                DateInput(
                  label: 'Fecha de Compra',
                  initialValue: state.purchaseDate,
                  onChange: cubit.purchaseDateChanged,
                ),
                SelectFormInput(
                  items: const {
                    'market': 'Mercado',
                    'super_market': 'Supermercado',
                  },
                  label: 'Lugar de Compra',
                  initialValue: state.market,
                  onChange: cubit.marketChanged,
                ),
                SelectNumberInput(
                  start: 1,
                  end: 5,
                  label: 'Cantidad',
                  initialValue: state.quantity,
                  onChange: cubit.quantityChanged,
                ),
                MultiSelectInput(
                  options: const {
                    'no_observations': 'Sin observaciones',
                    'not_at_time': 'No llego a tiempo',
                    'poor_condition': 'En mal estado',
                  },
                  nullOptions: const ['no_observations'],
                  label: 'Observaciones',
                  initialValue: state.observations,
                  onChange: cubit.observationsChanged,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cubit.addProduct();
                        Navigator.of(context).pop();
                      }
                    },
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
          ),
        );
      },
    );
  }
}
