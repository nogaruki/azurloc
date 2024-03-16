import 'package:flutter/material.dart';
import 'activity_detail_page.dart';
import 'models/activity_model.dart';
import 'package:azurloc/services/activity_service.dart';


class ActivityList extends StatefulWidget {
  const ActivityList({super.key});

  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  List<Activity> activities = []; // Assurez-vous que cela correspond à vos données mock


  void _getActivities() {
    final activityService = ActivityService();
    activityService.getAll().then((data) {
      setState(() {
        activities = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            leading: Image.network(activity.image),
            title: Text(activity.title),
            subtitle: Text('${activity.place} - ${activity.price}€'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ActivityDetailPage(activity: activity),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

