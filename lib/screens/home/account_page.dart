import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  double fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          'assets/image/mind.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage('assets/image/mind.jpg'),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .scale(delay: 200.ms),
                          SizedBox(height: 16),
                          Text(
                            'John Doe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ).animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Personal Information',
                    [
                      _buildInfoCard(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        subtitle: 'john.doe@example.com',
                      ),
                      _buildInfoCard(
                        icon: Icons.phone_outlined,
                        title: 'Phone',
                        subtitle: '+1 234 567 890',
                      ),
                      _buildInfoCard(
                        icon: Icons.location_on_outlined,
                        title: 'Location',
                        subtitle: 'New York, USA',
                      ),
                    ],
                  ),
                  
                  _buildSection(
                    'App Settings',
                    [
                      _buildSettingTile(
                        'Dark Mode',
                        'Change app theme',
                        trailing: Switch.adaptive(
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() => isDarkMode = value);
                          },
                        ),
                      ),
                      _buildSettingTile(
                        'Notifications',
                        'Enable push notifications',
                        trailing: Switch.adaptive(
                          value: isNotificationsEnabled,
                          onChanged: (value) {
                            setState(() => isNotificationsEnabled = value);
                          },
                        ),
                      ),
                      _buildSettingTile(
                        'Text Size',
                        'Adjust app text size',
                        trailing: SizedBox(
                          width: 150,
                          child: Slider.adaptive(
                            value: fontSize,
                            min: 12,
                            max: 24,
                            divisions: 4,
                            label: fontSize.round().toString(),
                            onChanged: (value) {
                              setState(() => fontSize = value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  _buildSection(
                    'Privacy & Security',
                    [
                      _buildSettingTile(
                        'Change Password',
                        'Update your password',
                        onTap: () {
                          // TODO: Implement password change
                        },
                      ),
                      _buildSettingTile(
                        'Two-Factor Authentication',
                        'Add extra security to your account',
                        onTap: () {
                          // TODO: Implement 2FA
                        },
                      ),
                      _buildSettingTile(
                        'Privacy Policy',
                        'Read our privacy policy',
                        onTap: () {
                          // TODO: Show privacy policy
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      icon: Icon(Icons.logout, color: Colors.red),
                      label: Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    ).animate()
      .fadeIn(duration: 600.ms)
      .slideX(begin: -0.2);
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
