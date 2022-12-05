//
//  ContentView.swift
//  CountDownBuddy
//
//  Created by Daniel Bonates on 02/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var targetDates = [Date]()
    @State var selectedTargetDates = Set<Date>()
    @State var selectedDate: Date = Date()
    
    var appDelegate: AppDelegate
    
    var body: some View {
        VStack {
            if targetDates.isEmpty {
                Text("Please add your first target date below.")
                    .frame(maxHeight: .infinity)
            } else {
                List(selection: $selectedTargetDates) {
                    ForEach(targetDates, id: \.self) { targetDate in
                        Text(targetDate.beautified)
                    }
                    .onMove(perform: moveItems)
                }
                .onDeleteCommand(perform: deleteItems)
            }
            

            VStack(alignment: .leading) {
                Text("\(selectedDate)")
                    HStack {
                        
                        
                        DatePicker(LocalizedStringKey("Time"),
                                   selection: $selectedDate,
                                   displayedComponents: [.hourAndMinute, .date])
                        
                        Button("Add") {
                            if targetDates.contains(selectedDate) == false {
                                withAnimation {
                                    targetDates.append(selectedDate)
                                }
                                save()
                            }
                        }
                    }
                    
                    
            }
            
            .padding()
            
        }
        .padding()
        .onAppear(perform: load)
    }
    
    
    func load() {
        targetDates = UserDefaults.standard.object(forKey: "targetDates") as? [Date] ?? []
    }

    func save() {
        self.appDelegate.selectedDate = selectedDate
        UserDefaults.standard.set(targetDates, forKey: "targetDates")
    }
    
    func deleteItems() {
        withAnimation {
            targetDates.removeAll(where: selectedTargetDates.contains)
        }

        save()
    }
    
    func moveItems(from source: IndexSet, to destination: Int) {
        targetDates.move(fromOffsets: source, toOffset: destination)
        save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedDate: Date(), appDelegate: AppDelegate())
    }
}
