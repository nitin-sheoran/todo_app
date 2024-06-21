import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/service/database_method.dart';
import 'package:todo_app/ui/add_task_screen.dart';
import 'package:todo_app/ui/task_edit_screen.dart';
import 'package:todo_app/util/color_const.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Stream<QuerySnapshot>? taskStream;
  bool hasTasks = false;
  bool isSearching = false;
  String searchQuery = '';
  String filterOption = 'default';

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: AppColorConstant.white,
        backgroundColor: Colors.white,
        title: isSearching
            ? TextFormField(
                autofocus: true,
                cursorHeight: 22,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search Title...',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              )
            : const Text('Task', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    searchQuery = '';
                  }
                  isSearching = !isSearching;
                });
              },
            ),
          ),
          PopupMenuButton<String>(
            color: AppColorConstant.white,
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onSelected: (value) {
              setState(() {
                filterOption = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'all',
                  child: Text('       All'),
                ),
                const PopupMenuItem<String>(
                  value: 'due_date_asc',
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward,size: 18),
                       SizedBox(width: 4),
                      Text('with Due Date'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'due_date_desc',
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward,size: 18),
                      SizedBox(width: 4),
                      Text('with Due Date'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'priority_asc',
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward,size: 18),
                      SizedBox(width: 4),
                      Text('with Priority'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'priority_desc',
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward,size: 18),
                      SizedBox(width: 4),
                      Text('with Priority'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: allTaskDetails()),
          ],
        ),
      ),
      floatingActionButton: hasTasks
          ? FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget allTaskDetails() {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> tasks = snapshot.data!.docs;

        if (searchQuery.isNotEmpty) {
          tasks = tasks.where((doc) {
            return doc['Title']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();
        }

        tasks.sort((a, b) {
          return (b['CreationDate'].compareTo(a['CreationDate']));
        });

        sortTasks(tasks);

        if (tasks.isEmpty) {
          return Center(
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: const MaterialStatePropertyAll(0.4),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                backgroundColor: const MaterialStatePropertyAll(Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTaskScreen(),
                  ),
                );
              },
              child: const Text(
                'Add Task',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            DocumentSnapshot documentSnapshot = tasks[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskEditScreen(
                      taskId: documentSnapshot['id'],
                      title: documentSnapshot['Title'],
                      description: documentSnapshot['Description'],
                      date: documentSnapshot['Date'],
                      time: documentSnapshot['Time'],
                      priority: documentSnapshot['Priority'],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Material(
                    elevation: 4.0,
                    shadowColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 240,
                                child: Text(
                                  documentSnapshot['Title'],
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w800),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    documentSnapshot['Date'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColorConstant.grey),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    documentSnapshot['Time'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColorConstant.grey),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Priority :',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                  Text(
                                    ' ${documentSnapshot['Priority']}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black38),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskEditScreen(
                                          taskId: documentSnapshot['id'],
                                          title: documentSnapshot['Title'],
                                          description:
                                          documentSnapshot['Description'],
                                          date: documentSnapshot['Date'],
                                          time: documentSnapshot['Time'],
                                          priority:
                                          documentSnapshot['Priority'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.edit)),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        surfaceTintColor: Colors.white,
                                        elevation: 100,
                                        title: const Text(
                                          'Alert!',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        content: const Text(
                                          'Are you sure to Delete Task!',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )),
                                          TextButton(
                                            onPressed: () async {
                                              await DatabaseMethod()
                                                  .deleteTaskDetails(
                                                  documentSnapshot['id']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  getOnTheLoad() async {
    taskStream = await DatabaseMethod().getTaskDetails();
    taskStream?.listen((event) {
      setState(() {
        hasTasks = event.docs.isNotEmpty;
      });
    });
    setState(() {});
  }

  void sortTasks(List<DocumentSnapshot> tasks) {
    switch (filterOption) {
      case 'all':
        tasks.sort((a, b) => b['CreationDate'].compareTo(a['CreationDate']));
        break;
      case 'due_date_asc':
        tasks.sort((a, b) => a['Date'].compareTo(b['Date']));
        break;
      case 'due_date_desc':
        tasks.sort((a, b) => b['Date'].compareTo(a['Date']));
        break;
      case 'priority_asc':
        tasks.sort((a, b) => a['Priority'].compareTo(b['Priority']));
        break;
      case 'priority_desc':
        tasks.sort((a, b) => b['Priority'].compareTo(a['Priority']));
        break;
      default:
        break;
    }
  }
}
