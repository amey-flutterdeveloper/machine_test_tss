class User {
  final int id;
  final String name;
  final String email;
  bool isFavorite;

  User({required this.id,required this.name,required this.email,this.isFavorite = false});
  factory User.fromJson(Map<String , dynamic >json){
    return User(
        id:json['id'],
        name:json['name'],
        email: json['email']
    );
  }
  Map<String ,dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'email' : email,
    'isFavorite' : isFavorite,
  };
}