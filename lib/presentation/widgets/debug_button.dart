import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DebugButton extends StatelessWidget {
  const DebugButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    assert(() {
      return true;
    }());
    
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.black.withOpacity(0.7),
      child: const Icon(
        Icons.bug_report,
        color: Colors.white,
      ),
      onPressed: () {
        final talker = Provider.of<Talker>(context, listen: false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TalkerScreen(
              talker: talker,
              appBarTitle: 'Debug Logs',
              theme: TalkerScreenTheme(
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
} 