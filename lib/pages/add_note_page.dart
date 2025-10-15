import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/utils/icon_btn.dart';
import 'package:notes_app/utils/my_alert_dialog.dart';
import 'package:notes_app/utils/my_text_field.dart';
import 'package:notes_app/utils/my_theme.dart';

class AddNotePage extends StatelessWidget {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final int? noteIndex;
  final NotesModel? notes;

  AddNotePage({this.noteIndex, this.notes, super.key});

  @override
  Widget build(BuildContext context) {
    //Pre-fill the text in controller if NoteModel have Data
    if (notes != null) {
      titleController.text = notes!.title;
      descriptionController.text = notes!.description;
    }

    return Scaffold(
      backgroundColor: mainColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar
              addNoteAppBar(
                noteIndex,
                context,
                titleController,
                descriptionController,
              ),
              const SizedBox(height: 40),

              // Title TextField
              MyTextField(
                hint: "Title",
                textSize: 48,
                controller: titleController,
              ),
              const SizedBox(height: 20),

              // Description TextField (multi-line)
              MyTextField(
                hint: "Type Something...",
                textSize: 23,
                controller: descriptionController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Row addNoteAppBar(
  int? noteIndex,
  BuildContext context,
  TextEditingController titleController,
  TextEditingController desController,
) {
  final isEdit = noteIndex != null;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconBtn(
        icon: Icon(Icons.arrow_back),
        iconBtnFun: () => Navigator.of(context).pop(),
      ),
      Row(
        children: [
          IconBtn(
            icon: Icon(Icons.remove_red_eye_outlined),
            iconBtnFun: () => {},
          ),
          SizedBox(width: 21),
          IconBtn(
            icon: isEdit
                ? Icon(Icons.update_outlined)
                : Icon(Icons.save_outlined),
            iconBtnFun: () {
              final isEdit = noteIndex != null;
              if (isEdit) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return MyAlertDialog(
                      icon: Icon(Icons.info_outline,color: Colors.white,),
                      content: 'Save Changes',
                      deleteNoteBtnFun: () {
                        saveOrUpdateNoteFun(
                          context,
                          titleController,
                          desController,
                          noteIndex,
                        );
                        Navigator.of(context).pop();
                      },
                      buttonOneText: "Discard",
                      buttonTwoText: "Save",
                      buttonOneColor: Colors.red,
                      buttonTwoColor: greenColor,
                    );
                  },
                );
              }else{
                saveOrUpdateNoteFun(context, titleController, desController, noteIndex);
              }
            },
          ),
        ],
      ),
    ],
  );
}

void saveOrUpdateNoteFun(
  BuildContext context,
  TextEditingController titleController,
  TextEditingController desController,
  int? noteIndex,
) {
  final isEdit = noteIndex != null;

  if (titleController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Note is Empty"), duration: Duration(seconds: 1)),
    );
  } else {
    final box = Hive.box<NotesModel>('notesBox');
    final note = NotesModel(
      title: titleController.text,
      description: desController.text,
      Color: randomColor(),

    );

    isEdit ? box.putAt(noteIndex, note) : box.add(note);
    titleController.clear();
    desController.clear();
    Navigator.of(context).pop();
  }
}
