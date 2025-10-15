import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_model.dart';

class NotesCardTile extends StatelessWidget{

  final NotesModel noteTitleText;
  final int noteColor;


  NotesCardTile(this.noteTitleText, this.noteColor);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity ,
      child: Card(
        margin: EdgeInsets.all(10),
        color: Color(noteColor),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(noteTitleText.title,style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w500),),
        ),

      ),
    );
  }

}