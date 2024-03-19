//
//  FileImporter.swift
//  Shift_work
//
//  Created by Harsh Joshi on 2024-03-19.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import ExcelDataReaderSwift

struct FileImporter: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var shifts: [Shift]

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.spreadsheet])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: FileImporter

        init(parent: FileImporter) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedFileURL = urls.first else { return }
            parent.shifts = parseExcelFile(at: selectedFileURL)
            parent.isPresented = false
        }
    }
}

private func parseExcelFile(at url: URL) -> [Shift] {
    do {
        // Load the Excel file
        let excelData = try ExcelData(contentsOf: url)

        // Assuming the data is in the first worksheet
        guard let worksheet = excelData.worksheets.first else {
            print("Error: Excel file is empty or does not contain any worksheets")
            return []
        }

        // Initialize a DateFormatter for parsing date strings
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // Adjust the date format as needed
        print("dateformatter")
        
        // Iterate over rows and extract shift information
        var shifts: [Shift] = []
        for row in worksheet.rows {
            // Ensure there are at least two columns
            guard row.count >= 2,
                  let dateString = row[0].string,
                  let date = dateFormatter.date(from: dateString),
                  let shiftType = row[1].string else {
                // Skip rows with missing or invalid data
                continue
            }
            let shift = Shift(date: date, type: shiftType)
            shifts.append(shift)
        }

        return shifts
    } catch {
        print("Error parsing Excel file: \(error)")
        return []
    }
}
