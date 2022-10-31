import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class GetLocationWidget extends StatefulWidget {
  const GetLocationWidget({super.key});

  @override
  State<GetLocationWidget> createState() => _GetLocationWidgetState();
}

class _GetLocationWidgetState extends State<GetLocationWidget> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final ref1 = FirebaseDatabase.instance.ref().child;

  void getLat(double? latitude) async {
    final Map<double, Map> updates = {};
    await ref1('users/$uid').update({
      'latitude': latitude,
    });
  }
  void getLong(double? longitude) async {
    final Map<double, Map> updates = {};
    await ref1('users/$uid').update({
      'longitude': longitude,
    });
  }
  bool _loading = false;

  LocationData? _location;
  String? _error;

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final _locationResult = await getLocation(
        settings: LocationSettings(ignoreLastKnownPosition: true),
      );

      setState(() {

        _location = _locationResult;
        getLat(_location?.latitude);
        getLong(_location?.longitude);
        _loading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _error ??
                'Location: ${_location?.latitude}, ${_location?.longitude}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: _getLocation,
                child: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Get'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
