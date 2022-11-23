import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_crud_sqflite/database/database_catatan.dart';
import 'package:simple_crud_sqflite/model/catatan.dart';
import 'package:simple_crud_sqflite/ui/tambah_edit_catatan_page.dart';

class CatatanDetailPage extends StatefulWidget {
  final int noteId;

  const CatatanDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  CatatanDetailPageState createState() => CatatanDetailPageState();
}

class CatatanDetailPageState extends State<CatatanDetailPage> {
  late Catatan note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    note = await DatabaseCatatan.instance.readCatatan(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade200,
          title: const Text(
            'Detail Catatan',
            style: TextStyle(color: Colors.black),
          ),
          leading: backButton(),
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.description,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget backButton() => IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () async {
        Navigator.pop(context);
      });

  Widget editButton() => IconButton(
      icon: const Icon(
        Icons.edit_outlined,
        color: Colors.black,
      ),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TambahEditCatatanPage(
            note: note,
            title: 'Edit',
          ),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.black,
        ),
        onPressed: () async {
          await DatabaseCatatan.instance.delete(widget.noteId);

          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        },
      );
}
