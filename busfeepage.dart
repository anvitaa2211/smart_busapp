import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_widget/barcode_widget.dart'; // Already added

class BusFeePage extends StatelessWidget {
  const BusFeePage({super.key});

  final Color primaryDark = const Color(0xFF1A237E);
  final Color accentBlue = const Color(0xFF3949AB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: Text("Bus Fees 2025-26",
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Total Balance Summary
          Container(
            width: double.infinity,
            color: primaryDark,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                Text("REMAINING BALANCE",
                    style: GoogleFonts.inter(
                        color: Colors.white70,
                        letterSpacing: 1.2,
                        fontSize: 12)),
                const SizedBox(height: 10),
                Text("₹ 4,500.00",
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionLabel("Payment History"),
                _paymentTile(context, "Quarter 1", "Paid", "12 Apr 2025", true,
                    "TXN98210"),
                _paymentTile(context, "Quarter 2", "Paid", "05 Jul 2025", true,
                    "TXN10234"),
                _paymentTile(
                    context, "Quarter 3", "Pending", "Due 10 Oct", false, ""),
                const SizedBox(height: 20),
                _sectionLabel("Fee Structure"),
                _simpleReceiptCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(text,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryDark)),
    );
  }

  Widget _paymentTile(BuildContext context, String title, String status,
      String date, bool isPaid, String txnId) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor:
          isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
          child: Icon(
            isPaid ? Icons.check_circle : Icons.pending_actions,
            color: isPaid ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        subtitle: Text(date, style: const TextStyle(fontSize: 12)),
        trailing: isPaid
            ? OutlinedButton.icon(
          onPressed: () => _showReceiptModal(context, title, txnId, date),
          icon: const Icon(Icons.receipt_long, size: 16),
          label: const Text("VIEW"),
          style: OutlinedButton.styleFrom(foregroundColor: accentBlue),
        )
            : ElevatedButton(
          onPressed: () => _showPaymentQR(context, title),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text("PAY NOW"),
        ),
      ),
    );
  }

  // --- Show Payment QR Modal ---
  void _showPaymentQR(BuildContext context, String quarter) {
    String paymentLink =
        "https://yourpaymentgateway.com/pay?quarter=$quarter&amount=4500"; // Example link

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:
      const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text("Scan to Pay",
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: paymentLink,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text("Amount: ₹ 4,500",
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark, foregroundColor: Colors.white),
                child: const Text("CLOSE"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showReceiptModal(
      BuildContext context, String quarter, String txnId, String date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:
      const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            Text("Payment Successful",
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(height: 40),
            _row("Quarter", quarter),
            _row("Transaction ID", txnId),
            _row("Date", date),
            _row("Amount", "₹ 4,000", isBold: true),
            const Spacer(),
            BarcodeWidget(
              barcode: Barcode.code128(),
              data: txnId,
              width: 200,
              height: 80,
              drawText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark, foregroundColor: Colors.white),
                child: const Text("CLOSE"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _simpleReceiptCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _row("Annual Fee", "₹ 15,000"),
          _row("Maintenance", "₹ 1,500"),
          const Divider(),
          _row("Total Paid", "₹ 12,000", isBold: true, color: Colors.green),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: GoogleFonts.inter(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? primaryDark,
              )),
        ],
      ),
    );
  }
}
