//
//  AddView.swift
//  iExpense
//
//  Created by Kenneth Oliver Rathbun on 3/29/24.
//

import SwiftUI

struct AddView: View {
    @State private var name: String = "New Expense"
    @State private var type: String = "Personal"
    @State private var amount: Decimal = 0.0
    @State private var currency: String = "USD"
    
    let types = ["Business", "Personal"]
    
    var expenses: Expenses
    
    @Environment(\.dismiss) var dismiss
    
    let currencyCodes = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD"]
    
    var body: some View {
        NavigationStack {
            Form {
//                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                Text(amount, format: .currency(code: currency))
                HStack {
                    TextField("Amount", value: $amount, format: .number.precision(.fractionLength(2)))
                        .keyboardType(.decimalPad)
                    Picker("", selection: $currency) {
                        ForEach(currencyCodes, id: \.self) { code in
                            Text("\(code)")
                        }
                        
                    }
                }
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = ExpenseItem(name: name, type: type, amount: amount, currency: currency)
                        expenses.items.append(item)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
