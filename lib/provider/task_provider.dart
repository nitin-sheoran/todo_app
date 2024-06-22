import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TaskProvider extends ChangeNotifier{
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  late TextEditingController editTitleController;
  late TextEditingController editDescriptionController;
  late TextEditingController editDateController;
  late TextEditingController editTimeController;
  String editPriority = '';

  String priority = "Low";
  Stream<QuerySnapshot>? taskStream;
  bool hasTasks = false;
  bool isSearching = false;
  String searchQuery = '';
  String filterOption = 'default';


}