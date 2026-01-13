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
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Inter',
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
  bool isAdmin = true; 

  final List<String> _titles = [
    'Dashboard',
    'Send Funds',
    'Withdraw Funds',
    'All Transactions',
    'Admin Panel',
    'Settings'
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    final List<Widget> pages = [
      const DashboardPage(),
      const SendFundsPage(),
      const WithdrawPage(),
      const AllTransactionsPage(),
      const AdminPanelPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      drawer: isMobile ? SidebarMenuWidget(
        selectedIndex: _selectedIndex,
        onTap: (i) {
          setState(() => _selectedIndex = i);
          Navigator.pop(context); // Close drawer on mobile
        },
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
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
    );
  }
}

// --- Sidebar Component ---

class SidebarMenuWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final bool isAdmin;

  const SidebarMenuWidget({super.key, required this.selectedIndex, required this.onTap, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Icon(Icons.account_balance_rounded, size: 50, color: Colors.blue),
          const SizedBox(height: 10),
          const Text("UniWallet", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 40),
          _menuItem(0, Icons.home_rounded, "Dashboard"),
          _menuItem(1, Icons.send_rounded, "Send Funds"),
          _menuItem(2, Icons.account_balance_wallet_rounded, "Withdraw"),
          _menuItem(3, Icons.history_rounded, "Transactions"),
          if (isAdmin) _menuItem(4, Icons.admin_panel_settings_rounded, "Admin Panel"),
          const Spacer(),
          _menuItem(5, Icons.settings_rounded, "Settings"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuItem(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
        title: Text(label, style: TextStyle(color: isSelected ? Colors.blue : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selected: isSelected,
        selectedTileColor: Colors.blue.withValues(alpha: 0.1),
        onTap: () => onTap(index),
      ),
    );
  }
}

// --- 1. Dashboard Page ---

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text("See All"))
          ],
        ),
        const TransactionListWidget(),
      ],
    );
  }
}

// --- 2. Send Funds Page ---

class SendFundsPage extends StatefulWidget {
  const SendFundsPage({super.key});
  @override
  State<SendFundsPage> createState() => _SendFundsPageState();
}

class _SendFundsPageState extends State<SendFundsPage> {
  final TextEditingController _amountController = TextEditingController();
  String selectedDept = 'Computer Science';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Recipient Name",
                      prefixIcon: const Icon(Icons.person_search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedDept,
                    decoration: InputDecoration(
                      labelText: "Department",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: ['Computer Science', 'Business', 'Engineering', 'Arts']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => selectedDept = val!),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () => _showConfirmation(context),
                      child: const Text("Confirm Transfer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transfer Successful!")));
  }
}

// --- 3. Withdraw Funds Page ---

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const BalanceCardWidget(balance: "4,250.00"),
        const SizedBox(height: 30),
        const Text("Withdrawal History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...List.generate(2, (index) => Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const Icon(Icons.account_balance, color: Colors.orange),
            title: const Text("ATM Withdrawal"),
            subtitle: Text("Jan ${10 - index}, 2026"),
            trailing: const Text("-\$200.00", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        )),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text("Request New Withdrawal"),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
        )
      ],
    );
  }
}

// --- 4. All Transactions (Ledger) ---

class AllTransactionsPage extends StatelessWidget {
  const AllTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Colors.white,
          child: ListTile(
            title: Text("Txn ID: 0x${(index + 1245).toRadixString(16)}..."),
            subtitle: Text("User: Student_$index • 12:4${index} PM"),
            trailing: Text(index % 2 == 0 ? "+\$120.00" : "-\$45.00", 
              style: TextStyle(color: index % 2 == 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}

// --- 5. Admin Panel ---

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminStatCard(title: "System Balance", value: "\$1,240,500", icon: Icons.analytics),
          const SizedBox(height: 20),
          const Text("Admin Controls", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _adminAction(Icons.person_add, "Add New Admin"),
          _adminAction(Icons.account_balance_wallet, "Manual Deposit"),
          _adminAction(Icons.block, "Freeze Account"),
        ],
      ),
    );
  }

  Widget _adminAction(IconData icon, String label) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class AdminStatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  const AdminStatCard({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- 6. Settings Page ---

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Center(
          child: Column(
            children: [
              CircleAvatar(radius: 50, backgroundColor: Colors.blue, child: Icon(Icons.person, size: 50, color: Colors.white)),
              SizedBox(height: 10),
              Text("John Doe", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("ID: 2024-UN-0012", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _settingsTile(Icons.vpn_key, "Change Password"),
        _settingsTile(Icons.qr_code, "Wallet Address: 0x55...3A"),
        _settingsTile(Icons.notifications, "Notifications"),
        const Divider(height: 40),
        _settingsTile(Icons.logout, "Sign Out", color: Colors.red),
      ],
    );
  }

  Widget _settingsTile(IconData icon, String label, {Color color = Colors.black87}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: () {},
    );
  }
}

// --- Reusable Dashboard Widgets ---

class BalanceCardWidget extends StatelessWidget {
  final String balance;
  const BalanceCardWidget({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF1976D2)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Available Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Text("\$$balance", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("**** **** **** 1234", style: TextStyle(color: Colors.white54, letterSpacing: 2)),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
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
      children: List.generate(4, (index) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: index % 2 == 0 ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1), 
            child: Icon(index % 2 == 0 ? Icons.south_west : Icons.north_east, color: index % 2 == 0 ? Colors.green : Colors.red, size: 18)
          ),
          title: Text(index % 2 == 0 ? "Refund: Library" : "Cafe Transaction", style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("Today, 11:20 AM"),
          trailing: Text(index % 2 == 0 ? "+\$15.00" : "-\$12.50", 
            style: TextStyle(fontWeight: FontWeight.bold, color: index % 2 == 0 ? Colors.green : Colors.black)),
        ),
      )),
    );
  }
}