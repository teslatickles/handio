import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:slider_button/slider_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstRoute(title: 'First Route'),
    );
  }
}

class FirstRoute extends StatefulWidget {
  const FirstRoute({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _colorAnimation;
  late Animation _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _colorAnimation =
        ColorTween(begin: Colors.blue, end: Colors.red).animate(_controller);
    _sizeAnimation = Tween<double>(begin: 25.0, end: 55.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("test"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                dynamic ductStatus = snapshot.data?["dryerDuctClear"];
                return Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.ac_unit_sharp),
                        ),
                        Text(snapshot.data?["hvacF1"]
                            ? 'Filter has been changed for the month'
                            : 'change the damn filter!')
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.dry_cleaning_rounded,
                            color: ductStatus ? Colors.amber : Colors.redAccent,
                            size: 45.0,
                          ),
                        ),
                        Text(snapshot.data?["dryerDuctClear"]
                            ? 'Dryer lint duct has been cleared for the month'
                            : 'clear the damn dryer lint duct!')
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.cleaning_services_rounded),
                        ),
                        Text(snapshot.data?["deepCleaned"]
                            ? 'House has been deep cleaned this month'
                            : 'deep clean needed!')
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.house_siding),
                        ),
                        Text(snapshot.data?["mortgagePaid"]
                            ? 'Monthly mortgage paid!'
                            : 'Pay the mortgage payment!')
                      ],
                    ),
                    // SizedBox(
                    //   height: 27,
                    //   child: Text(
                    //     "Name: ${snapshot.data?.data()}\n",
                    //     overflow: TextOverflow.fade,
                    //     style: const TextStyle(fontSize: 8),
                    //   ),
                    // ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
                return const Text("No data");
              }
              return const CircularProgressIndicator();
            },
          ),
        ));
  }

  Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("Months")
        .doc("dec_2021_xyz")
        .get();
  }
}
