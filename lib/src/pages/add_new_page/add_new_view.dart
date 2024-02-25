import 'package:flutter/material.dart';

class AddNewView extends StatelessWidget {
  const AddNewView({super.key});

  static const routeName = '/add-new';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('New Item', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
