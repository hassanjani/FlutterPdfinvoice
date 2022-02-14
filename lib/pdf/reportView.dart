import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:webtest/pdf/save_file_web.dart';

class CreatePdf extends StatefulWidget {
  const CreatePdf({Key? key}) : super(key: key);

  @override
  _CreatePdfState createState() => _CreatePdfState();
}

class _CreatePdfState extends State<CreatePdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  create();
                },
                child: Text(
                  "Generate Simple pdf",
                  style: TextStyle(fontSize: 22),
                )),
            SizedBox(
              height: 30,
            ),
            OutlinedButton(
                onPressed: () {
                  _generatePDF();
                },
                child: Text(
                  "Generate Invoice",
                  style: TextStyle(fontSize: 22),
                ))
          ],
        ),
      ),
    );
  }

  create() async {
    const String paragraphText =
        'Hello Flutter is awesome\'s Portable Document Format (PDF) is the de facto'
        'standard for the accurate, reliable, and platform-independent representation of a paged'
        'document. It\'s the only universally accepted file format that allows pixel-perfect layouts.'
        'In addition, PDF supports user interaction and collaborative workflows that are not'
        'possible with printed documents.  hassan.uswat@gmail.com';

// Create a new PDF document.
    final PdfDocument document = PdfDocument();
// Add a new page to the document.
    final PdfPage page = document.pages.add();
// Create a new PDF text element class and draw the flow layout text.
    final PdfLayoutResult layoutResult = PdfTextElement(
            text: paragraphText,
            font: PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
// Draw the next paragraph/content.
    page.graphics.drawLine(
        PdfPen(PdfColor(255, 0, 0)),
        Offset(0, layoutResult.bounds.bottom + 10),
        Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));

//     Directory appDocDirectory = await getApplicationDocumentsDirectory();
//
//     new Directory(appDocDirectory.path + '/' + 'dir').create(recursive: true)
// // The created directory is returned as a Future.
//         .then((Directory directory) async {
//       print('Path of New Dir: ' + directory.path);
//       // final output = await getTemporaryDirectory();
//       final file = File("${directory.path}/example.pdf");
//       await file.writeAsBytes(await document.save());
//     });
    if (kIsWeb) {
      final List<int> bytes = document.save();
      document.dispose();
      await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice1.pdf');
    }
    //Launch file.

// Save the document.
    //File('TextFlow.pdf').writeAsBytes(document.save());
// Dispose the document.
    document.dispose();
  }

  Future<void> _generatePDF() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    //Generate PDF grid.
    final PdfGrid grid = _getGrid();
    final PdfGrid grid1 = _getGrid1();
    //Draw the header section by creating text element
    final PdfLayoutResult result = await _drawHeader(page, pageSize, grid);
    grid1.draw(page: page, bounds: Rect.fromLTWH(0, 200 + 30, 0, 0))!;

    //Draw grid
    _drawGrid(page, grid, result);
    // _drawGrid(page, grid, result);
    //Add invoice footer
    _drawFooter(page, pageSize);
    //Save and dispose the document.
    final List<int> bytes = document.save();
    document.dispose();
    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice.pdf');
  }

  //Draws the invoice header
  Future<PdfLayoutResult> _drawHeader(
      PdfPage page, Size pageSize, PdfGrid grid) async {
    //Draw rectangle
    // page.graphics.drawRectangle(
    //     brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
    //     bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //logo
//Load the image using PdfBitmap.
    AssetImage assetImage = AssetImage('assets/logo.png');
    final ByteData bytes = await rootBundle.load('assets/logo.png');
    final Uint8List list = bytes.buffer.asUint8List();

    final PdfBitmap image = PdfBitmap(list);

    page.graphics.drawImage(image, Rect.fromLTWH(25, 0, 90, 90));

    //Draw string
    // page.graphics.drawString(
    //     'Intouch Invoice', PdfStandardFont(PdfFontFamily.helvetica, 30),
    //     brush: PdfBrushes.white,
    //     bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
    //     format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, 100),
      pen: PdfPen(PdfColor(255, 0, 0)),
      // brush: PdfSolidBrush(PdfColor(65, 104, 205))
    );
    page.graphics.drawString(
        "Payment Reciept", PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: Rect.fromLTWH(300, 0, 200, 100),
        brush: PdfBrushes.blue,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawString(
        "Smart & simple", PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: Rect.fromLTWH(120, 53, 200, 20),
        brush: PdfBrushes.black,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle));
    page.graphics.drawString(
        "TENECALL LTD", PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(120, 20, 200, 30),
        brush: PdfBrushes.black,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle));
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    // page.graphics.drawString('Amount', contentFont,
    //     brush: PdfBrushes.white,
    //     bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
    //     format: PdfStringFormat(
    //         alignment: PdfTextAlignment.center,
    //         lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber = 'Invoice Number: 2058557939\r\n\r\nDate: ' +
        format.format(DateTime.now()) +
        '\r\n\r\nSerial: SALES21005/TECH2';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    const String address =
        'Paid To: \r\n\r\nFazal Basit, \r\n\r\nUnited States, California, San Mateo, \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136';
    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));
    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  //Draws the grid
  void _drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 80, 0, 0))!;
    //Draw grand total.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    page.graphics.drawString(_getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));
  }

  //Draw the invoice footer data.
  void _drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));
    const String footerContent =
        '800 Interchange Blvd.\r\n\r\nSuite 2501, Austin, TX 78721\r\n\r\nAny Questions? support@adventure-works.com';
    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  PdfGrid _getGrid1() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 3);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Payment Method';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Check no';
    headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[2].value = 'Role';
    headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;

    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = "Cash";
    row.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[1].value = "----";
    row.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    row.cells[2].value = "Sales + Tech Rep";
    row.cells[2].stringFormat.alignment = PdfTextAlignment.center;

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.gridTable1LightAccent1);
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create PDF grid and return
  PdfGrid _getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 6);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Item#';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Discription';
    headerRow.cells[2].value = 'Unit Price';
    headerRow.cells[3].value = 'Qty';
    headerRow.cells[4].value = 'Rewards';
    headerRow.cells[5].value = 'Line Total';
    _addProducts('1', 'AWC Logo Cap', 8.99, 2, 0, 17.98, grid);
    _addProducts('4', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 0, 149.97, grid);
    _addProducts('3', 'Mountain Bike Socks,M', 9.5, 2, 0, 19, grid);
    _addProducts('8', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 0, 199.96, grid);
    _addProducts('5', 'ML Fork', 175.49, 6, 0, 1052.94, grid);
    _addProducts('6', 'Sports-100 Helmet,Black', 34.99, 1, 0, 34.99, grid);
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.gridTable1LightAccent1);
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void _addProducts(String productId, String productName, double price,
      int quantity, double rewards, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = rewards.toString();
    row.cells[5].value = total.toString();
  }

  //Get the total amount.
  double _getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
          grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }
}
