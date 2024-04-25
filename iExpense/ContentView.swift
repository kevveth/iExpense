//
//  ContentView.swift
//  iExpense
//
//  Created by Kenneth Oliver Rathbun on 3/27/24.
//

import SwiftUI

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Decimal
    let currency: String
    
    var isPersonal: Bool {
        type == "Personal"
    }
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items.filter { $0.isPersonal }) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: item.currency))
                                .foregroundStyle(
                                    item.amount < 10 ? .green :
                                        item.amount < 100 ? .orange : .red
                                )
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section("Business") {
                    ForEach(expenses.items.filter { !$0.isPersonal }) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: item.currency))
                                .foregroundStyle(
                                    item.amount < 10 ? .green :
                                        item.amount < 100 ? .orange : .red
                                )
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink("Add expense") {
                    AddView(expenses: expenses)
                }
            }
//            .sheet(isPresented: $showingAddExpense) {
//                AddView(expenses: expenses)
//            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        //        expenses.items.remove(atOffsets: offsets)
        for offset in offsets {
            let item = expenses.items[offset]
            
//             Determine if the item to be removed is Personal or Business
            if item.isPersonal {
                // Remove from personal expenses
                expenses.items.removeAll(where: { $0.id == item.id })
            } else {
                // Remove from business expenses
                expenses.items.removeAll(where: { $0.id == item.id })
            }
        }
    }
}

enum ExpenseSection {
    case personal, business
}

#Preview {
    ContentView()
}
