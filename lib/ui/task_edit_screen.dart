import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/service/database_method.dart';
import 'package:todo_app/service/notification_service.dart';

class TaskEditScreen extends StatefulWidget {
  const TaskEditScreen(
      {super.key,
      required this.taskId,
      required this.title,
      required this.description,
      required this.date,
      required this.time,
      required this.priority});

  final String taskId;
  final String title;
  final String description;
  final String date;
  final String time;
  final String priority;

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  late TaskProvider taskProvider;

  @override
  void initState() {
    super.initState();
    taskProvider = Provider.of<TaskProvider>(context,listen:false);
    taskProvider.editTitleController = TextEditingController(text: widget.title);
    taskProvider.editDescriptionController = TextEditingController(text: widget.description);
    taskProvider.editDateController = TextEditingController(text: widget.date);
    taskProvider.editTimeController = TextEditingController(text: widget.time);
    taskProvider.editPriority = widget.priority;
    LocalNotificationService.init();
  }

  @override
  void dispose() {
    taskProvider.editTitleController.dispose();
    taskProvider.editDescriptionController.dispose();
    taskProvider.editDateController.dispose();
    taskProvider.editTimeController.dispose();
    super.dispose();
  }

  Future<void> updateTaskDetails() async {
    Map<String, dynamic> editInfo = {
      'Title': taskProvider.editTitleController.text,
      'Description': taskProvider.editDescriptionController.text,
      'Date': taskProvider.editDateController.text,
      'Time': taskProvider.editTimeController.text,
      'Priority': taskProvider.editPriority,
    };

    await DatabaseMethod()
        .updateTaskDetails(widget.taskId, editInfo)
        .then((value) async {
      String dateTimeString = '${taskProvider.editDateController.text} ${taskProvider.editTimeController.text}';
      DateTime taskDateTime =
          DateFormat('dd-MM-yyyy hh:mm a').parse(dateTimeString);

      DateTime notificationDateTime =
          taskDateTime.subtract(const Duration(minutes: 10));
      await LocalNotificationService.scheduleNotification(
        id: widget.taskId.hashCode,
        title: 'Task Complete',
        body: 'Your task ${taskProvider.editTitleController.text}',
        scheduledDate: notificationDateTime,
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: -4,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('Task Edit'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: TextField(
                  controller: taskProvider.editTitleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: TextField(
                  controller: taskProvider.editDescriptionController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                  ),
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Date',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: TextField(
                  controller: taskProvider.editDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Pick Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1945),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            taskProvider.editDateController.text =
                                "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: TextField(
                  controller: taskProvider.editTimeController,
                  readOnly: true, // Make the TextField read-only
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Pick Time',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            final now = DateTime.now();
                            final dt = DateTime(now.year, now.month, now.day,
                                pickedTime.hour, pickedTime.minute);
                            final format = DateFormat(
                                'hh:mm a'); // 12-hour format with AM/PM
                            taskProvider.editTimeController.text = format.format(dt);
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Priority',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                height: height * 0.07,
                decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButtonFormField<String>(
                    value: taskProvider.editPriority,
                    onChanged: (newValue) {
                      setState(() {
                        taskProvider.editPriority = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Low',
                      border: InputBorder.none,
                    ),
                    dropdownColor: Colors.white,
                    items: <String>[
                      'Low',
                      'Medium',
                      'High',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    style: const TextStyle(
                      color: Color(0xffFFFFFF),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: 35,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.06),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 6,
                  shadowColor: Colors.white,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: const WidgetStatePropertyAll(0),
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ))),
                    onPressed: updateTaskDetails,
                    child: const Text(
                      'Update Task',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
