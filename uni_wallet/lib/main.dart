import 'package:flutter/material.dart';

void main() {
  runApp(const UniWallet());
}

class UniWallet extends StatelessWidget {
  const UniWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniWallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Inter', // Clean, modern typography
      ),
      home: const MainNavigationPage(),
    );
  }
}

// --- Main Navigation & Responsive Shell ---

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  bool isAdmin = true; // Toggle for testing Admin Panel visibility

  final List<String> _titles = [
    'Dashboard',
    'Send Funds',
    'Withdraw Funds',
    'All Transactions',
    'Admin Panel',
    'Settings'
  ];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardPage(),
      const SendFundsPage(),
      const WithdrawPage(),
      const AllTransactionsPage(),
      const AdminPanelPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], 
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      drawer: isMobile ? SidebarMenuWidget(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        isAdmin: isAdmin,
      ) : null,
      body: Row(
        children: [
          if (!isMobile) 
            SidebarMenuWidget(
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
              isAdmin: isAdmin,
            ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}

// --- Reusable Component: Sidebar (Drawer/Rail) ---

class SidebarMenuWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final bool isAdmin;

  const SidebarMenuWidget({super.key, required this.selectedIndex, required this.onTap, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Center(
                child: Text("UNI WALLET", 
                  style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            _menuItem(0, Icons.home_rounded, "Dashboard"),
            _menuItem(1, Icons.send_rounded, "Send Funds"),
            _menuItem(2, Icons.account_balance_wallet_rounded, "Withdraw"),
            _menuItem(3, Icons.history_rounded, "Transactions"),
            if (isAdmin) _menuItem(4, Icons.admin_panel_settings_rounded, "Admin Panel"),
            const Divider(),
            _menuItem(5, Icons.settings_rounded, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(label, style: TextStyle(color: isSelected ? Colors.blue : Colors.black87)),
      selected: isSelected,
      onTap: () => onTap(index),
    );
  }
}

// --- Page 1: Dashboard ---

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const BalanceCardWidget(balance: "4,250.00"),
        const SizedBox(height: 25),
        const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Row(
          children: const [
            Expanded(child: QuickActionButton(label: "Send", icon: Icons.north_east, color: Colors.blue)),
            SizedBox(width: 15),
            Expanded(child: QuickActionButton(label: "Withdraw", icon: Icons.south_west, color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 25),
        const Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const TransactionListWidget(),
      ],
    );
  }
}

// --- Reusable UI Widgets ---

class BalanceCardWidget extends StatelessWidget {
  final String balance;
  const BalanceCardWidget({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.blue]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Available Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Text("\$$balance", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const QuickActionButton({super.key, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => Card(
        margin: const EdgeInsets.only(top: 10),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFE3F2FD), child: Icon(Icons.person, color: Colors.blue)),
          title: const Text("Student Transfer"),
          subtitle: const Text("Today, 2:45 PM"),
          trailing: const Text("-\$50.00", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        ),
      )),
    );
  }
}

// --- Other Page Placeholders ---

class SendFundsPage extends StatelessWidget {
  const SendFundsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Recipient Search & Transfer Interface"));
}

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Withdrawal Request Form"));
}

class AllTransactionsPage extends StatelessWidget {
  const AllTransactionsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Full Transaction Ledger"));
}

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});
  @override
  Widget build(BuildContext context) => const AdminControlsWidget();
}

class AdminControlsWidget extends StatelessWidget {
  const AdminControlsWidget({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Admin Only: System Balances & User Mgmt"));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Profile & Wallet Settings"));
}