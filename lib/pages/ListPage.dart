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

  // Add a new listing
Future<void> _addListing(BuildContext context) async {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fundingController = TextEditingController();
  TextEditingController volunteerController = TextEditingController();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow content to be scrollable
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16.0), // Padding for better spacing
        width: 700, // Set width to full screen
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure content size adapts
          children: [
            Text(
              "Add New Listing",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'PixelyB'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                 labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'PixelyB'
                ),labelText: "Title"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                 labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'PixelyB'
                ),labelText: "Description"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: fundingController,
              decoration: InputDecoration( labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'PixelyB'
                ),labelText: "Funding Required"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: volunteerController,
              decoration: InputDecoration( labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'PixelyB'
                ),labelText: "Volunteers Required"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(fontFamily: 'PixelyB',color: Colors.black),),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      FirebaseFirestore.instance.collection("Ngo").doc(uid).collection("listing").add({
                        "title": titleController.text,
                        "description": descriptionController.text,
                        "fundingRequired": fundingController.text,
                        "volunteersRequired": volunteerController.text,
                        "uid": uid,
                        "isCommitted": false,
                        "timestamp": FieldValue.serverTimestamp(),
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add",style: TextStyle(fontFamily: 'PixelyB',color: Colors.black),),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


  // Edit a listing
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

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow content to be scrollable
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16.0), // Padding for better spacing
        width: MediaQuery.of(context).size.width * 0.9, // Adjust width to 90% of the screen width
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure content size adapts
          children: [
            Text(
              "Edit Listing",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'PixelyB'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'PixelyB'
                ),
                labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'PixelyB'
                ),
                labelText: "Description"),
            ),
            TextField(
              controller: fundingController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'PixelyB'
                ),
                labelText: "Funding Required"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(fontFamily: 'PixelyB',color: Colors.black),),
                ),
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
                      titleController.clear();
                      descriptionController.clear();
                      fundingController.clear();
                    }
                  },
                  child: Text("Save",style: TextStyle(fontFamily: 'PixelyB',color: Colors.black),),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


  // Delete a listing
  Future<void> _deleteListing(String docId) async {
    await FirebaseFirestore.instance
        .collection("Ngo")
        .doc(uid)
        .collection("listing")
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 200),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Listings",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(width: 10),
            ElevatedButton(
              style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
                    color: Colors.white,
                    fontFamily: 'PixelyR',
                  )),
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.white.withOpacity(0.2))),
              onPressed: () => _addListing(context),
              child: Text("Add New Listing"),
            ),
          ],
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
                child: ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 10), // Add gap here
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white)),
                      child: ListTile(
                        title: Text(data["title"],
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'PixelyB',
                                fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description: ${data["description"]}",
                                style: TextStyle(color: Colors.white70,fontFamily: 'PixelyB')),
                            Text("Funding: ₹${data["fundingRequired"]}",
                                style: TextStyle(color: Colors.white70,fontFamily: 'PixelyB')),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _editListing(
                                  context,
                                  snapshot.data!.docs[index].id,
                                  data["title"],
                                  data["description"],
                                  data["fundingRequired"]),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () async {
                                bool confirm = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Delete Listing?"),
                                          content: Text(
                                              "Are you sure you want to delete this listing?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text("Cancel"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    ) ??
                                    false;
                                if (confirm) {
                                  _deleteListing(snapshot.data!.docs[index].id);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CorpListPage extends StatefulWidget {
  @override
  _CorpListPageState createState() => _CorpListPageState();
}

class _CorpListPageState extends State<CorpListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // 2 tabs: Active Listings and My Listings
  }

  Future<String> _getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') ?? ''; // Fetching UID from SharedPreferences
  }

  Future<void> _commitListing(BuildContext context, String userUid, String ngoUid, String listingDocUid, Map<String, dynamic> listingData) async {
  try {
    // Fetch the listing document from the 'listing' subcollection
    DocumentSnapshot listingDocSnapshot = await FirebaseFirestore.instance
        .collection("Ngo")
        .doc(ngoUid)
        .collection("listing")
        .doc(listingDocUid)
        .get();

    // Check if the listing document exists
    if (!listingDocSnapshot.exists) {
      print("Error: Listing document not found at Ngo/$ngoUid/listing/$listingDocUid");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Listing document not found")));
      return;
    }

    // Fetch NGO data
    Map<String, dynamic> ngoData = listingDocSnapshot.data() as Map<String, dynamic>;
    String ngoName = ngoData["name"] ?? "Unknown NGO";
    String ngoDescription = ngoData["description"] ?? "No description available";

    // Fetch Corporate user data
    DocumentSnapshot corporateDocSnapshot = await FirebaseFirestore.instance
        .collection("Corporate")
        .doc(userUid)
        .get();
    
    Map<String, dynamic> corporateData = corporateDocSnapshot.data() as Map<String, dynamic>;
    String corporateName = corporateData["name"] ?? "Unknown Corporate";
    String corporateEmail = corporateData["email"] ?? "No email available";

    // Reference to the collaborations collection
    CollectionReference collaborationsRef = FirebaseFirestore.instance.collection("Collaborations");

    // Create a new document in the 'Collaborations' collection with combined info
    await collaborationsRef.add({
      "ngoUid": ngoUid,
      "listingDocUid": listingDocUid,
      "ngoName": ngoName,  // Ensure NGO name is added
      "ngoDescription": ngoDescription,
      "corporateUid": userUid,
      "corporateName": corporateName,
      "corporateEmail": corporateEmail,
      "title": listingData["title"],
      "description": listingData["description"],
      "fundingRequired": listingData["fundingRequired"],
      "createdAt": FieldValue.serverTimestamp(),
    });

    // Delete the listing document from the 'listing' subcollection after collaboration is created
    await FirebaseFirestore.instance
        .collection("Ngo")
        .doc(ngoUid)
        .collection("listing")
        .doc(listingDocUid)
        .delete();

    // Reload the page by using setState
    setState(() {
      // This will trigger a rebuild of the widgets and reload the data
    });

    // Show a success message
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Commit successful and listing removed")));
  } catch (e) {
    // Handle errors
    print("Error during commit: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Failed to commit: $e")));
  }
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
            SizedBox(height: 200),
            Text("NGO Listings",
                style: TextStyle(
                  fontFamily: 'PixelyB',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 10),
            TabBar(
              labelStyle: TextStyle(
                fontFamily: 'PixelyB',
                color: Colors.white
              ),
              controller: _tabController,
              tabs: [
                Tab(text: "Active Listings"),
                Tab(text: "My Collaborations" ), // Updated tab name
              ],
              indicatorColor: Colors.green,
            ),
          Expanded(
  child: TabBarView(
    controller: _tabController,
    children: [
      // Active Listings Tab
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Ngo")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No NGOs available", style: TextStyle(color: Colors.white)));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var ngoDoc = snapshot.data!.docs[index];
              String ngoUid = ngoDoc.id;
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("Ngo")
                    .doc(ngoUid)
                    .collection("listing")
                    .where("isCommitted", isEqualTo: false)
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> listingsSnapshot) {
                  if (listingsSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!listingsSnapshot.hasData || listingsSnapshot.data!.docs.isEmpty) {
                    return Container();
                  }
                  return Column(
                    children: listingsSnapshot.data!.docs.map((listingDoc) {
                      var data = listingDoc.data() as Map<String, dynamic>;
                      String ngoName = ngoDoc['name'] ?? 'Unknown';
                      return Card(
                        margin: EdgeInsets.all(8),
                        color: Colors.white.withOpacity(0.1),
                        child: ListTile(
                          title: Text(data["title"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("NGO: $ngoName", style: TextStyle(color: Colors.white70,fontFamily: 'PixelyB',),),
                              Text("Description: ${data["description"]}", style: TextStyle(color: Colors.white70,fontFamily: 'PixelyB',)),
                              Text("Funding Required: ₹${data["fundingRequired"]}", style: TextStyle(color: Colors.white70,fontFamily: 'PixelyB',)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () {
                              _commitListing(
                                context,
                                userUid,
                                ngoUid,
                                listingDoc.id,  // Pass the listing document ID
                                data
                              );
                            },
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
      // My Collaborations Tab
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Collaborations")
            .where("corporateUid", isEqualTo: userUid)  // Filter collaborations based on corporate UID
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No collaborations found", style: TextStyle(color: Colors.white)));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var collaborationDoc = snapshot.data!.docs[index];
              var data = collaborationDoc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 300),
                child: Card(
                  margin: EdgeInsets.all(8),
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    title: Text(data["title"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'PixelyB',)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text("NGO: ${data["ngoName"]}", style: TextStyle(color: Colors.white70)),
                        Text("Description: ${data["description"]}", style: TextStyle(color: Colors.white70,fontFamily: 'PixelyB',),),
                        Text("Funding Required: ₹${data["fundingRequired"]}", style: TextStyle(color: Colors.white70,fontFamily: 'PixelyB',)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ],
  ),
)

          ],
        );
      },
    );
  }
}
