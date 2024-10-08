import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
  MaterialApp(
    home: Electrovanne(),
  ),
);

class Electrovanne extends StatefulWidget {
  @override
  _ElectrovanneState createState() => _ElectrovanneState();
}

class _ElectrovanneState extends State<Electrovanne> {
  var electroList = [];

  @override
  void initState() {
    super.initState();
    fetchElectrovanne();
  }

  Future<void> fetchElectrovanne() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('http://localhost:3001/electrovanne'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token ?? '',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        electroList = json.decode(response.body) as List<dynamic>;
      });
    } else {
      throw Exception("Failed to get electrovanne data");
    }
  }

  Future<void> addElectrovanne(String name,bool status) async{
    final prefs=await SharedPreferences.getInstance();
    final token= prefs.getString('jwt_token');
    final response = await http.post(Uri.parse('http://localhost:3001/electrovanne'),
    headers: <String, String>{
      'Content-Type':'application/json; charset=UTF-8',
      'x-auth-token': token ?? '',
    },
      body: jsonEncode(<String, dynamic>{
        'nom':name,
        'status':status,
      }),
    );
    if (response.statusCode == 201){
      fetchElectrovanne();
    }else{
      throw Exception("Failed to add electrovanne");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Irrigation', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 7,),
            ElevatedButton(
              child: Text('Ajouter Electrovanne'),
              onPressed: () {
                showAddElectrovanneDialog(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),

            for (var electItem in electroList)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              electItem['nom'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 80),
                            FlutterSwitch(
                              width: 100.0,
                              height: 40.0,
                              valueFontSize: 13.0,
                              toggleSize: 25.0,
                              value: electItem['status'],
                              activeColor: Colors.green,
                              borderRadius: 30.0,
                              padding: 8.0,
                              showOnOff: true,
                              onToggle: (val) {
                                setState(() {
                                  electItem['status'] = val;
                                });
                              },
                            ),
                            SizedBox(width: 86, height: 80),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('Parametres'),
                              onPressed: () {
                                showAlertDialog(context, electItem['nom'], electItem['_id']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void showAddElectrovanneDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    bool status = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Ajouter Electrovanne'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      hintText: 'Entrez le nom',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Status"),
                      FlutterSwitch(
                        width: 100.0,
                        height: 40.0,
                        valueFontSize: 13.0,
                        toggleSize: 25.0,
                        value: status,
                        activeColor: Colors.green,
                        borderRadius: 30.0,
                        padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            status = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Annuler', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                TextButton(
                  child: Text('Ajouter', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    addElectrovanne(nameController.text, status);
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

}

void showAlertDialog(BuildContext context, String electroName, String electroId) {
  bool valueCheck1 = false;
  AlertDialog alert = AlertDialog(
    title: Text("Parametres de $electroName ", style: TextStyle(color: Colors.black, fontSize: 15)),
    content: SizedBox(
      height: 100,
      child: Column(
        children: <Widget>[
          TextFormField(
            onChanged: (newVal) {
              electroName = newVal;
            },
            initialValue: electroName,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Enter Electrovanne Name',
              hintText: 'Enter Your Name',
            ),
          ),
          Text("Irrigation auto"),
        ],
      ),
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextButton(
            child: Text("Annuler", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
          SizedBox(width: 40),
          TextButton(
            child: Text("Valider", style: TextStyle(color: Colors.white)),
            onPressed: () {
              print(electroName);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
