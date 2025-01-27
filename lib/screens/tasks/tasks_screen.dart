import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: TodoList(),
    );
  }
}

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime dueDate;
  Priority priority;
  DateTime createdAt;
  List<String> tags;
  String? category;
  bool isImportant;
  int? estimatedMinutes;

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.dueDate,
    this.priority = Priority.medium,
    this.tags = const [],
    this.category,
    this.isImportant = false,
    this.estimatedMinutes,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'dueDate': dueDate.toIso8601String(),
    'priority': priority.index,
    'createdAt': createdAt.toIso8601String(),
    'tags': tags,
    'category': category,
    'isImportant': isImportant,
    'estimatedMinutes': estimatedMinutes,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    description: json['description'],
    isCompleted: json['isCompleted'],
    dueDate: DateTime.parse(json['dueDate']),
    priority: Priority.values[json['priority']],
    tags: List<String>.from(json['tags'] ?? []),
    category: json['category'],
    isImportant: json['isImportant'] ?? false,
    estimatedMinutes: json['estimatedMinutes'],
  )
    ..id = json['id']
    ..createdAt = DateTime.parse(json['createdAt']);
}

enum Priority { low, medium, high }
enum TaskFilter { all, active, completed, important, today, upcoming }

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> with SingleTickerProviderStateMixin {
  final List<Task> _tasks = [];
  late TabController _tabController;
  TaskFilter _currentFilter = TaskFilter.all;
  final _prefs = SharedPreferences.getInstance();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // New fields for statistics
  int get _completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get _totalTasks => _tasks.length;
  double get _completionRate => _totalTasks == 0 ? 0 : _completedTasks / _totalTasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: TaskFilter.values.length, vsync: this);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await _prefs;
    final tasksJson = prefs.getStringList('tasks') ?? [];
    setState(() {
      _tasks.addAll(
        tasksJson.map((t) => Task.fromJson(jsonDecode(t))).toList(),
      );
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await _prefs;
    final tasksJson = _tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void _addTask(Task task) {
    setState(() {
      _tasks.insert(0, task);
      _saveTasks();
    });
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
  }

  void _toggleTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
      _saveTasks();
    });
  }

  void _deleteTask(String id, int index) {
    final removedTask = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
      _saveTasks();
    });
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildTaskCard(removedTask, animation, index),
      duration: const Duration(milliseconds: 500),
    );
  }

  void _toggleImportant(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isImportant = !task.isImportant;
      _saveTasks();
    });
  }

  List<Task> get _filteredTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_currentFilter) {
      case TaskFilter.active:
        return _tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.important:
        return _tasks.where((t) => t.isImportant).toList();
      case TaskFilter.today:
        return _tasks.where((t) {
          final taskDate = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
          return taskDate.isAtSameMomentAs(today);
        }).toList();
      case TaskFilter.upcoming:
        return _tasks.where((t) {
          final taskDate = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
          return taskDate.isAfter(today);
        }).toList();
      default:
        return _tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(
              TaskFilter.values.length,
              (index) => _buildTaskList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return AnimationLimiter(
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _filteredTasks.length,
        itemBuilder: (context, index, animation) {
          return _buildTaskCard(_filteredTasks[index], animation, index);
        },
      ),
    );
  }

  Widget _buildTaskCard(Task task, Animation<double> animation, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: TaskCard(
            task: task,
            onToggle: _toggleTask,
            onDelete: () => _deleteTask(task.id, index),
            onEdit: (task) => _showEditTaskDialog(task),
            onToggleImportant: () => _toggleImportant(task.id),
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        onSubmit: _addTask,
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        task: task,
        onSubmit: (updatedTask) {
          setState(() {
            final index = _tasks.indexWhere((t) => t.id == task.id);
            _tasks[index] = updatedTask;
            _saveTasks();
          });
        },
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Tasks'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter search term...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            // Implement search functionality
          },
        ),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort by'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Due Date'),
              onTap: () {
                setState(() {
                  _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.priority_high),
              title: const Text('Priority'),
              onTap: () {
                setState(() {
                  _tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.title),
              title: const Text('Title'),
              onTap: () {
                setState(() {
                  _tasks.sort((a, b) => a.title.compareTo(b.title));
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(String) onToggle;
  final VoidCallback onDelete;
  final Function(Task) onEdit;
  final VoidCallback onToggleImportant;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleImportant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Dismissible(
        key: Key(task.id),
        onDismissed: (_) => onDelete(),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: ExpansionTile(
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(task.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: theme.primaryColor,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: textTheme.titleMedium?.copyWith(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted ? Colors.grey : null,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  task.isImportant ? Icons.star : Icons.star_border,
                  color: task.isImportant ? Colors.amber : Colors.grey,
                ),
                onPressed: onToggleImportant,
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: theme.hintColor),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(task.dueDate),
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.priority_high, size: 16, color: _getPriorityColor(task.priority)),
                  const SizedBox(width: 4),
                  Text(
                    task.priority.toString().split('.')[1].toUpperCase(),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              if (task.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: task.tags.map((tag) => Chip(
                    label: Text(tag),
                    labelStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
                    backgroundColor: theme.primaryColor.withOpacity(0.8),
                    padding: const EdgeInsets.all(0),
                  )).toList(),
                ),
              ],
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(task),
          ),
          children: [
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            if (task.estimatedMinutes != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.timer),
                    const SizedBox(width: 8),
                    Text(
                      'Estimated time: ${task.estimatedMinutes} minutes',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }
}

class TaskDialog extends StatefulWidget {
  final Task? task;
  final Function(Task) onSubmit;

  const TaskDialog({
    Key? key,
    this.task,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagController;
  late DateTime _dueDate;
  late Priority _priority;
  late List<String> _tags;
  late bool _isImportant;
  late TextEditingController _estimatedMinutesController;
  late String? _category;

  final List<String> _availableCategories = [
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Education',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _tagController = TextEditingController();
    _estimatedMinutesController = TextEditingController(
      text: widget.task?.estimatedMinutes?.toString() ?? '',
    );
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _priority = widget.task?.priority ?? Priority.medium;
    _tags = widget.task?.tags ?? [];
    _isImportant = widget.task?.isImportant ?? false;
    _category = widget.task?.category;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Due Date'),
                    subtitle: Text(DateFormat('MMM dd, yyyy').format(_dueDate)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _dueDate = date);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<Priority>(
                    value: _priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: Priority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(
                            priority.toString().split('.')[1].toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _priority = value!);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('No Category'),
                ),
                ..._availableCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() => _category = value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _estimatedMinutesController,
              decoration: const InputDecoration(
                labelText: 'Estimated Minutes',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      labelText: 'Add Tag',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_tagController.text.isNotEmpty) {
                      setState(() {
                        _tags.add(_tagController.text);
                        _tagController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            if (_tags.isNotEmpty)
              Wrap(
                spacing: 8,
                children: _tags.map((tag) =>
                    Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(tag);
                        });
                      },
                    )).toList(),
              ),
            CheckboxListTile(
              title: const Text('Mark as Important'),
              value: _isImportant,
              onChanged: (value) {
                setState(() => _isImportant = value!);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final task = Task(
              title: _titleController.text,
              description: _descriptionController.text,
              dueDate: _dueDate,
              priority: _priority,
              tags: _tags,
              category: _category,
              isImportant: _isImportant,
              estimatedMinutes: int.tryParse(_estimatedMinutesController.text),
            );
            widget.onSubmit(task);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}