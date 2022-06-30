import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:firebase_cloud_storage/widget/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  _sendData(bool tambah, CollectionReference dt, String id) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  style: GoogleFonts.poppins(),
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: "Nama",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 175, 175, 175))),
                ),
                TextField(
                  style: GoogleFonts.poppins(),
                  controller: ageController,
                  decoration: InputDecoration(
                      hintText: "Umur",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 175, 175, 175))),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  style: GoogleFonts.poppins(),
                  controller: alamatController,
                  decoration: InputDecoration(
                      hintText: "Alamat",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 175, 175, 175))),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    if (tambah) {
                      AlertDialog alert = AlertDialog(
                        title: Text("Tambah Data"),
                        content: Text("Apakah anda yakin akan Menambah data"),
                        actions: [
                          FlatButton(
                            child: Text("Batal"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              dt.add({
                                'nama': nameController.text,
                                'umur': int.tryParse(ageController.text) ?? 0,
                                'alamat': alamatController.text,
                                'namaSearch':
                                    setSearchParam(nameController.text),
                              });
                              nameController.text = '';
                              ageController.text = '';
                              alamatController.text = '';
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );

                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    } else {
                      AlertDialog alert = AlertDialog(
                        title: Text("Edit Data"),
                        content: Text(
                            "Apakah anda yakin akan Mengedit data dengan id = $id"),
                        actions: [
                          FlatButton(
                            child: Text("Batal"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              dt.doc(id).update({
                                'nama': nameController.text,
                                'umur': int.tryParse(ageController.text) ?? 0,
                                'alamat': alamatController.text,
                                'namaSearch':
                                    setSearchParam(nameController.text),
                              });
                              nameController.text = '';
                              ageController.text = '';
                              alamatController.text = '';
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );

                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.all(13),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        tambah ? "Tambah Data" : "Edit Data",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  String name = "";
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference mahasiswa = firestore.collection('mahasiswa');
    final Stream<QuerySnapshot> listMahasiswa =
        firestore.collection('mahasiswa').snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Firestore'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.blue[300],
        onPressed: () {
          _sendData(true, mahasiswa, "");
        },
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            searchWidget(),
            listData(listMahasiswa, mahasiswa),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> listData(
      Stream<QuerySnapshot<Object?>> listMahasiswa,
      CollectionReference<Object?> mahasiswa) {
    return StreamBuilder<QuerySnapshot>(
        stream: (name != "")
            ? mahasiswa.where("namaSearch", arrayContains: name).snapshots()
            : listMahasiswa,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Center(child: Text("Error"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          final data = snapshot.requireData;

          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.size,
              itemBuilder: (context, index) {
                print(data.docs[index].id);
                return ItemCard(
                  data.docs[index]['nama'],
                  data.docs[index]['umur'],
                  data.docs[index]['alamat'],
                  onUpdate: () {
                    nameController.text = data.docs[index]['nama'];
                    ageController.text = data.docs[index]['umur'].toString();
                    alamatController.text = data.docs[index]['alamat'];
                    _sendData(false, mahasiswa, data.docs[index].id);
                  },
                  onDelete: () {
                    AlertDialog alert = AlertDialog(
                      title: Text("Hapus Data"),
                      content: Text("Apakah anda yakin akan menghapus data"),
                      actions: [
                        FlatButton(
                          child: Text("Batal"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            mahasiswa.doc(data.docs[index].id).delete();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                );
              });
        });
  }

  Container searchWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 238, 238),
          borderRadius: BorderRadius.circular(5)),
      child: TextField(
          obscureText: false,
          onChanged: (value) {
            setState(() {
              name = value;
            });
            print(name);
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Cari Nama ...",
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.search_outlined,
                  color: Color.fromARGB(255, 112, 112, 112),
                ),
                onPressed: () {},
              ),
              hintStyle: TextStyle(fontSize: 15),
              fillColor: Color.fromARGB(255, 238, 238, 238),
              filled: true)),
    );
  }

  bool showAlertDialog(BuildContext context, String value) {
    bool data = false;
    AlertDialog alert = AlertDialog(
      title: Text(value),
      content: Text("Apakah anda yakin akan $value"),
      actions: [
        FlatButton(
          child: Text("Batal"),
          onPressed: () {
            data = false;
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Lanjutkan"),
          onPressed: () {
            data = true;
            Navigator.pop(context);
          },
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return data;
  }
}
