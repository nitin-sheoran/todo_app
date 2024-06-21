import 'package:flutter/cupertino.dart';

class TaskProvider extends ChangeNotifier{
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  String priority = "Low";


}