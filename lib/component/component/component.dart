import 'package:chat_gpt/component/color/color.dart';
import 'package:flutter/material.dart';

Widget defaultFeatures({
  required Color color,
  required String headText,
  required String text,
}) =>
    Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headText,
            style: const TextStyle(
                fontFamily: 'Cera Pro',
                color: colors.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Cera Pro',
                color: colors.blackColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
