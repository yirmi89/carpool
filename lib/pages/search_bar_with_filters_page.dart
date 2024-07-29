// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carpool/models/group.dart';
//
// class SearchBarWithFiltersPage extends StatefulWidget {
//   final void Function(Locale) onLocaleChange;
//
//   const SearchBarWithFiltersPage({Key? key, required this.onLocaleChange}) : super(key: key);
//
//   @override
//   _SearchBarWithFiltersPageState createState() => _SearchBarWithFiltersPageState();
// }
//
// class _SearchBarWithFiltersPageState extends State<SearchBarWithFiltersPage> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Group> _searchResults = [];
//
//   void _searchGroups(String query) async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('groups').where('name', isGreaterThanOrEqualTo: query).get();
//     List<Group> groups = snapshot.docs.map((doc) => Group.fromMap(doc.data() as Map<String, dynamic>)).toList();
//
//     setState(() {
//       _searchResults = groups;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onChanged: (value) {
//                 _searchGroups(value);
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _searchResults.length,
//               itemBuilder: (context, index) {
//                 Group group = _searchResults[index];
//                 return ListTile(
//                   title: Text(group.name),
//                   subtitle: Text(group.description),
//                   onTap: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         groupName: group.name,
//                         onLocaleChange: widget.onLocaleChange,
//                       ),
//                     ));
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
