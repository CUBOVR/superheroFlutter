import 'package:flutter/material.dart';
import 'package:superhero_app/data/model/superheroDetailResponse.dart';
import 'package:superhero_app/data/model/superheroResponse.dart';
import 'package:superhero_app/data/repository.dart';

class SuperheroSearchscreen extends StatefulWidget {
  const SuperheroSearchscreen({super.key});

  @override
  State<SuperheroSearchscreen> createState() => _SuperheroSearchscreenState();
}

class _SuperheroSearchscreenState extends State<SuperheroSearchscreen> {
  Future<SuperheroResponse?>? _superheroInfo;
  Repository repository = Repository();
  bool _isTextEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Superhero Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Busca un superhéroe",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  _isTextEmpty = text.isEmpty;
                  _superheroInfo = repository.fetchSuperheroInfo(text);
                });
              },
            ),
          ),
          bodyList(_isTextEmpty),
        ],
      ),
    );
  }

  FutureBuilder<SuperheroResponse?> bodyList(bool isTextEmpty) {
    return FutureBuilder(
      future: _superheroInfo,
      builder: (context, snapshot) {
        if (isTextEmpty) {
          return Text("Introduce un nombre para buscar");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          var superheroList = snapshot.data?.result;
          return Expanded(
            child: ListView.builder(
              itemCount: superheroList?.length ?? 0,
              itemBuilder: (context, index) {
                if (superheroList != null) {
                  return itemSuperhero(superheroList[index]);
                } else {
                  return Text("Error");
                }
              },
            ),
          );
        } else {
          return Text("No hay resultados");
        }
      },
    );
  }

  Padding itemSuperhero(SuperheroDetailResponse item) => Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blueGrey,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.url,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment(0, -0.6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
