import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:simple_crud_sqflite/database/database_catatan.dart';
import 'package:simple_crud_sqflite/ui/detail_catatan_page.dart';
import 'package:simple_crud_sqflite/ui/tambah_edit_catatan_page.dart';
import 'package:simple_crud_sqflite/widget/catatan_card_widget.dart';
import '../model/catatan.dart';

class CatatanPage extends StatefulWidget {
  const CatatanPage({super.key});

  @override
  CatatanPageState createState() => CatatanPageState();
}

class CatatanPageState extends State<CatatanPage> {
  late List<Catatan> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshCatatan();
  }

  @override
  void dispose() {
    DatabaseCatatan.instance.close();

    super.dispose();
  }

  Future refreshCatatan() async {
    setState(() => isLoading = true);

    notes = await DatabaseCatatan.instance.readAllCatatan();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green.shade200,
          title: const Text(
            'Catatan',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text(
                      'Tidak ada catatan',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildCatatan(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const TambahEditCatatanPage(
                        title: 'Tambah',
                      )),
            );

            refreshCatatan();
          },
        ),
      );

  Widget buildCatatan() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CatatanDetailPage(noteId: note.id!),
              ));

              refreshCatatan();
            },
            child: CatatanCardWidget(note: note, index: index),
          );
        },
      );
}
