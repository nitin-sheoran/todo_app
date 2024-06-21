// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:todo_app/service/database_method.dart';
// import 'package:todo_app/ui/add_task_screen.dart';
// import 'package:todo_app/ui/task_edit_screen.dart';
// import 'package:todo_app/util/color_const.dart';
//
// class HomePageScreen extends StatefulWidget {
//   const HomePageScreen({super.key});
//
//   @override
//   State<HomePageScreen> createState() => _HomePageScreenState();
// }
//
// class _HomePageScreenState extends State<HomePageScreen> {
//   Stream<QuerySnapshot>? taskStream;
//   bool hasTasks = false;
//
//   getOnTheLoad() async {
//     taskStream = await DatabaseMethod().getTaskDetails();
//     taskStream?.listen((event) {
//       setState(() {
//         hasTasks = event.docs.isNotEmpty;
//       });
//     });
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     getOnTheLoad();
//     super.initState();
//   }
//
//   Widget allTaskDetails() {
//     return StreamBuilder(
//         stream: taskStream,
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                   elevation: const MaterialStatePropertyAll(0),
//                   shape: MaterialStatePropertyAll(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   backgroundColor: const MaterialStatePropertyAll(
//                     Colors.white
//                   )
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AddTaskScreen(),
//                     ),
//                   );
//                 },
//                 child: const Text('Add Task',style: TextStyle(fontSize: 18,color: Colors.black),),
//               ),
//             );
//           }
//
//           return ListView.builder(
//             shrinkWrap: true,
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TaskEditScreen(
//                             taskId: documentSnapshot['id'],
//                             title: documentSnapshot['Title'],
//                             description: documentSnapshot['Description'],
//                             date: documentSnapshot['Date'],
//                             time: documentSnapshot['Time']),
//                       ),
//                     );
//                   },
//                   child: Column(
//                     children: [
//                       Material(
//                         elevation: 4.0,
//                         shadowColor: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         child: Container(
//                           padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
//                           width: MediaQuery.of(context).size.width,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     documentSnapshot['Title'],
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w800),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     documentSnapshot['Description'],
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         documentSnapshot['Date'],
//                                         style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500,
//                                         color: AppColorConstant.grey),
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         documentSnapshot['Time'],
//                                         style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500,
//                                         color: AppColorConstant.grey),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 TaskEditScreen(
//                                                   taskId: documentSnapshot['id'],
//                                                   title: documentSnapshot['Title'],
//                                                   description: documentSnapshot['Description'],
//                                                   date: documentSnapshot['Date'],
//                                                   time: documentSnapshot['Time'],
//                                                 ),
//                                           ),
//                                         );
//                                       },
//                                       child: const Icon(Icons.edit)),
//                                   const SizedBox(height: 16),
//                                   GestureDetector(
//                                       onTap: () async {
//                                         showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return AlertDialog(
//                                               backgroundColor: Colors.white,
//                                               surfaceTintColor: Colors.white,
//                                               elevation: 100,
//                                               title: const Text(
//                                                 'Alert!',
//                                                 style: TextStyle(
//                                                     color: Colors.black),
//                                               ),
//                                               content: const Text(
//                                                 'Are you sure to Delete Task!',
//                                                 style: TextStyle(
//                                                     color: Colors.black),
//                                               ),
//                                               actions: [
//                                                 TextButton(
//                                                     onPressed: () {
//                                                       Navigator.pop(context);
//                                                     },
//                                                     child: const Text(
//                                                       'Cancel',
//                                                       style: TextStyle(
//                                                           color: Colors.black),
//                                                     )),
//                                                 TextButton(
//                                                   onPressed: () async {
//                                                     await DatabaseMethod()
//                                                         .deleteTaskDetails(
//                                                         documentSnapshot['id']);
//                                                     Navigator.pop(context);
//                                                   },
//                                                   child: const Text(
//                                                     'Delete',
//                                                     style: TextStyle(
//                                                         color: Colors.black),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                         );
//                                       },
//                                       child: const Icon(
//                                         Icons.delete,
//                                         color: Colors.red,
//                                       )),
//                                 ],
//                               ),
//                               // Row(
//                               //   mainAxisAlignment:
//                               //   MainAxisAlignment.spaceBetween,
//                               //   children: [
//                               //     Flexible(
//                               //       child: Text(
//                               //         documentSnapshot['Title'],
//                               //         style: const TextStyle(
//                               //             fontSize: 18,
//                               //             fontWeight: FontWeight.w800),
//                               //         overflow: TextOverflow.ellipsis,
//                               //       ),
//                               //     ),
//                               //     const SizedBox(width: 20),
//                               //
//                               //   ],
//                               // ),
//                               // const SizedBox(height: 2),
//                               // Row(
//                               //   mainAxisAlignment:
//                               //   MainAxisAlignment.spaceBetween,
//                               //   children: [
//                               //     const SizedBox(width: 20),
//                               //     GestureDetector(
//                               //         onTap: () async {
//                               //           showDialog(
//                               //             context: context,
//                               //             builder: (context) {
//                               //               return AlertDialog(
//                               //                 backgroundColor: Colors.white,
//                               //                 surfaceTintColor: Colors.white,
//                               //                 elevation: 100,
//                               //                 title: const Text(
//                               //                   'Alert!',
//                               //                   style: TextStyle(
//                               //                       color: Colors.black),
//                               //                 ),
//                               //                 content: const Text(
//                               //                   'Are you sure to Delete Task!',
//                               //                   style: TextStyle(
//                               //                       color: Colors.black),
//                               //                 ),
//                               //                 actions: [
//                               //                   TextButton(
//                               //                       onPressed: () {
//                               //                         Navigator.pop(context);
//                               //                       },
//                               //                       child: const Text(
//                               //                         'Cancel',
//                               //                         style: TextStyle(
//                               //                             color: Colors.black),
//                               //                       )),
//                               //                   TextButton(
//                               //                     onPressed: () async {
//                               //                       await DatabaseMethod()
//                               //                           .deleteTaskDetails(
//                               //                           documentSnapshot['id']);
//                               //                       Navigator.pop(context);
//                               //                     },
//                               //                     child: const Text(
//                               //                       'Delete',
//                               //                       style: TextStyle(
//                               //                           color: Colors.black),
//                               //                     ),
//                               //                   ),
//                               //                 ],
//                               //               );
//                               //             },
//                               //           );
//                               //         },
//                               //         child: const Icon(
//                               //           Icons.delete,
//                               //           color: Colors.red,
//                               //         )),
//                               //   ],
//                               // ),
//                               // const SizedBox(height: 2),
//                               // Row(
//                               //   children: [
//                               //     Text(
//                               //       documentSnapshot['Date'],
//                               //       style: const TextStyle(
//                               //           fontSize: 16,
//                               //           fontWeight: FontWeight.w500),
//                               //     ),
//                               //     const SizedBox(width: 4),
//                               //     Text(
//                               //       documentSnapshot['Time'],
//                               //       style: const TextStyle(
//                               //           fontSize: 16,
//                               //           fontWeight: FontWeight.w500),
//                               //     ),
//                               //   ],
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 );
//               },);
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         titleSpacing: -4,
//         backgroundColor: Colors.white,
//         title: const Text('Task'),
//       ),
//       floatingActionButton: hasTasks
//           ? FloatingActionButton(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(100),
//         ),
//         backgroundColor: Colors.white,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const AddTaskScreen(),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       )
//           : null,
//       body: Container(
//         margin: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Expanded(child: allTaskDetails()),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
  String sortBy = 'CreationDate';


  getOnTheLoad() async {
    taskStream = await DatabaseMethod().getTaskDetails();
    taskStream?.listen((event) {
      setState(() {
        hasTasks = event.docs.isNotEmpty;
      });
    });
    setState(() {
    });
  }
  void _loadTasks() {
    setState(() {
      taskStream = FirebaseFirestore.instance
          .collection('Task')
          .orderBy(sortBy)
          .snapshots();
    });
  }

  @override
  void initState() {
    getOnTheLoad();
    _loadTasks();
    super.initState();
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
        const priorityOrder = {'Low': 0, 'Medium': 1, 'High': 2};

        tasks.sort((a, b) {
          return priorityOrder[a['Priority']]!.compareTo(priorityOrder[b['Priority']]!);
        });

        if (tasks.isEmpty) {
          return Center(
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(0.4),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
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
                      time: documentSnapshot['Time'], priority: documentSnapshot['Priority'],
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
                              Text(
                                documentSnapshot['Title'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                documentSnapshot['Description'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
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
                              Text(documentSnapshot['Priority'],style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColorConstant.grey),),
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
                                          time: documentSnapshot['Time'], priority: documentSnapshot['Priority'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: isSearching
            ? TextFormField(
                autofocus: true,
                cursorHeight: 22,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search...',
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
            child: Row(
              children: [
                IconButton(
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
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    setState(() {
                      sortBy = value;
                      _loadTasks();
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return {'CreationDate', 'Date', 'Priority'}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
        ],
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
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: allTaskDetails()),
          ],
        ),
      ),
    );
  }
}
