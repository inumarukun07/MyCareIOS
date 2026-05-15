import 'package:flutter/material.dart';

void main() {
  runApp(const CarePhotoboothApp());
}

class CarePhotoboothApp extends StatelessWidget {
  const CarePhotoboothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Care Photobooth Software',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
          primary: AppColors.accent,
          surface: AppColors.card,
        ),
        fontFamily: 'Inter',
      ),
      home: const OperatorShell(),
    );
  }
}

class AppColors {
  static const bg = Color(0xFF070A0F);
  static const sidebar = Color(0xFF0B111A);
  static const card = Color(0xFF111827);
  static const cardSoft = Color(0xFF151F2E);
  static const border = Color(0xFF263244);
  static const accent = Color(0xFF00C2FF);
  static const accent2 = Color(0xFF4D7CFF);
  static const text = Color(0xFFEAF2FF);
  static const muted = Color(0xFF8EA0B8);
  static const success = Color(0xFF35D07F);
  static const warning = Color(0xFFFFC857);
  static const danger = Color(0xFFFF5C7A);
}

enum NavKey {
  dashboard,
  eventSession,
  screenEditor,
  filter,
  print,
  camera,
  payment,
  sharing,
  template,
  tools,
  aboutAccount,
}

class NavItem {
  final NavKey key;
  final String section;
  final String title;
  final IconData icon;

  const NavItem({
    required this.key,
    required this.section,
    required this.title,
    required this.icon,
  });
}

const navItems = <NavItem>[
  NavItem(
    key: NavKey.dashboard,
    section: 'Dashboard',
    title: 'Main Dashboard',
    icon: Icons.dashboard_rounded,
  ),
  NavItem(
    key: NavKey.eventSession,
    section: 'Event',
    title: 'Event Session',
    icon: Icons.event_available_rounded,
  ),
  NavItem(
    key: NavKey.screenEditor,
    section: 'Screen Editor',
    title: 'Live & Capture Screen',
    icon: Icons.screenshot_monitor_rounded,
  ),
  NavItem(
    key: NavKey.filter,
    section: 'Filter',
    title: 'Filters Setup',
    icon: Icons.auto_awesome_rounded,
  ),
  NavItem(
    key: NavKey.print,
    section: 'Print',
    title: 'Printer & Margins',
    icon: Icons.print_rounded,
  ),
  NavItem(
    key: NavKey.camera,
    section: 'Camera',
    title: 'Camera Source',
    icon: Icons.photo_camera_rounded,
  ),
  NavItem(
    key: NavKey.payment,
    section: 'Payment',
    title: 'Payment Setup',
    icon: Icons.payments_rounded,
  ),
  NavItem(
    key: NavKey.sharing,
    section: 'Sharing',
    title: 'Cloud Sharing',
    icon: Icons.cloud_upload_rounded,
  ),
  NavItem(
    key: NavKey.template,
    section: 'Template',
    title: 'Template Manager',
    icon: Icons.grid_view_rounded,
  ),
  NavItem(
    key: NavKey.tools,
    section: 'Tools',
    title: 'Operator Tools',
    icon: Icons.tune_rounded,
  ),
  NavItem(
    key: NavKey.aboutAccount,
    section: 'About / Account',
    title: 'Account & License',
    icon: Icons.manage_accounts_rounded,
  ),
];

class AppState {
  String activeEvent = 'Wedding Nadia & Rizky';
  String eventFolder = '/CareBooth/Events/NadiaRizky';
  bool cameraConnected = true;
  bool printerReady = true;
  bool internetConnected = true;
  bool cloudPending = true;
  bool paymentEnabled = false;
  bool qrisOnly = true;
  bool googleDriveLoggedIn = true;
  bool careMemoriesUploading = true;
  bool wirelessConnected = false;
  String activeTemplate = 'Classic Peach 4R';
  String cameraSource = 'Canon EOS 80D';
  String printerName = 'Canon Selphy CP1500';
  int fullPrintPrice = 35000;
  int halfPrintPrice = 25000;
  int printQuantity = 2;
  bool showStart = true;
  bool showRetake = true;
  bool showPrint = true;
  bool showShare = true;
}

class OperatorShell extends StatefulWidget {
  const OperatorShell({super.key});

  @override
  State<OperatorShell> createState() => _OperatorShellState();
}

class _OperatorShellState extends State<OperatorShell> {
  final AppState state = AppState();
  NavKey selectedKey = NavKey.dashboard;

  void selectPage(NavKey key) {
    setState(() => selectedKey = key);
  }

  void showSavedToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.cardSoft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<bool> confirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title),
        content: Text(message, style: const TextStyle(color: AppColors.muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 980;
        return Scaffold(
          body: Row(
            children: [
              if (!compact)
                Sidebar(
                  selectedKey: selectedKey,
                  onSelect: selectPage,
                  state: state,
                ),
              Expanded(
                child: Column(
                  children: [
                    TopAppBar(
                      state: state,
                      compact: compact,
                      onOpenMenu: compact
                          ? () => Scaffold.of(context).openDrawer()
                          : null,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: PageRouter(
                            key: ValueKey(selectedKey),
                            selectedKey: selectedKey,
                            state: state,
                            onNavigate: selectPage,
                            onSaved: showSavedToast,
                            onConfirm: confirmDialog,
                            refresh: () => setState(() {}),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          drawer: compact
              ? Drawer(
                  backgroundColor: AppColors.sidebar,
                  child: Sidebar(
                    selectedKey: selectedKey,
                    onSelect: (key) {
                      Navigator.pop(context);
                      selectPage(key);
                    },
                    state: state,
                  ),
                )
              : null,
        );
      },
    );
  }
}

class TopAppBar extends StatelessWidget {
  final AppState state;
  final bool compact;
  final VoidCallback? onOpenMenu;

  const TopAppBar({
    super.key,
    required this.state,
    required this.compact,
    this.onOpenMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (compact)
            IconButton(
              onPressed: onOpenMenu,
              icon: const Icon(Icons.menu_rounded),
            ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.accent2]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Care Photobooth Software',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3),
                Text(
                  'Professional operator console',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          if (!compact) ...[
            StatusPill(
              icon: Icons.photo_camera_rounded,
              label: 'Camera',
              value: state.cameraConnected ? 'Connected' : 'Offline',
              color:
                  state.cameraConnected ? AppColors.success : AppColors.danger,
            ),
            const SizedBox(width: 10),
            StatusPill(
              icon: Icons.print_rounded,
              label: 'Printer',
              value: state.printerReady ? 'Ready' : 'Offline',
              color: state.printerReady ? AppColors.success : AppColors.danger,
            ),
            const SizedBox(width: 10),
            StatusPill(
              icon: Icons.cloud_sync_rounded,
              label: 'Cloud',
              value: state.internetConnected ? 'Sync' : 'No Internet',
              color: state.internetConnected
                  ? AppColors.accent
                  : AppColors.warning,
            ),
          ],
          const SizedBox(width: 10),
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.settings_rounded),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.cardSoft,
            child: const Icon(Icons.person_rounded, color: AppColors.text),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final NavKey selectedKey;
  final ValueChanged<NavKey> onSelect;
  final AppState state;

  const Sidebar({
    super.key,
    required this.selectedKey,
    required this.onSelect,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292,
      color: AppColors.sidebar,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.favorite_rounded,
                      color: AppColors.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Active Event',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(
                        state.activeEvent,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.separated(
              itemCount: navItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = navItems[index];
                final selected = item.key == selectedKey;
                final showHeader =
                    index == 0 || navItems[index - 1].section != item.section;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
                        child: Text(
                          item.section.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .9,
                          ),
                        ),
                      ),
                    ],
                    InkWell(
                      onTap: () => onSelect(item.key),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.accent.withOpacity(.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: selected
                                  ? AppColors.accent.withOpacity(.55)
                                  : Colors.transparent),
                        ),
                        child: Row(
                          children: [
                            Icon(item.icon,
                                color: selected
                                    ? AppColors.accent
                                    : AppColors.muted),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  color: selected
                                      ? AppColors.text
                                      : AppColors.muted,
                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PageRouter extends StatelessWidget {
  final NavKey selectedKey;
  final AppState state;
  final ValueChanged<NavKey> onNavigate;
  final ValueChanged<String> onSaved;
  final Future<bool> Function(
      {required String title,
      required String message,
      String confirmText}) onConfirm;
  final VoidCallback refresh;

  const PageRouter({
    super.key,
    required this.selectedKey,
    required this.state,
    required this.onNavigate,
    required this.onSaved,
    required this.onConfirm,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedKey) {
      case NavKey.dashboard:
        return DashboardPage(state: state, onNavigate: onNavigate);
      case NavKey.eventSession:
        return EventPage(state: state, onSaved: onSaved);
      case NavKey.screenEditor:
        return ScreenEditorPage(
            state: state, onSaved: onSaved, refresh: refresh);
      case NavKey.filter:
        return FilterPage(onSaved: onSaved);
      case NavKey.print:
        return PrintPage(state: state, onSaved: onSaved, refresh: refresh);
      case NavKey.camera:
        return CameraPage(state: state, onSaved: onSaved, refresh: refresh);
      case NavKey.payment:
        return PaymentPage(state: state, onSaved: onSaved, refresh: refresh);
      case NavKey.sharing:
        return SharingPage(state: state, onSaved: onSaved, refresh: refresh);
      case NavKey.template:
        return TemplatePage(state: state, onSaved: onSaved, refresh: refresh);
      case NavKey.tools:
        return ToolsPage(
            state: state,
            onSaved: onSaved,
            onConfirm: onConfirm,
            refresh: refresh);
      case NavKey.aboutAccount:
        return AboutAccountPage(
            state: state, onConfirm: onConfirm, onSaved: onSaved);
    }
  }
}

class DashboardPage extends StatelessWidget {
  final AppState state;
  final ValueChanged<NavKey> onNavigate;

  const DashboardPage(
      {super.key, required this.state, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Main Dashboard',
      description:
          'Ringkasan status operasional photobooth untuk operator event.',
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1180 ? 3 : 2;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: constraints.maxWidth > 1180 ? 2.35 : 2.15,
                  children: [
                    StatusCard(
                        title: 'Event Active',
                        value: state.activeEvent,
                        icon: Icons.event_rounded,
                        status: 'Active',
                        color: AppColors.success),
                    StatusCard(
                        title: 'Camera Status',
                        value: state.cameraSource,
                        icon: Icons.photo_camera_rounded,
                        status: state.cameraConnected ? 'Connected' : 'Offline',
                        color: state.cameraConnected
                            ? AppColors.success
                            : AppColors.danger),
                    StatusCard(
                        title: 'Printer Status',
                        value: state.printerName,
                        icon: Icons.print_rounded,
                        status: state.printerReady ? 'Ready' : 'Offline',
                        color: state.printerReady
                            ? AppColors.success
                            : AppColors.danger),
                    StatusCard(
                        title: 'Payment Status',
                        value: state.paymentEnabled
                            ? 'QRIS payment enabled'
                            : 'Payment disabled',
                        icon: Icons.qr_code_rounded,
                        status: state.paymentEnabled ? 'Active' : 'Inactive',
                        color: state.paymentEnabled
                            ? AppColors.success
                            : AppColors.warning),
                    StatusCard(
                        title: 'Cloud Upload Status',
                        value: state.cloudPending
                            ? '12 pending uploads'
                            : 'All files synced',
                        icon: Icons.cloud_upload_rounded,
                        status: state.cloudPending ? 'Pending' : 'Synced',
                        color: state.cloudPending
                            ? AppColors.warning
                            : AppColors.success),
                    StatusCard(
                        title: 'Template Active',
                        value: state.activeTemplate,
                        icon: Icons.dashboard_customize_rounded,
                        status: 'Active',
                        color: AppColors.accent),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: panelDecoration(),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(72),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded, size: 32),
                    label: const Text('START PHOTOBOOTH',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 3,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      QuickAction(
                          label: 'Camera Setup',
                          icon: Icons.photo_camera_rounded,
                          onTap: () => onNavigate(NavKey.camera)),
                      QuickAction(
                          label: 'Print Setup',
                          icon: Icons.print_rounded,
                          onTap: () => onNavigate(NavKey.print)),
                      QuickAction(
                          label: 'Template Setup',
                          icon: Icons.grid_view_rounded,
                          onTap: () => onNavigate(NavKey.template)),
                      QuickAction(
                          label: 'Payment Setup',
                          icon: Icons.payments_rounded,
                          onTap: () => onNavigate(NavKey.payment)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventPage extends StatelessWidget {
  final AppState state;
  final ValueChanged<String> onSaved;

  const EventPage({super.key, required this.state, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Event Session',
      description: 'Kelola event aktif, folder output, dan sesi photobooth.',
      status: 'Active',
      statusColor: AppColors.success,
      form: Column(
        children: [
          TextFieldCard(
              label: 'Nama Event Aktif', initialValue: state.activeEvent),
          TextFieldCard(label: 'Folder Event', initialValue: state.eventFolder),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child: LargeButton(
                      icon: Icons.add_rounded,
                      label: 'Create Event',
                      onTap: () {})),
              const SizedBox(width: 12),
              Expanded(
                  child: LargeButton(
                      icon: Icons.folder_open_rounded,
                      label: 'Open Event',
                      onTap: () {})),
            ],
          ),
        ],
      ),
      preview: FolderPreview(folder: state.eventFolder),
      onSaved: () => onSaved('Event setting saved'),
    );
  }
}

class ScreenEditorPage extends StatelessWidget {
  final AppState state;
  final ValueChanged<String> onSaved;
  final VoidCallback refresh;

  const ScreenEditorPage(
      {super.key,
      required this.state,
      required this.onSaved,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Screen Editor',
      description:
          'Atur live view, capture screen, dan tombol yang muncul di layar photobooth.',
      status: 'Editing',
      statusColor: AppColors.accent,
      form: Column(
        children: [
          SwitchCard(
              title: 'Live View Setting', value: true, onChanged: (_) {}),
          SwitchCard(
              title: 'Capture Screen Setting', value: true, onChanged: (_) {}),
          SwitchCard(
              title: 'Show Start Button',
              value: state.showStart,
              onChanged: (v) {
                state.showStart = v;
                refresh();
              }),
          SwitchCard(
              title: 'Show Retake Button',
              value: state.showRetake,
              onChanged: (v) {
                state.showRetake = v;
                refresh();
              }),
          SwitchCard(
              title: 'Show Print Button',
              value: state.showPrint,
              onChanged: (v) {
                state.showPrint = v;
                refresh();
              }),
          SwitchCard(
              title: 'Show Share Button',
              value: state.showShare,
              onChanged: (v) {
                state.showShare = v;
                refresh();
              }),
        ],
      ),
      preview: PhotoboothScreenPreview(state: state),
      onSaved: () => onSaved('Screen editor setting saved'),
    );
  }
}

class FilterPage extends StatelessWidget {
  final ValueChanged<String> onSaved;

  const FilterPage({super.key, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    final filters = [
      'Clean',
      'Warm',
      'BW',
      'Vintage',
      'Cinematic',
      'Soft Glow',
      'High Key',
      'Moody'
    ];
    return FeaturePage(
      title: 'Filters Setup',
      description: 'Pilih filter foto dan cek preview sebelum/sesudah.',
      status: '6 Active',
      statusColor: AppColors.success,
      form: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filters.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.6,
            ),
            itemBuilder: (context, index) =>
                FilterTile(name: filters[index], active: index != 2),
          ),
        ],
      ),
      preview: const BeforeAfterPreview(),
      onSaved: () => onSaved('Filter setup saved'),
    );
  }
}

class PrintPage extends StatelessWidget {
  final AppState state;
  final ValueChanged<String> onSaved;
  final VoidCallback refresh;

  const PrintPage(
      {super.key,
      required this.state,
      required this.onSaved,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Print Setup',
      description:
          'Cari printer, atur margin portrait/landscape, dan jumlah cetakan.',
      status: state.printerReady ? 'Ready' : 'Offline',
      statusColor: state.printerReady ? AppColors.success : AppColors.danger,
      form: Column(
        children: [
          DropdownCard(
              label: 'Pilihan Printer',
              value: state.printerName,
              items: const [
                'Canon Selphy CP1500',
                'DNP DS-RX1HS',
                'Epson L8050'
              ]),
          NumberFieldCard(label: 'Margin Portrait - Top', value: '12'),
          NumberFieldCard(label: 'Margin Portrait - Bottom', value: '12'),
          NumberFieldCard(label: 'Margin Landscape - Left', value: '8'),
          NumberFieldCard(label: 'Margin Landscape - Right', value: '8'),
          NumberFieldCard(
              label: 'Quantity Printing', value: '${state.printQuantity}'),
          const SizedBox(height: 12),
          LargeButton(
              icon: Icons.search_rounded,
              label: 'Searching Printer',
              onTap: () {}),
        ],
      ),
      preview: PrinterPreview(state: state),
      onSaved: () => onSaved('Print setting saved'),
    );
  }
}

class CameraPage extends StatelessWidget {
  final AppState state;
  final ValueChanged<String> onSaved;
  final VoidCallback refresh;

  const CameraPage(
      {super.key,
      required this.state,
      required this.onSaved,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Camera Source',
      description:
          'Pilih kamera Canon, Gopro, dummy camera, dan kontrol EVF LiveView.',
      status: state.cameraConnected ? 'Live View' : 'Disconnected',
      statusColor: state.cameraConnected ? AppColors.success : AppColors.danger,
      form: Column(
        children: [
          DropdownCard(
              label: 'Camera Source',
              value: state.cameraSource,
              items: const ['Canon EOS 80D', 'GoPro Hero', 'Camera Dummy']),
          SwitchCard(title: 'Camera Canon', value: true, onChanged: (_) {}),
          SwitchCard(title: 'Camera Gopro', value: false, onChanged: (_) {}),
          SwitchCard(title: 'Camera Dummy', value: false, onChanged: (_) {}),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: LargeButton(
                      icon: Icons.link_rounded,
                      label: 'Connect',
                      onTap: () {
                        state.cameraConnected = true;
                        refresh();
                      })),
              const SizedBox(width: 12),
              Expanded(
                  child: LargeButton(
                      icon: Icons.link_off_rounded,
                      label: 'Disconnect',
                      onTap: () {
                        state.cameraConnected = false;
                        refresh();
                      })),
            ],
          ),
          const SizedBox(height: 12),
          LargeButton(
              icon: Icons.videocam_off_rounded,
              label: 'Stop EVF LiveView',
              onTap: () {}),
        ],
      ),
      preview: CameraLivePreview(connected: state.cameraConnected),
      onSaved: () => onSaved('Camera setting saved'),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final AppState state;
  final ValueChanged<String> onSaved;
  final VoidCallback refresh;

  const PaymentPage(
      {super.key,
      required this.state,
      required this.onSaved,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Payment Setup',
      description:
          'Aktifkan pembayaran QRIS dan tentukan harga cetak full/half print.',
      status: state.paymentEnabled ? 'Active' : 'Inactive',
      statusColor: state.paymentEnabled ? AppColors.success : AppColors.warning,
      form: Column(
        children: [
          SwitchCard(
              title: 'Enable Payment',
              value: state.paymentEnabled,
              onChanged: (v) {
                state.paymentEnabled = v;
                refresh();
              }),
          SwitchCard(
              title: 'QRIS Only',
              value: state.qrisOnly,
              onChanged: (v) {
                state.qrisOnly = v;
                refresh();
              }),
          NumberFieldCard(
              label: 'Set Full Print Price', value: '${state.fullPrintPrice}'),
          NumberFieldCard(
              label: 'Set Half Print Price', value: '${state.halfPrintPrice}'),
        ],
      ),
      preview: PaymentPreview(enabled: state.paymentEnabled),
      onSaved: () => onSaved('Payment setting saved'),
    );
  }
}

class SharingPage extends StatelessWidget {
  final AppState state;
  final ValueChanged<String> onSaved;
  final VoidCallback refresh;

  const SharingPage(
      {super.key,
      required this.state,
      required this.onSaved,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Sharing & Cloud Upload',
      description:
          'Kelola Google Drive, CareMemories, pending upload, dan group key.',
      status: state.cloudPending ? 'Pending' : 'Synced',
      statusColor: state.cloudPending ? AppColors.warning : AppColors.success,
      form: Column(
        children: [
          SwitchCard(
              title: 'Google Drive Login',
              value: state.googleDriveLoggedIn,
              onChanged: (v) {
                state.googleDriveLoggedIn = v;
                refresh();
              }),
          SwitchCard(
              title: 'CareMemories Upload',
              value: state.careMemoriesUploading,
              onChanged: (v) {
                state.careMemoriesUploading = v;
                refresh();
              }),
          TextFieldCard(
              label: 'GroupKey Name', initialValue: 'nadia-rizky-2026'),
          const SizedBox(height: 12),
          LargeButton(
              icon: Icons.cloud_upload_rounded,
              label: 'Retry Pending Upload',
              onTap: () {}),
        ],
      ),
      preview: PendingUploadPreview(),
      onSaved: () => onSaved('Sharing setting saved'),
    );
  }
}

class TemplatePage extends StatelessWidget {
  final AppState state;
  final ValueChanged<String> onSaved;
  final VoidCallback refresh;

  const TemplatePage(
      {super.key,
      required this.state,
      required this.onSaved,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    final templates = [
      'Classic Peach 4R',
      'Minimal White',
      'Neon Party',
      'Elegant Black',
      'GIF Fun',
      'Boomerang Frame',
      'Video Story'
    ];
    return FeaturePage(
      title: 'Template Manager',
      description: 'Kelola template foto, GIF/Boomerang, dan video.',
      status: 'Active Template',
      statusColor: AppColors.accent,
      form: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: templates.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (context, index) => TemplateTile(
              name: templates[index],
              active: templates[index] == state.activeTemplate,
              onTap: () {
                state.activeTemplate = templates[index];
                refresh();
              },
            ),
          ),
          const SizedBox(height: 12),
          LargeButton(
              icon: Icons.upload_file_rounded,
              label: 'Upload / Import Template',
              onTap: () {}),
        ],
      ),
      preview: TemplatePreview(name: state.activeTemplate),
      onSaved: () => onSaved('Template setting saved'),
    );
  }
}

class ToolsPage extends StatelessWidget {
  final AppState state;
  final ValueChanged<String> onSaved;
  final Future<bool> Function(
      {required String title,
      required String message,
      String confirmText}) onConfirm;
  final VoidCallback refresh;

  const ToolsPage(
      {super.key,
      required this.state,
      required this.onSaved,
      required this.onConfirm,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'Operator Tools',
      description:
          'Lock screen, buka folder event, dan kontrol wireless photobooth.',
      status:
          state.wirelessConnected ? 'Wireless Connected' : 'Wireless Offline',
      statusColor:
          state.wirelessConnected ? AppColors.success : AppColors.warning,
      form: Column(
        children: [
          LargeButton(
            icon: Icons.lock_rounded,
            label: 'Lock Screen',
            onTap: () async {
              final ok = await onConfirm(
                  title: 'Lock Screen',
                  message: 'Kunci layar operator sekarang?',
                  confirmText: 'Lock');
              if (ok) onSaved('Screen locked');
            },
          ),
          const SizedBox(height: 12),
          LargeButton(
              icon: Icons.folder_open_rounded,
              label: 'Open Event Folder',
              onTap: () {}),
          const SizedBox(height: 12),
          SwitchCard(
              title: 'Wireless Control',
              value: state.wirelessConnected,
              onChanged: (v) {
                state.wirelessConnected = v;
                refresh();
              }),
        ],
      ),
      preview: WirelessPreview(connected: state.wirelessConnected),
      onSaved: () => onSaved('Tools setting saved'),
    );
  }
}

class AboutAccountPage extends StatelessWidget {
  final AppState state;
  final Future<bool> Function(
      {required String title,
      required String message,
      String confirmText}) onConfirm;
  final ValueChanged<String> onSaved;

  const AboutAccountPage(
      {super.key,
      required this.state,
      required this.onConfirm,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return FeaturePage(
      title: 'About / Account',
      description:
          'Informasi versi aplikasi, lisensi, serial key, dan akun Google.',
      status: 'Licensed',
      statusColor: AppColors.success,
      form: Column(
        children: [
          InfoRow(label: 'App Version', value: 'v1.0.0 Operator Build'),
          InfoRow(label: 'License Status', value: 'Active / Pro License'),
          InfoRow(label: 'Serial Key', value: 'CARE-BOOTH-XXXX-2026'),
          InfoRow(
              label: 'Google Account',
              value: state.googleDriveLoggedIn ? 'Logged In' : 'Logged Out'),
          const SizedBox(height: 16),
          LargeButton(
            icon: Icons.logout_rounded,
            label: 'Logout Serial Key',
            onTap: () async {
              final ok = await onConfirm(
                  title: 'Logout Serial Key',
                  message: 'Yakin ingin logout lisensi/serial key?',
                  confirmText: 'Logout');
              if (ok) onSaved('Serial key logged out');
            },
          ),
          const SizedBox(height: 12),
          LargeButton(
            icon: Icons.account_circle_rounded,
            label: 'Logout Google Account',
            onTap: () async {
              final ok = await onConfirm(
                  title: 'Logout Google Account',
                  message: 'Yakin ingin logout akun Google?',
                  confirmText: 'Logout');
              if (ok) onSaved('Google account logged out');
            },
          ),
        ],
      ),
      preview: const AboutPreview(),
      onSaved: () => onSaved('Account setting saved'),
    );
  }
}

class PageScaffold extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const PageScaffold(
      {super.key,
      required this.title,
      required this.description,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(description,
                      style: const TextStyle(color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(child: child),
      ],
    );
  }
}

class FeaturePage extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final Color statusColor;
  final Widget form;
  final Widget preview;
  final VoidCallback onSaved;

  const FeaturePage({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.statusColor,
    required this.form,
    required this.preview,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: title,
      description: description,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1000;
          final content = [
            Expanded(
              flex: 4,
              child: Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Status Panel',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w900)),
                        const Spacer(),
                        BadgePill(label: status, color: statusColor),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: SingleChildScrollView(child: form)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                            child: OutlinedButton(
                                onPressed: () {}, child: const Text('Reset'))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: OutlinedButton(
                                onPressed: () {}, child: const Text('Test'))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: FilledButton(
                                onPressed: onSaved, child: const Text('Save'))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: isWide ? 18 : 0, height: isWide ? 0 : 18),
            Expanded(
              flex: 5,
              child: Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Preview Area',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 16),
                    Expanded(child: preview),
                  ],
                ),
              ),
            ),
          ];

          return isWide
              ? Row(children: content)
              : Column(
                  children: content.map((e) => e is SizedBox ? e : e).toList());
        },
      ),
    );
  }
}

class Panel extends StatelessWidget {
  final Widget child;

  const Panel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: panelDecoration(),
      child: child,
    );
  }
}

BoxDecoration panelDecoration() {
  return BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(28),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.18),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ],
  );
}

class StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const StatusPill(
      {super.key,
      required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }
}

class BadgePill extends StatelessWidget {
  final String label;
  final Color color;

  const BadgePill({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.45)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String status;
  final Color color;

  const StatusCard(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      required this.status,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(.13),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              BadgePill(label: status, color: color),
            ],
          ),
          const Spacer(),
          Text(title,
              style: const TextStyle(
                  color: AppColors.muted, fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
          Text(value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAction(
      {super.key,
      required this.label,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      height: 72,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label, textAlign: TextAlign.center),
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
      ),
    );
  }
}

class LargeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const LargeButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(58),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class TextFieldCard extends StatelessWidget {
  final String label;
  final String initialValue;

  const TextFieldCard(
      {super.key, required this.label, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        decoration: inputDecoration(label),
      ),
    );
  }
}

class NumberFieldCard extends StatelessWidget {
  final String label;
  final String value;

  const NumberFieldCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        keyboardType: TextInputType.number,
        decoration: inputDecoration(label),
      ),
    );
  }
}

class DropdownCard extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;

  const DropdownCard(
      {super.key,
      required this.label,
      required this.value,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (_) {},
        decoration: inputDecoration(label),
      ),
    );
  }
}

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.cardSoft,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.border)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.border)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.accent)),
  );
}

class SwitchCard extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchCard(
      {super.key,
      required this.title,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
              child:
                  Text(label, style: const TextStyle(color: AppColors.muted))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class FolderPreview extends StatelessWidget {
  final String folder;

  const FolderPreview({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return PreviewBox(
      icon: Icons.folder_special_rounded,
      title: 'Event Folder Ready',
      subtitle: folder,
      color: AppColors.accent,
    );
  }
}

class PhotoboothScreenPreview extends StatelessWidget {
  final AppState state;

  const PhotoboothScreenPreview({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF101827),
                    Color(0xFF182D3D),
                    Color(0xFF0B111A)
                  ],
                ),
              ),
            ),
          ),
          const Center(
            child: CircleAvatar(
              radius: 62,
              backgroundColor: Color(0x3300C2FF),
              child: Text('3',
                  style: TextStyle(fontSize: 62, fontWeight: FontWeight.w900)),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Row(
              children: [
                if (state.showStart)
                  _PreviewButton(
                      label: 'Start', icon: Icons.play_arrow_rounded),
                if (state.showRetake)
                  _PreviewButton(label: 'Retake', icon: Icons.refresh_rounded),
                if (state.showPrint)
                  _PreviewButton(label: 'Print', icon: Icons.print_rounded),
                if (state.showShare)
                  _PreviewButton(label: 'Share', icon: Icons.ios_share_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PreviewButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text(label)
      ]),
    );
  }
}

class FilterTile extends StatelessWidget {
  final String name;
  final bool active;

  const FilterTile({super.key, required this.name, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? AppColors.accent.withOpacity(.12) : AppColors.cardSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: active ? AppColors.accent : AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded,
              color: active ? AppColors.accent : AppColors.muted),
          const SizedBox(width: 10),
          Expanded(
              child: Text(name,
                  style: const TextStyle(fontWeight: FontWeight.w800))),
          Switch(value: active, onChanged: (_) {}),
        ],
      ),
    );
  }
}

class BeforeAfterPreview extends StatelessWidget {
  const BeforeAfterPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: MockPhotoCard(title: 'Before', warm: false)),
        const SizedBox(width: 14),
        Expanded(child: MockPhotoCard(title: 'After Filter', warm: true)),
      ],
    );
  }
}

class MockPhotoCard extends StatelessWidget {
  final String title;
  final bool warm;

  const MockPhotoCard({super.key, required this.title, required this.warm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: warm
              ? const [Color(0xFF3D2A18), Color(0xFF895A2B)]
              : const [Color(0xFF1D2735), Color(0xFF394454)],
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
          child: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
    );
  }
}

class PrinterPreview extends StatelessWidget {
  final AppState state;

  const PrinterPreview({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return PreviewBox(
      icon: Icons.print_rounded,
      title: state.printerName,
      subtitle: state.printerReady
          ? 'Printer ready · Quantity ${state.printQuantity}'
          : 'Printer offline',
      color: state.printerReady ? AppColors.success : AppColors.danger,
    );
  }
}

class CameraLivePreview extends StatelessWidget {
  final bool connected;

  const CameraLivePreview({super.key, required this.connected});

  @override
  Widget build(BuildContext context) {
    return PreviewBox(
      icon: connected ? Icons.videocam_rounded : Icons.videocam_off_rounded,
      title: connected ? 'EVF LiveView Active' : 'Camera Disconnected',
      subtitle: connected
          ? 'Live camera preview mock is running'
          : 'Connect camera to start live view',
      color: connected ? AppColors.success : AppColors.danger,
    );
  }
}

class PaymentPreview extends StatelessWidget {
  final bool enabled;

  const PaymentPreview({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return PreviewBox(
      icon: Icons.qr_code_2_rounded,
      title: enabled ? 'QRIS Payment Active' : 'Payment Disabled',
      subtitle: enabled
          ? 'Customer must scan before print'
          : 'Print can run without payment',
      color: enabled ? AppColors.success : AppColors.warning,
    );
  }
}

class PendingUploadPreview extends StatelessWidget {
  PendingUploadPreview({super.key});

  final List<String> uploads = const [
    'IMG_0001.jpg',
    'IMG_0002.jpg',
    'GIF_0004.mp4',
    'PRINT_0007.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: uploads.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardSoft,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_upload_rounded, color: AppColors.warning),
            const SizedBox(width: 12),
            Expanded(
                child: Text(uploads[index],
                    style: const TextStyle(fontWeight: FontWeight.w800))),
            const BadgePill(label: 'Pending', color: AppColors.warning),
          ],
        ),
      ),
    );
  }
}

class TemplateTile extends StatelessWidget {
  final String name;
  final bool active;
  final VoidCallback onTap;

  const TemplateTile(
      {super.key,
      required this.name,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              active ? AppColors.accent.withOpacity(.12) : AppColors.cardSoft,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: active ? AppColors.accent : AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF1D2735), Color(0xFF0B111A)]),
                ),
                child: const Center(
                    child: Icon(Icons.image_rounded,
                        size: 34, color: AppColors.muted)),
              ),
            ),
            const SizedBox(height: 10),
            Text(name,
                style: const TextStyle(fontWeight: FontWeight.w800),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            BadgePill(
                label: active ? 'Active' : 'Set Active',
                color: active ? AppColors.success : AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class TemplatePreview extends StatelessWidget {
  final String name;

  const TemplatePreview({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.cardSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: AspectRatio(
          aspectRatio: 4 / 6,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.accent, width: 2),
            ),
            child: Column(
              children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14)))),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WirelessPreview extends StatelessWidget {
  final bool connected;

  const WirelessPreview({super.key, required this.connected});

  @override
  Widget build(BuildContext context) {
    return PreviewBox(
      icon: Icons.wifi_tethering_rounded,
      title: connected
          ? 'Wireless Control Connected'
          : 'Wireless Control Disconnected',
      subtitle: connected
          ? 'Remote trigger and operator control ready'
          : 'Waiting for wireless controller',
      color: connected ? AppColors.success : AppColors.warning,
    );
  }
}

class AboutPreview extends StatelessWidget {
  const AboutPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const PreviewBox(
      icon: Icons.verified_user_rounded,
      title: 'Care Photobooth Software',
      subtitle:
          'Professional photobooth operator dashboard · Material Design · Mock UI',
      color: AppColors.accent,
    );
  }
}

class PreviewBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const PreviewBox(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(.16), AppColors.cardSoft, AppColors.bg],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: color.withOpacity(.14),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: color.withOpacity(.45)),
            ),
            child: Icon(icon, size: 48, color: color),
          ),
          const SizedBox(height: 22),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}
