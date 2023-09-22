import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task1_rosenfield_health/Screens/login_screen.dart';
import 'add_server.dart'; // Assuming this is where your AddServerDialog class is defined
import 'package:shared_preferences/shared_preferences.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({Key? key}) : super(key: key);

  @override
  State<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  List<ServerData> serverList = [];
  int? defaultServerIndex;

  @override
  void initState() {
    super.initState();
    getServerData();
  }

  // Method to save server data to SharedPreferences
  static Future<void> setServerData(List<ServerData> serverList) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final serverListJson = serverList.map((server) => server.toJson()).toList();
    pref.setString('serverList', jsonEncode(serverListJson));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Servers",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: serverList.isEmpty
          ? const Center(
        child: Text(
          "No servers",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        itemCount: serverList.length,
        itemBuilder: (context, index) {
          final server = serverList[index];

          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            child: ListTile(
              title: Text(
                'Server Name: ${server.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Server IP/Domain: ${server.ip}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Default Server: ${server.isDefault ? 'true' : 'false'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      // Open the edit dialog for the selected server
                      _openEditDialog(server);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _showDeleteConfirmationDialog(server);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddServerDialog(
                onSave: (serverData) {
                  setState(() {
                    if (serverData.isDefault) {
                      List<ServerData> tempList = List.from(serverList);
                      for (int i = 0; i < tempList.length; i++) {
                        if (tempList[i].isDefault) {
                          tempList[i] = ServerData(
                            name: tempList[i].name,
                            ip: tempList[i].ip,
                            isDefault: false,
                          );
                        }
                      }
                      serverList = tempList;
                    }
                    serverList.add(serverData);
                  });

                  // Save the updated server list to SharedPreferences
                  setServerData(serverList);
                },
                serverList: serverList, // Pass the actual serverList
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          size: 36.0,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                // Navigate to the LoginScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.adb_sharp),
              onPressed: () {
                // Add your action for the second bottom navigation button here
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Method to retrieve server data from SharedPreferences

  void getServerData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final serverListJson = pref.getString('serverList');

    if (serverListJson != null) {
      final serverList = (jsonDecode(serverListJson) as List)
          .map((item) => ServerData.fromJson(item))
          .toList();

      setState(() {
        // Combine the existing serverList and any new servers from the TestScreen
        serverList.addAll(serverList);
      });
    }
  }

  void _openEditDialog(ServerData server) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController serverNameController =
        TextEditingController(text: server.name);
        TextEditingController serverIPController =
        TextEditingController(text: server.ip);
        bool isDefaultServer = server.isDefault;

        return AlertDialog(
          title: const Text('Edit Server'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: serverNameController,
                decoration: const InputDecoration(
                  labelText: 'Server Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: serverIPController,
                decoration: const InputDecoration(
                  labelText: 'Server IP/Domain',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Default Server',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Checkbox(
                    value: isDefaultServer,
                    onChanged: (value) {
                      setState(() {
                        isDefaultServer = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {

                  final updatedServerData = ServerData(
                  name: serverNameController.text,
                  ip: serverIPController.text,
                  isDefault: isDefaultServer,
                );

                setState(() {
                  // Update the server data in the list
                  final index = serverList.indexOf(server);
                  if (index != -1) {
                    serverList[index] = updatedServerData;
                  }
                });
                // Save the updated server list to SharedPreferences
                setServerData(serverList);

                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(ServerData server) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dismiss dialog on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Server'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete the server?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Perform the delete operation here
                setState(() {
                  serverList.remove(server);
                  if (server.isDefault) {
                    defaultServerIndex = null;
                  }
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

