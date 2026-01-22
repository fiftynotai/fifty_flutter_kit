import 'package:fifty_forms/fifty_forms.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Dynamic form demonstrating:
/// - FiftyFormArray for repeating field groups
/// - Add/remove items dynamically
/// - Min/max constraints
class DynamicFormDemo extends StatefulWidget {
  const DynamicFormDemo({super.key});

  @override
  State<DynamicFormDemo> createState() => _DynamicFormDemoState();
}

class _DynamicFormDemoState extends State<DynamicFormDemo> {
  late final FiftyFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FiftyFormController(
      initialValues: {
        'projectName': '',
        'description': '',
      },
      validators: {
        'projectName': [
          const Required(message: 'Project name is required'),
          const MinLength(3, message: 'At least 3 characters'),
        ],
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    await _controller.submit((values) async {
      // Collect array values
      final tasks = _controller.getArrayValues('tasks');
      final teamMembers = _controller.getArrayValues('team');

      debugPrint('Project: ${values['projectName']}');
      debugPrint('Description: ${values['description']}');
      debugPrint('Tasks: $tasks');
      debugPrint('Team: $teamMembers');

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Project created with ${tasks.length} tasks and ${teamMembers.length} team members'),
          backgroundColor: FiftyColors.igrisGreen,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROJECT BUILDER'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(FiftySpacing.xl),
        child: FiftyForm(
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'CREATE PROJECT',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: FiftyColors.terminalWhite,
                      fontFamily: FiftyTypography.fontFamilyHeadline,
                      letterSpacing: 2,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FiftySpacing.sm),
              Text(
                'Define project details, tasks, and team members',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FiftyColors.hyperChrome,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FiftySpacing.xxxl),

              // Project Details Section
              _SectionHeader(
                title: 'PROJECT DETAILS',
                icon: Icons.folder_outlined,
              ),
              const SizedBox(height: FiftySpacing.lg),
              FiftyTextFormField(
                name: 'projectName',
                controller: _controller,
                label: 'PROJECT NAME',
                hint: 'Enter project name',
                prefix: const Icon(Icons.title, size: 20),
              ),
              const SizedBox(height: FiftySpacing.lg),
              FiftyTextFormField(
                name: 'description',
                controller: _controller,
                label: 'DESCRIPTION',
                hint: 'Describe your project (optional)',
                maxLines: 3,
                minLines: 2,
                prefix: const Icon(Icons.description_outlined, size: 20),
              ),
              const SizedBox(height: FiftySpacing.xxxl),

              // Tasks Array Section
              _SectionHeader(
                title: 'TASKS',
                icon: Icons.checklist,
                subtitle: 'Add up to 10 tasks (minimum 1)',
              ),
              const SizedBox(height: FiftySpacing.lg),
              FiftyFormArray(
                controller: _controller,
                name: 'tasks',
                minItems: 1,
                maxItems: 10,
                initialCount: 1,
                itemBuilder: (context, index, remove) {
                  return _TaskItem(
                    controller: _controller,
                    index: index,
                  );
                },
                addButtonBuilder: (add) {
                  return FiftyButton(
                    onPressed: add,
                    label: 'ADD TASK',
                    icon: Icons.add,
                    variant: FiftyButtonVariant.ghost,
                    expanded: true,
                  );
                },
              ),
              const SizedBox(height: FiftySpacing.xxxl),

              // Team Members Array Section
              _SectionHeader(
                title: 'TEAM MEMBERS',
                icon: Icons.group_outlined,
                subtitle: 'Add up to 5 team members (optional)',
              ),
              const SizedBox(height: FiftySpacing.lg),
              FiftyFormArray(
                controller: _controller,
                name: 'team',
                minItems: 0,
                maxItems: 5,
                initialCount: 0,
                itemBuilder: (context, index, remove) {
                  return _TeamMemberItem(
                    controller: _controller,
                    index: index,
                  );
                },
                addButtonBuilder: (add) {
                  return FiftyButton(
                    onPressed: add,
                    label: 'ADD TEAM MEMBER',
                    icon: Icons.person_add,
                    variant: FiftyButtonVariant.ghost,
                    expanded: true,
                  );
                },
              ),
              const SizedBox(height: FiftySpacing.xxxl),

              // Summary Card
              _SummaryCard(controller: _controller),
              const SizedBox(height: FiftySpacing.xl),

              // Submit button
              FiftySubmitButton(
                controller: _controller,
                label: 'CREATE PROJECT',
                loadingText: 'CREATING',
                onPressed: _handleSubmit,
                expanded: true,
                disableWhenInvalid: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: FiftyColors.crimsonPulse.withValues(alpha: 0.2),
            borderRadius: FiftyRadii.smRadius,
          ),
          child: Icon(
            icon,
            color: FiftyColors.crimsonPulse,
            size: 18,
          ),
        ),
        const SizedBox(width: FiftySpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.titleSmall,
                  fontWeight: FiftyTypography.bold,
                  letterSpacing: FiftyTypography.letterSpacingLabel,
                  color: FiftyColors.terminalWhite,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: FiftyColors.hyperChrome,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TaskItem extends StatelessWidget {
  final FiftyFormController controller;
  final int index;

  const _TaskItem({
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final titleName = 'tasks[$index].title';
    final priorityName = 'tasks[$index].priority';

    // Register validators for this task
    _registerValidators();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FiftyTextFormField(
          name: titleName,
          controller: controller,
          validators: [
            const Required(message: 'Task title is required'),
          ],
          label: 'TASK TITLE',
          hint: 'What needs to be done?',
          prefix: const Icon(Icons.task_alt, size: 20),
        ),
        const SizedBox(height: FiftySpacing.md),
        FiftyDropdownFormField<String>(
          name: priorityName,
          controller: controller,
          label: 'PRIORITY',
          items: const [
            FiftyDropdownItem(value: 'low', label: 'Low'),
            FiftyDropdownItem(value: 'medium', label: 'Medium'),
            FiftyDropdownItem(value: 'high', label: 'High'),
            FiftyDropdownItem(value: 'critical', label: 'Critical'),
          ],
          initialValue: 'medium',
        ),
      ],
    );
  }

  void _registerValidators() {
    final titleName = 'tasks[$index].title';
    if (controller.getValue(titleName) == null) {
      controller.registerField(titleName, validators: [
        const Required(message: 'Task title is required'),
      ]);
    }
  }
}

class _TeamMemberItem extends StatelessWidget {
  final FiftyFormController controller;
  final int index;

  const _TeamMemberItem({
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final nameName = 'team[$index].name';
    final roleName = 'team[$index].role';
    final emailName = 'team[$index].email';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FiftyTextFormField(
          name: nameName,
          controller: controller,
          validators: [
            const Required(message: 'Name is required'),
          ],
          label: 'NAME',
          hint: 'Team member name',
          prefix: const Icon(Icons.person_outline, size: 20),
        ),
        const SizedBox(height: FiftySpacing.md),
        FiftyTextFormField(
          name: roleName,
          controller: controller,
          label: 'ROLE',
          hint: 'e.g., Developer, Designer',
          prefix: const Icon(Icons.work_outline, size: 20),
        ),
        const SizedBox(height: FiftySpacing.md),
        FiftyTextFormField(
          name: emailName,
          controller: controller,
          validators: [
            const Email(message: 'Enter a valid email'),
          ],
          label: 'EMAIL',
          hint: 'team@fifty.ai',
          keyboardType: TextInputType.emailAddress,
          prefix: const Icon(Icons.email_outlined, size: 20),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final FiftyFormController controller;

  const _SummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final tasks = controller.getArrayValues('tasks');
        final team = controller.getArrayValues('team');
        final projectName = controller.getValue<String>('projectName') ?? '';

        return Container(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          decoration: BoxDecoration(
            color: FiftyColors.voidBlack,
            borderRadius: FiftyRadii.lgRadius,
            border: Border.all(color: FiftyColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.summarize_outlined,
                    color: FiftyColors.hyperChrome,
                    size: 18,
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Text(
                    'PROJECT SUMMARY',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.labelMedium,
                      fontWeight: FiftyTypography.bold,
                      letterSpacing: FiftyTypography.letterSpacingLabel,
                      color: FiftyColors.hyperChrome,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FiftySpacing.lg),
              _SummaryRow(
                label: 'Project',
                value: projectName.isEmpty ? '(not set)' : projectName,
                isEmpty: projectName.isEmpty,
              ),
              const SizedBox(height: FiftySpacing.sm),
              _SummaryRow(
                label: 'Tasks',
                value: '${tasks.length}',
                highlight: tasks.isNotEmpty,
              ),
              const SizedBox(height: FiftySpacing.sm),
              _SummaryRow(
                label: 'Team Members',
                value: team.isEmpty ? 'None' : '${team.length}',
                isEmpty: team.isEmpty,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isEmpty;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isEmpty = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.body,
            color: FiftyColors.hyperChrome,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.body,
            fontWeight: FiftyTypography.medium,
            color: isEmpty
                ? FiftyColors.hyperChrome.withValues(alpha: 0.5)
                : highlight
                    ? FiftyColors.igrisGreen
                    : FiftyColors.terminalWhite,
          ),
        ),
      ],
    );
  }
}
