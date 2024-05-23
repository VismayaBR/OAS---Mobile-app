class Items{
  final String name;
  final String description;
  final String category;
  
  final String expiry;
  final String basebid;
  final String imagepath;
  int? maxbid;
  String? fulldescription;
  
  Items({required this.name, required this.description, required this.expiry, required this.basebid, required this.imagepath,required this.category,this.maxbid,required this.fulldescription,});

  get widget => null;
}


class Services{
   final String name;
  final String description;
  final String category;
  
  final String expiry;
  final String budget;
  final String imagepath;
  String? maxbid;
  String? fulldescription;
  
  Services({required this.name, required this.description, required this.expiry, required this.budget, required this.imagepath,required this.category,this.maxbid,required this.fulldescription,});
}
  
