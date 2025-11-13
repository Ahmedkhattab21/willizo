// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class GymMachinesGridWidget extends StatefulWidget {
//   const GymMachinesGridWidget({super.key});

//   @override
//   State<GymMachinesGridWidget> createState() => _GymMachinesGridWidgetState();
// }

// class _GymMachinesGridWidgetState extends State<GymMachinesGridWidget> {
//   List<String> selectedMachines = [];
//   bool selectAll = false;

//   final List<MachineItem> machines = [
//     MachineItem(
//       name: 'Elliptical Trainer',
//       description: 'Low-impact cardio machine.',
//       imagePath: 'assets/images/elliptical_trainer.png',
//     ),
//     MachineItem(
//       name: 'Treadmill',
//       description: 'Machine for walking or running indoors.',
//       imagePath: 'assets/images/treadmill.png',
//     ),
//     MachineItem(
//       name: 'Smith Machine',
//       description: 'Barbell on fixed rails for safe.',
//       imagePath: 'assets/images/smith_machine.png',
//     ),
//     MachineItem(
//       name: 'Exercise Bike',
//       description: 'Stationary bike for cardio workouts.',
//       imagePath: 'assets/images/exercise_bike.png',
//     ),
//   ];

//   void toggleMachine(String machineName) {
//     setState(() {
//       if (selectedMachines.contains(machineName)) {
//         selectedMachines.remove(machineName);
//         selectAll = false;
//       } else {
//         selectedMachines.add(machineName);
//         if (selectedMachines.length == machines.length) {
//           selectAll = true;
//         }
//       }
//     });
//   }

//   void toggleSelectAll() {
//     setState(() {
//       selectAll = !selectAll;
//       if (selectAll) {
//         selectedMachines = machines.map((m) => m.name).toList();
//       } else {
//         selectedMachines.clear();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header with title and Select All
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Gym Machines',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: toggleSelectAll,
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 20.r,
//                       height: 20.r,
//                       decoration: BoxDecoration(
//                         color: selectAll
//                             ? Color(0xFFCDFF00)
//                             : Colors.transparent,
//                         border: Border.all(color: Color(0xFFCDFF00), width: 2),
//                         borderRadius: BorderRadius.circular(4.r),
//                       ),
//                       child: selectAll
//                           ? Icon(Icons.check, color: Colors.black, size: 14.r)
//                           : null,
//                     ),
//                     SizedBox(width: 8.w),
//                     Text(
//                       'Select All',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 16.h),
//         // Grid
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: GridView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12.w,
//               mainAxisSpacing: 12.h,
//               childAspectRatio: 0.85,
//             ),
//             itemCount: machines.length,
//             itemBuilder: (context, index) {
//               final machine = machines[index];
//               final isSelected = selectedMachines.contains(machine.name);
//               return GestureDetector(
//                 onTap: () => toggleMachine(machine.name),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFF1C1C1E),
//                     borderRadius: BorderRadius.circular(12.r),
//                     border: Border.all(
//                       color: isSelected
//                           ? Color(0xFFCDFF00)
//                           : Colors.transparent,
//                       width: 2,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Image container
//                       Container(
//                         height: 120.h,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Color(0xFF2C2C2E),
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.r),
//                             topRight: Radius.circular(10.r),
//                           ),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.r),
//                             topRight: Radius.circular(10.r),
//                           ),
//                           child: Image.asset(
//                             machine.imagePath,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Center(
//                                 child: Icon(
//                                   Icons.fitness_center,
//                                   color: Colors.grey,
//                                   size: 40.r,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       // Text content
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.all(12.r),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     machine.name,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   SizedBox(height: 4.h),
//                                   Text(
//                                     machine.description,
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                               // Checkbox at bottom
//                               Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: Container(
//                                   width: 20.r,
//                                   height: 20.r,
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? Color(0xFFCDFF00)
//                                         : Colors.transparent,
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? Color(0xFFCDFF00)
//                                           : Colors.grey,
//                                       width: 2,
//                                     ),
//                                     borderRadius: BorderRadius.circular(4.r),
//                                   ),
//                                   child: isSelected
//                                       ? Icon(
//                                           Icons.check,
//                                           color: Colors.black,
//                                           size: 14.r,
//                                         )
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class MachineItem {
//   final String name;
//   final String description;
//   final String imagePath;

//   MachineItem({
//     required this.name,
//     required this.description,
//     required this.imagePath,
//   });
// }
