import 'package:flutter/material.dart';
import 'package:simple_crud_sqflite/database/database_catatan.dart';
import 'package:simple_crud_sqflite/model/catatan.dart';
import '../widget/catatan_form_widget.dart';

class TambahEditCatatanPage extends StatefulWidget {
  final Catatan? note;
  final String title;

  const TambahEditCatatanPage({
    Key? key,
    required this.title,
    this.note,
  }) : super(key: key);
  @override
  TambahEditCatatanPageState createState() => TambahEditCatatanPageState();
}

class TambahEditCatatanPageState extends State<TambahEditCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade200,
          title: Text(
            '${widget.title} Catatan',
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: backButton(),
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: CatatanFormWidget(
            isImportant: isImportant,
            number: number,
            title: title,
            description: description,
            onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: const Text('Save'),
      ),
    );
  }

  Widget backButton() => IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () async {
        Navigator.pop(context);
      });

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await DatabaseCatatan.instance.update(note);
  }

  Future addNote() async {
    final note = Catatan(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await DatabaseCatatan.instance.create(note);
  }
}
