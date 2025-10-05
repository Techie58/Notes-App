import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/pages/add_note_page.dart';
import 'package:notes_app/utils/my_alert_dialog.dart';
import 'package:notes_app/utils/my_theme.dart';
import 'package:notes_app/utils/notes_card_tile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void deleteNoteBtnFun(int index) {
    var box = Hive.box<NotesModel>("notesBox");

    box.deleteAt(index);
  }

  void addNoteBtnFun() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddNotePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Color(0xFF252525),
      floatingActionButton: getFaBtnFun(addNoteBtnFun),

      //if myNotes == Empty then show Picture
      body: ValueListenableBuilder(
        valueListenable: Hive.box<NotesModel>('notesBox').listenable(),
        builder: (context, Box<NotesModel> box, _) {
          if (box.isEmpty) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/homeBgImg.png'),
                  alignment: Alignment.center,
                ),
              ),
              child: Center(
                child: Text(
                  "Create your first note !",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          final notesList = box.values.toList();
          return getMainListView(context, notesList, box);
        },
      ),
    );
  }
}

FloatingActionButton getFaBtnFun(VoidCallback? addNoteBtnFun) {
  return FloatingActionButton(
    backgroundColor: Color(0xFF252525),
    foregroundColor: Colors.white,
    onPressed: addNoteBtnFun,
    child: Icon(Icons.add),
  );
}

ListView getMainListView(
  BuildContext context,
  List<NotesModel> notesList,
  Box<NotesModel> box,
) {
  return ListView.builder(
    itemCount: notesList.length,
    itemBuilder: (context, index) {
      final note = notesList[index];

      //Dismissible is used for Slide Delete
      return Dismissible(
        key: Key(note.title + index.toString()), // unique key for each note
        direction: DismissDirection.endToStart, // swipe from right to left
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        confirmDismiss: (direction) async {
          final result = await showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return MyAlertDialog(
                icon: Icon(Icons.delete_forever_outlined,color: Colors.white,),
                content: "Are you sure you want to delete? ",
                deleteNoteBtnFun: () => Navigator.of(context).pop(true),
                buttonOneText: 'Cancel',
                buttonTwoText: 'Delete',
                buttonOneColor: greenColor,
                buttonTwoColor: Colors.red,
              );
            },
          );

          return result ?? false;
        },
        onDismissed: (direction) {
          box.deleteAt(index); // ✅ deletes note from Hive
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Note deleted'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        //Updating Note
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNotePage(noteIndex: index,notes: note)),
            );
          },
          child: NotesCardTile(note),
        ),
      );
    },
  );
}
