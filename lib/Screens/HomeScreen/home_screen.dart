import 'package:flutter/material.dart';
import 'package:to_do1/Screens/HomeScreen/home_cell.dart';
import 'package:to_do1/models/game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) { 
    List<Game> data = [
      const Game("Devil May Cry", 300, "dmc5.jpg"), 
      const Game("FC24", 400, "fifa.jpg"),
      const Game("Minecraft", 260, "minecraft.jpg"),
      const Game("Need For Spêed", 400, "nfs.jpg"),
      const Game("Reddead 2", 300, "rdr2.jpg"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('G-Store Esprit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        children: [
          HomeCell(data[0]), 
          HomeCell(data[1]),
          HomeCell(data[2]),
          HomeCell(data[1]),
          HomeCell(data[2]),
          HomeCell(data[1]),
          HomeCell(data[2]),
          HomeCell(data[3]),
          HomeCell(data[1]),
          HomeCell(data[2]),
          HomeCell(data[4]),
        ],
      ), 
    );
  }
}
