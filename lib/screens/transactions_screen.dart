import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock transaction data
    final transactions = [
      {
        'id': 'TXN001',
        'amount': 4500,
        'date': '2025-04-15',
        'status': 'Completed',
      },
      {
        'id': 'TXN002',
        'amount': 6000,
        'date': '2025-04-10',
        'status': 'Pending',
      },
      {
        'id': 'TXN003',
        'amount': 7000,
        'date': '2025-04-05',
        'status': 'Completed',
      },
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Transaction Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Spent: ₹18,500',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement view all
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'View All',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction['id']! as String,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '₹${transaction['amount']}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Date: ${transaction['date']}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            'Status: ${transaction['status']}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color:
                                  transaction['status'] == 'Completed'
                                      ? Colors.green
                                      : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: Offset(0.95, 0.95));
              },
            ),
          ],
        ),
      ),
    );
  }
}
