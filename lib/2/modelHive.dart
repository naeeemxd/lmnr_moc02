import 'package:hive/hive.dart';



part 'modelHive.g.dart';



@HiveType(typeId: 0)

class Asset extends HiveObject {

  @HiveField(0)

  String name;



  @HiveField(1)

  String type;



  @HiveField(2)

  String description;



  @HiveField(3)

  String serialNumber;



  @HiveField(4)

  bool isAvailable;



  Asset({

    required this.name,

    required this.type,

    required this.description,

    required this.serialNumber,

    this.isAvailable=true,

});

}
