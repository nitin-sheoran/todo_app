import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/service/database_method.dart';
import 'package:todo_app/service/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TaskProvider taskProvider;


  @override
  void initState() {
    super.initState();
    taskProvider = Provider.of<TaskProvider>(context,listen:false);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        titleSpacing: -6,
        backgroundColor: Colors.white,
        title: const Text('Add Task'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider,child) {
          return Container(
            margin: const EdgeInsets.only(
                left: 16, right: 16, top: 10, bottom: 40),
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
                      controller: provider.titleController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Title'),
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
                      controller: provider.descriptionController,
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
                      controller: provider.dateController,
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
                                provider.dateController.text =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
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
                      controller: provider.timeController,
                      readOnly: true,
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
                                final dt = DateTime(
                                    now.year, now.month, now.day,
                                    pickedTime.hour, pickedTime.minute);
                                final format = DateFormat(
                                    'hh:mm a');
                                provider.timeController.text = format.format(dt);
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
                        borderRadius:
                        BorderRadius.circular(10),
                        border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: DropdownButtonFormField<String>(
                        value: provider.priority,
                        onChanged: (newValue) {
                          setState(() {
                            provider.priority = newValue!;
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
                                  fontSize: 16
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
                    width: width,
                    child: Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.white,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: const WidgetStatePropertyAll(0),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          String id = randomAlphaNumeric(10);
                          DateTime creationDate = DateTime.now();
                          Map<String, dynamic> employeeInfoMap = {
                            "Title": provider.titleController.text,
                            "id": id,
                            "Description": provider.descriptionController.text,
                            "Date": provider.dateController.text,
                            "Time": provider.timeController.text,
                            "Priority": provider.priority,
                            'CreationDate': creationDate,
                          };
                          await DatabaseMethod()
                              .addTaskDetails(employeeInfoMap, id)
                              .then((value) async {
                            Fluttertoast.showToast(
                              msg: "Task Details Successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                            DateTime taskDate = DateFormat('dd-MM-yyyy')
                                .parse(provider.dateController.text);
                            TimeOfDay taskTime = TimeOfDay(
                              hour: int.parse(DateFormat('HH').format(
                                  DateFormat('hh:mm a')
                                      .parse(provider.timeController.text))),
                              minute: int.parse(DateFormat('mm').format(
                                  DateFormat('hh:mm a')
                                      .parse(provider.timeController.text))),
                            );

                            DateTime taskDateTime = DateTime(
                                taskDate.year,
                                taskDate.month,
                                taskDate.day,
                                taskTime.hour,
                                taskTime.minute);
                            DateTime notificationTime =
                            taskDateTime.subtract(const Duration(minutes: 10));

                            await LocalNotificationService.scheduleNotification(
                              id: 0,
                              title: "Task Complete",
                              body:
                              "Your task ${provider.titleController.text}",
                              scheduledDate: notificationTime,
                              payload: 'payload',
                            );
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Create Task',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
