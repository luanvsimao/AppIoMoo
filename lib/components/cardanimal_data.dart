// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:iomoo/utilities/colors.dart';
import 'package:iomoo/utilities/typography.dart';

import '../utilities/icons.dart';

class CardAnimalData extends StatelessWidget {
  final String name;
  final String id;
  final int heartRate;

  const CardAnimalData({
    Key? key,
    required this.name,
    required this.id,
    required this.heartRate,
  }) : super(key: key);

  String getStatus() {
    if (heartRate < 80) {
      return 'Calmo';
    } else if (heartRate >= 80 && heartRate <= 100) {
      return 'Agitado';
    } else {
      return 'Estressado';
    }
  }

  Color getStatusColor() {
    if (heartRate < 80) {
      return AppColors.calmState;
    } else if (heartRate >= 80 && heartRate <= 100) {
      return AppColors.agitatedState;
    } else {
      return AppColors.stressedState;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = getStatus();
    final Color color = getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: (Container(
        margin: const EdgeInsets.only(left: 6, right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        height: 120,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  width: 66,
                  height: 66,
                  child: CircleAvatar(
                    backgroundColor: AppColors.avatar.withOpacity(0.10),
                    backgroundImage:
                        const AssetImage('assets/images/cow-avatar.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      child: Text(
                        name,
                        style: AppTypography.headingCard,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 20,
                      child: Opacity(
                        opacity: 0.3,
                        child: Text(
                          '#$id',
                          style: AppTypography.body,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(94),
                    color: color.withOpacity(0.3),
                  ),
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  alignment: Alignment.center,
                  child: Text(
                    status,
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      AppIcons.heart,
                      const SizedBox(
                          width: 10), // espaço entre o ícone e o texto
                      Text(
                        '$heartRate BPM',
                        style: const TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
