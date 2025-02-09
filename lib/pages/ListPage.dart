import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:segfaultersloc/pages/HomePage.dart'; // Ensure PageBackground is imported
import 'package:shared_preferences/shared_preferences.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  String? role;
  String? uid;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
      uid = prefs.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return PageBackground(
      overlayColor: Colors.green,
      child: role == "org" ? OrgListPage(uid: uid!) : CorpListPage(),
    );
  }
}

class OrgListPage extends StatelessWidget {
  final String uid;
  const OrgListPage({super.key, required this.uid});

  Future<void> _addListing(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController fundingController = TextEditingController();
    TextEditingController volunteerController = TextEditingController();


    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Listing"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title")),
              TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Description")),
              TextField(
                  controller: fundingController,
                  decoration: InputDecoration(labelText: "Funding Required"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: volunteerController,
                  decoration: InputDecoration(labelText: "Volunteers Required"),
                  keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection("Ngo")
                      .doc(uid)
                      .collection("listing")
                      .add({
                    "title": titleController.text,
                    "description": descriptionController.text,
                    "fundingRequired": fundingController.text,
                    "uid": uid,
                    "isCommitted": false,
                    "timestamp": FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editListing(
      BuildContext context,
      String docId,
      String currentTitle,
      String currentDescription,
      String currentFunding) async {
    TextEditingController titleController =
        TextEditingController(text: currentTitle);
    TextEditingController descriptionController =
        TextEditingController(text: currentDescription);
    TextEditingController fundingController =
        TextEditingController(text: currentFunding);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Listing"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title")),
              TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Description")),
              TextField(
                  controller: fundingController,
                  decoration: InputDecoration(labelText: "Funding Required"),
                  keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection("Ngo")
                      .doc(uid)
                      .collection("listing")
                      .doc(docId)
                      .update({
                    "title": titleController.text,
                    "description": descriptionController.text,
                    "fundingRequired": fundingController.text,
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
        ),
        Text("Your Listings",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _addListing(context),
          child: Text("Add New Listing"),
        ),
        SizedBox(height: 20),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Ngo")
                .doc(uid)
                .collection("listing")
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Text("No listings found",
                        style: TextStyle(color: Colors.white)));
              }
              return Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white)),
                      child: ListTile(
                        title: Text(data["title"],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description: ${data["description"]}",
                                style: TextStyle(color: Colors.white70)),
                            Text("Funding: ₹${data["fundingRequired"]}",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _editListing(
                              context,
                              doc.id,
                              data["title"],
                              data["description"],
                              data["fundingRequired"]),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CorpListPage extends StatelessWidget {
  Future<String> _getNgoName(String ngoUid) async {
    DocumentSnapshot ngoDoc =
        await FirebaseFirestore.instance.collection("Ngo").doc(ngoUid).get();
    return ngoDoc.exists
        ? (ngoDoc.data() as Map<String, dynamic>)["name"] ?? "Unknown NGO"
        : "Unknown NGO";
  }

  Future<String> _getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') ?? ''; // Fetching UID from SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserUid(), // Getting the user UID from SharedPreferences
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text("Failed to fetch UID",
                  style: TextStyle(color: Colors.white)));
        }

        String userUid = snapshot.data!;

        return Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Text("All NGO Listings",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Ngo")
                    .snapshots(), // Stream to get all NGO documents
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text("No NGOs available",
                            style: TextStyle(color: Colors.white)));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var ngoDoc = snapshot.data!.docs[index];
                      String ngoUid =
                          ngoDoc.id; // NGO document ID is used as UID
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("Ngo")
                            .doc(ngoUid)
                            .collection("listing")
                            .where("isCommitted", isEqualTo: false)
                            .get(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> listingsSnapshot) {
                          if (listingsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!listingsSnapshot.hasData ||
                              listingsSnapshot.data!.docs.isEmpty) {
                            return Container(); // No listings for this NGO
                          }
                          return Column(
                            children:
                                listingsSnapshot.data!.docs.map((listingDoc) {
                              var data =
                                  listingDoc.data() as Map<String, dynamic>;
                              String ngoName = ngoDoc['name'] ?? 'Unknown';

                              return Card(
                                margin: EdgeInsets.all(8),
                                color: Colors.white.withOpacity(0.1),
                                child: ListTile(
                                  title: Text(data["title"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("NGO: $ngoName",
                                          style:
                                              TextStyle(color: Colors.white70)),
                                      Text(
                                          "Description: ${data["description"]}",
                                          style:
                                              TextStyle(color: Colors.white70)),
                                      Text(
                                          "Funding Required: ₹${data["fundingRequired"]}",
                                          style:
                                              TextStyle(color: Colors.white70)),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
