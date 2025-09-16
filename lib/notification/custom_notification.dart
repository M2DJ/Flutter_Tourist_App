import 'package:flutter/material.dart';

class CustomNotification extends StatelessWidget {
  final String? title;
  final String? imagePath;
  final String? time;
  final String? content;
  final VoidCallback? onTap;
  const CustomNotification({
    super.key,
    this.title,
    this.imagePath,
    this.time,
    this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (title == null || imagePath == null || time == null || content == null) {
      return const SizedBox.shrink(); // Return empty widget if any required field is null
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 80,
        maxHeight: 120,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withAlpha(25)),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue.withAlpha(25),
                    backgroundImage: imagePath!.isNotEmpty 
                        ? AssetImage(imagePath!) 
                        : null,
                    child: imagePath!.isEmpty 
                        ? const Icon(Icons.notifications, color: Colors.blue, size: 20)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: [
                          Expanded(
                            child: Text(
                              title!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            time!,
                            style: TextStyle(
                              color: Colors.grey.shade600, 
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Text(
                          content!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
