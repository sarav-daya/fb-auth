import 'package:fb_auth_provider/providers/profile/profile_provider.dart';
import 'package:fb_auth_provider/providers/profile/profile_state.dart';
import 'package:fb_auth_provider/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileProvider profileProvider;
  late final Function() _profileListener;
  @override
  void initState() {
    super.initState();
    print('initState');
    profileProvider = context.read<ProfileProvider>();
    _profileListener = profileProvider.addListener(errorDialogListener,
        fireImmediately: false);
    _getProfile();
  }

  void errorDialogListener(ProfileState state) {
    print('errorDialog');
    if (state.profileStatus == ProfileStatus.error) {
      errorDialog(context, state.error);
    }
  }

  @override
  void dispose() {
    print('dispose');
    _profileListener();
    super.dispose();
  }

  void _getProfile() {
    final String uid = context.read<fbAuth.User?>()!.uid;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getProfile(uid: 'uid');
    });
  }

  Widget _buildProfile() {
    final ProfileState profileState = context.watch<ProfileState>();

    if (profileState.profileStatus == ProfileStatus.initial) {
      return Container();
    } else if (profileState.profileStatus == ProfileStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (profileState.profileStatus == ProfileStatus.error) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/error.png',
              width: 75,
              height: 75,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Oooops!\nTry again',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      );
    }
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/loading.gif',
            image: profileState.user.profileImage,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-id: ${profileState.user.id}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '-name: ${profileState.user.name}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '-email: ${profileState.user.email}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '-point: ${profileState.user.point}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '-rank: ${profileState.user.rank}',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _buildProfile(),
    );
  }
}
