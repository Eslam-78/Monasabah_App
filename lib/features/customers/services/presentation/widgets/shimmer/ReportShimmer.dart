import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.grey[300],
            ),
            title: Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.grey[300],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Divider(),
                Container(
                  width: double.infinity,
                  height: 14.0,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 14.0,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 14.0,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 14.0,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
