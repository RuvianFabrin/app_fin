import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Helper para formatação de moeda
final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

// Formatador de Input para Moeda
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    double value = double.parse(digitsOnly) / 100;
    String newText = currencyFormatter.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static double parse(String text) {
    String digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return 0.0;
    return double.parse(digitsOnly) / 100;
  }
}

//---------------------------------------------------
// 1. MODELOS DE DADOS
//---------------------------------------------------

class FinancialControl {
  final int? id;
  final int month;
  final int year;

  FinancialControl({this.id, required this.month, required this.year});

  FinancialControl copyWith({
    int? id,
    int? month,
    int? year,
  }) {
    return FinancialControl(
      id: id ?? this.id,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'month': month, 'year': year};
  }

  factory FinancialControl.fromMap(Map<String, dynamic> map) {
    return FinancialControl(
      id: map['id'],
      month: map['month'],
      year: map['year'],
    );
  }
}

class Transaction {
  final int? id;
  final int controlId;
  final String name;
  final double value;
  final String type; // 'income' or 'expense'
  final String category;
  final bool isPaid;
  final DateTime date;

  Transaction({
    this.id,
    required this.controlId,
    required this.name,
    required this.value,
    required this.type,
    this.category = 'Geral',
    this.isPaid = false,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'controlId': controlId,
      'name': name,
      'value': value,
      'type': type,
      'category': category,
      'isPaid': isPaid ? 1 : 0,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      controlId: map['controlId'],
      name: map['name'],
      value: map['value'],
      type: map['type'],
      category: map['category'] ?? 'Geral',
      isPaid: map['isPaid'] == 1,
      date: map['date'] != null && map['date'].isNotEmpty
          ? DateTime.parse(map['date'])
          : DateTime.now(),
    );
  }
}

class FuturePurchase {
  final int? id;
  final int controlId;
  final String name;
  final double value;
  final String category;
  final DateTime date;

  FuturePurchase({
    this.id,
    required this.controlId,
    required this.name,
    required this.value,
    this.category = 'Geral',
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'controlId': controlId,
      'name': name,
      'value': value,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory FuturePurchase.fromMap(Map<String, dynamic> map) {
    return FuturePurchase(
      id: map['id'],
      controlId: map['controlId'],
      name: map['name'],
      value: map['value'],
      category: map['category'] ?? 'Geral',
      date: DateTime.parse(map['date']),
    );
  }
}

class Investment {
  final int? id;
  final int controlId;
  final String name;
  final double value;
  final String category;
  final DateTime date;

  Investment({
    this.id,
    required this.controlId,
    required this.name,
    required this.value,
    this.category = 'Geral',
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'controlId': controlId,
      'name': name,
      'value': value,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Investment.fromMap(Map<String, dynamic> map) {
    return Investment(
      id: map['id'],
      controlId: map['controlId'],
      name: map['name'],
      value: map['value'],
      category: map['category'] ?? 'Geral',
      date: DateTime.parse(map['date']),
    );
  }
}

class Debt {
  final int? id;
  final int controlId;
  final String name;
  final double value;
  final String category;
  final DateTime date;

  Debt({
    this.id,
    required this.controlId,
    required this.name,
    required this.value,
    this.category = 'Geral',
    required this.date,
  });

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'controlId': controlId,
      'name': name,
      'value': value,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Debt.fromMap(Map<String, dynamic> map) {
    return Debt(
      id: map['id'],
      controlId: map['controlId'],
      name: map['name'],
      value: map['value'],
      category: map['category'] ?? 'Geral',
      date: DateTime.parse(map['date']),
    );
  }
}


class CreditCard {
  final int? id;
  final int controlId;
  final String name;
  final int dueDate;
  final int bestPurchaseDate;
  final double currentBill;
  final double creditLimit;

  CreditCard({
    this.id,
    required this.controlId,
    required this.name,
    required this.dueDate,
    required this.bestPurchaseDate,
    required this.currentBill,
    required this.creditLimit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'controlId': controlId,
      'name': name,
      'dueDate': dueDate,
      'bestPurchaseDate': bestPurchaseDate,
      'currentBill': currentBill,
      'creditLimit': creditLimit,
    };
  }

  factory CreditCard.fromMap(Map<String, dynamic> map) {
    return CreditCard(
      id: map['id'],
      controlId: map['controlId'],
      name: map['name'],
      dueDate: map['dueDate'],
      bestPurchaseDate: map['bestPurchaseDate'],
      currentBill: map['currentBill'],
      creditLimit: map['creditLimit'],
    );
  }
}

//---------------------------------------------------
// 2. HELPER DO BANCO DE DADOS (SQLITE)
//---------------------------------------------------

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'financial_control.db');
    return await openDatabase(
      path,
      version: 5, // <-- VERSÃO INCREMENTADA
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // ... código para criar todas as tabelas, incluindo a nova 'debts'
    await db.execute('''
      CREATE TABLE financial_controls(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        UNIQUE(month, year)
      )
    ''');
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        controlId INTEGER NOT NULL,
        name TEXT NOT NULL,
        value REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL DEFAULT 'Geral',
        isPaid INTEGER NOT NULL DEFAULT 0,
        date TEXT NOT NULL,
        FOREIGN KEY (controlId) REFERENCES financial_controls (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE credit_cards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        controlId INTEGER NOT NULL,
        name TEXT NOT NULL,
        dueDate INTEGER NOT NULL,
        bestPurchaseDate INTEGER NOT NULL,
        currentBill REAL NOT NULL,
        creditLimit REAL NOT NULL,
        FOREIGN KEY (controlId) REFERENCES financial_controls (id) ON DELETE CASCADE
      )
    ''');
     await db.execute('''
      CREATE TABLE future_purchases(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        controlId INTEGER NOT NULL,
        name TEXT NOT NULL,
        value REAL NOT NULL,
        category TEXT NOT NULL DEFAULT 'Geral',
        date TEXT NOT NULL,
        FOREIGN KEY (controlId) REFERENCES financial_controls (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE investments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        controlId INTEGER NOT NULL,
        name TEXT NOT NULL,
        value REAL NOT NULL,
        category TEXT NOT NULL DEFAULT 'Geral',
        date TEXT NOT NULL,
        FOREIGN KEY (controlId) REFERENCES financial_controls (id) ON DELETE CASCADE
      )
    ''');
     await db.execute('''
      CREATE TABLE debts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        controlId INTEGER NOT NULL,
        name TEXT NOT NULL,
        value REAL NOT NULL,
        category TEXT NOT NULL DEFAULT 'Geral',
        date TEXT NOT NULL,
        FOREIGN KEY (controlId) REFERENCES financial_controls (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE transactions ADD COLUMN date TEXT NOT NULL DEFAULT ''");
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE future_purchases(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          controlId INTEGER NOT NULL,
          name TEXT NOT NULL,
          value REAL NOT NULL,
          category TEXT NOT NULL DEFAULT 'Geral',
          date TEXT NOT NULL,
          FOREIGN KEY (controlId) REFERENCES financial_controls (id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 4) {
       await db.execute('''
        CREATE TABLE investments(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          controlId INTEGER NOT NULL,
          name TEXT NOT NULL,
          value REAL NOT NULL,
          category TEXT NOT NULL DEFAULT 'Geral',
          date TEXT NOT NULL,
          FOREIGN KEY (controlId) REFERENCES financial_controls (id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 5) {
        await db.execute('''
        CREATE TABLE debts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          controlId INTEGER NOT NULL,
          name TEXT NOT NULL,
          value REAL NOT NULL,
          category TEXT NOT NULL DEFAULT 'Geral',
          date TEXT NOT NULL,
          FOREIGN KEY (controlId) REFERENCES financial_controls (id) ON DELETE CASCADE
        )
      ''');
    }
  }


  // --- FinancialControl ---
  Future<int> insertControl(FinancialControl control) async {
    final db = await database;
    return await db.insert('financial_controls', control.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
   Future<int> updateControl(FinancialControl control) async {
    final db = await database;
    return await db.update('financial_controls', control.toMap(), where: 'id = ?', whereArgs: [control.id]);
  }

  Future<List<FinancialControl>> getControls() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('financial_controls', orderBy: 'year DESC, month DESC');
    return List.generate(maps.length, (i) {
      return FinancialControl.fromMap(maps[i]);
    });
  }

  Future<FinancialControl?> getControlByMonthYear(int month, int year) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'financial_controls',
      where: 'month = ? AND year = ?',
      whereArgs: [month, year],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return FinancialControl.fromMap(maps.first);
    }
    return null;
  }

  Future<void> deleteControl(int id) async {
    final db = await database;
    await db.delete('financial_controls', where: 'id = ?', whereArgs: [id]);
  }

  // --- Transaction ---
  Future<int> insertTransaction(Transaction transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> updateTransaction(Transaction transaction) async {
    final db = await database;
    return await db.update('transactions', transaction.toMap(),
        where: 'id = ?', whereArgs: [transaction.id]);
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Transaction>> getTransactions(int controlId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'controlId = ?',
      whereArgs: [controlId],
      orderBy: 'date DESC'
    );
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }
  
  // --- FuturePurchase ---
  Future<int> insertFuturePurchase(FuturePurchase purchase) async {
    final db = await database;
    return await db.insert('future_purchases', purchase.toMap());
  }

  Future<int> updateFuturePurchase(FuturePurchase purchase) async {
    final db = await database;
    return await db.update('future_purchases', purchase.toMap(),
        where: 'id = ?', whereArgs: [purchase.id]);
  }

  Future<void> deleteFuturePurchase(int id) async {
    final db = await database;
    await db.delete('future_purchases', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FuturePurchase>> getFuturePurchases(int controlId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'future_purchases',
      where: 'controlId = ?',
      whereArgs: [controlId],
      orderBy: 'date DESC'
    );
    return List.generate(maps.length, (i) {
      return FuturePurchase.fromMap(maps[i]);
    });
  }

  // --- Investment ---
  Future<int> insertInvestment(Investment investment) async {
    final db = await database;
    return await db.insert('investments', investment.toMap());
  }

  Future<int> updateInvestment(Investment investment) async {
    final db = await database;
    return await db.update('investments', investment.toMap(),
        where: 'id = ?', whereArgs: [investment.id]);
  }

  Future<void> deleteInvestment(int id) async {
    final db = await database;
    await db.delete('investments', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Investment>> getInvestments(int controlId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'investments',
      where: 'controlId = ?',
      whereArgs: [controlId],
      orderBy: 'date DESC'
    );
    return List.generate(maps.length, (i) {
      return Investment.fromMap(maps[i]);
    });
  }

    // --- Debt ---
  Future<int> insertDebt(Debt debt) async {
    final db = await database;
    return await db.insert('debts', debt.toMap());
  }

  Future<int> updateDebt(Debt debt) async {
    final db = await database;
    return await db.update('debts', debt.toMap(),
        where: 'id = ?', whereArgs: [debt.id]);
  }

  Future<void> deleteDebt(int id) async {
    final db = await database;
    await db.delete('debts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Debt>> getDebts(int controlId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'debts',
      where: 'controlId = ?',
      whereArgs: [controlId],
      orderBy: 'date DESC'
    );
    return List.generate(maps.length, (i) {
      return Debt.fromMap(maps[i]);
    });
  }

  // --- CreditCard ---
  Future<int> insertCard(CreditCard card) async {
    final db = await database;
    return await db.insert('credit_cards', card.toMap());
  }

  Future<int> updateCard(CreditCard card) async {
    final db = await database;
    return await db.update('credit_cards', card.toMap(),
        where: 'id = ?', whereArgs: [card.id]);
  }

  Future<void> deleteCard(int id) async {
    final db = await database;
    await db.delete('credit_cards', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CreditCard>> getCards(int controlId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'credit_cards',
      where: 'controlId = ?',
      whereArgs: [controlId],
    );
    return List.generate(maps.length, (i) {
      return CreditCard.fromMap(maps[i]);
    });
  }

  // --- Categories ---
  Future<Set<String>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT category FROM transactions
      UNION
      SELECT category FROM future_purchases
      UNION
      SELECT category FROM investments
      UNION
      SELECT category FROM debts
    ''');
    return results.map((map) => map['category'] as String).toSet();
  }
}

//---------------------------------------------------
// 3. MAIN
//---------------------------------------------------

void main() {
  runApp(const FinancialControlApp());
}

class FinancialControlApp extends StatelessWidget {
  const FinancialControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Financeiro',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

//---------------------------------------------------
// 4. TELA INICIAL (HomePage)
//---------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<FinancialControl>> _controlsFuture;

  @override
  void initState() {
    super.initState();
    _loadControls();
  }

  void _loadControls() {
    setState(() {
      _controlsFuture = DatabaseHelper().getControls();
    });
  }

  Future<void> _addControl() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'SELECIONE MÊS E ANO',
      confirmText: 'CONFIRMAR',
      cancelText: 'CANCELAR',
    );

    if (pickedDate != null) {
      final newControl = FinancialControl(
        month: pickedDate.month,
        year: pickedDate.year,
      );
      await DatabaseHelper().insertControl(newControl);
      _loadControls();
    }
  }

  Future<void> _editControl(FinancialControl control) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(control.year, control.month),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'EDITAR MÊS E ANO',
    );

    if (pickedDate != null) {
      final dbHelper = DatabaseHelper();
      final existing = await dbHelper.getControlByMonthYear(pickedDate.month, pickedDate.year);
      if (existing != null && existing.id != control.id) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este mês/ano já existe.'), backgroundColor: Colors.red),
          );
        }
        return;
      }
      
      final updatedControl = control.copyWith(month: pickedDate.month, year: pickedDate.year);
      await dbHelper.updateControl(updatedControl);
      _loadControls();
    }
  }

  Future<void> _deleteControl(FinancialControl control) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Controle?'),
        content: Text('Tem certeza que deseja excluir o controle de ${_monthYearString(control.month, control.year)}? Todos os dados serão perdidos.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Não')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sim, Excluir', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper().deleteControl(control.id!);
      _loadControls();
    }
  }
  
  Future<void> _showCopyControlDialog(FinancialControl sourceControl) async {
     DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'COPIAR PARA QUAL MÊS/ANO?',
    );

    if (pickedDate == null || !mounted) return;

    final dbHelper = DatabaseHelper();
    final existingControl = await dbHelper.getControlByMonthYear(pickedDate.month, pickedDate.year);

    if (existingControl != null) {
      final bool? overwrite = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Controle já existe'),
          content: Text('Já existe um controle para ${_monthYearString(pickedDate.month, pickedDate.year)}. Deseja sobrescrevê-lo?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Não')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sim')),
          ],
        ),
      );
      if (overwrite != true) return;
      await dbHelper.deleteControl(existingControl.id!);
    }
    
    final newControl = FinancialControl(month: pickedDate.month, year: pickedDate.year);
    final newControlId = await dbHelper.insertControl(newControl);

    final transactionsToCopy = await dbHelper.getTransactions(sourceControl.id!);
    for (final transaction in transactionsToCopy) {
      final newTransaction = Transaction(
        controlId: newControlId,
        name: transaction.name,
        value: transaction.value,
        type: transaction.type,
        category: transaction.category,
        isPaid: false,
        date: transaction.date.copyWith(month: pickedDate.month, year: pickedDate.year),
      );
      await dbHelper.insertTransaction(newTransaction);
    }

    final cardsToCopy = await dbHelper.getCards(sourceControl.id!);
    for (final card in cardsToCopy) {
      final newCard = CreditCard(
        controlId: newControlId,
        name: card.name,
        dueDate: card.dueDate,
        bestPurchaseDate: card.bestPurchaseDate,
        currentBill: 0,
        creditLimit: card.creditLimit,
      );
      await dbHelper.insertCard(newCard);
    }

    final futurePurchasesToCopy = await dbHelper.getFuturePurchases(sourceControl.id!);
    for (final purchase in futurePurchasesToCopy) {
      final newPurchase = FuturePurchase(
        controlId: newControlId,
        name: purchase.name,
        value: purchase.value,
        category: purchase.category,
        date: purchase.date.copyWith(month: pickedDate.month, year: pickedDate.year),
      );
      await dbHelper.insertFuturePurchase(newPurchase);
    }

    final investmentsToCopy = await dbHelper.getInvestments(sourceControl.id!);
    for (final investment in investmentsToCopy) {
      final newInvestment = Investment(
        controlId: newControlId,
        name: investment.name,
        value: investment.value,
        category: investment.category,
        date: investment.date.copyWith(month: pickedDate.month, year: pickedDate.year),
      );
      await dbHelper.insertInvestment(newInvestment);
    }

    final debtsToCopy = await dbHelper.getDebts(sourceControl.id!);
    for (final debt in debtsToCopy) {
      final newDebt = Debt(
        controlId: newControlId,
        name: debt.name,
        value: debt.value,
        category: debt.category,
        date: debt.date.copyWith(month: pickedDate.month, year: pickedDate.year),
      );
      await dbHelper.insertDebt(newDebt);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copiado para ${_monthYearString(pickedDate.month, pickedDate.year)}!')),
      );
    }

    _loadControls();
  }


  String _monthYearString(int month, int year) {
    final date = DateTime(year, month);
    return DateFormat.yMMMM('pt_BR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Controles Financeiros'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: FutureBuilder<List<FinancialControl>>(
        future: _controlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum controle encontrado.\nClique em "+" para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final controls = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controls.length,
            itemBuilder: (context, index) {
              final control = controls[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.calendar_month, color: Colors.greenAccent),
                  title: Text(
                    _monthYearString(control.month, control.year),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editControl(control);
                          } else if (value == 'delete') {
                            _deleteControl(control);
                          } else if (value == 'copy') {
                            _showCopyControlDialog(control);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Editar Mês/Ano')),
                          const PopupMenuItem(value: 'copy', child: Text('Copiar Controle')),
                          const PopupMenuItem(value: 'delete', child: Text('Excluir Controle', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ControlPage(control: control),
                      ),
                    ).then((_) => _loadControls());
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addControl,
        tooltip: 'Adicionar Controle',
        child: const Icon(Icons.add),
      ),
    );
  }
}

//---------------------------------------------------
// 5. TELA DE CONTROLE (ControlPage)
//---------------------------------------------------

class ControlPage extends StatefulWidget {
  final FinancialControl control;

  const ControlPage({super.key, required this.control});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  List<Transaction> _incomes = [];
  List<Transaction> _expenses = [];
  List<CreditCard> _cards = [];
  List<FuturePurchase> _futurePurchases = [];
  List<Investment> _investments = [];
  List<Debt> _debts = [];
  Set<String> _allCategories = {};

  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  double _balance = 0.0;
  double _totalCardBills = 0.0;
  double _totalCardLimits = 0.0;
  double _totalFuturePurchases = 0.0;
  double _totalInvestments = 0.0;
  double _totalDebts = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dbHelper = DatabaseHelper();
    final transactions = await dbHelper.getTransactions(widget.control.id!);
    final cards = await dbHelper.getCards(widget.control.id!);
    final futurePurchases = await dbHelper.getFuturePurchases(widget.control.id!);
    final investments = await dbHelper.getInvestments(widget.control.id!);
    final debts = await dbHelper.getDebts(widget.control.id!);
    final categories = await dbHelper.getAllCategories();

    final incomes = transactions.where((t) => t.type == 'income').toList();
    final expenses = transactions.where((t) => t.type == 'expense').toList();

    final totalIncome = incomes.fold(0.0, (sum, item) => sum + item.value);
    final totalExpense = expenses.fold(0.0, (sum, item) => sum + item.value);
    final totalCardBills = cards.fold(0.0, (sum, item) => sum + item.currentBill);
    final totalCardLimits = cards.fold(0.0, (sum, item) => sum + item.creditLimit);
    final totalFuturePurchases = futurePurchases.fold(0.0, (sum, item) => sum + item.value);
    final totalInvestments = investments.fold(0.0, (sum, item) => sum + item.value);
    final totalDebts = debts.fold(0.0, (sum, item) => sum + item.value);

    if (mounted) {
      setState(() {
        _incomes = incomes;
        _expenses = expenses;
        _cards = cards;
        _futurePurchases = futurePurchases;
        _investments = investments;
        _debts = debts;
        _allCategories = categories;
        _totalIncome = totalIncome;
        _totalExpense = totalExpense;
        _balance = totalIncome - totalExpense;
        _totalCardBills = totalCardBills;
        _totalCardLimits = totalCardLimits;
        _totalFuturePurchases = totalFuturePurchases;
        _totalInvestments = totalInvestments;
        _totalDebts = totalDebts;
      });
    }
  }

  String _monthYearString(int month, int year) {
    final date = DateTime(year, month);
    return DateFormat.yMMMM('pt_BR').format(date);
  }

  Future<void> _showTransactionDialog({Transaction? transaction}) async {
    final isEditing = transaction != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: transaction?.name ?? '');
    final valueController = TextEditingController(
        text: transaction != null ? currencyFormatter.format(transaction.value) : '');
    final categoryController =
        TextEditingController(text: transaction?.category ?? 'Geral');
    String type = transaction?.type ?? 'expense';
    bool isPaid = transaction?.isPaid ?? false;
    DateTime selectedDate = transaction?.date ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Transação' : 'Nova Transação'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text('Data: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));
                          if (picked != null && picked != selectedDate) {
                            setState(() => selectedDate = picked);
                          }
                        },
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      TextFormField(
                        controller: valueController,
                        decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [CurrencyInputFormatter()],
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _allCategories.where((String option) {
                            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          categoryController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context, TextEditingController fieldController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                           // Sincroniza o controller do autocomplete com o nosso controller
                           WidgetsBinding.instance.addPostFrameCallback((_) {
                             if (fieldController.text != categoryController.text) {
                               fieldController.text = categoryController.text;
                             }
                           });
                           fieldController.addListener(() {
                              categoryController.text = fieldController.text;
                           });

                           return TextFormField(
                            controller: fieldController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(labelText: 'Grupo / Categoria'),
                            validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Tipo: '),
                          Radio<String>(
                            value: 'expense',
                            groupValue: type,
                            onChanged: (value) => setState(() => type = value!),
                          ),
                          const Text('Despesa'),
                          Radio<String>(
                            value: 'income',
                            groupValue: type,
                            onChanged: (value) => setState(() => type = value!),
                          ),
                          const Text('Entrada'),
                        ],
                      ),
                      if (type == 'expense')
                        SwitchListTile(
                          title: const Text('Despesa Paga?'),
                          value: isPaid,
                          onChanged: (bool value) => setState(() => isPaid = value),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final transactionToSave = Transaction(
                    id: transaction?.id,
                    controlId: widget.control.id!,
                    name: nameController.text,
                    value: CurrencyInputFormatter.parse(valueController.text),
                    type: type,
                    category: categoryController.text,
                    isPaid: type == 'expense' ? isPaid : true,
                    date: selectedDate,
                  );
                  if (isEditing) {
                    await DatabaseHelper().updateTransaction(transactionToSave);
                  } else {
                    await DatabaseHelper().insertTransaction(transactionToSave);
                  }
                  _loadData();
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFuturePurchaseDialog({FuturePurchase? purchase}) async {
    final isEditing = purchase != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: purchase?.name ?? '');
    final valueController = TextEditingController(
        text: purchase != null ? currencyFormatter.format(purchase.value) : '');
    final categoryController =
        TextEditingController(text: purchase?.category ?? 'Geral');
    DateTime selectedDate = purchase?.date ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Compra Futura' : 'Nova Compra Futura'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text('Data: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101));
                          if (picked != null && picked != selectedDate) {
                            setState(() => selectedDate = picked);
                          }
                        },
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      TextFormField(
                        controller: valueController,
                        decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [CurrencyInputFormatter()],
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _allCategories.where((String option) {
                            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          categoryController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context, TextEditingController fieldController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                           WidgetsBinding.instance.addPostFrameCallback((_) {
                             if (fieldController.text != categoryController.text) {
                               fieldController.text = categoryController.text;
                             }
                           });
                           fieldController.addListener(() {
                              categoryController.text = fieldController.text;
                           });
                           return TextFormField(
                            controller: fieldController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(labelText: 'Grupo / Categoria'),
                            validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final purchaseToSave = FuturePurchase(
                    id: purchase?.id,
                    controlId: widget.control.id!,
                    name: nameController.text,
                    value: CurrencyInputFormatter.parse(valueController.text),
                    category: categoryController.text,
                    date: selectedDate,
                  );
                  if (isEditing) {
                    await DatabaseHelper().updateFuturePurchase(purchaseToSave);
                  } else {
                    await DatabaseHelper().insertFuturePurchase(purchaseToSave);
                  }
                  _loadData();
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showInvestmentDialog({Investment? investment}) async {
    final isEditing = investment != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: investment?.name ?? '');
    final valueController = TextEditingController(
        text: investment != null ? currencyFormatter.format(investment.value) : '');
    final categoryController =
        TextEditingController(text: investment?.category ?? 'Geral');
    DateTime selectedDate = investment?.date ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Investimento' : 'Novo Investimento'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text('Data: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));
                          if (picked != null && picked != selectedDate) {
                            setState(() => selectedDate = picked);
                          }
                        },
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      TextFormField(
                        controller: valueController,
                        decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [CurrencyInputFormatter()],
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _allCategories.where((String option) {
                            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          categoryController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context, TextEditingController fieldController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                           WidgetsBinding.instance.addPostFrameCallback((_) {
                             if (fieldController.text != categoryController.text) {
                               fieldController.text = categoryController.text;
                             }
                           });
                           fieldController.addListener(() {
                              categoryController.text = fieldController.text;
                           });
                           return TextFormField(
                            controller: fieldController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(labelText: 'Grupo / Categoria'),
                            validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final investmentToSave = Investment(
                    id: investment?.id,
                    controlId: widget.control.id!,
                    name: nameController.text,
                    value: CurrencyInputFormatter.parse(valueController.text),
                    category: categoryController.text,
                    date: selectedDate,
                  );
                  if (isEditing) {
                    await DatabaseHelper().updateInvestment(investmentToSave);
                  } else {
                    await DatabaseHelper().insertInvestment(investmentToSave);
                  }
                  _loadData();
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDebtDialog({Debt? debt}) async {
    final isEditing = debt != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: debt?.name ?? '');
    final valueController = TextEditingController(
        text: debt != null ? currencyFormatter.format(debt.value) : '');
    final categoryController =
        TextEditingController(text: debt?.category ?? 'Geral');
    DateTime selectedDate = debt?.date ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Dívida' : 'Nova Dívida'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text('Data: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));
                          if (picked != null && picked != selectedDate) {
                            setState(() => selectedDate = picked);
                          }
                        },
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      TextFormField(
                        controller: valueController,
                        decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [CurrencyInputFormatter()],
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _allCategories.where((String option) {
                            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          categoryController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context, TextEditingController fieldController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                           WidgetsBinding.instance.addPostFrameCallback((_) {
                             if (fieldController.text != categoryController.text) {
                               fieldController.text = categoryController.text;
                             }
                           });
                           fieldController.addListener(() {
                              categoryController.text = fieldController.text;
                           });
                           return TextFormField(
                            controller: fieldController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(labelText: 'Grupo / Categoria'),
                            validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final debtToSave = Debt(
                    id: debt?.id,
                    controlId: widget.control.id!,
                    name: nameController.text,
                    value: CurrencyInputFormatter.parse(valueController.text),
                    category: categoryController.text,
                    date: selectedDate,
                  );
                  if (isEditing) {
                    await DatabaseHelper().updateDebt(debtToSave);
                  } else {
                    await DatabaseHelper().insertDebt(debtToSave);
                  }
                  _loadData();
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCardDialog({CreditCard? card}) async {
    final isEditing = card != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: card?.name ?? '');
    final dueDateController =
        TextEditingController(text: card?.dueDate.toString() ?? '');
    final bestDayController =
        TextEditingController(text: card?.bestPurchaseDate.toString() ?? '');
    final billController = TextEditingController(
        text: card != null ? currencyFormatter.format(card.currentBill) : '');
    final limitController = TextEditingController(
        text: card != null ? currencyFormatter.format(card.creditLimit) : '');

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(isEditing ? 'Editar Cartão' : 'Novo Cartão de Crédito'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nome do Cartão'),
                        validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                    TextFormField(
                        controller: dueDateController,
                        decoration: const InputDecoration(labelText: 'Data de Vencimento (dia)'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                    TextFormField(
                        controller: bestDayController,
                        decoration: const InputDecoration(labelText: 'Melhor data de Compra (dia)'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                    TextFormField(
                        controller: billController,
                        decoration: const InputDecoration(labelText: 'Valor Atual da Fatura (R\$)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [CurrencyInputFormatter()],
                        validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                    TextFormField(
                        controller: limitController,
                        decoration: const InputDecoration(labelText: 'Valor do Limite (R\$)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [CurrencyInputFormatter()],
                        validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final cardToSave = CreditCard(
                      id: card?.id,
                      controlId: widget.control.id!,
                      name: nameController.text,
                      dueDate: int.parse(dueDateController.text),
                      bestPurchaseDate: int.parse(bestDayController.text),
                      currentBill: CurrencyInputFormatter.parse(billController.text),
                      creditLimit: CurrencyInputFormatter.parse(limitController.text),
                    );
                    if (isEditing) {
                      await DatabaseHelper().updateCard(cardToSave);
                    } else {
                      await DatabaseHelper().insertCard(cardToSave);
                    }
                    _loadData();
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        });
  }

  Future<void> _confirmDeleteDialog({
    required String title,
    required String content,
    required VoidCallback onDelete,
  }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_monthYearString(widget.control.month, widget.control.year)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.add_card, color: Colors.greenAccent),
                      title: const Text('Adicionar Despesa/Entrada'),
                      onTap: () {
                        Navigator.pop(context);
                        _showTransactionDialog();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.credit_card, color: Colors.blueAccent),
                      title: const Text('Adicionar Cartão'),
                      onTap: () {
                        Navigator.pop(context);
                        _showCardDialog();
                      },
                    ),
                     ListTile(
                      leading: const Icon(Icons.show_chart, color: Colors.purpleAccent),
                      title: const Text('Adicionar Investimento'),
                      onTap: () {
                        Navigator.pop(context);
                        _showInvestmentDialog();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_bag, color: Colors.orangeAccent),
                      title: const Text('Adicionar Compra Futura'),
                      onTap: () {
                        Navigator.pop(context);
                        _showFuturePurchaseDialog();
                      },
                    ),
                     ListTile(
                      leading: const Icon(Icons.money_off, color: Colors.redAccent),
                      title: const Text('Adicionar Dívida'),
                      onTap: () {
                        Navigator.pop(context);
                        _showDebtDialog();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Despesas'),
            _buildGroupedExpenses(),
            const SizedBox(height: 24),
            _buildSectionTitle('Entradas'),
            _incomes.isEmpty
                ? const Center(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Nenhuma entrada cadastrada.')))
                : Column(
                    children: _incomes
                        .map((t) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: _buildTransactionTile(t, Colors.greenAccent),
                            ))
                        .toList(),
                  ),
            const SizedBox(height: 24),
            _buildSectionTitle('Investimentos'),
             _buildInvestmentsSummary(),
            _buildGroupedInvestments(),
            const SizedBox(height: 24),
            _buildSectionTitle('Totais'),
            _buildTotalsCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Cartões'),
            _buildCreditCardSummary(),
            _cards.isEmpty
                ? const Center(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Nenhum cartão cadastrado.')))
                : Column(
                    children: _cards.map((c) => _buildCreditCardTile(c)).toList(),
                  ),
            const SizedBox(height: 24),
            _buildSectionTitle('Compras no Futuro'),
            _buildFuturePurchasesSummary(),
            _buildGroupedFuturePurchases(),
            const SizedBox(height: 24),
            _buildSectionTitle('Dívidas'),
            _buildDebtsSummary(),
            _buildGroupedDebts(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent),
      ),
    );
  }

  Widget _buildGroupedExpenses() {
    if (_expenses.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Nenhuma despesa cadastrada.')));
    }

    final Map<String, List<Transaction>> groupedExpenses = {};
    for (final expense in _expenses) {
      (groupedExpenses[expense.category] ??= []).add(expense);
    }

    final sortedCategories = groupedExpenses.keys.toList()..sort();

    return Column(
      children: sortedCategories.map((category) {
        final transactionsInCategory = groupedExpenses[category]!;
        final categoryTotal =
            transactionsInCategory.fold(0.0, (sum, item) => sum + item.value);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(category,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 16),
                Text(
                  currencyFormatter.format(categoryTotal),
                  style: const TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            children: transactionsInCategory
                .map((t) => _buildTransactionTile(t, Colors.redAccent))
                .toList(),
          ),
        );
      }).toList(),
    );
  }

  ListTile _buildTransactionTile(Transaction transaction, Color color) {
    final isExpense = transaction.type == 'expense';
    final isPaid = transaction.isPaid;

    return ListTile(
      leading: Icon(
        isExpense
            ? (isPaid ? Icons.check_circle : Icons.radio_button_unchecked)
            : Icons.attach_money,
        color: isExpense ? (isPaid ? Colors.grey : color) : color,
      ),
      title: Text(
        transaction.name,
        style: TextStyle(
          decoration: isExpense && isPaid
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: isExpense && isPaid ? Colors.grey : null,
        ),
      ),
      subtitle: Text(
        '${DateFormat('dd/MM').format(transaction.date)} - ${currencyFormatter.format(transaction.value)}',
        style: TextStyle(
          color: isExpense && isPaid ? Colors.grey : color,
          decoration: isExpense && isPaid
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            _showTransactionDialog(transaction: transaction);
          } else if (value == 'delete') {
            _confirmDeleteDialog(
              title: 'Excluir Transação?',
              content: 'Você tem certeza que deseja excluir "${transaction.name}"?',
              onDelete: () async {
                await DatabaseHelper().deleteTransaction(transaction.id!);
                _loadData();
              },
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'edit', child: Text('Editar')),
          const PopupMenuItem<String>(value: 'delete', child: Text('Excluir')),
        ],
      ),
    );
  }

  Widget _buildTotalsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTotalRow('Total de Entradas:', _totalIncome, Colors.green),
            const SizedBox(height: 8),
            _buildTotalRow('Total de Despesas:', _totalExpense, Colors.red),
            const Divider(height: 24),
            _buildTotalRow(
              'Saldo:',
              _balance,
              _balance >= 0 ? Colors.green : Colors.red,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double value, Color color,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(currencyFormatter.format(value),
            style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildCreditCardSummary() {
    if (_cards.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildTotalRow('Total Faturas:', _totalCardBills, Colors.redAccent),
            const SizedBox(height: 4),
            _buildTotalRow('Total Limites:', _totalCardLimits, Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardTile(CreditCard card) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(card.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent)),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showCardDialog(card: card);
                    } else if (value == 'delete') {
                      _confirmDeleteDialog(
                        title: 'Excluir Cartão?',
                        content: 'Você tem certeza que deseja excluir o cartão "${card.name}"?',
                        onDelete: () async {
                          await DatabaseHelper().deleteCard(card.id!);
                          _loadData();
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(value: 'edit', child: Text('Editar')),
                    const PopupMenuItem<String>(value: 'delete', child: Text('Excluir')),
                  ],
                ),
              ],
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _buildCardInfoRow('Vencimento:', 'dia ${card.dueDate}'),
            _buildCardInfoRow('Melhor dia de compra:', 'dia ${card.bestPurchaseDate}'),
            _buildCardInfoRow('Fatura Atual:', currencyFormatter.format(card.currentBill),
                valueColor: Colors.redAccent),
            _buildCardInfoRow('Limite:', currencyFormatter.format(card.creditLimit)),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildFuturePurchasesSummary() {
    if (_futurePurchases.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildTotalRow('Total Previsto:', _totalFuturePurchases, Colors.orangeAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedFuturePurchases() {
    if (_futurePurchases.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Nenhuma compra futura cadastrada.')));
    }

    final Map<String, List<FuturePurchase>> grouped = {};
    for (final purchase in _futurePurchases) {
      (grouped[purchase.category] ??= []).add(purchase);
    }

    final sortedCategories = grouped.keys.toList()..sort();

    return Column(
      children: sortedCategories.map((category) {
        final purchasesInCategory = grouped[category]!;
        final categoryTotal =
            purchasesInCategory.fold(0.0, (sum, item) => sum + item.value);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(category,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 16),
                Text(
                  currencyFormatter.format(categoryTotal),
                  style: const TextStyle(
                      color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            children: purchasesInCategory
                .map((p) => _buildFuturePurchaseTile(p))
                .toList(),
          ),
        );
      }).toList(),
    );
  }
  
  ListTile _buildFuturePurchaseTile(FuturePurchase purchase) {
    return ListTile(
      leading: const Icon(Icons.shopping_bag_outlined, color: Colors.orangeAccent),
      title: Text(purchase.name),
      subtitle: Text(
        '${DateFormat('dd/MM').format(purchase.date)} - ${currencyFormatter.format(purchase.value)}',
        style: const TextStyle(color: Colors.orangeAccent),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            _showFuturePurchaseDialog(purchase: purchase);
          } else if (value == 'delete') {
            _confirmDeleteDialog(
              title: 'Excluir Compra Futura?',
              content: 'Você tem certeza que deseja excluir "${purchase.name}"?',
              onDelete: () async {
                await DatabaseHelper().deleteFuturePurchase(purchase.id!);
                _loadData();
              },
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'edit', child: Text('Editar')),
          const PopupMenuItem<String>(value: 'delete', child: Text('Excluir')),
        ],
      ),
    );
  }
  
  Widget _buildInvestmentsSummary() {
    if (_investments.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildTotalRow('Total Investido:', _totalInvestments, Colors.purpleAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedInvestments() {
    if (_investments.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Nenhum investimento cadastrado.')));
    }

    final Map<String, List<Investment>> grouped = {};
    for (final investment in _investments) {
      (grouped[investment.category] ??= []).add(investment);
    }

    final sortedCategories = grouped.keys.toList()..sort();

    return Column(
      children: sortedCategories.map((category) {
        final investmentsInCategory = grouped[category]!;
        final categoryTotal =
            investmentsInCategory.fold(0.0, (sum, item) => sum + item.value);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(category,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 16),
                Text(
                  currencyFormatter.format(categoryTotal),
                  style: const TextStyle(
                      color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            children: investmentsInCategory
                .map((i) => _buildInvestmentTile(i))
                .toList(),
          ),
        );
      }).toList(),
    );
  }

  ListTile _buildInvestmentTile(Investment investment) {
    return ListTile(
      leading: const Icon(Icons.show_chart, color: Colors.purpleAccent),
      title: Text(investment.name),
      subtitle: Text(
        '${DateFormat('dd/MM').format(investment.date)} - ${currencyFormatter.format(investment.value)}',
        style: const TextStyle(color: Colors.purpleAccent),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            _showInvestmentDialog(investment: investment);
          } else if (value == 'delete') {
            _confirmDeleteDialog(
              title: 'Excluir Investimento?',
              content: 'Você tem certeza que deseja excluir "${investment.name}"?',
              onDelete: () async {
                await DatabaseHelper().deleteInvestment(investment.id!);
                _loadData();
              },
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'edit', child: Text('Editar')),
          const PopupMenuItem<String>(value: 'delete', child: Text('Excluir')),
        ],
      ),
    );
  }

  Widget _buildDebtsSummary() {
    if (_debts.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildTotalRow('Total em Dívidas:', _totalDebts, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedDebts() {
    if (_debts.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Nenhuma dívida cadastrada.')));
    }

    final Map<String, List<Debt>> grouped = {};
    for (final debt in _debts) {
      (grouped[debt.category] ??= []).add(debt);
    }

    final sortedCategories = grouped.keys.toList()..sort();

    return Column(
      children: sortedCategories.map((category) {
        final debtsInCategory = grouped[category]!;
        final categoryTotal =
            debtsInCategory.fold(0.0, (sum, item) => sum + item.value);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(category,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 16),
                Text(
                  currencyFormatter.format(categoryTotal),
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            children: debtsInCategory
                .map((d) => _buildDebtTile(d))
                .toList(),
          ),
        );
      }).toList(),
    );
  }

  ListTile _buildDebtTile(Debt debt) {
    return ListTile(
      leading: const Icon(Icons.money_off, color: Colors.red),
      title: Text(debt.name),
      subtitle: Text(
        '${DateFormat('dd/MM').format(debt.date)} - ${currencyFormatter.format(debt.value)}',
        style: const TextStyle(color: Colors.red),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            _showDebtDialog(debt: debt);
          } else if (value == 'delete') {
            _confirmDeleteDialog(
              title: 'Excluir Dívida?',
              content: 'Você tem certeza que deseja excluir "${debt.name}"?',
              onDelete: () async {
                await DatabaseHelper().deleteDebt(debt.id!);
                _loadData();
              },
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'edit', child: Text('Editar')),
          const PopupMenuItem<String>(value: 'delete', child: Text('Excluir')),
        ],
      ),
    );
  }
}

