import 'package:flutter/material.dart';
import 'package:machine_test_tss/service/user_service.dart';
import 'package:machine_test_tss/models/user_model.dart';
import 'package:machine_test_tss/task2/image_picker_screen.dart';
import 'package:machine_test_tss/task3/to_do_screen.dart';
class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> _users = [];
  bool _showFavoritesOnly = false ;
  bool _loading = true;
  @override
  void initState() {

    super.initState();
    _loadUsers();
  }


  Future<void> _loadUsers() async {
    try{
      List<User> users = await fetchUsers();
      print("Fetched users: ${users.length}");
      List<String> favoriteIds = await loadFavorites();
      for(var user in users) {
        if(favoriteIds.contains(user.id.toString())){
          user.isFavorite = true ;

        }
      }
      setState(() {
        _users = users;
        _loading = false;

      });
    }catch(e){
      setState(() {
        _loading = false;

      });
      debugPrint("Error fetching users: $e");
    }

  }

  void _toggleFavorite(User user) {
    setState(() {
      user.isFavorite = !user.isFavorite;

    });
    saveFavorites(_users);
  }
  @override
  Widget build(BuildContext context) {
    final displayedUsers = _showFavoritesOnly ? _users.where((u) => u.isFavorite).toList() : _users;
    return Scaffold(drawer: Drawer(backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
children: [
  DrawerHeader(decoration: BoxDecoration(color: Colors.deepPurple),
      child:Text('Tasks')),
  ListTile(
    title: Text('Task 1 : User List'),
    onTap: ()
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> UserListScreen()));
    },
  ),
  ListTile(
    title: Text('Task 2 : Camera / Gallery'),
    onTap: ()
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ImagePickerScreen()));
    },
  ),
  ListTile(
    title: Text('Task 1 : To Do List'),
    onTap: ()
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ToDoScreen()));
    },
  ),
],
),
),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "User List",style: TextStyle(color: Colors.white),
        ),

        actions: [
          Row(
            children: [
              Text('Favorites Only ',
                style: TextStyle(color: Colors.white),),
            Switch(
                value:_showFavoritesOnly,
                onChanged: (val){
                  setState(() {
                    _showFavoritesOnly = val;
                  });
                }),

            ],
          ),

        ],
      ),body: _loading ? const Center(
      child: CircularProgressIndicator()
    )
      : ListView.builder(
      itemCount: displayedUsers.length,
        itemBuilder: (context,index){
        final user = displayedUsers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: IconButton(onPressed: ()=>_toggleFavorite(user),
                icon:Icon(user.isFavorite ? Icons.star : Icons.star_border,
                color: Colors.amber,),
            ),
          ),
        );
        }),
    );
  }
}
