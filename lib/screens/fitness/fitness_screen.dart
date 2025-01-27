import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({Key? key}) : super(key: key);

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showMotivationalQuote = true;
  int _selectedActivityIndex = -1;

  final List<WorkoutActivity> _activities = [
    WorkoutActivity(
      icon: Icons.directions_run,
      title: 'Running',
      subtitle: '5.2 km',
      color: Colors.blue,
      stats: {
        'Pace': '5:30 min/km',
        'Calories': '450 kcal',
        'Duration': '45 mins',
        'Heart Rate': '145 bpm'
      },
    ),
    WorkoutActivity(
      icon: Icons.fitness_center,
      title: 'Strength Training',
      subtitle: '45 mins',
      color: Colors.purple,
      stats: {
        'Sets': '15',
        'Reps': '180',
        'Calories': '320 kcal',
        'Heart Rate': '135 bpm'
      },
    ),
    WorkoutActivity(
      icon: Icons.directions_bike,
      title: 'Cycling',
      subtitle: '10 km',
      color: Colors.green,
      stats: {
        'Speed': '20 km/h',
        'Calories': '280 kcal',
        'Duration': '30 mins',
        'Heart Rate': '128 bpm'
      },
    ),
    WorkoutActivity(
      icon: Icons.pool,
      title: 'Swimming',
      subtitle: '30 mins',
      color: Colors.orange,
      stats: {
        'Laps': '20',
        'Distance': '1000m',
        'Calories': '400 kcal',
        'Heart Rate': '140 bpm'
      },
    ),
  ];

  final List<Achievement> _achievements = [
    Achievement(
      icon: Icons.local_fire_department,
      title: '7 Day Streak',
      progress: 0.7,
      color: Colors.orange,
    ),
    Achievement(
      icon: Icons.emoji_events,
      title: 'Distance Champion',
      progress: 0.9,
      color: Colors.amber,
    ),
    Achievement(
      icon: Icons.wb_sunny,
      title: 'Early Bird',
      progress: 1.0,
      color: Colors.blue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_showMotivationalQuote) _buildMotivationalBanner(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 25),
                  _buildTabBar(),
                  const SizedBox(height: 20),
                  _buildTabContent(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Fitness Tracker',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Color(0xFF1E88E5)),
          onPressed: _showCalendarView,
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Color(0xFF1E88E5)),
          onPressed: _showProfile,
        ),
      ],
    );
  }

  Widget _buildMotivationalBanner() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
          children: [
          const Icon(Icons.emoji_emotions, color: Colors.amber, size: 30),
      const SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
          Text(
            'Keep pushing yourself!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
              'Youre doing great! Just 2,315 steps to reach your daily goal.',
          style: TextStyle(color: Colors.grey),
        ),
        ],
      ),
    ),
    IconButton(
    icon: const Icon(Icons.close, color: Colors.grey),
    onPressed: () {
    setState(() {
    _showMotivationalQuote = false;
    });
    },
    ),
    ],
    ),
    );
    }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Steps', '7,685', Icons.directions_walk),
                _buildSummaryItem('Calories', '456', Icons.local_fire_department),
                _buildSummaryItem('Minutes', '65', Icons.timer),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Goal Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Daily Goal: 10,000 steps',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFF1E88E5),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: 'Activities'),
          Tab(text: 'Progress'),
          Tab(text: 'Achievements'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 500, // Adjust based on content
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildActivitiesList(),
          _buildWeeklyProgress(),
          _buildAchievements(),
        ],
      ),
    );
  }

  Widget _buildActivitiesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _activities.length,
      itemBuilder: (context, index) {
        final activity = _activities[index];
        final isSelected = _selectedActivityIndex == index;

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedActivityIndex = isSelected ? -1 : index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: activity.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            activity.icon,
                            color: activity.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                activity.subtitle,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      ],
                    ),
                    if (isSelected) ...[
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      _buildActivityStats(activity),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivityStats(WorkoutActivity activity) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      physics: const NeverScrollableScrollPhysics(),
      children: activity.stats.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                entry.value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeeklyProgress() {
    return Container(
        padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    spreadRadius: 1,
    blurRadius: 5,
    ),
    ],
    ),
    child: Column(
    children: [
    const Text(
    'Weekly Activity Overview',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 20),
    SizedBox(
    height: 200,
    child: BarChart(
    BarChartData(
    alignment: BarChartAlignment.spaceAround,
    maxY: 1.0,
    barTouchData: BarTouchData(enabled: false),
    titlesData: FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
    sideTitles: SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
    const titles = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Text(
    titles[value.toInt()],
    style: const TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
    ),
    );
    },
    ),
    ),
    leftTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
    ),
    ),
    borderData: FlBorderData(show: false),
    gridData: FlGridData(show: false),
    barGroups: [0.6, 0.8, 0.4, 0.9, 0.5, 0.3, 0.7]
        .asMap()
        .entries
        .map((entry) {
    return BarChartGroupData(x: entry.key,
      barRods: [
        BarChartRodData(
          toY: entry.value,
          color: const Color(0xFF1E88E5),
          width: 20,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(6),
          ),
        ),
      ],
    );
    }).toList(),
    ),
    ),
    ),
    ],
    ),
    );
  }

  Widget _buildAchievements() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: achievement.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      achievement.icon,
                      color: achievement.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: achievement.progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(achievement.color),
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    '${(achievement.progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF1E88E5),
      onPressed: _showAddActivityDialog,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Start Activity',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _showAddActivityDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Start New Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: activity.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        activity.icon,
                        color: activity.color,
                      ),
                    ),
                    title: Text(activity.title),
                    subtitle: Text('Tap to start tracking'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(context);
                      _showStartActivityConfirmation(activity);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStartActivityConfirmation(WorkoutActivity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start ${activity.title}'),
        content: const Text('Are you ready to start tracking this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Started tracking ${activity.title}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showCalendarView() {
    // TODO: Implement calendar view
  }

  void _showProfile() {
    // TODO: Implement profile view
  }
}

class WorkoutActivity {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Map<String, String> stats;

  WorkoutActivity({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.stats,
  });
}

class Achievement {
  final IconData icon;
  final String title;
  final double progress;
  final Color color;

  Achievement({
    required this.icon,
    required this.title,
    required this.progress,
    required this.color,
  });
}