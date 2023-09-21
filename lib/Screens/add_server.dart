
import 'package:flutter/material.dart';

class AddServerDialog extends StatefulWidget {

  final Function(ServerData) onSave;
  final List<ServerData> serverList;
  final ServerData? serverToEdit;

  const AddServerDialog({
    Key? key,
    required this.onSave,
    required this.serverList,
    this.serverToEdit,
  }) : super(key: key);

  @override
  State<AddServerDialog> createState() => _AddServerDialogState();
}
class _AddServerDialogState extends State<AddServerDialog> {
  final TextEditingController serverNameController = TextEditingController();
  final TextEditingController serverIPController = TextEditingController();
  bool isDefaultServer = false;
  String validationMessage = '';

  @override
  void initState() {
    super.initState();
    // Populate the dialog fields with the existing server data when editing
    if (widget.serverToEdit != null) {
      serverNameController.text = widget.serverToEdit!.name;
      serverIPController.text = widget.serverToEdit!.ip;
      isDefaultServer = widget.serverToEdit!.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Change the title based on whether it's an edit or add operation
    final dialogTitle = widget.serverToEdit == null
        ? 'Add Server'
        : 'Edit Server';

    return AlertDialog(
      title: Center(
        child: Text(
          dialogTitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
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
          const SizedBox(height: 16), // Add some vertical spacing
          Row(
            children: [
              const Text(
                'Defaults Server',
                style: TextStyle(
                  fontSize: 16, // Increase font size
                  color: Colors.black87, // Change text color
                ),
              ),
              Checkbox(
                value: isDefaultServer,
                onChanged: (value) {
                  setState(() {
                    isDefaultServer = value ?? false;

                    // Set the default value of all other servers to false
                    for (final server in widget.serverList) {
                      if (server != widget.serverToEdit) {
                        server.isDefault = false;
                      }
                    }
                  });
                },
              ),
            ],
          ),
          if (validationMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                validationMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic, // Add italic style
                ),
              ),
            ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final serverName = serverNameController.text;
            final serverIP = serverIPController.text;

            if (serverName.isEmpty || serverIP.isEmpty) {
              setState(() {
                validationMessage = 'Both fields are required.';
              });
            } else if (isServerNameUnique(serverName)) {
              setState(() {
                validationMessage = 'Server name already exists. Please enter a unique name.';
              });
            } else {
              final updatedServerData = ServerData(
                name: serverName,
                ip: serverIP,
                isDefault: isDefaultServer,
              );

              if (widget.serverToEdit != null) {
                final index = widget.serverList.indexOf(widget.serverToEdit!);
                if (index != -1) {
                  widget.serverList[index] = updatedServerData;
                }
              }

              widget.onSave(updatedServerData);

              Navigator.of(context).pop();
            }
          },
          child: const Text(
            'Save',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Make it bold
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
              fontWeight: FontWeight.bold, // Make it bold
            ),
          ),
        ),
      ],
    );
  }


  // Function to check if the server name is unique
  bool isServerNameUnique(String name) {
    return widget.serverList.any((server) => server.name == name);
  }
}

class ServerData {
  late final String name;
  late final String ip;
  late final bool isDefault;

  ServerData({required this.name, required this.ip, this.isDefault = false});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ip': ip,
      'isDefault': isDefault,
    };
  }
  factory ServerData.fromJson(Map<String, dynamic> json) {
    return ServerData(
      name: json['name'],
      ip: json['ip'],
      isDefault: json['isDefault'],
    );
  }
}