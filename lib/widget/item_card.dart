import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final int age;
  String alamat;
  //// Pointer to Update Function
  final Function? onUpdate;
  //// Pointer to Delete Function
  final Function? onDelete;

  ItemCard(this.name, this.age, this.alamat, {this.onUpdate, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(90, 134, 134, 134).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.data_usage_rounded,
                size: 30,
                color: Color.fromARGB(129, 146, 146, 146),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      name,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 56, 56, 56),
                          fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    child: Text(
                      age.toString() + " Tahun",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 68, 68, 68),
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 140,
                    child: Text(
                      alamat,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 92, 92, 92),
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (onUpdate != null) onUpdate!();
                },
                child: Container(
                  child: Icon(
                    Icons.drive_file_rename_outline_outlined,
                    size: 30,
                    color: Colors.amber,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (onDelete != null) onDelete!();
                },
                child: Container(
                  child: Icon(
                    Icons.disabled_by_default_rounded,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
