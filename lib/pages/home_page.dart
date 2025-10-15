import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart' show MasonryGridView, SliverSimpleGridDelegateWithFixedCrossAxisCount;
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


  final TextEditingController _searchController = TextEditingController();
  bool _isSearch = false;
  String _searchQuery = "";
  List<NotesModel> _filterNotes=[];


  void _startSearch(){

    setState(() {
      _isSearch=true;
    });
  }

  void _stopSearch(){
    setState(() {
      _isSearch = false;
      _searchController.clear();
      _searchQuery = '';
      _filterNotes = [];
    });
  }


  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


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
      appBar: animatedAppBar(_isSearch, _searchController, _onSearchChanged, _stopSearch, _startSearch),
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
          final allNotes = box.values.toList().cast<NotesModel>();

// Filter notes by search text
          final filteredNotes = _searchQuery.isEmpty
              ? allNotes
              : allNotes.where((note) {
            final title = note.title.toLowerCase();
            final desc = note.description.toLowerCase();
            return title.contains(_searchQuery) || desc.contains(_searchQuery);
          }).toList();

          if (filteredNotes.isEmpty) {
            return Center(
              child: Text(
                _searchQuery.isEmpty
                    ? "Create your first note!"
                    : "No matching notes found.",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return getMainListView(context, filteredNotes, box);

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

MasonryGridView getMainListView(
  BuildContext context,
  List<NotesModel> notesList,
  Box<NotesModel> box,
) {
  return MasonryGridView.builder(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 2 columns
    ),
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    itemCount: notesList.length,
    itemBuilder: (context, index) {
      final note = notesList[index];
      return Dismissible(
        key: Key(note.title + index.toString()),
        direction: DismissDirection.endToStart,
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
                icon: Icon(Icons.delete_forever_outlined, color: Colors.white),
                content: "Are you sure you want to delete?",
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
          box.deleteAt(index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note deleted')),
          );
        },
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNotePage(noteIndex: index, notes: note),
              ),
            );
          },
          child: NotesCardTile(note,note.Color),
        ),
      );
    },
  );


}

//getMainListView
ListView listView(
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
              action: SnackBarAction(label: 'Undo', onPressed: ()=>box.add(note)),
              duration: Duration(seconds: 2),
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
          child: NotesCardTile(note,note.Color),
        ),
      );
    },
  );
}
