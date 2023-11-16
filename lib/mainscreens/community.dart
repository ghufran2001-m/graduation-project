// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class community_screen extends StatefulWidget {
  const community_screen({super.key});

  @override
  State<community_screen> createState() => _community_screenState();
}

class _community_screenState extends State<community_screen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          PostContainer(),
          const SizedBox(
            height: 10,
          ),
          PostContainer(),
          const SizedBox(
            height: 10,
          ),
          PostContainer(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget PostContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width - 15,
      decoration:const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:15, top:15),
              child: Row(
                children: [
                  Container(
                    height:40, width:40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle   
                               ),
                  ),
                  SizedBox(width: 10,),
                  Text("Ghufran Mustafa", style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.bold,),),
                  SizedBox(width: 130,),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list_sharp),
                    color: Colors.black87,
                  ),
                ],
                
              ),
            ),
          ),
        
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 150, width:200, color: Colors.white,
                           
                        ),
              ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.star),
                    color: Colors.black87,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.comment_rounded),
                    color: Colors.black87,
                  ),
                  const SizedBox(
                    width: 230,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.system_update_tv_sharp),
                    color: Colors.black87,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
