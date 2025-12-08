import 'package:flutter/material.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:foodplanner/config/colors.dart';

class EditClasses extends StatefulWidget {
  @override
  State<EditClasses> createState() => _EditClassesState();
}

class _EditClassesState extends State<EditClasses> {
  List<SchoolClass> schoolClasses = [];
  List<SchoolClass> editedClasses = [];
  Map<int, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    loadClasses(); 
  }

  Future<void> loadClasses() async {
    final classes = await SchoolClassService(apiUrl: ApiConfig.baseUrl)
        .fetchAllClasses();

    setState(() {
      schoolClasses = classes;

      editedClasses =  classes
        .map((c) => SchoolClass(classId: c.classId, className: c.className))
        .toList();

      for (var c in editedClasses) {
        controllers[c.classId] = TextEditingController(text: c.className);
      }
    });
  }


  Future<void> showCannotDeleteDialog(SchoolClass schoolClass) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Text(
            "Du kan ikke slette '${schoolClass.className}', da der er elever i. \n Slet eleverne ved at gå ind på administrér skole.",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
              ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
              ),
            ),
          ],
        );
      },
    );
  }


  Future<void> showRenameDialog(SchoolClass schoolClass) async {
    final controller = TextEditingController(text: schoolClass.className);

    final newName = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${schoolClass.className} → ${controller.text}",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(border: InputBorder.none),
                        style: const TextStyle(fontSize: 20),
                        onChanged: (value) {
                          setStateDialog(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Save button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, controller.text.trim());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4A45A),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Gem",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    if (newName != null && newName.isNotEmpty) {
      setState(() {
        schoolClass.className = newName;
      });
    }
  }

  Future<void> deleteClass(SchoolClass schoolClass) async {
    await SchoolClassService(apiUrl: ApiConfig.baseUrl)
        .deleteClass(schoolClass.classId);

    setState(() {
      schoolClasses.remove(schoolClass);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 120,
        elevation: 0,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 25),
          child: Text(
            "Redigér klasser",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: schoolClasses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: schoolClasses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final schoolClass = schoolClasses[index];

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Class name
                                Expanded(
                                  child: Text(
                                    schoolClass.className,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // RENAME BUTTON
                                GestureDetector(
                                  onTap: () {
                                    showRenameDialog(schoolClass);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      "Omdøb",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // DELETE BUTTON
                                GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          title: Text(
                                            "Er du sikker på, at du vil slette '${schoolClass.className}'?",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      minimumSize: Size(double.infinity, 50),
                                                      backgroundColor: Colors.orangeAccent,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                                      elevation: 4,
                                                      shadowColor: Colors.black26,
                                                    ),
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text(
                                                      "Nej",
                                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      minimumSize: Size(double.infinity, 50),
                                                      backgroundColor: Colors.red,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                                      elevation: 4,
                                                      shadowColor: Colors.black26,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      deleteClass(schoolClass);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        Text(
                                                          "Ja, slet",
                                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Icon(Icons.delete, color: Colors.black),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.delete, color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Bottom buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text("Annullér", style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            for (var c in schoolClasses) {
                              await SchoolClassService(apiUrl: ApiConfig.baseUrl)
                                  .updateClass(c.classId, c.className);
                            }
                            Navigator.pop(context, schoolClasses);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Gem",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
          ),
          
            
      bottomNavigationBar: NavBar(),
    );
  }
}