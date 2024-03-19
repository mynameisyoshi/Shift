//
//  ContentView.swift
//  Shift_work
//
//  Created by Harsh Joshi on 2024-03-19.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct Shift {
    let date: Date
    let type: String
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedDate = Date()
    @State private var shifts: [Shift] = []
    @State private var isImporting: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Select Your Shift")
                    .font(.title)
                    .padding()

                // Display shift options based on selected date
                ForEach(shifts.filter { $0.date == selectedDate }, id: \.self) { shift in
                    NavigationLink(destination: ShiftScreen(shift: shift.type)) {
                        Text(shift.type)
                    }.padding()
                }

                // Button to import Excel file
                Button("Import Excel File") {
                    isImporting = true
                }.padding()
            }
            .navigationTitle("Shift Selection")
            .sheet(isPresented: $isImporting) {
                FileImporter(isPresented: $isImporting, shifts: $shifts)
            }
        }
        .onAppear {
            // Load default shifts or perform any other initialization
            shifts = getDefaultShifts()
        }
    }

    // Example function to load default shifts
    private func getDefaultShifts() -> [Shift] {
        // Provide default shifts here
        // For example, you can return an array of Shift objects
        return []
    }
}

struct ShiftScreen: View {
    let shift: String
    var body: some View {
        VStack {
            Text("Today's Shift: \(shift)")
                .font(.title)
                .padding()

            // Customize appearance based on the shift
            if shift == "Off" {
                Text("Off")
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Color.black)
            } else if shift == "Morning" {
                Text("Morning")
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Color.blue)
            } else if shift == "Day" {
                Text("Day")
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Color.yellow)
            } else if shift == "Evening" {
                Text("Evening")
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Color.orange)
            }
        }
        .navigationTitle("Shift Details")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
