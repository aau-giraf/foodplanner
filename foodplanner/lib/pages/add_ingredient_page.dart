import 'package:flutter/material.dart';

class AddIngredientPage extends StatelessWidget {
  const AddIngredientPage({super.key});

  @override
  Widget build(BuildContext context) {
    double buttonsize = MediaQuery.sizeOf(context).width;
    return Scaffold(
      
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // Siden den skal tilbage til :)
        //   }, 
        // ),
        title: const Text("Redigér madpakke"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded (
              child: ListView.separated(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container( 
                    width: buttonsize,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      //border: Border.all(color: Colors.grey),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Knækbrød',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Spacer(),

                        Column (
                          children: [
                            SizedBox(height: 8),
                            IconButton (
                              icon: Icon(Icons.add),
                                onPressed: () {

                                },
                              style: ElevatedButton.styleFrom(
                                iconColor: Colors.orange,
                              ),
                            ),
                            Text(
                              'Tilføj mere',
                              style: new TextStyle(
                              fontSize: 12.0,
                              )
                            ),
                          ]
                        ),
                        SizedBox(width: 10),

                        Column (
                          children: [
                            SizedBox(height: 8),
                            IconButton(
                              icon: Icon(Icons.check),
                                onPressed: () {

                                },
                              style: ElevatedButton.styleFrom(
                                iconColor: const Color.fromARGB(255, 27, 197, 5),
                              ),
                            ),
                            Text(
                              'Bekræft',
                              style: new TextStyle(
                              fontSize: 12.0,
                              )
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10);
                },
              ),
            ),

            SizedBox(height: 20),

            Container (
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                    BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
              ),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddIngredientPage()),
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  iconColor: Colors.white,
                  minimumSize: Size(buttonsize/2, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                  ),
                ),
              ),
            ),
          ]
        
        )
      )
    );
  }
}