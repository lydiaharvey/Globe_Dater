import 'package:hive/hive.dart';

part 'decision_map.g.dart'; //imports a generated file

@HiveType(typeId: 0) //all model classes must have a unique ID
class DecisionMap{

  @HiveField(0) //This assigns a unique number to each attribute in the database
  late int ID;

  @HiveField(1)
  late int yesID;

  @HiveField(2)
  late int noID;

  @HiveField(3)
  late String description;

  @HiveField(4)
  late String question;


  @override
  String toString() {
    return 'DecisionMap{ID: $ID, yesID: $yesID, noID: $noID, description: $description}';
  }
}