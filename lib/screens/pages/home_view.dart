import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/screens/desborad/account/login_view.dart';
import 'package:firebase_todo/screens/desborad/splash_screen/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late FirebaseFirestore db;
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// insulation
    db = FirebaseFirestore.instance;

    //// data fetching data
  }

  /// Add Todo List items

  Future addTodo() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 500,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                const Text(
                  "Add Todo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                //  CustomTextFil("title"),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                      hintText: "Desc",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),

                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        print("user create new todo");

                        /// data add (set data)
                        db.collection('Notes').add({
                          "title": titleController.text,
                          "desc": descController.text
                        }).then((value) {
                          print("Note Added ${value.id}");
                          // value.id firebase autoId gantleted
                        });
                        // us modal -------- > data set kar rahe hai es liye modal ka toJson us aayega

                        Navigator.pop(context);
                        titleController.clear();
                        descController.clear();
                      },
                      child: const Text("Add")),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// Update Notes
  Future updateTodo(String id, String mTitle, String mDesc) {
    titleController.text = mTitle;
    descController.text = mDesc;

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 500,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                const Text(
                  "Update Todo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                      hintText: "Desc",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        print("update todo");

                        db.collection('Notes').doc(id).update({
                          "title": titleController.text,
                          "desc": descController.text
                        });
                        Navigator.pop(context);
                        titleController.clear();
                        descController.clear();
                      },
                      child: const Text("Update")),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// delet Notes
  Future<void> deletTodo(String itemId) async {
    await db.collection('Notes').doc(itemId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireBase Todo"),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                print("Log Out ");
                await FirebaseAuth.instance.signOut();
                var sp = await SharedPreferences.getInstance();
                sp.setBool(SplashViewState.LOGIN_KEY, false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginView()));
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        /// data fetching data
        stream: db.collection("Notes").snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print("object ${snapshot.hasError}");
            return Center(
              child: Text("Data Not Added ${snapshot.hasError}"),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        /// global variable
                        var notesData = snapshot.data!.docs[index];
                        // from Json data us in modal

                        return InkWell(
                          onTap: () {
                            // call update Function
                            updateTodo(notesData.id, notesData['title'],
                                notesData['desc']);
                          },
                          child: Card(
                            child: ListTile(
                              leading: Text("${index + 1}"),
                              title: Text("${notesData['title']}"),
                              subtitle: Text("${notesData['desc']}"),
                              trailing: InkWell(
                                onTap: () => deletTodo(notesData.id),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
