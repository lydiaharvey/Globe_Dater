import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'decision_map.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer';

// All of my imports

late Box<DecisionMap> box;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized(); //

  await Hive.initFlutter();
  Hive.registerAdapter(DecisionMapAdapter());

  box = await Hive.openBox<DecisionMap>('decisionMap');




  String csv = "assets/data.csv";
  String fileData = await rootBundle.loadString(csv);
  List <String> rows = fileData.split("\n");
  for (int i=0; i< rows.length;i++){
    String row = rows[i];
    List <String> itemInRow = row.split(",");
    DecisionMap dm = DecisionMap()
      ..ID = int.parse(itemInRow[0])
      ..yesID = int.parse(itemInRow[1])
      ..noID = int.parse(itemInRow[2])
      ..description = itemInRow[3]
      ..question = itemInRow[4];

      int key = int.parse(itemInRow[0]);
      box.put(key,dm);


  }
  runApp(MaterialApp(home:home(),debugShowCheckedModeBanner: false,));
}



class home extends StatefulWidget {


  home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  late int ID;
  late int yesID;
  late int noID;
  String description = "";
  String question = "";


  void buttonHandler(id){
    setState(() {
      DecisionMap? current = box.get(id);
      if (current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
        question = current.question;
      }
    });
        }






  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        DecisionMap current = box.get(1)!;
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
        question=current.question;


      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2EBFB),
        appBar: AppBar(
          backgroundColor: Color(0xFF9667E0),
          toolbarHeight: 100,
          title: Text("Map Guesser",style: TextStyle(fontSize: 50),),
          centerTitle: true,
        ),
        body:Stack(
            children:[
              Align(alignment: Alignment(0,0.3), child: Image.asset("assets/globley.png", scale: 2,)),
              Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0), child: Align(alignment: Alignment.topCenter, child: Text(description, style: TextStyle(fontSize: 50,color: Colors.black),textAlign: TextAlign.center))),
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 20),child: Align(alignment: Alignment(0,-0.5),child: Text(question, style: TextStyle(fontSize: 45,color: Colors.black),textAlign: TextAlign.center))),
              Padding(padding: EdgeInsets.all(50), child: Align(alignment: Alignment.bottomLeft, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF46B000),fixedSize: Size(MediaQuery.of(context).size.width*0.3, MediaQuery.of(context).size.height*0.2)), onPressed:(){ buttonHandler(yesID);},child: Text("Yes", style: TextStyle(fontSize: 50),),))),
              Padding(padding: EdgeInsets.all(50), child: Align(alignment: Alignment.bottomRight, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF46B000),fixedSize: Size(MediaQuery.of(context).size.width*0.3, MediaQuery.of(context).size.height*0.2)), onPressed:(){buttonHandler(noID);},child: Text("No", style: TextStyle(fontSize: 50),),))),

            ]
        ));
  }
}

