import 'package:episode_box/src/data/data_provider.dart';
import 'package:episode_box/src/helpers/form_helper.dart';
import 'package:episode_box/src/pages/episode_page/dto/episode_dto.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class AddNewView extends StatefulWidget {
  const AddNewView({super.key});

  static const routeName = '/add-new';

  @override
  State<StatefulWidget> createState() => _AddNewView();
}

class _AddNewView extends State<AddNewView> {
  final _formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final seasonController = TextEditingController();
  final episodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    seasonController.text = '1';
    episodeController.text = '1';
  }

  @override
  void dispose() {
    itemNameController.dispose();
    seasonController.dispose();
    episodeController.dispose();
    super.dispose();
  }

  Future _handleSave() async {
    context.loaderOverlay.show();

    var newItem = EpisodeDto(
        mongo.ObjectId(),
        itemNameController.text,
        int.tryParse(seasonController.text),
        int.tryParse(episodeController.text) ?? 1);

    await DataProvider.addItem(newItem);

    if (!context.mounted) return;

    context.loaderOverlay.hide();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Item saved successfully."),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
    ));

    Navigator.pop(context, true);
  }

  Future _onSavePressed() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      var isSeasonEmpty = int.tryParse(seasonController.text) == null;
      if (isSeasonEmpty) {
        _showEmptySeasonDialog(context);
      } else {
        await _handleSave();
      }
    }
  }

  _showEmptySeasonDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        _handleSave();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Season is empty"),
      content: const Text("Are you sure to create an item without season?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('New Item', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  validator: FormHelper.notEmptyTextValidator(
                      'Please enter item name.'),
                  controller: itemNameController,
                  autocorrect: false,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Season'),
                  validator: FormHelper.numericTextValidator(),
                  controller: seasonController,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Episode'),
                  validator: FormHelper.numericTextValidator(),
                  controller: episodeController,
                  keyboardType: TextInputType.number,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                      onPressed: _onSavePressed, child: const Text('Save')),
                )
              ],
            ),
          )),
    );
  }
}
