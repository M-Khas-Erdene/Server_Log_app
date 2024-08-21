import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JH;
import '../components/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EditServerPage extends StatefulWidget {
  final Server server;

  const EditServerPage({Key? key, required this.server}) : super(key: key);

  @override
  _EditServerPageState createState() => _EditServerPageState();
}

class _EditServerPageState extends State<EditServerPage> {
  final _formKey = GlobalKey<FormState>();
  late String reasonForFailure;
  late DateTime? dateOfFailure;
  late DateTime? dateOfStartup;
  bool dateOfFailureChanged = false;
  bool dateOfStartupChanged = false;

  @override
  void initState() {
    super.initState();
    reasonForFailure = widget.server.reasonForFailure;
    dateOfFailure = widget.server.dateOfFailure;
    dateOfStartup = widget.server.dateOfStartup;
  }

  Future<void> updateServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http
        .put(
      Uri.parse('http://10.0.2.2:5000/servers/date/${widget.server.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: JH.jsonEncode({
        'reason_for_failure': reasonForFailure,
        'date_of_failure': dateOfFailureChanged
            ? dateOfFailure?.toIso8601String()
            : dateOfFailure?.add(Duration(hours: 8)).toIso8601String(),
        'date_of_startup': dateOfStartupChanged
            ? dateOfStartup?.toIso8601String()
            : dateOfStartup?.add(Duration(hours: 8)).toIso8601String(),
      }),
    )
        .catchError((ex) {
      debugPrint("Error: $ex");
    });

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to update server: ${response.statusCode} ${response.body}'),
        ),
      );
    }
  }

  Future<void> _selectDateAndTime(BuildContext context, bool isFailure) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFailure
          ? dateOfFailure ?? DateTime.now()
          : dateOfStartup ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isFailure
            ? dateOfFailure ?? DateTime.now()
            : dateOfStartup ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          final selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          if (isFailure) {
            dateOfFailure = selectedDateTime;
            dateOfFailureChanged = true;
          } else {
            dateOfStartup = selectedDateTime;
            dateOfStartupChanged = true;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color appBarColor;
    Color textColor;
    Color buttonColor;

    String formatDateTime(DateTime? dateTime, bool hasChanged) {
      if (dateTime == null) return '';
      final dateTimeWithOffset =
          hasChanged ? dateTime : dateTime.add(Duration(hours: 8));
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTimeWithOffset);
    }

    if (dateOfFailure != null && dateOfStartup != null) {
      if (dateOfFailure!.isAfter(dateOfStartup!)) {
        backgroundColor = Colors.redAccent[100]!;
        appBarColor = Colors.redAccent[400]!;
        textColor = const Color.fromARGB(255, 0, 0, 0);
        buttonColor = Colors.red;
      } else {
        backgroundColor = Colors.greenAccent[100]!;
        appBarColor = Colors.greenAccent[400]!;
        textColor = Colors.green[700]!;
        buttonColor = Colors.green;
      }
    } else {
      backgroundColor = Colors.grey[200]!;
      appBarColor = Colors.grey[700]!;
      textColor = Colors.black;
      buttonColor = Colors.grey;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Server',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: reasonForFailure,
                decoration: InputDecoration(
                  labelText: 'Reason for Failure',
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
                onChanged: (value) => reasonForFailure = value,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of Failure',
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
                controller: TextEditingController(
                  text: formatDateTime(dateOfFailure, dateOfFailureChanged),
                ),
                onTap: () => _selectDateAndTime(context, true),
                readOnly: true,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of Startup',
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
                controller: TextEditingController(
                  text: formatDateTime(dateOfStartup, dateOfStartupChanged),
                ),
                onTap: () => _selectDateAndTime(context, false),
                readOnly: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    updateServer();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Update Server',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
