import 'package:flutter_project_api/api_services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_api/add_edit_user_screen.dart';


class UserListPage extends StatefulWidget {
  final bool isFavourite;

   const UserListPage({Key? key, this.isFavourite = false}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    ApiService apiService = ApiService();
    List<dynamic> data = await apiService.getAll();
    setState(() {
      allUsers = List<Map<String, dynamic>>.from(data);
      filteredUsers = widget.isFavourite
          ? allUsers.where((user) => user["isFavorite"] == true).toList()
          : allUsers;
      isLoading = false;
    });
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers.where((user) =>
      user["name"].toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFavourite ? 'Favorite Users' : 'User List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value){
                filterUsers();
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildUserList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    if (filteredUsers.isEmpty) {
      return Center(
        child: Text(
          "No Users Found",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _editUser(user);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.pink,
                child: Text(
                  user['name'][0].toUpperCase(),
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text("Gender : ${user['gender']}"),
                    Text("City : ${user['city'].toString()}"),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildFavoriteButton(user),
                  SizedBox(height: 8),
                  _buildDeleteButton(user),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(Map<String, dynamic> user) {
    ApiService apiService = ApiService();
    return IconButton(
      icon: Icon(
        user['isFavorite'] == true ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () async {
        await apiService.toggleFavorite(user['id'], user['isFavorite']);
        fetchUsers();
      },
    );
  }

  Widget _buildDeleteButton(Map<String, dynamic> user) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () => _showDeleteConfirmation(user),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> user) {
    ApiService apiService = ApiService();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete User"),
        content: Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await apiService.deleteUser(user['id']);
              fetchUsers();
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editUser(Map<String, dynamic> user) {
    ApiService apiService = ApiService();

    print("::: from _edit user");
    print(user);

    user['hobbies'] = user['hobbies'] == null || user['hobbies'].length == 0 ? [] : user['hobbies'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserEntryPage(userDetails: user),
      ),
    ).then((updatedUser) async {
      if (updatedUser != null) {
        await apiService.updateUser(user['id'], updatedUser);
        fetchUsers();
      }
    });
  }
}
