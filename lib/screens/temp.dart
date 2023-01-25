// return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(100.0),
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: <Color>[
//                 Color.fromARGB(255, 243, 58, 33),
//                 Color.fromARGB(255, 233, 30, 30)
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   children: <Widget>[
//                     logo(size),
//                     if (size.width > 800)
//                       const SizedBox(
//                         width: 300,
//                       ),
//                     if (size.width < 550)
//                       const SizedBox(
//                         width: 20,
//                       ),
//                     if (size.width < 800 && size.width > 560)
//                       const SizedBox(
//                         width: 150,
//                       ),
//                     menuItems(size),
//                     searchButton(),
//                     profileIconName(size)
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
      // body: SizedBox(
      //   height: double.infinity,
      //   width: double.infinity,
      //   child: PageView.builder(
      //     controller: pageController,
      //     itemCount: menuName.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Container(
      //         decoration: const BoxDecoration(color: Colors.white60),
      //         child: Padding(
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //           child: menuName[index].page,
      //         ),
      //       );
      //     },
      //   ),
      // ),
  