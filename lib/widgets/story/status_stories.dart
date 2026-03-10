import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/post.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class StatusStories extends StatelessWidget {
  final List<Post> stories;
  final VoidCallback? onAddStory;

  const StatusStories({
    super.key,
    required this.stories,
    this.onAddStory,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      height: responsive.sp(110),
      padding: EdgeInsets.symmetric(vertical: responsive.sp(AppTheme.spacing8)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: responsive.sp(AppTheme.spacing12)),
        itemCount: stories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddStoryCard(
              onTap: onAddStory,
              responsive: responsive,
            );
          }
          
          final story = stories[index - 1];
          return _StoryCard(
            story: story,
            responsive: responsive,
          );
        },
      ),
    );
  }
}

class _AddStoryCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Responsive responsive;

  const _AddStoryCard({
    this.onTap,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: responsive.sp(70),
        margin: EdgeInsets.only(right: responsive.sp(AppTheme.spacing12)),
        child: Column(
          children: [
            Container(
              width: responsive.sp(65),
              height: responsive.sp(65),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.greenPrimary, AppTheme.greenDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.add,
                color: AppTheme.white,
                size: responsive.sp(30),
              ),
            ),
            SizedBox(height: responsive.sp(AppTheme.spacing4)),
            Text(
              'Your Story',
              style: TextStyle(
                fontSize: responsive.sp(11),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final Post story;
  final Responsive responsive;

  const _StoryCard({
    required this.story,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to story viewer
      },
      child: Container(
        width: responsive.sp(70),
        margin: EdgeInsets.only(right: responsive.sp(AppTheme.spacing12)),
        child: Column(
          children: [
            Container(
              width: responsive.sp(65),
              height: responsive.sp(65),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: story.isExpired
                    ? null
                    : const LinearGradient(
                        colors: [AppTheme.greenPrimary, AppTheme.alertOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: story.isExpired
                    ? Border.all(color: AppTheme.greySoft, width: 2)
                    : null,
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.white,
                ),
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: AppTheme.greySoft,
                  backgroundImage: story.userAvatar != null
                      ? CachedNetworkImageProvider(story.userAvatar!)
                      : null,
                  child: story.userAvatar == null
                      ? Icon(
                          Icons.person,
                          size: responsive.sp(24),
                          color: AppTheme.greyMedium,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: responsive.sp(AppTheme.spacing4)),
            Text(
              story.userName,
              style: TextStyle(
                fontSize: responsive.sp(11),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
